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
		"I AM THE ETERNAL!",
		"I AM THE INHERITOR!",
		"I WILL NOT BE FORGOTTEN!",
	)
	show_in_roundend = TRUE
	var/ascended = FALSE
	max_thralls = 69

/datum/antagonist/vampire/lord/get_antag_cap_weight()
	return 3

/datum/antagonist/vampire/lord/on_gain()
	. = ..()
	addtimer(CALLBACK(owner.current, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "[name]"), 5 SECONDS)

	greet()

	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)
	for(var/datum/mind/MF in get_minds("Vampire Spawn"))
		owner.i_know_person(MF)
		owner.person_knows_me(MF)

	var/mob/living/carbon/human/H = owner.current
	for(var/datum/charflaw/cf in H.charflaws)
		if(istype(cf, /datum/charflaw/hunted) || istype(cf, /datum/charflaw/targeted))
			H.charflaws.Remove(cf)
			QDEL_NULL(cf)
	H.equipOutfit(/datum/outfit/job/vamplord)
	H.set_patron(/datum/patron/inhumen/zizo)
	add_verb(H, /mob/living/carbon/human/proc/demand_submission)
	H.maxbloodpool += 3000
	H.adjust_bloodpool(3000)
	for(var/S in MOBSTATS)
		H.change_stat(S, 2)
	H.forceMove(pick(GLOB.vlord_starts))
	ADD_TRAIT(H, TRAIT_DUSTABLE, TRAIT_GENERIC) //They are ancient walking calamities, no take backs.
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC) //Brute-forced method to ensure that Vampire Lords, no matter what, receive their most important traits.
	ADD_TRAIT(H, TRAIT_ARMOR_NOSPDCAP, TRAIT_GENERIC) //Their armor never weighs on their stride.
	ADD_TRAIT(H, TRAIT_INFINITE_ENERGY, TRAIT_GENERIC) //Playing it safe, with the assumption that Vampire Lords already inherit any traits given to regular Vampires.
	ADD_TRAIT(H, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC) //Heavy-Antag Role, lets you repair your armor with tools + level to journeyman.
	ADD_TRAIT(H, TRAIT_NOMOOD, TRAIT_GENERIC) //Stops you getting moodnuked and dropping your weapon non-stop. I didn't want to have to give them this off-the-bat but after seeing this happen, yeaaaah.
	H.update_move_intent_slowdown()

/datum/antagonist/vampire/lord/greet()
	to_chat(owner.current, span_userdanger("I am ancient. I am the Land. And I am now awoken to trespassers upon my domain."))
	to_chat(owner.current, span_boldwarning("I should check my immedate surroundings, from the bloodstained stone I can recall my Ichor fang at will should I lose it again and from the Crimson Crucible I can begin my various projects of collective sacrifice of vitae between myself and my servants to reclaim my long-lost power and kingdom."))
	owner.current.playsound_local(get_turf(owner.current), 'sound/villain/dreamer_warning.ogg', 80, FALSE, pressure_affected = FALSE) //Extra bit of AURA
	. = ..()

/datum/outfit/job/vamplord/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank_up_to(/datum/skill/magic/blood, 6, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE) //Returned to Legendary-tier, but its the only weapon you get at this level, since Halford's new Blood Magic system compensates a lot for this.
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 5, TRUE) //Equalized all combat skills to be Master-tier, otherwise. Unless you somehow get legendary via-other means. You used to just get legendary in everything cause this added to your class, not skill upto'd.
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/axes, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/riding, 4, TRUE) //Journeyman, lets them at least travel like a noble lord.
	H.adjust_skillrank_up_to(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 6, TRUE) //Who said Progress can't have gains?

	pants = /obj/item/clothing/under/roguetown/tights/puritan
	shirt = /obj/item/clothing/suit/roguetown/shirt/vampire
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	id = /obj/item/clothing/ring/rubybs //Blacksteel and Rontz, fits a lorde, very well.
	beltr = /obj/item/storage/belt/rogue/pouch/coins/veryrich //Intended they have two now.
	beltl = /obj/item/rogueweapon/scabbard/sheath/royal
	head = /obj/item/clothing/head/roguetown/vampire
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	cloak = /obj/item/clothing/cloak/cape/puritan
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	backl = /obj/item/storage/backpack/rogue/satchel/black
	l_hand = /obj/item/rogueweapon/sword/long/judgement/vlord
	H.ambushable = FALSE
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1, //Intended they have two now, its a bad solution but it means they don't become poorer than an adv/miner towner midgame as easily as before.
		/obj/item/rope/chain = 1, //Needed so you can actually sire people, beforehand you had to get rope every round. This speeds things up.
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/roguekey/vampire = 1 //Softlock protection, otherwise I'd have removed it. You still spawn in a room with keys anyway soo...
		)
