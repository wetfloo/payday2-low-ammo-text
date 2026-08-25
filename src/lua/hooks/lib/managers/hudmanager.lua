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

---@return LowAmmoText.AmmoStateManager
local function get_or_init_ammo_state_manager()
	if LowAmmoText.ammo_state_manager then
		return LowAmmoText.ammo_state_manager
	end

	local rendered_text = LowAmmoText.RenderedText:new({
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
	local ammo_state_manager = LowAmmoText.AmmoStateManager:new(rendered_text)

	LowAmmoText.ammo_state_manager = ammo_state_manager
	return ammo_state_manager
end

local function init_hooks()
	Hooks:PostHook(
		hook_class,
		hook_fn,
		LowAmmoText.mod_name .. "__posthook__ammo_state_handler",
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

			local ammo_state_manager = get_or_init_ammo_state_manager()

			local max_clip = equipped_unit:base():get_ammo_max_per_clip()
			local max_total = equipped_unit:base():get_ammo_max()
			local current_clip = equipped_unit:base():get_ammo_remaining_in_clip()
			local current_total = equipped_unit:base():get_ammo_total()

			ammo_state_manager:update_state_values({
				no_ammo = current_total <= 0,
				low_total_ammo = current_total
					<= max_total * LowAmmoText._data.threshold_low_ammo_total,
				clip_empty = current_clip <= 0,
				low_ammo_clip = current_clip
					<= max_clip * LowAmmoText._data.threshold_low_ammo_clip,
			})
		end
	)

	Hooks:PostHook(
		PlayerManager,
		"add_to_temporary_property",
		LowAmmoText.mod_name .. "__posthook__bulletstorm_state_handler",
		function(_self, name, time, _value)
			if name ~= "bullet_storm" or not time then
				return
			end

			local ammo_state_manager = get_or_init_ammo_state_manager()

			ammo_state_manager:update_state_values({ bulletstorm = true })
			DelayedCalls:Add(LowAmmoText.mod_name .. "__delayed__bulletstorm_handle_reset", time, function()
				ammo_state_manager:update_state_values({ bulletstorm = false })
			end)
		end
	)

	Hooks:PostHook(
		PlayerManager,
		"activate_temporary_upgrade",
		LowAmmoText.mod_name .. "__posthook__swan_song_aced_state_handler",
		function(self, category, upgrade)
			-- Why is Swan Song called... that?
			-- I don't know, ask whoever programmed this shit.
			if upgrade ~= "berserker_damage_multiplier" then
				return
			end

			-- Pulled from game's code
			local upgrade_value = self:upgrade_value(category, upgrade)
			if not upgrade_value then
				return
			end
			local time = upgrade_value[2]

			local ammo_state_manager = get_or_init_ammo_state_manager()

			ammo_state_manager:update_state_values({ swan_song_aced = true })
			DelayedCalls:Add(LowAmmoText.mod_name .. "__delayed__swan_song_aced_handle_reset", time, function()
				ammo_state_manager:update_state_values({ swan_song_aced = false })
			end)
		end
	)

	Hooks:PostHook(hook_class, "destroy", LowAmmoText.mod_name .. "__posthook__cleanup_handler", function(_self)
		if LowAmmoText.ammo_state_manager then
			LowAmmoText.ammo_state_manager:destroy()
			LowAmmoText.ammo_state_manager = nil
		end
	end)
end

if delayed then
	DelayedCalls:Add(LowAmmoText.mod_name .. "__delayed__init_hooks", 2, init_hooks)
else
	init_hooks()
end
