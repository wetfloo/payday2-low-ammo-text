function easeInSine(x)
	return 1 - Math.cos((x * Math.PI) / 2)
end

function easeOutSine(x)
	return Math.sin((x * Math.PI) / 2)
end

function easeInOutSine(x)
	return -(Math.cos(Math.PI * x) - 1) / 2
end

function easeInQuad(x)
	return x * x
end

function easeOutQuad(x)
	return 1 - (1 - x) * (1 - x)
end

function easeInOutQuad(x)
	if x < 0.5 then
		return 2 * x * x
	else
		return 1 - Math.pow(-2 * x + 2, 2) / 2
	end
end

function easeInCubic(x)
	return x * x * x
end

function easeOutCubic(x)
	return 1 - Math.pow(1 - x, 3)
end

function easeInOutCubic(x)
	if x < 0.5 then
		return 4 * x * x * x
	else
		return 1 - Math.pow(-2 * x + 2, 3) / 2
	end
end

function easeInQuart(x)
	return x * x * x * x
end

function easeOutQuart(x)
	return 1 - Math.pow(1 - x, 4)
end

function easeInOutQuart(x)
	if x < 0.5 then
		return 8 * x * x * x * x
	else
		return 1 - Math.pow(-2 * x + 2, 4) / 2
	end
end

function easeInQuint(x)
	return x * x * x * x * x
end

function easeOutQuint(x)
	return 1 - Math.pow(1 - x, 5)
end

function easeInOutQuint(x)
	if x < 0.5 then
		return 16 * x * x * x * x * x
	else
		return 1 - Math.pow(-2 * x + 2, 5) / 2
	end
end

function easeInExpo(x)
	if x == 0 then
		return 0
	else
		return Math.pow(2, 10 * x - 10)
	end
end

function easeOutExpo(x)
	if x == 1 then
		return 1
	else
		return 1 - Math.pow(2, -10 * x)
	end
end

function easeInOutExpo(x)
	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	elseif x < 0.5 then
		return Math.pow(2, 20 * x - 10) / 2
	else
		return (2 - Math.pow(2, -20 * x + 10)) / 2
	end
end

function easeInCirc(x)
	return 1 - Math.sqrt(1 - Math.pow(x, 2))
end

function easeOutCirc(x)
	return Math.sqrt(1 - Math.pow(x - 1, 2))
end

function easeInOutCirc(x)
	if x < 0.5 then
		return (1 - Math.sqrt(1 - Math.pow(2 * x, 2))) / 2
	else
		return (Math.sqrt(1 - Math.pow(-2 * x + 2, 2)) + 1) / 2
	end
end

function easeInBack(x)
	local c1 = 1.70158
	local c3 = c1 + 1

	return c3 * x * x * x - c1 * x * x
end

function easeOutBack(x)
	local c1 = 1.70158
	local c3 = c1 + 1

	return 1 + c3 * Math.pow(x - 1, 3) + c1 * Math.pow(x - 1, 2)
end

function easeInOutBack(x)
	local c1 = 1.70158
	local c2 = c1 * 1.525

	if x < 0.5 then
		return (Math.pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2
	else
		return (Math.pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2
	end
end

function easeInElastic(x)
	local c4 = (2 * Math.PI) / 3

	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	else
		return -Math.pow(2, 10 * x - 10) * Math.sin((x * 10 - 10.75) * c4)
	end
end

function easeOutElastic(x)
	local c4 = (2 * Math.PI) / 3

	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	else
		return Math.pow(2, -10 * x) * Math.sin((x * 10 - 0.75) * c4) + 1
	end
end

function easeInOutElastic(x)
	local c5 = (2 * Math.PI) / 4.5

	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	elseif x < 0.5 then
		return -(Math.pow(2, 20 * x - 10) * Math.sin((20 * x - 11.125) * c5)) / 2
	else
		return (Math.pow(2, -20 * x + 10) * Math.sin((20 * x - 11.125) * c5)) / 2 + 1
	end
end

function easeInBounce(x)
	return 1 - easeOutBounce(1 - x)
end

function easeOutBounce(x)
	local n1 = 7.5625
	local d1 = 2.75

	if x < 1 / d1 then
		return n1 * x * x
	elseif x < 2 / d1 then
		x = x - 1.5 / d1
		return n1 * x * x + 0.75
	elseif x < 2.5 / d1 then
		x = x - 2.25 / d1
		return n1 * x * x + 0.9375
	else
		x = x - 2.625 / d1
		return n1 * x * x + 0.984375
	end
end

function easeInOutBounce(x)
	if x < 0.5 then
		return (1 - easeOutBounce(1 - 2 * x)) / 2
	else
		return (1 + easeOutBounce(2 * x - 1)) / 2
	end
end
