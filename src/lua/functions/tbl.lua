LowAmmoText.tbl = LowAmmoText.tbl or {}

function LowAmmoText.tbl.shallow_copy(tbl)
	local result = {}

	for k, v in pairs(tbl) do
		result[k] = v
	end

	return result
end

---@param target table
---@param filler table
---@return table
local function fill_missing_rec(target, filler)
	for k, v in pairs(filler) do
		if not target[k] then
			-- No need to worry about inner table structure,
			-- as `filler` should have the entire table
			-- structure for `target`'s missing fields.
			-- If it doesn't, too bad.
			target[k] = filler
		elseif type(target[k]) == "table" and type(v) == "table" then
			fill_missing_rec(target[k], v)
		end
	end

	return target
end

---@param target table
---@param filler table
---@return table
function LowAmmoText.tbl.fill_missing(target, filler)
	return fill_missing_rec(target, filler)
end
