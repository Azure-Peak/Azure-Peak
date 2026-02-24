/datum/job/roguetown/wapprentice
	title = "Magicians Associate"
	flag = APPRENTICE
	department_flag = BURGHERS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4

	allowed_races = ACCEPTED_RACES
	spells = list(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	advclass_cat_rolls = list(CTAG_WAPPRENTICE = 20)

	tutorial = "Yils of study have led you to the University of Azuria. The Divine heals and protects. The arcyne arts, though useful, are far more suited to death and destruction. The Crown knows this, and provides a stipend to fund your studies and just as much your complacency, to not turn your magicks against the Crown. A comfortable tenure, a stipend, and a place to undergo your study. What more could a Mage ask for?"

	outfit = /datum/outfit/job/roguetown/wapprentice

	display_order = JDO_APPRENTICE
	give_bank_account = TRUE

	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/nobility/combat_courtmage.ogg'
	advjob_examine = TRUE // So that Court Magicians can know if they're teachin' a Apprentice or if someone's a bit more advanced of a player. Just makes the title show up as the advjob's name.

	job_traits = list(TRAIT_ALCHEMY_EXPERT, TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3)
	job_subclasses = list(
		/datum/advclass/wapprentice/associate,
		/datum/advclass/wapprentice/alchemist,
		/datum/advclass/wapprentice/apprentice
	)

/datum/outfit/job/roguetown/wapprentice
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights/random
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/magebag/associate
	beltr = /obj/item/storage/keyring/apprentice
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff
	shoes = /obj/item/clothing/shoes/roguetown/gladiator // FANCY SANDALS

/datum/advclass/wapprentice/associate
	name = "Magician's Associate"
	tutorial = "No one could truly master the entirety of the arcyne arts. But commanding the fundamentals is quite achievable. Deemed competent by your peers and mentor, you have become an Associate, paid a stipend to wield your power in the name of the Crown, or at least not against them. The Crown might want a bolt of lightning in their enemies back - after all, what else is the arcyne good for but war and destruction? But as many mages knows, wisdom and whimsy is the true calling of the Magi who has mastered the arts. The choice is yours."
	outfit = /datum/outfit/job/roguetown/wapprentice/associate

	category_tags = list(CTAG_WAPPRENTICE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1
	)
	age_mod = /datum/class_age_mod/apprentice_associate
	subclass_spellpoints = 21
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wapprentice/associate/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
		)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")

/datum/advclass/wapprentice/alchemist
	name = "Alchemist Associate"
	tutorial = "Some never considered alchemy a true arcyne art, but simply a foundation. Like a quill is to poetry. During your studies, however, you have taken to the passion of alchemy, the transmutation of elements and the creation of something concrete. Lyfeblood, elixirs, coal dust, moondust, ozium, and bottle bombs! All under Psydonia is yours to create! Just don't set the University on fire. Or do, but don't get caught."
	outfit = /datum/outfit/job/roguetown/wapprentice/alchemist

	category_tags = list(CTAG_WAPPRENTICE)
	traits_applied = list(TRAIT_SEEDKNOW)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_WIL = 1
	)
	age_mod = /datum/class_age_mod/apprentice_alchemist
	subclass_spellpoints = 18
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/staves = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wapprentice/alchemist/pre_equip(mob/living/carbon/human/H)
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/seeds/swampweed = 1,
		/obj/item/seeds/pipeweed = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1
		)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")

/datum/advclass/wapprentice/apprentice
	name = "Magician's Apprentice"
	tutorial = "The road to arcyne mastery is long and treacherous. Books, scrolls, gems, studies, singed hair, and summoning gone wrong. Expenses and death alike, it is not a path for the pauper or the coward. You, however, were given a place as an apprentice in the University of Azuria. Under the watchful gaze of the Court Magician, and their fellow associates, you may yet live to become a master of the arcyne arts."
	outfit = /datum/outfit/job/roguetown/wapprentice/apprentice

	category_tags = list(CTAG_WAPPRENTICE)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1 // this is just a carrot for the folk who are mad enough to take this role...
	)
	age_mod = /datum/class_age_mod/apprentice_apprentice
	subclass_spellpoints = 18
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/staves = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wapprentice/apprentice/pre_equip(mob/living/carbon/human/H)
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/chalk = 1,
		)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
