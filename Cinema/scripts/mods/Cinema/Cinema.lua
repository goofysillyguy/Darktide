local mod = get_mod("Cinema")
local DMF = get_mod("DMF")
local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")
local item_package_ok, ItemPackage = pcall(require, "scripts/foundation/managers/package/utilities/item_package")
local master_items_ok, MasterItems = pcall(require, "scripts/backend/master_items")
local theme_package_ok, ThemePackage = pcall(require, "scripts/foundation/managers/package/utilities/theme_package")
local video_settings_ok, VideoViewSettings = pcall(require, "scripts/ui/views/video_view/video_view_settings")

if not item_package_ok then
	ItemPackage = nil
end

if not master_items_ok then
	MasterItems = nil
end

if not theme_package_ok then
	ThemePackage = nil
end

if not video_settings_ok then
	VideoViewSettings = nil
end

local LINE_PREFIX = "[Cinema]"
local LOG_DIRECTORY_PRIMARY = "F:/Source/dt"
local LOG_DIRECTORY_FALLBACK = "./../mods/Cinema"
local LOG_FILE_NAME = "Cinema.log"
local PLAY_MODE_SETTING_ID = "play_mode"
local SELECTED_CUTSCENE_SETTING_ID = "selected_cutscene"
local ECHO_SETTING_ID = "echo_to_chat"

local CUTSCENES = {
	{ name = "cutscene_1", label = "Cutscene 1" },
	{ name = "cutscene_2", label = "Cutscene 2" },
	{ name = "cutscene_3", label = "Cutscene 3" },
	{ name = "cutscene_4", label = "Cutscene 4" },
	{ name = "cutscene_5", label = "Cutscene 5" },
	{ name = "cutscene_5_hub", label = "Cutscene 5 Hub" },
	{ name = "cutscene_6", label = "Cutscene 6" },
	{ name = "cutscene_7", label = "Cutscene 7" },
	{ name = "cutscene_8", label = "Cutscene 8" },
	{ name = "cutscene_9", label = "Cutscene 9" },
	{ name = "cutscene_10", label = "Cutscene 10" },
	{ name = "intro_abc", label = "Intro ABC" },
	{ name = "outro_win", label = "Outro Win" },
	{ name = "outro_fail", label = "Outro Fail" },
	{ name = "hub_location_intro_barber", label = "Hub Intro: Barber" },
	{ name = "hub_location_intro_contracts", label = "Hub Intro: Contracts" },
	{ name = "hub_location_intro_crafting", label = "Hub Intro: Crafting" },
	{ name = "hub_location_intro_gun_shop", label = "Hub Intro: Gun Shop" },
	{ name = "hub_location_intro_mission_board", label = "Hub Intro: Mission Board" },
	{ name = "hub_location_intro_training_grounds", label = "Hub Intro: Training Grounds" },
	{ name = "path_of_trust_01", label = "Path of Trust 01" },
	{ name = "path_of_trust_02", label = "Path of Trust 02" },
	{ name = "path_of_trust_03", label = "Path of Trust 03" },
	{ name = "path_of_trust_04", label = "Path of Trust 04" },
	{ name = "path_of_trust_05", label = "Path of Trust 05" },
	{ name = "path_of_trust_06", label = "Path of Trust 06" },
	{ name = "path_of_trust_07", label = "Path of Trust 07" },
	{ name = "path_of_trust_08", label = "Path of Trust 08" },
	{ name = "path_of_trust_09", label = "Path of Trust 09" },
	{ name = "traitor_captain_intro", label = "Traitor Captain Intro" },
}

local GLOBAL_CINEMATICS = {
	intro_abc = { "c_cam" },
	outro_win = { "outro_win" },
	outro_fail = { "outro_fail" },
	cutscene_1 = { "cs_intro" },
	cutscene_2 = { "cs_02_part_1", "cs_02_part_2", "cs_02_part_3" },
	cutscene_3 = { "cs_03" },
	cutscene_4 = { "cs_04" },
	cutscene_5 = { "cs_05", "cs_05_exterior" },
	cutscene_5_hub = { "cs_05_hub" },
	cutscene_6 = { "cs_06" },
	cutscene_7 = { "cs_07" },
	cutscene_8 = { "cs_08" },
	cutscene_9 = { "cs_09" },
	cutscene_10 = { "cs_10" },
	path_of_trust_01 = { "path_of_trust_01_part_01", "path_of_trust_01_corridor_01", "path_of_trust_01_part_02" },
	path_of_trust_02 = { "path_of_trust_02_part_01", "path_of_trust_02_barracks", "path_of_trust_02_part_02" },
	path_of_trust_03 = { "path_of_trust_03_part_01", "path_of_trust_03_crafting_station", "path_of_trust_03_part_02" },
	path_of_trust_04 = { "path_of_trust_04_part_01", "path_of_trust_04_corridor_02", "path_of_trust_04_part_02" },
	path_of_trust_05 = { "path_of_trust_05_part_01", "path_of_trust_05_bar", "path_of_trust_05_part_02" },
	path_of_trust_06 = { "path_of_trust_06_hangar" },
	path_of_trust_07 = { "path_of_trust_07_part_01", "path_of_trust_07_barracks", "path_of_trust_07_part_02" },
	path_of_trust_08 = { "path_of_trust_08_part_01", "path_of_trust_08_corridor_01", "path_of_trust_08_part_02" },
	path_of_trust_09 = { "path_of_trust_09_office" },
	traitor_captain_intro = { "traitor_captain_intro" },
	hub_location_intro_barber = { "hub_location_intro_barber" },
	hub_location_intro_contracts = { "hub_location_intro_contracts" },
	hub_location_intro_crafting = { "hub_location_intro_crafting" },
	hub_location_intro_gun_shop = { "hub_location_intro_gun_shop" },
	hub_location_intro_mission_board = { "hub_location_intro_mission_board_part_01", "hub_location_intro_mission_board_part_02" },
	hub_location_intro_training_grounds = { "hub_location_intro_training_grounds" },
}

local FORCED_LEVELS = {
	intro_abc = { "content/levels/cinematics/c_cams/c_cam_generic/world" },
	outro_win = { "content/levels/cinematics/outro/win/outro_win_generic/world" },
	outro_fail = { "content/levels/cinematics/outro/fail/outro_fail_generic/world" },
	cutscene_1 = { "content/levels/prologue/cs_01_exterior/world" },
	cutscene_2 = { "content/levels/prologue/cellblock/world" },
	cutscene_3 = { "content/levels/prologue/cs_03_bay/world" },
	cutscene_4 = { "content/levels/prologue/cs_04_hangar/world" },
	cutscene_5 = {
		"content/levels/prologue/cs_05_hangar/world",
		"content/levels/prologue/cs_05_exterior/world",
	},
	cutscene_5_hub = { "content/levels/prologue/cs_05_hub/world" },
	cutscene_7 = { "content/levels/hub/hub_ship/cinematics/path_of_trust/pot_war_room/world" },
	cutscene_8 = { "content/levels/hub/hub_ship/cs_07_08_office/world" },
	cutscene_9 = { "content/levels/prologue/cs_09_hub/world" },
	path_of_trust_01 = {
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_war_room/world",
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_corridor_01/world",
	},
	path_of_trust_02 = {
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_war_room/world",
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_barracks/world",
	},
	path_of_trust_03 = {
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_war_room/world",
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_crafting_station/world",
	},
	path_of_trust_04 = {
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_war_room/world",
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_corridor_02/world",
	},
	path_of_trust_05 = {
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_war_room/world",
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_bar/world",
	},
	path_of_trust_06 = { "content/levels/hub/hub_ship/cinematics/path_of_trust/pot_hangar/world" },
	path_of_trust_07 = {
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_war_room/world",
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_barracks/world",
	},
	path_of_trust_08 = {
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_war_room/world",
		"content/levels/hub/hub_ship/cinematics/path_of_trust/pot_corridor_01/world",
	},
	path_of_trust_09 = { "content/levels/hub/hub_ship/cinematics/path_of_trust/pot_office/world" },
	hub_location_intro_barber = { "content/levels/hub/hub_ship/cinematics/hub_location_intros/hli_barber_vendor/world" },
	hub_location_intro_mission_board = { "content/levels/hub/hub_ship/cinematics/hub_location_intros/hli_mission_terminal/world" },
	hub_location_intro_training_grounds = { "content/levels/hub/hub_ship/cinematics/hub_location_intros/hli_training_grounds/world" },
	traitor_captain_intro = { "content/levels/cinematics/twins_boss_intro/world" },
}

local VIDEO_TEMPLATES = {
	cutscene_6 = "cs06",
	hub_location_intro_barber = "hli_barbershop",
	hub_location_intro_contracts = "hli_contracts",
	hub_location_intro_crafting = "hli_crafting_station_underground",
	hub_location_intro_gun_shop = "hli_gun_shop",
	hub_location_intro_mission_board = "hli_mission_board",
}

local ORIGIN_ANCHOR_BLOCKED = {
	cutscene_1 = "hard_oob_crash",
}

local PROLOGUE_THEME_LEVEL = "content/levels/prologue/missions/prologue"
local HUB_THEME_LEVEL = "content/levels/hub/hub_ship/missions/hub_ship"
local ONBOARDING_HUB_THEME_LEVEL = "content/levels/hub/hub_ship/missions/mission_om_hub_01"
local PROLOGUE_DEFAULT_THEME_PACKAGE = "content/levels/prologue/missions/prologue_themes/default/prologue_theme_default"
local HUB_DEFAULT_THEME_PACKAGE = "content/levels/hub/hub_ship/missions/hub_ship_themes/default/theme_default_hub_ship"
local ONBOARDING_HUB_DEFAULT_THEME_PACKAGE = "content/levels/hub/hub_ship/missions/om_hub_01_themes/default/theme_default_om_hub_01"

local CUTSCENE_THEME_LEVELS = {
	cutscene_1 = { PROLOGUE_THEME_LEVEL },
	cutscene_2 = { PROLOGUE_THEME_LEVEL },
	cutscene_3 = { PROLOGUE_THEME_LEVEL },
	cutscene_4 = { PROLOGUE_THEME_LEVEL },
	cutscene_5 = { PROLOGUE_THEME_LEVEL },
	cutscene_5_hub = { ONBOARDING_HUB_THEME_LEVEL },
	cutscene_7 = { ONBOARDING_HUB_THEME_LEVEL },
	cutscene_9 = { HUB_THEME_LEVEL },
	path_of_trust_01 = { HUB_THEME_LEVEL },
	path_of_trust_02 = { HUB_THEME_LEVEL },
	path_of_trust_03 = { HUB_THEME_LEVEL },
	path_of_trust_04 = { HUB_THEME_LEVEL },
	path_of_trust_05 = { HUB_THEME_LEVEL },
	path_of_trust_06 = { HUB_THEME_LEVEL },
	path_of_trust_07 = { HUB_THEME_LEVEL },
	path_of_trust_08 = { HUB_THEME_LEVEL },
	path_of_trust_09 = { HUB_THEME_LEVEL },
	traitor_captain_intro = { HUB_THEME_LEVEL },
	hub_location_intro_barber = { HUB_THEME_LEVEL },
	hub_location_intro_mission_board = { HUB_THEME_LEVEL },
	hub_location_intro_training_grounds = { HUB_THEME_LEVEL, ONBOARDING_HUB_THEME_LEVEL },
}

local EXTRA_PACKAGES = {
	cutscene_1 = {
		PROLOGUE_THEME_LEVEL,
		PROLOGUE_DEFAULT_THEME_PACKAGE,
	},
	cutscene_2 = {
		PROLOGUE_THEME_LEVEL,
		PROLOGUE_DEFAULT_THEME_PACKAGE,
	},
	cutscene_3 = {
		PROLOGUE_THEME_LEVEL,
		PROLOGUE_DEFAULT_THEME_PACKAGE,
	},
	cutscene_4 = {
		PROLOGUE_THEME_LEVEL,
		PROLOGUE_DEFAULT_THEME_PACKAGE,
	},
	cutscene_5 = {
		PROLOGUE_THEME_LEVEL,
		PROLOGUE_DEFAULT_THEME_PACKAGE,
	},
	cutscene_5_hub = {
		ONBOARDING_HUB_THEME_LEVEL,
		ONBOARDING_HUB_DEFAULT_THEME_PACKAGE,
	},
	cutscene_7 = {
		ONBOARDING_HUB_THEME_LEVEL,
		ONBOARDING_HUB_DEFAULT_THEME_PACKAGE,
	},
	cutscene_9 = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	path_of_trust_01 = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	path_of_trust_02 = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	path_of_trust_03 = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	path_of_trust_04 = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	path_of_trust_05 = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	path_of_trust_06 = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	path_of_trust_07 = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	path_of_trust_08 = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	path_of_trust_09 = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	traitor_captain_intro = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	hub_location_intro_barber = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	hub_location_intro_mission_board = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
	},
	hub_location_intro_training_grounds = {
		HUB_THEME_LEVEL,
		HUB_DEFAULT_THEME_PACKAGE,
		ONBOARDING_HUB_THEME_LEVEL,
		ONBOARDING_HUB_DEFAULT_THEME_PACKAGE,
	},
}

