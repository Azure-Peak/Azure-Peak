// towner bow-hunter/spear-hunter analogue
/datum/advclass/outcast/poacher
	name = "Poacher"
	tutorial = "You have rejected society and its laws, choosing life in the wilderness instead. Simple thieving highwayman or freedom fighter, you take from those who have and give to the have-nots. Fancy, how the latter includes yourself!"
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/outcast/poacher
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_MASTERFUL_HUNTER)
	cmode_music = 'sound/music/combat_poacher.ogg'
	category_tags = list(CTAG_OUTCAST)

	subclass_stats = list( // they get more stats in their outfit choice; adds up to 6 statweight total
		STATKEY_PER = 1,
		STATKEY_CON = 1
	)
	subclass_skills = list( // amalgam of bow-hunter n spear-hunter
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
	)
	maximum_possible_slots = 20 // Should not fill, just a hack to make it shows what types of outcasts are in round

// yes, this is p much just the towner hunter loadout. it's a disguise, and also, you are uniquely well-equipped to make light armor so
/datum/outfit/job/roguetown/outcast/poacher/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/archercap
	mask = /obj/item/clothing/head/roguetown/roguehood/red
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/shirt/tunic/green //Can wear this as a cloak too
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/tights/green
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backl = /obj/item/storage/backpack/rogue/backpack
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	r_hand = /obj/item/storage/meatbag
	backpack_contents = list(
				/obj/item/flint = 1,
				/obj/item/bait = 1,
				/obj/item/rogueweapon/huntingknife/combat/messser = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1,
				/obj/item/hunting_map/white_stag = 1,
				/obj/item/hunting_map/boars = 1,
				)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_LOWER_CLASS, H)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/huntersyell)
		var/weapons = list("Recurve Bow","Crossbow","Spear")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		if(weapon_choice=="Spear")	// melee loadout: +2 str for a total of 6 statweight
			H.STASTR += 2
		else						// ranged loadout: +2 per and +1 spd, for a total of 6 statweight
			H.STAPER += 2
			H.STASPD += 1
		switch(weapon_choice)
			if("Recurve Bow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/quiver/arrows
			if("Crossbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/bolt/standard
			if("Spear")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE) // no idea why towner SH gets less wskill than bowhunter someone can buff this if it's stupid
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				l_hand = /obj/item/rogueweapon/spear
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/huntersyell)
	outcast_select_bounty(H)
