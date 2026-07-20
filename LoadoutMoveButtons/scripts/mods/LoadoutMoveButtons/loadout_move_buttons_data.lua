local mod = get_mod("LoadoutMoveButtons")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "enable_move_buttons",
				type = "checkbox",
				default_value = true,
				tooltip = "enable_move_buttons_tooltip",
			},
		},
	},
}