/*------VERBS-----*/

// NEW VERBS
/mob/living/carbon/human/proc/demand_submission()
	set name = "Demand Submission"
	set category = "RoleUnique.Vampire"
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
	set category = "RoleUnique.Vampire"

	if(!clan_position)
		to_chat(src, span_warning("You have no subordinates to punish."))
		return

	var/list/possible = list()
	for(var/datum/clan_hierarchy_node/subordinate in clan_position.get_all_subordinates())
		var/mob/living/carbon/human/member = subordinate.assigned_member
		if(!member || QDELETED(member))
			continue
		possible[member.real_name] = member
	if(!length(possible))
		to_chat(src, span_warning("You have no subordinates to punish."))
		return
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
	body_parts_covered = COVERAGE_ALL_BUT_ARMFEET
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

/obj/item/clothing/head/roguetown/vampire/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 180, "size" = 1)) //AURAFARMING BUFF

/obj/item/clothing/head/roguetown/vampire/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE_CROWN)

////////BROKEN////////
/obj/item/clothing/suit/roguetown/armor/chainmail/iron/vampire
	name = "regal maille"
	desc = "An ornate aketon, woven from crimson silk and worn beneath a layer of enchanted gilbranze maille. Vheslyn and Zizo had both failed in their pursuits - yet, the ancient truths they left behind were more valuable than lyfe itself. It's time to show them all how a Lord truly gets it done."
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
	smeltresult = /obj/item/ingot/vampire
	unenchantable = TRUE //Its pretty much near-perfect protection, you do not need this.

/obj/item/clothing/suit/roguetown/armor/chainmail/iron/vampire/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 180, "size" = 1)) //Enchanted look.

/obj/item/clothing/suit/roguetown/armor/chainmail/iron/vampire/get_examine_highlight_status() //best armor in the game, it shouldn't be worn lightly
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

////////VAMPYRELORD-EXCLUSIVE ARMORSET////////
/obj/item/clothing/suit/roguetown/armor/plate/vampire
	slot_flags = ITEM_SLOT_ARMOR
	name = "ancient ceremonial plate"
	desc = "Enchanted gilbranze armor, bearing the heraldry of a fallen kingdom. Upon the cuirass remains a singular puncture, unable to be fully mended by even the finest blood magicks: that which invoked your torpor, oh-so-long ago."
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	body_parts_inherent = FULL_BODY
	icon_state = "vplate"
	item_state = "vplate"
	armor = ARMOR_VAMP
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	allowed_sex = list(MALE, FEMALE)
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/vampire
	equip_delay_self = 40
	armor_class = ARMOR_CLASS_HEAVY
	resistance_flags = FIRE_PROOF | ACID_PROOF
	unenchantable = TRUE //Its pretty much near-perfect protection, you do not need this.

/obj/item/clothing/suit/roguetown/armor/plate/vampire/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 180, "size" = 1)) //Enchanted look.

/obj/item/clothing/suit/roguetown/armor/plate/vampire/get_examine_highlight_status() //best armor in the game, it shouldn't be worn lightly
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/vampire
	name = "ancient ceremonial vestments"
	desc = "An ornate aketon, woven from crimson silk and worn beneath a layer of enchanted gilbranze maille. Vheslyn, and Zizo had both failed in their pursuits - yet, the ancient truths they left behind were more valuable than lyfe itself. It's time to show them all how a Lord truly gets it done."
	icon_state = "vhauberk"
	item_state = "vhauberk"
	armor_class = ARMOR_CLASS_HEAVY
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	resistance_flags = FIRE_PROOF | ACID_PROOF
	smeltresult = /obj/item/ingot/vampire
	unenchantable = TRUE //Its pretty much near-perfect protection, you do not need this.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/vampire/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 180, "size" = 1)) //Enchanted look.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/vampire/get_examine_highlight_status() //best armor in the game, it shouldn't be worn lightly
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

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
	smeltresult = /obj/item/ingot/vampire
	resistance_flags = FIRE_PROOF | ACID_PROOF
	unenchantable = TRUE //Its pretty much near-perfect protection, you do not need this.

/obj/item/clothing/under/roguetown/platelegs/vampire/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 180, "size" = 1)) //Enchanted look.

/obj/item/clothing/under/roguetown/platelegs/vampire/get_examine_highlight_status() //best armor in the game, it shouldn't be worn lightly
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

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
	smeltresult = /obj/item/ingot/vampire
	unenchantable = TRUE //Its pretty much near-perfect protection, you do not need this.

