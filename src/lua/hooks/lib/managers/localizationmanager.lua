Hooks:Add(
	"LocalizationManagerPostInit",
	"LocalizationManagerPostInit_" .. LowAmmoText.mod_name .. "_LoadLocStrings",
	function(loc_manager)
		loc_manager:load_localization_file(LowAmmoText.mod_path .. "loc/en.json")
	end
)