local CUTSCENE_BY_NAME = {}
local CUTSCENE_BY_BUTTON = {}
local pending_check = nil
local pending_auto_stop = nil
local network_lookup_id
local event_history = {}
local EVENT_HISTORY_LIMIT = 80
local direct_manual_register_cutscene = nil
local scan_queue = {}
local scan_active = nil
local scan_results = {}
local scan_sequence = 0
local scan_next_time = nil
local extra_package_loads = {}
local forced_play_options = {}
local SCAN_TIMEOUT_SECONDS = 25
local SETTING_TRIGGER_COOLDOWN_SECONDS = 5
local setting_trigger_times = {}
local EXTRA_STORY_CANDIDATES = {}
local file_initialized = false
local file_error_reported = false
local file_status_reported = false
local active_log_directory = nil
local active_log_path = nil
local flow_register_hooked = false
local stop_cutscene
local play_video_template

for index, cutscene in ipairs(CUTSCENES) do
	CUTSCENE_BY_NAME[cutscene.name] = cutscene
	CUTSCENE_BY_BUTTON[string.format("play_cutscene_%02d", index)] = cutscene.name
end

local function as_string(value)
	if value == nil then
		return "<nil>"
	end

	return tostring(value)
end

local function persistent_lua_module(name, lua_module)
	if not lua_module then
		return nil
	end

	if DMF and DMF.persistent_table and DMF.deepcopy then
		local persistent_success, persistent = pcall(DMF.persistent_table, DMF, name)

		if persistent_success and persistent then
			if not persistent.initialized then
				local copy_success, copied = pcall(DMF.deepcopy, lua_module)

				if copy_success and copied then
					for key, value in pairs(copied) do
						persistent[key] = value
					end

					persistent.initialized = true
				end
			end

			return persistent
		end
	end

	return lua_module
end

local lua_modules = Mods and Mods.lua
local _io = persistent_lua_module("Cinema_io", lua_modules and lua_modules.io) or io
local _os = persistent_lua_module("Cinema_os", lua_modules and lua_modules.os) or os

function mod:log_directory()
	return active_log_directory or LOG_DIRECTORY_PRIMARY
end

function mod:log_path()
	return active_log_path or self:log_directory() .. "/" .. LOG_FILE_NAME
end

local function to_windows_path(path)
	return tostring(path):gsub("/", "\\")
end

local function ensure_log_directory(path)
	if _os and _os.execute then
		pcall(_os.execute, 'mkdir "' .. to_windows_path(path) .. '" 2>nul')
	end
end

local function log_timestamp(format)
	if _os and _os.date then
		local ok, result = pcall(_os.date, format)

		if ok and result then
			return tostring(result)
		end
	end

	return "unknown-time"
end

local function open_log_file(mode)
	if not _io or not _io.open then
		return nil, nil, "Mods.lua.io.open is unavailable"
	end

	if active_log_path then
		local ok, file_or_error = pcall(_io.open, active_log_path, mode)

		if ok and file_or_error then
			return file_or_error, active_log_path
		end
	end

	local last_error
	local directories = {
		LOG_DIRECTORY_PRIMARY,
		LOG_DIRECTORY_FALLBACK,
	}

	for i = 1, #directories do
		local directory = directories[i]

		ensure_log_directory(directory)

		local path = directory .. "/" .. LOG_FILE_NAME
		local ok, file_or_error = pcall(_io.open, path, mode)

		if ok and file_or_error then
			active_log_directory = directory
			active_log_path = path

			return file_or_error, path
		end

		last_error = ok and file_or_error or "pcall failed"
	end

	return nil, nil, last_error
end

local function reset_log_file()
	file_initialized = false
	file_error_reported = false
	file_status_reported = false
end

local function append_file_line(line)
	if mod:get("write_to_file") == false then
		return
	end

	local ok, err = pcall(function()
		if not file_initialized then
			local mode = mod:get("clear_file_on_load") ~= false and "w" or "a"
			local file, path, open_error = open_log_file(mode)

			if not file then
				error(open_error or "unknown open error")
			end

			file:write(string.format("%s log started %s\n", LINE_PREFIX, log_timestamp("%Y-%m-%d %H:%M:%S")))
			file:write(string.format("Log path: %s\n", tostring(path)))
			file:close()
			file_initialized = true
		end

		local file, _, open_error = open_log_file("a")

		if not file then
			error(open_error or "unknown open error")
		end

		file:write(string.format("[%s] %s\n", log_timestamp("%H:%M:%S"), line))
		file:close()
	end)

	if not ok and not file_error_reported then
		file_error_reported = true
		mod:warning("%s", "Cinema file logging failed: " .. tostring(err))
	elseif ok and not file_status_reported then
		file_status_reported = true
		mod:info("%s", "Cinema file log: " .. tostring(mod:log_path()))
	end
end

local function write_line(message)
	local line = string.format("%s %s", LINE_PREFIX, message)

	if mod:get(ECHO_SETTING_ID) ~= false then
		mod:echo("%s", line)
	end

	mod:info("%s", line)
	append_file_line(line)
end

local function write_quiet_line(message)
	local line = string.format("%s %s", LINE_PREFIX, message)

	mod:info("%s", line)
	append_file_line(line)
end

