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
	job_traits = list(TRAIT_INQUISITION, TRAIT_HOMESTEAD_EXPERT)

/datum/outfit/job/roguetown/neophyte
	has_loadout = TRUE

/datum/advclass/neophyte/scribe
	name = "Scribe"
	tutorial = "You are an apprentice tasked with handling the records, correspondence and mundane work that would otherwise occupy the time of proper Inquisitors. You maintain documents, assist with the manor's upkeep and lend your hands wherever they are needed. Your work may be humble, but it allows those above you to focus on matters of greater importance."
	outfit = /datum/outfit/job/roguetown/neophyte/scribe
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_NEOPHYTE)
	virtue_limits = list(/datum/virtue/combat/combat_virtue, /datum/virtue/combat/dualwielder)
	traits_applied = list(TRAIT_GOODWRITER, TRAIT_KEENEARS, TRAIT_SELF_RELIANCE, TRAIT_JACKOFALLTRADES) // fucking snitch, bro
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
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/qsabsolution)

/datum/advclass/neophyte/page
	name = "Page"
	tutorial = "You are a young aspirant who dreams of one day taking up arms in service to the Inquisition. You are not yet ready to stand among the chapter, but you train, carry their equipment, tend to their needs and learn from their example. Until you are deemed ready, your duty is to serve and prepare."
	outfit = /datum/outfit/job/roguetown/neophyte/page
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_NEOPHYTE)
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_STEELHEARTED, TRAIT_COMBAT_JMAN, TRAIT_NOSHIELDS)
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
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/silver
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/sword/long/cleric
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

	var/choice = tgui_input_list(H, "Choose your path.", "PSYDON PROVIDES", list(devious, devoted, defying, determined, dexterous))
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
	virtue_limits = list(/datum/virtue/combat/dualwielder, /datum/virtue/thief, /datum/virtue/items/arsonist)
	traits_applied = list(TRAIT_PACIFISM, TRAIT_SILVER_BLESSED, TRAIT_MEDICINE_EXPERT, TRAIT_ROYAL_SUBSIDY)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_SPD = 2,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/ceramics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
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
		/obj/item/rogueweapon/huntingknife/scissors = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Inquisition Funding.")
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/qsabsolution)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)

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
	var/crafting = FALSE // someone is writing on it right now
	var/craft_progress = 0 // saved on the kit itself, so we pick up where we left off
	var/craft_steps = 40 // progress needed to finish a document
	var/craft_type

/obj/item/inqarticles/inqslip_kit/examine(mob/user)
	. = ..()
	// Inquisition members and Otavans both know what this is really about
	var/datum/virtue/origin = user.client?.prefs?.virtue_origin
	var/from_otava = istype(origin, /datum/virtue/origin/otava)
	if(HAS_TRAIT(user, TRAIT_INQUISITION) || from_otava)
		. += span_warning("Of late, the Otavan Inquisition seems to be sending its Neophytes over to Azurea, who come to learn rather than to serve. By arrangement with Otava, these unsalaried aspirants are writ in no ledger, and whatever they request is granted freely, as a courtesy to the order. The slip kit is chief among their tools: with it, a trained hand may draft confessions, accusations and requisitions bearing the weight of the Inquisition's seal. Its proper forms are taught only to those within the order, and a slip badly drawn is worth less than the parchment beneath it. You're almost certain that those aspirants, and this new program, are the ones behind the increased taxes back in Otava.")
	else
		. += span_warning("This might have a lot of diplomatic weight, despite your ineptitude to make heads nor tails of it. Maybe in a few months, you could decipher how to falsify those documents?")

	if(!craft_type)
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			. += span_info("Set it down on a table and right-click it to begin writing.")
		return
	. += span_notice("There is a [craft_type] in the works, [round(craft_progress / craft_steps * 100)]% done.")
	if(crafting)
		. += span_info("Someone is writing on it right now.")

