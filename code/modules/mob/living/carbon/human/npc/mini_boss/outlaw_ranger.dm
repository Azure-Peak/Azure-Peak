GLOBAL_LIST_INIT(ranger_aggro, list(
	"Hold still.",
	"You won't outrun my arrows.",
	"I see you.",
	"Nowhere to hide.",
	"One shot is all I need.",
	"Stay back if you value your life.",
	"I don't miss.",
	"That was a warning shot.",
))

/mob/living/carbon/human/species/human/northern/outlaw_ranger
	ai_controller = /datum/ai_controller/human_npc/archer
	faction = list(FACTION_DUNDEAD)
	ambushable = FALSE
	dodgetime = 25
	d_intent = INTENT_DODGE
	threat_point = THREAT_ELITE

/mob/living/carbon/human/species/human/northern/outlaw_ranger/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/outlaw_ranger/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.ranger_aggro, TRUE)
	name = pick("the Marksman", "the Bowman", "the Deadeye", "the Hunter", "the Sharpshooter")
	real_name = name
	job = "Outlaw"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/npc/mini_boss/ranger)
	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)
	update_hair()
	update_body()
	AddComponent(/datum/component/npc_death_line)

/mob/living/carbon/human/species/human/northern/outlaw_ranger/death(gibbed, nocutscene = FALSE)
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/datum/outfit/job/roguetown/npc/mini_boss/ranger/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 13
	H.STASPD = 14
	H.STACON = 12
	H.STAWIL = 12
	H.STAPER = 16
	H.STAINT = 12
	H.STALUC = 12
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	neck = /obj/item/clothing/neck/roguetown/gorget
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	r_hand = /obj/item/rogueweapon/sword/short/iron
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	backl = /obj/item/quiver/bodkin
	H.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
