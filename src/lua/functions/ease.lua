function LowAmmoText.ease.linear(x)
	return x
end

function LowAmmoText.ease.in_sine(x)
	return 1 - math.cos((x * math.pi) / 2)
end

function LowAmmoText.ease.out_sine(x)
	return math.sin((x * math.pi) / 2)
end

function LowAmmoText.ease.in_out_sine(x)
	return -(math.cos(math.pi * x) - 1) / 2
end

function LowAmmoText.ease.in_quad(x)
	return x * x
end

function LowAmmoText.ease.out_quad(x)
	return 1 - (1 - x) * (1 - x)
end

function LowAmmoText.ease.in_out_quad(x)
	if x < 0.5 then
		return 2 * x * x
	else
		return 1 - math.pow(-2 * x + 2, 2) / 2
	end
end

function LowAmmoText.ease.in_cubic(x)
	return x * x * x
end

function LowAmmoText.ease.out_cubic(x)
	return 1 - math.pow(1 - x, 3)
end

function LowAmmoText.ease.in_out_cubic(x)
	if x < 0.5 then
		return 4 * x * x * x
	else
		return 1 - math.pow(-2 * x + 2, 3) / 2
	end
end

function LowAmmoText.ease.in_quart(x)
	return x * x * x * x
end

function LowAmmoText.ease.out_quart(x)
	return 1 - math.pow(1 - x, 4)
end

function LowAmmoText.ease.in_out_quart(x)
	if x < 0.5 then
		return 8 * x * x * x * x
	else
		return 1 - math.pow(-2 * x + 2, 4) / 2
	end
end

function LowAmmoText.ease.in_quint(x)
	return x * x * x * x * x
end

function LowAmmoText.ease.out_quint(x)
	return 1 - math.pow(1 - x, 5)
end

function LowAmmoText.ease.in_out_quint(x)
	if x < 0.5 then
		return 16 * x * x * x * x * x
	else
		return 1 - math.pow(-2 * x + 2, 5) / 2
	end
end

function LowAmmoText.ease.in_expo(x)
	if x == 0 then
		return 0
	else
		return math.pow(2, 10 * x - 10)
	end
end

function LowAmmoText.ease.out_expo(x)
	if x == 1 then
		return 1
	else
		return 1 - math.pow(2, -10 * x)
	end
end

function LowAmmoText.ease.in_out_expo(x)
	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	elseif x < 0.5 then
		return math.pow(2, 20 * x - 10) / 2
	else
		return (2 - math.pow(2, -20 * x + 10)) / 2
	end
end

function LowAmmoText.ease.in_circ(x)
	return 1 - math.sqrt(1 - math.pow(x, 2))
end

function LowAmmoText.ease.out_circ(x)
	return math.sqrt(1 - math.pow(x - 1, 2))
end

function LowAmmoText.ease.in_out_circ(x)
	if x < 0.5 then
		return (1 - math.sqrt(1 - math.pow(2 * x, 2))) / 2
	else
		return (math.sqrt(1 - math.pow(-2 * x + 2, 2)) + 1) / 2
	end
end

function LowAmmoText.ease.in_back(x)
	local c1 = 1.70158
	local c3 = c1 + 1

	return c3 * x * x * x - c1 * x * x
end

function LowAmmoText.ease.out_back(x)
	local c1 = 1.70158
	local c3 = c1 + 1

	return 1 + c3 * math.pow(x - 1, 3) + c1 * math.pow(x - 1, 2)
end

function LowAmmoText.ease.in_out_back(x)
	local c1 = 1.70158
	local c2 = c1 * 1.525

	if x < 0.5 then
		return (math.pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2
	else
		return (math.pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2
	end
end

function LowAmmoText.ease.in_elastic(x)
	local c4 = (2 * math.pi) / 3

	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	else
		return -math.pow(2, 10 * x - 10) * math.sin((x * 10 - 10.75) * c4)
	end
end

function LowAmmoText.ease.out_elastic(x)
	local c4 = (2 * math.pi) / 3

	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	else
		return math.pow(2, -10 * x) * math.sin((x * 10 - 0.75) * c4) + 1
	end
end

function LowAmmoText.ease.in_out_elastic(x)
	local c5 = (2 * math.pi) / 4.5

	if x == 0 then
		return 0
	elseif x == 1 then
		return 1
	elseif x < 0.5 then
		return -(math.pow(2, 20 * x - 10) * math.sin((20 * x - 11.125) * c5)) / 2
	else
		return (math.pow(2, -20 * x + 10) * math.sin((20 * x - 11.125) * c5)) / 2 + 1
	end
end

function LowAmmoText.ease.in_bounce(x)
	return 1 - LowAmmoText.ease.out_bounce(1 - x)
end

function LowAmmoText.ease.out_bounce(x)
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

function LowAmmoText.ease.in_out_bounce(x)
	if x < 0.5 then
		return (1 - LowAmmoText.ease.out_bounce(1 - 2 * x)) / 2
	else
		return (1 + LowAmmoText.ease.out_bounce(2 * x - 1)) / 2
	end
end
