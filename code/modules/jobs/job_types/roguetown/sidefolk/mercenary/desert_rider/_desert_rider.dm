/datum/advclass/mercenary/desert_rider
	name = "Desert Rider Janissary"
	tutorial = "Janissaries are often ex-soldiers, recruited from one of the many city-states of Raneshen. Defection or a completed tour?; it hardly matters. With a shield, stout armor, and disciplined stance, they stand tall. Their Momentum gives them Strength."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider
	class_select_category = CLASS_CAT_RANESHENI
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_desertrider.ogg'
	subclass_languages = list(/datum/language/raneshi)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/mercenary/desert_rider/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/zeybek_momentum/janissary)
	to_chat(H, span_warning("The Desert Riders are a slightly-infamous band of mercenaries, as old and prestigious as Grenzelhoft's own. They have fought on both sides of nearly every conflict since the fall of the Celestial Empire."))
	head = /obj/item/clothing/head/roguetown/helmet/sallet/raneshen
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	gloves = /obj/item/clothing/gloves/roguetown/chain
	pants = /obj/item/clothing/under/roguetown/brigandinelegs
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/clothing/neck/roguetown/shalal,
		/obj/item/flashlight/flare/torch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	var/weapons = list("Mace & Shield","Spear & Shield")
	if(H.mind)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Mace & Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				backl = /obj/item/rogueweapon/shield/tower/raneshen
			if("Spear & Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				r_hand = /obj/item/rogueweapon/spear
				backl = /obj/item/rogueweapon/shield/tower/raneshen

	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	beltl = /obj/item/rogueweapon/sword/long/marlin
	beltr = /obj/item/rogueweapon/scabbard/sword

	H.merctype = 4
