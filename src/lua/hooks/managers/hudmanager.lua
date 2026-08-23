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

local function init_hooks()
	Hooks:PostHook(
		hook_class,
		hook_fn,
		"LowAmmoText_set_teammate_ammo_amount_alive",
		function(_self)
			if not managers.player:player_unit() then
				return
			end

			local equipped_unit =
				managers.player:player_unit():movement():current_state()._equipped_unit
			if
				not equipped_unit
				or not alive(equipped_unit)
				or equipped_unit ~= managers.player:equipped_weapon_unit()
			then
				return
			end

			LowAmmoText:load_configuration()

			local max_clip = equipped_unit:base():get_ammo_max_per_clip()
			local current_left = equipped_unit:base():get_ammo_total()
			local current_clip = equipped_unit:base():get_ammo_remaining_in_clip()

			local low_ammo_clip = current_clip
				<= max_clip * LowAmmoText._data.threshold_low_ammo_clip
			local low_ammo = current_left
				<= max_clip * LowAmmoText._data.threshold_low_ammo_total_from_clip
			local no_ammo = current_left <= 0

			if not LowAmmoText.rendered_text then
				LowAmmoText.rendered_text = LowAmmoText.RenderedText:new({
					s = "",
					text_configuration = {
						color = Color.white,
						offset = {
							x = LowAmmoText._data.text_offset_x,
							y = LowAmmoText._data.text_offset_y,
						},
						font_size = LowAmmoText._data.text_font_size,
						font = tweak_data.menu.pd2_large_font,
						alpha = LowAmmoText._data.text_alpha,
					},
					text_shadow_configuration = {
						color = Color.black,
						additional_offset = {
							x = 1,
							y = 1,
						},
					},
				})
			end

			if no_ammo or low_ammo or low_ammo_clip then
				LowAmmoText.rendered_text:show(LowAmmoText._data.text_fade_duration_secs)

				if no_ammo then
					LowAmmoText.rendered_text:set_s(managers.localization:text("low_ammo_text__ammo_state__no_ammo"))
					LowAmmoText.rendered_text:set_text_color(Color(1.0, 0.0, 0.0))
				elseif low_ammo then
					LowAmmoText.rendered_text:set_s(managers.localization:text("low_ammo_text__ammo_state__low_total"))
					LowAmmoText.rendered_text:set_text_color(Color(1.0, 0.5, 0.0))
				elseif low_ammo_clip then
					LowAmmoText.rendered_text:set_s(managers.localization:text("low_ammo_text__ammo_state__low_clip"))
					LowAmmoText.rendered_text:set_text_color(Color(0.9, 0.9, 0.9))
				end
			else
				LowAmmoText.rendered_text:hide(LowAmmoText._data.text_fade_duration_secs)
			end
		end
	)

	Hooks:PostHook(
		hook_class,
		"destroy",
		"LowAmmoText_set_teammate_ammo_amount_destroy",
		function(_self)
			if LowAmmoText.rendered_text then
				LowAmmoText.rendered_text:destroy()
				LowAmmoText.rendered_text = nil
			end
		end
	)
end

if delayed then
	DelayedCalls:Add("LowAmmoText_hudmanager_delayed", 2, init_hooks)
else
	init_hooks()
end
