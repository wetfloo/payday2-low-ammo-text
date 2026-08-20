Hooks:Add(
	"MenuManagerSetupCustomMenus",
	"MenuManagerSetupCustomMenus_LowAmmoText",
	function(_menu_manager, _nodes)
		MenuHelper:LoadFromJsonFile(
			LowAmmoText.mod_path .. "menus/blt_options.json",
			LowAmmoText,
			-- TODO: setting it like this is bad,
			-- because we don't have a way to set other values.
			LowAmmoText._data.text_offset
		)

		-- Add our own callbacks to handle menu value changes
		MenuCallbackHandler.low_ammo_text__menu_callback__indicator_offset_y = function(_self, item)
			local val = item:value()

			LowAmmoText._data.text_offset.y = val

			if LowAmmoText.rendered_text then
				LowAmmoText.rendered_text:set_offset_y(val)
			end
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
