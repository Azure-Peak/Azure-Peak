/datum/patron/inhumen/graggar
	name = "Graggar"
	domain = "God of Conquest, War, Strategy, Bind-Breaking"
	desc = "Slave orc turned deity, said by the Holy Ecclesial to have been blessed by Ravox himself. He took his blessings to wage a bloody war against his once-captors, and then continued his conquest in his own name. Some Graggarites might care for honor, however many do not- what matters are results, and victory at a reasonable cost."
	worshippers = "Prisoners, Slaves, Militants, and the Cruel"
	mob_traits = list(TRAIT_HORDE, TRAIT_ORGAN_EATER)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/graggar_bloodrage				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/call_to_slaughter 				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/projectile/blood_net 			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/revel_in_slaughter 			= CLERIC_T3,
	)
	confess_lines = list(
		"GRAGGAR IS THE BEAST I WORSHIP!",
		"THROUGH VIOLENCE, DIVINITY!",
		"THE GOD OF CONQUEST DEMANDS BLOOD!",
	)
	storyteller = /datum/storyteller/graggar

/datum/patron/inhumen/graggar/on_lesser_heal(
    mob/living/user,
    mob/living/target,
    message_out,
    message_self,
    conditional_buff,
    situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("Foul fumes billow outward as [target] is restored!")
	*message_self = span_notice("A noxious scent burns my nostrils, but I feel better!")

	var/bonus = 0

	for(var/obj/effect/decal/cleanable/blood/blood in oview(5, target))
		bonus = min(bonus + 0.1, 2.5)
	
	if(!bonus)
		return
		
	*situational_bonus = bonus
	*conditional_buff = TRUE

/datum/patron/inhumen/graggar/on_gain(mob/living/living)
	. = ..()
	
	RegisterSignal(living, COMSIG_LIVING_DRINKED_LIMB_BLOOD, PROC_REF(on_drink_blood))

/datum/patron/inhumen/graggar/proc/on_drink_blood(mob/living/drinker, mob/living/target)
	SIGNAL_HANDLER

	drinker.adjust_hydration(8)

/datum/patron/inhumen/graggar/on_loss(mob/living/living)
	. = ..()
	
	UnregisterSignal(living, COMSIG_LIVING_DRINKED_LIMB_BLOOD)

// When bleeding, near blood on ground, zchurch, bad-cross, or ritual chalk
/datum/patron/inhumen/graggar/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/under/cave/inhumen))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/zizocross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That acursed cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer if actively bleeding.
	if(follower.bleed_rate > 0)
		return TRUE
	// Allows prayer near blood.
	for(var/obj/effect/decal/cleanable/blood in view(3, get_turf(follower)))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/graggar in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Graggar to hear my prayers I must either be in the church of the abandoned, near an inverted psycross, near fresh blood or draw blood of my own!"))
	return FALSE
