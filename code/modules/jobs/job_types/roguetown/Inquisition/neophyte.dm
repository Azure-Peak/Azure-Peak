/datum/job/roguetown/neophyte
	title = "Neophyte"
	flag = NEOPHYTE
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "The stories of old must be Transcribed. You are a Neophyte, an apprentice and page for the local inquisitorial embassy. As you are not a combatant like most of this troupe, your responsibilities are little, but so are your obligations. Accompany the Absolver in spreading His Love, or follow the Inquisitor to seek stories to scribe."
	selection_color = JCOLOR_INQUISITION
	outfit = /datum/outfit/job/roguetown/neophyte/
	display_order = JDO_NEOPHYTE
	min_pq = 1
	max_pq = null
	round_contrib_points = 2
	wanderer_examine = FALSE
	advjob_examine = FALSE
	give_bank_account = 25
	job_traits = list(
		TRAIT_INQUISITION,
		TRAIT_HOMESTEAD_EXPERT,
	)
	//As they are meant to be a non-combatant, let us blacklist all combat-centric virtues. Similar to the Hag.
	virtue_restrictions = list(
		/datum/virtue/combat/dualwielder,
		/datum/virtue/combat/combat_virtue, 
		/datum/virtue/combat/crossbowman,
		/datum/virtue/combat/bowman,
		/datum/virtue/combat/sharp,
		/datum/virtue/combat/combat_aware,
		)
	advclass_cat_rolls = list(CTAG_NEOPHYTE = 2)
	job_subclasses = list(
		/datum/advclass/neophyte
	)

/datum/advclass/neophyte
	name = "Neophyte"
	tutorial = "The stories of old must be Transcribed. You are a Neophyte, an apprentice and page for the local inquisitorial embassy. As you are not a combatant like most of the Orthodoxists, your responsibilities are little, but so are your obligations."
	outfit = /datum/outfit/job/roguetown/neophyte/basic
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_NEOPHYTE)
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_CON = -1,
		STATKEY_LCK = -2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_SPD = 1 
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE, //in the steps of the absolver
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE, //potential for embassy/chapel repairs, an extra class cookie
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE, 
	) //A little bit of every basic labor/craft skill, but absolutely zero combat skills

	tempo_capable = FALSE
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy,
		"The Plates" = /obj/item/repair_kit/metal,
		"The Kit" = /obj/item/repair_kit,
	)

/datum/outfit/job/roguetown/neophyte/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	cloak = /obj/item/clothing/cloak/tabard/psydontabard/black
	mask = /obj/item/clothing/head/roguetown/roguehood/psydon/black
	neck = /obj/item/roguekey/inquisitionmanor
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/natural/feather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	backl = /obj/item/storage/backpack/rogue/satchel/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	id = /obj/item/clothing/ring/signet/psy
	backpack_contents = list(
		/obj/item/paper/inqslip/arrival/neophyte = 1,//a pitiful three Marques
		/obj/item/book/rogue/bibble/psy = 1,
		/obj/item/inqarticles/indexer = 1,
		/obj/item/paper/scroll = 3,
		/obj/item/paper/inqslip/confession = 1,
		/obj/item/paper/inqslip/accusation = 2,
		)

	switch(H.patron?.type)
		if(/datum/patron/old_god)
			wrists = /obj/item/clothing/neck/roguetown/psicross/silver
			H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_APPRENTICE, TRUE)
			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
		else
			wrists = /obj/item/clothing/neck/roguetown/psicross