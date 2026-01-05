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
		"I AM THE FIRSTBORNE OF KAINE!",
		"I AM THE INHERITOR!",
	)
	show_in_roundend = TRUE
	var/ascended = FALSE
	max_thralls = 69

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
	ADD_TRAIT(H, TRAIT_DUSTABLE, TRAIT_GENERIC) //They are ancient and have a great risk. Maybe add a quest to reclaim their power?
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC) //Brute-forced method to ensure that Vampire Lords, no matter what, receive their most important traits.
	ADD_TRAIT(H, TRAIT_INFINITE_ENERGY, TRAIT_GENERIC) //Playing it safe, with the assumption that Vampire Lords already inherit any traits given to regular Vampires.
	ADD_TRAIT(H, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_BITERHELM, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

/datum/antagonist/vampire/lord/greet()
	to_chat(owner.current, span_userdanger("I am ancient. I am the Land. And I am now awoken to trespassers upon my domain."))
	. = ..()

/datum/outfit/job/vamplord/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank_up_to(/datum/skill/magic/blood, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE) //Reduced from Legendary-tier, as Halford's new Blood Magic system compensates a lot for this.
	H.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE) //Equalized all combat skills to be Master-tier, otherwise,
	H.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	pants = /obj/item/clothing/under/roguetown/tights/puritan
	shirt = /obj/item/clothing/suit/roguetown/shirt/vampire
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
	gloves = /obj/item/clothing/gloves/roguetown/chain
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltr = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	beltl = /obj/item/roguekey/vampire
	head = /obj/item/clothing/head/roguetown/vampire
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	cloak = /obj/item/clothing/cloak/cape/puritan
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
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

////////OUTFITS////////
/obj/item/clothing/suit/roguetown/shirt/vampire
	slot_flags = ITEM_SLOT_SHIRT
	name = "regal silks"
	desc = "An ornate robe, meticulously weaved from crimson silk and studded with enchanted gilbranze buttons. A Lord's presentation is everything; and unlike the dull-blooded, you've had plenty of tyme to cultivate your flamboyance."
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	icon_state = "vrobe"
	item_state = "vrobe"
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/roguetown/vampire
	name = "crown of darkness"
	desc = "An obsidian crown, bejeweled with a beautifully-cut rontz. It is an eternal reminder that this world is yours to conquer - let no one, dull-blooded or otherwise, stop your fallen kingdom from rising once more."
	icon_state = "vcrown"
	body_parts_covered = null
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = null
	sellprice = 1000
	smeltresult = /obj/item/ingot/draconic //Closest - and most valuable - analogue to obsidian.
	resistance_flags = FIRE_PROOF | ACID_PROOF

////////BROKEN////////
/obj/item/clothing/suit/roguetown/armor/chainmail/iron/vampire
	name = "old ancient ceremonial vestments" //Currently invisible, due to the lack of an object sprite. Reinstate once someone adds a 'vunder' icon to the shirt.dmi.
	desc = "An ornate aketon, woven from crimson silk and worn beneath a layer of enchanted gilbranze maille. Vheslyn, Zizo, Kaine had all failed in their pursuits - yet, the ancient truths they left behind were more valuable than lyfe itself. It's time to show them all how a Lord truly gets it done."
	icon_state = "vunder"
	item_state = "vunder"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	body_parts_covered = COVERAGE_TORSO
	body_parts_inherent = FULL_BODY
	armor_class = ARMOR_CLASS_HEAVY
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	resistance_flags = FIRE_PROOF | ACID_PROOF
	smeltresult = /obj/item/ingot/purifiedaalloy

