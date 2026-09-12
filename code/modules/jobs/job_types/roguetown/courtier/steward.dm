/datum/job/roguetown/steward
	title = "Steward"
	flag = STEWARD
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_STEWARD
	tutorial = "Coin, Coin, Coin! Oh beautiful coin: You're addicted to it, and you hold the position as the Grand Duke's personal treasurer of both coin and information. You know the power silver and gold has on a man's mortal soul, and you know just what lengths they'll go to in order to get even more. Keep your festering economy alive- for it is the only thing you can weigh any trust into anymore."
	outfit = /datum/outfit/job/roguetown/steward
	give_bank_account = TRUE
	noble_income = 16
	quest_claim_barred = TRUE
	min_pq = 3 //Please don't give the vault keys to somebody that's going to lock themselves in on accident
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_noble.ogg'
	is_quest_giver = TRUE

	advclass_cat_rolls = list(CTAG_STEWARD = 2)

	job_traits = list(TRAIT_NOBLE, TRAIT_SEEPRICES, TRAIT_ROYAL_SUBSIDY)
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible) //Needs to use the throat - sometimes
	virtue_restrictions = list(/datum/virtue/utility/skilled, /datum/virtue/utility/apprentice) //Commerce role, not a craftsman.
	job_subclasses = list(
		/datum/advclass/steward
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/steward
	name = "Steward"
	tutorial = "Coin, Coin, Coin! Oh beautiful coin: You're addicted to it, and you hold the position as the Grand Duke's personal treasurer of both coin and information. You know the power silver and gold has on a man's mortal soul, and you know just what lengths they'll go to in order to get even more. Keep your festering economy alive- for it is the only thing you can weigh any trust into anymore."
	outfit = /datum/outfit/job/roguetown/steward/basic

	category_tags = list(CTAG_STEWARD)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_CON = 1,
		STATKEY_STR = -2
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/steward
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/steward/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward
	else if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/silktunic
	head = /obj/item/clothing/head/roguetown/chaperon/noble/steward
	pants = /obj/item/clothing/under/roguetown/tights/puritan
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold
	belt = /obj/item/storage/belt/rogue/leather/plaquegold/noble
	beltr = /obj/item/rogueweapon/scabbard/sheath/royal
	beltl = /obj/item/storage/belt/rogue/pouch/merchant/coins
	neck = /obj/item/clothing/neck/roguetown/ornateamulet/noble
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/scomstone
	if(H.wear_mask) //Sovl Injection
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch/left))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask/l
	else
		mask = /obj/item/clothing/mask/rogue/spectacles/fancy/dark
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
	add_verb(H, /mob/living/carbon/human/proc/adjust_taxes)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_RICH, H)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/decorated = 1, //okay, they're like the richest guy that isn't a royal in the realm, they can have a histerically overpriced dagger, sire.
		/obj/item/storage/keyring/steward = 1,
		/obj/item/mini_flagpole/steward = 1,
		/obj/item/clothing/ring/signet = 1,
		/obj/item/recipe_book/treasury_primer = 1,
	)

/mob/living/carbon/human/proc/adjust_taxes()
	set name = "Adjust Taxes"
	set category = "RoleUnique.Stewardry"
	if(stat)
		return
	var/datum/taxsetter/taxsetter = new("The Diligent Steward Intervenes", "The Greedy Steward Imposes")
	taxsetter.ui_interact(src)
