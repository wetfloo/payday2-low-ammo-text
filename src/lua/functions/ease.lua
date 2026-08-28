LowAmmoText.ease = LowAmmoText.ease or {}

function LowAmmoText.ease.linear(x)
	return x
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
