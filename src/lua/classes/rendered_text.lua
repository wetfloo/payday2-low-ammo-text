---@class Offset
---@field x number
---@field y number

---@class (exact) RenderTextInputParams
---@field s string
---@field text_configuration TextConfiguration
---@field text_shadow_configuration TextShadowConfiguration|nil

---@class (exact) TextConfiguration
---@field color Color
---@field alpha number
---@field offset Offset
---@field font_size number
---@field font Font

---@class (exact) TextShadowConfiguration
---@field color Color
---@field additional_offset Offset

---@class RenderedText
---@field private _hud HUD
---@field private _panel HUDPanel
---@field private _s string
---@field private _text RenderedTextComponent
---@field private _text_configuration TextConfiguration
---@field private _shadow RenderedTextComponent
---@field private _text_shadow_configuration TextConfiguration|nil

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

	if self._text_shadow_configuration then
		local params_shadow = LowAmmoText.tbl.shallow_copy(params_text)
		params_shadow.color = param.text_shadow_configuration.color
		-- Render shadow first, otherwise we get overlap.
		self._shadow = self._panel:text(params_shadow)
	end
	-- Then we can render text
	self._text = self._panel:text(params_text)

	self:_realign()
end

function LowAmmoText.RenderedText:destroy()
	if self._text and alive(self._text) then
		self._text:remove()
		self._text = nil
	end
	if self._shadow and alive(self._shadow) then
		self._shadow:remove()
		self._shadow = nil
	end
end

---@param offset Offset
function LowAmmoText.RenderedText:set_offset(offset)
	self._text_configuration.offset = offset
	self:_realign()
end

---@param val number
function LowAmmoText.RenderedText:set_offset_x(val)
	self._text_configuration.offset.x = val
	self:_realign()
end

---@param val number
function LowAmmoText.RenderedText:set_offset_y(val)
	self._text_configuration.offset.y = val
	self:_realign()
end

---@param color Color
function LowAmmoText.RenderedText:set_text_color(color)
	self._text_configuration.color = color
	self._text:set_color(color)
end

---@param s string
function LowAmmoText.RenderedText:set_s(s)
	if s == self._s then
		return
	end

	self._s = s

	self._text:set_text(s)
	self._shadow:set_text(s)

	self:_realign()
end

---@param val number
function LowAmmoText.RenderedText:set_alpha(val)
	self._text:set_alpha(val)
	self._shadow:set_alpha(val)

	self._alpha = val
end

function LowAmmoText.RenderedText:show()
	self._shadow:show()
	self._text:show()
end

function LowAmmoText.RenderedText:hide()
	self._shadow:hide()
	self._text:hide()
end

---@param val number
function LowAmmoText.RenderedText:set_font_size(val)
	self._text_configuration.font_size = val

	self._text:set_font_size(val)
	self._shadow:set_font_size(val)

	self:_realign()
end

function LowAmmoText.RenderedText:set_font(val)
	self._text_configuration.font = val

	self._text:set_font(val)
	self._shadow:set_font(val)

	-- TODO: this call would cause access violations, for some reason.
	-- Find some help and try to fix it.
	-- self:_realign()
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
	local x = self._text_configuration.offset.x
	local y = self._text_configuration.offset.y

	return w + x, h + y
end

---@private
function LowAmmoText.RenderedText:_realign()
	local w, h = self:_hud_center_with_offset()

	set_text_panel_size_to_rendered(self._shadow)
	self._shadow:set_center(w, h)
	local x = self._text_shadow_configuration.additional_offset.x
	local y = self._text_shadow_configuration.additional_offset.y
	self._shadow:move(x, y)

	set_text_panel_size_to_rendered(self._text)
	self._text:set_center(w, h)
end
