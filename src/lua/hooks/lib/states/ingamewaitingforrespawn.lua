Hooks:PostHook(IngameWaitingForRespawnState, "at_enter", "LowAmmoText__posthook__custody_enter_handler", function (_self)
	if LowAmmoText.ammo_state_manager then
		LowAmmoText.ammo_state_manager:destroy()
		LowAmmoText.ammo_state_manager = nil
	end
end)
