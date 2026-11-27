/datum/assembly_warrant
	var/defense_daily_cap = 0
	var/defense_remaining = 0
	var/last_refreshed_day = -1

/datum/assembly_warrant/proc/reset()
	defense_daily_cap = 0
	defense_remaining = 0
	last_refreshed_day = -1

/datum/assembly_warrant/proc/refresh_for_day()
	defense_remaining = defense_daily_cap
	last_refreshed_day = GLOB.dayspassed

/datum/assembly_warrant/proc/set_defense_cap(amount)
	defense_daily_cap = max(0, amount)
	defense_remaining = min(defense_remaining, defense_daily_cap)
