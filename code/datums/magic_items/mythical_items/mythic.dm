#define INFERNAL_FLAME_COOLDOWN 20 SECONDS
#define FREEZING_COOLDOWN 20 SECONDS
#define REWIND_COOLDOWN 20 SECONDS
#define CHAOS_COOLDOWN 10 SECONDS

//T4 Enchantments
/datum/magic_item/mythic/infernalflame
	name = "infernal flame"
	description = "It glows with white hot heat."
	var/last_used
	var/warned

/datum/magic_item/mythic/infernalflame/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < src.last_used + INFERNAL_FLAME_COOLDOWN)
		return
	if(isliving(target))
		var/mob/living/targeted = target
		targeted.adjust_fire_stacks(10)
		targeted.ignite_mob()
		targeted.visible_message(span_danger("[source] sets [targeted] on fire!"))
		src.last_used = world.time

/datum/magic_item/mythic/infernalflame/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	if(world.time < src.last_used + INFERNAL_FLAME_COOLDOWN)
		if(!warned)
			to_chat(firer, span_notice("[fired_from] is not yet ready to immolate!"))
			warned = TRUE
	if(isliving(firer) && isliving(target))
		var/mob/living/damaging = target
		if(damaging.stat != DEAD)
			damaging.adjust_fire_stacks(10)
			damaging.ignite_mob()
			damaging.visible_message(span_danger("[fired_from] sets [damaging] on fire!"))
			src.last_used = world.time

/datum/magic_item/mythic/infernalflame/on_hit_response(var/obj/item/I, var/mob/living/carbon/human/owner, var/mob/living/carbon/human/attacker)
	if(world.time < src.last_used + INFERNAL_FLAME_COOLDOWN)
		return
	if(isliving(attacker) && attacker != owner)
		attacker.adjust_fire_stacks(10)
		attacker.ignite_mob()
		attacker.visible_message(span_danger("[I] sets [attacker] on fire!"))
		src.last_used = world.time

/datum/magic_item/mythic/freezing
	name = "freezing"
	description = "It feels ice cold."
	var/last_used
	var/warned
/datum/magic_item/mythic/freezing/on_hit_response(var/obj/item/I, var/mob/living/carbon/human/owner, var/mob/living/carbon/human/attacker)
	if(world.time < src.last_used + FREEZING_COOLDOWN)
		return
	if(isliving(attacker) && attacker != owner)
		attacker.apply_status_effect(/datum/status_effect/freon/freezing)
		attacker.visible_message(span_danger("[I] freezes [attacker] solid!"))
		src.last_used = world.time

/datum/magic_item/mythic/freezing/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	if(world.time < src.last_used + FREEZING_COOLDOWN)
		if(!warned)
			to_chat(firer, span_notice("[fired_from] is not yet ready to glaciate!"))
			warned = TRUE
	if(isliving(firer) && isliving(target))
		var/mob/living/damaging = target
		if(damaging.stat != DEAD)
			damaging.apply_status_effect(/datum/status_effect/freon/freezing)
			damaging.visible_message(span_danger("[fired_from] freezes[damaging] solid!"))
			src.last_used = world.time

/datum/magic_item/mythic/freezing/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < src.last_used + FREEZING_COOLDOWN)
		return
	if(isliving(target))
		var/mob/living/targeted = target
		targeted.apply_status_effect(/datum/status_effect/freon/freezing)
		targeted.visible_message(span_danger("[source] freezes [targeted] solid!"))
		src.last_used = world.time

/datum/magic_item/mythic/briarcurse
	name = "Briar's Curse"
	description = "Its grip seems thorny. Must hurt to use."
	var/last_used

/datum/magic_item/mythic/briarcurse/on_apply(var/obj/item/i)
	.=..()
	i.force = i.force + 10
	if (i.force_wielded)
		i.force_wielded = i.force_wielded + 10

/datum/magic_item/mythic/briarcurse/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	.=..()
	if(!proximity_flag)
		return
	if(isliving(target))
		var/mob/living/carbon/targeted = target
		targeted.adjustBruteLoss(10)
		to_chat(target, span_notice("[source] gouges you with its sharp edges!"))

/datum/magic_item/mythic/rewind
	name = "Temporal Rewind"
	description = "Its seems both old and new at the same time."
	var/last_used
	var/active_item = FALSE
	var/warned = FALSE

/datum/magic_item/mythic/rewind/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	.=..()
	if(!proximity_flag)
		return
	if(world.time < src.last_used + REWIND_COOLDOWN)
		return
	else
		var/turf/target_turf = get_turf(user)
		active_item = TRUE
		sleep(5 SECONDS)
		to_chat(user, span_notice("[source] rewinds you back in time!"))
		do_teleport(user, target_turf, channel = TELEPORT_CHANNEL_QUANTUM)
		src.last_used = world.time

/datum/magic_item/mythic/rewind/on_hit_response(var/obj/item/I, var/mob/living/carbon/human/owner, var/mob/living/carbon/human/attacker)
	if(world.time < src.last_used + REWIND_COOLDOWN)
		return
	if(!active_item)
		var/turf/target_turf = get_turf(owner)
		active_item = TRUE
		sleep(5 SECONDS)
		to_chat(owner, span_notice("[I] rewinds you back in time!"))
		do_teleport(owner, target_turf, channel = TELEPORT_CHANNEL_QUANTUM)
		src.last_used = world.time
		active_item = FALSE


/datum/magic_item/mythic/chaos_storm
	name = "chaos storm"
	description = "Its crackles with unpredictable chaotic energy."
	var/last_used

/datum/magic_item/mythic/chaos_storm/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	.=..()
	if(!proximity_flag)
		return
	if(world.time < (src.last_used + CHAOS_COOLDOWN))
		return
	if(isliving(target))
		var/mob/living/L = target
		switch(rand(1,5))
			if(1)
				L.apply_damage(15, BURN)
				L.adjust_fire_stacks(5)
				L.ignite_mob()
				to_chat(L, span_warning("Chaotic flames engulf you!"))
			if(2)
				L.apply_damage(10, BRUTE)
				L.Knockdown(20)
				to_chat(L, span_warning("Chaotic force slams into you!"))
			if(3)
				L.electrocute_act(12, source, 1)
				to_chat(L, span_warning("Chaotic lightning courses through you!"))
			if(4)
				L.OffBalance(2.5 SECONDS)
				to_chat(L, span_warning("Chaotic energy disrupts your coordination!"))
			if(5)
				L.confused += 2 SECONDS
				to_chat(L, span_warning("Chaotic energy scrambles your thoughts!"))
		src.last_used = world.time

#undef INFERNAL_FLAME_COOLDOWN
#undef FREEZING_COOLDOWN
#undef REWIND_COOLDOWN
#undef CHAOS_COOLDOWN
