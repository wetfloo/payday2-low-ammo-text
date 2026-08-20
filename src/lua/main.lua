---@alias Color any
---@alias Font any
---@alias HUD any
---@alias HUDPanel any

_G.LowAmmoText = _G.LowAmmoText or {}

LowAmmoText.mod_path = LowAmmoText.mod_path or ModPath

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
