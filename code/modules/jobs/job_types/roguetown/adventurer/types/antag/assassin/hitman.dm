/datum/advclass/assassin_hitman
	name = "Snickersnacker"
	tutorial = "Some devotees of Psydon say that killing Graggarites through cuts is wrong, as blood empowers the Sinistar. \
	You prove that he cares not whether blood flows, as long as death follows. \
	Use your garrote, strength, or a mace to assist in your slayings. Snick-snack, a neck cracks."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/assassin/hitman
	category_tags = list(CTAG_ASSASSIN)
	traits_applied = list(TRAIT_BLACKBAGGER, TRAIT_UNCONVERTIBLE)	// Agent (15)47 - Lets you use the blackbag and garrote you
	// Weighted 14
	// post-redesign, this is basically a Souped Up Confessor. higher WIL, SPD, and PER. a little STR to get you through.
	// blackbag motherfuckers. if that doesn't work; Knife Dat Bitch!! you still also have stupidly high wrestling but im hoping w/ the
	// lack of con and eghh-- level strength this doesnt suck ass to play against. that being said; blackbags are limited. look into fucking w/ this more.
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_SPD = 3, // 6
		STATKEY_INT = 1,
		STATKEY_STR = 1, // 2
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		// MAIN COMBAT SKILLS
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,		// all classes get expert knives by default. this is here to be Clear.
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT, // as a backup. if you REALLY want to push into STR, you can, i guess.
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,	// grandfathered. if you *really need* a ranged option.
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN, // see: maces. only assassin class that gets this.
		// lamas isnt going to be happy about these two but their blackbags are limited & they were previously grandfathered in
		// as a one-off role that only shows up sometimes i think this is O.K. to keep.
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		// CHICHANERY
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, // put heads back on for blood bounty
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_NOVICE,
		// ASSASSIN ESSENTIALS
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
	)
	extra_context = "All assassins are DODGE EXPERTS, able to access the ZURCH, have NOSTINK, have ANTI-SCRYING, and are steel-hearted. \
	Each class also can summon the 'PROFANE DAGGER', which they are all experts in using."

/datum/outfit/job/roguetown/assassin/hitman/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/knuckles
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/flashlight/flare/torch/lantern/prelit = 1,
					/obj/item/lockpickring/mundane = 1,
					/obj/item/clothing/head/inqarticles/blackbag = 1,
					/obj/item/inqarticles/garrote = 1,
					)
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	backl = /obj/item/rogueweapon/mace/cudgel
	beltl = /obj/item/rogueweapon/scabbard/sheath
