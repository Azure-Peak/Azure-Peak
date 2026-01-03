/datum/job/roguetown/monk
	title = "Acolyte"
	flag = MONK
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 6
	spawn_positions = 6

	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/monk
	tutorial = "Chores, some more chores- Even more chores.. Oh how the life of a humble acolyte is exhausting… You have faith, but even you know you gave up a life of adventure for that of the security in the Church. Assist the Bishop in their daily tasks, maybe today will be the day something interesting happens."

	display_order = JDO_MONK
	give_bank_account = TRUE
	min_pq = 1 //A step above Churchling, should funnel new players to the churchling role to learn miracles at a more sedate pace
	max_pq = null
	round_contrib_points = 5

	//No nobility for you, being a member of the clergy means you gave UP your nobility. It says this in many of the church tutorial texts.
	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_traits = list(TRAIT_RITUALIST, TRAIT_GRAVEROBBER, TRAIT_HOMESTEAD_EXPERT, TRAIT_CLERGY)
	advclass_cat_rolls = list(CTAG_ACOLYTE = 2)
	job_subclasses = list(
		/datum/advclass/acolyte
	)

/datum/advclass/acolyte
	name = "Acolyte"
	tutorial = "Chores, some more chores- Even more chores.. Oh how the life of a humble acolyte is exhausting… You have faith, but even you know you gave up a life of adventure for that of the security in the Church. Assist the Bishop in their daily tasks, maybe today will be the day something interesting happens."
	outfit = /datum/outfit/job/roguetown/monk/basic
	subclass_languages = list(/datum/language/grenzelhoftian)
	category_tags = list(CTAG_ACOLYTE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)

/datum/outfit/job/roguetown/monk
	name = "Acolyte"
	jobtype = /datum/job/roguetown/monk
	has_loadout = TRUE
	job_bitflag = BITFLAG_HOLY_WARRIOR
	allowed_patrons = list(/datum/patron/divine/undivided, /datum/patron/divine/pestra, /datum/patron/divine/astrata, /datum/patron/divine/eora, /datum/patron/divine/noc, /datum/patron/divine/necra, /datum/patron/divine/abyssor, /datum/patron/divine/malum, /datum/patron/divine/ravox, /datum/patron/divine/xylix) // The whole Ten. Probably could delete this now, actually.

/datum/outfit/job/roguetown/monk/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/storage/keyring/churchie
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/ritechalk)
	H.cmode_music = 'sound/music/cmode/church/combat_acolyte.ogg' // has to be defined here for the selection below to work. sm1 please rewrite cmusic to apply pre-equip.
	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/white
			cloak = /obj/item/clothing/cloak/undivided
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if(/datum/patron/divine/noc)
			head = /obj/item/clothing/head/roguetown/roguehood/nochood
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
			wrists = /obj/item/clothing/wrists/roguetown/nocwrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/noc
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		if(/datum/patron/divine/abyssor) // the deep calls!
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			pants = /obj/item/clothing/under/roguetown/tights
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
			head = /obj/item/clothing/head/roguetown/roguehood/abyssor
		if(/datum/patron/divine/dendor) //Dendorites all busted. Play Druid.
			head = /obj/item/clothing/head/roguetown/dendormask
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/roguetown/necrahood
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			shoes = /obj/item/clothing/shoes/roguetown/boots
			pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/necra
			shirt = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
			cloak = /obj/item/clothing/cloak/raincloak/mortus
			backr = /obj/item/rogueweapon/shovel/silver
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
			head = /obj/item/clothing/head/roguetown/roguehood/phys
			shoes = /obj/item/clothing/shoes/roguetown/boots
			pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
			cloak = /obj/item/clothing/cloak/templar/pestran
		if(/datum/patron/divine/eora) //Eora content from Stonekeep
			head = /obj/item/clothing/head/roguetown/eoramask
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/eora
			cloak = /obj/item/clothing/cloak/templar/eoran
		if(/datum/patron/divine/malum)
			head = /obj/item/clothing/head/roguetown/roguehood
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
			shoes = /obj/item/clothing/shoes/roguetown/boots
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			pants = /obj/item/clothing/under/roguetown/trou
			cloak = /obj/item/clothing/cloak/templar/malumite
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
		if(/datum/patron/divine/ravox)
			head = /obj/item/clothing/head/roguetown/roguehood
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
			cloak = /obj/item/clothing/cloak/templar/ravox
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/boots
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/white
			backpack_contents = list(/obj/item/ritechalk, /obj/item/book/rogue/law)
		if(/datum/patron/divine/xylix)
			head = /obj/item/clothing/head/roguetown/roguehood
			cloak = /obj/item/clothing/cloak/templar/xylixian
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe
			neck = /obj/item/clothing/neck/roguetown/luckcharm // For good luck, as Xylix would intend
			H.cmode_music = 'sound/music/combat_jester.ogg'
			var/datum/inspiration/I = new /datum/inspiration(H)
			I.grant_inspiration(H, bard_tier = BARD_T2)
		else
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast)
	// -- End of section for god specific bonuses --
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")

/datum/outfit/job/roguetown/monk/basic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/divine/undivided)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/astrata) // Light and Guidance - Like ravox, they probably can endure seeing some shit.
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	if(H.patron?.type == /datum/patron/divine/noc) // Arcyne and Knowledge - Probably good at reading and the other arcyne adjacent stuff.
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
		H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE) // for their arcane spells, very little CDR and cast speed.
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		ADD_TRAIT(H, TRAIT_ARCYNE_T1, TRAIT_GENERIC) // So that they can take arcyne potential and not break.
	if(H.patron?.type == /datum/patron/divine/abyssor) // The Sea and Weather - probably would be good at fishing
		H.adjust_skillrank(/datum/skill/labor/fishing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/necra) // Death and Moving on - grave diggers.
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE) // digging graves and carrying bodies builds muscles probably.
		H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
	if(H.patron?.type == /datum/patron/divine/pestra) // Medicine and Healing - better surgeons and alchemists
		H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 4, TRUE)
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/eora) // Beauty and Love - beautiful and can read people pretty well.
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
	if(H.patron?.type == /datum/patron/divine/malum) // Craft and Creativity - they can make stuff.
		ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
	if(H.patron?.type == /datum/patron/divine/ravox) // Justice and Honor - athletics and probably a bit better at handling the horrors of war
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/staves, 3, TRUE) //On par with an Adventuring Monk. Seems quite fitting.
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/xylix)  // Trickery and Inspiration - muxic and rogueish skills
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, 2, TRUE)
