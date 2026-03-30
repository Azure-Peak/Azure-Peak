/datum/advclass/mercenary/desert_rider/zeybek
	name = "Desert Rider Zeybek"
	tutorial = "The Desert Riders are a band of mercenaries known for their loose morals and high effectiveness. From an evil, ignoble beginning as an infamous company meant to track down runaway slaves, they grew into a considerable force. Their skill with long and short blades are famed and feared the world over."
	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider_zeybek
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/desert_rider_zeybek/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/zeybek_momentum/zeybek)
	to_chat(H, span_warning("The Desert Riders are a slightly-infamous band of mercenaries, as old and prestigious as Grenzelhoft's own. They have fought on both sides of nearly every conflict since the fall of the Celestial Empire."))
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/raneshen
	neck = /obj/item/clothing/neck/roguetown/leather
	mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	gloves = /obj/item/clothing/gloves/roguetown/angle
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
	backr = /obj/item/storage/backpack/rogue/satchel/black
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/clothing/neck/roguetown/shalal,
		/obj/item/flashlight/flare/torch,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	var/weapons = list("Shamshirs and Javelin","Whips and Knives", "Recurve Bow")
	if(H.mind)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Shamshirs and Javelin")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				backl = /obj/item/quiver/javelin/iron
			if("Whips and Knives")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/whip
				beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
			if("Recurve Bow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				backl = /obj/item/quiver/arrows

	H.merctype = 4
