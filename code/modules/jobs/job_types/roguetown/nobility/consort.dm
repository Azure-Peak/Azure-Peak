/datum/job/roguetown/lady
	title = "Consort"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0

	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	tutorial = "Picked out of your political value rather than likely any form of love, you have become the rulers most trusted confidant--and likely friend--throughout your time at their side. Your loyalty, patience and trust will be tested this day... for the daggers that threaten the neck of the one who wears the crown are as equally pointed at your own." //no more refence to marriage or love, can be platonic

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/servant,
	/obj/effect/proc_holder/spell/self/grant_nobility, /obj/effect/proc_holder/spell/self/grant_title) //why not
	outfit = /datum/outfit/job/roguetown/lady

	display_order = JDO_LADY
	give_bank_account = TRUE
	noble_income = 22
	min_pq = 10 //should probably be higher with duchess at 50
	max_pq = null
	round_contrib_points = 3
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible) //Needs to use the throat - sometimes

	advclass_cat_rolls = list(CTAG_CONSORT = 2)
	job_subclasses = list(
		/datum/advclass/consort
	)
	has_subprefs = FALSE

/datum/advclass/consort
	name = "Consort"
	tutorial = "Picked out of your political value rather than likely any form of love, you have become the rulers most trusted confidant--and likely friend--throughout your time at their side. Your loyalty, patience and trust will be tested this day... for the daggers that threaten the neck of the one who wears the crown are as equally pointed at your own."
	outfit = /datum/outfit/job/roguetown/lady/basic
	category_tags = list(CTAG_CONSORT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 5,
	)
	subclass_skills = list(
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, //not that easy to grab after all
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT, //of course
	)

/datum/job/roguetown/exlady
	title = "Consort Dowager"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	display_order = JDO_LADY
	give_bank_account = TRUE

/datum/outfit/job/roguetown/lady
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/lady/basic
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord //weaker than duke's one
	pants = /obj/item/clothing/under/roguetown/tights/puritan
	backr = /obj/item/storage/backpack/rogue/satchel/short
	shoes = /obj/item/clothing/shoes/roguetown/rosa/nine
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	neck = /obj/item/clothing/neck/roguetown/ornateamulet/noble
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/scomstone/garrison

/datum/outfit/job/roguetown/lady/basic/pre_equip(mob/living/carbon/human/H)
	. = ..()
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KEENEARS, TRAIT_GENERIC)
//		SSticker.rulermob = H
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold
	if(H.wear_mask) //sovl injection
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch/left))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask/l
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich,
		/obj/item/rogueweapon/huntingknife/idagger/steel/decorated,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/storage/keyring/lord = 1,
		/obj/item/roguekey/skeleton = 1
	)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_RICH, H)
		record_round_statistic(STATS_MARRIAGES_MADE)//Terrible way to do this but like, it wouldn't work off the "I'm married proc" so here we are.

/obj/effect/proc_holder/spell/self/convertrole/servant
	name = "Recruit Servant"
	new_role = "Servant"
	overlay_state = "recruit_servant"
	recruitment_faction = "Servants"
	recruitment_message = "Serve the crown, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."
	recharge_time = 100
