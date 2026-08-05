/mob/living/simple_animal/hostile/retaliate/rogue/troll/undead
	// Icon credit openkeep troll, edited by Ketrai for undeath
	icon = 'icons/roguetown/mob/monster/deadites/troll_undead.dmi'
	name = "deadite troll"
	desc = "The toil continues in undeath. Hulking muscles and old wounds cast a long shadow, it looks tortured... And salivating crimson spittle at the opportunity to make you experience the same fate."
	icon_state = "troll"
	icon_living = "troll"
	icon_dead = "troll_dead"
	pixel_x = -16
	health = TROLL_HEALTH_UNDEAD
	maxHealth = TROLL_HEALTH_UNDEAD
	ai_controller = /datum/ai_controller/undead_troll

	head_butcher = /obj/item/natural/head/troll/undead
	// Troll flesh is unnatural and doesn't rot easily
	botched_butcher_results = list (
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll = 2,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll/fried = 1,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/horn = 1, 
		/obj/item/natural/hide = 1)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll = 2,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll/fried = 2,
		/obj/item/natural/hide = 2,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 4,
		/obj/item/alch/horn = 2,
		/obj/item/alch/viscera = 3,
		)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll = 3,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll/fried = 3,
		/obj/item/natural/hide = 3,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 5,
		/obj/item/alch/horn = 2,
		/obj/item/alch/viscera = 3,
		)

/mob/living/simple_animal/hostile/retaliate/rogue/troll/undead/Initialize()
	. = ..()
	AddComponent(/datum/component/deadite, 15 MINUTES, 300, 200, "troll_downed", 0)

/mob/living/simple_animal/hostile/retaliate/rogue/troll/undead/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND)
			return "r_leg"
		if(BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND)
			return "l_leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
	return ..()
