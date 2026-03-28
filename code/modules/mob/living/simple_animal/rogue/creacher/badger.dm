//Badgers are about a little stronger than raccoons, but still weak compared to wolfs and foxes.
/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger
	icon = 'icons/roguetown/mob/monster/badger.dmi'
	name = "bauson"
	desc = "A hostile little thing, it can put some volfs to shame with its aggression."
	icon_state = "badger"
	icon_living = "badger"
	icon_dead = "badger_dead"
	aggressive = 1
	threat_point = THREAT_LOW
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1, /obj/item/natural/bone = 2, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 1, 
						/obj/item/alch/bone = 1, 
						/obj/item/alch/viscera = 1,
						/obj/item/natural/bone = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2, 
						/obj/item/alch/bone = 1, 
						/obj/item/alch/viscera = 1,
						/obj/item/natural/bone = 2,)
	remains_type = /obj/effect/decal/remains/badger
	health = 90
	maxHealth = 90	//Wolf is 120
	simple_detect_bonus = 25	//Good at detecting stealthed people, but not as well as bobcats or raccoons.
	melee_damage_lower = 15
	melee_damage_upper = 22
	STACON = 6
	STASTR = 7
	STASPD = 16	//Pretty fast.

/obj/effect/decal/remains/badger
	name = "remains"
	desc = "Whether through unlucky circumstance or other means, this badger has passed. Lucky you."
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/badger.dmi'
