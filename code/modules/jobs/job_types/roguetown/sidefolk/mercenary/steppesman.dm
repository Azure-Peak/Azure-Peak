/datum/advclass/mercenary/steppesman
	name = "Steppesman"
	tutorial = "Once serving a Hetmen from the frontiers, you have been rented out as a mercenary in the distant realm of Azuria to bring coin home. There are three things you value most; saigas, freedom, and money."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/steppesman
	class_select_category = CLASS_CAT_AAVNR
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_steppe.ogg'
	subclass_languages = list(/datum/language/aavnic)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled
	extra_context = "This subclass has 4 loadouts with various stats, skills & equipment."
	subclass_skills = list(
	//Universal skills
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/mercenary/steppesman/pre_equip(mob/living/carbon/human/H)
	..()

	//Universal gear
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/whip/nagaika,
		/obj/item/rogueweapon/scabbard/sheath
		)

	// CLASS ARCHETYPES
	H.adjust_blindness(-3)
	if(H.mind)
		var/classes = list("Szabrista - Saber Veteran", "Árkász - Elite Sapper", "Druzhina - Light Archer","Kozak - Light Infantry")
		var/classchoice = input(H, "Choose your archetypes", "Available archetypes") as anything in classes

		switch(classchoice)
			if("Szabrista - Saber Veteran")	//Tl;dr - medium armor class for Mount and Blade larpers who still get a saiga. Akin to Vaquero with specific drip.
				H.set_blindness(0)
				to_chat(H, span_warning("The Szabristas are the elites of the southern steppes, veterans of conflict across the realm. Outfitted with a shishka and shield, these warriors sacrifice their swiftness for armor and civilized respect."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak		//Needs a unique helmet + mask combo at some point. 	//Dragonfruits to the rescue! Unique helmet with neck protection and +50 durability.
				gloves = /obj/item/clothing/gloves/roguetown/chain
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe	//Scale armor w/ better durability & unique sprite
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				backl = /obj/item/rogueweapon/shield/iron/steppesman
				beltl= /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/sabre/steppesman
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_SPD, 1)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil() 	//Fits in my head all too well.
				var/masks = list(				
				"Humen" 	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman,
				"Beast"		= /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
				"None"
		)
				var/maskchoice = input("What fits your face?", "MASK SELECTION") as anything in masks
				if(maskchoice != "None")
					mask = masks[maskchoice]

			if("Árkász - Elite Sapper")	//Tl;dr - medium armor sappers with less mobility in exchange for their different statblock and equipment.
				H.set_blindness(0)
				to_chat(H, span_warning("The Árkászi are frontline sappers specialized in sowing chaos and confusion in tandem with the Szabristas, focused on raw strength and will over the company's swordsmen and archers."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/chain
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				backl = /obj/item/rogueweapon/shield/iron/steppesman
				l_hand = /obj/item/rogueweapon/stoneaxe/battle/steppesman
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 2, TRUE)		//To avoid virtue cheese
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 2, TRUE)		//Ditto
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, 3, TRUE)		//Ditto
				H.adjust_skillrank_up_to(/datum/skill/craft/traps, 3, TRUE)			//Ditto
				H.change_stat(STATKEY_STR, 2)		//Statblock prone to revision. Probably will be revised. Currently weighted for 7 points and not 9.
				H.change_stat(STATKEY_WIL, 3)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_SPD, -2)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil()
				var/masks = list(				
				"Humen" 	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman,
				"Beast"		= /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
				"None"
		)
				var/maskchoice = input("What fits your face?", "MASK SELECTION") as anything in masks
				if(maskchoice != "None")
					mask = masks[maskchoice]

			if("Druzhina - Light Archer")	//Tl;dr - light armor class for Tatar-style archery. Has 'Druzhina' as a name cus czech/polish influence, couldn't think of better one.
				H.set_blindness(0)
				to_chat(H, span_warning("A Druzhina, a commoner of the Aavnic steppes made into a professional soldier. Hunters, herders, and various nomads from all walks of life. Equal in service, equal behind their bow, and ready to fight."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				beltr = /obj/item/quiver/javelin/iron
				beltl = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/steppesman
				neck = /obj/item/clothing/neck/roguetown/leather
				H.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/slings, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
				H.change_stat(STATKEY_PER, 3)
				H.change_stat(STATKEY_WIL, 2)
				H.change_stat(STATKEY_SPD, 2)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("Kozak - Light Infantry")		//Tl;dr - Old Steppesman whip build, light armor, be the glass canon you always wanted to be. Live your life, king. 
				H.set_blindness(0)
				to_chat(H, span_warning("Being a Kozak is not a title one earns, nor is born with. It's a way of life. Known to be eccentric, living life on the edge - but living as free as possible. Skilled with whips, these madmen are the bane of civilized warriors."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				head = /obj/item/clothing/head/roguetown/papakha	//No helm
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
				cloak = /obj/item/clothing/cloak/volfmantle			//Crazed man, gives the look.
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				beltr = /obj/item/rogueweapon/shield/buckler		//Doesn't get good shield skill + no armor, so they get this to compensate for no parry on whip.
				beltl = /obj/item/rogueweapon/whip
				neck = /obj/item/clothing/neck/roguetown/bevor		//Better neckpiece for slightly less skill variety. Based it off a cool piece of art...
				H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)		//Bit high but he doesn't get huge strength boons so makes up for it. Same as a guard.
				H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_SPD, 2)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()		//Semi-crazed warrior vibe.
		
	H.merctype = 11
