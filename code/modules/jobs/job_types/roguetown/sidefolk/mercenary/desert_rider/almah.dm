/datum/advclass/mercenary/desert_rider/almah
	name = "Desert Rider Almah"
	tutorial = "You're an Almah - a blade dancer, trained in the arts of spellbladery, an art originating from Azurea in ancient time. Your people have refined spellbladery into an artform. They call you a bladedancer - for the beautiful, bloody tapestry of magycks and blade you weave out of your foes in battle."
	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider_almah
	traits_applied = list(TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_SPD = 1, // Weighted 7. Swap str for spd
		STATKEY_INT = 1, // Weighted 7. But a very nice statblock
		STATKEY_PER = 1, 
		STATKEY_CON = 1,
		STATKEY_WIL = 2, // With 2 Wil they should not be struggling
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/desert_rider_almah
	var/subclass_selected

/datum/outfit/job/roguetown/mercenary/desert_rider_almah/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/mercenary/desert_rider_almah/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	// Gear - mirrors Zeybek
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/raneshen
	neck = /obj/item/clothing/neck/roguetown/gorget/copper
	mask = /obj/item/clothing/mask/rogue/facemask/copper
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	gloves = /obj/item/clothing/gloves/roguetown/angle
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	backr = /obj/item/storage/backpack/rogue/satchel/black

	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/clothing/neck/roguetown/shalal,
		/obj/item/flashlight/flare/torch,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/book/spellbook
		)

	// Spellblade chant selection - almah faction, blade choice is locked to shamshirs
	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "almah")
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
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
				H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
				H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/blade_storm)
			if("phalangite")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				H.mind.AddSpell(new /datum/action/cooldown/spell/shatter)
				H.mind.AddSpell(new /datum/action/cooldown/spell/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	switch(subclass_selected)
		if("blade")
			var/blade_weapons = list("Dual Shamshirs", "Shalal Saber & Shield")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in blade_weapons
			switch(weapon_choice)
				if("Dual Shamshirs")
					ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
					r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
					l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
					beltl = /obj/item/rogueweapon/scabbard/sword
					beltr = /obj/item/rogueweapon/scabbard/sword
				if("Shalal Saber & Shield")
					r_hand = /obj/item/rogueweapon/sword/long/marlin
					beltr = /obj/item/rogueweapon/scabbard/sword
					backl = /obj/item/rogueweapon/shield/tower/raneshen
		if("phalangite")
			var/polearm_weapons = list("Spear", "Dory & Shield")
			var/polearm_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in polearm_weapons
			switch(polearm_choice)
				if("Spear")
					r_hand = /obj/item/rogueweapon/spear
					backl = /obj/item/rogueweapon/scabbard/gwstrap
				if("Dory & Shield")
					r_hand = /obj/item/rogueweapon/spear/spellblade
					backl = /obj/item/rogueweapon/shield/tower/raneshen
		if("macebearer")
			var/mace_weapons = list("Steel Mace", "Steel Warhammer & Shield")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			switch(mace_choice)
				if("Steel Mace")
					r_hand = /obj/item/rogueweapon/mace/steel
				if("Steel Warhammer & Shield")
					r_hand = /obj/item/rogueweapon/mace/warhammer/steel
					backl = /obj/item/rogueweapon/shield/tower/raneshen

	H.merctype = 4
