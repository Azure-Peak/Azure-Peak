/mob/living/simple_animal/hostile/retaliate/rogue/saiga/game
	name = "fatty saiga"
	desc = "Some saiga haven't foregone the same development as their brethren. Born with lanky legs and an insatiable appetite, these saigas cultivate a great wealth of fatty muscle tissue. This makes them slow, instead they've learned how to hide themselves in unexpected places, avoiding predators thusly."
	move_base_delay = MOVEMENT_DELAY_CRAWLING
	STASPD = 5
	icon_state = "fatty"
	icon_living = "fatty"

	botched_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga = 1,
		/obj/item/natural/bone = 4,
		/obj/item/alch/sinew = 1,
		/obj/item/reagent_containers/food/snacks/fat = 1,
	)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga = 2,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins = 0,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime = 0,
		/obj/item/reagent_containers/food/snacks/fat = 2,
		/obj/item/natural/hide = 2,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 3,
		/obj/item/alch/bone = 1,
		/obj/item/alch/viscera = 2
	)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/saiga = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins = 2,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime = 1,
		/obj/item/reagent_containers/food/snacks/fat = 3,
		/obj/item/natural/hide = 4,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 3,
		/obj/item/alch/bone = 1,
		/obj/item/alch/viscera = 2
	)
