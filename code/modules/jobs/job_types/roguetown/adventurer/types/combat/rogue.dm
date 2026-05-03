/datum/advclass/rogue
	name = "Treasure Hunter"
	tutorial = "You are a treasure hunter trained in hunting for valuables. Discern what is treasure or not, your fortune could be hidden anywhere."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/rogue
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_SEEPRICES, TRAIT_GRAVEROBBER)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	class_select_category = CLASS_CAT_ROGUE
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/rogue/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a treasure hunter trained in hunting for valuables. Discern what is treasure or not, your fortune could be hidden anywhere."))
	pants = /obj/item/clothing/under/roguetown/trou/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	backr = /obj/item/rogueweapon/shovel
	head = /obj/item/clothing/head/roguetown/fedora
	beltl = /obj/item/flashlight/flare/torch/lantern
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(
		/obj/item/lockpick = 1, 
		/obj/item/rogueweapon/huntingknife = 1, 
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		var/weapons = list("Sabre","Whip")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Sabre")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword/sabre
				r_hand = /obj/item/rogueweapon/scabbard/sword
			if("Whip")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/whip

/datum/advclass/rogue/thief
	name = "Thief"
	tutorial = "You are a scoundrel and a thief. A master in getting into places you shouldn't be and taking things that aren't rightfully yours."
	outfit = /datum/outfit/job/roguetown/adventurer/thief
	subclass_languages = list(/datum/language/thievescant)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/thief/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a scoundrel and a thief. A master in getting into places you shouldn't be and taking things that aren't rightfully yours."))
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	beltl = /obj/item/quiver/Warrows
	beltr = /obj/item/rogueweapon/mace/cudgel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

/datum/advclass/rogue/bard
	name = "Bard"
	tutorial = "You make your fortune in brothels, flop houses, and taverns – gaining fame for your songs and legends. If there is any truth to them, that is."
	outfit = /datum/outfit/job/roguetown/adventurer/bard
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_GOODLOVER, TRAIT_EMPATH)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/bard/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You make your fortune in brothels, flop houses, and taverns – gaining fame for your songs and legends. If there is any truth to them, that is."))
	head = /obj/item/clothing/head/roguetown/bardhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	backl = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/half/red
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)
		var/weapons = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute")
		var/weapon_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Flute")
				backr = /obj/item/rogue/instrument/flute

/datum/advclass/rogue/swashbuckler
	name = "Swashbuckler"
	tutorial = "You are a daring rogue of the seas! Swashbucklers wield agile swordplay and acrobatic prowess - fighting dirty to outmaneuver foes with flair."
	outfit = /datum/outfit/job/roguetown/adventurer/swashbuckler
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_NUTCRACKER, TRAIT_DECEIVING_MEEKNESS)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/swashbuckler/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a daring rogue of the seas! Swashbucklers wield agile swordplay and acrobatic prowess - fighting dirty to outmaneuver foes with flair."))
	head = /obj/item/clothing/head/roguetown/helmet/tricorn
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogue/instrument/hurdygurdy
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/sword/cutlass
	backpack_contents = list(
		/obj/item/bomb = 1,
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
