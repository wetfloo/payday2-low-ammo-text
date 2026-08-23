---@class (exact) AmmoStateValues
---@field no_ammo boolean
---@field low_total_ammo boolean
---@field clip_empty boolean
---@field bulletstorm boolean
---@field low_clip_ammo boolean

---@class (exact) LowAmmoText.AmmoStateManager
---@field init fun(self: LowAmmoText.AmmoStateManager, rendered_text: LowAmmoText.RenderedText)
---@field destroy fun(self: LowAmmoText.AmmoStateManager)
---@field state_values AmmoStateValues
---@field private _state_values_raw AmmoStateValues

LowAmmoText.AmmoStateManager = LowAmmoText.AmmoStateManager or class()

local presets_sorted = {
	{ k = "no_ammo", s_id = "low_ammo_text__ammo_state__no_ammo", color = Color(1.0, 0.0, 0.0) },
	{
		k = "low_total_ammo",
		s_id = "low_ammo_text__ammo_state__low_total",
		color = Color(1.0, 0.5, 0.0),
	},
	{
		k = "clip_empty",
		s_id = "low_ammo_text__ammo_state__clip_empty",
		color = Color(1.0, 0.98, 0.35),
	},
	{
		k = "bulletstorm",
		s_id = "low_ammo_text__ammo_state__bulletstorm",
		color = Color(0.5, 0.9, 0.28),
	},
	{
		k = "low_ammo_clip",
		s_id = "low_ammo_text__ammo_state__low_clip",
		color = Color(0.9, 0.9, 0.9),
	},
}

---@param rendered_text LowAmmoText.RenderedText
function LowAmmoText.AmmoStateManager:init(rendered_text)
	self._state_values_raw = {}
	for _, preset in ipairs(presets_sorted) do
		self._state_values_raw[preset.k] = false
	end

	self._rendered_text = rendered_text

	self.state_values = LowAmmoText.tbl.on_access_post(self._state_values_raw, nil, function(_k, _v)
		self:_on_state_value_update()
	end)
end

function LowAmmoText.AmmoStateManager:destroy()
	if self._rendered_text then
		---@type LowAmmoText.RenderedText
		self._rendered_text:destroy()
	end
	self._rendered_text = nil
end

function LowAmmoText.AmmoStateManager:_on_state_value_update()
	local preset

	for _, preset_curr in ipairs(presets_sorted) do
		if self.state_values[preset_curr.k] then
			preset = preset_curr
			break
		end
	end

	if not preset then
		self._rendered_text:hide(LowAmmoText._data.text_fade_duration_secs)
		return
	end

	self._rendered_text:set_s(managers.localization:text(preset.s_id))
	self._rendered_text:set_text_color(preset.color)
	self._rendered_text:show(LowAmmoText._data.text_fade_duration_secs)
end
