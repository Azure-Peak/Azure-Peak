/datum/job/roguetown/neophyte
	title = "Neophyte"
	flag = NEOPHYTE
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_sexes = list(MALE, FEMALE)
	allowed_patrons = list(/datum/patron/old_god) // endvre
	forbidden_races = list(/datum/species/construct/metal)
	tutorial = "You are a Neophyte, an apprentice, helping hand or aide for the local embassy. Your responsibilities are little, but so are your obligations."
	outfit = /datum/outfit/job/roguetown/neophyte
	display_order = JDO_NEOPHYTE
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advclass_cat_rolls = list(CTAG_NEOPHYTE = 20)
	job_subclasses = list(
		/datum/advclass/neophyte/scribe,
		/datum/advclass/neophyte/page,
		/datum/advclass/neophyte/oblate,
	)
	job_traits = list(TRAIT_INQUISITION, TRAIT_HOMESTEAD_EXPERT, TRAIT_COMBAT_JMAN, TRAIT_NOSHIELDS)

/datum/outfit/job/roguetown/neophyte
	has_loadout = TRUE

/datum/advclass/neophyte/scribe
	name = "Scribe"
	tutorial = "You are an apprentice tasked with handling the records, correspondence and mundane work that would otherwise occupy the time of proper Inquisitors. You maintain documents, assist with the manor's upkeep and lend your hands wherever they are needed. Your work may be humble, but it allows those above you to focus on matters of greater importance."
	outfit = /datum/outfit/job/roguetown/neophyte/scribe
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_NEOPHYTE)
	virtue_limits = list(/datum/virtue/combat/combat_virtue, /datum/virtue/combat/dualwielder)
	traits_applied = list(TRAIT_GOODWRITER, TRAIT_KEENEARS, TRAIT_ROYAL_SUBSIDY) // fucking snitch, bro
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN, // sweatlords will go for dust runner for the free JMAN way around TnR, so I'm just giving them this anyway, it's also just knives anyway so who cares
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/neophyte/scribe/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/headband/monk/black
	cloak = /obj/item/clothing/cloak/tabard/psydontabard/black/alt
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	beltl = /obj/item/rogueweapon/huntingknife/combat/silver
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator
	gloves = /obj/item/clothing/gloves/roguetown/bandages
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/keyring/neophyte = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/inqarticles/inqslip_kit = 1,
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Inquisition Funding.")

/datum/advclass/neophyte/page
	name = "Page"
	tutorial = "You are a young aspirant who dreams of one day taking up arms in service to the Inquisition. You are not yet ready to stand among the chapter, but you train, carry their equipment, tend to their needs and learn from their example. Until you are deemed ready, your duty is to serve and prepare."
	outfit = /datum/outfit/job/roguetown/neophyte/page
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_NEOPHYTE)
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_STEELHEARTED)
	maximum_possible_slots = 1 // one is enough, they wouldn't send too many newbies to the front, the other two don't add to the deathball
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_LCK = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/neophyte/page/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/headband/monk/black
	cloak = /obj/item/clothing/cloak/tabard/psydontabard/black/alt
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	beltl = /obj/item/rogueweapon/huntingknife/combat/silver
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/ornate
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator
	gloves = /obj/item/clothing/gloves/roguetown/bandages
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/keyring/neophyte = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/inqarticles/inqslip_kit = 1,
	)

	// ALL THE D's!
	var/devious = "Devious (+1 LUC)"
	var/devoted = "Devoted (T1 Miracles)"
	var/defying = "Defying (Deathless, -1 LUC)"
	var/determined = "Determined (Enduring, -1 LUC)"
	var/dexterous = "Dexterous (Dodge Expert, -1 LUC)"

	var/choice = tgui_alert(H, "Choose your path.", "PSYDON PROVIDES", list(devious, devoted, defying, determined, dexterous))
	if(choice == devious)
		H.change_stat(STATKEY_LCK, 1)
	else if(choice == devoted)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)
	else if(choice == defying)
		ADD_TRAIT(H, TRAIT_DEATHLESS, JOB_TRAIT)
		H.change_stat(STATKEY_LCK, -1)
	else if(choice == determined)
		ADD_TRAIT(H, TRAIT_NOPAINSTUN, JOB_TRAIT)
		H.change_stat(STATKEY_LCK, -1)
	else if(choice == dexterous)
		ADD_TRAIT(H, TRAIT_DODGEEXPERT, JOB_TRAIT)
		H.change_stat(STATKEY_LCK, -1)
	else
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Inquisition Funding.")

