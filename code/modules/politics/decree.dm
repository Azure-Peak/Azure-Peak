/datum/decree
	var/id
	var/name
	var/year
	var/flavor_text
	var/active = TRUE
	var/cooldown_expires = 0
	var/revoke_text
	var/restore_text

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

/// Returns the updated poll-tax daily rate (in mammon) for this payer. Decrees may narrow it.
/// Applied after the base per-category rate is looked up. Return `current_rate` for no change.
/datum/decree/proc/apply_poll_tax_cap(mob/living/payer, poll_category, current_rate)
	return current_rate

/// Returns the updated daily fine ceiling (in mammon) for this payer. Decrees may narrow it.
/datum/decree/proc/apply_daily_fine_cap(mob/living/payer, current_remaining)
	return current_remaining

/// Called after a fine is actually transferred, so decrees can track running totals.
/datum/decree/proc/on_fine_applied(mob/living/payer, amount)
	return

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
	broadcast_state_change()
	return TRUE

/datum/decree/proc/broadcast_state_change()
	var/template = active ? restore_text : revoke_text
	if(!template)
		return
	var/ruler_type = SSticker?.rulertype || "Lord"
	var/body = replacetext(template, "%RULER%", ruler_type)
	var/title = active ? "BY LORDLY MERCY" : "BY LORDLY DECREE"
	priority_announce(body, title, pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)
