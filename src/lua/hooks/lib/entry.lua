Hooks:Add(
	"LocalizationManagerPostInit",
	"LocalizationManagerPostInit_LowAmmoText_LoadLocStrings",
	function(loc_manager)
		loc_manager:load_localization_file(LowAmmoText.mod_path .. "loc/en.json")
	end
)
