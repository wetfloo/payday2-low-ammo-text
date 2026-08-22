Hooks:Add(
	"MenuManagerSetupCustomMenus",
	"MenuManagerSetupCustomMenus_LowAmmoText",
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

			if LowAmmoText.rendered_text then
				LowAmmoText.rendered_text:set_font_size(val)
			end
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__text_offset_x = function(_self, item)
			local val = item:value()

			LowAmmoText._data.text_offset_x = val

			if LowAmmoText.rendered_text then
				LowAmmoText.rendered_text:set_offset_x(val)
			end
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__text_offset_y = function(_self, item)
			local val = item:value()

			LowAmmoText._data.text_offset_y = val

			if LowAmmoText.rendered_text then
				LowAmmoText.rendered_text:set_offset_y(val)
			end
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__text_alpha = function(_self, item)
			local val = item:value()

			LowAmmoText._data.text_alpha = val

			if LowAmmoText.rendered_text then
				LowAmmoText.rendered_text:set_alpha(val)
			end
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__closed = function(_self)
			LowAmmoText:save_configuration()
		end
	end
)
