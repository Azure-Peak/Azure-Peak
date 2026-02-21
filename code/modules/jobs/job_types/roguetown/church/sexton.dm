/datum/job/roguetown/sexton
	title = "Sexton"
	flag = SEXTON
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	tutorial = "You are a Sexton, an apprentice, helping hand or aide for the local church. Your responsibilities are little, but so are your obligations."
	outfit = /datum/outfit/job/roguetown/sexton/
	display_order = JDO_SEXTON
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advclass_cat_rolls = list(CTAG_SEXTON = 20)
	job_subclasses = list(
		/datum/advclass/sexton/groundskeeper,
		/datum/advclass/sexton/gravetender,
	)

/datum/outfit/job/roguetown/sexton
	has_loadout = TRUE

/datum/advclass/sexton/groundskeeper
	name = "Groundskeeper"
	tutorial = "You are the groundskeeper for the local church, and are responsible for all the little odd-jobs that keep it running. \
	Your duties range from cleaning the floors and pews to managing the stores and conducting church business."
	outfit = /datum/outfit/job/roguetown/sexton/groundskeeper
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_SEXTON)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
		STATKEY_INT = 2, //helps learning!
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE, //potential for repairs
	) //A little bit of every basic labor/craft skill, but zero combat skills

/datum/outfit/job/roguetown/sexton/groundskeeper/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	gloves = /obj/item/clothing/gloves/roguetown/leather
	pants = /obj/item/clothing/under/roguetown/trou
	belt = /obj/item/storage/belt/rogue/leather/sash
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	beltl = /obj/item/rogueweapon/shovel/small
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/keyring/acolyte = 1,
		/obj/item/natural/cloth = 1,
	)
	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/psicross/xylix
		else
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)	//Capped to T1 miracles.
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Church Funding.")


/datum/advclass/sexton/gravetender
	name = "Gravetender"
	tutorial = "You are the gravetender for the local church, and are responsible for taking care of the graves north of town and for the retrieval of the truly dead back into Necra's grasp. \
	Only the devout of Necra may take up the gravetender's mantle."
	outfit = /datum/outfit/job/roguetown/sexton/gravetender
	cmode_music = 'sound/music/combat_holy.ogg'
	maximum_possible_slots = 1 //No combat role stacking, please?
	category_tags = list(CTAG_SEXTON)
	traits_applied = list(TRAIT_OUTDOORSMAN) //often outside digging holes
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list( 
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
	) //practically only combat skills. Exchanges all of its homesteading (and even T1 Miracles!) for minor combat skills.

/datum/outfit/job/roguetown/sexton/gravetender
	allowed_patrons = list(/datum/patron/divine/necra)
	has_loadout = TRUE

/datum/outfit/job/roguetown/sexton/gravetender/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/inqhat/gravehat
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/gravecoat
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	belt = /obj/item/storage/belt/rogue/leather/black
	neck = /obj/item/clothing/neck/roguetown/psicross/silver/necra //thematic
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shovel/silver //Not pre-blessed, mind you
	beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow //main tool of defense
	beltr = /obj/item/quiver/bolts
	backpack_contents = list(
		/obj/item/burial_shroud = 2, //easier retrievals
		/obj/item/storage/keyring/acolyte = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_ORI, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_0)	//Orison and Locate Dead only.
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/locate_dead) //Gives Grovetender no healing nor combat miracles. Fetch them bodies, boy!

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Church Funding.")
		
	var/prev_real_name = H.real_name
	var/prev_name = H.name
	var/prefix = "Gravetender" // similar to Big Man: prefix so it's easier to tell who this guy is.
	H.real_name = "[prefix] [prev_real_name]"
	H.name = "[prefix] [prev_name]"	
