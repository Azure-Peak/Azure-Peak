
/datum/coven/quietus
	name = "Quietus"
	desc = "Live in the shadows striking only when needed. Poisons, mass-confusion and fire."
	icon_state = "daimonion"
	power_type = /datum/coven_power/quietus
	clan_restricted = FALSE

/datum/coven_power/quietus
	name = "Quietus power name"
	desc = "Quietus power description"

//SILENCE OF DEATH
/datum/coven_power/quietus/silence_of_death
	name = "Silence of Death"
	desc = "Create an area of pure silence around you, confusing those within it."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	duration_length = 20 SECONDS
	cooldown_length = 60 SECONDS
	var/datum/proximity_monitor/advanced/silence_field/proximity_field
	var/silence_range = 7
	var/validation_timer

/datum/coven_power/quietus/silence_of_death/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(!proximity_field)
		proximity_field = new /datum/proximity_monitor/advanced/silence_field(owner, silence_range, FALSE, src)
		// Apply silence to all mobs currently in range
		apply_initial_silence()
		// Start validation timer to check positions periodically - this is really redundant but its useful incases of forceMove
		validation_timer = addtimer(CALLBACK(src, PROC_REF(validate_silence_field)), 1 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/datum/coven_power/quietus/silence_of_death/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(proximity_field)
		QDEL_NULL(proximity_field)
	if(validation_timer)
		deltimer(validation_timer)
		validation_timer = null

/datum/coven_power/quietus/silence_of_death/proc/apply_initial_silence()
	if(!owner || !proximity_field)
		return

	// Find all mobs within range and apply silence
	for(var/mob/living/carbon/human/target in range(silence_range, owner))
		if(should_affect_target(target))
			proximity_field.add_affected_mob(target)

/datum/coven_power/quietus/silence_of_death/proc/validate_silence_field()
	if(!owner || !proximity_field)
		return

	var/list/current_affected = proximity_field.affected_mobs.Copy()

	// Check each affected mob to see if they're still in range
	for(var/mob/living/carbon/human/target in current_affected)
		if(!target || target.z != owner.z || get_dist(owner, target) > silence_range)
			proximity_field.remove_affected_mob(target)

	// Check for new mobs that entered range
	for(var/mob/living/carbon/human/target in range(silence_range, owner))
		if(should_affect_target(target) && !(target in proximity_field.affected_mobs))
			proximity_field.add_affected_mob(target)

/datum/coven_power/quietus/silence_of_death/proc/should_affect_target(mob/living/carbon/human/target)
	if(!owner || !target)
		return FALSE
	if(target == owner)
		return FALSE
	if(!owner.clan_position || !target.clan_position)
		return TRUE
	if(target.clan_position.is_subordinate_to(owner.clan_position))
		return FALSE
	if(target.clan_position.is_superior_to(owner.clan_position))
		return FALSE
	return TRUE

/datum/coven_power/quietus/silence_of_death/proc/apply_silence(mob/living/carbon/human/target)
	if(!should_affect_target(target))
		return
	if(!HAS_TRAIT(target, TRAIT_SILENT_FOOTSTEPS))
		ADD_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(!HAS_TRAIT(target, TRAIT_DEAF))
		ADD_TRAIT(target, TRAIT_DEAF, "quietus")
		if(target.confused < 5)
			target.confused += 1

/datum/coven_power/quietus/silence_of_death/proc/remove_silence(mob/living/carbon/human/target)
	if(HAS_TRAIT_FROM(target, TRAIT_DEAF, "quietus"))
		REMOVE_TRAIT(target, TRAIT_DEAF, "quietus")
	if(HAS_TRAIT_FROM(target, TRAIT_SILENT_FOOTSTEPS, "quietus"))
		REMOVE_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, "quietus")

// Proximity monitor for the silence field
/datum/proximity_monitor/advanced/silence_field
	var/datum/coven_power/quietus/silence_of_death/parent_power
	var/list/affected_mobs = list()

/datum/proximity_monitor/advanced/silence_field/New(atom/center, range, ignore_if_not_on_turf, datum/coven_power/quietus/silence_of_death/power)
	parent_power = power
	. = ..()