/obj/item/clothing/shoes/roguetown/boots/armor/vampire/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 180, "size" = 1)) //Enchanted look.

/obj/item/clothing/shoes/roguetown/boots/armor/vampire/get_examine_highlight_status() //best armor in the game, it shouldn't be worn lightly
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/gloves/roguetown/chain/vampire
	name = "ancient ceremonial gauntlets"
	icon_state = "Enchanted gilbranze fingerettes, meticulously forged to leave no motion unimpeded. In your pursuit of immortality, the viziers had discovered a forbidden alternative to apotheosis: one that promised eternal lyfe, yet not without a cost. Never before could you've imagined just how sweet the taste of blood might be."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon_state = "vgloves"
	item_state = "vgloves"
	armor = ARMOR_VAMP
	smeltresult = /obj/item/ingot/vampire
	body_parts_inherent = FULL_BODY
	max_integrity = ARMOR_INT_SIDE_ANTAG
	unenchantable = TRUE //Its pretty much near-perfect protection, you do not need this.
	throw_on_break = FALSE //We only get one set

/obj/item/clothing/gloves/roguetown/chain/vampire/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 180, "size" = 1)) //Enchanted look.

/obj/item/clothing/gloves/roguetown/chain/vampire/get_examine_highlight_status() //best armor in the game, it shouldn't be worn lightly
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/wrists/roguetown/bracers/paalloy/vampire
	name = "ancient ceremonial bracers"
	desc = "Enchanted gilbranze cuffings, clasped around the wrists. They call it a 'curse', but what would they know? What would they have in five hundred years? Would the oh-so-valiant heroes truly accept death, or would they see the pointlessness in besmirching eternal lyfe?"
	icon_state = "vbracers"
	smeltresult = /obj/item/ingot/vampire
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_SIDE_ANTAG
	unenchantable = TRUE //Its pretty much near-perfect protection, you do not need this.
	throw_on_break = FALSE //We only get one set.

/obj/item/clothing/wrists/roguetown/bracers/paalloy/vampire/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 180, "size" = 1)) //Enchanted look.

/obj/item/clothing/wrists/roguetown/bracers/paalloy/get_examine_highlight_status() //best armor in the game, it shouldn't be worn lightly
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/neck/roguetown/gorget/paalloy/vampire
	name = "ancient ceremonial gorget"
	desc = "A neckguard of enchanted gilbranze. Though a vampyre needn't air to lyve, they most certainly need a spine."
	icon_state = "vgorget"
	smeltresult = /obj/item/ingot/vampire
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_SIDE_ANTAG
	unenchantable = TRUE //Its pretty much near-perfect protection, you do not need this.
	throw_on_break = FALSE //We only get one set.

/obj/item/clothing/neck/roguetown/gorget/paalloy/vampire/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 180, "size" = 1)) //Enchanted look.

/obj/item/clothing/neck/roguetown/gorget/paalloy/vampire/get_examine_highlight_status() //best armor in the game, it shouldn't be worn lightly
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/head/roguetown/helmet/heavy/vampire
	name = "ancient ceremonial sayovard"
	desc = "A grand bascinet of enchanted gilbranze. They erased you from history, they destroyed your kingdom, and they plucked at its remains like vultures-to-carrion. Yet now, they cower in fear of your second coming; for they know that even the Pantheon cannot stop what is coming. </br>Send word - the end is nigh."
	icon_state = "vhelmet"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	armor = ARMOR_VAMP
	body_parts_inherent = FULL_BODY
	block2add = FOV_BEHIND
	stack_fovs = FALSE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	smeltresult = /obj/item/ingot/vampire
	var/active_item = FALSE
	unenchantable = TRUE //Its pretty much near-perfect protection, you do not need this.
	throw_on_break = FALSE //We only get one set.

/obj/item/clothing/head/roguetown/helmet/heavy/vampire/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 180, "size" = 1)) //Enchanted look.

/obj/item/clothing/head/roguetown/helmet/heavy/vampire/get_examine_highlight_status() //best armor in the game, it shouldn't be worn lightly
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/head/roguetown/helmet/heavy/vampire/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_HEAD)
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)
		to_chat(user, span_red("The bascinet's visor chitters, and your jaw tightens with symbiotic intent.."))

/obj/item/clothing/head/roguetown/helmet/heavy/vampire/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	REMOVE_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)
	to_chat(user, span_red("..and like that, the bascinet's visor goes dormant once more - a strange pressure, relieved from your jaw."))
