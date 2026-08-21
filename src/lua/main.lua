---@alias Color any
---@alias Font any
---@alias HUD any
---@alias HUDPanel any

_G.LowAmmoText = _G.LowAmmoText or {}

LowAmmoText.mod_path = LowAmmoText.mod_path or ModPath
LowAmmoText.save_path = LowAmmoText.save_path or SavePath .. "LowAmmoText_options.json"

function LowAmmoText.dofile(name)
	return dofile(LowAmmoText.mod_path .. "lua/" .. name .. ".lua")
end

-- keep-sorted start
LowAmmoText.dofile("functions/tbl")
-- keep-sorted end

-- keep-sorted start
LowAmmoText.dofile("classes/rendered_text")
-- keep-sorted end

LowAmmoText._data = LowAmmoText._data
	or {
		text_font_size = 14,

		text_offset_x = 0,
		text_offset_y = 20,

		text_alpha = 1.0,
	}

--- Loads the mod's configuration,
--- saving it to [LowAmmoText._data] and returning it as a table.
function LowAmmoText:load_configuration()
	local file = io.open(self.save_path, "r")
	if not file then
		return
	end

	local result = json.decode(file:read("*all"))
	file:close()

	self.tbl.fill_missing(result, self._data)
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

if RequiredScript == "lib/entry" then
	LowAmmoText.dofile("hooks/lib/entry")
	return
end

if RequiredScript == "lib/managers/hudmanager" then
	LowAmmoText.dofile("hooks/managers/hudmanager")
	return
end

if RequiredScript == "lib/managers/menumanager" then
	LowAmmoText.dofile("hooks/managers/menumanager")
	return
end
