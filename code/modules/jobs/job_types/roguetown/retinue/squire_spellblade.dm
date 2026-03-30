/datum/advclass/squire/azurtaeron
	name = "Azurtaeron Initiate"
	tutorial = "You are an Azurtaeron Initiate - a squire who has shown an aptitude for the ancient \
	Azurian art of spellbladery. Where other squires train with steel alone, \
	you have begun to learn the ancient techniques of using cold steel and sorcery both. \
	You are not well-trained enough to use armor alongside your arts, yet. But with time, effort and \
	perhaps the right mentor, you will one dae take up the mantle of an Azurtaeron - heavily armored Spellknight \
	of Azurean legends."
	outfit = /datum/outfit/job/roguetown/squire/azurtaeron
	category_tags = list(CTAG_SQUIRE)
	traits_applied = list(TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/squire/azurtaeron
	var/subclass_selected

/datum/outfit/job/roguetown/squire/azurtaeron/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/squire/azurtaeron/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/book/spellbook = 1,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/repair_kit/metal,
		/obj/item/repair_kit,
	)

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

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

	// Weapon choices — trainee tier (journeyman skills, weaker weapons)
	switch(subclass_selected)
		if("blade")
			var/weapons = list("Longsword", "Rapier", "Sabre", "Arming Sword", "Shortsword", "Hwando", "Steel Dagger")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			beltr = /obj/item/rogueweapon/scabbard/sword
			switch(weapon_choice)
				if("Longsword")
					r_hand = /obj/item/rogueweapon/sword/long
				if("Rapier")
					r_hand = /obj/item/rogueweapon/sword/rapier
				if("Sabre")
					r_hand = /obj/item/rogueweapon/sword/sabre
				if("Arming Sword")
					r_hand = /obj/item/rogueweapon/sword
				if("Shortsword")
					r_hand = /obj/item/rogueweapon/sword/short
				if("Hwando")
					r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog
					armor = /obj/item/clothing/suit/roguetown/armor/basiceast
				if("Steel Dagger")
					r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
			if(weapon_choice == "Steel Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("phalangite")
			var/spear_weapons = list("Spear", "Dory", "Naginata")
			var/spear_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in spear_weapons
			switch(spear_choice)
				if("Spear")
					r_hand = /obj/item/rogueweapon/spear
				if("Dory")
					r_hand = /obj/item/rogueweapon/spear/spellblade
				if("Naginata")
					r_hand = /obj/item/rogueweapon/spear/naginata
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					armor = /obj/item/clothing/suit/roguetown/armor/basiceast
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("macebearer")
			var/mace_weapons = list("Mace", "Warhammer")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			switch(mace_choice)
				if("Mace")
					r_hand = /obj/item/rogueweapon/mace
				if("Warhammer")
					r_hand = /obj/item/rogueweapon/mace/warhammer
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_WORKING_CLASS, H, "Savings.")
