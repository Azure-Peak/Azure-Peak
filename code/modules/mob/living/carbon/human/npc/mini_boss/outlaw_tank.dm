GLOBAL_LIST_INIT(tank_aggro, list(
	"You cannot break me.",
	"Hit harder. I dare you.",
	"Is that all?",
	"I am the wall.",
	"Give up! You won't break me.",
	"You won't break me, I'll break YOU!",
	"I'm fucking invincible!",
	"Your blows mean nothing.",
	"Come. Shatter yourself upon me.",
	"I have endured worse.",
	"You will tire before I fall.",
	"*laugh",
	"*chuckle",
	"*grumble",
))

/mob/living/carbon/human/species/human/northern/outlaw_tank
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_DUNDEAD)
	ambushable = FALSE
	dodgetime = 40
	d_intent = INTENT_PARRY
	threat_point = THREAT_ELITE

/mob/living/carbon/human/species/human/northern/outlaw_tank/Initialize()
	. = ..()
	//Begin RANDOMISE here
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/outlaw_tank/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.tank_aggro, TRUE)
	name = pick("the Bulwark", "the Immovable", "the Shieldwall", "the Ironclad", "the Unbreakable")
	real_name = name
	job = "Outlaw"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/npc/mini_boss/tank)
	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)
	update_hair()
	update_body()
	def_intent_change(INTENT_PARRY)
	AddComponent(/datum/component/npc_death_line)
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()
	dna.species.handle_body(src)
	src.regenerate_icons() //Fixes the weird body with random genders for NPCs.

/mob/living/carbon/human/species/human/northern/outlaw_tank/death(gibbed, nocutscene = FALSE)
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/datum/outfit/job/roguetown/npc/mini_boss/tank/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 15
	H.STASPD = 10
	H.STACON = 15
	H.STAWIL = 14
	H.STAPER = 12
	H.STAINT = 12
	H.STALUC = 10
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	r_hand = /obj/item/rogueweapon/mace/steel
	l_hand = /obj/item/rogueweapon/shield/tower
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)

	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/knight] //HUZZAR!!
	H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