// In hand: scrap whatever is being written
/obj/item/inqarticles/inqslip_kit/attack_self(mob/user)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_INQUISITION))
		to_chat(user, span_warning("You have no idea how to use this at all at the present moment."))
		return
	if(!craft_type)
		to_chat(user, span_notice("Nothing is being written. Set it down on a table and right-click it to begin."))
		return
	if(crafting)
		to_chat(user, span_warning("The kit is being used right now."))
		return

	var/choice = tgui_alert(user, "Scrap the [craft_type]? Its [round(craft_progress / craft_steps * 100)]% of progress will be lost.", "Inquisitorial Slip Kit", list("Yes", "No"))
	if(choice != "Yes")
		return
	if(!do_after(user, 1.5 SECONDS, src))
		return
	if(QDELETED(src) || !craft_type) // someone else may have scrapped it meanwhile
		return

	to_chat(user, span_warning("You scrap the [craft_type]."))
	craft_type = null
	craft_progress = 0

// On a table: right-click to start (or keep) writing
/obj/item/inqarticles/inqslip_kit/attack_right(mob/user)
	if(!HAS_TRAIT(user, TRAIT_INQUISITION))
		to_chat(user, span_warning("You have no idea how to use this at all at the present moment."))
		return TRUE
	if(crafting)
		to_chat(user, span_warning("The kit is already being used."))
		return TRUE
	if(!(isturf(loc) && (locate(/obj/structure/table) in loc)))
		to_chat(user, span_warning("I need to set this down on a table to do my holy work."))
		return TRUE

	// First time: decide what to write. Later on we just keep going.
	if(!craft_type)
		var/choice = tgui_input_list(user, "What would you like to prepare?", "Inquisitorial Slip Kit", list(
			"Draft Confession",
			"Draft Accusation",
			"Draft INDEXER Requisition",
			"Draft SNACKS Requisition"
		))
		if(!choice)
			return TRUE
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
	return TRUE

/obj/item/inqarticles/inqslip_kit/proc/start_crafting(mob/user)
	// Re-checked here because the type prompt above can take a while
	if(crafting || !craft_type)
		return FALSE
	if(!(isturf(loc) && (locate(/obj/structure/table) in loc)))
		to_chat(user, span_warning("I need to set this down on a table to do my holy work."))
		return FALSE

	crafting = TRUE

	// Neophytes are practiced at this, good writers even more so
	var/duration = 4 SECONDS
	if(istype(user.job, /datum/job/roguetown/neophyte) || user.job == "Neophyte")
		duration = 2 SECONDS
	if(HAS_TRAIT(user, TRAIT_GOODWRITER))
		duration = 1 SECONDS

	to_chat(user, span_notice("You [craft_progress ? "continue" : "begin"] preparing the [craft_type] with your Inquisitorial Slip Kit..."))

	// What the writer has just accomplished, one line per 10 progress
	var/list/milestones = list(
		"have set down the title and opening lines of the [craft_type]",
		"have written the introductory passage and established its purpose",
		"have filled out the opening account with the necessary particulars",
		"have laid down the principal body and its supporting details",
		"have expanded upon the account and cited the relevant passages",
		"have reviewed the preceding passages and amended their wording",
		"have written the concluding passage and closing remarks",
		"have penned the final lines and are ready to affix His Holiest Seal"
	)

	var/completed = TRUE
	while(craft_progress < craft_steps)
		if(QDELETED(src) || QDELETED(user))
			completed = FALSE
			break
		// The kit has to stay on its table the whole time
		if(!(isturf(loc) && (locate(/obj/structure/table) in loc)))
			to_chat(user, span_warning("The kit is no longer on a table!"))
			completed = FALSE
			break
		if(!do_after(user, duration, src))
			to_chat(user, span_warning("You stop writing. What you wrote so far stays on the kit."))
			completed = FALSE
			break
		craft_progress++
		if(craft_progress % 5 == 0)
			playsound(src, 'sound/items/write.ogg', 100, FALSE)
			var/milestone = min(craft_progress / 10, length(milestones))
			to_chat(user, span_warning("You [milestones[milestone]]. ([round(craft_progress / craft_steps * 100)]%)"))

	crafting = FALSE
	if(!completed)
		return FALSE
	return finish_crafting(user)

