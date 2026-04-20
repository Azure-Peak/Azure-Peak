/* *
 * Deranged Knight
 * A miniboss for quest system, designed to be a high-level challenge for multiple players.
 * Gear uses /datum/component/item_on_drop/dust to crumble on removal, preventing looting.
 */

GLOBAL_LIST_INIT(matthios_aggro, world.file2list("strings/rt/matthiosaggrolines.txt"))
GLOBAL_LIST_INIT(zizo_aggro, world.file2list("strings/rt/zizoaggrolines.txt"))
GLOBAL_LIST_INIT(graggar_aggro, world.file2list("strings/rt/graggaraggrolines.txt"))
GLOBAL_LIST_INIT(hedgeknight_aggro, world.file2list("strings/rt/hedgeknightaggrolines.txt"))

/mob/living/carbon/human/species/human/northern/deranged_knight
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_DUNDEAD)
	ambushable = FALSE
	dodgetime = 30
	var/preset = "matthios"
	var/forced_preset = "" // If set, force a specific preset instead of randomizing.



/mob/living/carbon/human/species/human/northern/deranged_knight/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/deranged_knight/proc/outfit_dk(datum/outfit/outfit)
	if(!outfit)
		return
	equipOutfit(outfit)
	// Apply dust-on-drop to all equipped gear so it can't be looted via dismemberment or stripping.
	// TRAIT_NODROP on held items prevents grab disarming.
	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)

/mob/living/carbon/human/species/human/northern/deranged_knight/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Ascendant Knight"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	if(forced_preset)
		preset = forced_preset
	else
		switch(rand(1, 4))
			if(1)
				preset = "graggar"
			if(2)
				preset = "matthios"
			if(3)
				preset = "zizo"
			if(4)
				preset = "hedgeknight"
	switch(preset)
		if("graggar")
			ADD_TRAIT(src, TRAIT_HORDE, TRAIT_GENERIC)
			outfit_dk(new /datum/outfit/job/roguetown/quest_miniboss/graggar)
		if ("matthios")
			ADD_TRAIT(src, TRAIT_FREEMAN, TRAIT_GENERIC)
			outfit_dk(new /datum/outfit/job/roguetown/quest_miniboss/matthios)
		if ("zizo")
			ADD_TRAIT(src, TRAIT_CABAL, TRAIT_GENERIC)
			outfit_dk(new /datum/outfit/job/roguetown/quest_miniboss/zizo)
		if ("hedgeknight")
			if(prob(50))
				outfit_dk(new /datum/outfit/job/roguetown/quest_miniboss/hedge_knight)
			else
				outfit_dk(new /datum/outfit/job/roguetown/quest_miniboss/blacksteel)
			// No special trait for hedgeknight, he's just a generic tough guy.

	var/list/aggro_lines
	switch(preset)
		if("graggar")
			aggro_lines = GLOB.graggar_aggro
		if("matthios")
			aggro_lines = GLOB.matthios_aggro
		if("zizo")
			aggro_lines = GLOB.zizo_aggro
		if("hedgeknight")
			aggro_lines = GLOB.hedgeknight_aggro
	if(aggro_lines)
		SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, aggro_lines, TRUE)

	gender = pick(MALE,FEMALE)
	regenerate_icons()

	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/himecut,
						/datum/sprite_accessory/hair/head/countryponytailalt,
						/datum/sprite_accessory/hair/head/stacy,
						/datum/sprite_accessory/hair/head/kusanagi_alt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/dave,
						/datum/sprite_accessory/hair/head/emo,
						/datum/sprite_accessory/hair/head/sabitsuki,
						/datum/sprite_accessory/hair/head/sabitsuki_ponytail))

	var/datum/bodypart_feature/hair/head/new_hair = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)

	new_hair.accessory_colors = "#DDDDDD"
	new_hair.hair_color = "#DDDDDD"
	hair_color = "#DDDDDD"

	head.add_bodypart_feature(new_hair)

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#FFBF00"
		organ_eyes.accessory_colors = "#FFBF00#FFBF00"

	if(organ_ears)
		organ_ears.accessory_colors = "#5f5f70"

	skin_tone = "5f5f70"

	if(prob(1))
		real_name = "Taras Mura"
	update_hair()
	update_body()

	def_intent_change(INTENT_PARRY)


/mob/living/carbon/human/species/human/northern/deranged_knight/death(gibbed, nocutscene)
	if(preset == "matthios")
		if(prob(95))
			say("Matthios, I have failed you...", forced = TRUE, npc_speech = TRUE)
		else
			say("Matthios, is this true?!", forced = TRUE, npc_speech = TRUE)
	else if(preset == "zizo")
		say("Zizo, forgive me!", forced = TRUE, npc_speech = TRUE)
	else if(preset == "graggar")
		say("No more... Blood!", npc_speech = TRUE)
	emote("painscream")
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/datum/outfit/job/roguetown/quest_miniboss/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.STASTR = 15
	H.STASPD = 14
	H.STACON = 12
	H.STAWIL = 12
	H.STAPER = 12
	H.STAINT = 12
	H.STALUC = 10

	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/datum/outfit/job/roguetown/quest_miniboss/matthios/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/matthios
	pants = /obj/item/clothing/under/roguetown/platelegs/matthios
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/matthios
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/matthios
	head = /obj/item/clothing/head/roguetown/helmet/heavy/matthios
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/flail/peasantwarflail/matthios
	mask = /obj/item/clothing/mask/rogue/facemask/steel

/datum/outfit/job/roguetown/quest_miniboss/zizo/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
	pants = /obj/item/clothing/under/roguetown/platelegs/zizo
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/zizo
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/zizo
	head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/sword/long/zizo
	mask = /obj/item/clothing/mask/rogue/facemask/steel

/datum/outfit/job/roguetown/quest_miniboss/graggar/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
	pants = /obj/item/clothing/under/roguetown/platelegs/graggar
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/graggar
	gloves = /obj/item/clothing/gloves/roguetown/plate/graggar
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	head = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead/graggar
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	cloak = /obj/item/clothing/cloak/graggar

/datum/outfit/job/roguetown/quest_miniboss/blacksteel/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	gloves = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	head = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/greatsword
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	wrists = /obj/item/clothing/wrists/roguetown/bracers

/datum/outfit/job/roguetown/quest_miniboss/hedge_knight/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	pants = /obj/item/clothing/under/roguetown/platelegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	gloves = /obj/item/clothing/gloves/roguetown/plate
	head = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/greatsword/grenz
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/sword/long
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	cloak = /obj/item/clothing/cloak/tabard/stabard/black

/*
 * Goon preset
 * Intended to support knight, but should not have any special/overly expensive gear.
*/

/mob/living/carbon/human/species/human/northern/highwayman/dk_goon
	faction = list(FACTION_DUNDEAD)

/mob/living/carbon/human/species/human/northern/deranged_knight/matthios
	forced_preset = "matthios"

/mob/living/carbon/human/species/human/northern/deranged_knight/zizo
	forced_preset = "zizo"

/mob/living/carbon/human/species/human/northern/deranged_knight/graggar
	forced_preset = "graggar"

/mob/living/carbon/human/species/human/northern/deranged_knight/hedgeknight
	forced_preset = "hedgeknight"
