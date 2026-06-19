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
	set_species(/datum/species/human/northern)
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
	//random voice - no point for extensive features. They dust on death and are exclusive to quests.
	//Their gear is also nodrop, it won't be flung off.
	var/voice_choice = rand(1, 12)
	switch(voice_choice)
		if(1)
			src.voice_color = "0bb1e4"
		if(2)
			src.voice_color = "d30c0c"
		if(3)
			src.voice_color = "4d4afc"
		if(4)
			src.voice_color = "da40c0"
		if(5)
			src.voice_color = "51e251"
		if(6)
			src.voice_color = "a059cf"
		if(7)
			src.voice_color = "8700c5"
		if(8)
			src.voice_color = "cfc886"
		if(9)
			src.voice_color = "ff9100"
		if(10)
			src.voice_color = "a0a0a0"
		if(11)
			src.voice_color = "797979"
		if(12)
			src.voice_color = "ff5e00"

	gender = pick(MALE, FEMALE)
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

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight() //HUZZAR!!
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()
