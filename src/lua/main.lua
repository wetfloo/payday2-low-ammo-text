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
LowAmmoText.dofile("functions/color")
LowAmmoText.dofile("functions/tbl")
-- keep-sorted end

-- keep-sorted start
LowAmmoText.dofile("classes/ammo_state_manager")
LowAmmoText.dofile("classes/rendered_text")
-- keep-sorted end

LowAmmoText._data = LowAmmoText._data
	or {
		text_font_size = 14,
		text_alpha = 1.0,
		text_fade_duration_secs = 0.25,
		text_offset_x = 0,
		text_offset_y = 20,

		threshold_low_ammo_clip = 0.25,
		threshold_low_ammo_total = 0.25,
		---@deprecated
		threshold_low_ammo_total_from_clip = 0.5,
	}

LowAmmoText._mt_data = LowAmmoText._mt_data
	or {
		__index = function(t, k)
			local m = {}

			local function percent(val)
				return val * 100
			end

			function m.threshold_low_ammo_clip_percent()
				return percent(rawget(t, "threshold_low_ammo_clip"))
			end

			---@deprecated
			function m.threshold_low_ammo_total_from_clip_percent()
				return percent(rawget(t, "threshold_low_ammo_total_from_clip"))
			end

			function m.threshold_low_ammo_total_percent()
				return percent(rawget(t, "threshold_low_ammo_total"))
			end

			function m.text_fade_duration_millis()
				return rawget(t, "text_fade_duration_secs") * 1000
			end

			local result = m[k]
			if result and type(result) == "function" then
				return result()
			end
		end,
	}

setmetatable(LowAmmoText._data, LowAmmoText._mt_data)

--- Loads the mod's configuration,
--- saving it to [LowAmmoText._data] and returning it as a table.
function LowAmmoText:load_configuration()
	local file = io.open(self.save_path, "r")
	if not file then
		return
	end

	local result = json.decode(file:read("*all")) or {}
	file:close()

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
