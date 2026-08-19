_G.LowAmmoText = _G.LowAmmoText or {}

LowAmmoText.mod_path = LowAmmoText.mod_path or ModPath

function LowAmmoText.dohook(name)
	return dofile(LowAmmoText.mod_path .. "lua/hooks/" .. name .. ".lua")
end

LowAmmoText._data = {
	offset_y = -20.0,
}

if RequiredScript == "lib/entry" then
	LowAmmoText.dohook("entry")
	return
end

if RequiredScript == "lib/managers/hudmanager" then
	LowAmmoText.dohook("managers/hudmanager")
	return
end

if RequiredScript == "lib/managers/menumanager" then
	LowAmmoText.dohook("managers/menumanager")
	return
end