local function record_event(message)
	event_history[#event_history + 1] = message

	while #event_history > EVENT_HISTORY_LIMIT do
		table.remove(event_history, 1)
	end

	write_quiet_line(message)
end

local function debug_queue_enabled()
	return mod:get("debug_queue_story") ~= false
end

local function cleanup_empty_active_enabled()
	return mod:get("cleanup_empty_active") ~= false
end

local function allow_unaligned_enabled()
	return mod:get("allow_unaligned_scene_playback") == true
end

local function origin_anchor_enabled()
	return mod:get("origin_anchor_scene_playback") == true
end

local function borrow_destination_enabled()
	return mod:get("borrow_destination_scene_playback") == true
end

local function origin_anchor_block_reason(cinematic_name)
	return ORIGIN_ANCHOR_BLOCKED[cinematic_name]
end

local function origin_anchor_allowed(cinematic_name)
	return origin_anchor_enabled() and origin_anchor_block_reason(cinematic_name) == nil
end

if mod:get("origin_anchor_scene_playback") == true then
	mod:set("origin_anchor_scene_playback", false)
	write_quiet_line("origin_anchor_scene_playback=false reason=safety_reset_after_oob_crash")
end

local function manual_register_enabled(cinematic_name)
	if mod:get("manual_register_stories") == true then
		return true
	end

	return cinematic_name ~= nil and direct_manual_register_cutscene == cinematic_name
end

local function safe_method(object, method_name, ...)
	if not object or type(object[method_name]) ~= "function" then
		return nil
	end

	local ok, result = pcall(object[method_name], object, ...)

	if ok then
		return result
	end

	return nil
end

local function cinematic_manager()
	return Managers and Managers.state and Managers.state.cinematic
end

local function cinematic_scene_system()
	local state = Managers and Managers.state
	local extension = state and state.extension

	if not extension or type(extension.has_system) ~= "function" or type(extension.system) ~= "function" then
		return nil
	end

	if safe_method(extension, "has_system", "cinematic_scene_system") then
		return safe_method(extension, "system", "cinematic_scene_system")
	end

	return nil
end

local function component_system()
	local state = Managers and Managers.state
	local extension = state and state.extension

	if not extension or type(extension.has_system) ~= "function" or type(extension.system) ~= "function" then
		return nil
	end

	if safe_method(extension, "has_system", "component_system") then
		return safe_method(extension, "system", "component_system")
	end

	return nil
end

local function current_time()
	local time_manager = Managers and Managers.time
	local t = time_manager and safe_method(time_manager, "time", "main")

	if type(t) == "number" then
		return t
	end

	return os.clock()
end

local function count_table(value)
	if type(value) ~= "table" then
		return 0
	end

	local count = 0

	for _ in pairs(value) do
		count = count + 1
	end

	return count
end

local function compact_list(value)
	if type(value) ~= "table" then
		return "<none>"
	end

	local parts = {}

	for i = 1, #value do
		parts[#parts + 1] = tostring(value[i])
	end

	if #parts == 0 then
		return "<empty>"
	end

	return table.concat(parts, ",")
end

local function compact_package_summary(value)
	if type(value) ~= "table" then
		return "count=0 packages=<none>"
	end

	local count = #value

	if count == 0 then
		return "count=0 packages=<empty>"
	end

	local limit = math.min(count, 8)
	local parts = {}

	for i = 1, limit do
		parts[#parts + 1] = tostring(value[i])
	end

	if count > limit then
		parts[#parts + 1] = string.format("...+%d", count - limit)
	end

	return string.format("count=%d packages=%s", count, table.concat(parts, ","))
end

local function copy_array(value)
	local copy = {}

	if type(value) == "table" then
		for i = 1, #value do
			copy[#copy + 1] = value[i]
		end
	end

	return copy
end

local function unique_array(value)
	local copy = {}
	local seen = {}

	if type(value) == "table" then
		for i = 1, #value do
			local item = value[i]

			if item and not seen[item] then
				seen[item] = true
				copy[#copy + 1] = item
			end
		end
	end

	return copy
end

local function level_name(level)
	if level == nil or type(Level) ~= "table" or type(Level.name) ~= "function" then
		return "<nil>"
	end

	local ok, result = pcall(Level.name, level)

	if ok then
		return tostring(result)
	end

	return "<unknown>"
end

local function unit_level(unit)
	if unit == nil or type(Unit) ~= "table" or type(Unit.level) ~= "function" then
		return nil
	end

	local ok, level = pcall(Unit.level, unit)

	if ok then
		return level
	end

	return nil
end

local function flow_callback_context_level_name()
	local application = rawget(_G, "Application")

	if application == nil or type(application.flow_callback_context_level) ~= "function" then
		return "<unavailable>"
	end

	local ok, level = pcall(application.flow_callback_context_level)

	if not ok then
		return "<unavailable>"
	end

	return level_name(level)
end

local function sorted_keys(value)
	local keys = {}

	if type(value) == "table" then
		for key in pairs(value) do
			keys[#keys + 1] = key
		end
	end

	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)

	return keys
end

local function compact_keys(value)
	local keys = sorted_keys(value)
	local parts = {}

	for i = 1, #keys do
		parts[#parts + 1] = tostring(keys[i])
	end

	if #parts == 0 then
		return "<empty>"
	end

	return table.concat(parts, ",")
end

local function command_line(first, ...)
	local parts = {}

	if first ~= nil then
		parts[#parts + 1] = tostring(first)
	end

	for i = 1, select("#", ...) do
		parts[#parts + 1] = tostring(select(i, ...))
	end

	return table.concat(parts, " ")
end

local function split_args(line)
	local args = {}

	for token in string.gmatch(line or "", "%S+") do
		args[#args + 1] = token
	end

	return args
end

local function selected_cutscene_name()
	local selected = mod:get(SELECTED_CUTSCENE_SETTING_ID)

	if CUTSCENE_BY_NAME[selected] then
		return selected
	end

	return CUTSCENES[1].name
end

local function auto_stop_seconds()
	local seconds = tonumber(mod:get("auto_stop_seconds")) or 0

	return math.max(0, seconds)
end

local function resolve_cutscene(value)
	if value == nil or value == "" or value == "selected" then
		return selected_cutscene_name()
	end

	local index = tonumber(value)

	if index and CUTSCENES[index] then
		return CUTSCENES[index].name
	end

	if CUTSCENE_BY_NAME[value] then
		return value
	end

	return nil
end

local function cutscene_configuration(system, cinematic_name)
	local cinematics = system and rawget(system, "_cinematics")
	local sub_cinematics = cinematics and cinematics[cinematic_name]
	local setups_by_name = system and rawget(system, "_cinematics_setups")
	local setups = setups_by_name and setups_by_name[cinematic_name]
	local valid = 0
	local invalid = 0

	if type(setups) == "table" then
		for _, setup in pairs(setups) do
			if type(setup) == "table" and setup.is_valid then
				valid = valid + 1
			else
				invalid = invalid + 1
			end
		end
	end

	return sub_cinematics, setups, valid, invalid
end

local function ensure_global_cinematic_config(system, cinematic_name)
	local categories = GLOBAL_CINEMATICS[cinematic_name]

	if type(system) ~= "table" or type(categories) ~= "table" then
		return false
	end

	local cinematics = rawget(system, "_cinematics")

	if type(cinematics) ~= "table" then
		return false
	end

	local existing = cinematics[cinematic_name]

	if type(existing) == "table" and #existing > 0 then
		return true
	end

	cinematics[cinematic_name] = copy_array(categories)
	record_event(string.format("config_injected cutscene=%s categories=%s",
		cinematic_name,
		compact_list(categories)
	))

	return true
end

local function story_count_for_category(category, manager)
	local cinematic = manager or cinematic_manager()
	local stories = type(cinematic) == "table" and rawget(cinematic, "_stories")
	local category_stories = type(stories) == "table" and stories[category]

	if type(category_stories) == "table" then
		return #category_stories
	end

	return 0
end

local function story_counts_for_cutscene(sub_cinematics)
	if type(sub_cinematics) ~= "table" then
		return "<none>"
	end

	local parts = {}

	for i = 1, #sub_cinematics do
		local category = sub_cinematics[i]

		parts[#parts + 1] = string.format("%s:%d", category, story_count_for_category(category))
	end

	if #parts == 0 then
		return "<empty>"
	end

	return table.concat(parts, ",")
end

local function registered_story_count_for_cutscene(cinematic_name)
	local system = cinematic_scene_system()
	local sub_cinematics = cutscene_configuration(system, cinematic_name)
	local count = 0

	if type(sub_cinematics) ~= "table" then
		return count
	end

	for i = 1, #sub_cinematics do
		count = count + story_count_for_category(sub_cinematics[i])
	end

	return count
end

local function loaded_level_names_for_cutscene(cinematic_name)
	local cinematic = cinematic_manager()
	local cinematic_levels = type(cinematic) == "table" and rawget(cinematic, "_cinematic_levels")
	local levels = type(cinematic_levels) == "table" and cinematic_levels[cinematic_name]

	if type(levels) ~= "table" or #levels == 0 then
		return "<none>"
	end

	local parts = {}

	for i = 1, #levels do
		parts[#parts + 1] = level_name(levels[i])
	end

	return table.concat(parts, ",")
end

local function world_origin_level_names_for_cutscene(cinematic_name)
	local components = component_system()
	local origin_level_names = {}

	if not components or type(components.get_units_from_component_name) ~= "function" or type(components.get_components) ~= "function" then
		return origin_level_names
	end

	local ok, scenes = pcall(components.get_units_from_component_name, components, "CinematicScene")

	if not ok or type(scenes) ~= "table" then
		return origin_level_names
	end

	for _, scene_unit in ipairs(scenes) do
		local scene_components = safe_method(components, "get_components", scene_unit, "CinematicScene")
		local scene_component = type(scene_components) == "table" and scene_components[1]

		if scene_component and safe_method(scene_component, "unit_type") == "destination" and safe_method(scene_component, "cinematic_name") == cinematic_name then
			local origin_level_name = safe_method(scene_component, "origin_level_name")

			if origin_level_name and origin_level_name ~= "" then
				origin_level_names[#origin_level_names + 1] = origin_level_name
			end
		end
	end

	return unique_array(origin_level_names)
end

local function candidate_level_names_for_cutscene(cinematic_name)
	local raw_names = {}
	local world_names = world_origin_level_names_for_cutscene(cinematic_name)
	local forced_names = FORCED_LEVELS[cinematic_name]

	for i = 1, #world_names do
		raw_names[#raw_names + 1] = world_names[i]
	end

	if type(forced_names) == "table" then
		for i = 1, #forced_names do
			raw_names[#raw_names + 1] = forced_names[i]
		end
	end

	return unique_array(raw_names)
end

local function video_template_for_cutscene(cinematic_name)
	return VIDEO_TEMPLATES[cinematic_name]
end

local function video_template_exists(template_name)
	if not template_name then
		return false
	end

	local templates = VideoViewSettings and VideoViewSettings.templates

	return type(templates) ~= "table" or templates[template_name] ~= nil
end

local function resolve_video_template(value)
	local cinematic_name = resolve_cutscene(value)

	if cinematic_name and VIDEO_TEMPLATES[cinematic_name] then
		return VIDEO_TEMPLATES[cinematic_name], cinematic_name
	end

	if value and value ~= "" then
		return value, nil
	end

	local selected = selected_cutscene_name()

	return VIDEO_TEMPLATES[selected], selected
end

local function scene_playback_available(system, cinematic_name)
	ensure_global_cinematic_config(system, cinematic_name)

	local _, _, valid = cutscene_configuration(system, cinematic_name)

	if valid and valid > 0 then
		return true
	end

	if registered_story_count_for_cutscene(cinematic_name) > 0 then
		return true
	end

	local level_names = candidate_level_names_for_cutscene(cinematic_name)

	return #level_names > 0
end

local function loading_cinematic_name(manager)
	local cinematic = manager or cinematic_manager()
	local loader = type(cinematic) == "table" and rawget(cinematic, "_cinematic_level_loader")

	return type(loader) == "table" and rawget(loader, "_cinematic_name") or nil
end

local function unique_story_candidates(cinematic_name, category)
	local raw_candidates = {}
	local extra_candidates = EXTRA_STORY_CANDIDATES[category] or EXTRA_STORY_CANDIDATES[cinematic_name]

	if type(extra_candidates) == "table" then
		for i = 1, #extra_candidates do
			raw_candidates[#raw_candidates + 1] = extra_candidates[i]
		end
	end

	local seen = {}
	local candidates = {}

	for i = 1, #raw_candidates do
		local candidate = raw_candidates[i]

		if candidate and not seen[candidate] then
			seen[candidate] = true
			candidates[#candidates + 1] = candidate
		end
	end

	return candidates
end

local function manual_register_stories_for_level(manager, cinematic_name, level, source)
	if not manual_register_enabled(cinematic_name) then
		return
	end

	if not cinematic_name or not level then
		record_event(string.format("manual_register skipped source=%s cutscene=%s level=%s",
			as_string(source),
			as_string(cinematic_name),
			level_name(level)
		))

		return
	end

	local system = cinematic_scene_system()
	local cinematics = system and rawget(system, "_cinematics")
	local sub_cinematics = cinematics and cinematics[cinematic_name]

	if type(sub_cinematics) ~= "table" then
		record_event(string.format("manual_register skipped cutscene=%s reason=no_sub_cinematics", cinematic_name))

		return
	end

	record_event(string.format("manual_register scan cutscene=%s level=%s categories=%s",
		cinematic_name,
		level_name(level),
		compact_list(sub_cinematics)
	))

	for i = 1, #sub_cinematics do
		local category = sub_cinematics[i]

		if story_count_for_category(category, manager) > 0 then
			record_event(string.format("manual_register skip category=%s reason=already_registered count=%d",
				category,
				story_count_for_category(category, manager)
			))
		else
			local candidates = unique_story_candidates(cinematic_name, category)
			local registered = false

			if #candidates == 0 then
				record_event(string.format("manual_register skipped category=%s reason=no_explicit_story_candidate", category))
			else
				local story_name = candidates[1]

				record_event(string.format("manual_candidate category=%s story=%s validation=skipped reason=storyteller_probe_can_crash",
					category,
					story_name
				))

				manager:register_story({
					cinematic_category = category,
					story_name = story_name,
					weight = 1,
					flow_level = level,
				})
				record_event(string.format("manual_register category=%s story=%s validation=skipped",
					category,
					story_name
				))

				registered = true
			end

			if not registered then
				record_event(string.format("manual_register failed category=%s candidates=%s",
					category,
					compact_list(candidates)
				))
			end
		end
	end
end

local function unit_level_name(unit)
	return level_name(unit_level(unit))
end

local function log_setup_details(setups)
	if type(setups) ~= "table" then
		return
	end

	local categories = sorted_keys(setups)

	for i = 1, #categories do
		local category = categories[i]
		local setup = setups[category]

		if type(setup) == "table" then
			write_line(string.format("  setup category=%s valid=%s origin=%s destination=%s camera=%s origin_level=%s destination_level=%s",
				as_string(category),
				tostring(setup.is_valid == true),
				tostring(setup.scene_unit_origin ~= nil),
				tostring(setup.scene_unit_destination ~= nil),
				tostring(setup.camera_unit ~= nil),
				unit_level_name(setup.scene_unit_origin),
				unit_level_name(setup.scene_unit_destination)
			))
		end
	end
end

local function fallback_destination_unit(excluded_level)
	local components = component_system()

	if not components or type(components.get_units_from_component_name) ~= "function" or type(components.get_components) ~= "function" then
		return nil
	end

	local ok, scenes = pcall(components.get_units_from_component_name, components, "CinematicScene")

	if not ok or type(scenes) ~= "table" then
		return nil
	end

	for _, scene_unit in ipairs(scenes) do
		local scene_components = safe_method(components, "get_components", scene_unit, "CinematicScene")
		local scene_component = type(scene_components) == "table" and scene_components[1]

		if scene_component and safe_method(scene_component, "unit_type") == "destination" then
			local scene_level = unit_level(scene_unit)
			local category = safe_method(scene_component, "cinematic_category")
			local cinematic_name = safe_method(scene_component, "cinematic_name")

			if scene_level and scene_level ~= excluded_level then
				return scene_unit, category, cinematic_name
			end
		end
	end

	return nil
end

local function append_unique_package(packages, seen, package_name)
	if type(package_name) ~= "string" or package_name == "" or seen[package_name] then
		return
	end

	seen[package_name] = true
	packages[#packages + 1] = package_name
end

local function append_theme_packages(packages, seen, theme_level)
	if not ThemePackage or type(ThemePackage.level_resource_dependency_packages) ~= "function" then
		return
	end

	local ok, theme_packages = pcall(ThemePackage.level_resource_dependency_packages, theme_level, "default")

	if not ok or type(theme_packages) ~= "table" then
		return
	end

	for _, package_name in pairs(theme_packages) do
		append_unique_package(packages, seen, package_name)
	end
end

local function append_item_packages(packages, seen, level_name)
	if not ItemPackage or not MasterItems or type(ItemPackage.level_resource_dependency_packages) ~= "function" or type(MasterItems.get_cached) ~= "function" then
		return
	end

	local item_ok, item_definitions = pcall(MasterItems.get_cached)

	if not item_ok or type(item_definitions) ~= "table" then
		return
	end

	local ok, item_packages = pcall(ItemPackage.level_resource_dependency_packages, item_definitions, level_name)

	if not ok or type(item_packages) ~= "table" then
		return
	end

	for package_name, _ in pairs(item_packages) do
		append_unique_package(packages, seen, package_name)
	end
end

local function extra_packages_for_cutscene(cinematic_name)
	local packages = {}
	local seen = {}
	local configured_packages = EXTRA_PACKAGES[cinematic_name]

	if type(configured_packages) == "table" then
		for i = 1, #configured_packages do
			append_unique_package(packages, seen, configured_packages[i])
		end
	end

	local theme_levels = CUTSCENE_THEME_LEVELS[cinematic_name]

	if type(theme_levels) == "table" then
		for i = 1, #theme_levels do
			append_item_packages(packages, seen, theme_levels[i])
			append_theme_packages(packages, seen, theme_levels[i])
		end
	end

	return packages
end

local function release_extra_packages(cinematic_name)
	local package_manager = Managers and Managers.package

	if not package_manager or type(package_manager.release) ~= "function" then
		return
	end

	local function release_state(name, state)
		if type(state) ~= "table" then
			return
		end

		for package_id, _ in pairs(state.package_ids or {}) do
			pcall(package_manager.release, package_manager, package_id)
		end

		record_event(string.format("extra_packages_released cutscene=%s packages=%s",
			as_string(name),
			compact_package_summary(state.packages)
		))
	end

	if cinematic_name then
		release_state(cinematic_name, extra_package_loads[cinematic_name])
		extra_package_loads[cinematic_name] = nil
	else
		for name, state in pairs(extra_package_loads) do
			release_state(name, state)
			extra_package_loads[name] = nil
		end
	end
end

local function load_extra_packages_for_cutscene(cinematic_name, ready_callback)
	local initial_packages = extra_packages_for_cutscene(cinematic_name)

	if #initial_packages == 0 then
		return true
	end

	local package_manager = Managers and Managers.package

	if not package_manager or type(package_manager.load) ~= "function" then
		return false, "Managers.package:load unavailable"
	end

	release_extra_packages(cinematic_name)

	local state = {
		packages = {},
		seen = {},
		package_ids = {},
		loaded = 0,
		total = 0,
		expanded = false,
		failed = false,
	}

	extra_package_loads[cinematic_name] = state

	record_event(string.format("extra_packages_load_start cutscene=%s packages=%s",
		as_string(cinematic_name),
		compact_package_summary(initial_packages)
	))

	local package_loaded

	local function load_package(package_name)
		if state.seen[package_name] then
			return true
		end

		state.seen[package_name] = true
		state.packages[#state.packages + 1] = package_name
		state.total = state.total + 1

		local ok, package_id_or_error = pcall(package_manager.load, package_manager, package_name, string.format("CinemaExtraPackage(%s)", cinematic_name), package_loaded, true)

		if not ok then
			state.failed = true

			record_event(string.format("extra_package_load_failed cutscene=%s package=%s error=%s",
				as_string(cinematic_name),
				as_string(package_name),
				as_string(package_id_or_error)
			))

			release_extra_packages(cinematic_name)

			return false, package_id_or_error
		end

		state.package_ids[package_id_or_error] = package_name

		return true
	end

	local function load_missing_packages(packages_to_load)
		local added = 0

		for i = 1, #packages_to_load do
			local package_name = packages_to_load[i]

			if not state.seen[package_name] then
				local ok, err = load_package(package_name)

				if not ok then
					return false, err
				end

				added = added + 1
			end
		end

		return true, added
	end

	package_loaded = function(package_id)
		if extra_package_loads[cinematic_name] ~= state or state.failed then
			return
		end

		state.loaded = state.loaded + 1

		if state.total <= 20 or state.loaded == state.total or state.loaded % 50 == 0 then
			record_event(string.format("extra_package_loaded cutscene=%s package=%s loaded=%d/%d",
				as_string(cinematic_name),
				as_string(state.package_ids[package_id]),
				state.loaded,
				state.total
			))
		end

		if state.loaded >= state.total then
			if not state.expanded then
				state.expanded = true

				local expanded_packages = extra_packages_for_cutscene(cinematic_name)
				local ok, added_or_error = load_missing_packages(expanded_packages)

				if not ok then
					if ready_callback then
						ready_callback(false, added_or_error)
					end

					return
				end

				if added_or_error > 0 then
					record_event(string.format("extra_packages_expand cutscene=%s added=%d packages=%s",
						as_string(cinematic_name),
						added_or_error,
						compact_package_summary(state.packages)
					))

					return
				end
			end

			record_event(string.format("extra_packages_ready cutscene=%s packages=%s",
				as_string(cinematic_name),
				compact_package_summary(state.packages)
			))

			if ready_callback then
				ready_callback(true)
			end
		end
	end

	local ok, err = load_missing_packages(initial_packages)

	if not ok then
		return false, err
	end

	return nil
end

local function forced_playback_active(cinematic_name)
	return cinematic_name ~= nil and direct_manual_register_cutscene == cinematic_name
end

local function log_cutscene_inspect(cinematic_name)
	cinematic_name = resolve_cutscene(cinematic_name) or selected_cutscene_name()

	local system = cinematic_scene_system()
	ensure_global_cinematic_config(system, cinematic_name)

	local sub_cinematics, setups, valid, invalid = cutscene_configuration(system, cinematic_name)
	local cinematic = cinematic_manager()

	write_line(string.format("inspect cutscene=%s label=%s lookup_id=%s",
		cinematic_name,
		CUTSCENE_BY_NAME[cinematic_name] and CUTSCENE_BY_NAME[cinematic_name].label or "<unknown>",
		as_string(network_lookup_id(cinematic_name))
	))
	write_line(string.format("  system=%s current=%s active=%s left=%s",
		tostring(system ~= nil),
		as_string(safe_method(system, "current_cinematic_name")),
		as_string(safe_method(system, "is_active")),
		as_string(system and rawget(system, "_cinematics_left_to_play"))
	))
	write_line(string.format("  configured=%s count=%d scenes=%s",
		tostring(type(sub_cinematics) == "table"),
		type(sub_cinematics) == "table" and #sub_cinematics or 0,
		compact_list(sub_cinematics)
	))
	write_line(string.format("  story_defs=%s", story_counts_for_cutscene(sub_cinematics)))
	write_line(string.format("  loading=%s using_levels=%s loaded_levels=%s",
		as_string(safe_method(cinematic, "currently_loading_cinematic_name")),
		as_string(safe_method(cinematic, "is_using_cinematic_levels")),
		loaded_level_names_for_cutscene(cinematic_name)
	))
	write_line(string.format("  video_template=%s", as_string(video_template_for_cutscene(cinematic_name))))
	write_line(string.format("  candidate_levels=%s", compact_list(candidate_level_names_for_cutscene(cinematic_name))))
	write_line(string.format("  setups=%d valid=%d invalid=%d",
		count_table(setups),
		valid,
		invalid
	))
	log_setup_details(setups)
end

network_lookup_id = function(cinematic_name)
	local network_lookup = rawget(_G, "NetworkLookup")
	local lookup = network_lookup and network_lookup.cinematic_scene_names

	if type(lookup) ~= "table" then
		return nil
	end

	local ok, result = pcall(function()
		return lookup[cinematic_name]
	end)

	if ok then
		return result
	end

	return nil
end

play_video_template = function(template_name, source, cinematic_name)
	if not template_name or template_name == "" then
		return false, "video template unavailable"
	end

	if not video_template_exists(template_name) then
		return false, "unknown video template"
	end

	local ui = Managers and Managers.ui

	if not ui or type(ui.open_view) ~= "function" then
		return false, "Managers.ui:open_view unavailable"
	end

	local ok, err = pcall(ui.open_view, ui, "video_view", nil, true, true, nil, {
		allow_skip_input = true,
		template = template_name,
	})

	if ok then
		write_line(string.format("video_play source=%s cutscene=%s template=%s",
			as_string(source),
			as_string(cinematic_name),
			template_name
		))

		return true
	end

	return false, err
end

local function request_server_cutscene(system, cinematic_name)
	if system and type(system.request_play_cutscene) == "function" then
		local ok, err = pcall(system.request_play_cutscene, system, cinematic_name)

		if ok then
			return true
		end

		return false, err
	end

	local cinematic_name_id = network_lookup_id(cinematic_name)
	local connection = Managers and Managers.connection

	if not cinematic_name_id then
		return false, "NetworkLookup.cinematic_scene_names unavailable"
	end

	if not connection or type(connection.send_rpc_server) ~= "function" then
		return false, "Managers.connection:send_rpc_server unavailable"
	end

	local ok, err = pcall(connection.send_rpc_server, connection, "rpc_request_play_cutscene", cinematic_name_id)

	if ok then
		return true
	end

	return false, err
end

local function play_local_cutscene(system, cinematic_name)
	if not system or type(system.play_cutscene) ~= "function" then
		return false, "cinematic_scene_system:play_cutscene unavailable"
	end

	local ok, err = pcall(system.play_cutscene, system, cinematic_name)

	if ok then
		local current = safe_method(system, "current_cinematic_name")
		local left = system and rawget(system, "_cinematics_left_to_play")
		local no_active_scene = current == nil or current == "none"
		local no_queued_stories = left == nil or left == 0

		if no_active_scene and no_queued_stories and registered_story_count_for_cutscene(cinematic_name) == 0 then
			direct_manual_register_cutscene = nil

			return false, "no cinematic stories queued"
		end

		return true
	end

	return false, err
end

local function play_forced_cutscene(system, cinematic_name, options)
	if not system then
		return false, "cinematic_scene_system unavailable"
	end

	local cinematic = cinematic_manager()

	if not cinematic or type(cinematic.load_levels) ~= "function" then
		return false, "Managers.state.cinematic:load_levels unavailable"
	end

	ensure_global_cinematic_config(system, cinematic_name)

	local level_names = candidate_level_names_for_cutscene(cinematic_name)

	if #level_names == 0 then
		return false, "no cinematic level candidates configured"
	end

	if type(system._cleanup_level_unit_for_cutscene) == "function" then
		pcall(system._cleanup_level_unit_for_cutscene, system, cinematic_name)
	end

	direct_manual_register_cutscene = cinematic_name
	forced_play_options[cinematic_name] = type(options) == "table" and options or nil

	record_event(string.format("force_play start cutscene=%s levels=%s queue_mode=%s",
		cinematic_name,
		compact_list(level_names),
		as_string(options and options.queue_mode)
	))

	local function on_levels_spawned()
		local ok, err

		if type(system._on_level_prepared) == "function" then
			ok, err = pcall(system._on_level_prepared, system, cinematic_name, nil)
		elseif type(system._play_cutscene) == "function" then
			ok, err = pcall(system._play_cutscene, system, cinematic_name, nil)
		else
			ok = false
			err = "cinematic_scene_system has no playable callback"
		end

		if not ok then
			record_event(string.format("force_play callback_failed cutscene=%s error=%s",
				cinematic_name,
				as_string(err)
			))
		end

		local left = system and rawget(system, "_cinematics_left_to_play")

		if ok and (left == nil or left == 0) then
			record_event(string.format("force_play no_queue cutscene=%s reason=no_valid_cinematic_setup",
				cinematic_name
			))

			pending_check = nil
			pending_auto_stop = nil
			forced_play_options[cinematic_name] = nil

			if type(system._activate_view) == "function" then
				pcall(system._activate_view, system, "none")
			end

			if type(system._set_cinematic_name) == "function" then
				pcall(system._set_cinematic_name, system, "none")
			else
				rawset(system, "_current_cinematic_name", "none")
			end

			local cinematic = cinematic_manager()

			if cinematic and type(cinematic.unload_levels) == "function" then
				pcall(cinematic.unload_levels, cinematic, cinematic_name)
			end
		end
	end

	local function start_level_load()
		local ok, err = pcall(cinematic.load_levels, cinematic, cinematic_name, level_names, on_levels_spawned, nil, nil, false)

		if ok then
			if type(system._activate_view) == "function" then
				pcall(system._activate_view, system, cinematic_name, true)
			end

			if type(system._set_cinematic_name) == "function" then
				pcall(system._set_cinematic_name, system, cinematic_name)
			end

			return true
		end

		direct_manual_register_cutscene = nil
		forced_play_options[cinematic_name] = nil
		release_extra_packages(cinematic_name)

		return false, err
	end

	local package_state, package_err = load_extra_packages_for_cutscene(cinematic_name, function(package_success, preload_error)
		if package_success == false then
			direct_manual_register_cutscene = nil
			forced_play_options[cinematic_name] = nil
			write_line(string.format("force_play extra_packages_failed cutscene=%s error=%s",
				cinematic_name,
				as_string(preload_error)
			))

			return
		end

		if direct_manual_register_cutscene ~= cinematic_name then
			forced_play_options[cinematic_name] = nil
			record_event(string.format("force_play extra_packages_ready_ignored cutscene=%s reason=not_active", cinematic_name))

			return
		end

		local ok, err = start_level_load()

		if not ok then
			write_line(string.format("force_play level_load_failed cutscene=%s error=%s",
				cinematic_name,
				as_string(err)
			))
		end
	end)

	if package_state == true then
		return start_level_load()
	elseif package_state == nil then
		record_event(string.format("force_play waiting_extra_packages cutscene=%s packages=%s",
			cinematic_name,
			compact_package_summary(extra_packages_for_cutscene(cinematic_name))
		))

		return true
	end

	direct_manual_register_cutscene = nil
	forced_play_options[cinematic_name] = nil

	return false, package_err
end

local function play_direct_cutscene(system, cinematic_name, options)
	if not system or type(system.play_cutscene) ~= "function" then
		return false, "cinematic_scene_system:play_cutscene unavailable"
	end

	if type(FORCED_LEVELS[cinematic_name]) == "table" and #FORCED_LEVELS[cinematic_name] > 0 then
		return play_forced_cutscene(system, cinematic_name, options)
	end

	ensure_global_cinematic_config(system, cinematic_name)

	direct_manual_register_cutscene = cinematic_name
	record_event(string.format("direct_play start cutscene=%s", cinematic_name))

	local ok, err = pcall(system.play_cutscene, system, cinematic_name)

	if ok then
		return true
	end

	direct_manual_register_cutscene = nil

	return false, err
end

local function play_cutscene(cinematic_name, source, force_scene, options)
	if not CUTSCENE_BY_NAME[cinematic_name] then
		write_line(string.format("blocked=unknown_cutscene name=%s", as_string(cinematic_name)))
		return false
	end

	local system = cinematic_scene_system()
	local current = safe_method(system, "current_cinematic_name")
	local left = system and rawget(system, "_cinematics_left_to_play")

	if current and current ~= "none" or type(left) == "number" and left > 0 then
		write_line(string.format("pre_play_stop current=%s left=%s next=%s",
			as_string(current),
			as_string(left),
			cinematic_name
		))
		stop_cutscene()

		system = cinematic_scene_system()
	end

	if not force_scene then
		local template_name = video_template_for_cutscene(cinematic_name)

		if template_name then
			local ok, err = play_video_template(template_name, source, cinematic_name)

			if not ok then
				write_line(string.format("video_play failed cutscene=%s template=%s error=%s",
					cinematic_name,
					template_name,
					as_string(err)
				))
			end

			return ok
		end
	end

	local mode = mod:get(PLAY_MODE_SETTING_ID) or "server"

	if not scene_playback_available(system, cinematic_name) then
		write_line(string.format("play failed mode=%s cutscene=%s error=no scene playback data",
			mode,
			cinematic_name
		))

		return false
	end

	ensure_global_cinematic_config(system, cinematic_name)

	local ok, err

	if mode ~= "direct" and #world_origin_level_names_for_cutscene(cinematic_name) == 0 and #candidate_level_names_for_cutscene(cinematic_name) > 0 then
		write_quiet_line(string.format("mode_auto_direct cutscene=%s previous_mode=%s reason=no_world_origin_levels",
			cinematic_name,
			mode
		))
		mode = "direct"
	end

	if mode == "direct" then
		ok, err = play_direct_cutscene(system, cinematic_name, options)
	elseif mode == "local" then
		ok, err = play_local_cutscene(system, cinematic_name)
	else
		ok, err = request_server_cutscene(system, cinematic_name)
	end

	if ok then
		write_line(string.format("play source=%s mode=%s cutscene=%s", as_string(source), mode, cinematic_name))
		pending_check = {
			cinematic_name = cinematic_name,
			time = current_time() + 2,
		}

		local auto_stop = auto_stop_seconds()

		if auto_stop > 0 then
			pending_auto_stop = {
				cinematic_name = cinematic_name,
				time = current_time() + auto_stop,
			}
			write_line(string.format("auto_stop armed seconds=%.1f", auto_stop))
		end

		return true
	end

	write_line(string.format("play failed mode=%s cutscene=%s error=%s", mode, cinematic_name, as_string(err)))
	return false
end

local function trigger_cinematic_skip_state(show_skip, can_skip)
	local event_manager = Managers and Managers.event

	if event_manager and type(event_manager.trigger) == "function" then
		pcall(event_manager.trigger, event_manager, "event_cinematic_skip_state", show_skip, can_skip)
	end
end

local function close_view_if_active(view_name)
	local ui = Managers and Managers.ui

	if not ui or type(ui.view_active) ~= "function" or type(ui.close_view) ~= "function" then
		return false
	end

	local ok, active = pcall(ui.view_active, ui, view_name)

	if not ok or not active then
		return false
	end

	return pcall(ui.close_view, ui, view_name, true)
end

local function stop_current_vo()
	if rawget(_G, "Vo") and type(Vo.stop_all_currently_playing_vo) == "function" then
		pcall(Vo.stop_all_currently_playing_vo)
	end
end

local function reset_world_time_scale()
	local world_manager = Managers and Managers.world

	if world_manager and type(world_manager.set_world_update_time_scale) == "function" then
		pcall(world_manager.set_world_update_time_scale, world_manager, 1)
	end
end

local function reset_local_cinematic_state(system, reason)
	if type(system) ~= "table" then
		return
	end

	local previous_current = rawget(system, "_current_cinematic_name")
	local previous_left = rawget(system, "_cinematics_left_to_play")

	rawset(system, "_cinematics_left_to_play", 0)

	if type(system._set_cinematic_name) == "function" then
		pcall(system._set_cinematic_name, system, "none")
	else
		rawset(system, "_current_cinematic_name", "none")
	end

	if debug_queue_enabled() and (previous_current ~= nil and previous_current ~= "none" or previous_left ~= nil and previous_left ~= 0) then
		record_event(string.format("local_cinematic_state_reset reason=%s previous_current=%s previous_left=%s",
			as_string(reason),
			as_string(previous_current),
			as_string(previous_left)
		))
	end
end

stop_cutscene = function()
	pending_check = nil
	pending_auto_stop = nil
	local forced_cinematic_name = direct_manual_register_cutscene

	direct_manual_register_cutscene = nil
	trigger_cinematic_skip_state(false, false)
	stop_current_vo()

	local system = cinematic_scene_system()
	local current_cinematic_name = safe_method(system, "current_cinematic_name")
	local cinematic = Managers and Managers.state and Managers.state.cinematic

	if cinematic and type(cinematic.stop_all_stories) == "function" then
		pcall(cinematic.stop_all_stories, cinematic)
	end

	release_extra_packages(current_cinematic_name)
	release_extra_packages(forced_cinematic_name)

	if current_cinematic_name then
		forced_play_options[current_cinematic_name] = nil
	end

	if forced_cinematic_name then
		forced_play_options[forced_cinematic_name] = nil
	end

	if current_cinematic_name and current_cinematic_name ~= "none" and system and type(system.client_unset_scene) == "function" then
		pcall(system.client_unset_scene, system, current_cinematic_name)
	end

	reset_world_time_scale()
	close_view_if_active("cutscene_view")
	close_view_if_active("video_view")
	close_view_if_active("mission_intro_view")
	reset_local_cinematic_state(system, "stop")
	write_line("stop cutscene requested")
end

local function scan_clear_queue()
	for i = #scan_queue, 1, -1 do
		scan_queue[i] = nil
	end
end

local function scan_result_status_counts()
	local counts = {}

	for _, result in pairs(scan_results) do
		local status = result.status or "unknown"

		counts[status] = (counts[status] or 0) + 1
	end

	return counts
end

local function log_scan_report()
	local counts = scan_result_status_counts()
	local status_keys = sorted_keys(counts)
	local parts = {}

	for i = 1, #status_keys do
		local status = status_keys[i]

		parts[#parts + 1] = string.format("%s:%d", status, counts[status])
	end

	write_line(string.format("scan_report results=%d active=%s queued=%d statuses=%s",
		count_table(scan_results),
		scan_active and scan_active.cinematic_name or "<none>",
		#scan_queue,
		#parts > 0 and table.concat(parts, ",") or "<none>"
	))

	local cutscene_names = sorted_keys(scan_results)

	for i = 1, #cutscene_names do
		local cinematic_name = cutscene_names[i]
		local result = scan_results[cinematic_name]

		write_quiet_line(string.format("scan_report cutscene=%s status=%s categories=%d aligned=%d origin_anchor=%d borrow_destination=%d blocked_origin_anchor=%d unaligned=%d stories=%d missing_story=%d missing_setup=%d video=%s levels=%s",
			cinematic_name,
			as_string(result.status),
			result.categories or 0,
			result.aligned or 0,
			result.origin_anchor or 0,
			result.borrow_destination or 0,
			result.blocked_origin_anchor or 0,
			result.unaligned or 0,
			result.stories or 0,
			result.missing_story or 0,
			result.missing_setup or 0,
			as_string(result.video_template),
			as_string(result.levels)
		))
	end
end

local function cleanup_scan_cutscene(system, cinematic_name)
	if type(system) == "table" and type(system._uninitialize_cinematic) == "function" then
		local ok = pcall(system._uninitialize_cinematic, system, cinematic_name)

		if ok then
			reset_local_cinematic_state(system, "scan_cleanup")

			return
		end
	end

	local cinematic = cinematic_manager()

	if cinematic and type(cinematic.unload_levels) == "function" then
		pcall(cinematic.unload_levels, cinematic, cinematic_name)
	end

	reset_local_cinematic_state(system, "scan_cleanup")
end

local function classify_scan_result(cinematic_name, level_names)
	local system = cinematic_scene_system()
	ensure_global_cinematic_config(system, cinematic_name)

	local sub_cinematics, setups, valid, invalid = cutscene_configuration(system, cinematic_name)
	local result = {
		status = "unknown",
		categories = type(sub_cinematics) == "table" and #sub_cinematics or 0,
		aligned = 0,
		origin_anchor = 0,
		borrow_destination = 0,
		blocked_origin_anchor = 0,
		unaligned = 0,
		stories = 0,
		missing_story = 0,
		missing_setup = 0,
		valid = valid,
		invalid = invalid,
		levels = compact_list(level_names),
		video_template = video_template_for_cutscene(cinematic_name),
	}

	if type(sub_cinematics) ~= "table" or #sub_cinematics == 0 then
		result.status = result.video_template and "video_template" or "no_categories"

		return result
	end

	for i = 1, #sub_cinematics do
		local category = sub_cinematics[i]
		local setup = type(setups) == "table" and setups[category] or nil
		local story_count = story_count_for_category(category)
		local has_setup = type(setup) == "table"
		local has_origin = has_setup and setup.scene_unit_origin ~= nil
		local has_destination = has_setup and setup.scene_unit_destination ~= nil
		local has_camera = has_setup and setup.camera_unit ~= nil
		local is_valid = has_setup and setup.is_valid == true
		local category_status

		if story_count > 0 then
			result.stories = result.stories + 1
		end

		if story_count > 0 and is_valid and has_origin and has_destination and has_camera then
			result.aligned = result.aligned + 1
			category_status = "ready_aligned"
		elseif story_count > 0 and has_origin and has_camera and not has_destination then
			local borrowed_destination = fallback_destination_unit(unit_level(setup.scene_unit_origin))
			local has_borrow_destination = borrowed_destination ~= nil

			if has_borrow_destination then
				result.borrow_destination = result.borrow_destination + 1
			end

			if origin_anchor_block_reason(cinematic_name) then
				result.blocked_origin_anchor = result.blocked_origin_anchor + 1
				category_status = has_borrow_destination and "blocked_origin_anchor_borrowable" or "blocked_origin_anchor"
			else
				result.origin_anchor = result.origin_anchor + 1
				category_status = has_borrow_destination and "experimental_borrow_destination" or "experimental_origin_anchor"
			end
		elseif story_count <= 0 then
			result.missing_story = result.missing_story + 1
			category_status = "missing_story"
		else
			result.missing_setup = result.missing_setup + 1
			category_status = "missing_setup"
		end

		write_quiet_line(string.format("scan_setup cutscene=%s category=%s status=%s stories=%d valid=%s origin=%s destination=%s camera=%s origin_level=%s destination_level=%s",
			cinematic_name,
			as_string(category),
			category_status,
			story_count,
			tostring(is_valid),
			tostring(has_origin),
			tostring(has_destination),
			tostring(has_camera),
			has_setup and unit_level_name(setup.scene_unit_origin) or "<nil>",
			has_setup and unit_level_name(setup.scene_unit_destination) or "<nil>"
		))
	end

	if result.aligned == result.categories then
		result.status = "ready_aligned"
	elseif result.borrow_destination == result.categories then
		result.status = result.blocked_origin_anchor > 0 and "blocked_origin_anchor_borrowable" or "experimental_borrow_destination"
	elseif result.aligned + result.origin_anchor == result.categories then
		result.status = result.aligned > 0 and "ready_mixed" or "experimental_origin_anchor"
	elseif result.blocked_origin_anchor == result.categories then
		result.status = "blocked_origin_anchor"
	elseif result.stories == 0 then
		result.status = "no_stories"
	elseif result.aligned + result.origin_anchor + result.unaligned > 0 then
		result.status = "partial"
	elseif result.missing_setup > 0 then
		result.status = "missing_setup"
	else
		result.status = "unknown"
	end

	if result.video_template and (result.status == "no_stories" or result.status == "no_candidate_levels" or result.status == "unknown") then
		result.status = "video_template"
	end

	return result
end

local function finish_scan_cutscene(scan_id, cinematic_name, level_names, status, error_message)
	if not scan_active or scan_active.id ~= scan_id then
		local system = cinematic_scene_system()

		cleanup_scan_cutscene(system, cinematic_name)

		return
	end

	local result
	local system = cinematic_scene_system()

	if status then
		result = {
			status = status,
			categories = 0,
			aligned = 0,
			origin_anchor = 0,
			borrow_destination = 0,
			blocked_origin_anchor = 0,
			unaligned = 0,
			stories = 0,
			missing_story = 0,
			missing_setup = 0,
			valid = 0,
			invalid = 0,
			levels = compact_list(level_names),
			error = error_message,
			video_template = video_template_for_cutscene(cinematic_name),
		}

		if result.video_template and (status == "no_stories" or status == "no_candidate_levels" or status == "unknown") then
			result.status = "video_template"
		end
	else
		local ok, classified_or_error = pcall(classify_scan_result, cinematic_name, level_names)

		if ok then
			result = classified_or_error
		else
			result = {
				status = "classify_failed",
				categories = 0,
				aligned = 0,
				origin_anchor = 0,
				borrow_destination = 0,
				blocked_origin_anchor = 0,
				unaligned = 0,
				stories = 0,
				missing_story = 0,
				missing_setup = 0,
				valid = 0,
				invalid = 0,
				levels = compact_list(level_names),
				error = classified_or_error,
			}
		end
	end

	scan_results[cinematic_name] = result

	write_line(string.format("scan_result cutscene=%s status=%s categories=%d aligned=%d origin_anchor=%d borrow_destination=%d blocked_origin_anchor=%d unaligned=%d stories=%d missing_story=%d missing_setup=%d valid=%d invalid=%d video=%s levels=%s error=%s",
		cinematic_name,
		as_string(result.status),
		result.categories or 0,
		result.aligned or 0,
		result.origin_anchor or 0,
		result.borrow_destination or 0,
		result.blocked_origin_anchor or 0,
		result.unaligned or 0,
		result.stories or 0,
		result.missing_story or 0,
		result.missing_setup or 0,
		result.valid or 0,
		result.invalid or 0,
		as_string(result.video_template),
		as_string(result.levels),
		as_string(result.error)
	))

	cleanup_scan_cutscene(system, cinematic_name)

	if direct_manual_register_cutscene == cinematic_name then
		direct_manual_register_cutscene = nil
	end

	scan_active = nil
	scan_next_time = current_time() + 0.75
end

local function start_scan_cutscene(cinematic_name)
	if not CUTSCENE_BY_NAME[cinematic_name] then
		write_line(string.format("scan skipped unknown_cutscene=%s", as_string(cinematic_name)))

		return false
	end

	local system = cinematic_scene_system()
	local cinematic = cinematic_manager()

	if not system or not cinematic or type(cinematic.load_levels) ~= "function" then
		write_line("scan failed reason=cinematic_system_unavailable")

		return false
	end

	local current = safe_method(system, "current_cinematic_name")
	local left = system and rawget(system, "_cinematics_left_to_play")

	if current and current ~= "none" or type(left) == "number" and left > 0 then
		write_line(string.format("scan pre_stop current=%s left=%s", as_string(current), as_string(left)))
		stop_cutscene()
		system = cinematic_scene_system()
	end

	ensure_global_cinematic_config(system, cinematic_name)

	local level_names = candidate_level_names_for_cutscene(cinematic_name)

	if #level_names == 0 then
		local video_template = video_template_for_cutscene(cinematic_name)
		local result = {
			status = video_template and "video_template" or "no_candidate_levels",
			categories = 0,
			aligned = 0,
			origin_anchor = 0,
			borrow_destination = 0,
			blocked_origin_anchor = 0,
			unaligned = 0,
			stories = 0,
			missing_story = 0,
			missing_setup = 0,
			valid = 0,
			invalid = 0,
			levels = compact_list(level_names),
			video_template = video_template,
		}

		scan_results[cinematic_name] = result
		write_line(string.format("scan_result cutscene=%s status=%s categories=0 aligned=0 origin_anchor=0 borrow_destination=0 blocked_origin_anchor=0 unaligned=0 stories=0 missing_story=0 missing_setup=0 valid=0 invalid=0 video=%s levels=%s error=<nil>",
			cinematic_name,
			result.status,
			as_string(result.video_template),
			result.levels
		))

		return false
	end

	scan_sequence = scan_sequence + 1

	local scan_id = scan_sequence

	scan_active = {
		id = scan_id,
		cinematic_name = cinematic_name,
		level_names = level_names,
		started_at = current_time(),
	}
	direct_manual_register_cutscene = cinematic_name

	write_line(string.format("scan_start cutscene=%s queued=%d levels=%s",
		cinematic_name,
		#scan_queue,
		compact_list(level_names)
	))

	local function on_levels_spawned()
		if not scan_active or scan_active.id ~= scan_id then
			finish_scan_cutscene(scan_id, cinematic_name, level_names, "cancelled")

			return
		end

		if type(system._initialize_cinematic) ~= "function" then
			finish_scan_cutscene(scan_id, cinematic_name, level_names, "initialize_unavailable")

			return
		end

		local ok, err = pcall(system._initialize_cinematic, system, cinematic_name)

		if not ok then
			finish_scan_cutscene(scan_id, cinematic_name, level_names, "initialize_failed", err)

			return
		end

		finish_scan_cutscene(scan_id, cinematic_name, level_names)
	end

	local ok, err = pcall(cinematic.load_levels, cinematic, cinematic_name, level_names, on_levels_spawned, nil, true, false)

	if ok then
		return true
	end

	finish_scan_cutscene(scan_id, cinematic_name, level_names, "load_failed", err)

	return false
end

local function update_scan(now)
	if scan_active then
		if now - scan_active.started_at > SCAN_TIMEOUT_SECONDS then
			finish_scan_cutscene(scan_active.id, scan_active.cinematic_name, scan_active.level_names, "timeout")
		end

		return
	end

	if scan_next_time and now < scan_next_time then
		return
	end

	if #scan_queue > 0 then
		local next_cutscene = table.remove(scan_queue, 1)

		start_scan_cutscene(next_cutscene)
	end
end

local function queue_scan_cutscene(cinematic_name)
	if not CUTSCENE_BY_NAME[cinematic_name] then
		write_line(string.format("scan skipped unknown_cutscene=%s", as_string(cinematic_name)))

		return false
	end

	scan_queue[#scan_queue + 1] = cinematic_name

	return true
end

local function queue_scan_all()
	scan_clear_queue()
	table.clear(scan_results)

	for i = 1, #CUTSCENES do
		queue_scan_cutscene(CUTSCENES[i].name)
	end

	write_line(string.format("scan_queued count=%d", #scan_queue))
end

local function stop_scan()
	local active = scan_active

	scan_clear_queue()
	scan_active = nil
	direct_manual_register_cutscene = nil

	if active then
		cleanup_scan_cutscene(cinematic_scene_system(), active.cinematic_name)
	end

	write_line("scan stopped")
end

local function log_scan_status()
	write_line(string.format("scan_status active=%s queued=%d results=%d timeout_seconds=%d",
		scan_active and scan_active.cinematic_name or "<none>",
		#scan_queue,
		count_table(scan_results),
		SCAN_TIMEOUT_SECONDS
	))
end

local function handle_scan_command(value)
	value = value or "status"

	if value == "all" then
		queue_scan_all()
	elseif value == "status" then
		log_scan_status()
	elseif value == "report" then
		log_scan_report()
	elseif value == "stop" or value == "cancel" then
		stop_scan()
	else
		local cinematic_name = resolve_cutscene(value)

		if cinematic_name then
			queue_scan_cutscene(cinematic_name)
			write_line(string.format("scan_queued cutscene=%s queued=%d", cinematic_name, #scan_queue))
		else
			write_line("usage: /cinema scan [all|status|report|stop|index|cutscene_name]")
		end
	end
end

local function list_cutscenes(filter)
	local filter_text = filter and string.lower(tostring(filter)) or nil
	local shown = 0

	write_line("cutscenes:")

	for index, cutscene in ipairs(CUTSCENES) do
		local haystack = string.lower(cutscene.name .. " " .. cutscene.label)

		if not filter_text or string.find(haystack, filter_text, 1, true) then
			local system = cinematic_scene_system()
			local sub_cinematics = cutscene_configuration(system, cutscene.name)

			write_line(string.format("  %02d %s - %s configured=%s",
				index,
				cutscene.name,
				cutscene.label,
				tostring(type(sub_cinematics) == "table")
			))
			shown = shown + 1
		end
	end

	write_line(string.format("shown=%d total=%d", shown, #CUTSCENES))
end

local function story_definition_summary(story_definition)
	if type(story_definition) ~= "table" then
		return "<invalid>"
	end

	return string.format("%s@%s",
		as_string(story_definition.name),
		level_name(story_definition.level)
	)
end

local function dump_registered_stories(filter)
	local cinematic = cinematic_manager()
	local stories = type(cinematic) == "table" and rawget(cinematic, "_stories")
	local filter_text = filter and filter ~= "" and filter ~= "all" and string.lower(tostring(filter)) or nil
	local keys = sorted_keys(stories)
	local total_defs = 0
	local shown = 0
	local max_rows = filter_text and 80 or 30

	for _, category in ipairs(keys) do
		local definitions = stories[category]

		if type(definitions) == "table" then
			total_defs = total_defs + #definitions
		end
	end

	write_line(string.format("stories categories=%d defs=%d filter=%s",
		#keys,
		total_defs,
		as_string(filter_text)
	))

	for _, category in ipairs(keys) do
		local definitions = stories[category]
		local summaries = {}

		if type(definitions) == "table" then
			for i = 1, #definitions do
				summaries[#summaries + 1] = story_definition_summary(definitions[i])
			end
		end

		local line = string.format("  %s count=%d stories=%s",
			as_string(category),
			type(definitions) == "table" and #definitions or 0,
			#summaries > 0 and table.concat(summaries, ",") or "<none>"
		)
		local haystack = string.lower(line)

		if not filter_text or string.find(haystack, filter_text, 1, true) then
			if shown < max_rows then
				write_line(line)
			end

			shown = shown + 1
		end
	end

	if shown > max_rows then
		write_line(string.format("  truncated shown=%d total_matching=%d use filter to narrow", max_rows, shown))
	else
		write_line(string.format("shown=%d", shown))
	end
end

local function dump_event_history(filter)
	if filter == "clear" then
		table.clear(event_history)
		write_line("history cleared")

		return
	end

	local filter_text = filter and filter ~= "" and filter ~= "all" and string.lower(tostring(filter)) or nil
	local shown = 0

	write_line(string.format("history events=%d filter=%s", #event_history, as_string(filter_text)))

	for i = 1, #event_history do
		local event = event_history[i]
		local haystack = string.lower(event)

		if not filter_text or string.find(haystack, filter_text, 1, true) then
			write_line(string.format("  %02d %s", i, event))
			shown = shown + 1
		end
	end

	write_line(string.format("shown=%d", shown))
end

local function add_story_candidate(category, story_name)
	if not category or category == "" or not story_name or story_name == "" then
		write_line("usage: /cinema candidate [category] [story_name]")

		return
	end

	local candidates = EXTRA_STORY_CANDIDATES[category] or {}

	candidates[#candidates + 1] = story_name
	EXTRA_STORY_CANDIDATES[category] = candidates

	write_line(string.format("candidate category=%s story=%s count=%d", category, story_name, #candidates))
end

local function clear_log_file()
	local file, path, open_error = open_log_file("w")

	if not file then
		write_line(string.format("file_log clear failed error=%s", as_string(open_error)))

		return
	end

	file:write(string.format("%s log cleared %s\n", LINE_PREFIX, log_timestamp("%Y-%m-%d %H:%M:%S")))
	file:write(string.format("Log path: %s\n", tostring(path)))
	file:close()
	file_initialized = true
	file_error_reported = false
	file_status_reported = true
	write_line(string.format("file_log cleared path=%s", mod:log_path()))
end

local function log_file_status()
	write_line(string.format("file_log enabled=%s clear_on_load=%s initialized=%s path=%s",
		tostring(mod:get("write_to_file") ~= false),
		tostring(mod:get("clear_file_on_load") ~= false),
		tostring(file_initialized),
		mod:log_path()
	))
end

local function log_status()
	local system = cinematic_scene_system()
	local cinematic = cinematic_manager()

	write_line(string.format("status mode=%s selected=%s system=%s current=%s",
		as_string(mod:get(PLAY_MODE_SETTING_ID)),
		selected_cutscene_name(),
		tostring(system ~= nil),
		as_string(safe_method(system, "current_cinematic_name"))
	))
	write_line(string.format("  active=%s left=%s auto_stop_seconds=%.1f",
		as_string(safe_method(system, "is_active")),
		as_string(system and rawget(system, "_cinematics_left_to_play")),
		auto_stop_seconds()
	))
	write_line(string.format("  cinematic_loading=%s using_levels=%s",
		as_string(safe_method(cinematic, "currently_loading_cinematic_name")),
		as_string(safe_method(cinematic, "is_using_cinematic_levels"))
	))
	write_line(string.format("  cleanup_empty_active=%s debug_queue_story=%s",
		tostring(cleanup_empty_active_enabled()),
		tostring(debug_queue_enabled())
	))
	write_line(string.format("  allow_unaligned_scene_playback=%s",
		tostring(allow_unaligned_enabled())
	))
	write_line(string.format("  origin_anchor_scene_playback=%s",
		tostring(origin_anchor_enabled())
	))
	write_line(string.format("  borrow_destination_scene_playback=%s",
		tostring(borrow_destination_enabled())
	))
	write_line(string.format("  manual_register_stories=%s direct_window=%s",
		tostring(mod:get("manual_register_stories") == true),
		as_string(direct_manual_register_cutscene)
	))
	write_line(string.format("  file_log=%s path=%s",
		tostring(mod:get("write_to_file") ~= false),
		mod:log_path()
	))
	write_line(string.format("  scan_active=%s scan_queued=%d scan_results=%d",
		scan_active and scan_active.cinematic_name or "<none>",
		#scan_queue,
		count_table(scan_results)
	))
end

local function log_help()
	write_line("commands:")
	write_line("  /cinema list [filter]")
	write_line("  /cinema play [selected|index|cutscene_name]")
	write_line("  /cinema direct [selected|index|cutscene_name]")
	write_line("  /cinema noalign [selected|index|cutscene_name]  one-shot forced unaligned playback")
	write_line("  /cinema scene [selected|index|cutscene_name]")
	write_line("  /cinema video [selected|index|cutscene_name|template_name]")
	write_line("  /cinema selected [index|cutscene_name]")
	write_line("  /cinema mode [server|local|direct]")
	write_line("  /cinema inspect [selected|index|cutscene_name]")
	write_line("  /cinema stories [filter|all]")
	write_line("  /cinema history [filter|all|clear]")
	write_line("  /cinema candidate [category] [story_name]")
	write_line("  /cinema scan [all|status|report|stop|index|cutscene_name]")
	write_line("  /cinema filelog [on|off|clear|path|status]")
	write_line("  /cinema autostop [seconds]")
	write_line("  /cinema manual [on|off|status]")
	write_line("  /cinema cleanup [on|off|status]")
	write_line("  /cinema debug [on|off|status]")
	write_line("  /cinema anchor [on|off|status]  experimental; blocked for known crashing scenes")
	write_line("  /cinema borrow [on|off|status]  experimental; borrow a current-level destination marker")
	write_line("  /cinema unaligned [on|off|status]")
	write_line("  /cinema stop")
	write_line("  /cinema status")
end

mod:hook_require("scripts/script_flow_nodes/flow_callbacks", function(callbacks)
	if flow_register_hooked then
		return
	end

	local flow_callbacks = callbacks or rawget(_G, "FlowCallbacks")

	if type(flow_callbacks) ~= "table" or type(flow_callbacks.register_cinematic_story) ~= "function" then
		write_line("flow_register_hook skipped reason=FlowCallbacks unavailable")

		return
	end

	flow_register_hooked = true

	mod:hook(flow_callbacks, "register_cinematic_story", function(func, params)
		if debug_queue_enabled() and type(params) == "table" then
			record_event(string.format("flow_register_cinematic_story category=%s story=%s weight=%s context_level=%s keys=%s",
				as_string(params.cinematic_category),
				as_string(params.story_name),
				as_string(params.weight),
				flow_callback_context_level_name(),
				compact_keys(params)
			))
		end

		return func(params)
	end)
end)

mod:hook_require("scripts/extension_systems/cinematic_scene/cinematic_scene_system", function(CinematicSceneSystem)
	mod:hook(CinematicSceneSystem, "_initialize_sub_cinematics", function(func, self, cinematic_name, sub_cinematics)
		local setups = func(self, cinematic_name, sub_cinematics)

		if not forced_playback_active(cinematic_name) or type(setups) ~= "table" then
			return setups
		end

		for category, setup in pairs(setups) do
			if type(setup) == "table" and not setup.scene_unit_destination and setup.scene_unit_origin and setup.camera_unit then
				record_event(string.format("unaligned_candidate cutscene=%s category=%s origin_level=%s",
					as_string(cinematic_name),
					as_string(category),
					unit_level_name(setup.scene_unit_origin)
				))
			end
		end

		return setups
	end)

	mod:hook(CinematicSceneSystem, "_queue_cinematics", function(func, self, cinematic_name, client_channel_id)
		if not forced_playback_active(cinematic_name) then
			return func(self, cinematic_name, client_channel_id)
		end

		local sub_cinematics = rawget(self, "_cinematics") and rawget(self, "_cinematics")[cinematic_name]
		local setups_by_name = rawget(self, "_cinematics_setups")
		local sub_cinematics_setup = setups_by_name and setups_by_name[cinematic_name]

		if type(sub_cinematics) ~= "table" or type(sub_cinematics_setup) ~= "table" then
			return func(self, cinematic_name, client_channel_id)
		end

		local template = CinematicSceneTemplates and CinematicSceneTemplates[cinematic_name] or {}
		local hotjoin_only = template.hotjoin_only
		local is_skippable = template.is_skippable
		local wait_for_player_input = template.wait_for_player_input
		local popup_info = template.popup_info
		local play_options = forced_play_options[cinematic_name]
		local queue_mode = type(play_options) == "table" and play_options.queue_mode or nil
		local queued = 0

		for _, category in ipairs(sub_cinematics) do
			local setup = sub_cinematics_setup[category]
			local can_queue_aligned = type(setup) == "table" and setup.is_valid and setup.scene_unit_origin and setup.scene_unit_destination
			local has_origin_anchor_shape = type(setup) == "table" and not setup.is_valid and setup.scene_unit_origin and setup.camera_unit and not setup.scene_unit_destination
			local force_unaligned = queue_mode == "noalign" and has_origin_anchor_shape
			local can_queue_origin_anchor = not force_unaligned and origin_anchor_allowed(cinematic_name) and has_origin_anchor_shape
			local borrowed_destination, borrowed_category, borrowed_cinematic_name

			if not force_unaligned and borrow_destination_enabled() and has_origin_anchor_shape then
				borrowed_destination, borrowed_category, borrowed_cinematic_name = fallback_destination_unit(unit_level(setup.scene_unit_origin))
			end

			local can_queue_borrow_destination = borrowed_destination ~= nil
			local can_queue_unaligned = (force_unaligned or allow_unaligned_enabled()) and not can_queue_origin_anchor and has_origin_anchor_shape

			if can_queue_aligned or can_queue_origin_anchor or can_queue_borrow_destination or can_queue_unaligned then
				local played_callback = callback(self, "_cinematic_played", cinematic_name, category)
				local origin = (can_queue_aligned or can_queue_origin_anchor or can_queue_borrow_destination) and setup.scene_unit_origin or nil
				local destination = can_queue_aligned and setup.scene_unit_destination or can_queue_origin_anchor and setup.scene_unit_origin or borrowed_destination
				local success = Managers.state.cinematic:queue_story(cinematic_name, category, origin, destination, played_callback, client_channel_id, hotjoin_only, is_skippable, wait_for_player_input, popup_info)

				if success then
					if can_queue_unaligned then
						local cinematic = Managers.state and Managers.state.cinematic
						local queued_stories = type(cinematic) == "table" and rawget(cinematic, "_queued_stories")
						local queued_story = type(queued_stories) == "table" and queued_stories[#queued_stories]

						if type(queued_story) == "table" and queued_story.cinematic_scene_name == cinematic_name then
							queued_story.category = category
							queued_story.scene_unit_origin = setup.scene_unit_origin
							queued_story.scene_unit_destination = setup.scene_unit_origin
							queued_story.use_alignment_units = false
						end
					end

					self._cinematics_left_to_play = self._cinematics_left_to_play + 1
					queued = queued + 1

					if can_queue_origin_anchor then
						record_event(string.format("queue_origin_anchor cutscene=%s category=%s origin_level=%s",
							as_string(cinematic_name),
							as_string(category),
							unit_level_name(setup.scene_unit_origin)
						))
					elseif can_queue_borrow_destination then
						record_event(string.format("queue_borrow_destination cutscene=%s category=%s origin_level=%s borrowed_category=%s borrowed_cutscene=%s destination_level=%s",
							as_string(cinematic_name),
							as_string(category),
							unit_level_name(setup.scene_unit_origin),
							as_string(borrowed_category),
							as_string(borrowed_cinematic_name),
							unit_level_name(borrowed_destination)
						))
					elseif can_queue_unaligned then
						record_event(string.format("queue_unaligned cutscene=%s category=%s origin_level=%s forced=%s",
							as_string(cinematic_name),
							as_string(category),
							unit_level_name(setup.scene_unit_origin),
							tostring(force_unaligned)
						))
					end
				end
			elseif has_origin_anchor_shape and borrow_destination_enabled() then
				record_event(string.format("queue_skip_borrow_destination_missing cutscene=%s category=%s origin_level=%s",
					as_string(cinematic_name),
					as_string(category),
					unit_level_name(setup.scene_unit_origin)
				))
			elseif has_origin_anchor_shape and origin_anchor_block_reason(cinematic_name) then
				record_event(string.format("queue_skip_origin_anchor_blocked cutscene=%s category=%s reason=%s origin_level=%s",
					as_string(cinematic_name),
					as_string(category),
					as_string(origin_anchor_block_reason(cinematic_name)),
					unit_level_name(setup.scene_unit_origin)
				))
			elseif type(setup) == "table" then
				record_event(string.format("queue_skip_invalid cutscene=%s category=%s origin=%s destination=%s camera=%s story_defs=%d",
					as_string(cinematic_name),
					as_string(category),
					tostring(setup.scene_unit_origin ~= nil),
					tostring(setup.scene_unit_destination ~= nil),
					tostring(setup.camera_unit ~= nil),
					story_count_for_category(category)
				))
			end
		end

		return queued > 0
	end)
end)

mod:hook_require("scripts/managers/cinematic/cinematic_manager", function(CinematicManager)
	mod:hook(CinematicManager, "load_levels", function(func, self, cinematic_name, level_names, on_levels_spawned_callback, client_channel_id, hotjoin_only, load_only, preload_id)
		if debug_queue_enabled() then
			record_event(string.format("load_levels cutscene=%s levels=%s client_channel=%s hotjoin=%s load_only=%s preload=%s",
				as_string(cinematic_name),
				compact_list(level_names),
				as_string(client_channel_id),
				as_string(hotjoin_only),
				as_string(load_only),
				as_string(preload_id)
			))
		end

		return func(self, cinematic_name, level_names, on_levels_spawned_callback, client_channel_id, hotjoin_only, load_only, preload_id)
	end)

	mod:hook(CinematicManager, "_on_levels_loaded", function(func, self, request_id, load_only, cinematic_name, levels_loaded)
		local result = func(self, request_id, load_only, cinematic_name, levels_loaded)

		if debug_queue_enabled() then
			record_event(string.format("levels_loaded request=%s cutscene=%s load_only=%s levels=%s",
				as_string(request_id),
				as_string(cinematic_name),
				as_string(load_only),
				compact_keys(levels_loaded)
			))
		end

		if direct_manual_register_cutscene == cinematic_name then
			record_event(string.format("direct_play registration_window_closed cutscene=%s", cinematic_name))
			direct_manual_register_cutscene = nil
		end

		return result
	end)

	mod:hook(CinematicManager, "_spawn_cinematic_level", function(func, self, cinematic_level_name)
		local level = func(self, cinematic_level_name)
		local cinematic_name = loading_cinematic_name(self)

		if debug_queue_enabled() then
			record_event(string.format("spawn_cinematic_level name=%s level=%s",
				as_string(cinematic_level_name),
				level_name(level)
			))
		end

		manual_register_stories_for_level(self, cinematic_name, level, "spawn_cinematic_level")

		return level
	end)

	mod:hook(CinematicManager, "unload_levels", function(func, self, cinematic_name)
		if debug_queue_enabled() then
			record_event(string.format("unload_levels cutscene=%s", as_string(cinematic_name)))
		end

		local result = func(self, cinematic_name)

		release_extra_packages(cinematic_name)

		if cinematic_name then
			forced_play_options[cinematic_name] = nil
		end

		return result
	end)

	mod:hook(CinematicManager, "register_story", function(func, self, params)
		local result = func(self, params)

		if debug_queue_enabled() and type(params) == "table" then
			record_event(string.format("register_story category=%s story=%s weight=%s level=%s result=%s",
				as_string(params.cinematic_category),
				as_string(params.story_name),
				as_string(params.weight),
				level_name(params.flow_level),
				as_string(result)
			))
		end

		return result
	end)

	mod:hook(CinematicManager, "queue_story", function(func, self, cinematic_scene_name, category, optional_scene_unit_origin, optional_scene_unit_destination, played_callback, client_channel_id, hotjoin_only, is_skippable, wait_for_player_input, popup_info)
		local result = func(self, cinematic_scene_name, category, optional_scene_unit_origin, optional_scene_unit_destination, played_callback, client_channel_id, hotjoin_only, is_skippable, wait_for_player_input, popup_info)

		if debug_queue_enabled() then
			record_event(string.format("queue_story result=%s cutscene=%s category=%s story_defs=%d origin=%s destination=%s client_channel=%s hotjoin=%s skippable=%s wait=%s",
				tostring(result),
				as_string(cinematic_scene_name),
				as_string(category),
				story_count_for_category(category, self),
				tostring(optional_scene_unit_origin ~= nil),
				tostring(optional_scene_unit_destination ~= nil),
				as_string(client_channel_id),
				as_string(hotjoin_only),
				as_string(is_skippable),
				as_string(wait_for_player_input)
			))
		end

		return result
	end)
end)

mod.play_selected_cutscene = function()
	play_cutscene(selected_cutscene_name(), "keybind")
end

mod.stop_cutscene = function()
	stop_cutscene()
end

mod.on_setting_changed = function(setting_id)
	local cinematic_name = CUTSCENE_BY_BUTTON[setting_id]

	if cinematic_name and mod:get(setting_id) == true then
		local now = current_time()
		local last_trigger = setting_trigger_times[setting_id]

		if last_trigger and now - last_trigger < SETTING_TRIGGER_COOLDOWN_SECONDS then
			mod:set(setting_id, false)
			write_quiet_line(string.format("setting_trigger ignored setting=%s cutscene=%s reason=cooldown elapsed=%.2f",
				setting_id,
				cinematic_name,
				now - last_trigger
			))

			return
		end

		setting_trigger_times[setting_id] = now

		local previous_mode = mod:get(PLAY_MODE_SETTING_ID)

		mod:set(PLAY_MODE_SETTING_ID, "direct")
		play_cutscene(cinematic_name, "setting-direct")

		if previous_mode and previous_mode ~= "direct" then
			mod:set(PLAY_MODE_SETTING_ID, previous_mode)
		end

		mod:set(setting_id, false)
	end
end

mod.update = function()
	local now = current_time()

	update_scan(now)

	if pending_check and now >= pending_check.time then
		local cinematic_name = pending_check.cinematic_name
		local system = cinematic_scene_system()
		local current = safe_method(system, "current_cinematic_name")
		local active = safe_method(system, "is_active")
		local left = system and rawget(system, "_cinematics_left_to_play")

		write_line(string.format("post_check cutscene=%s current=%s active=%s left=%s",
			cinematic_name,
			as_string(current),
			as_string(active),
			as_string(left)
		))
		log_cutscene_inspect(cinematic_name)

		pending_check = nil

		if cleanup_empty_active_enabled() and active == true and current == cinematic_name and left == 0 then
			write_line(string.format("cleanup_empty_active firing cutscene=%s", cinematic_name))
			stop_cutscene()

			return
		end
	end

	if pending_auto_stop and now >= pending_auto_stop.time then
		write_line(string.format("auto_stop firing cutscene=%s", pending_auto_stop.cinematic_name))
		stop_cutscene()
	end
end

mod:command("cinema", "Cinema cutscene tester. Usage: /cinema help", function(first, ...)
	local args = split_args(command_line(first, ...))
	local command = args[1] or "help"

	if command == "help" then
		log_help()
	elseif command == "list" then
		list_cutscenes(args[2])
	elseif command == "play" then
		local cinematic_name = resolve_cutscene(args[2])

		if cinematic_name then
			play_cutscene(cinematic_name, "command")
		else
			write_line("usage: /cinema play [selected|index|cutscene_name]")
		end
	elseif command == "direct" then
		local cinematic_name = resolve_cutscene(args[2])

		if cinematic_name then
			local previous_mode = mod:get(PLAY_MODE_SETTING_ID)

			mod:set(PLAY_MODE_SETTING_ID, "direct")
			play_cutscene(cinematic_name, "command-direct")

			if previous_mode and previous_mode ~= "direct" then
				mod:set(PLAY_MODE_SETTING_ID, previous_mode)
			end
		else
			write_line("usage: /cinema direct [selected|index|cutscene_name]")
		end
	elseif command == "noalign" then
		local cinematic_name = resolve_cutscene(args[2])

		if cinematic_name then
			local previous_mode = mod:get(PLAY_MODE_SETTING_ID)

			mod:set(PLAY_MODE_SETTING_ID, "direct")
			play_cutscene(cinematic_name, "command-noalign", true, { queue_mode = "noalign" })

			if previous_mode and previous_mode ~= "direct" then
				mod:set(PLAY_MODE_SETTING_ID, previous_mode)
			end
		else
			write_line("usage: /cinema noalign [selected|index|cutscene_name]")
		end
	elseif command == "scene" then
		local cinematic_name = resolve_cutscene(args[2])

		if cinematic_name then
			local previous_mode = mod:get(PLAY_MODE_SETTING_ID)

			mod:set(PLAY_MODE_SETTING_ID, "direct")
			play_cutscene(cinematic_name, "command-scene", true)

			if previous_mode and previous_mode ~= "direct" then
				mod:set(PLAY_MODE_SETTING_ID, previous_mode)
			end
		else
			write_line("usage: /cinema scene [selected|index|cutscene_name]")
		end
	elseif command == "video" then
		local template_name, cinematic_name = resolve_video_template(args[2])

		if template_name then
			local ok, err = play_video_template(template_name, "command-video", cinematic_name)

			if not ok then
				write_line(string.format("video_play failed template=%s error=%s", template_name, as_string(err)))
			end
		else
			write_line("usage: /cinema video [selected|index|cutscene_name|template_name]")
		end
	elseif command == "selected" then
		local cinematic_name = resolve_cutscene(args[2])

		if cinematic_name then
			mod:set(SELECTED_CUTSCENE_SETTING_ID, cinematic_name)
			write_line(string.format("selected=%s", cinematic_name))
		else
			write_line(string.format("selected=%s", selected_cutscene_name()))
		end
	elseif command == "mode" then
		local mode = args[2]

		if mode == "server" or mode == "local" or mode == "direct" then
			mod:set(PLAY_MODE_SETTING_ID, mode)
		elseif mode and mode ~= "status" then
			write_line("usage: /cinema mode [server|local|direct]")
			return
		end

		write_line(string.format("mode=%s", as_string(mod:get(PLAY_MODE_SETTING_ID))))
	elseif command == "inspect" then
		log_cutscene_inspect(args[2])
	elseif command == "stories" then
		dump_registered_stories(args[2])
	elseif command == "history" then
		dump_event_history(args[2])
	elseif command == "candidate" then
		add_story_candidate(args[2], args[3])
	elseif command == "scan" then
		handle_scan_command(args[2])
	elseif command == "filelog" then
		local value = args[2] or "status"

		if value == "on" then
			mod:set("write_to_file", true)
			reset_log_file()
			log_file_status()
		elseif value == "off" then
			mod:set("write_to_file", false)
			log_file_status()
		elseif value == "clear" then
			clear_log_file()
		elseif value == "path" or value == "status" then
			log_file_status()
		else
			write_line("usage: /cinema filelog [on|off|clear|path|status]")
		end
	elseif command == "autostop" then
		local seconds = tonumber(args[2])

		if seconds then
			mod:set("auto_stop_seconds", math.max(0, seconds))
		end

		write_line(string.format("auto_stop_seconds=%.1f", auto_stop_seconds()))
	elseif command == "manual" then
		local value = args[2]

		if value == "on" then
			mod:set("manual_register_stories", true)
		elseif value == "off" then
			mod:set("manual_register_stories", false)
		elseif value and value ~= "status" then
			write_line("usage: /cinema manual [on|off|status]")
			return
		end

		write_line(string.format("manual_register_stories=%s", tostring(manual_register_enabled())))
	elseif command == "cleanup" then
		local value = args[2]

		if value == "on" then
			mod:set("cleanup_empty_active", true)
		elseif value == "off" then
			mod:set("cleanup_empty_active", false)
		elseif value and value ~= "status" then
			write_line("usage: /cinema cleanup [on|off|status]")
			return
		end

		write_line(string.format("cleanup_empty_active=%s", tostring(cleanup_empty_active_enabled())))
	elseif command == "debug" then
		local value = args[2]

		if value == "on" then
			mod:set("debug_queue_story", true)
		elseif value == "off" then
			mod:set("debug_queue_story", false)
		elseif value and value ~= "status" then
			write_line("usage: /cinema debug [on|off|status]")
			return
		end

		write_line(string.format("debug_queue_story=%s", tostring(debug_queue_enabled())))
	elseif command == "anchor" then
		local value = args[2]

		if value == "on" then
			mod:set("origin_anchor_scene_playback", true)
		elseif value == "off" then
			mod:set("origin_anchor_scene_playback", false)
		elseif value and value ~= "status" then
			write_line("usage: /cinema anchor [on|off|status]")
			return
		end

		write_line(string.format("origin_anchor_scene_playback=%s", tostring(origin_anchor_enabled())))
	elseif command == "borrow" then
		local value = args[2]

		if value == "on" then
			mod:set("borrow_destination_scene_playback", true)
		elseif value == "off" then
			mod:set("borrow_destination_scene_playback", false)
		elseif value and value ~= "status" then
			write_line("usage: /cinema borrow [on|off|status]")
			return
		end

		write_line(string.format("borrow_destination_scene_playback=%s", tostring(borrow_destination_enabled())))
	elseif command == "unaligned" then
		local value = args[2]

		if value == "on" then
			mod:set("allow_unaligned_scene_playback", true)
		elseif value == "off" then
			mod:set("allow_unaligned_scene_playback", false)
		elseif value and value ~= "status" then
			write_line("usage: /cinema unaligned [on|off|status]")
			return
		end

		write_line(string.format("allow_unaligned_scene_playback=%s", tostring(allow_unaligned_enabled())))
	elseif command == "stop" then
		stop_cutscene()
	elseif command == "status" then
		log_status()
	else
		write_line(string.format("unknown command=%s", command))
		log_help()
	end
end)
