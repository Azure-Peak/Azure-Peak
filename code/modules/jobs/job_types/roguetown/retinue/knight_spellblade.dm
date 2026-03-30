/datum/advclass/knight/azurtaeron
	name = "Knight Azurtaeron"
	tutorial = "After the founding of Azuria, the knights of this land held fast to the traditional idea of chivalry. \
	Steel, Strength and Swords. With no room for magick - Spellbladery being relegated to commoners or auxillary role. \
	It took less than half a generation before the knights changed their mind - Spellbladery was an Azurean art, and \
	it was both practical and demanding. What better way for a Knight to express their skills and nobility than to master it, \
	cutting their foes with speed never thought possible in such armor. You have mastered the noble art of Spellbladery \
	in heavy armor. What you lack in divine power, you make up for in strength and magycks. Azurea's traditions live on \
	through your blade."
	outfit = /datum/outfit/job/roguetown/knight/azurtaeron
	category_tags = list(CTAG_ROYALGUARD)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/knight/azurtaeron
	var/subclass_selected

/datum/outfit/job/roguetown/knight/azurtaeron/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/knight/azurtaeron/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	// No town bonus - strip TRAIT_GUARDSMAN
	if(HAS_TRAIT(H, TRAIT_GUARDSMAN))
		REMOVE_TRAIT(H, TRAIT_GUARDSMAN, JOB_TRAIT)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backl = /obj/item/rogueweapon/shield/heater
	backpack_contents = list(
		/obj/item/book/spellbook = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
	)

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	// Armor choice
	H.adjust_blindness(-3)
	if(H.mind)
		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/heavy,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]

		var/helmets = list(
			"Pigface Bascinet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"			= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Bucket Helmet"			= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight's Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Armet"					= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Visored Sallet"		= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Klappvisier Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Hounskull Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		H.set_blindness(0)
		if(helmchoice != "None")
			head = helmets[helmchoice]

	// Spellblade chant selection
	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "conventional")
	H << browse(selection_html, "window=spellblade_chant;size=1100x900")
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

	// Weapon selection - done in pre_equip since knight outfits don't use choose_loadout
	switch(subclass_selected)
		if("blade")
			var/list/weapons = list("Steel Broadsword", "Estoc", "Rapier", "Sabre", "Steel Arming Sword", "Steel Greatsword", "Steel Dagger")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Steel Broadsword")
					r_hand = /obj/item/rogueweapon/sword/long/broadsword/steel
					beltr = /obj/item/rogueweapon/scabbard/sword
				if("Estoc")
					r_hand = /obj/item/rogueweapon/estoc
					backl = /obj/item/rogueweapon/scabbard/gwstrap
				if("Rapier")
					r_hand = /obj/item/rogueweapon/sword/rapier
					beltr = /obj/item/rogueweapon/scabbard/sword
				if("Sabre")
					r_hand = /obj/item/rogueweapon/sword/sabre
					beltr = /obj/item/rogueweapon/scabbard/sword
				if("Steel Arming Sword")
					r_hand = /obj/item/rogueweapon/sword
					beltr = /obj/item/rogueweapon/scabbard/sword
				if("Steel Greatsword")
					r_hand = /obj/item/rogueweapon/greatsword
					backl = /obj/item/rogueweapon/scabbard/gwstrap
				if("Steel Dagger")
					beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
			if(weapon_choice == "Steel Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("phalangite")
			var/polearm_weapons = list("Halberd", "Bardiche", "Lucerne", "Partizan", "Dory", "Naginata")
			var/polearm_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in polearm_weapons
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			switch(polearm_choice)
				if("Halberd")
					r_hand = /obj/item/rogueweapon/halberd
				if("Bardiche")
					r_hand = /obj/item/rogueweapon/halberd/bardiche
				if("Lucerne")
					r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				if("Partizan")
					r_hand = /obj/item/rogueweapon/spear/partizan
				if("Dory")
					r_hand = /obj/item/rogueweapon/spear/spellblade
					backl = /obj/item/rogueweapon/shield/heater
				if("Naginata")
					r_hand = /obj/item/rogueweapon/spear/naginata
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("macebearer")
			var/mace_weapons = list("Steel Mace", "Steel Warhammer", "Great Mace")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			switch(mace_choice)
				if("Steel Mace")
					r_hand = /obj/item/rogueweapon/mace/steel
				if("Steel Warhammer")
					r_hand = /obj/item/rogueweapon/mace/warhammer/steel
				if("Great Mace")
					r_hand = /obj/item/rogueweapon/mace/goden/steel
					backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_CLASS, H, "Savings.")
