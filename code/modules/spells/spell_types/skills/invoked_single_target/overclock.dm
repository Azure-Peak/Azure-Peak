/obj/effect/proc_holder/spell/invoked/overlock
	name = "Overclock"
	desc = "Force your prosthetics beyond their limits, your arms gain strength and legs gain speed for a short time, but risk damaging them."
	overlay_state = "overclock"
	releasedrain = 1
	chargedrain = 0
	chargetime = 0
	range = 0
	movement_interrupt = FALSE
	sound = 'sound/misc/clockloop.ogg'
	action_icon = 'icons/mob/actions/engineer_skills.dmi'
	invocation_type = "none"
	associated_skill = /datum/skill/craft/engineering
	antimagic_allowed = TRUE
	recharge_time = 5 MINUTES
	miracle = FALSE
	devotion_cost = 0

/obj/effect/proc_holder/spell/invoked/overlock/cast(list/targets, mob/living/user)
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user

	// Count prosthetic limbs and collect them going with the recommendations on this
	var/prosthetic_arms = 0
	var/prosthetic_legs = 0
	var/list/prosthetic_parts = list()

	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(!istype(BP, /obj/item/bodypart/l_arm/prosthetic) && \
		   !istype(BP, /obj/item/bodypart/r_arm/prosthetic) && \
		   !istype(BP, /obj/item/bodypart/l_leg/prosthetic) && \
		   !istype(BP, /obj/item/bodypart/r_leg/prosthetic))
			continue
		prosthetic_parts += BP
		if(istype(BP, /obj/item/bodypart/l_arm/prosthetic) || istype(BP, /obj/item/bodypart/r_arm/prosthetic))
			prosthetic_arms++
		else
			prosthetic_legs++

	//if we have no prosthetics we notify the user and remove the spell
	if(!length(prosthetic_parts))
		to_chat(H, span_warning("I have no prosthetic limbs to overclock!"))
		revert_cast()
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/invoked/overlock)
		return FALSE

	// a buff is applied based on the number of arms and legs. 
	H.apply_status_effect(/datum/status_effect/buff/overclock, prosthetic_arms, prosthetic_legs)
	H.visible_message(
		span_warning("[H]'s prosthetic limbs begin to whir and rattle loudly!"),
		span_notice("I push my prosthetics to their limit — I can feel them vibrating loudly.")
	)
	playsound(H, 'sound/misc/clockloop.ogg', 75, TRUE)

	// Roll for overload damage on each prosthetic
	for(var/obj/item/bodypart/BP in prosthetic_parts)
		var/overload_chance = get_overload_chance(BP)
		if(!overload_chance)
			continue
		if(prob(overload_chance))
			BP.take_damage(100, BRUTE, "blunt", FALSE)
			H.visible_message(
				span_danger("[H]'s [BP.name] sparks violently from the overload!"),
				span_danger("My [BP.name] screams with stress — something inside just broke!")
			)
			playsound(H, pick('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/grille (1).ogg'), 100, TRUE)
			var/datum/effect_system/spark_spread/S = new()
			S.set_up(2, TRUE, get_turf(H))
			S.start()

	return TRUE

/// Returns the overload chance % for a given prosthetic, this goes by the lowest quality prosthetic
/obj/effect/proc_holder/spell/invoked/overlock/proc/get_overload_chance(obj/item/bodypart/BP)
	// Bronze prosthetics — 50% chance
	if(istype(BP, /obj/item/bodypart/l_arm/prosthetic/bronzeleft) || \
	   istype(BP, /obj/item/bodypart/r_arm/prosthetic/bronzeright) || \
	   istype(BP, /obj/item/bodypart/l_leg/prosthetic/bronzeleft) || \
	   istype(BP, /obj/item/bodypart/r_leg/prosthetic/bronzeright))
		return 50

	// Steel or iron prosthetics — 35% chance
	if(istype(BP, /obj/item/bodypart/l_arm/prosthetic/iron) || \
	   istype(BP, /obj/item/bodypart/r_arm/prosthetic/iron) || \
	   istype(BP, /obj/item/bodypart/l_leg/prosthetic/iron) || \
	   istype(BP, /obj/item/bodypart/r_leg/prosthetic/iron) || \
	   istype(BP, /obj/item/bodypart/l_arm/prosthetic/steel) || \
	   istype(BP, /obj/item/bodypart/r_arm/prosthetic/steel) || \
	   istype(BP, /obj/item/bodypart/l_leg/prosthetic/steel) || \
	   istype(BP, /obj/item/bodypart/r_leg/prosthetic/steel))
		return 35

	// Gold prosthetics — no overload risk
	if(istype(BP, /obj/item/bodypart/l_arm/prosthetic/gold) || \
	   istype(BP, /obj/item/bodypart/r_arm/prosthetic/gold) || \
	   istype(BP, /obj/item/bodypart/l_leg/prosthetic/gold) || \
	   istype(BP, /obj/item/bodypart/r_leg/prosthetic/gold))
		return 0

	// Wooden or unknown — almost guaranteed overload
	return 50
