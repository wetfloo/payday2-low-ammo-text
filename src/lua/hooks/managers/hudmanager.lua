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
		local function shadowed_text(panel, params, text_color, shadow_color, shadow_offset)
			local function apply_and_render(name, color, offset)
				local params_owned = {}

				for k, v in pairs(params) do
					params_owned[k] = v
				end

				if name then
					params_owned.name = name
				end
				if color then
					params_owned.color = color
				end
				if offset then
					if params_owned.x and offset.x then
						params_owned.x = params_owned.x + offset.x
					end
					if params_owned.y and offset.y then
						params_owned.y = params_owned.y + offset.y
					end
				end

				panel:text(params_owned)
			end

			local text_name = params.name
			local shadow_name = params.name .. "_text_shadow"

			-- Re-use previous text shadow instance if we simply update text.
			-- Shadows must be rendered *before* text to not overlap.
			local shadow_prev = panel:child(shadow_name)
			if shadow_prev and alive(shadow_prev) then
				shadow_prev:set_text(params.text)
			else
				apply_and_render(shadow_name, shadow_color, shadow_offset)
			end

			-- Re-use previous text instance if we simply update text.
			local text_prev = panel:child(text_name)
			if text_prev and alive(text_prev) then
				text_prev:set_text(params.text)
			else
				apply_and_render(text_name, text_color, nil)
			end
		end

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

		local center_w = hud.panel:w() / 2
		local center_h = hud.panel:h() / 2

		shadowed_text(hud.panel, {
			name = "low_ammo_text__test_text",
			text = string.format("%d :: %d", current_clip, current_left),
			font = tweak_data.menu.pd2_medium_font,
			font_size = 16,
			x = center_w,
			y = center_h,
		}, Color.white, Color.black, { x = 1, y = 1 })

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
