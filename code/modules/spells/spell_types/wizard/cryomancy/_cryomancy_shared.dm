// Cryomancy shared — frost stack status effects and helper procs
// Four tiers: frosted1 (-1 SPD), frosted2 (-2 SPD, 1.1x action CD),
// frosted3 (-3 SPD, 1.2x action CD), frosted4 (frozen: x2 move slow for 8s, 15s immunity)
// Fire spells shatter frost stacks (handled in fire spell on_hit procs)

#define FROST_OVERLAY_COLOR rgb(136, 191, 255)
#define FROZEN_DURATION (8 SECONDS)
#define FROZEN_IMMUNITY_DURATION (15 SECONDS)
#define FROZEN_IMMUNITY_KEY "frozen_immunity"
#define MOVESPEED_ID_FROZEN "frozen_slowdown"

/// Apply one frost stack to the target. Escalates frosted1 → frosted2 → frosted3 → frosted4 (frozen).
/proc/apply_frost_stack(mob/living/target, stacks = 1)
	if(!isliving(target))
		return
	var/final_tier = 0
	for(var/i in 1 to stacks)
		if(target.has_status_effect(/datum/status_effect/debuff/frosted4))
			target.apply_status_effect(/datum/status_effect/debuff/frosted4)
			final_tier = max(final_tier, 4)
			return
		if(target.has_status_effect(/datum/status_effect/debuff/frosted3))
			if(target.mob_timers[FROZEN_IMMUNITY_KEY] && world.time < target.mob_timers[FROZEN_IMMUNITY_KEY])
				target.apply_status_effect(/datum/status_effect/debuff/frosted3)
				var/remaining = round((target.mob_timers[FROZEN_IMMUNITY_KEY] - world.time) / 10)
				target.balloon_alert_to_viewers("<font color='#4cadee'>frost adapted ([remaining]s)</font>")
				final_tier = max(final_tier, 3)
				break
			target.remove_status_effect(/datum/status_effect/debuff/frosted3)
			target.apply_status_effect(/datum/status_effect/debuff/frosted4)
			final_tier = 4
			continue
		if(target.has_status_effect(/datum/status_effect/debuff/frosted2))
			target.remove_status_effect(/datum/status_effect/debuff/frosted2)
			target.apply_status_effect(/datum/status_effect/debuff/frosted3)
			final_tier = 3
			continue
		if(target.has_status_effect(/datum/status_effect/debuff/frosted1))
			target.remove_status_effect(/datum/status_effect/debuff/frosted1)
			target.apply_status_effect(/datum/status_effect/debuff/frosted2)
			final_tier = 2
			continue
		target.apply_status_effect(/datum/status_effect/debuff/frosted1)
		final_tier = max(final_tier, 1)
	// Single alert for the final tier reached
	switch(final_tier)
		if(1)
			target.balloon_alert_to_viewers("<font color='#4cadee'>frosted I (-1 spd)!</font>")
		if(2)
			target.balloon_alert_to_viewers("<font color='#4cadee'>frosted II (-2 spd, 1.1x slow)!</font>")
		if(3)
			target.balloon_alert_to_viewers("<font color='#4cadee'>frosted III (-3 spd, 1.2x slow)!</font>")
		if(4)
			target.balloon_alert_to_viewers("<font color='#4cadee'>frozen IV!</font>")

/// Decrement one frost stack from the target. Used by fire spells.
/// Returns TRUE if a stack was removed.
/proc/remove_frost_stack(mob/living/target)
	if(!isliving(target))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/frosted4))
		target.remove_status_effect(/datum/status_effect/debuff/frosted4)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/frosted3))
		target.remove_status_effect(/datum/status_effect/debuff/frosted3)
		target.apply_status_effect(/datum/status_effect/debuff/frosted2)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/frosted2))
		target.remove_status_effect(/datum/status_effect/debuff/frosted2)
		target.apply_status_effect(/datum/status_effect/debuff/frosted1)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/frosted1))
		target.remove_status_effect(/datum/status_effect/debuff/frosted1)
		return TRUE
	return FALSE

/// Check if the target has any frost stacks.
/proc/has_frost_stacks(mob/living/target)
	if(!isliving(target))
		return FALSE
	return target.has_status_effect(/datum/status_effect/debuff/frosted1) || \
		target.has_status_effect(/datum/status_effect/debuff/frosted2) || \
		target.has_status_effect(/datum/status_effect/debuff/frosted3) || \
		target.has_status_effect(/datum/status_effect/debuff/frosted4)

