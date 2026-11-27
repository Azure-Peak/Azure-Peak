// Templar monk equivalent
// No dodge expert, relies on parrying and higher con instead
/datum/advclass/templar/maris
	name = "Maris"
	tutorial = "One of Abyssor's sentinels dedicated to the path of the dream painter. You are amongst the protectors of the cult, keeping your fellow cultists safe from dreamfiends. You are beholden to the word of the Bishop whose basement you dwell in."
	outfit = /datum/outfit/job/roguetown/maris
	allowed_patrons = list(/datum/patron/divine/abyssor)
	traits_applied = list(TRAIT_WATERBREATHING, TRAIT_CIVILIZEDBARBARIAN)
	category_tags = list(CTAG_TEMPLAR)
	maximum_possible_slots = 1
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE, // fish fillet drying
	)
	subclass_languages = list(/datum/language/abyssal)

/datum/outfit/job/roguetown/maris/pre_equip(mob/living/carbon/human/H)
	..()
	id = /obj/item/clothing/ring/silver/cleric
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	backl = /obj/item/storage/backpack/rogue/satchel
	mask = /obj/item/clothing/head/roguetown/roguehood/abyssor_painter
	neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea
	head = /obj/item/clothing/head/roguetown/headband/monk
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	pants = /obj/item/clothing/under/roguetown/trou/leather
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/storage/keyring/acolyte
	shoes = /obj/item/clothing/shoes/roguetown/footwraps/padded
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		/obj/item/mini_flagpole/church,
		/obj/item/rogueweapon/huntingknife/paint
		)
	H.cmode_music = 'sound/music/combat_holy.ogg' //on-par w/ monks
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	ADD_TRAIT(H, TRAIT_INK_AFFINITY, ROUNDSTART_TRAIT)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Church Funding.", mint_new = TRUE, mint_label = "Church funding", income_acct = LEDGER_CITIZEN_ESTATE)
	var/weapons = list("Discipline - Unarmed","Knuckledusters","Paintbrush")
	var/weapon_choice = input(H,"Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Discipline - Unarmed")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/bandages/pugilist(H))
		if("Knuckledusters")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/knuckles(H))
		if("Paintbrush")
			r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/steel/paint
