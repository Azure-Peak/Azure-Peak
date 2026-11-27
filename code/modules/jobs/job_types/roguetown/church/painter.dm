/datum/job/roguetown/painter
	title = "Painter"
	tutorial = "Not a painter in the traditional sense, you are a visionary. Peer into the dream pool of Abyssor and receive great visions of past, present and future. Gaze into the esotheric realm of the Deepfather's dream. Go bother others with your prophecies."
	flag = PAINTER
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_ages = ALL_AGES_LIST
	allowed_patrons = list(/datum/patron/divine/abyssor)
	virtue_restrictions = list(/datum/virtue/utility/noble)
	quirk_restrictions = list(/datum/quirk/noble)
	forbidden_races = list(RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/monk
	display_order = JDO_PAINTER
	give_bank_account = TRUE
	min_pq = 1
	max_pq = null
	round_contrib_points = 3
	quest_claim_barred = TRUE

	job_traits = list(TRAIT_WATERBREATHING, TRAIT_RITUALIST, TRAIT_CLERGY)

	advclass_cat_rolls = list(CTAG_PAINTER = 2)
	job_subclasses = list(
		/datum/advclass/voice,
	)

// Compared to acolyte, trades utility skills for ever so slightly more stats, combat skills and equipment. T3.
// Basically the world's worst leader just to not pump church's combat capabilities too much.
/datum/advclass/voice
	name = "Voice of the Seas"
	tutorial = "One of Abyssor's visionaries dedicated to the path of the dream painter. You are amongst the exalted of the cult, leading this little branch of abyssorite misfits. Keep in mind your authority does not reach past the cult, and you are beholden to the word of the Bishop whose basement you dwell in. Perhaps you can recruit some of the loyal abyssorites around here."
	outfit = /datum/outfit/job/roguetown/voice
	category_tags = list(CTAG_PAINTER)
	// Not sold on them having civ barb, but parrying without is hell.
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_STEELHEARTED, TRAIT_BLEED_PAINT)
	maximum_possible_slots = 1
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE // fish fillet drying
	)
	subclass_languages = list(/datum/language/abyssal)

/datum/outfit/job/roguetown/voice/pre_equip(mob/living/carbon/human/H)
	..()
	id = /obj/item/clothing/ring/gold
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	neck = /obj/item/clothing/neck/roguetown/psicross/abyssor/g //represents the cult, has to be somewhat outstanding
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_leader
	head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssor_painter
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	pants = /obj/item/clothing/under/roguetown/trou/leather
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/storage/backpack/rogue/satchel/short
	shoes = /obj/item/clothing/shoes/roguetown/footwraps/padded
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		/obj/item/mini_flagpole/church,
		/obj/item/storage/keyring/acolyte
		)
	H.cmode_music = 'sound/music/combat_holy.ogg' //on-par w/ monks
	ADD_TRAIT(H, TRAIT_INK_AFFINITY, ROUNDSTART_TRAIT)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_4)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Church Funding.", mint_new = TRUE, mint_label = "Church funding", income_acct = LEDGER_CITIZEN_ESTATE)
	var/weapons = list("Discipline - Unarmed","Knuckledusters","Sylveric Trident")
	var/weapon_choice = input(H,"Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Discipline - Unarmed")
			r_hand = /obj/item/clothing/gloves/roguetown/bandages/pugilist
		if("Knuckledusters")
			r_hand = /obj/item/clothing/gloves/roguetown/knuckles
		if("Sylveric Trident")
			r_hand = /obj/item/rogueweapon/spear/trident/dreamscape_trident
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if(H.mind)
				// Basically bind weapon for dream items. Works on the trident.
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dream_bind)
	var/brushes = list("Offensive Brush", "Healing Brush")
	var/brush_choice = input(H,"Choose your ritualistic brush.", "TAKE UP FAITH") as anything in brushes
	switch(brush_choice)
		if("Offensive Brush")
			l_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/steel/paint
		if("Healing Brush")
			l_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/steel/paint_heal
