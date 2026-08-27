LowAmmoText._data = LowAmmoText._data
	or {
		text_font_size = 14,
		text_alpha = 1.0,
		text_fade_duration_secs = 0.25,
		text_offset_x = 0,
		text_offset_y = 20,

		pulse_text_animation_start = 0.6,
		pulse_text_animation_speed_mul = 1.0,

		threshold_low_ammo_clip = 0.25,
		threshold_low_ammo_total = 0.25,
		---@deprecated
		threshold_low_ammo_total_from_clip = 0.5,
	}

LowAmmoText._mt_data = LowAmmoText._mt_data
	or {
		__index = function(t, k)
			local m = {}

			function m.text_fade_duration_millis()
				return rawget(t, "text_fade_duration_secs") * 1000
			end

			function m.pulse_text_animation_speed_mul_log()
				return math.pow(10, rawget(t, "pulse_text_animation_speed_mul"))
			end

			local result = m[k]
			if result and type(result) == "function" then
				return result()
			end
		end,

		__newindex = function(t, k, v)
			local m = {}

			function m.text_fade_duration_millis()
				return rawset(t, "text_fade_duration_secs", v / 1000)
			end

			function m.pulse_text_animation_speed_mul_log()
				return rawset(t, "pulse_text_animation_speed_mul", math.log10(v))
			end

			local result = m[k]
			if result and type(result) == "function" then
				return result()
			end
		end,
	}

setmetatable(LowAmmoText._data, LowAmmoText._mt_data)