////////VAMPYRELORD-EXCLUSIVE ARMORSET////////
/obj/item/clothing/suit/roguetown/armor/plate/vampire
	slot_flags = ITEM_SLOT_ARMOR
	name = "ancient ceremonial plate"
	desc = "Enchanted gilbranze armor, bearing the heraldry of a fallen kingdom. Upon the cuirass remains a singular puncture, unable to be fully mended by even the finest blood magicks: that which invoked your torpor, oh-so-long ago."
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = FULL_BODY
	icon_state = "vplate"
	item_state = "vplate"
	armor = ARMOR_VAMP
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	allowed_sex = list(MALE, FEMALE)
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/purifiedaalloy
	equip_delay_self = 40
	armor_class = ARMOR_CLASS_HEAVY
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/vampire
	name = "ancient ceremonial vestments"
	desc = "An ornate aketon, woven from crimson silk and worn beneath a layer of enchanted gilbranze maille. Vheslyn, Zizo, Kaine had all failed in their pursuits - yet, the ancient truths they left behind were more valuable than lyfe itself. It's time to show them all how a Lord truly gets it done."
	armor_class = ARMOR_CLASS_HEAVY
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	resistance_flags = FIRE_PROOF | ACID_PROOF
	smeltresult = /obj/item/ingot/purifiedaalloy

/obj/item/clothing/under/roguetown/platelegs/vampire
	name = "ancient ceremonial plate greaves"
	desc = "Enchanted gilbranze tassets, meticulously shingled over silk-lined chausses. Astrata tore open the sky, and Her light sundered all who had embraced your gift. They cried for your help - but you stood there, numb."
	gender = PLURAL
	icon_state = "vpants"
	item_state = "vpants"
	sewrepair = FALSE
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_LEG_ANTAG
	blocksound = PLATEHIT
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/purifiedaalloy
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/shoes/roguetown/boots/armor/vampire
	name = "ancient ceremonial sabatons"
	desc = "A set of enchanted gilbranze boots, tightly fastened with strips of niteleather. It was by your command that the families were left broken at your feet; and it was by your sword that even the righteous were forced to yield. Now, their descendants rally against you once more; let them know their place."
	body_parts_covered = FEET
	body_parts_inherent = FULL_BODY
	icon_state = "vboots"
	item_state = "vboots"
	max_integrity = ARMOR_INT_LEG_ANTAG
	color = null
	blocksound = PLATEHIT
	armor = ARMOR_VAMP
	resistance_flags = FIRE_PROOF | ACID_PROOF
	smeltresult = /obj/item/ingot/purifiedaalloy

/obj/item/clothing/gloves/roguetown/chain/vampire
	name = "ancient ceremonial gauntlets"
	icon_state = "Enchanted gilbranze fingerettes, meticulously forged to leave no motion unimpeded. In your pursuit of immortality, the viziers had discovered a forbidden alternative to apotheosis: one that promised eternal lyfe, yet not without a cost. Never before could you've imagined just how sweet the taste of blood might be."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon_state = "vgloves"
	item_state = "vgloves"
	armor = ARMOR_VAMP
	smeltresult = /obj/item/ingot/purifiedaalloy
	body_parts_inherent = FULL_BODY
	max_integrity = ARMOR_INT_SIDE_ANTAG

/obj/item/clothing/wrists/roguetown/bracers/paalloy/vampire
	name = "ancient ceremonial bracers"
	desc = "Enchanted gilbranze cuffings, clasped around the wrists. They call it a 'curse', but what would they know? What would they have in five hundred years? Would the oh-so-valiant heroes truly accept death, or would they see the pointlessness in besmirching eternal lyfe?"
	icon_state = "ancientbracers"
	smeltresult = /obj/item/ingot/purifiedaalloy
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_SIDE_ANTAG

/obj/item/clothing/neck/roguetown/gorget/paalloy/vampire
	name = "ancient ceremonial gorget"
	desc = "A neckguard of enchanted gilbranze. Though a vampyre needn't air to lyve, they most certainly need a spine."
	icon_state = "ancientgorget"
	smeltresult = /obj/item/ingot/purifiedaalloy
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_SIDE_ANTAG

/obj/item/clothing/head/roguetown/helmet/heavy/vampire
	name = "ancient ceremonial sayovard"
	desc = "A grand bascinet of enchanted gilbranze. They erased you from history, they destroyed your kingdom, and they plucked at its remains like vultures-to-carrion. Yet now, they cower in fear of your second coming; for they know that even the Pantheon cannot stop what is coming. </br>Send word - the end is nigh."
	icon_state = "vhelmet"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	body_parts_inherent = FULL_BODY
	block2add = FOV_BEHIND
	stack_fovs = FALSE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	smeltresult = /obj/item/ingot/purifiedaalloy
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
