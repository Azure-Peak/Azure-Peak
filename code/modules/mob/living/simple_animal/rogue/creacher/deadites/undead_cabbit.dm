/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/undead
	ai_controller = /datum/ai_controller/undead/cabbit
	faction = list(FACTION_UNDEAD)

	icon = 'icons/roguetown/mob/monster/deadites/cabbit_undead.dmi'
	name = "deadite cabbit"
	desc = "What is that?! Why is it moving so fast? It's going for the throat! It's going for the throat!!!."
	icon_state = "cabbit"
	icon_living = "cabbit"
	icon_dead = "cabbit_dead"
	health = CABBIT_HEALTH_UNDEAD
	maxHealth = CABBIT_HEALTH_UNDEAD
	head_butcher = /obj/item/natural/head/cabbit/undead

	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2, 
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1,
							/obj/item/natural/fur/rabbit = 1,
							/obj/item/natural/rabbitsfoot = 0,
							/obj/item/alch/viscera = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/meat_rotten = 3, 
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1,
							/obj/item/natural/fur/rabbit = 1,
							/obj/item/natural/rabbitsfoot = 1,
							/obj/item/alch/viscera = 2)

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/undead/simple_limb_hit(zone)
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

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/undead/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddComponent(/datum/component/deadite, 15 MINUTES, 30, 30, "cabbit_downed", 1)
