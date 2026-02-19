/datum/antagonist/unbound_death_knight
	name = "Unbound Death Knight"
	roundend_category = "Unbound Death Knight"
	antagpanel_category = "Unbound Death Knight"
	job_rank = ROLE_UNBOUND_DEATHKNIGHT
	confess_lines = list(
		"I WILL LIVE ETERNAL!",
		"YOU CANNOT KILL ME!",
		"I AM ALREADY DEAD YOU MORON!"
	)
	rogue_enabled = TRUE

/datum/antagonist/unbound_death_knight/on_gain()
	. = ..()
	skeletonize()
	equip_knight()
	forge_objectives()

/// Skeletonizes the owner, making it a skeleton. Separate proc in hopes that someone will remove duplicate skelecode from AP.
/datum/antagonist/unbound_death_knight/proc/skeletonize()
	if(isdwarf(owner.current)) // I am terribly sorry, fellow dwarfs. Remove this after death knight's armor works with dwarves.
		owner.current.set_species(/datum/species/human/northern)

	var/mob/living/carbon/human/L = owner.current
	for(var/datum/charflaw/cf in L.charflaws)
		L.charflaws.Remove(cf)
		QDEL_NULL(cf)
	L.hairstyle = "Bald"
	L.facial_hairstyle = "Shaved"
	L.mob_biotypes = MOB_UNDEAD
	var/obj/item/organ/eyes/eyes = L.getorganslot(ORGAN_SLOT_EYES)
	if (eyes)
		eyes.Remove(L, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(L)
	for(var/obj/item/bodypart/B in L.bodyparts)
		B.skeletonize(FALSE)
	L.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/simple/claw)
	L.update_a_intents()

	L.update_body()
	L.update_hair()
	L.update_body_parts(redraw = TRUE)

	ADD_TRAIT(L, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_NOSLEEP, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)

/datum/antagonist/unbound_death_knight/proc/equip_knight()
	owner.unknow_all_people()
	for (var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)

	var/mob/living/carbon/human/H = owner.current
	H.cmode_music = 'sound/music/combat_cult.ogg'
	H.faction = list("undead")
	H.equipOutfit(/datum/outfit/job/roguetown/unbound_deathknight)

/datum/antagonist/unbound_death_knight/greet()
	sleep(5 SECONDS) // Lets all other messages finish before we start.
	to_chat(owner, span_warning("You feel the power of unknown energy course through you."))
	sleep(1 SECONDS)
	to_chat(owner, span_warning("You are... Awake? But how?"))
	sleep(1 SECONDS)
	to_chat(owner, span_warning("The realization of what is happening slowly overwhelms you with horror..."))
	sleep(2 SECONDS)
	to_chat(owner, "<span class='pulsedeath'>Your master is gone!</span>")
	sleep(1 SECONDS)
	to_chat(owner, "<span class='pulsedeath'>You have no orders!</span>")
	sleep(1 SECONDS)
	to_chat(owner, "<span class='pulsedeath'>You have no goal!</span>")
	sleep(2 SECONDS)
	to_chat(owner, "<span class='pulsedeath'>You have no reason to be here. But you are awake.</span>")

/datum/antagonist/unbound_death_knight/proc/forge_objectives()
	var/list/hoomans = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != CONSCIOUS)
			continue

		if(H?.mind == owner)
			continue

		hoomans |= H

	INVOKE_ASYNC(src, PROC_REF(greet)) // Solvful text while we wait 30 seconds for poll to finish
	// Firstly, we will try finding targets for protect/kill.
	var/list/targets = pollCandidates(
		"Would you like to be a target for a death knight?", 
		ignore_category = POLL_IGNORE_DEATHKNIGHT_TARGET, 
		group = hoomans
	)
	if(!length(targets))
		return

	var/mob/living/carbon/human/poor_sod
	for(var/i = 0 to 3)
		var/mob/living/carbon/human/candidate = pick_n_take(targets)
		if(!candidate?.mind)
			continue

		poor_sod = candidate
		break

	if(poor_sod) // Prioritizing player to player interactions at all costs
		var/datum/objective/lordscommandment
		if(rand(50))
			lordscommandment = new /datum/objective/protect 
		else
			lordscommandment = new /datum/objective/assassinate

		lordscommandment.target = poor_sod.mind
		lordscommandment.owner = owner
		lordscommandment.update_explanation_text()
		objectives += lordscommandment
	else // "Freeform" objective is assigned if no players opt in
		var/datum/objective/free = new /datum/objective
		free.name = "Protect area"
		if(prob(50))
			free.explanation_text = "Keep the living out of the Northern Hamlet."
		else
			free.explanation_text = "Defend the Northern Hamlet against trespassers."
		objectives += free

	to_chat(owner, "<span class='pulsedeath'>Suddenly, you remember your master's last commandment...</span>")
	owner.announce_objectives()

/datum/outfit/job/roguetown/unbound_deathknight/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.mind.adjust_spellpoints(9)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonechill)

	beltl = /obj/item/rogueweapon/scabbard/sword
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/platelegs/blk/death
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blkknight
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	armor = /obj/item/clothing/suit/roguetown/armor/plate/blkknight/death
	gloves = /obj/item/clothing/gloves/roguetown/plate/blk/death
	backr = /obj/item/storage/backpack/rogue/satchel/black

	H.change_stat(STATKEY_INT, 3)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_SPD, -3)

	H.ambushable = FALSE

	H.adjust_blindness(-3)

	var/helmets = list(
		"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/black,
		"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard/black,
		"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/black,
		"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/black,
		"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/black,
		"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/black,
		"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/black,
		"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/black,
		"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/black,
		"Slitted Kettle"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle/black,
	)
	var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]

	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in list("Longsword", "Warhammer", "Halberd")
	switch(weapon_choice)
		if("Longsword")
			beltl = /obj/item/rogueweapon/scabbard/sword
			l_hand = /obj/item/rogueweapon/sword/long/death
			backl = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if ("Warhammer")
			beltr = /obj/item/rogueweapon/mace/warhammer/steel
			backl = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
		if("Halberd")
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			r_hand = /obj/item/rogueweapon/halberd
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1
	)
	H.set_blindness(0)

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/helmet/heavy/guard/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/helmet/heavy/sheriff/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/helmet/heavy/knight/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/helmet/sallet/visored/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/armor/plate/blkknight/death
	color = CLOTHING_BLACK

/obj/item/clothing/shoes/roguetown/boots/armor/blkknight/death
	color = CLOTHING_BLACK

/obj/item/clothing/gloves/roguetown/plate/blk/death
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/platelegs/blk/death
	color = CLOTHING_BLACK
