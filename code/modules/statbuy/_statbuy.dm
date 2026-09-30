// Statbuy: instead of picking a preset statpack, players distribute a pool of points across their stats.
// An allocation is an associative list of STATKEY_* -> modifier. This is basically just a custom statpack we set.
// Raising a stat by one costs a point, lowering a stat by one refunds a point.

/// The stats that can be bought, in the order the Preferences Menu displays them.
GLOBAL_LIST_INIT(statbuy_stats, list(
	STATKEY_STR = "Strength",
	STATKEY_PER = "Perception",
	STATKEY_WIL = "Willpower",
	STATKEY_CON = "Constitution",
	STATKEY_INT = "Intelligence",
	STATKEY_SPD = "Speed",
	STATKEY_LCK = "Fortune",
))

/// Returns a fresh allocation with nothing assigned.
/proc/get_default_statbuy()
	. = list()
	for(var/stat in GLOB.statbuy_stats)
		.[stat] = 0

/// Returns how many points the given allocation costs. Can be negative if more was lowered than raised.
/proc/get_statbuy_points_spent(list/statbuy)
	. = 0
	for(var/stat in statbuy)
		. += statbuy[stat]

/// Returns a valid copy of the given allocation. Anything that overspends the pool is reset entirely.
/proc/sanitize_statbuy(list/statbuy)
	. = get_default_statbuy()
	if(!islist(statbuy))
		return
	for(var/stat in .)
		var/value = statbuy[stat]
		if(!isnum(value))
			continue
		.[stat] = clamp(round(value), STATBUY_STAT_MIN, STATBUY_STAT_MAX)
	if(get_statbuy_points_spent(.) > STATBUY_POINTS)
		return get_default_statbuy()

/// Returns TRUE if nothing has been assigned in the given allocation.
/proc/is_statbuy_unassigned(list/statbuy)
	for(var/stat in statbuy)
		if(statbuy[stat])
			return FALSE
	return TRUE

/// Generates a blurb string for use in preferences, in the same style as /datum/statpack/proc/generate_modifier_string()
/proc/generate_statbuy_string(list/statbuy)
	var/list/concat = list()
	for(var/stat in GLOB.statbuy_stats)
		var/value = statbuy[stat]
		if(!value)
			continue
		var/modifier = ""
		if(value >= 1)
			modifier = "+"
		concat += "[modifier][value] [uppertext(copytext(stat, 1, 4))]"
	if(!length(concat))
		return "Unassigned"
	return concat.Join(", ")

/// Applies the given allocation to the recipient, the statbuy counterpart to /datum/statpack/proc/apply_to_human()
/proc/apply_statbuy_to_human(mob/living/carbon/human/recipient, list/statbuy)
	if(!recipient?.mind)
		return FALSE
	var/list/sanitized_statbuy = sanitize_statbuy(statbuy)
	for(var/stat in sanitized_statbuy)
		recipient.change_stat(stat, sanitized_statbuy[stat])
	return TRUE

/// Statbuy's replacement for statpack.virtuous: leaving every stat untouched grants access to virtuous-only virtues and the second virtue slot.
/datum/preferences/proc/is_virtuous()
	return is_statbuy_unassigned(statbuy)
