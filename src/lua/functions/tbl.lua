LowAmmoText.tbl = LowAmmoText.tbl or {}

---@param target table
---@param filler table
---@return table
local function fill_missing_rec(target, filler)
	for k, v in pairs(filler) do
		if target[k] == nil then
			-- No need to worry about inner table structure,
			-- as `filler` should have the entire table
			-- structure for `target`'s missing fields.
			-- If it doesn't, too bad.
			target[k] = v
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

---@param t table
---@param on_get fun(k: any)|nil
---@param on_set fun(k: any, v: any)|nil
---@return table
function LowAmmoText.tbl.on_access_post(t, on_get, on_set)
	-- See https://www.lua.org/pil/13.4.4.html for this technique explanation.
	local proxy = {}
	local mt = {}

	function mt.__index(_t, k)
		local val = t[k]
		if on_get ~= nil and type(on_get) == "function" then
			on_get(k)
		end
		return val
	end

	function mt.__newindex(_t, k, v)
		t[k] = v
		if on_set ~= nil and type(on_set) == "function" then
			on_set(k, v)
		end
	end

	setmetatable(proxy, mt)
	return proxy
end

function LowAmmoText.tbl.deep_clone(o)
	if type(o) ~= "table" then
		return o
	end

	local res = {}

	for k, v in pairs(o) do
		res[LowAmmoText.tbl.deep_clone(k)] = LowAmmoText.tbl.deep_clone(v)
	end

	setmetatable(res, getmetatable(o))

	return res
end
