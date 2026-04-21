GLOBAL_LIST_INIT(large_goblin_aggro, list(
	"ME BIGGEST GOBLIN!",
	"CRUSH TINY HUMAN!",
	"YOU SMALL! ME BIG!",
	"GOBLIN KING SEND ME!",
	"HAHA! YOU SCARED!",
	"ME SMASH!",
	"BIG GOBLIN EAT YOU!",
	"NO RUN! COME BACK!",
	"ME NOT LIKE OTHER GOBLIN! ME BETTER!",
	"WHY YOU HIT ME?! NOW ME HIT YOU HARDER!",
))

/mob/living/carbon/human/species/goblin/npc/large
	name = "unusually large goblin"
	gob_outfit = /datum/outfit/job/roguetown/npc/mini_boss/large_goblin
	faction = list(FACTION_DUNDEAD, FACTION_ORCS)
	dodgetime = 20
	d_intent = INTENT_PARRY

/mob/living/carbon/human/species/goblin/npc/large/after_creation()
	..()
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.large_goblin_aggro, TRUE)
	name = pick("Big Grug", "Massive Gronk", "Huge Blort", "Giant Snik", "Enormous Gak", "Colossal Muk")
	real_name = name
	ADD_TRAIT(src, TRAIT_BIGGUY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	src.transform = src.transform.Scale(1.25, 1.25)
	src.pixel_y += round(0.25 * 16)
	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)

/mob/living/carbon/human/species/goblin/npc/large/death(gibbed, nocutscene = FALSE)
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/datum/outfit/job/roguetown/npc/mini_boss/large_goblin/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 16
	H.STASPD = 12
	H.STACON = 20
	H.STAWIL = 12
	H.STAPER = 6
	H.STAINT = 8 // I am Evil
	H.STALUC = 4
	var/loadout = rand(1, 4)
	switch(loadout)
		if(1) // mace brute
			r_hand = /obj/item/rogueweapon/mace
			l_hand = /obj/item/rogueweapon/shield/wood
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
			head = /obj/item/clothing/head/roguetown/helmet/leather/goblin
		if(2) // greataxe berserker
			r_hand = /obj/item/rogueweapon/greataxe/militia
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
			head = /obj/item/clothing/head/roguetown/helmet/leather/goblin
		if(3) // flail and shield
			r_hand = /obj/item/rogueweapon/flail
			l_hand = /obj/item/rogueweapon/shield/wood
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
			head = /obj/item/clothing/head/roguetown/helmet/leather/goblin
		if(4) // bottle bomber
			r_hand = /obj/item/rogueweapon/mace
			neck = /obj/item/storage/belt/rogue/pouch/bombs
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
			head = /obj/item/clothing/head/roguetown/helmet/leather/goblin
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