/obj/item/inqarticles/inqslip_kit/proc/finish_crafting(mob/user)
	if(!user || QDELETED(src))
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
	craft_type = null
	craft_progress = 0
	return !!created

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
	var/processing = FALSE // true while a HERMES is working on it

/obj/item/inqarticles/requisition/attack_self(mob/user)
	. = ..()
	to_chat(user, span_notice("This requisition must be presented to a HERMES terminal for processing."))

/obj/item/inqarticles/requisition/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity || processing)
		return
	if(!istype(target, /obj/structure/roguemachine/mail))
		return

	var/obj/structure/roguemachine/mail/H = target

	if(!requested && !length(requested_pool))
		to_chat(user, span_warning("This requisition contains no requested item. What a waste."))
		user.visible_message(span_notice("[user] sends something."))
		playsound(H.loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		qdel(src)
		return

	// The terminal keeps the document while it processes the request
	if(!user.transferItemToLoc(src, H, TRUE))
		return
	processing = TRUE
	user.visible_message(span_notice("[user] sends something."))
	playsound(H.loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	to_chat(user, span_notice("The HERMES whirs as it receives the requisition. It should be ready shortly..."))
	addtimer(CALLBACK(src, PROC_REF(deliver), H, user), 12 SECONDS)

/obj/item/inqarticles/requisition/proc/deliver(obj/structure/roguemachine/mail/H, mob/user)
	// Terminal got destroyed while processing, the document goes with it
	if(QDELETED(H))
		qdel(src)
		return

	// The single requested item, or a random draw without repeats from the pool
	var/list/to_issue = list()
	if(requested)
		to_issue += requested
	else
		var/list/pool = requested_pool.Copy()
		for(var/i in 1 to min(requested_amount, length(pool)))
			var/picked = pick(pool)
			pool -= picked
			to_issue += picked
	if(!length(to_issue))
		qdel(src)
		return

	// Everything arrives sealed in an Inquisition parcel
	var/obj/item/parcel/inquisition/delivery = new(get_turf(H))
	delivery.load_items(to_issue)

	H.visible_message(span_notice("The HERMES processes the requisition and issues \the [delivery]."))
	// If whoever sent it is still standing there, hand it over
	if(!QDELETED(user) && user.Adjacent(H))
		user.put_in_hands(delivery)
	qdel(src)

/obj/item/parcel/inquisition

/obj/item/parcel/inquisition/Initialize(mapload)
	. = ..()
	// Not a quest parcel: always visible, no reveal proximity monitor
	invisibility = initial(invisibility)
	QDEL_NULL(proximity_monitor)

/// Seals the given item types inside, and sizes/names the parcel to match
/obj/item/parcel/inquisition/proc/load_items(list/item_types)
	var/large = FALSE
	for(var/item_type in item_types)
		var/obj/item/I = new item_type(src)
		contained_items += I
		if(I.w_class >= WEIGHT_CLASS_NORMAL)
			large = TRUE

	if(length(contained_items) == 1)
		var/obj/item/only = contained_items[1]
		name = "parcel ([only.name])"
		desc = "A securely wrapped parcel containing [only.name]."
	else
		name = "parcel (assorted goods)"
		desc = "A securely wrapped parcel containing [length(contained_items)] items."
	icon_state = large ? "ration_large" : "ration_small"
	dropshrink = 1
	update_icon()

/obj/item/parcel/inquisition/can_open(mob/user)
	if(!HAS_TRAIT(user, TRAIT_INQUISITION))
		to_chat(user, span_warning("This [sealed_noun] bears the seal of the Inquisition. Only its members may open it."))
		return FALSE
	return TRUE

/obj/item/parcel/inquisition/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		. += span_notice("It bears the seal of the Inquisition. As one of its own, you may open it.")
	else
		. += span_warning("It's stamped with the seal of the Inquisition. Only its members should open it.")
