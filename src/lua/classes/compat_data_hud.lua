---@class CompatDataHUD
---@field hook_class BLTHookClass
---@field hook_fn BLTHookFunctionName
---@field hook_delay_secs number|nil

LowAmmoText.CompatDataHUD = LowAmmoText.CompatDataHUD or class()

---@enum CompatDataHUDType
LowAmmoText.CompatDataHUD.HUDType = LowAmmoText.CompatDataHUD.HUDType
	or {
		["Auto"] = 0,
		["Holo"] = 1,
		["VoidUI"] = 2,
		["MUI"] = 3,
		["PDTHHud"] = 4,
	}

---@class CompatDataHUD
---@param hud_compat_override CompatDataHUDType
function LowAmmoText.CompatDataHUD:init(hud_compat_override)
	self.hook_class = HUDTeammate
	self.hook_fn = "set_ammo_amount_by_type"
	self.hook_delay_secs = nil

	local delayed = false

	if hud_compat_override == self.HUDType.MUI then
		---@diagnostic disable-next-line: undefined-global
		self.hook_class = MUITeammate
		delayed = true
	elseif
		hud_compat_override == self.HUDType.PDTHHud
		or hud_compat_override == self.HUDType.VoidUI
		or hud_compat_override == self.HUDType.Holo
	then
		self.hook_class = HUDManager
		self.hook_fn = "set_teammate_ammo_amount"
		delayed = true
	end

	if delayed then
		self.hook_delay_secs = 2
	end
end
