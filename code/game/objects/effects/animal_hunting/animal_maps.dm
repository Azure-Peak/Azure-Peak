/obj/item/hunting_map
	name = "crumpled map"
	desc = "A rough sketch of animal migratory patterns and bedding sites."
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "hunt_map"
	w_class = WEIGHT_CLASS_TINY
	/// Category this map forces
	var/datum/hunting_category/target_category = /datum/hunting_category/low_tier
	/// Skill-based success chances (0-6)
	var/list/skill_chances = list(0, 0, 0, 0, 0, 0, 0)
	/// How much the chance drops per use (0.1 = 10%)
	var/degradation_rate = 0
	/// Current degradation multiplier (1.0 = 100% effectiveness)
	var/current_potency = 1.0
	/// Hard limit on uses
	var/uses_left = -1 

/obj/item/hunting_map/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Click a hunt map onto a fresh mound to apply a % increase to find the corresponding creechers.")
	. += span_info("Some maps scale with hunting skill.")
	. += span_info("Some maps degrade when used, getting worse or breaking entirely.")

/obj/item/hunting_map/afterattack(obj/effect/hunting_track/target, mob/user, proximity)
	if(!proximity || !istype(target))
		return

	if(target.trail_depth > 0 || target.track_revealed)
		to_chat(user, span_warning("The trail is already cold or established. You must use this on a fresh mound."))
		return

	if(target.hunt_category)
		to_chat(user, span_warning("This trail has already been identified."))
		return

	if(target.influence_attempted)
		to_chat(user, span_warning("This trail has been cross-examined with a map for the best routes."))
		return

	user.visible_message(span_notice("[user] consults [src] while examining the earth."), \
		span_notice("You cross-reference the signs in the dirt with the markings on [src]..."))

	if(!do_after(user, 3 SECONDS, target = target))
		return

	var/skill = user.get_skill_level(/datum/skill/misc/hunting)
	var/base_chance = skill_chances[skill + 1]
	var/final_chance = base_chance * current_potency

	if(prob(final_chance))
		target.secret_map_influence = target_category
	target.influence_attempted = TRUE
	to_chat(user, span_info("You feel a bit more confident about the direction of this trail."))

	// Handle Degradation
	if(degradation_rate > 0)
		current_potency = max(0, current_potency - degradation_rate)
		if(current_potency <= 0)
			to_chat(user, span_danger("[src] has become completely illegible and falls apart."))
			qdel(src)
			return

	// Handle Use Limit
	if(uses_left > 0)
		uses_left--
		if(uses_left <= 0)
			to_chat(user, span_danger("[src] tears into useless scraps from heavy use."))
			qdel(src)

/obj/item/hunting_map/white_stag
	name = "legend of the white stag"
	desc = "An esoteric map detailed with blessed silver ink. It claims to track the movements of a Great White Stag. Only the best hunters can decipher the signs properly when examining this against an animal track."
	target_category = /datum/hunting_category/white_stag
	skill_chances = list(1, 1, 5, 10, 14, 18, 20)
	degradation_rate = 0.1 // 10% drop per use
	uses_left = 3

/obj/item/hunting_map/white_stag/debug
	skill_chances = list(100, 100, 100, 100, 100, 100, 100)
	uses_left = 1
	degradation_rate = 0

/obj/item/hunting_map/boars
	name = "boar signs"
	desc = "A simple map denoting recent areas where there have been boar attacks. It is easy to use for skilled hunters"
	target_category = /datum/hunting_category/boars
	skill_chances = list(20, 30, 40, 50, 70, 90, 100)
	degradation_rate = 0
	uses_left = 5
