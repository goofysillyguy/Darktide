return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Cinema` encountered an error loading the Darktide Mod Framework.")

		new_mod("Cinema", {
			mod_script       = "Cinema/scripts/mods/Cinema/Cinema",
			mod_data         = "Cinema/scripts/mods/Cinema/Cinema_data",
			mod_localization = "Cinema/scripts/mods/Cinema/Cinema_localization",
		})
	end,
	packages = {},
}
