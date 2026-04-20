/datum/decree
	var/id
	var/name
	var/year
	var/flavor_text
	var/active = TRUE
	var/cooldown_expires = 0

/datum/decree/New()
	. = ..()
	year = roll_initial_year()

/datum/decree/proc/roll_initial_year()
	return CALENDAR_EPOCH_YEAR

/datum/decree/proc/get_display_name()
	return "[name] of [year]"

/datum/decree/proc/apply_exemption(mob/living/payer, tax_category)
	return FALSE

/datum/decree/proc/apply_rate_cap(mob/living/payer, tax_category, current_cap)
	return current_cap

/datum/decree/proc/on_revoke()
	return

/datum/decree/proc/on_restore()
	return

/datum/decree/proc/can_change_state()
	return world.time >= cooldown_expires

/datum/decree/proc/set_state(new_active)
	if(active == new_active)
		return FALSE
	active = new_active
	year = CALENDAR_EPOCH_YEAR
	cooldown_expires = world.time + DECREE_COOLDOWN
	if(active)
		on_restore()
	else
		on_revoke()
	return TRUE
