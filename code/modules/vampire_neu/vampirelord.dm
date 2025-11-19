/datum/antagonist/vampire/lord
	name = "Methuselah"
	roundend_category = "Vampires"
	antagpanel_category = "Vampire"
	job_rank = ROLE_VAMPIRE
	generation = GENERATION_METHUSELAH
	show_in_antagpanel = TRUE
	antag_hud_type = ANTAG_HUD_VAMPIRE
	antag_hud_name = "vamplord"
	confess_lines = list(
		"I AM ANCIENT!",
		"I AM THE LAND!",
		"FIRSTBORNE CHILD OF KAIN!",
	)
	show_in_roundend = TRUE
	var/ascended = FALSE

/datum/antagonist/vampire/lord/get_antag_cap_weight()
	return 3

/datum/antagonist/vampire/lord/on_gain()
	. = ..()
	addtimer(CALLBACK(owner.current, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "[name]"), 5 SECONDS)

	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)
	for(var/datum/mind/MF in get_minds("Vampire Spawn"))
		owner.i_know_person(MF)
		owner.person_knows_me(MF)

	var/mob/living/carbon/human/H = owner.current
	H.equipOutfit(/datum/outfit/job/vamplord)
	H.set_patron(/datum/patron/inhumen/zizo)
	H.verbs |= /mob/living/carbon/human/proc/demand_submission
	H.maxbloodpool += 3000
	H.adjust_bloodpool(3000)
	for(var/S in MOBSTATS)
		H.change_stat(S, 2)
	H.forceMove(pick(GLOB.vlord_starts))

/datum/antagonist/vampire/lord/greet()
	to_chat(owner.current, span_userdanger("I am ancient. I am the Land. And I am now awoken to trespassers upon my domain."))
	. = ..()

/datum/outfit/job/vamplord/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank_up_to(/datum/skill/magic/blood, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/vampire
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltr = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	head  = /obj/item/clothing/head/roguetown/vampire
	beltl = /obj/item/roguekey/vampire
	cloak = /obj/item/clothing/cloak/cape/puritan
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel/black
	l_hand = /obj/item/rogueweapon/sword/long/judgement/vlord
	H.ambushable = FALSE

/*------VERBS-----*/

// NEW VERBS
/mob/living/carbon/human/proc/demand_submission()
	set name = "Demand Submission"
	set category = "VAMPIRE"
	if(SSmapping.retainer.king_submitted)
		to_chat(src, span_warning("I am already the Master of [SSmapping.config.map_name]."))
		return

	var/mob/living/carbon/ruler = SSticker.rulermob

	if(!ruler || (get_dist(src, ruler) > 1))
		to_chat(src, span_warning("The Master of [SSmapping.config.map_name] is not beside me."))
		return

	if(ruler.stat <= CONSCIOUS)
		to_chat(src, span_warning("[ruler] is still conscious."))
		return

	switch(alert(ruler, "Submit and Pledge Allegiance to [name]?", "SUBMISSION", "Yes", "No"))
		if("Yes")
			SSmapping.retainer.king_submitted = TRUE
		if("No")
			to_chat(ruler, span_boldnotice("I refuse!"))
			to_chat(src, span_boldnotice("[p_they(TRUE)] refuse[ruler.p_s()]!"))

/mob/living/carbon/human/proc/punish_spawn()
	set name = "Punish Minion"
	set category = "VAMPIRE"

	var/list/possible = list()
	for(var/datum/mind/V in SSmapping.retainer.vampires)
		if(V.special_role == "Vampire Spawn")
			possible[V.current.real_name] = V.current
	for(var/datum/mind/D in SSmapping.retainer.death_knights)
		possible[D.current.real_name] = D.current
	var/name_choice = input(src, "Who to punish?", "PUNISHMENT") as null|anything in possible
	if(!name_choice)
		return
	var/mob/living/carbon/human/choice = possible[name_choice]
	if(!choice || QDELETED(choice))
		return
	var/punishmentlevels = list("Pause", "Pain", "DESTROY")
	var/punishment = input(src, "Severity?", "PUNISHMENT") as null|anything in punishmentlevels
	if(!punishment)
		return
	switch(punishment)
		if("Pain")
			to_chat(choice, span_boldnotice("You are wracked with pain as your master punishes you!"))
			choice.apply_damage(30, BRUTE)
			choice.emote_scream()
			playsound(choice, 'sound/misc/obey.ogg', 100, FALSE, pressure_affected = FALSE)
		if("Pause")
			to_chat(choice, span_boldnotice("Your body is frozen in place as your master punishes you!"))
			choice.Paralyze(300)
			choice.emote_scream()
			playsound(choice, 'sound/misc/obey.ogg', 100, FALSE, pressure_affected = FALSE)
		if("DESTROY")
			to_chat(choice, span_boldnotice("You feel only darkness. Your master no longer has use of you."))
			addtimer(CALLBACK(choice, TYPE_PROC_REF(/mob/living, dust)), 10 SECONDS)
	visible_message(span_danger("[src] reaches out, gripping [choice]'s soul, inflicting punishment!"), ignored_mobs = list(choice))

////////Outfits////////
/obj/item/clothing/under/roguetown/platelegs/vampire
	name = "ancient plate greaves"
	desc = ""
	gender = PLURAL
	icon_state = "vpants"
	item_state = "vpants"
	sewrepair = FALSE
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_LEG_ANTAG
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = PLATEHIT
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/roguetown/shirt/vampire
	slot_flags = ITEM_SLOT_SHIRT
	name = "regal silks"
	desc = "A set of ornate robes with a sash coming across the breast."
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	icon_state = "vrobe"
	item_state = "vrobe"
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/roguetown/vampire
	name = "crown of darkness"
	icon_state = "vcrown"
	body_parts_covered = null
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = null
	sellprice = 1000
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/roguetown/armor/chainmail/iron/vampire
	icon_state = "vunder"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	name = "ancient chain shirt"
	desc = ""
	body_parts_covered = COVERAGE_TORSO
	body_parts_inherent = FULL_BODY
	armor_class = ARMOR_CLASS_HEAVY
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/roguetown/armor/plate/vampire
	slot_flags = ITEM_SLOT_ARMOR
	name = "ancient ceremonial plate"
	desc = ""
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = FULL_BODY
	icon_state = "vplate"
	item_state = "vplate"
	armor = ARMOR_VAMP
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	allowed_sex = list(MALE, FEMALE)
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 40
	armor_class = ARMOR_CLASS_HEAVY
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/shoes/roguetown/boots/armor/vampire
	name = "ancient ceremonial plated boots"
	desc = ""
	body_parts_covered = FEET
	body_parts_inherent = FULL_BODY
	icon_state = "vboots"
	item_state = "vboots"
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
	max_integrity = ARMOR_INT_LEG_ANTAG
	color = null
	blocksound = PLATEHIT
	armor = ARMOR_VAMP
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/roguetown/helmet/heavy/vampire
	name = "ancient ceremonial helm"
	icon_state = "vhelmet"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	body_parts_inherent = FULL_BODY
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
	block2add = FOV_BEHIND
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/active_item = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/vampire/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_HEAD)
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)

/obj/item/clothing/head/roguetown/helmet/heavy/vampire/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	REMOVE_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)

/obj/item/clothing/gloves/roguetown/chain/vampire
	name = "ancient ceremonial gloves"
	icon_state = "vgloves"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor = ARMOR_VAMP
	body_parts_inherent = FULL_BODY
	max_integrity = ARMOR_INT_SIDE_ANTAG
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
