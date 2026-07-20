local mod = get_mod("FovUnlocked")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "enabled",
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "vertical_fov",
				type = "numeric",
				default_value = 65,
				range = { 45, 120 },
			},
		},
	},
}
