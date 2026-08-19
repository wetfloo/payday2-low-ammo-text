Hooks:Add(
	"MenuManagerSetupCustomMenus",
	"MenuManagerSetupCustomMenus_LowAmmoText",
	function(_menu_manager, _nodes)
		MenuHelper:LoadFromJsonFile(
			LowAmmoText.mod_path .. "menus/blt_options.json",
			LowAmmoText,
			LowAmmoText._data
		)

		-- Add our own callbacks to handle menu value changes
		MenuCallbackHandler.low_ammo_text__menu_callback__indicator_offset_y = function(_self, item)
			local value = item:value()
			local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)

			LowAmmoText._data.offset_y = value

			local text = LowAmmoText._rendered_indicators.text
			local shadow = LowAmmoText._rendered_indicators.shadow

			local text_x, text_y = text:center()
			local shadow_x, shadow_y = shadow:center()
			local shadow_offset_x = shadow_x - text_x
			local shadow_offset_y = shadow_y - text_y

			text_y = (hud.panel:w() / 2) + value
			shadow_x = shadow_x + shadow_offset_x
			shadow_y = text_y + shadow_offset_y

			text:set_center(text_x, text_y)
			shadow:set_center(shadow_x, shadow_y)
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__closed = function(_self) end
	end
)

Hooks:Add(
	"MenuManagerPopulateCustomMenus",
	"MenuManagerPopulateCustomMenus_LowAmmoText",
	function(_menu_manager, _nodes) end
)

Hooks:Add(
	"MenuManagerBuildCustomMenus",
	"MenuManagerBuildCustomMenus_LowAmmoText",
	function(_menu_manager, _nodes) end
)
