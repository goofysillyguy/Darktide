local mod = get_mod("LoadoutMoveButtons")

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ProfileUtils = require("scripts/utilities/profile_utils")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")

local Guard = {}

function Guard.report_error(context, error_message)
	local message = string.format("%s: %s", tostring(context or "guarded call"), tostring(error_message))

	if mod._loadout_move_buttons_last_guarded_error == message then
		return
	end

	mod._loadout_move_buttons_last_guarded_error = message

	if mod.warning then
		mod:warning("%s", "[LoadoutMoveButtons] " .. message)
	end
end

function Guard.safe_call(context, func, ...)
	if type(func) ~= "function" then
		return false, nil
	end

	local ok, result = pcall(func, ...)

	if not ok then
		Guard.report_error(context, result)

		return false, nil
	end

	return true, result
end

function Guard.safe_method(context, object, method_name, ...)
	local ok, method = pcall(function ()
		return object and object[method_name]
	end)

	if not ok then
		Guard.report_error(context, method)

		return false, nil
	end

	if type(method) ~= "function" then
		return false, nil
	end

	return Guard.safe_call(context, method, object, ...)
end

function Guard.get(setting_id)
	local ok, value = Guard.safe_call("read setting " .. tostring(setting_id), mod.get, mod, setting_id)

	return ok and value or nil
end

function Guard.localize(key)
	local ok, value = Guard.safe_call("localize " .. tostring(key), mod.localize, mod, key)

	return ok and value or tostring(key or "")
end

local MOVE_LAYOUT = {
	left = -1,
	right = 1,
	row_width = 225,
	row_height = 44,
	button_width = 107,
	button_height = 40,
}
MOVE_LAYOUT.button_gap = MOVE_LAYOUT.row_width - MOVE_LAYOUT.button_width * 2

local function move_buttons_enabled()
	return Guard.get("enable_move_buttons") ~= false
end

local function better_loadouts_mod()
	local ok, better_loadouts = pcall(get_mod, "BetterLoadouts")

	return ok and better_loadouts or nil
end

local function better_loadouts_loaded()
	return better_loadouts_mod() ~= nil
end

local function better_loadouts_layout(better_loadouts)
	local namespace = better_loadouts and better_loadouts.BL

	if not namespace then
		return nil
	end

	if namespace.layout then
		local ok, layout = pcall(namespace.layout)

		if ok then
			return layout
		end
	end

	if namespace.layout_for_limit then
		local ok, layout = pcall(namespace.layout_for_limit, better_loadouts.preset_limit or 28)

		if ok then
			return layout
		end
	end
end

local function better_loadouts_is_wide(better_loadouts)
	if not better_loadouts then
		return false
	end

	if better_loadouts._bl_is_wide_preset_layout ~= nil then
		return better_loadouts._bl_is_wide_preset_layout == true
	end

	local columns = better_loadouts._bl_profile_preset_num_cols or 0
	local rows = better_loadouts._bl_profile_preset_num_rows or 0

	if columns == 0 and rows == 0 then
		local layout = better_loadouts_layout(better_loadouts) or {}

		columns = layout.MAX_COLUMNS or 0
		rows = layout.ROWS_PER_COL or 0
	end

	return columns > rows
end

local function use_vertical_move_labels()
	local better_loadouts = better_loadouts_mod()

	return better_loadouts ~= nil and not better_loadouts_is_wide(better_loadouts)
end

local function move_row_label_keys()
	if use_vertical_move_labels() then
		return "move_up", "move_down"
	end

	return "move_left", "move_right"
end

local function layout_contains_reorder_controls(layout)
	if type(layout) ~= "table" then
		return false
	end

	for i = 1, #layout do
		local element = layout[i]

		if element.loadout_organizer_move_direction or element.loadout_organizer_move_row then
			return true
		end
	end

	return false
end

local function layout_is_profile_preset_customize(layout)
	if type(layout) ~= "table" then
		return false
	end

	for i = 1, #layout do
		if layout[i].delete_button then
			return true
		end
	end

	return false
end

local function layout_spacing_width(layout)
	if type(layout) == "table" then
		for i = 1, #layout do
			local element = layout[i]
			local size = element and element.size

			if element.widget_type == "dynamic_spacing" and size and size[1] then
				return size[1]
			end
		end
	end

	return MOVE_LAYOUT.row_width
end

