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

/datum/antagonist/unbound_spellblade/proc/equip_spellblade()
	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)

	var/mob/living/carbon/human/H = owner.current
	H.cmode_music = 'sound/music/combat_cult.ogg'
	H.faction = list("undead")
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
	var/subclass_selected

/datum/outfit/job/roguetown/unbound_spellblade/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/unbound_spellblade/pre_equip(mob/living/carbon/human/H)
	..()

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

	// Chant selection — uses undead faction for "MEMORIES" UI
	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "undead")
	H << browse(selection_html, "window=spellblade_chant;size=1300x1000")
	onclose(H, "spellblade_chant", src)

	var/open_time = world.time
	while(!subclass_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellblade_chant")

	if(!subclass_selected)
		subclass_selected = "blade"

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = subclass_selected

	if(H.mind)
		switch(subclass_selected)
			if("blade")
				H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
				H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
				H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /datum/action/cooldown/spell/shatter)
				H.mind.AddSpell(new /datum/action/cooldown/spell/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
		H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4, "ward" = TRUE))

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

	switch(subclass_selected)
		if("blade")
			var/weapons = list("Khopesh", "Sabre", "Steel Dagger")
			var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Khopesh")
					beltr = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
				if("Sabre")
					beltr = /obj/item/rogueweapon/sword/sabre
				if("Steel Dagger")
					beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
			if(weapon_choice == "Steel Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("phalangite")
			var/weapons = list("Spear", "Bardiche")
			var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Spear")
					r_hand = /obj/item/rogueweapon/spear
				if("Bardiche")
					r_hand = /obj/item/rogueweapon/halberd/bardiche
					backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("macebearer")
			var/weapons = list("Steel Mace", "Steel Warhammer")
			var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Steel Mace")
					beltr = /obj/item/rogueweapon/mace/steel
				if("Steel Warhammer")
					beltr = /obj/item/rogueweapon/mace/warhammer/steel
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
	H.set_blindness(0)

	var/tabards = list("Black Tabard", "Black Jupon")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR HERALDRY.") as anything in tabards
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
