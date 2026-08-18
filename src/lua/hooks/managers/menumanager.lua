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
		MenuCallbackHandler.low_ammo_text__menu_callback__test_slider = function(_self, item)
			LowAmmoText._data.test_value = item:value()
			log(item:value())
		end

		MenuCallbackHandler.low_ammo_text__menu_callback__closed = function(_self)
			log("closed!")
		end
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
