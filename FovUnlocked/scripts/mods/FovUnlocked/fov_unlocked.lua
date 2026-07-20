local mod = get_mod("FovUnlocked")

local Managers = Managers
local Application = Application

local DEFAULT_VFOV = 65

local cfg = {}

local function refresh_settings()
    cfg.enabled     = mod:get("enabled") ~= false
    cfg.target_vfov = mod:get("vertical_fov") or DEFAULT_VFOV
    cfg.multiplier  = cfg.target_vfov / DEFAULT_VFOV
end
refresh_settings()

local function game_slider_multiplier()
    local vfov = Application.user_setting("render_settings", "vertical_fov") or DEFAULT_VFOV
    return vfov / DEFAULT_VFOV
end

mod.on_setting_changed = function()
    local was_enabled = cfg.enabled
    refresh_settings()
   
    if was_enabled and not cfg.enabled then
        local cam = Managers.state and Managers.state.camera
        if cam then
            cam:set_fov_multiplier(game_slider_multiplier())
        end
    end
end

mod:hook("CameraManager", "update", function(func, self, dt, t, viewport_name, yaw, pitch, roll)
    if cfg.enabled then
        self._fov_multiplier = cfg.multiplier
    end
    return func(self, dt, t, viewport_name, yaw, pitch, roll)
end)
