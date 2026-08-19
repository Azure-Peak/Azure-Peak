/datum/advclass/wretch/profane_champion
	name = "Profane Champion"
	tutorial = "You are a champion of the Ecclesial, bearing boons of your Patron into battle. By quill or sword their word shall be heard."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/wretch/profane_champion
	class_select_category = CLASS_CAT_CLERIC
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_HEAVYARMOR)
	maximum_possible_slots = 4 //Same as templar
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 4
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list("Armor Plates"=/obj/item/repair_kit/metal)

	tempo_capable = TRUE

/datum/outfit/job/roguetown/wretch/profane_champion
	has_loadout = TRUE

/datum/outfit/job/roguetown/wretch/profane_champion/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	if(!(istype(H.patron, /datum/patron/inhumen)))
		to_chat(H, span_warning("I reject the false prophets, Matthios embraces my fyre as His own."))
		H.set_patron(/datum/patron/inhumen/matthios)//If you are not an ascendant get put up as Matthiosite
	if(H.mind)
		var/weapons = list("Arming Sword", "Battle Axe", "Warhammer", "Flail")
		switch(H.patron?.type)
			if(/datum/patron/inhumen/zizo)
				weapons += "Avantyne Longsword"
			if(/datum/patron/inhumen/matthios)
				weapons += "Gilded Flail"
			if(/datum/patron/inhumen/graggar)
				weapons += "Vicious Axe"
			if(/datum/patron/inhumen/baotha)
				weapons += "Saccharine Swordspear"
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Arming Sword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword
				l_hand = /obj/item/rogueweapon/shield/tower/metal
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Battle Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/shield/tower/metal
				beltr = /obj/item/rogueweapon/stoneaxe/battle
			if("Warhammer")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/shield/tower/metal
				beltr = /obj/item/rogueweapon/mace/warhammer/steel
			if("Flail")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/shield/tower/metal
				beltr = /obj/item/rogueweapon/flail/sflail
			if("Avantyne Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/sword/long/zizo(H))
			if("Gilded Flail")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/flail/peasantwarflail/matthios(H))
			if("Vicious Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/greataxe/steel/doublehead/graggar(H))
			if("Saccharine Swordspear")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/spear/partizan/baotha(H))
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_2)
		wretch_select_bounty(H)

	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/minion_order)
			add_verb(H, /mob/living/carbon/human/proc/revelations)
			H.mind.AddSpell(new /datum/action/cooldown/spell/gravemark)
			H.mind?.current.faction += "[H.name]_faction"
		ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	cloak = /obj/item/clothing/cloak/cape/crusader
	neck = /obj/item/clothing/neck/roguetown/gorget
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)

/datum/outfit/job/roguetown/wretch/profane_champion/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/iron, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/book/rogue/bibble/zizo,SLOT_IN_BACKPACK, TRUE)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios, SLOT_RING, TRUE)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha, SLOT_RING, TRUE)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar, SLOT_RING, TRUE)

	if(H.mind)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold, SLOT_HEAD)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk, SLOT_SHIRT, TRUE)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/plate, SLOT_GLOVES, TRUE)
		H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers, SLOT_WRISTS, TRUE)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/platelegs, SLOT_PANTS, TRUE)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/armor, SLOT_SHOES, TRUE)
