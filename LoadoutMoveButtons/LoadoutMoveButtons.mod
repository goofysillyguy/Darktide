return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`LoadoutMoveButtons` encountered an error loading the Darktide Mod Framework.")

		new_mod("LoadoutMoveButtons", {
			mod_script       = "LoadoutMoveButtons/scripts/mods/LoadoutMoveButtons/loadout_move_buttons",
			mod_data         = "LoadoutMoveButtons/scripts/mods/LoadoutMoveButtons/loadout_move_buttons_data",
			mod_localization = "LoadoutMoveButtons/scripts/mods/LoadoutMoveButtons/loadout_move_buttons_localization",
		})
	end,
	packages = {},
}
