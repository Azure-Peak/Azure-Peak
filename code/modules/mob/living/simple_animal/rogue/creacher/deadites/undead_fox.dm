/mob/living/simple_animal/hostile/retaliate/rogue/fox/undead
	threat_point = THREAT_LOW
	anatomy_type = /datum/anatomy/quadruped/undead
	icon = 'icons/roguetown/mob/monster/deadites/fox_undead.dmi'
	name = "deadite venard"
	desc = "Once majestic, its gait is nowhere near as springy. At least, until it notices a piece of fresh meat."
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	health = FOX_HEALTH_UNDEAD
	maxHealth = FOX_HEALTH_UNDEAD
	ai_controller = /datum/ai_controller/undead/fox
	move_base_delay = MOVEMENT_DELAY_SPD_10
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

/mob/living/simple_animal/hostile/retaliate/rogue/fox/undead/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/deadite, 15 MINUTES, "fox_downed")