/datum/advclass/neophyte/oblate
	name = "Oblate"
	tutorial = "You are a devoted servant of Psydon and apprentice to the Absolver, following their sacred oath of pacifism. You too, believe violence should never be the first answer, and even the fiercest soul can be guided toward peace. Through prayer, mercy, counsel, and care for the wounded, you strive to embody the Allfather's teachings and your master's example, hoping that one day you may prove worthy of His holiest relic: the Golgatha."
	outfit = /datum/outfit/job/roguetown/neophyte/oblate
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_NEOPHYTE)
	traits_applied = list(TRAIT_PACIFISM, TRAIT_SILVER_BLESSED, TRAIT_ROYAL_SUBSIDY)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_SPD = 2,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/neophyte/oblate/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/headband/monk/black
	cloak = /obj/item/clothing/cloak/tabard/psydontabard/black/alt
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/psicross/silver/anointed
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator
	gloves = /obj/item/clothing/gloves/roguetown/bandages
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/keyring/neophyte = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/inqarticles/inqslip_kit = 1,
		/obj/item/rogueweapon/huntingknife/combat/silver = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Inquisition Funding.")

/obj/item/inqarticles/inqslip_kit
	name = "Inquisitorial Slip Kit"
	desc = "A collection of tools used to draft and issue Inquisitorial slips and forms in the field. Only those initiated into the Inquisition should know how to properly use its contents."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "slip_kit"
	w_class = WEIGHT_CLASS_SMALL
	grid_height = 32
	grid_width = 32
	slot_flags = ITEM_SLOT_HIP
	intdamage_factor = 0
	sellprice = 0
	var/crafting = FALSE
	var/craft_progress = 0
	var/craft_type

/obj/item/inqarticles/inqslip_kit/attack_self(mob/user)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_INQUISITION))
		to_chat(user, span_warning("You have no idea how to use this at all at the present moment."))
		return
	if(crafting)
		to_chat(user, span_warning("The kit is already being used."))
		return
	var/choice = input(user, "What would you like to prepare?", "Inquisitorial Slip Kit") as null|anything in list(
		"Draft Confession",
		"Draft Accusation",
		"Draft INDEXER Requisition"
	)
	if(!choice)
		return
	switch(choice)
		if("Draft Confession")
			craft_type = "confession"
		if("Draft Accusation")
			craft_type = "accusation"
		if("Draft INDEXER Requisition")
			craft_type = "requisition (INDEXER)"
		if("Draft SNACKS Requisition")
			craft_type = "requisition (SNACKS)"
	start_crafting(user)

/obj/item/inqarticles/inqslip_kit/proc/start_crafting(mob/user)
	if(crafting)
		return FALSE
	if(!(locate(/obj/structure/table) in get_step(user, user.dir)))
		to_chat(user, span_warning("I need a table to do my holy work."))
		craft_type = null
		return FALSE

	crafting = TRUE
	craft_progress = 0

	// Neophytes are practiced at this, good writers even more so
	var/duration = 4 SECONDS
	if(istype(user.job, /datum/job/roguetown/neophyte) || user.job == "Neophyte")
		duration = 2 SECONDS
	if(HAS_TRAIT(user, TRAIT_GOODWRITER))
		duration = 1 SECONDS

	to_chat(user, span_notice("You begin preparing the [craft_type] with your Inquisitorial Slip Kit..."))

	var/completed = TRUE
	while(craft_progress < 40)
		// Scrapped (right click), or the kit / user is gone
		if(!crafting || QDELETED(src) || QDELETED(user))
			completed = FALSE
			break
		// Make sure they remain at the table while working.
		if(!(locate(/obj/structure/table) in get_step(user, user.dir)))
			to_chat(user, span_warning("You get distracted from what you were doing!"))
			completed = FALSE
			break
		if(!do_after(user, duration, src))
			to_chat(user, span_warning("You stop preparing the document."))
			completed = FALSE
			break
		if(!crafting) // scrapped while we were working
			completed = FALSE
			break
		craft_progress++
		if(craft_progress < 40)
			to_chat(user, span_warning("You continue preparing the [craft_type]... ([craft_progress]/40)."))

	if(!completed)
		crafting = FALSE
		craft_type = null
		craft_progress = 0
		return FALSE
	return finish_crafting(user)

