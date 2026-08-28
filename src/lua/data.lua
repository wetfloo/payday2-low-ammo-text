local pulse_text_animation_speed_exp = 2

LowAmmoText._default_data = LowAmmoText._default_data
	or {
		text_font_size = 16,
		text_alpha = 1.0,
		text_fade_duration_secs = 0.25,
		text_offset_x = 0,
		text_offset_y = 20,

		threshold_low_ammo_clip = 0.25,
		threshold_low_ammo_total = 0.25,

		pulse_text_animation_start = 0.65,
		pulse_text_ease_function_key = "linear",
		pulse_text_animation_speed_mul = 7.65175,

		state_enabled_no_ammo = true,
		state_enabled_low_total_ammo = true,
		state_enabled_clip_empty = true,
		state_enabled_low_ammo_clip = true,
		state_enabled_bulletstorm = true,
		state_enabled_swan_song_aced = true,
	}

LowAmmoText._mt_data = LowAmmoText._mt_data
	or {
		__index = function(t, k)
			local m = {}

			function m.text_fade_duration_millis()
				return rawget(t, "text_fade_duration_secs") * 1000
			end

			function m.pulse_text_animation_speed_mul_log()
				return math.pow(
					pulse_text_animation_speed_exp,
					rawget(t, "pulse_text_animation_speed_mul")
				)
			end

			function m.pulse_text_ease_function()
				return LowAmmoText.ease[rawget(t, "pulse_text_ease_function_key")]
			end

			local result = m[k]
			if result and type(result) == "function" then
				return result()
			end

			return result
		end,

		__newindex = function(t, k, v)
			local m = {}

			function m.text_fade_duration_millis()
				return rawset(t, "text_fade_duration_secs", v / 1000)
			end

			function m.pulse_text_animation_speed_mul_log()
				return rawset(
					t,
					"pulse_text_animation_speed_mul",
					math.log(v, pulse_text_animation_speed_exp)
				)
			end

			local result = m[k]
			if result and type(result) == "function" then
				return result()
			end
		end,
	}
setmetatable(LowAmmoText._default_data, LowAmmoText._mt_data)

LowAmmoText._data = LowAmmoText._data or LowAmmoText.tbl.deep_clone(LowAmmoText._default_data)
