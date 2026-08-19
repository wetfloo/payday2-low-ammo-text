LowAmmoText.render = LowAmmoText.render or {}

local function hud_center(hud)
	local w = hud.panel:w() / 2
	local h = hud.panel:h() / 2
	return w, h
end

local function set_text_panel_size_to_rendered(panel)
	local _, _, w, h = panel:text_rect()
	panel:set_size(w, h)

	return panel, w, h
end

local function find_or_create(name, params_common)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	local panel = hud.panel

	local text_name = name
	local shadow_name = name .. "_text_shadow"

	local result_text = panel:child(text_name)
	local result_shadow = panel:child(shadow_name)

	local w, h = hud_center(hud)
	local text_offset = LowAmmoText._data.text_offset
	w = w + text_offset.x
	h = h + text_offset.y

	if not result_text or not alive(result_text) then
		local params = LowAmmoText.tbl.shallow_copy(params_common)
		params.name = name
		params.color = Color.white

		result_text = panel:text(params)
	end

	if not result_shadow or not alive(result_shadow) then
		local params = LowAmmoText.tbl.shallow_copy(params_common)
		params.name = name .. "_text_shadow"
		params.color = Color.black

		result_shadow = panel:text(params)
	end

	-- Updating text could cause the text size to change,
	-- so we handle that by re-centering and moving each time.
	set_text_panel_size_to_rendered(result_text)
	result_text:set_center(w, h)

	set_text_panel_size_to_rendered(result_shadow)
	result_shadow:set_center(w, h)
	result_shadow:move(1, 1)

	return result_text, result_shadow
end

LowAmmoText.render.update_text = function()
	if not managers.player:player_unit() then
		return
	end

	local equipped_unit = managers.player:player_unit():movement():current_state()._equipped_unit
	if
		not equipped_unit
		or not alive(equipped_unit)
		or equipped_unit ~= managers.player:equipped_weapon_unit()
	then
		return
	end

	local current_left = equipped_unit:base():get_ammo_total()
	local current_clip = equipped_unit:base():get_ammo_remaining_in_clip()

	return find_or_create("low_ammo_text__ammo_indicator", {
		text = string.format("%d :: %d", current_clip, current_left),
		font = tweak_data.menu.pd2_medium_font,
		font_size = 16,
	})
end
