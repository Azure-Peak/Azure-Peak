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
	outfit = /datum/outfit/job/roguetown/neophyte/
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
	traits_applied = list(TRAIT_GOODWRITER, TRAIT_KEENEARS) // fucking snitch, bro
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
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/keyring/neophyte = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/inqarticles/inqslip_kit = 1,
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Inquisition Funding.")

/datum/advclass/neophyte/page
	name = "Page"
	tutorial = "You are a young aspirant who dreams of one day taking up arms in service to the Inquisition. You are not yet ready to stand among the chapter, but you train, carry their equipment, tend to their needs and learn from their example. Until you are deemed ready, your duty is to serve and prepare."
	outfit = /datum/outfit/job/roguetown/neophyte/page
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_NEOPHYTE)
	traits_applied = list(TRAIT_SQUIRE_REPAIR)
	maximum_possible_slots = 1 // one is enough, they wouldn't send too many newbies to the front, the other two don't add to the deathball
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_LCK = -1,
	)
	subclass_skills = list(
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
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
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
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/keyring/neophyte = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/inqarticles/inqslip_kit = 1,
	)
	var/choice = tgui_alert(H, "Choose your path.", "PSYDON PROVIDES", list(
		"Devious (+1 LUC for good luck!)",
		"Devoted (T1 Miracles)",
		"Determined (Enduring, -2 WIL)",
		"Dexterous (Dodge Expert, -2 LUC)"
	))
	if(choice == "Devoted (T1 Miracles)")
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)
	else if(choice == "Determined (Enduring, -2 WIL)")
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
		H.change_stat(STATKEY_WIL, -2)
	else if(choice == "Dexterous (Dodge Expert, -2 LUC)")
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		H.change_stat(STATKEY_LCK, -2)
	else if(choice == "Devious (+1 LUC for good luck!)")
		H.change_stat(STATKEY_LCK, 1)

/datum/advclass/neophyte/oblate
	name = "Oblate"
	tutorial = "You are a devoted servant of Psydon and apprentice to the Absolver, following their sacred oath of pacifism. You too, believe violence should never be the first answer, and even the fiercest soul can be guided toward peace. Through prayer, mercy, counsel, and care for the wounded, you strive to embody the Allfather's teachings and your master's example, hoping that one day you may prove worthy of His holiest relic: the Golgatha."
	outfit = /datum/outfit/job/roguetown/neophyte/oblate
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_NEOPHYTE)
	traits_applied = list(TRAIT_PACIFISM, TRAIT_SILVER_BLESSED)
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
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Inquisition Funding.")

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
	start_crafting(user)

/obj/item/inqarticles/inqslip_kit/proc/start_crafting(mob/user)
	if(crafting)
		return FALSE
	if(!locate(/obj/structure/table) in get_step(user, user.dir))
		to_chat(user, span_warning("I need a table to do my holy work."))
		craft_type = null
		return FALSE
	crafting = TRUE
	craft_progress = 0
	var/duration = 3 SECONDS
	if(istype(user.job, /datum/job/roguetown/neophyte))
		duration = 2 SECONDS
	if(HAS_TRAIT(user, TRAIT_GOODWRITER))
		duration = 1 SECONDS
	to_chat(user, span_notice("You begin preparing the [craft_type] with your Inquisitorial Slip Kit..."))
	while(craft_progress < 40)
		if(QDELETED(src) || !user || QDELETED(user))
			crafting = FALSE
			craft_type = null
			craft_progress = 0
			return FALSE
		// Make sure they remain at the table while working.
		if(!locate(/obj/structure/table) in get_step(user, user.dir))
			to_chat(user, span_warning("You get distracted from what you were doing!"))
			crafting = FALSE
			craft_type = null
			craft_progress = 0
			return FALSE
		if(!do_after(user, duration, src))
			to_chat(user, span_warning("You stop preparing the document."))
			crafting = FALSE
			craft_type = null
			craft_progress = 0
			return FALSE
		craft_progress++
		if(craft_progress < 40)
			to_chat(user, span_warning("You continue preparing the [craft_type]... ([craft_progress]/40)."))
	return finish_crafting(user)

/obj/item/inqarticles/inqslip_kit/proc/finish_crafting(mob/user)
	if(!user || QDELETED(src))
		crafting = FALSE
		craft_type = null
		craft_progress = 0
		return FALSE
	var/obj/item/inqarticles/created
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
	var/requested

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
	var/obj/item/I = new requested(get_turf(H))
	if(!requested)
		to_chat(user, span_warning("This requisition contains no requested item. What a waste."))
		user.visible_message(span_notice("[user] sends something."))
		playsound(H.loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		qdel(src)
		return
	user.visible_message(span_notice("[user] sends something."))
	playsound(H.loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	user.put_in_hands(I)
	to_chat(user, span_notice("The HERMES processes the requisition and issues \the [I.name]."))
	qdel(src)
