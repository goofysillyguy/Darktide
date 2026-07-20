return {
	mod_name = {
		en = "Cinema",
	},
	mod_description = {
		en = "Solo cutscene tester for quickly playing Darktide cinematics from mod settings or chat commands.",
	},
	echo_to_chat = {
		en = "Echo Output to Chat",
	},
	echo_to_chat_description = {
		en = "Shows Cinema command output locally in chat.",
	},
	write_to_file = {
		en = "Write Output to File",
	},
	write_to_file_description = {
		en = "Writes Cinema output to F:/Source/dt/Cinema.log when available.",
	},
	clear_file_on_load = {
		en = "Clear File on Load",
	},
	clear_file_on_load_description = {
		en = "Starts a fresh Cinema.log each time the mod initializes.",
	},
	play_mode = {
		en = "Play Mode",
	},
	play_mode_description = {
		en = "Direct Local loads and plays locally without RPC. Server Request asks the normal cinematic RPC path. Local Direct invokes the local cinematic system without manual story registration.",
	},
	play_mode_direct = {
		en = "Direct Local",
	},
	play_mode_server = {
		en = "Server Request",
	},
	play_mode_local = {
		en = "Local Direct",
	},
	selected_cutscene = {
		en = "Selected Cutscene",
	},
	selected_cutscene_description = {
		en = "Cutscene used by the Play Selected keybind and /cinema play selected.",
	},
	auto_stop_seconds = {
		en = "Auto Stop Seconds",
	},
	auto_stop_seconds_description = {
		en = "Automatically runs Cinema stop after this many seconds. Set to 0 to disable.",
	},
	cleanup_empty_active = {
		en = "Cleanup Empty Active Cutscenes",
	},
	cleanup_empty_active_description = {
		en = "Automatically stops a cutscene if Darktide marks it active but no cinematic stories are queued.",
	},
	manual_register_stories = {
		en = "Manual Story Registration",
	},
	manual_register_stories_description = {
		en = "Attempts to register validated cinematic story names for server/local mode experiments. Direct Local enables this only for its current cutscene.",
	},
	origin_anchor_scene_playback = {
		en = "Origin-Anchored Scene Playback",
	},
	origin_anchor_scene_playback_description = {
		en = "Experimental. For loaded scene cutscenes with an origin and camera but no destination marker, attempts to align the story to its own origin. Some cutscenes can place units outside the hub and crash.",
	},
	borrow_destination_scene_playback = {
		en = "Borrow Destination Marker",
	},
	borrow_destination_scene_playback_description = {
		en = "Experimental. For loaded scene cutscenes with an origin and camera but no destination marker, attempts to use a current-level destination marker from another cutscene.",
	},
	allow_unaligned_scene_playback = {
		en = "Allow Unaligned Scene Playback",
	},
	allow_unaligned_scene_playback_description = {
		en = "Allows scene stories with no destination alignment unit to queue. These are useful for experiments but can play in the wrong place or with missing presentation.",
	},
	debug_queue_story = {
		en = "Log Queue Story Attempts",
	},
	debug_queue_story_description = {
		en = "Logs each CinematicManager queue_story result while testing cutscenes.",
	},
	play_selected_key = {
		en = "Play Selected Cutscene",
	},
	play_selected_key_description = {
		en = "Keybind that plays the currently selected cutscene.",
	},
	stop_cutscene_key = {
		en = "Stop Cutscene",
	},
	stop_cutscene_key_description = {
		en = "Keybind that closes cutscene views and resets local cinematic state.",
	},
	cutscene_buttons = {
		en = "Cutscene Triggers",
	},
	cutscene_buttons_description = {
		en = "Toggle a cutscene on to play it. Cinema automatically resets the toggle off after sending the request.",
	},
	cutscene_option_01 = { en = "Cutscene 1" },
	cutscene_option_02 = { en = "Cutscene 2" },
	cutscene_option_03 = { en = "Cutscene 3" },
	cutscene_option_04 = { en = "Cutscene 4" },
	cutscene_option_05 = { en = "Cutscene 5" },
	cutscene_option_06 = { en = "Cutscene 5 Hub" },
	cutscene_option_07 = { en = "Cutscene 6" },
	cutscene_option_08 = { en = "Cutscene 7" },
	cutscene_option_09 = { en = "Cutscene 8" },
	cutscene_option_10 = { en = "Cutscene 9" },
	cutscene_option_11 = { en = "Cutscene 10" },
	cutscene_option_12 = { en = "Intro ABC" },
	cutscene_option_13 = { en = "Outro Win" },
	cutscene_option_14 = { en = "Outro Fail" },
	cutscene_option_15 = { en = "Hub Intro: Barber" },
	cutscene_option_16 = { en = "Hub Intro: Contracts" },
	cutscene_option_17 = { en = "Hub Intro: Crafting" },
	cutscene_option_18 = { en = "Hub Intro: Gun Shop" },
	cutscene_option_19 = { en = "Hub Intro: Mission Board" },
	cutscene_option_20 = { en = "Hub Intro: Training Grounds" },
	cutscene_option_21 = { en = "Path of Trust 01" },
	cutscene_option_22 = { en = "Path of Trust 02" },
	cutscene_option_23 = { en = "Path of Trust 03" },
	cutscene_option_24 = { en = "Path of Trust 04" },
	cutscene_option_25 = { en = "Path of Trust 05" },
	cutscene_option_26 = { en = "Path of Trust 06" },
	cutscene_option_27 = { en = "Path of Trust 07" },
	cutscene_option_28 = { en = "Path of Trust 08" },
	cutscene_option_29 = { en = "Path of Trust 09" },
	cutscene_option_30 = { en = "Traitor Captain Intro" },
	play_cutscene_01 = { en = "Play Cutscene 1" },
	play_cutscene_02 = { en = "Play Cutscene 2" },
	play_cutscene_03 = { en = "Play Cutscene 3" },
	play_cutscene_04 = { en = "Play Cutscene 4" },
	play_cutscene_05 = { en = "Play Cutscene 5" },
	play_cutscene_06 = { en = "Play Cutscene 5 Hub" },
	play_cutscene_07 = { en = "Play Cutscene 6" },
	play_cutscene_08 = { en = "Play Cutscene 7" },
	play_cutscene_09 = { en = "Play Cutscene 8" },
	play_cutscene_10 = { en = "Play Cutscene 9" },
	play_cutscene_11 = { en = "Play Cutscene 10" },
	play_cutscene_12 = { en = "Play Intro ABC" },
	play_cutscene_13 = { en = "Play Outro Win" },
	play_cutscene_14 = { en = "Play Outro Fail" },
	play_cutscene_15 = { en = "Play Hub Intro: Barber" },
	play_cutscene_16 = { en = "Play Hub Intro: Contracts" },
	play_cutscene_17 = { en = "Play Hub Intro: Crafting" },
	play_cutscene_18 = { en = "Play Hub Intro: Gun Shop" },
	play_cutscene_19 = { en = "Play Hub Intro: Mission Board" },
	play_cutscene_20 = { en = "Play Hub Intro: Training Grounds" },
	play_cutscene_21 = { en = "Play Path of Trust 01" },
	play_cutscene_22 = { en = "Play Path of Trust 02" },
	play_cutscene_23 = { en = "Play Path of Trust 03" },
	play_cutscene_24 = { en = "Play Path of Trust 04" },
	play_cutscene_25 = { en = "Play Path of Trust 05" },
	play_cutscene_26 = { en = "Play Path of Trust 06" },
	play_cutscene_27 = { en = "Play Path of Trust 07" },
	play_cutscene_28 = { en = "Play Path of Trust 08" },
	play_cutscene_29 = { en = "Play Path of Trust 09" },
	play_cutscene_30 = { en = "Play Traitor Captain Intro" },
}