/datum/proximity_monitor/advanced/silence_field/setup_field_turf(turf/target)
	. = ..()
	// Check for any mobs already on this turf
	for(var/mob/living/carbon/human/H in target)
		if(parent_power.should_affect_target(H))
			add_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/field_edge_crossed(atom/movable/movable, turf/location, direction)
	. = ..()
	if(istype(movable, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = movable
		if(parent_power.should_affect_target(H))
			add_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/field_edge_uncrossed(atom/movable/movable, turf/location, direction)
	. = ..()
	if(istype(movable, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = movable
		remove_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/proc/add_affected_mob(mob/living/carbon/human/target)
	if(target in affected_mobs)
		return
	affected_mobs |= target
	parent_power.apply_silence(target)

/datum/proximity_monitor/advanced/silence_field/proc/remove_affected_mob(mob/living/carbon/human/target)
	if(!(target in affected_mobs))
		return
	affected_mobs -= target
	parent_power.remove_silence(target)

/datum/proximity_monitor/advanced/silence_field/Destroy()
	// Clean up all affected mobs when the field is destroyed
	for(var/mob/living/carbon/human/H in affected_mobs)
		parent_power.remove_silence(H)
	affected_mobs.Cut()
	parent_power = null
	return ..()

/datum/coven_power/quietus/scorpions_touch
	name = "Scorpion's Touch"
	desc = "Utilize your vitae to cause blood to ooze out faster, and for wounds to become more painful."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING | COVEN_CHECK_FREE_HAND
	violates_masquerade = TRUE
	cooldown_length = 60 SECONDS
	vitae_cost = 150

/datum/coven_power/quietus/scorpions_touch/activate()
	. = ..()
	owner.put_in_hands(new /obj/item/melee/touch_attack/quietus(owner))

//SCORPION'S TOUCH
/obj/item/melee/touch_attack/quietus
	name = "\improper poison touch"
	desc = "Vile, black vitae dribbling down a hand, ready to seep into a wound."
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = COLOR_ALMOST_BLACK
	on_use_sound = 'sound/magic/bloodrot.ogg'

/obj/item/melee/touch_attack/quietus/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/debuff/blackvitae)
		living_target.visible_message(span_warning("[target]'s wounds begin to fester and rot!"))
		to_chat(living_target, span_danger("WHAT ACHES NOW SEETHES WITH AGONY! EVERYTHING HURTS <span class='italics'>MORE</span>!"))
	return ..()

//DAGON'S CALL
/datum/coven_power/quietus/dagons_call
	name = "Dagon's Call"
	desc = "Curse the last person you attacked to drown in their own blood."

	level = 3
	research_cost = 2
	vitae_cost = 200
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	cooldown_length = 120 SECONDS

/datum/coven_power/quietus/dagons_call/can_activate(atom/target, alert = FALSE)
	. = ..()
	var/mob/living/lastattacker = owner.lastattacker_weakref?.resolve()
	if(!isliving(lastattacker))
		to_chat(owner, span_warning("You don't seem to have last attacked soul earlier..."))
		return FALSE
	if(get_dist(owner, lastattacker) > 10)
		to_chat(owner, span_warning("They're too far to curse."))
		return FALSE
	else
		return .

/datum/coven_power/quietus/dagons_call/activate()
	. = ..()
	var/mob/living/lastattacker = owner.lastattacker_weakref?.resolve()
	owner.emote("snap", forced = TRUE)
	playsound(lastattacker, 'sound/magic/bloodcurse.ogg', 40, FALSE)
	lastattacker.reagents.add_reagent(/datum/reagent/bloodacid, 3)
	to_chat(owner, "You send your curse on [lastattacker], the last creature you attacked.")

//BAAL'S CARESS
/datum/coven_power/quietus/baals_caress
	name = "Baal's Caress"
	desc = "Impale yourself to imbue your weapon with your vitae, making it deadlier for three strikes, and applying a poison for the first strike."

	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	vitae_cost = 250
	target_type = NONE
	violates_masquerade = TRUE
	cooldown_length = 60 SECONDS

/datum/coven_power/quietus/baals_caress/can_activate(atom/target, alert = FALSE)
	. = ..()
	var/obj/item/rogueweapon/target_weapon = owner.get_active_held_item()
	if(!istype(target_weapon))
		if(alert)
			to_chat(owner, span_warning("[src] can only be used on weapons!"))
		return FALSE

	if(!target_weapon.sharpness)
		if(alert)
			to_chat(owner, span_warning("[src] can only be used on bladed weapons!"))
		return FALSE

	return .

/datum/coven_power/quietus/baals_caress/activate(obj/item/rogueweapon/target)
	. = ..()
	var/obj/item/rogueweapon/target_weapon = owner.get_active_held_item()
	if(do_after(owner, 1 SECONDS))
		if(target_weapon.GetComponent(/datum/component/bloodblade))
			qdel(target_weapon.GetComponent(/datum/component/bloodblade))
	owner.visible_message(span_danger("[owner] impales themselves with [target_weapon]!"))
	playsound(owner, 'sound/combat/wound_tear.ogg', 100, TRUE, -2)
	playsound(owner, 'sound/magic/bloodbladestart.ogg', 25, TRUE, -2)
	if(do_after(owner, 2 SECONDS))
		playsound(owner, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
		playsound(owner, 'sound/magic/bloodbladeend.ogg', 25, TRUE, -2)
		target_weapon.AddComponent(/datum/component/bloodblade)
		target.AddElement(/datum/element/one_time_poison, list(/datum/reagent/bloodacid = 1))
		return TRUE
	else
		to_chat(owner, span_warning("We were interrupted!"))
	return FALSE

/datum/coven_power/quietus/taste_of_death
	name = "Taste of Death"
	desc = "Spit a glob of caustic blood at your enemies."

	level = 5
	research_cost = 4
	minimal_generation = GENERATION_ANCILLAE
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	violates_masquerade = TRUE

/datum/coven_power/quietus/taste_of_death/post_gain()
	. = ..()
	owner.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/acidsplash/quietus)

/obj/effect/proc_holder/spell/invoked/projectile/acidsplash/quietus
	projectile_type = /obj/projectile/magic/acidsplash/quietus
	invocations = list("lobs a glob of acid!")
	invocation_type = "emote"

/obj/projectile/magic/acidsplash/quietus
	damage = 40
	speed = 2

/obj/projectile/magic/acidsplash/quietus/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/turf/T = get_turf(src)
	playsound(src, 'sound/magic/bloodball.ogg', 100)

	for(var/mob/living/L in range(aoe_range, get_turf(src))) //apply damage over time to mobs
		if(!L.anti_magic_check())
			L.apply_status_effect(/datum/status_effect/buff/acidsplash)
			L.reagents.add_reagent(/datum/reagent/bloodacid, 1)
			new /obj/effect/temp_visual/acidsplash(get_turf(L))
	for(var/turf/turfs_in_range in range(aoe_range+1, T)) //make a splash
		new /obj/effect/temp_visual/acidsplash(T)
