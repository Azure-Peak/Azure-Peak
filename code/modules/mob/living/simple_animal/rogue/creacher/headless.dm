//The vile Vore Monster
/mob/living/simple_animal/hostile/retaliate/rogue/headless
	anatomy_type = /datum/anatomy/biped/lamia/headless
	threat_point = THREAT_DANGEROUS
	icon = 'icons/roguetown/mob/monster/lamia.dmi'
	name = "headless"
	desc = "A horrible beast of gluttony. Its body is built like a barrel with a maw that opens only to darkness."
	icon_state = "headless"
	icon_living = "headless"
	icon_dead = "headless_dead"
	gender = NEUTER
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 9
	base_intents = list(/datum/intent/simple/bite, /datum/intent/simple/claw)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
						/obj/item/reagent_containers/food/snacks/fat = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	faction = list(FACTION_ORCS)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST|MOB_REPTILE
	health = HEADLESS_HEALTH
	maxHealth = HEADLESS_HEALTH
	melee_damage_lower = 25
	melee_damage_upper = 35
	environment_smash = ENVIRONMENT_SMASH_NONE
	food_type = list()
	footstep_type = null
	pooptype = null
	STACON = 6
	STASTR = 13
	STASPD = 10
	deaggroprob = 0
	food = 0
	dodgetime = 15
	aggressive = 1
	remains_type = null

	ai_controller = /datum/ai_controller/headless
	move_base_delay = MOVEMENT_DELAY_SLOW


/mob/living/simple_animal/hostile/retaliate/rogue/headless/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, 0.1)
