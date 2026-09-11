/mob/living/carbon/human/proc/handle_curses()
	for(var/curse in curses)
		var/datum/curse/C = curse
		C.on_life(src)

/mob/living/carbon/human/proc/add_curse(datum/curse/C)
	if(is_cursed(C))
		return FALSE

	C = new C()
	curses += C
	var/curse_resist = FALSE
	if(HAS_TRAIT(src, TRAIT_CURSE_RESIST))
		curse_resist = 0.5
	C.on_gain(src, curse_resist)
	return TRUE

/mob/living/carbon/human/proc/remove_curse(datum/curse/C)
	if(!is_cursed(C))
		return FALSE

	var/curse_resist = FALSE
	if(HAS_TRAIT(src, TRAIT_CURSE_RESIST))
		curse_resist = 0.5
	for(var/datum/curse/curse in curses)
		if(curse.name == C.name)
			curse.on_loss(src, curse_resist)
			curses -= curse
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/is_cursed(datum/curse/C)
	if(!C)
		return FALSE

	for(var/datum/curse/curse in curses)
		if(curse.name == C.name)
			return TRUE
	return FALSE

/datum/curse
	var/name = "Debug Curse"
	var/description = "This is a debug curse."
	var/trait

/datum/curse/proc/on_life(mob/living/carbon/human/owner)
	return

/datum/curse/proc/on_death(mob/living/carbon/human/owner)
	return

/datum/curse/proc/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	ADD_TRAIT(owner, trait, TRAIT_CURSE)
	to_chat(owner, span_userdanger("Something is wrong... I feel cursed."))
	to_chat(owner, span_danger(description))
	owner.playsound_local(get_turf(owner), 'sound/misc/excomm.ogg', 80, FALSE, pressure_affected = FALSE)
	return

/datum/curse/proc/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	REMOVE_TRAIT(owner, trait, TRAIT_CURSE)
	to_chat(owner, span_userdanger("Something has changed... I feel relieved."))
	owner.playsound_local(get_turf(owner), 'sound/misc/bell.ogg', 80, FALSE, pressure_affected = FALSE)
	qdel(src)
	return

//////////////////////
///	TEN CURSES	///
//////////////////////

/datum/curse/astrata
	name = "Curse of Astrata"
	description = "I am forsaken by the Sun. I will find no rest under Her unwavering gaze."
	trait = TRAIT_CURSE_ASTRATA

/datum/curse/noc
	name = "Curse of Noc"
	description = "I am forsaken by the Moon. I will find no salvation in His grace."
	trait = TRAIT_CURSE_NOC

/datum/curse/dendor
	name = "Curse of Dendor"
	description = "I am forsaken by the Treefather. Reason and common sense abandon me."
	trait = TRAIT_CURSE_DENDOR //Needs something unique but come up with it later:tm:

/datum/curse/abyssor
	name = "Curse of Abyssor"
	description = "I am forsaken by the Dreamer. His domain will surely become my grave."
	trait = TRAIT_CURSE_ABYSSOR

/datum/curse/ravox
	name = "Curse of Ravox"
	description = "I am forsaken by the Justicar. My opponents will show me no clemency."
	trait = TRAIT_CURSE_RAVOX

/datum/curse/necra
	name = "Curse of Necra"
	description = "I am forsaken by the Undermaiden. Even the lightest strike could send me into Her embrace."
	trait = TRAIT_CURSE_NECRA //Should be crit weakness still just flavour:tm:

/datum/curse/xylix
	name = "Curse of Xylix"
	description = "I am forsaken by the Trickster. Misfortune follows me on every step."
	trait = TRAIT_CURSE_XYLIX

/datum/curse/pestra
	name = "Curse of Pestra"
	description = "I am forsaken by the Plaguemother. Sickness overwhelms my body rendering even simplest of tasks into a challenge."
	trait = TRAIT_CURSE_PESTRA

/datum/curse/malum
	name = "Curse of Malum"
	description = "I am forsaken by the Maker. My hands tremble and fog overwhelms my mind."
	trait = TRAIT_CURSE_MALUM

/datum/curse/eora
	name = "Curse of Eora"
	description = "I am forsaken by the Lover. There is no beauty to be found for me in this world."
	trait = TRAIT_CURSE_EORA

////////////////////////////
///	ASCENDANT CURSES	///
////////////////////////////
/datum/curse/zizo
	name = "Curse of Zizo"
	description = "I am forsaken by the Architect. Her grasp reaches for my heart."
	trait = TRAIT_CURSE_ZIZO

