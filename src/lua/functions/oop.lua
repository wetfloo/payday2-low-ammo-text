---@class Offset
---@field x number
---@field y number

---@class (exact) RenderTextInputParams
---@field s string
---@field text_configuration TextConfiguration
---@field text_shadow_configuration TextShadowConfiguration|nil

---@class (exact) TextConfiguration
---@field color Color
---@field offset Offset
---@field font_size number
---@field font Font

---@class (exact) TextShadowConfiguration
---@field color Color
---@field additional_offset Offset

---@class RenderedText
---@field private _hud HUD
---@field private _panel HUDPanel
---@field private _text RenderedTextComponent
---@field private _text_configuration TextConfiguration
---@field private _shadow RenderedTextComponent
---@field private _text_shadow_configuration TextConfiguration|nil

---@alias Color any
---@alias Font any
---@alias HUD any
---@alias HUDPanel any
---@alias RenderedTextComponent any

LowAmmoText.RenderedText = LowAmmoText.RenderedText or class()

local function set_text_panel_size_to_rendered(panel)
	local _, _, w, h = panel:text_rect()
	panel:set_size(w, h)

	return panel, w, h
end

---@param param RenderTextInputParams
function LowAmmoText.RenderedText:init(param)
	self._hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	self._panel = self._hud.panel

	self._text_configuration = param.text_configuration
	self._text_shadow_configuration = param.text_shadow_configuration

	local params_text = {
		text = param.s,
		color = param.text_configuration.color,
		font = param.text_configuration.font,
		font_size = param.text_configuration.font_size,
	}
	local params_shadow = LowAmmoText.tbl.shallow_copy(params_text)
	params_shadow.color = param.text_shadow_configuration.color

	-- Render shadow first, otherwise we get overlap.
	self._shadow = self._panel:text(params_shadow)
	self._text = self._panel:text(params_text)

	self:_realign()
end

---@param offset Offset
function LowAmmoText.RenderedText:set_offset(offset)
	self._text_configuration.offset = offset
	self:_realign()
end

---@param color Color
function LowAmmoText.RenderedText:set_text_color(color)
	self._text_configuration.color = color
	self._text:set_color(color)
end

---@private
function LowAmmoText.RenderedText:_hud_center()
	local w = self._hud.panel:w() / 2
	local h = self._hud.panel:h() / 2
	return w, h
end

---@private
function LowAmmoText.RenderedText:_hud_center_with_offset()
	local w, h = self:_hud_center()
	local x, y = table.unpack(self._text_configuration.offset)

	return w + x, h + y
end

---@private
function LowAmmoText.RenderedText:_realign()
	local w, h = self:_hud_center_with_offset()

	if self._shadow and alive(self._shadow) then
		set_text_panel_size_to_rendered(self._shadow)

		self._shadow:set_center(w, h)

		local x, y = table.unpack(self._text_shadow_configuration.additional_offset)
		self._shadow:move(x, y)
	end

	if self._text and alive(self._text) then
		set_text_panel_size_to_rendered(self._text)

		self._text:set_center(w, h)
	end
end