local function insert_reorder_controls_before_delete(layout)
	if type(layout) ~= "table" then
		return layout
	end

	local injected_layout = {}
	local inserted = false
	local spacing_width = layout_spacing_width(layout)

	for i = 1, #layout do
		local element = layout[i]

		if element.delete_button and not inserted then
			injected_layout[#injected_layout + 1] = {
				widget_type = "loadout_organizer_move_row",
				loadout_organizer_move_row = true,
			}
			injected_layout[#injected_layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					spacing_width,
					10,
				},
			}
			inserted = true
		end

		injected_layout[#injected_layout + 1] = element
	end

	return injected_layout
end

local function inject_reorder_controls(layout)
	if not move_buttons_enabled() or better_loadouts_loaded() then
		return layout
	end

	if not layout_is_profile_preset_customize(layout) or layout_contains_reorder_controls(layout) then
		return layout
	end

	return insert_reorder_controls_before_delete(layout)
end

local function move_row_button_change_function(hotspot_id)
	return function (content, style)
		ButtonPassTemplates.terminal_button_change_function(content, style, hotspot_id)
	end
end

local function move_row_background_change_function(hotspot_id)
	return function (content, style)
		ButtonPassTemplates.terminal_button_change_function(content, style, hotspot_id)
		ButtonPassTemplates.terminal_button_hover_change_function(content, style, hotspot_id)
	end
end

local function move_row_button_passes(hotspot_id, text_id, x, base_style_id)
	return {
		{
			content_id = hotspot_id,
			pass_type = "hotspot",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					x,
					0,
					0,
				},
				size = {
					MOVE_LAYOUT.button_width,
					MOVE_LAYOUT.button_height,
				},
			},
			content = {
				on_pressed_sound = nil,
				on_released_sound = nil,
				on_hover_sound = UISoundEvents.default_mouse_hover,
			},
		},
		{
			pass_type = "texture",
			style_id = base_style_id .. "_background",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "left",
				scale_to_material = true,
				vertical_alignment = "center",
				default_color = Color.terminal_background_gradient(nil, true),
				hover_color = Color.terminal_frame_selected(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = Color.ui_grey_medium(140, true),
				offset = {
					x,
					0,
					2,
				},
				size = {
					MOVE_LAYOUT.button_width,
					MOVE_LAYOUT.button_height,
				},
			},
			change_function = move_row_background_change_function(hotspot_id),
		},
		{
			pass_type = "texture",
			style_id = base_style_id .. "_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "left",
				scale_to_material = true,
				vertical_alignment = "center",
				default_color = Color.terminal_frame(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = Color.ui_grey_medium(120, true),
				offset = {
					x,
					0,
					3,
				},
				size = {
					MOVE_LAYOUT.button_width,
					MOVE_LAYOUT.button_height,
				},
			},
			change_function = move_row_button_change_function(hotspot_id),
		},
		{
			pass_type = "texture",
			style_id = base_style_id .. "_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "left",
				scale_to_material = true,
				vertical_alignment = "center",
				default_color = Color.terminal_corner(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				disabled_color = Color.ui_grey_medium(120, true),
				offset = {
					x,
					0,
					4,
				},
				size = {
					MOVE_LAYOUT.button_width,
					MOVE_LAYOUT.button_height,
				},
			},
			change_function = move_row_button_change_function(hotspot_id),
		},
		{
			pass_type = "text",
			style_id = base_style_id .. "_text",
			value = "",
			value_id = text_id,
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				default_color = Color.terminal_text_header(255, true),
				hover_color = Color.white(255, true),
				selected_color = Color.white(255, true),
				disabled_color = Color.ui_grey_medium(160, true),
				offset = {
					x,
					0,
					5,
				},
				size = {
					MOVE_LAYOUT.button_width,
					MOVE_LAYOUT.button_height,
				},
			},
			change_function = move_row_button_change_function(hotspot_id),
		},
	}
end

