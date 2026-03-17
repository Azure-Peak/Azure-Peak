// Kinda glorified status effects. But they may apply a status effect or something else entirely.
// Since hags can mess with these from a distance, and they're tied to a specific hag,
// we don't want to store these on the mob like status effects.

/datum/hag_boon
	var/name = "Generic Boon"
	var/desc = "A boon description"
	var/time_granted = 0
	var/true_name = ""
	var/datum/component/hag_curio_tracker/tracker
	/// How powerful a boon is. Not used for all types of boons.
	var/points = 1
	/// Whether or not this boon can be transmuted into a curse. 
	/// Curses should never be able to transmuted.
	/// Some boons can only be triggered into specific curses, rather than free form.
	var/transmutable = TRUE
	var/hag_curse = FALSE

/datum/hag_boon/New(t_name, datum/component/hag_curio_tracker/T, set_points)
	src.time_granted = world.time
	src.true_name = t_name
	src.tracker = T
	src.points = set_points
	var/mob/living/L = find_target()
	to_chat(world, "DEBUG: Attempting to apply [src] to [L] finding [true_name] with [points] points.")
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
	// Fallback in case someone ghosts or druid shenaniganery!
	for(var/mob/living/L in GLOB.mob_living_list)
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

/datum/hag_boon/item_debt/proc/add_points(amt)
	points += amt
