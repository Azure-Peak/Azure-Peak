/datum/antagonist/zizo_knight
	name = "Dark Itinerant Knight"
	roundend_category = "Dark Itinerant Knight"
	antagpanel_category = "Dark Itinerant Knight"
	job_rank = ROLE_DARK_ITINERANT
	confess_lines = list(
		"ZIZO! ZIZO! ZIZO!",
		"FOR THE PALE LADY!",
	)
	rogue_enabled = TRUE
	var/outfit_path = /datum/outfit/job/dark_itinerant_knight

/datum/antagonist/zizo_knight/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return

	H.set_patron(/datum/patron/inhumen/zizo)
	H.cmode_music = 'sound/music/combat_heretic.ogg'
	H.faction = list(FACTION_UNDEAD)
	to_chat(owner, span_danger("I'm a servant to the ALMIGHTY. They call it the UNSPEAKABLE. I SHALL WRECK HAVOK and SURVIVE."))
	H.equipOutfit(outfit_path)

/datum/antagonist/zizo_knight/squire
	name = "Dark Itinerant Squire"
	roundend_category = "Dark Itinerant Squire"
	antagpanel_category = "Dark Itinerant Squire"
	outfit_path = /datum/outfit/job/dark_itinerant_squire

/datum/outfit/job/dark_itinerant_squire/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	backr = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	r_hand = /obj/item/rogueweapon/spear
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/hammer/iron = 1, 
		/obj/item/rogueweapon/tongs = 1, 
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1, 
		/obj/item/repair_kit/metal = 1,
		/obj/item/repair_kit = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	)

	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE)

	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_SPD, 1) // 9 weighted
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mindlink)

	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in list("Crossbow", "Bow", "Sling")
	var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in list("Light Armor", "Medium Armor")
	H.set_blindness(0)
	switch(weapon_choice)
		if("Crossbow")
			beltr = /obj/item/quiver/bolt/standard
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
		if("Bow")
			beltr = /obj/item/quiver/bodkin
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
		if("Sling")
			beltr = /obj/item/quiver/sling/iron
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling

	switch(armor_choice)
		if("Light Armor")
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
			armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Medium Armor")
			pants = /obj/item/clothing/under/roguetown/chainlegs
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.cmode_music = 'sound/music/combat_heretic.ogg'
	ADD_TRAIT(H, TRAIT_SQUIRE_REPAIR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	wretch_select_bounty(H)

/datum/outfit/job/dark_itinerant_knight/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern
	neck = /obj/item/clothing/neck/roguetown/bevor
	gloves = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	l_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/ritechalk = 1,
	)

	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)

	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_INT, 3)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_WIL, 2) 
	H.change_stat(STATKEY_SPD, -1) // 11 weighted
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mindlink)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/zizosquire)
		//See modules/spells/spell_types/skills/invoked_qoe/recruitment for convertrole + objectives

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/combat_heretic.ogg'
	wretch_select_bounty(H)

