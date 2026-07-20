/datum/job/roguetown/painter
	title = "Painter"
	tutorial = "Not a painter in the traditional sense, you are a visionary. Peer into the dream pool of Abyssor and receive great visions of past, present and future. Gaze into the esotheric realm of the Deepfather's dream. Go bother others with your prophecies."
	flag = PAINTER
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_ages = ALL_AGES_LIST
	allowed_patrons = list(/datum/patron/divine/abyssor)
	virtue_restrictions = list(/datum/virtue/utility/noble)
	forbidden_races = list(RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/monk
	display_order = JDO_PAINTER
	give_bank_account = TRUE
	min_pq = 1
	max_pq = null
	round_contrib_points = 3

	job_traits = list(TRAIT_WATERBREATHING, TRAIT_INK_AFFINITY, TRAIT_RITUALIST, TRAIT_CLERGY)

	advclass_cat_rolls = list(CTAG_PAINTER = 2)
	job_subclasses = list(
		/datum/advclass/herald,
		/datum/advclass/voice,
		/datum/advclass/maris,
	)

// Acolyte variant
/datum/advclass/herald
	name = "Herald of the abyss"
	tutorial = "One of Abyssor's acolytes dedicated to the path of the dream painter. You are amongst the most studious of the cult, capable of casting the most powerful miracles. Detail your visions, bring great tidings... Perfom the grunt work to prepare the greatest rituals. You are beholden to the word of the Bishop whose basement you dwell in."
	outfit = /datum/outfit/job/roguetown/herald
	category_tags = list(CTAG_PAINTER)
	traits_applied = list(TRAIT_ALCHEMY_EXPERT, TRAIT_GRAVEROBBER, TRAIT_HOMESTEAD_EXPERT)
	maximum_possible_slots = 1
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_PER = 2,
		// Nice day to go fishing, eh?
		STATKEY_LCK = 1,
		STATKEY_STR = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
	)
	subclass_languages = list(/datum/language/abyssal)

/datum/outfit/job/roguetown/herald/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/storage/keyring/acolyte
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	pants = /obj/item/clothing/under/roguetown/tights
	neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea
	head = /obj/item/clothing/head/roguetown/roguehood/abyssor_painter
	backpack_contents = list(/obj/item/ritechalk, /obj/item/mini_flagpole/church)
	H.cmode_music = 'sound/music/cmode/church/combat_acolyte.ogg'
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_LOWER_MIDDLE_CLASS, H)

// Trades utility skills for ever so slightly more stats, combat skills and equipment. T3.
// Basically the world's worst leader just to not pump church's combat capabilities too much.
/datum/advclass/voice
	name = "Voice of the seas"
	tutorial = "One of Abyssor's visionaries dedicated to the path of the dream painter. You are amongst the exhalted of the cult, leading this little branch of abyssorite misfits. Keep in mind your authority does not reach past the cult, and you are beholden to the word of the Bishop whose basement you dwell in."
	outfit = /datum/outfit/job/roguetown/voice
	category_tags = list(CTAG_PAINTER)
	// Not sold on them having civ barb, but parrying without is hell.
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_STEELHEARTED)
	maximum_possible_slots = 1
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
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
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
	)
	subclass_languages = list(/datum/language/abyssal)

/datum/outfit/job/roguetown/voice/pre_equip(mob/living/carbon/human/H)
	..()
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_leader
	head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssor_painter
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	pants = /obj/item/clothing/under/roguetown/tights/black
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/storage/keyring/acolyte
	shoes = /obj/item/clothing/shoes/roguetown/footwraps/padded
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/storage/keyring/acolyte = 1
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_3)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Church Funding.")
	var/weapons = list("Discipline - Unarmed","Knuckledusters","Quarterstaff","Sylveric Trident")
	var/weapon_choice = input(H,"Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Discipline - Unarmed")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/bandages/pugilist(H))
		if("Knuckledusters")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/knuckles(H))
		if("Quarterstaff")
			r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/steel
			backr = /obj/item/rogueweapon/scabbard/gwstrap
		if("Sylveric Trident")
			r_hand = /obj/item/rogueweapon/spear/dreamscape_trident
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if(H.mind)
				// Basically bind weapon for dream items. Works on the trident.
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dream_bind)

// Templar monk equivalent
// No dodge expert, relies on parrying and higher con instead
/datum/advclass/maris
	name = "Maris"
	tutorial = "One of Abyssor's sentinels dedicated to the path of the dream painter. You are amongst the protectors of the cult, keeping your fellow cultists safe from dreamfiends. You are beholden to the word of the Bishop whose basement you dwell in."
	outfit = /datum/outfit/job/roguetown/maris
	category_tags = list(CTAG_PAINTER)
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_STEELHEARTED)
	maximum_possible_slots = 1
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
	)
	subclass_languages = list(/datum/language/abyssal)

/datum/outfit/job/roguetown/maris/pre_equip(mob/living/carbon/human/H)
	..()
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	backl = /obj/item/storage/backpack/rogue/satchel
	mask = /obj/item/clothing/head/roguetown/roguehood/abyssor_painter
	neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea
	head = /obj/item/clothing/head/roguetown/headband/monk
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	pants = /obj/item/clothing/under/roguetown/tights/black
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/storage/keyring/acolyte
	shoes = /obj/item/clothing/shoes/roguetown/footwraps/padded
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/storage/keyring/acolyte = 1
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Church Funding.")
	var/weapons = list("Discipline - Unarmed","Knuckledusters","Quarterstaff")
	var/weapon_choice = input(H,"Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Discipline - Unarmed")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/bandages/pugilist(H))
		if("Knuckledusters")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/knuckles(H))
		if("Quarterstaff")
			r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/steel
			backr = /obj/item/rogueweapon/scabbard/gwstrap
