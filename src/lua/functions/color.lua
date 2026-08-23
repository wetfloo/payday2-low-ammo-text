LowAmmoText.color = LowAmmoText.color or {}

function LowAmmoText.color.hsv_to_rgb(h, s, v, a)
	h = (h % 1.0) * 360

	local c = v * s
	local u = math.abs(((h / 60) % 2.0) - 1)
	local x = c * (1 - u)
	local m = v - c

	local r, g, b

	if h < 60 then
		r, g, b = c, x, 0
	elseif h < 120 then
		r, g, b = x, c, 0
	elseif h < 180 then
		r, g, b = 0, c, x
	elseif h < 240 then
		r, g, b = 0, x, c
	elseif h < 300 then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end

	r, g, b = r + m, g + m, b + m
	a = a or 1.0

	return r, g, b
end

function LowAmmoText.color.rgb_to_hsv(r, g, b, a)
	local cmax = math.max(r, g, b)
	local cmin = math.min(r, g, b)
	local d = cmax - cmin

	local h, s, v = 0, 0, cmax

	-- Hue calculation.
	if d ~= 0.0 then
		if cmax == r then
			h = 60 * (((g - b) / d) % 6.0)
		elseif cmax == g then
			h = 60 * (((b - r) / d) + 2)
		elseif cmax == b then
			h = 60 * (((r - g) / d) + 4)
		end
	end

	-- Saturation calculation.
	if cmax ~= 0.0 then
		s = d / cmax
	end

	-- Normalize & return.
	h = h / 360
	a = a or 1.0
	return h, s, v
end
