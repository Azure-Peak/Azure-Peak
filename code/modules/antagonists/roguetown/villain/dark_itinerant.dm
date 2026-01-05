/datum/antagonist/zizo_knight
	name = "Dark Itinerant Knight"
	roundend_category = "Dark Itinerant Knight"
	antagpanel_category = "Dark Itinerant Knight"
	job_rank = ROLE_DARK_ITINERANT
	confess_lines = list(
		"ZIZO! ZIZO! ZIZO!",
		"FOR THE PALE LADY!",
	)
	rogue_enabled = TRUE
	var/outfit_path = /datum/outfit/job/dark_itinerant_knight

/datum/antagonist/zizo_knight/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return

	H.set_patron(/datum/patron/inhumen/zizo)
	H.cmode_music = 'sound/music/combat_heretic.ogg'
	H.faction = list("undead")
	to_chat(owner, span_danger("I'm a servant to the ALMIGHTY. They call it the UNSPEAKABLE. I SHALL WRECK HAVOK and SURVIVE."))
	H.equipOutfit(outfit_path)

/datum/antagonist/zizo_knight/squire
	name = "Dark Itinerant Squire"
	roundend_category = "Dark Itinerant Squire"
	antagpanel_category = "Dark Itinerant Squire"
	outfit_path = /datum/outfit/job/dark_itinerant_squire

/datum/outfit/job/dark_itinerant_squire/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	backr = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	r_hand = /obj/item/rogueweapon/spear
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/hammer/iron = 1, 
		/obj/item/rogueweapon/tongs = 1, 
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
		/obj/item/repair_kit/metal = 1,
		/obj/item/repair_kit = 1,
	)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE)

		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_WIL, 1)
		H.change_stat(STATKEY_SPD, 1) // 9 weighted

		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mindlink)

	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in list("Crossbow", "Bow", "Sling")
	var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in list("Light Armor", "Medium Armor")
	H.set_blindness(0)
	switch(weapon_choice)
		if("Crossbow")
			beltr = /obj/item/quiver/bolts
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
		if("Bow")
			beltr = /obj/item/quiver/bodkin
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
		if("Sling")
			beltr = /obj/item/quiver/sling/iron
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling 

	switch(armor_choice)
		if("Light Armor")
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
			armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Medium Armor")
			pants = /obj/item/clothing/under/roguetown/chainlegs
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.cmode_music = 'sound/music/combat_heretic.ogg'
	ADD_TRAIT(H, TRAIT_SQUIRE_REPAIR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	wretch_select_bounty(H)

/datum/outfit/job/dark_itinerant_knight/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	shoes = /obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	beltr = /obj/item/rogueweapon/scabbard/sword
	backr = /obj/item/storage/backpack/rogue/satchel
	l_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/ritechalk = 1,
	)

	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
		H.change_stat(STATKEY_STR, 2)
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_INT, 3)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_WIL, 2) 
		H.change_stat(STATKEY_SPD, -1) // 11 weighted
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mindlink)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/zizosquire)

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/combat_heretic.ogg'
	wretch_select_bounty(H)

/obj/effect/proc_holder/spell/self/convertrole/zizosquire
	name = "Recruit Squire"
	new_role = "Retainer"
	overlay_state = "recruit_guard"
	recruitment_faction = "Retainers"
	recruitment_message = "Join my service as a retainer, %RECRUIT!"
	accept_message = "I pledge my service to you!"
	refuse_message = "I must decline your offer."

/obj/effect/proc_holder/spell/self/convertrole/zizosquire/can_convert(mob/living/carbon/human/recruit)
	if(QDELETED(recruit))
		return FALSE
	if(!(locate(/datum/antagonist/zizo_knight/squire) in recruit?.mind?.antag_datums))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/zizosquire/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(QDELETED(recruit) || QDELETED(recruiter))
		return FALSE

	var/datum/antagonist/zizo_knight/zk_antag = locate(/datum/antagonist/zizo_knight) in recruiter.mind?.antag_datums
	var/datum/antagonist/zizo_knight/squire/zs_antag = locate(/datum/antagonist/zizo_knight/squire) in recruit.mind?.antag_datums

	var/datum/objective/dark_itinerant/zizotrain = new /datum/objective/dark_itinerant(null, recruiter.mind)
	var/datum/objective/dark_itinerant/zizoserve = new /datum/objective/dark_itinerant/squire(null, recruit.mind)

	zizotrain.target = recruit.mind
	zizotrain.explanation_text = "Train your squire [recruit.real_name] in the field. Show them the ropes. Ensure they survive."
	zk_antag.objectives += zizotrain
	zizoserve.target = recruiter.mind
	zizoserve.explanation_text =  "Serve faithfully to your knight [recruiter.real_name], heed their commands and help them."
	zs_antag.objectives += zizoserve
	recruit.mind.announce_objectives()
	recruiter.mind.announce_objectives()

	. = ..()
	if(!.)
		return FALSE

	qdel(src)

/datum/objective/dark_itinerant
	name = "Train your squire"
	explanation_text = "Train your squire in the field. Show them the ropes. Ensure they survive."
	triumph_count = 5

/datum/objective/dark_itinerant/check_completion()
	return !target || considered_alive(target, enforce_human = TRUE)

/datum/objective/dark_itinerant/squire
	name = "Serve your Knight"
	explanation_text = "Serve faithfully to your knight, heed their commands and help them."
	triumph_count = 5
