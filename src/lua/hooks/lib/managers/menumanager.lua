Hooks:Add(
	"MenuManagerSetupCustomMenus",
	"MenuManagerSetupCustomMenus_" .. LowAmmoText.mod_name,
	function(_menu_manager, _nodes)
		LowAmmoText:load_configuration()

		MenuHelper:LoadFromJsonFile(
			LowAmmoText.mod_path .. "menus/blt_options.json",
			LowAmmoText,
			LowAmmoText._data
		)

		-- Add our own callbacks to handle menu value changes
		MenuCallbackHandler.low_ammo_text__menu_callback__text_font_size = function(_self, item)
			local val = item:value()

			LowAmmoText._data.text_font_size = val

			if LowAmmoText.ammo_state_manager then
				LowAmmoText.ammo_state_manager:set_font_size(val)
			end
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__text_offset_x = function(_self, item)
			local val = item:value()

			LowAmmoText._data.text_offset_x = val

			if LowAmmoText.ammo_state_manager then
				LowAmmoText.ammo_state_manager:set_offset_x(val)
			end
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__text_offset_y = function(_self, item)
			local val = item:value()

			LowAmmoText._data.text_offset_y = val

			if LowAmmoText.ammo_state_manager then
				LowAmmoText.ammo_state_manager:set_offset_y(val)
			end
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__text_alpha = function(_self, item)
			local val = item:value()

			LowAmmoText._data.text_alpha = val

			if LowAmmoText.ammo_state_manager then
				LowAmmoText.ammo_state_manager:set_alpha(val)
			end
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__text_fade_duration_millis = function(
			_self,
			item
		)
			LowAmmoText._data.text_fade_duration_millis = item:value()
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__threshold_low_ammo_clip_percent = function(
			_self,
			item
		)
			LowAmmoText._data.threshold_low_ammo_clip_percent = item:value()
		end

		---@deprecated
		MenuCallbackHandler.low_ammo_text__menu_callback__threshold_low_ammo_total_from_clip_percent = function(
			_self,
			item
		)
			LowAmmoText._data.threshold_low_ammo_total_from_clip_percent = item:value()
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__threshold_low_ammo_total_percent = function(
			_self,
			item
		)
			LowAmmoText._data.threshold_low_ammo_total_percent = item:value()
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__pulse_text_animation_start = function(
			_self,
			item
		)
			LowAmmoText._data.pulse_text_animation_start = item:value()
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__pulse_text_animation_speed_mul_log = function(
			_self,
			item
		)
			LowAmmoText._data.pulse_text_animation_speed_mul_log = item:value()
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__closed = function(_self)
			LowAmmoText:save_configuration()
		end
	end
)
