---@alias Color any
---@alias Font any
---@alias HUD any
---@alias HUDPanel any

_G.LowAmmoText = _G.LowAmmoText or {}

LowAmmoText.mod_name = LowAmmoText.mod_name or "LowAmmoText"

LowAmmoText.mod_path = LowAmmoText.mod_path or ModPath
LowAmmoText.save_path = LowAmmoText.save_path or SavePath .. LowAmmoText.mod_name .. "_options.json"

function LowAmmoText.dofile(name)
	return dofile(LowAmmoText.mod_path .. "lua/" .. name .. ".lua")
end

-- keep-sorted start
LowAmmoText.dofile("functions/tbl")
-- keep-sorted end

LowAmmoText.dofile("data")

-- keep-sorted start
LowAmmoText.dofile("classes/ammo_state_manager")
LowAmmoText.dofile("classes/rendered_text")
-- keep-sorted end

--- Loads the mod's configuration,
--- saving it to [LowAmmoText._data] and returning it as a table.
function LowAmmoText:load_configuration()
	local file = io.open(self.save_path, "r")
	if not file then
		return
	end

	local read = file:read("*all")
	file:close()
	if not read then
		return
	end

	local result = json.decode(read) or {}

	self.tbl.fill_missing(result, self._data)
	setmetatable(result, LowAmmoText._mt_data)
	self._data = result

	return result
end

function LowAmmoText:save_configuration()
	local file = io.open(self.save_path, "w+")
	if not file then
		return
	end

	local result = file:write(json.encode(self._data))
	file:close()

	return result
end

LowAmmoText.dofile("hooks/" .. RequiredScript)
