GLOBAL_LIST_INIT(duelist_aggro, list(
	"En garde!",
	"You'll need to be faster than that.",
	"Dance with me!",
	"Too slow!",
	"I've killed better than you.",
	"Come, let us settle this.",
	"Your form is sloppy.",
	"A shame. I expected more.",
))

/mob/living/carbon/human/species/human/northern/outlaw_duelist
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_DUNDEAD)
	ambushable = FALSE
	dodgetime = 20
	d_intent = INTENT_DODGE
	threat_point = THREAT_ELITE

/mob/living/carbon/human/species/human/northern/outlaw_duelist/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/outlaw_duelist/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.duelist_aggro, TRUE)
	name = pick("the Duelist", "the Fencer", "the Blade", "the Swift", "the Unmatched")
	real_name = name
	job = "Outlaw"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/npc/mini_boss/duelist)
	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)
	update_hair()
	update_body()
	def_intent_change(INTENT_DODGE)
	AddComponent(/datum/component/npc_death_line)

/mob/living/carbon/human/species/human/northern/outlaw_duelist/death(gibbed, nocutscene = FALSE)
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/datum/outfit/job/roguetown/npc/mini_boss/duelist/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 13
	H.STASPD = 16
	H.STACON = 12
	H.STAWIL = 12
	H.STAPER = 14
	H.STAINT = 13
	H.STALUC = 12
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	gloves = /obj/item/clothing/gloves/roguetown/leather
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron
	neck = /obj/item/clothing/neck/roguetown/gorget
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	r_hand = /obj/item/rogueweapon/sword/long
	l_hand = /obj/item/rogueweapon/shield/buckler
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
