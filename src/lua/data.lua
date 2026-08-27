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