/datum/curse/graggar
	name = "Curse of Graggar"
	description = "I am forsaken by the Warlord. Bloodlust is only thing I know for real."
	trait = TRAIT_CURSE_GRAGGAR

/datum/curse/matthios
	name = "Curse of Matthios"
	description = "I am forsaken by the Dragon. Greed will be my only salvation."
	trait = TRAIT_CURSE_MATTHIOS

/datum/curse/baotha
	name = "Curse of Baotha"
	description = "I am forsaken by the Heartbreaker. I am drowning in her promises."
	trait = TRAIT_CURSE_BAOTHA

//////////////////////
///	ON LIFE		///
//////////////////////

/datum/curse/astrata/on_life(mob/user)
	if(!user)
		return
	var/mob/living/carbon/human/H = user
	if(H.stat == DEAD)
		return
	if(H.advsetup)
		return

	if(world.time % 5)
		if(GLOB.tod != "night")
			if(isturf(H.loc))
				var/turf/T = H.loc
				if(T.can_see_sky())
					if(T.get_lumcount() > 0.15)
						H.fire_act(1,5)

/datum/curse/noc/on_life(mob/user)
	if(!user)
		return
	var/mob/living/carbon/human/H = user
	if(H.stat == DEAD)
		return
	if(H.advsetup)
		return

	if(world.time % 5)
		if(GLOB.tod != "day")
			if(isturf(H.loc))
				var/turf/T = H.loc
				if(T.can_see_sky())
					if(T.get_lumcount() > 0.15)
						H.fire_act(1,5)


//////////////////////
/// ON GAIN / LOSS ///
//////////////////////

//TENNITES//

//ASTRATA//
/datum/curse/astrata/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	if(curse_resist && prob(50))
		return
	ADD_TRAIT(owner, TRAIT_NOSLEEP, TRAIT_GENERIC)

/datum/curse/astrata/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOSLEEP, TRAIT_GENERIC)

//NECRA//
/datum/curse/necra/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STACON -= (10 * (1 - curse_resist))
	if(curse_resist && prob(50))
		return
	ADD_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

/datum/curse/necra/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STACON += (10 * (1 - curse_resist))
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

//XYLIX//
/datum/curse/xylix/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STALUC -= (20 * (1 - curse_resist))

/datum/curse/xylix/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STALUC += (20 * (1 - curse_resist))

//PESTRA//
/datum/curse/pestra/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STAWIL -= (10 * (1 - curse_resist))
	if(curse_resist && prob(50))
		return
	ADD_TRAIT(owner, TRAIT_NORUN, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_MISSING_NOSE, TRAIT_GENERIC)

/datum/curse/pestra/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STAWIL += (10 * (1 - curse_resist))
	REMOVE_TRAIT(owner, TRAIT_NORUN, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_MISSING_NOSE, TRAIT_GENERIC)

//EORA//
/datum/curse/eora/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	var/curse_chance = (100 * (1 - curse_resist))
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_UNSEEMLY, TRAIT_GENERIC)
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_GENERIC)

/datum/curse/eora/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_UNSEEMLY, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_GENERIC)

//ASCENDANTS//

//ZIZO//
/datum/curse/zizo/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STAINT -= (20 * (1 - curse_resist))
	ADD_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)

/datum/curse/zizo/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STAINT += (20 * (1 - curse_resist))
	REMOVE_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)

//GRAGGAR//
/datum/curse/graggar/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STASTR -= (14 * (1 - curse_resist))
	ADD_TRAIT(owner, TRAIT_DISFIGURED, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_INHUMEN_ANATOMY, TRAIT_GENERIC)

/datum/curse/graggar/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STASTR += (14 * (1 - curse_resist))
	REMOVE_TRAIT(owner, TRAIT_DISFIGURED, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_INHUMEN_ANATOMY, TRAIT_GENERIC)

//MATTHIOS//
/datum/curse/matthios/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STALUC -= (14 * (1 - curse_resist))
	ADD_TRAIT(owner, TRAIT_CLUMSY, TRAIT_GENERIC)

/datum/curse/matthios/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STALUC += (14 * (1 - curse_resist))
	REMOVE_TRAIT(owner, TRAIT_CLUMSY, TRAIT_GENERIC)

//BAOTHA//
/datum/curse/baotha/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	var/curse_chance = (100 * (1 - curse_resist))
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_NUDIST, TRAIT_GENERIC)
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_NUDE_SLEEPER, TRAIT_GENERIC)
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)

/datum/curse/baotha/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NUDIST, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_NUDE_SLEEPER, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)
