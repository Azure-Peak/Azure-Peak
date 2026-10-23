/mob/living/simple_animal/hostile/retaliate/rogue/goat/game
	name = "tough goat"
	desc = "Unlike their domesticated counterpart, these roughened mountain goats are feisty creatures. Their horns just as unclipped as the amount of mercy they harbor. They're not as meaty, featuring tough muscle and fats instead."
	icon_state = "tough"
	icon_living = "tough"
	icon_dead = "tough_dead"

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
									/obj/item/reagent_containers/food/snacks/fat = 1,
									/obj/item/alch/viscera = 1,
									/obj/item/alch/sinew = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/reagent_containers/food/snacks/fat = 3,
						/obj/item/natural/hide = 1,
						/obj/item/natural/fur/goat = 1,
						/obj/item/natural/bundle/bone/full = 1, /obj/item/alch/sinew = 2, /obj/item/alch/bone = 1, /obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/reagent_containers/food/snacks/fat = 4,
						/obj/item/natural/hide = 1,
						/obj/item/natural/fur/goat = 2,
						/obj/item/natural/bundle/bone/full = 1, /obj/item/alch/sinew = 2, /obj/item/alch/bone = 1, /obj/item/alch/viscera = 2)
	head_butcher = /obj/item/natural/head/goat_wild

	health = GOAT_WILD_HEALTH
	maxHealth = GOAT_WILD_HEALTH
	tame_chance = 5
	bonus_tame_chance = 5
	melee_damage_lower = 15
	melee_damage_upper = 28
	STASPD = 11
	STACON = 10

	//new ai, old ai off
	aggressive = 1
	ai_controller = /datum/ai_controller/goat_tough //aggressive