mod:hook_require("scripts/ui/view_elements/view_element_profile_presets/view_element_profile_presets_definitions", function (definitions)
	local blueprints = definitions and definitions.profile_preset_grid_blueprints

	if not blueprints then
		return
	end

	local move_row_pass_template = {}
	local left_passes = move_row_button_passes("left_hotspot", "left_text", 0, "left")
	local right_passes = move_row_button_passes("right_hotspot", "right_text", MOVE_LAYOUT.button_width + MOVE_LAYOUT.button_gap, "right")

	for i = 1, #left_passes do
		move_row_pass_template[#move_row_pass_template + 1] = left_passes[i]
	end

	for i = 1, #right_passes do
		move_row_pass_template[#move_row_pass_template + 1] = right_passes[i]
	end

	blueprints.loadout_organizer_move_row = {
		size = {
			MOVE_LAYOUT.row_width,
			MOVE_LAYOUT.row_height,
		},
		pass_template = move_row_pass_template,
		init = function (parent, widget, element, callback_name)
			local content = widget and widget.content

			if not content then
				return
			end

			local left_label_key, right_label_key = move_row_label_keys()

			content.element = element
			content.left_text = Guard.localize(left_label_key)
			content.right_text = Guard.localize(right_label_key)

			if callback_name then
				if content.left_hotspot then
					content.left_hotspot.pressed_callback = callback(parent, callback_name, widget, {
						loadout_organizer_move_direction = MOVE_LAYOUT.left,
					})
				end

				if content.right_hotspot then
					content.right_hotspot.pressed_callback = callback(parent, callback_name, widget, {
						loadout_organizer_move_direction = MOVE_LAYOUT.right,
					})
				end
			end
		end,
	}
end)

local function set_reorder_button_states(view)
	local grid = view and view._profile_preset_tooltip_grid
	local _, widgets = Guard.safe_method("profile preset tooltip widgets", grid, "widgets")
	local enabled = move_buttons_enabled()

	if type(widgets) ~= "table" then
		return
	end

	local index = view._active_customize_preset_index
	local _, presets = Guard.safe_call("get profile presets for move buttons", ProfileUtils and ProfileUtils.get_profile_presets)
	local count = presets and #presets or 0

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget and widget.content
		local element = content and content.element
		local direction = element and element.loadout_organizer_move_direction

		if element and element.loadout_organizer_move_row then
			local left_label_key, right_label_key = move_row_label_keys()

			content.left_text = Guard.localize(left_label_key)
			content.right_text = Guard.localize(right_label_key)

			if content.left_hotspot then
				content.left_hotspot.disabled = not enabled or not index or index <= 1
			end

			if content.right_hotspot then
				content.right_hotspot.disabled = not enabled or not index or index >= count
			end
		elseif direction then
			local hotspot = content.hotspot

			if hotspot then
				hotspot.disabled = not enabled or not index or index + direction < 1 or index + direction > count
			end
		end
	end
end

function mod.move_active_preset(view, direction)
	if not move_buttons_enabled() then
		return
	end

	local index = view and view._active_customize_preset_index
	local _, presets = Guard.safe_call("get profile presets for moving", ProfileUtils and ProfileUtils.get_profile_presets)
	local new_index = index and index + direction

	if not presets or not index or not new_index or not presets[index] or new_index < 1 or new_index > #presets then
		return
	end

	presets[index], presets[new_index] = presets[new_index], presets[index]

	Guard.safe_method("save moved profile preset order", Managers and Managers.save, "queue_save")

	view._active_customize_preset_index = nil
	Guard.safe_method("rebuild profile preset buttons after move", view, "_setup_preset_buttons")
	Guard.safe_method("reopen moved profile preset customize menu", view, "on_profile_preset_index_customize", new_index)
	set_reorder_button_states(view)
end

local function grid_is_profile_preset_tooltip_grid(grid)
	local parent = grid and grid._parent

	return parent and parent._profile_preset_tooltip_grid == grid
end

local function should_inject_better_loadouts_reorder_controls(grid, layout, content_blueprints)
	return move_buttons_enabled()
		and better_loadouts_loaded()
		and grid_is_profile_preset_tooltip_grid(grid)
		and content_blueprints
		and content_blueprints.loadout_organizer_move_row ~= nil
		and layout_is_profile_preset_customize(layout)
		and not layout_contains_reorder_controls(layout)
end

mod:hook("ViewElementGrid", "present_grid_layout", function (func, self, layout, content_blueprints, ...)
	local adjusted_layout = layout

	if should_inject_better_loadouts_reorder_controls(self, layout, content_blueprints) then
		adjusted_layout = insert_reorder_controls_before_delete(layout)
	end

	return func(self, adjusted_layout, content_blueprints, ...)
end)

mod:hook("ViewElementProfilePresets", "_present_tooltip_grid_layout", function (func, self, layout, ...)
	local adjusted_layout = inject_reorder_controls(layout)

	return func(self, adjusted_layout, ...)
end)

mod:hook("ViewElementProfilePresets", "cb_on_profile_preset_icon_grid_left_pressed", function (func, self, widget, element, ...)
	local direction = element and element.loadout_organizer_move_direction

	if direction and move_buttons_enabled() then
		mod.move_active_preset(self, direction)

		return
	end

	return func(self, widget, element, ...)
end)

mod:hook("ViewElementProfilePresets", "on_profile_preset_index_customize", function (func, self, index, ...)
	local result = func(self, index, ...)

	set_reorder_button_states(self)

	return result
end)

mod:hook_safe("ViewElementProfilePresets", "cb_on_profile_preset_icon_grid_layout_changed", function (self)
	set_reorder_button_states(self)
end)

mod:hook_safe("ViewElementProfilePresets", "update", function (self)
	set_reorder_button_states(self)
end)
