/datum/job/roguetown/druid
	title = "Druid"
	f_title = "Druidess"
	flag = DRUID
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS //gets set to dendor on the outfit anyways lol
	outfit = /datum/outfit/job/roguetown/druid
	tutorial = "You have always been drawn to the wild, and the wild drawn to you. When your calling came, it was from Dendor. Your patron claims dominion over all nature--promising bounties to those who act in his name to bring balance to His domain. The forest is the most comfortable place for you, toiling alongside soilsons and soilbrides...although sometimes what lies beyond the gates fills your soul with a feral yearning."

	display_order = JDO_DRUID
	give_bank_account = TRUE
	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // this was originally druid music. i think its ok to have druids share it w/ wardens.

	//You're.. not REALLY a full-on church member, but being a druid implies you became a clergy-man of some sort; even if it's non-organized. So, still shouldn't be noble.
	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_traits = list(TRAIT_SEEDKNOW, TRAIT_OUTDOORSMAN, TRAIT_RITUALIST, TRAIT_HOMESTEAD_EXPERT, TRAIT_WOODWALKER)

	advclass_cat_rolls = list(CTAG_DRUID = 2)
	job_subclasses = list(
		/datum/advclass/druid
	)

/datum/advclass/druid
	name = "Druid"
	tutorial = "You have always been drawn to the wild, and the wild drawn to you. When your calling came, it was from Dendor. \
	Your patron claims dominion over all nature--promising bounties to those who act in his name to bring balance to His domain. \
	The forest is the most comfortable place for you, toiling alongside soilsons and soilbrides...although sometimes what lies beyond the gates fills your soul with a feral yearning."
	outfit = /datum/outfit/job/roguetown/druid/basic
	category_tags = list(CTAG_DRUID)
	subclass_languages = list(/datum/language/beast)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/druidic = SKILL_LEVEL_JOURNEYMAN, //Shapeshifting.
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT, //Druids know the forest and when it has been disturbed
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE, //To help them defend themselves with parrying
		/datum/skill/combat/staves = SKILL_LEVEL_NOVICE, //This, too.
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/druid
	name = "Druid"
	jobtype = /datum/job/roguetown/druid
	allowed_patrons = list(/datum/patron/divine/dendor)
	has_loadout = TRUE

/datum/outfit/job/roguetown/druid/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	belt = /obj/item/storage/belt/rogue/leather/rope
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/rogueweapon/whip //The whip itself is not often associated to many jobs. Druids feel like a thematic choice to have a self-defense whip
	backl = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/dendormask
	wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
	backpack_contents = list(/obj/item/ritechalk, /obj/item/storage/keyring/churchie)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, 5, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/magic/druidic, 5, TRUE)
	H.ambushable = FALSE
	H.AddComponent(/datum/component/wise_tree_alert)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_DESTITUTE, H, "Church Funding.")

/datum/outfit/job/roguetown/druid/basic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.put_in_hands(new /obj/item/rogueweapon/woodstaff(H)) //To encourage them to wander the forests and to help defend themselves
