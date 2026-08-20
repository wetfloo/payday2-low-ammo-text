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

		local current_left = equipped_unit:base():get_ammo_total()
		local current_clip = equipped_unit:base():get_ammo_remaining_in_clip()
		local s = string.format("%s :: %s", current_clip, current_left)

		if not LowAmmoText.rendered_text then
			LowAmmoText.rendered_text = LowAmmoText.RenderedText:new({
				s = s,
				text_configuration = {
					color = Color.white,
					offset = LowAmmoText._data.text_offset,
					font_size = 16,
					font = tweak_data.menu.pd2_medium_font,
				},
				text_shadow_configuration = {
					color = Color.black,
					additional_offset = {
						x = 1,
						y = 1,
					},
				},
			})
		else
			LowAmmoText.rendered_text:set_s(s)
		end
	end)
end

if delayed then
	DelayedCalls:Add("LowAmmoText_hudmanager_delayed", 2, add_hook)
else
	add_hook()
end
