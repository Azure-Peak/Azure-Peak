/datum/advclass/assassin_ranger
	name = "Headhunter"
	tutorial = "You prefer to see your targets dead from a range. Skilled in bows, crossbows, and slings, rain death from afar. \
	If need be, your dagger serves as the perfect back-up weapon. You've slain enough beasts in the woods; claim the Dark Star's blood-bounties."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/assassin/ranger
	category_tags = list(CTAG_ASSASSIN)
	traits_applied = list(TRAIT_WOODWALKER, TRAIT_OUTDOORSMAN, TRAIT_UNCONVERTIBLE)	// Master of the Forest - Tosses them a bone for wilderness chases.
	// Weighted 14
	subclass_stats = list(
		STATKEY_PER = 4,
		STATKEY_SPD = 3,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		// MAIN COMBAT SKILLS
		// instead of getting an alternate melee choice, youre good at ALL the ranged stuff. awesome.
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/slings = SKILL_LEVEL_EXPERT,
		// wrestling. fuck my life.
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT, // already expert, just here for clarification.
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		// CHICHANERY
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, // re-attach heads
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		// ASSASSIN ESSENTIALS
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
	)
	extra_context = "All assassins are DODGE EXPERTS, able to access the ZURCH, have NOSTINK, have ANTI-SCRYING, and are steel-hearted. \
	Each class also can summon the 'PROFANE DAGGER', which they are all experts in using."

/datum/outfit/job/roguetown/assassin/ranger/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/raincloak/red
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/flashlight/flare/torch/lantern/prelit = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/rogueweapon/huntingknife/idagger/warden_machete = 1,
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/lockpickring/mundane = 1,
					)
	mask = /obj/item/clothing/mask/rogue/wildguard
	neck = /obj/item/clothing/neck/roguetown/coif
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	beltl = /obj/item/rogueweapon/scabbard/sheath
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Yew Longbow","Crossbow")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Yew Longbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltl = /obj/item/quiver/arrows
			if("Crossbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/bolt/standard
