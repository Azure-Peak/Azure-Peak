/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/undead
	icon = 'icons/roguetown/mob/monster/deadites/rat_undead.dmi'
	name = "deadite rous"
	desc = "Death has only narrowed down its tastes. Chitters tell tales of your flesh."
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat_dead"
	gender = MALE
	pixel_x = -8
	pixel_y = 0
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 1,
							/obj/item/natural/hide = 1,
							/obj/item/natural/bone = 2,
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1,
							/obj/item/alch/viscera = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2,
							/obj/item/natural/hide = 1,
							/obj/item/natural/bone = 2,
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1,
							/obj/item/alch/viscera = 1,
							/obj/item/natural/fur/rat = 1)
	head_butcher = /obj/item/natural/head/rous/undead
	faction = list(FACTION_UNDEAD)
	threat_point = THREAT_MODERATE
	health = RAT_HEALTH_UNDEAD
	maxHealth = RAT_HEALTH_UNDEAD
	ai_controller = /datum/ai_controller/rat/undead
	undead_rat = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/undead/simple_limb_hit(zone)
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

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/undead/Initialize()
	. = ..()
	AddComponent(/datum/component/deadite, 4 MINUTES, 50, 50, "rat_downed", 0)

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/undead/summoned
	ai_controller = /datum/ai_controller/rat/undead/summoned
