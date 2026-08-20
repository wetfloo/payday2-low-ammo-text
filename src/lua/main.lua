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

LowAmmoText._data = {
	text_color = Color.white,
	shadow_color = Color.black,

	text_offset = {
		x = 0,
		y = -20,
	},
}

if RequiredScript == "lib/entry" then
	LowAmmoText.dofile("hooks/entry")
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
