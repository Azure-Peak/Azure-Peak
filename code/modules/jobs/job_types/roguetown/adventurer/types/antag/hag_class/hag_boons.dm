// Kinda glorified status effects. But they may apply a status effect or something else entirely.
// Since hags can mess with these from a distance, and they're tied to a specific hag,
// we don't want to store these on the mob like status effects.

/datum/hag_boon
	var/name = "Generic Boon"
	var/time_granted = 0
	var/true_name = ""

/datum/hag_boon/New(t_name)
	src.time_granted = world.time
	src.true_name = t_name
	var/mob/living/L = find_target()
	if(L)
		apply_boon_effect(L)

/datum/hag_boon/Destroy()
	var/mob/living/L = find_target()
	if(L)
		remove_boon_effect(L)
	return ..()

/datum/hag_boon/proc/find_target()
	for(var/mob/living/L in GLOB.player_list)
		if(L.real_name == true_name)
			return L
	return null

/datum/hag_boon/proc/apply_boon_effect(mob/living/L)
	// Apply status effects, mutations, etc.
	return

/datum/hag_boon/proc/remove_boon_effect(mob/living/L)
	// Strip those same effects
	return

/// HAG BOON DATUMS ///

/datum/hag_boon/item_debt
	name = "Material Pact"
	var/points = 0

/datum/hag_boon/item_debt/proc/add_points(amt)
	points += amt
