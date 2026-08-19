local hook_class = HUDTeammate
local hook_fn = "set_ammo_amount_by_type"
local delayed = false

---@diagnostic disable-next-line: undefined-global
if MUIMenu and MUITeammate then
	---@diagnostic disable-next-line: undefined-global
	hook_class = MUITeammate
	delayed = true
	---@diagnostic disable-next-line: undefined-global
elseif PDTHHud or VoidUI or Holo then
	hook_class = HUDManager
	hook_fn = "set_teammate_ammo_amount"
	delayed = true
end

local function add_hook()
	Hooks:PostHook(hook_class, hook_fn, "LowAmmoText_set_teammate_ammo_amount", function(_self)
		LowAmmoText.render.update_text()
	end)
end

if delayed then
	DelayedCalls:Add("LowAmmoText_hudmanager_delayed", 2, add_hook)
else
	add_hook()
end
