/mob/living/simple_animal/hostile/retaliate/rogue/boar/undead
	icon = 'icons/roguetown/mob/monster/deadites/boar_undead.dmi'
	name = "deadite bramblesnout"
	desc = "The terrifying bramblesnout, claimed by undeath. Its viciously curved tusks are splintered but lethal, backed by a ruined mass of muscle that no longer feels pain, fatigue, or mercy.""
	icon_state = "boar"
	icon_living = "boar"
	icon_dead = "boar_dead"
	health = BOAR_HEALTH_UNDEAD
	maxHealth = BOAR_HEALTH_UNDEAD

	botched_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2, 
		/obj/item/alch/sinew = 2, 
		/obj/item/natural/bone = 4,
		/obj/item/alch/viscera = 1,
		/obj/item/natural/hide = 1,
	)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 4,
		/obj/item/reagent_containers/food/snacks/fat = 2, 
		/obj/item/natural/bundle/bone/full = 1, 
		/obj/item/alch/sinew = 3, 
		/obj/item/alch/bone = 1, 
		/obj/item/alch/viscera = 2, 
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2,
		/obj/item/natural/hide = 2,
	)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 5,
		/obj/item/reagent_containers/food/snacks/fat = 3, 
		/obj/item/natural/bundle/bone/full = 1, 
		/obj/item/alch/sinew = 4, 
		/obj/item/alch/bone = 1, 
		/obj/item/alch/viscera = 2, 
		/obj/item/reagent_containers/food/snacks/rogue/meat/meat_rotten = 2,
		/obj/item/natural/hide = 3,
	)

/mob/living/simple_animal/hostile/retaliate/rogue/boar/undead/Initialize()
	. = ..()
	AddComponent(/datum/component/deadite, 15 MINUTES, BOAR_HEALTH_UNDEAD, 300, "boar_downed")

/mob/living/simple_animal/hostile/retaliate/rogue/boar/undead/simple_limb_hit(zone)
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
