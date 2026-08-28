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

---@class LowAmmoText.RenderedText
---@field init fun(self: LowAmmoText.RenderedText, param: RenderTextInputParams)
---@field destroy fun(self: LowAmmoText.RenderedText)
---@field set_offset fun(self: LowAmmoText.RenderedText, offset: Offset)
---@field set_offset_x fun(self: LowAmmoText.RenderedText, val: number)
---@field set_offset_y fun(self: LowAmmoText.RenderedText, val: number)
---@field set_text_color fun(self: LowAmmoText.RenderedText, color: Color)
---@field set_s fun(self: LowAmmoText.RenderedText, s: string)
---@field set_alpha fun(self: LowAmmoText.RenderedText, val: number)
---@field show fun(self: LowAmmoText.RenderedText, fade_in_duration_secs: number)
---@field hide fun(self: LowAmmoText.RenderedText, fade_out_duration_secs: number)
---@field hide fun(self: LowAmmoText.RenderedText): boolean
---@field add_text_animator fun(self: LowAmmoText.RenderedText, k: string, animator: TextAnimatorFn)
---@field set_font_size fun(self: LowAmmoText.RenderedText, val: number)
---@field private _hud HUD
---@field private _panel HUDPanel
---@field private _s string
---@field private _text RenderedTextComponent
---@field private _text_configuration TextConfiguration
---@field private _text_animators TextAnimatorsMap
---@field private _shadow RenderedTextComponent
---@field private _text_shadow_configuration TextConfiguration|nil
---@field private _shadow_animators TextAnimatorsMap
---@field private _visible boolean

---@alias TextAnimatorsMap { [string]: TextAnimator }

---@class (exact) TextAnimator
---@field fn TextAnimatorFn
---@field active boolean

---@alias TextAnimatorFn fun(o: RenderedTextComponent): boolean|nil

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
		local params_shadow = LowAmmoText.tbl.deep_clone(params_text)
		params_shadow.color = param.text_shadow_configuration.color
		-- Render shadow first, otherwise we get overlap.
		self._shadow = self._panel:text(params_shadow)
	end
	-- Then we can render text
	self._text = self._panel:text(params_text)

	self:set_alpha(self._text_configuration.alpha)

	self._text_animators = {}
	self._shadow_animators = {}

	self:_realign()
end

function LowAmmoText.RenderedText:destroy()
	if self._text and alive(self._text) then
		self._panel:remove(self._text)
		self._text = nil
	end
	if self._shadow and alive(self._shadow) then
		self._panel:remove(self._shadow)
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
	if not self._visible then
		return
	end

	self._text:set_alpha(val)
	self._shadow:set_alpha(val)

	self._text_configuration.alpha = val
end

function LowAmmoText.RenderedText:show(fade_in_duration_secs)
	if self._visible then
		return
	end
	self._visible = true

	if fade_in_duration_secs == nil then
		fade_in_duration_secs = 0
	end

	-- Necessary for all the closure we're running next,
	-- otherwise `self` would be overridden.
	local t = self

	t._shadow:animate(function(o)
		over(fade_in_duration_secs or 0.0, function(p)
			o:set_alpha(p * t._text_configuration.alpha)
		end)
	end)

	t._text:animate(function(o)
		over(fade_in_duration_secs or 0.0, function(p)
			o:set_alpha(p * t._text_configuration.alpha)
		end)
	end)
end

function LowAmmoText.RenderedText:hide(fade_out_duration_secs)
	if not self._visible then
		return
	end
	self._visible = false

	if fade_out_duration_secs == nil then
		fade_out_duration_secs = 0
	end

	-- Necessary for all the closure we're running next,
	-- otherwise `self` would be overridden.
	local t = self

	t._shadow:animate(function(o)
		over(fade_out_duration_secs or 0.0, function(p)
			o:set_alpha((1 - p) * t._text_configuration.alpha)
		end)
	end)

	t._text:animate(function(o)
		over(fade_out_duration_secs or 0.0, function(p)
			o:set_alpha((1 - p) * t._text_configuration.alpha)
		end)
	end)
end

---@return boolean
function LowAmmoText.RenderedText:visible()
	return self._visible
end

---@param k string
---@param animator TextAnimatorFn
function LowAmmoText.RenderedText:add_text_animator(k, animator)
	local addition = {
		active = true,
		animator = animator,
	}
	self._text_animators[k] = addition

	local t = self
	self._text:animate(function(o)
		local active = true

		while active do
			if t._visible then
				local needs_realign = animator(o) or false
				if needs_realign then
					t._text:_realign()
				end

				active = (t._text_animators[k] and t._text_animators[k].active) or false
			end

			coroutine.yield()
		end
	end)
end

---@param k string
function LowAmmoText.RenderedText:stop_text_animator(k)
	local animator = self._text_animators[k]
	if not animator then
		return
	end

	animator.active = false
end

---@param k string
---@param animator TextAnimatorFn
function LowAmmoText.RenderedText:add_shadow_animator(k, animator)
	local addition = {
		active = true,
		animator = animator,
	}
	self._shadow_animators[k] = addition

	local t = self
	self._shadow:animate(function(o)
		local active = true

		while active do
			local needs_realign = animator(o) or false
			if needs_realign then
				t._shadow:_realign()
			end

			active = (t._shadow_animators[k] and t._shadow_animators[k].active) or false
			coroutine.yield()
		end
	end)
end

---@param k string
function LowAmmoText.RenderedText:stop_shadow_animator(k)
	local animator = self._shadow_animators[k]
	if not animator then
		return
	end

	animator.active = false
end

---@param val number
function LowAmmoText.RenderedText:set_font_size(val)
	self._text_configuration.font_size = val

	self._text:set_font_size(val)
	self._shadow:set_font_size(val)

	self:_realign()
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
