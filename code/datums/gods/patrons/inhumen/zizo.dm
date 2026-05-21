/datum/patron/inhumen/zizo
	name = "Zizo"
	domain = "Progress, Undeath, Hubris, Left Hand Magicks"
	desc = "A once-mortal snow elf turned god. Her hubris in thinking she could harvest lux from the planet itself led to the elimination of her entire race. Her works are still used to this dae in some cases."
	worshippers = "Necromancers, Researchers, Warlocks, and the Undead"
	mob_traits = list(TRAIT_CABAL, TRAIT_ZIZOSIGHT)
	miracles = list(/datum/action/cooldown/spell/touch/orison							= CLERIC_ORI,
					/datum/action/cooldown/spell/zizo/snuff_lights						= CLERIC_T0,
					/datum/action/cooldown/spell/miracle/heal							= CLERIC_T1,
					/datum/action/cooldown/spell/miracle/bloodmiracle					= CLERIC_T1,
					/datum/action/cooldown/spell/projectile/zizo/profane				= CLERIC_T1,
					/datum/action/cooldown/spell/raise_undead_formation/zizo	 		= CLERIC_T2,
					/datum/action/cooldown/spell/zizo/bone_cataclysm					= CLERIC_T2,
					/datum/action/cooldown/spell/tame_undead/zizo						= CLERIC_T3,
					/datum/action/cooldown/spell/zizo/rituos 							= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/zizo				= CLERIC_T3,
					/datum/action/cooldown/spell/convert_heretic						= CLERIC_T4,
					/datum/action/cooldown/spell/lacrima/zizo							= CLERIC_T4,	
	)
	confess_lines = list(
		"PRAISE ZIZO!",
		"LONG LIVE ZIZO!",
		"ZIZO IS QUEEN!",
	)
	storyteller = /datum/storyteller/zizo

	titles = list(
		"Dame of Progress",
		"Lady of Progress",
		"Lady of Secrets",
		"Dame of Secrets",
		"Arch Lych"
	)

/datum/patron/inhumen/zizo/post_equip(mob/living/pious)
	. = ..()
	if(ishuman(pious))
		var/mob/living/carbon/human/human = pious
		var/datum/devotion/pious_devotion = human.devotion
		if(pious_devotion?.level >= CLERIC_T2)
			pious.grant_language(/datum/language/undead)

// When the sun is blotted out, zchurch, bad-cross, or ritual chalk
/datum/patron/inhumen/zizo/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/under/cave/inhumen))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/zizocross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That accursed cross interrupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer near a grave.
	for(var/obj/structure/closet/dirthole/grave/G in view(4, get_turf(follower)))
		return TRUE
	// Allows prayer during the sun being blotted from the sky.
	if(hasomen(OMEN_SUNSTEAL))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/zizo in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Zizo to hear my prayers I must either be in the church of the abandoned, near an inverted psycross, atop a drawn Zizite symbol, or while the sun is blotted from the sky!"))
	return FALSE

/datum/patron/inhumen/zizo/on_lesser_heal(
    mob/living/user,
    mob/living/target,
    message_out,
    message_self,
    conditional_buff,
    situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("Vital energies are sapped towards [target]!")
	*message_self = span_notice("The life around me pales as I am restored!")

	var/bonus = 0

	for(var/obj/item/natural/bone/bone in oview(5, user))
		bonus += 0.5

	for(var/obj/item/natural/bundle/bone/bone in oview(5, user))
		bonus += (bone.amount * 0.5)

	if(!bonus)
		return

	*conditional_buff = TRUE
	*situational_bonus = min(bonus, 5)
