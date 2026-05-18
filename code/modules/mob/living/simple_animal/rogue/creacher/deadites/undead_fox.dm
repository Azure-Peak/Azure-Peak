/mob/living/simple_animal/hostile/retaliate/rogue/fox/undead
	icon = 'icons/roguetown/mob/monster/deadites/fox_undead.dmi'
	name = "deadite venard"
	desc = "Once majestic, its gait is nowhere near as springy. At least, until it notices a piece of fresh meat."
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	health = FOX_HEALTH_UNDEAD
	maxHealth = FOX_HEALTH_UNDEAD
	ai_controller = /datum/ai_controller/undead/fox
	head_butcher = /obj/item/natural/head/fox/undead
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 1, /obj/item/alch/viscera = 1, /obj/item/natural/bone = 3)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2,
						/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/fox = 1,
						/obj/item/natural/bone = 4)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2,
						/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 2,
						/obj/item/alch/viscera = 2,
						/obj/item/natural/fur/fox = 1,
						/obj/item/natural/bone = 4)

/mob/living/simple_animal/hostile/retaliate/rogue/fox/undead/simple_limb_hit(zone)
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

/mob/living/simple_animal/hostile/retaliate/rogue/fox/undead/Initialize()
	. = ..()
	AddComponent(/datum/component/deadite, 15 MINUTES, 50, 50, "fox_downed")
