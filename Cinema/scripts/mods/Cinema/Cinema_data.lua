local mod = get_mod("Cinema")

local cutscene_options = {
	{ text = "cutscene_option_01", value = "cutscene_1" },
	{ text = "cutscene_option_02", value = "cutscene_2" },
	{ text = "cutscene_option_03", value = "cutscene_3" },
	{ text = "cutscene_option_04", value = "cutscene_4" },
	{ text = "cutscene_option_05", value = "cutscene_5" },
	{ text = "cutscene_option_06", value = "cutscene_5_hub" },
	{ text = "cutscene_option_07", value = "cutscene_6" },
	{ text = "cutscene_option_08", value = "cutscene_7" },
	{ text = "cutscene_option_09", value = "cutscene_8" },
	{ text = "cutscene_option_10", value = "cutscene_9" },
	{ text = "cutscene_option_11", value = "cutscene_10" },
	{ text = "cutscene_option_12", value = "intro_abc" },
	{ text = "cutscene_option_13", value = "outro_win" },
	{ text = "cutscene_option_14", value = "outro_fail" },
	{ text = "cutscene_option_15", value = "hub_location_intro_barber" },
	{ text = "cutscene_option_16", value = "hub_location_intro_contracts" },
	{ text = "cutscene_option_17", value = "hub_location_intro_crafting" },
	{ text = "cutscene_option_18", value = "hub_location_intro_gun_shop" },
	{ text = "cutscene_option_19", value = "hub_location_intro_mission_board" },
	{ text = "cutscene_option_20", value = "hub_location_intro_training_grounds" },
	{ text = "cutscene_option_21", value = "path_of_trust_01" },
	{ text = "cutscene_option_22", value = "path_of_trust_02" },
	{ text = "cutscene_option_23", value = "path_of_trust_03" },
	{ text = "cutscene_option_24", value = "path_of_trust_04" },
	{ text = "cutscene_option_25", value = "path_of_trust_05" },
	{ text = "cutscene_option_26", value = "path_of_trust_06" },
	{ text = "cutscene_option_27", value = "path_of_trust_07" },
	{ text = "cutscene_option_28", value = "path_of_trust_08" },
	{ text = "cutscene_option_29", value = "path_of_trust_09" },
	{ text = "cutscene_option_30", value = "traitor_captain_intro" },
}

local cutscene_button_widgets = {}

for i = 1, #cutscene_options do
	cutscene_button_widgets[#cutscene_button_widgets + 1] = {
		setting_id = string.format("play_cutscene_%02d", i),
		type = "checkbox",
		default_value = false,
	}
end

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "echo_to_chat",
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "write_to_file",
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "clear_file_on_load",
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "play_mode",
				type = "dropdown",
				default_value = "direct",
				options = {
					{ text = "play_mode_direct", value = "direct" },
					{ text = "play_mode_server", value = "server" },
					{ text = "play_mode_local", value = "local" },
				},
			},
			{
				setting_id = "selected_cutscene",
				type = "dropdown",
				default_value = "hub_location_intro_mission_board",
				options = cutscene_options,
			},
			{
				setting_id = "auto_stop_seconds",
				type = "numeric",
				default_value = 0,
				range = {
					0,
					120,
				},
				decimals_number = 0,
				step_size_value = 5,
			},
			{
				setting_id = "cleanup_empty_active",
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "manual_register_stories",
				type = "checkbox",
				default_value = false,
			},
			{
				setting_id = "origin_anchor_scene_playback",
				type = "checkbox",
				default_value = false,
			},
			{
				setting_id = "borrow_destination_scene_playback",
				type = "checkbox",
				default_value = false,
			},
			{
				setting_id = "allow_unaligned_scene_playback",
				type = "checkbox",
				default_value = false,
			},
			{
				setting_id = "debug_queue_story",
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "play_selected_key",
				type = "keybind",
				default_value = {},
				keybind_global = true,
				keybind_trigger = "pressed",
				keybind_type = "function_call",
				function_name = "play_selected_cutscene",
			},
			{
				setting_id = "stop_cutscene_key",
				type = "keybind",
				default_value = {},
				keybind_global = true,
				keybind_trigger = "pressed",
				keybind_type = "function_call",
				function_name = "stop_cutscene",
			},
			{
				setting_id = "cutscene_buttons",
				type = "group",
				sub_widgets = cutscene_button_widgets,
			},
		},
	},
}
