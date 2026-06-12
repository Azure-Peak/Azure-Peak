GLOBAL_LIST_INIT(duelist_aggro, list(
	"En garde!",
	"You'll need to be faster than that.",
	"Dance with me!",
	"Too slow!",
	"I've killed better than you.",
	"Come, let us settle this.",
	"Your form is sloppy.",
	"Lets dance!",
	"A dance wit' lyfe and death!",
	"Slow! Pitiful!",
	"Faster, faster!",
	"*laugh",
	"*sigh",
	"*groan",
	"*nod",
	"Way ahead of you!",
	"No no, please miss more. It makes bleeding you easier.",
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
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/npc/mini_boss/duelist)
	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)
	update_hair()
	update_body()
	def_intent_change(INTENT_DODGE)
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
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	r_hand = /obj/item/rogueweapon/sword/long
	l_hand = /obj/item/rogueweapon/shield/buckler
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)

	H.dna.species.soundpack_m = new /datum/voicepack/male/evil() //Its a dodge build w/battleready sire, I know what had to be done.
	H.dna.species.soundpack_f = new /datum/voicepack/female/haughty()
