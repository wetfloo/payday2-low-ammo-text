LowAmmoText.tbl = LowAmmoText.tbl or {}

function LowAmmoText.tbl.shallow_copy(tbl)
	local result = {}

	for k, v in pairs(tbl) do
		result[k] = v
	end

	return result
end
