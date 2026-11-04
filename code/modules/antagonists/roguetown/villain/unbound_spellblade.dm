/datum/antagonist/unbound_spellblade
	name = "Unbound Spellblade"
	roundend_category = "Unbound Spellblade"
	antagpanel_category = "Unbound Spellblade"
	job_rank = ROLE_UNBOUND_DEATHKNIGHT // Shares preference with Death Knight
	confess_lines = list(
		"MY BLADE REMEMBERS!",
		"THE ARCYNE FLOWS ETERNAL!",
		"THE ROAD TO MASTERY NEVER ENDS!",
		"I AM ALREADY DEAD YOU MORON!"
	)
	rogue_enabled = TRUE

/datum/antagonist/unbound_spellblade/on_gain()
	. = ..()
	skeletonize()
	equip_spellblade()
	forge_objectives()

/datum/antagonist/unbound_spellblade/proc/skeletonize()
	var/mob/living/carbon/human/L = owner.current
	L.become_skeleton()
	ADD_TRAIT(L, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_ARCYNE, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_SHATTER_KILL, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_SKELETAL_GIB_ON_DEATH, TRAIT_GENERIC)

/datum/antagonist/unbound_spellblade/proc/equip_spellblade()
	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)

	var/mob/living/carbon/human/H = owner.current
	H.cmode_music = 'sound/music/combat_cult.ogg'
	H.faction = list(FACTION_UNDEAD)
	H.equipOutfit(/datum/outfit/job/roguetown/unbound_spellblade)

/datum/antagonist/unbound_spellblade/greet()
	sleep(5 SECONDS)
	to_chat(owner, span_warning("Arcyne energy surges through your hollow bones."))
	sleep(1 SECONDS)
	to_chat(owner, span_warning("You are... Awake? But how?"))
	sleep(1 SECONDS)
	to_chat(owner, span_warning("Memories of steel and sorcery flood back — the Chant, the Blade, the Momentum..."))
	sleep(2 SECONDS)
	to_chat(owner, "<span class='pulsedeath'>Your master is gone!</span>")
	sleep(1 SECONDS)
	to_chat(owner, "<span class='pulsedeath'>The bond is severed!</span>")
	sleep(1 SECONDS)
	to_chat(owner, "<span class='pulsedeath'>But the arcyne still flows.</span>")
	sleep(2 SECONDS)
	to_chat(owner, "<span class='pulsedeath'>You remember your craft. You remember your Chant. That is enough.</span>")

/datum/antagonist/unbound_spellblade/proc/forge_objectives()
	var/list/hoomans = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != CONSCIOUS)
			continue

		if(H?.mind == owner)
			continue

		hoomans |= H

	INVOKE_ASYNC(src, PROC_REF(greet))
	var/list/targets = pollCandidates(
		"Would you like to be a target for an unbound spellblade?",
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

	if(poor_sod)
		var/datum/objective/lordscommandment
		if(rand(50))
			lordscommandment = new /datum/objective/protect
		else
			lordscommandment = new /datum/objective/assassinate

		lordscommandment.target = poor_sod.mind
		lordscommandment.owner = owner
		lordscommandment.update_explanation_text()
		objectives += lordscommandment
	else
		var/datum/objective/free = new /datum/objective
		free.name = "Protect area"
		if(prob(50))
			free.explanation_text = "Keep the living out of the Northern Hamlet."
		else
			free.explanation_text = "Defend the Northern Hamlet against trespassers."
		objectives += free

	to_chat(owner, "<span class='pulsedeath'>Suddenly, a final memory surfaces — your master's last commandment...</span>")
	owner.announce_objectives()

/datum/outfit/job/roguetown/unbound_spellblade

/datum/outfit/job/roguetown/unbound_spellblade/pre_equip(mob/living/carbon/human/H)
	..()

	change_origin(H, /datum/virtue/origin/unselectable/skeleton, "Legion")

	H.change_stat(STATKEY_STR, -2)
	H.change_stat(STATKEY_SPD, -3)
	H.change_stat(STATKEY_CON, -5)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_INT, 4)
	H.change_stat(STATKEY_PER, 1)

	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)

	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/black
	pants = /obj/item/clothing/under/roguetown/chainlegs/black
	neck = /obj/item/clothing/neck/roguetown/chaincoif/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine/black
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	backr = /obj/item/rogueweapon/shield/heater
	backl = /obj/item/storage/backpack/rogue/satchel

	H.ambushable = FALSE
	//we allow swift intent, solo full antag undead
	// Chant selection — uses undead faction for "MEMORIES" UI
	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	var/spellblade_chant_selected = prompt_spellblade_choice(H, get_spellblade_chant_html(src, H, "undead"))
	var/datum/spellblade_chant/chant = GLOB.spellblade_chants[spellblade_chant_selected]
	chant.apply_chant(H)

	if(H.mind)
		H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 5))

	H.adjust_blindness(-3)
	var/helmets = list(
		"Pigface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/black,
		"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard/black,
		"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/black,
		"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/black,
		"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/black,
		"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/black,
		"Hounskull Bascinet"= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/black,
		"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/black,
		"Slitted Kettle"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle/black,
		"None",
	)
	var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]

	// used to handle skill assignment automatically
	var/obj/item/rogueweapon/granted_weapon = null
	switch(spellblade_chant_selected)
		if("blade")
			var/weapons = list("Khopesh", "Sabre", "Steel Dagger")
			var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Khopesh")
					beltr = granted_weapon = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
				if("Sabre")
					beltr = granted_weapon = /obj/item/rogueweapon/sword/sabre
				if("Steel Dagger")
					beltr = granted_weapon = /obj/item/rogueweapon/huntingknife/idagger/steel
		if("phalangite")
			var/weapons = list("Spear", "Bardiche")
			var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Spear")
					r_hand = granted_weapon = /obj/item/rogueweapon/spear
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Bardiche")
					r_hand = granted_weapon = /obj/item/rogueweapon/halberd/bardiche
					backr = /obj/item/rogueweapon/scabbard/gwstrap
		if("macebearer")
			var/weapons = list("Steel Mace", "Steel Warhammer", "Grand Mace", "Battle Axe", "Steel Greataxe")
			var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Steel Mace")
					beltr = granted_weapon = /obj/item/rogueweapon/mace/steel
				if("Steel Warhammer")
					beltr = granted_weapon = /obj/item/rogueweapon/mace/warhammer/steel
				if("Grand Mace")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/goden/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Battle Axe")
					beltr = granted_weapon = /obj/item/rogueweapon/stoneaxe/battle
				if("Steel Greataxe")
					r_hand = granted_weapon = /obj/item/rogueweapon/greataxe/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
	if(granted_weapon)
		H.adjust_skillrank_up_to(granted_weapon::associated_skill, SKILL_LEVEL_EXPERT, TRUE)

	H.set_blindness(0)

	var/tabards = list("Black Tabard", "Black Jupon")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich

	// Reorder undead eyes action to the end
	var/obj/item/organ/eyes/existing_eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(existing_eyes)
		existing_eyes.Remove(H, TRUE)
		existing_eyes.Insert(H)

	H.energy = H.max_energy
	H.select_skeleton_features()

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/black
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/chainlegs/black
	color = CLOTHING_BLACK

/obj/item/clothing/neck/roguetown/chaincoif/black
	color = CLOTHING_BLACK

/obj/item/clothing/gloves/roguetown/chain/black
	color = CLOTHING_BLACK

/obj/item/clothing/wrists/roguetown/bracers/brigandine/black
	color = CLOTHING_BLACK
