LowAmmoText.tbl = LowAmmoText.tbl or {}

LowAmmoText.tbl.shallow_copy = function(tbl)
	local result = {}

	for k, v in pairs(tbl) do
		result[k] = v
	end

	return result
end
