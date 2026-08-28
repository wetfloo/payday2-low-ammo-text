---@class (exact) AmmoStateValues
---@field no_ammo? boolean
---@field low_total_ammo? boolean
---@field clip_empty? boolean
---@field low_ammo_clip? boolean
---@field bulletstorm? boolean
---@field swan_song_aced? boolean

---@class (exact) LowAmmoText.AmmoStateManager
---@field init fun(self: LowAmmoText.AmmoStateManager, rendered_text: LowAmmoText.RenderedText)
---@field destroy fun(self: LowAmmoText.AmmoStateManager)
---@field alive fun(self: LowAmmoText.AmmoStateManager): boolean
---@field update_state_values fun(self: LowAmmoText.AmmoStateManager, state_values: AmmoStateValues)
---@field state_values AmmoStateValues
---@field private _state_values AmmoStateValues
---@field private _preset AmmoStatePreset|nil

---@class AmmoStatePreset
---@field k string
---@field s_id string
---@field color Color

-- We depend on this, so better init it just in case.
LowAmmoText.dofile("classes/rendered_text")

LowAmmoText.AmmoStateManager = LowAmmoText.AmmoStateManager or class()

local presets_sorted = {
	{ k = "no_ammo", s_id = "low_ammo_text__ammo_state__no_ammo", color = Color(1.0, 0.0, 0.0) },
	{
		k = "clip_empty",
		s_id = "low_ammo_text__ammo_state__clip_empty",
		color = Color(1.0, 0.98, 0.35),
	},
	{
		k = "swan_song_aced",
		s_id = "low_ammo_text__ammo_state__swan_song_aced",
		color = Color(0.24, 0.66, 0.93),
	},
	{
		k = "bulletstorm",
		s_id = "low_ammo_text__ammo_state__bulletstorm",
		color = Color(0.5, 0.9, 0.28),
	},
	{
		k = "low_total_ammo",
		s_id = "low_ammo_text__ammo_state__low_total",
		color = Color(1.0, 0.5, 0.0),
	},
	{
		k = "low_ammo_clip",
		s_id = "low_ammo_text__ammo_state__low_clip",
		color = Color(0.9, 0.9, 0.9),
	},
}

---@param rendered_text LowAmmoText.RenderedText
function LowAmmoText.AmmoStateManager:init(rendered_text)
	self._state_values = {}
	for _, preset in ipairs(presets_sorted) do
		self._state_values[preset.k] = false
	end

	self._rendered_text = rendered_text

	local t = self
	self._rendered_text:add_text_animator("ammo_state_manager_text_animator", function(o)
		local preset_color = t._preset and t._preset.color
		if not preset_color then
			return
		end

		if LowAmmoText._data.pulse_text_animation_speed_mul <= 1.0 then
			o:set_color(preset_color)
			return
		end

		local time = Application:time()
		local base_time_mul = 50
		local product = time * base_time_mul * LowAmmoText._data.pulse_text_animation_speed_mul
		local sine_norm = (math.sin(product) + 1) / 2
		local eased = LowAmmoText.ease.in_out_circ(sine_norm)
		local mul = math.lerp(LowAmmoText._data.pulse_text_animation_start, 1.0, eased)

		local r, g, b = preset_color.r, preset_color.g, preset_color.b
		local h, s, v = rgb_to_hsv(r, g, b)
		r, g, b = hsv_to_rgb(h, s, v * mul)

		o:set_color(Color(r, g, b))
	end)
end

function LowAmmoText.AmmoStateManager:destroy()
	if self._rendered_text then
		---@type LowAmmoText.RenderedText
		self._rendered_text:destroy()
		self._rendered_text = nil
	end
end

---@param offset Offset
function LowAmmoText.AmmoStateManager:set_offset(offset)
	self._rendered_text:set_offset(offset)
end

---@param val number
function LowAmmoText.AmmoStateManager:set_offset_x(val)
	self._rendered_text:set_offset_x(val)
end

---@param val number
function LowAmmoText.AmmoStateManager:set_offset_y(val)
	self._rendered_text:set_offset_y(val)
end

---@param val number
function LowAmmoText.AmmoStateManager:set_alpha(val)
	self._rendered_text:set_alpha(val)
end

---@param val number
function LowAmmoText.AmmoStateManager:set_font_size(val)
	self._rendered_text:set_font_size(val)
end

---@param state_values AmmoStateValues
function LowAmmoText.AmmoStateManager:update_state_values(state_values)
	self._state_values = LowAmmoText.tbl.fill_missing(state_values, self._state_values)

	self:_on_state_value_update()
end

function LowAmmoText.AmmoStateManager:_on_state_value_update()
	local preset

	for _, preset_curr in ipairs(presets_sorted) do
		local k = preset_curr.k
		local found = self._state_values[k]

		local enabled = LowAmmoText._data["state_enabled_" .. k]
		if enabled == nil then
			enabled = true
		end

		if found and enabled then
			preset = preset_curr
			break
		end
	end

	self._preset = preset

	if not preset then
		self._rendered_text:hide(LowAmmoText._data.text_fade_duration_secs)
		return
	end

	self._rendered_text:set_s(managers.localization:text(preset.s_id))
	self._rendered_text:set_text_color(preset.color)
	self._rendered_text:show(LowAmmoText._data.text_fade_duration_secs)
end
