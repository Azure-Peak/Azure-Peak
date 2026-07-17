/datum/status_effect/buff/clash/test_dummy
	duration = 30 SECONDS

/mob/living/carbon/human/species/human/northern/guard_dummy
	name = "guard dummy"
	real_name = "Guard Dummy"
	faction = list(FACTION_STATION)
	ambushable = FALSE
	a_intent = INTENT_HARM
	d_intent = INTENT_PARRY

/mob/living/carbon/human/species/human/northern/guard_dummy/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/guard_dummy/after_creation()
	..()
	job = "Guard Dummy"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/guard_dummy)
	adjust_skillrank(/datum/skill/combat/swords, 6, TRUE)
	adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
	cmode = TRUE
	apply_status_effect(/datum/status_effect/buff/clash/test_dummy)

/datum/outfit/job/roguetown/guard_dummy/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/boots
	r_hand = /obj/item/rogueweapon/sword
