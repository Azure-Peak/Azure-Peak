/datum/job/roguetown/marshal // A somewhat ham-fisted merge between bailiff and the old town sheriff role. The latter was built like a modern day officer, but we medieval in this bitch!
	title = "Marshal"
	flag = MARSHAL
	department_flag = RETINUE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	display_order = JDO_MARSHAL
	selection_color = JCOLOR_RETINUE
	tutorial = "You are an agent of the crown in matters of law and military, making sure that laws are pushed, verified and carried out by the retinue upon the citizenry of the realm. \
				While you preside over the knights and men-at-arms, much of your work happens behind a desk, deferring to the Sergeant-at-Arms to make sure your will is carried out in the field."
	whitelist_req = FALSE

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/guard) // /obj/effect/proc_holder/spell/self/convertrole/warden
	outfit = /datum/outfit/job/roguetown/marshal

	give_bank_account = TRUE
	noble_income = 20
	min_pq = 8
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_knight.ogg'
	advclass_cat_rolls = list (CTAG_MARSHAL = 20)

	job_traits = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_PERFECT_TRACKER, TRAIT_EXPERT_HUNTER)
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible) //Needs to use the throat - sometimes
	job_subclasses = list(
		/datum/advclass/marshal/classic,
		/datum/advclass/marshal/kcommander
	)

/datum/outfit/job/roguetown/marshal
	job_bitflag = BITFLAG_ROYALTY | BITFLAG_GARRISON	//Same as Captain, you get decent combat stats so might as well be garrison.

/datum/outfit/job/roguetown/marshal/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	backl = /obj/item/storage/backpack/rogue/satchel
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	id = /obj/item/scomstone/garrison
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/signal_horn = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.verbs |= /mob/proc/haltyell
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/living/carbon/human/proc/request_law, /mob/living/carbon/human/proc/request_law_removal, /mob/living/carbon/human/proc/request_purge)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_RICH, H)

/datum/advclass/marshal/classic
	name = "Marshal"
	tutorial = "You've spent your daes in the courts and garrisons of the city. You've studied the law tome from back to front and enforce your word with the iron hand of justice, and the iron mace in your hands. More men have spent days rotting in the dungeon than that Knight Commander could ever have claimed, and every person in the realm respects your authority in matters of law and order."
	outfit = /datum/outfit/job/roguetown/marshal/classic

	category_tags = list(CTAG_MARSHAL)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_LCK = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/marshal/classic/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/retinue
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/bailiff
	backr = /obj/item/rogueweapon/mace/cudgel/justice
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/storage/keyring/marshal
	head = /obj/item/clothing/head/roguetown/chaperon/noble/bailiff

/datum/advclass/marshal/kcommander
	name = "Knight Commander"
	tutorial = "You spent your daes as a dutiful knight in the service of the crown. Earning your accolades through military tactics and victories, you're reknown for your warfaring. Now retired from your days afield, you enforce the same iron law you once practiced at war in your home. You run the garrison, knights and the town's laws with a military strictness, and no-one can claim you are weaker on crime than any of those weak Marshals."
	outfit = /datum/outfit/job/roguetown/marshal/kcommander

	category_tags = list(CTAG_MARSHAL)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_LCK = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/marshal/kcommander/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/marshal
	backr = /obj/item/rogueweapon/sword/long/oathkeeper
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/storage/keyring/marshal
	l_hand = /obj/item/rogueweapon/scabbard/sword/noble

/mob/proc/haltyell()
	set name = "HALT!"
	set category = "Noises"
	emote("haltyell")

/mob/proc/haltyell_exhausting()
	set name = "HALT!"
	set category = "Noises"

	emote("haltyell")
	stamina_add(rand(5,15))