/// Returns the current frost stack count (0-4).
/proc/get_frost_stacks(mob/living/target)
	if(!isliving(target))
		return 0
	if(target.has_status_effect(/datum/status_effect/debuff/frosted4))
		return 4
	if(target.has_status_effect(/datum/status_effect/debuff/frosted3))
		return 3
	if(target.has_status_effect(/datum/status_effect/debuff/frosted2))
		return 2
	if(target.has_status_effect(/datum/status_effect/debuff/frosted1))
		return 1
	return 0

/// Remove all frost stacks. Used by fire damage to cleanse frozen state.
/proc/remove_all_frost_stacks(mob/living/target)
	if(!isliving(target))
		return
	target.remove_status_effect(/datum/status_effect/debuff/frosted4)
	target.remove_status_effect(/datum/status_effect/debuff/frosted3)
	target.remove_status_effect(/datum/status_effect/debuff/frosted2)
	target.remove_status_effect(/datum/status_effect/debuff/frosted1)

// --- Status Effects ---

/datum/status_effect/debuff/frosted1
	id = "frosted1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/frosted1
	duration = 15 SECONDS
	effectedstats = list(STATKEY_SPD = -1)

/atom/movable/screen/alert/status_effect/debuff/frosted1
	name = "Frosted"
	desc = "A chill seeps into my bones."
	icon_state = "debuff"

/datum/status_effect/debuff/frosted1/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(FROST_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)
	target.update_vision_cone()

/datum/status_effect/debuff/frosted1/on_remove()
	var/mob/living/target = owner
	target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, FROST_OVERLAY_COLOR)
	target.update_vision_cone()
	. = ..()

/datum/status_effect/debuff/frosted2
	id = "frosted2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/frosted2
	duration = 15 SECONDS
	effectedstats = list(STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/debuff/frosted2
	name = "Frosted II"
	desc = "The cold bites deep. My movements are sluggish."
	icon_state = "debuff"

/datum/status_effect/debuff/frosted2/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(FROST_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)
	target.update_vision_cone()

/datum/status_effect/debuff/frosted2/on_remove()
	var/mob/living/target = owner
	target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, FROST_OVERLAY_COLOR)
	target.update_vision_cone()
	. = ..()

/datum/status_effect/debuff/frosted2/nextmove_modifier()
	return 1.1

/datum/status_effect/debuff/frosted3
	id = "frosted3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/frosted3
	duration = 15 SECONDS
	effectedstats = list(STATKEY_SPD = -3)

/atom/movable/screen/alert/status_effect/debuff/frosted3
	name = "Frosted III"
	desc = "Frozen to the bone. I can barely move."
	icon_state = "debuff"

/datum/status_effect/debuff/frosted3/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(FROST_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)
	target.update_vision_cone()

/datum/status_effect/debuff/frosted3/on_remove()
	var/mob/living/target = owner
	target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, FROST_OVERLAY_COLOR)
	target.update_vision_cone()
	. = ..()

/datum/status_effect/debuff/frosted3/nextmove_modifier()
	return 1.2

// Frosted IV - Frozen: x2 movement slowdown for 8 seconds, 15s immunity after
/datum/status_effect/debuff/frosted4
	id = "frosted4"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/frosted4
	duration = FROZEN_DURATION

/atom/movable/screen/alert/status_effect/debuff/frosted4
	name = "Frozen"
	desc = "Completely frozen. I can barely move at all."
	icon_state = "debuff"

/datum/status_effect/debuff/frosted4/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(FROST_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)
	target.add_movespeed_modifier(MOVESPEED_ID_FROZEN, update = TRUE, priority = 100, multiplicative_slowdown = 2, movetypes = GROUND)
	target.update_vision_cone()
	target.visible_message(span_danger("[target] freezes solid!"), span_userdanger("My body seizes up - I'm frozen!"))
	playsound(get_turf(target), 'sound/spellbooks/crystal.ogg', 80, TRUE)

/datum/status_effect/debuff/frosted4/on_remove()
	var/mob/living/target = owner
	target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, FROST_OVERLAY_COLOR)
	target.remove_movespeed_modifier(MOVESPEED_ID_FROZEN)
	target.update_vision_cone()
	// Apply immunity window
	target.mob_timers[FROZEN_IMMUNITY_KEY] = world.time + FROZEN_IMMUNITY_DURATION
	. = ..()

// Temp visuals

/obj/effect/temp_visual/trapice
	icon = 'icons/effects/effects.dmi'
	icon_state = "frost"
	light_outer_range = 2
	light_color = "#4cadee"
	duration = 11
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/snap_freeze
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	name = "rippeling arcyne ice"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER

#undef FROST_OVERLAY_COLOR
#undef FROZEN_DURATION
#undef FROZEN_IMMUNITY_DURATION
#undef FROZEN_IMMUNITY_KEY
#undef MOVESPEED_ID_FROZEN
