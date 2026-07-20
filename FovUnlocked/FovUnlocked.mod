return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`FovUnlocked` encountered an error loading the Darktide Mod Framework.")

		new_mod("FovUnlocked", {
			mod_script       = "FovUnlocked/scripts/mods/FovUnlocked/fov_unlocked",
			mod_data         = "FovUnlocked/scripts/mods/FovUnlocked/fov_unlocked_data",
			mod_localization = "FovUnlocked/scripts/mods/FovUnlocked/fov_unlocked_localization",
		})
	end,
	packages = {},
}
