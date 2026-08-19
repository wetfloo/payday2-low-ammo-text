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

local function text_size_to_rendered(text)
	local x, y, w, h = text:text_rect()
	text:set_size(w, h)
	return text, x, y, w, h
end

local function apply_and_render(panel, params, name, color)
	local params_owned = {}

	for k, v in pairs(params) do
		params_owned[k] = v
	end

	-- We expect the caller to provide us the correct coordinates later.
	params_owned.x = nil
	params_owned.y = nil

	if name then
		params_owned.name = name
	end
	if color then
		params_owned.color = color
	end

	return panel:text(params_owned)
end

local function shadowed_text(panel, params, shadow_offset, shadow_color)
	shadow_color = shadow_color or Color.black

	local result_text
	local result_shadow

	local text_name = params.name
	local shadow_name = params.name .. "_text_shadow"

	-- Re-use previous text shadow instance if we simply update text.
	-- Shadows must be rendered *before* text to not overlap.
	local prev_shadow = panel:child(shadow_name)
	if prev_shadow and alive(prev_shadow) then
		result_shadow = prev_shadow
		result_shadow:set_text(params.text)
	else
		result_shadow = apply_and_render(panel, params, shadow_name, shadow_color)
		text_size_to_rendered(result_shadow)
		result_shadow:set_center(params.x, params.y)
		result_shadow:move(shadow_offset.x, shadow_offset.y)
	end

	-- Re-use previous text instance if we simply update text.
	local prev_text = panel:child(text_name)
	if prev_text and alive(prev_text) then
		result_text = prev_text
		result_text:set_text(params.text)
	else
		result_text = apply_and_render(panel, params, text_name)
		text_size_to_rendered(result_text)
		result_text:set_center(params.x, params.y)
	end

	return result_text, result_shadow
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

		local max_clip = equipped_unit:base():get_ammo_max_per_clip()
		local current_left = equipped_unit:base():get_ammo_total()
		local current_clip = equipped_unit:base():get_ammo_remaining_in_clip()
		local low_ammo = current_left <= math.round(max_clip / 2)
		local low_ammo_clip = current_clip <= math.round(max_clip / 4)
		local out_of_ammo = current_left <= 0

		local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)

		local center_x = hud.panel:w() / 2
		local center_y = hud.panel:h() / 2

		local text, shadow = shadowed_text(hud.panel, {
			name = "low_ammo_text__ammo_indicator",
			text = string.format("%d :: %d", current_clip, current_left),
			font = tweak_data.menu.pd2_medium_font,
			font_size = 16,
			color = Color.white,
			x = center_x,
			y = center_y + LowAmmoText._data.offset_y,
		}, { x = 1, y = 1 })

		-- shadow:set_center(center_x, center_y)

		-- if low_ammo_clip and not out_of_ammo and not low_ammo then
		-- 	return hook_indicator("low_ammo_clip", { low_ammo, low_ammo_clip, out_of_ammo })
		-- end
		--
		-- if low_ammo and not out_of_ammo then
		-- 	return hook_indicator("low_ammo", { low_ammo, low_ammo_clip, out_of_ammo })
		-- end
		--
		-- if out_of_ammo then
		-- 	return hook_indicator("out_of_ammo", { low_ammo, low_ammo_clip, out_of_ammo })
		-- end
		--
		-- return hook_indicator("check", { low_ammo, low_ammo_clip, out_of_ammo })
	end)
end

if delayed then
	DelayedCalls:Add("LowAmmoText_hudmanager_delayed", 2, add_hook)
else
	add_hook()
end
