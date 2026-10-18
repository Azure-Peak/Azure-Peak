/proc/get_skill_delay(skill_level, fastest = 0.5, slowest = 5)
	if(skill_level == SKILL_LEVEL_NONE) //can't divivde by zero
		return slowest SECONDS
	else
		var/percentage = skill_level / SKILL_LEVEL_LEGENDARY // Turns it into a percentage
		var/result = LERP(slowest, fastest, percentage)
		return result SECONDS

// PSEUDORANDOMIZATION PROCS
// Intended to be uses in loops

/// Adjusts a base chance by a pseudorandom factor within (-factor, +factor)
/// and rounds the final result to 2 decimal places.
/// Example value 2, factor 0.1 => returns a value between 1.80 and 2.20
/proc/pseudorandomize_chance(base_chance, factor = 0.1)
	var/variation = rand() * (2 * factor) - factor
	var/result = base_chance * (1 + variation)
	return round(result, 0.01)

/// Always increases the base value by a random amount between (base * factor) and (base * (factor * 2))
/// and rounds the final result to 2 decimal places.
/// Example value 2, factor 0.1 => returns a value between 2.20 and 2.40
/proc/pseudorandomize_increase(base_value, factor = 0.1)
	var/min_increase = base_value * factor
	var/max_increase = base_value * (factor * 2)
	var/increase = min_increase + (rand() * (max_increase - min_increase))
	return round(base_value + increase, 0.01)

/// Always decreases the base value by a random amount between (base * factor) and (base * (factor * 2))
/// and rounds the final result to 2 decimal places.
/// Example value 2, factor 0.1 => returns a value between 1.80 and 1.60
/proc/pseudorandomize_decrease(base_value, factor = 0.1)
	var/min_decrease = base_value * factor
	var/max_decrease = base_value * (factor * 2)
	var/decrease = min_decrease + (rand() * (max_decrease - min_decrease))
	return round(base_value - decrease, 0.01)
