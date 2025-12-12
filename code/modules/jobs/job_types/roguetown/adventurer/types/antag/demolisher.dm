/datum/advclass/demolisher //medium armored hardy snob. Uses maces and explosive
	name = "Demolisher"
	tutorial = "What can stop a group of free people? The walls? enemy formations? Moral principles? Ha! Not when the demolisher is nearby.\n\
	The sale and illegal supply of explosives was a very lucrative business.\n\
	Unfortunately, you've been discovered, and now you're forced to hide in the woods while offering your services to your new friends."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/demolisher
	category_tags = list(CTAG_BANDIT)
	maximum_possible_slots = 2
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_ALCHEMY_EXPERT, TRAIT_EXPLOSIVE_SUPPLY, TRAIT_BOMBER_EXPERT)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 4, //extreme VVV
		STATKEY_CON = 4, //hardy
		STATKEY_SPD = -2, //slow
		STATKEY_LCK = 1,
		STATKEY_INT = 2
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_MASTER,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN, //bombs
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN, //bombs
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/bandit/demolisher/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	head = /obj/item/clothing/head/roguetown/roguehood/black
	backl = /obj/item/twstrap/bombstrap
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/bomb = 4,
					/obj/item/flint = 1,
					)
	mask = /obj/item/clothing/mask/rogue/facemask/copper
	neck = /obj/item/clothing/neck/roguetown/gorget/copper
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	beltl = /obj/item/satchel_bomb
	beltr = /obj/item/rogueweapon/mace/cudgel
	id = /obj/item/mattcoin
	H.set_blindness(0)

	if(!istype(H.patron, /datum/patron/inhumen/matthios))
		var/inputty = input(H, "Would you like to change your patron to Matthios?", "The Transactor calls", "No") as anything in list("Yes", "No")
		if(inputty == "Yes")
			to_chat(H, span_warning("My former deity has abandoned me.. Matthios is my new master."))
			H.set_patron(/datum/patron/inhumen/matthios)
		else
			return TRUE
