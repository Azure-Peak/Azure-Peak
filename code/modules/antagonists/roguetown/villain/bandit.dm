/datum/antagonist/bandit
	name = "Bandit"
	roundend_category = "bandits"
	antagpanel_category = "Bandit"
	job_rank = ROLE_BANDIT
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "bandit"
	confess_lines = list(
		"FREEDOM!!!",
		"I WILL NOT LIVE IN YOUR WALLS!",
		"I WILL NOT FOLLOW YOUR RULES!",
	)
	rogue_enabled = TRUE
	var/favor = 150
	var/totaldonated = 0

/datum/antagonist/bandit/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/bandit))
		return span_boldnotice("Another free man. My ally.")

/datum/antagonist/bandit/on_gain()
	owner.special_role = "Bandit"
	//owner.assigned_role = "Bandit"
	forge_objectives()
	. = ..()
	equip_bandit()
	finalize_bandit()

/datum/antagonist/bandit/proc/finalize_bandit()
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/traitor.ogg', 60, FALSE, pressure_affected = FALSE)
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H.patron, /datum/patron/inhumen))
		H.set_patron(/datum/patron/inhumen/matthios)	//If you aren't a heretical worshiper, forces you to Matthios worship. (All bandits follow Matthios.)
	H.verbs |= /mob/proc/haltyell_exhausting
	ADD_TRAIT(H, TRAIT_BANDITCAMP, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_COMMIE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_OUTLAW, TRAIT_GENERIC)		//Just to stop them from using mesiters like Wretches.
	to_chat(H, span_alertsyndie("I am a BANDIT!"))
	to_chat(H, span_boldwarning("Long ago I did a crime worthy of my bounty being hung on the wall outside of the local inn. I live now with fellow free men in reverence to MATTHIOS whose idol grants us boons and wishes when fed the money, treasures, and metals of the civilized wretches. As a member of the free men, I worship MATTHIOS first and foremost, though I may have allegiance to other deities."))

/datum/antagonist/bandit/proc/forge_objectives()
	return

/datum/antagonist/bandit/proc/move_to_spawnpoint()
	owner.current.forceMove(pick(GLOB.bandit_starts))

/datum/antagonist/bandit/proc/equip_bandit()

	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)
	for(var/datum/mind/MF in get_minds("Bandit"))
		owner.i_know_person(MF)
		owner.person_knows_me(MF)

	return TRUE

/datum/antagonist/bandit/roundend_report()
	if(owner?.current)
		var/the_name = owner.name
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			the_name = H.real_name
		if(!totaldonated)
			to_chat(world, "[the_name] was a bandit.")
		else
			to_chat(world, "[the_name] was a bandit. Their band stole [totaldonated] mammons worth of loot!")
