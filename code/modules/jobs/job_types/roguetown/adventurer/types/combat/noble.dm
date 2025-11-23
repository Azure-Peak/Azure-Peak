/datum/advclass/noble
	name = "Aristocrat"
	tutorial = "You are a traveling noble visiting foreign lands. With wealth, come the poor, ready to pilfer you of your hard earned (inherited) coin, so tread lightly unless you want to meet a grizzly end."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/adventurer/noble
	traits_applied = list(TRAIT_NOBLE)
	class_select_category = CLASS_CAT_NOBLE
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)

	cmode_music = 'sound/music/combat_knight.ogg'
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/noble/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a traveling noble visiting foreign lands. With wealth, come the poor, ready to pilfer you of your hard earned (inherited) coin, so tread lightly unless you want to meet a grizzly end."))
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	id = /obj/item/clothing/ring/silver
	beltl = /obj/item/rogueweapon/sword/sabre/dec
	l_hand = /obj/item/rogueweapon/scabbard/sword
	if(should_wear_masc_clothes(H))
		cloak = /obj/item/clothing/cloak/half/red
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
		pants = /obj/item/clothing/under/roguetown/tights/black
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
		cloak = /obj/item/clothing/cloak/raincloak/purple
	backpack_contents = list(/obj/item/recipe_book/survival = 1) // Someone gonna argue it is sovlful to not have this but whatever
	var/turf/TU = get_turf(H)
	if(TU)
		new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
	H.set_blindness(0)

/datum/advclass/noble/knighte
	name = "Knight Errant"
	tutorial = "You are a knight from a distant land, a scion of a noble house visiting Azuria for one reason or another."
	outfit = /datum/outfit/job/roguetown/adventurer/knighte
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/knighte/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		to_chat(H, span_warning("You are a knight from a distant land, a scion of a noble house visiting Azuria for one reason or another."))
		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"None"
			)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]

	gloves = /obj/item/clothing/gloves/roguetown/chain
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/stabard
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/recipe_book/survival = 1,
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/turf/TU = get_turf(H)
	if(TU)
		new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Longsword","Mace + Shield","Flail + Shield","Billhook","Battle Axe","Greataxe")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword/long
				r_hand = /obj/item/rogueweapon/scabbard/sword
			if("Mace + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/mace
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("Flail + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/flail
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("Billhook")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/billhook
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Battle Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
			if("Greataxe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe
				backr = /obj/item/rogueweapon/scabbard/gwstrap

/datum/advclass/noble/squire
	name = "Squire Errant"
	tutorial = "You are a squire who has traveled far in search of a master to train you and a lord to knight you."
	outfit = /datum/outfit/job/roguetown/adventurer/squire
	traits_applied = list(TRAIT_SQUIRE_REPAIR)
	subclass_stats = list()
	subclass_skills = list()
	extra_context = "Chooses between Footman, Lancer, Irregular for its stats, skills, and equipment."

/datum/outfit/job/roguetown/adventurer/squire/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a squire who has traveled far in search of a master to train you and a lord to knight you."))
	head = /obj/item/clothing/head/roguetown/roguehood
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	cloak = /obj/item/clothing/cloak/stabard
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/tongs = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/repair_kit/metal = 1,
		/obj/item/repair_kit = 1,
	)
	if(H.mind)
		var/static/list/variants = list("Footman Squire", "Lancer Squire", "Irregular Squire")
		var/chosen_variant = tgui_input_list(H, "Choose your squirely training.", "SQUIRE TRAINING", variants)
		if(!chosen_variant)
			chosen_variant = "Footman Squire"
		switch(chosen_variant)
			if("Footman Squire")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				pants = /obj/item/clothing/under/roguetown/chainlegs/iron
				gloves = /obj/item/clothing/gloves/roguetown/chain/iron
				beltr = /obj/item/rogueweapon/sword/iron
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

				var/static/list/footman_stats = list(
					STATKEY_STR = 1,
					STATKEY_SPD = 1,
					STATKEY_PER = 1,
					STATKEY_CON = 1,
					STATKEY_INT = 1,
				)
				var/static/list/footman_skills = list(
					/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
					/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
					/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
					/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
					/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
					/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
					/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
					/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
					/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
					/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
				)

				for(var/statkey in footman_stats)
					H.change_stat(statkey, footman_stats[statkey])

				for(var/skill in footman_skills)
					H.adjust_skillrank(skill, footman_skills[skill], TRUE)
			if("Lancer Squire")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				pants = /obj/item/clothing/under/roguetown/chainlegs/iron
				gloves = /obj/item/clothing/gloves/roguetown/chain/iron
				backl = /obj/item/rogueweapon/scabbard/gwstrap/sheathed_spear
				beltr = /obj/item/rogueweapon/huntingknife/idagger
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

				var/static/list/lancer_stats = list(
					STATKEY_STR = 1,
					STATKEY_SPD = 1,
					STATKEY_PER = 1,
					STATKEY_CON = 1,
					STATKEY_INT = 1,
				)
				var/static/list/lancer_skills = list(
					/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
					/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
					/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
					/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
					/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
					/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
					/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
					/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
					/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
					/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
					/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
					/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
				)

				for(var/statkey in lancer_stats)
					H.change_stat(statkey, lancer_stats[statkey])

				for(var/skill in lancer_skills)
					H.adjust_skillrank(skill, lancer_skills[skill], TRUE)
			if("Irregular Squire")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				pants = /obj/item/clothing/under/roguetown/trou/leather
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltr = /obj/item/rogueweapon/huntingknife/idagger
				beltl = /obj/item/quiver/arrows
				backpack_contents += list(/obj/item/flashlight/flare/torch/lantern = 1)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

				var/static/list/irregular_stats = list(
					STATKEY_SPD = 2,
					STATKEY_PER = 1,
					STATKEY_CON = 1,
					STATKEY_INT = 1,
				)
				var/static/list/irregular_skills = list(
					/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
					/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
					/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
					/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
					/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
					/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
					/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
					/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
					/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
					/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
					/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
				)

				for(var/statkey in irregular_stats)
					H.change_stat(statkey, irregular_stats[statkey])

				for(var/skill in irregular_skills)
					H.adjust_skillrank(skill, irregular_skills[skill], TRUE)
	H.set_blindness(0)
