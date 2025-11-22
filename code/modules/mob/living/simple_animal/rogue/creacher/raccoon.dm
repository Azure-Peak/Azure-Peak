//Raccoons are a faster, still hostile, version of a wolf and bobcat, but the weakest of the three.
/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon
	icon = 'icons/roguetown/mob/monster/raccoon.dmi'
	name = "rakun"
	desc = "An adorable albiet dangerous creacher of Azuria's northern coast, known to steal food from bins or eat small game."
	icon_state = "raccoon"
	icon_living = "raccoon"
	icon_dead = "raccoon_dead"
	aggressive = 1
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
						/obj/item/natural/bone = 2,
						/obj/item/natural/fur/raccoon = 1)
	remains_type = /obj/effect/decal/remains/raccoon
	health = 85
	maxHealth = 85	//Wolf is 120
	simple_detect_bonus = 30	//Good at detecting stealthed people, but not as well as Bobcats.
	melee_damage_lower = 10
	melee_damage_upper = 15
	STACON = 4
	STASTR = 4
	STASPD = 18	//A little faster than bobcats.

	//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/volf
	melee_cooldown = WOLF_ATTACK_SPEED

/obj/effect/decal/remains/raccoon
	name = "remains"
	desc = "Whether through unlucky circumstance or other means, this raccoon has passed."
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/raccoon.dmi'