/obj/item/inqarticles/inqslip_kit/proc/finish_crafting(mob/user)
	if(!user || QDELETED(src))
		crafting = FALSE
		craft_type = null
		craft_progress = 0
		return FALSE
	var/obj/item/created
	switch(craft_type)
		if("confession")
			created = new /obj/item/paper/inqslip/confession(get_turf(user))
		if("accusation")
			created = new /obj/item/paper/inqslip/accusation(get_turf(user))
		if("requisition (INDEXER)")
			var/obj/item/inqarticles/requisition/requisition = new(get_turf(user))
			requisition.desc += " <i>It seems penned for an INDEXER.</i>"
			requisition.requested = /obj/item/inqarticles/indexer
			created = requisition
		if("requisition (SNACKS)")
			var/obj/item/inqarticles/requisition/requisition = new(get_turf(user))
			requisition.desc += " <i>It seems penned for some snacks? How imprudent.</i>"
			requisition.requested_amount = 3
			requisition.requested_pool = list(
				/obj/item/reagent_containers/food/snacks/rogue/psycrossbun_jamtallowed,
				/obj/item/reagent_containers/food/snacks/rogue/psycrossbun_marmaladed,
				/obj/item/reagent_containers/food/snacks/rogue/cheesebun,
				/obj/item/reagent_containers/food/snacks/rogue/bun_raston,
				/obj/item/reagent_containers/food/snacks/rogue/griddle,
				/obj/item/reagent_containers/food/snacks/rogue/pastry,
				/obj/item/reagent_containers/food/snacks/rogue/biscuit,
				/obj/item/reagent_containers/food/snacks/rogue/chocolatebiscuit,
				/obj/item/reagent_containers/food/snacks/rogue/plumbiscuit,
				/obj/item/reagent_containers/food/snacks/rogue/tangerinebiscuit,
				/obj/item/reagent_containers/food/snacks/rogue/cookie,
				/obj/item/reagent_containers/food/snacks/rogue/cookied,
				/obj/item/reagent_containers/food/snacks/rogue/dot_tart,
			)
			created = requisition
	if(created)
		to_chat(user, span_notice("You finish preparing the [created.name]."))
		user.put_in_hands(created)
	crafting = FALSE
	craft_type = null
	craft_progress = 0
	return !!created

/obj/item/inqarticles/inqslip_kit/attack_right(mob/user)
	if(crafting)
		to_chat(user, span_warning("You stop preparing, and scrap the document."))
		crafting = FALSE
		craft_type = null
		craft_progress = 0
		return TRUE
	return ..()

/obj/item/inqarticles/requisition
	name = "Field Requisition"
	desc = "An official document for Inquisitorial requisitions. Seems quite important, yet hastily made."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "requisition"
	w_class = WEIGHT_CLASS_TINY
	sellprice = 0
	var/requested // a single item type
	var/list/requested_pool // or: a list of item types to pick randomly from
	var/requested_amount = 1 // how many to pick from the pool

/obj/item/inqarticles/requisition/attack_self(mob/user)
	. = ..()
	to_chat(user, span_notice("This requisition must be presented to a HERMES terminal for processing."))

/obj/item/inqarticles/requisition/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(!istype(target, /obj/structure/roguemachine/mail))
		return

	var/obj/structure/roguemachine/mail/H = target
	user.visible_message(span_notice("[user] sends something."))
	playsound(H.loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

	if(!requested && !length(requested_pool))
		to_chat(user, span_warning("This requisition contains no requested item. What a waste."))
		qdel(src)
		return

	var/list/issued = list()
	if(requested)
		issued += new requested(get_turf(H))
	else
		// Pick without repeats
		var/list/pool = requested_pool.Copy()
		for(var/i in 1 to min(requested_amount, length(pool)))
			var/picked = pick(pool)
			pool -= picked
			issued += new picked(get_turf(H))

	for(var/obj/item/I as anything in issued)
		user.put_in_hands(I)

	if(length(issued) == 1)
		to_chat(user, span_notice("The HERMES processes the requisition and issues \the [issued[1]]."))
	else
		to_chat(user, span_notice("The HERMES processes the requisition and issues [length(issued)] items."))
	qdel(src)
