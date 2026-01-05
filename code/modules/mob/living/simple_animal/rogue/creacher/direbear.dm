/mob/living/simple_animal/hostile/retaliate/rogue/direbear	//This way don't need new unqiue AI controller. Wolves are modular anyway.
	icon = 'icons/roguetown/mob/monster/direbear.dmi'
	name = "direbear"
	desc = "Renowned as a symbol of strength and rebirth by followers of Dendor, these mighty beasts are said to sleep for months on end without ever starving. While highly sought for their furs and hides, these claim as many hunters as they are claimed by."
	icon_state = "direbear"
	icon_living = "direbear"
	icon_dead = "direbear_dead"
	pixel_x = -16
	ambushable = FALSE
	base_intents = list(/datum/intent/simple/bite/bear)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1, 
									/obj/item/natural/hide = 1, 
									/obj/item/natural/fur/direbear = 1, 
									/obj/item/natural/bone = 3)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
									/obj/item/natural/hide = 2,
									/obj/item/natural/fur/direbear = 1,
									/obj/item/alch/sinew = 2, 
									/obj/item/alch/bone = 1, 
									/obj/item/alch/viscera = 2,
									/obj/item/natural/bone = 4)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
									/obj/item/natural/hide = 3,
									/obj/item/natural/fur/direbear = 2,
									/obj/item/alch/sinew = 2, 
									/obj/item/alch/bone = 1, 
									/obj/item/alch/viscera = 2,
									/obj/item/natural/bone = 4,
									/obj/item/natural/head/direbear = 1)
	faction = list("bears")		//This mf will kill undead - swapped to its own faction, doesn't trigger ambushes
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	melee_damage_lower = 50		// Ey, bo-bo!
	melee_damage_upper = 60		// We're gonna take his pick-in-ick basket!
	vision_range = 6		
	aggro_vision_range = 8
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES // silly furniture won't stop our boy
	milkies = FALSE
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	health = 500	//volf is 120, saigabuck is 400
	maxHealth = 500
	food_type = list(/obj/item/reagent_containers/food/snacks, 
				/obj/item/bodypart, 	//Woe be upon ye
				/obj/item/organ, 		//Woe be upon ye
				/obj/effect/decal/remains,
				)
	STACON = 12
	STASTR = 13
	STASPD = 9
	simple_detect_bonus = 40	//No sneaking by our boy..
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = FALSE //we dont despawn, our boy chills
	food = 0
	remains_type = /obj/effect/decal/remains/bear
	attack_sound = list('sound/vo/mobs/direbear/direbear_attack1.ogg','sound/vo/mobs/direbear/direbear_attack2.ogg','sound/vo/mobs/direbear/direbear_attack3.ogg')
	dodgetime = 30
	aggressive = 1
	stat_attack = UNCONSCIOUS	//You falling unconcious won't save you, little one..
	eat_forever = TRUE

//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/direbear

/mob/living/simple_animal/hostile/retaliate/rogue/direbear/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/direbear/direbear_attack1.ogg')	//Placeholder till we get more sounds
		if("pain")
			return pick('sound/vo/mobs/direbear/direbear_death1.ogg')	//Placeholder till we get more sounds
		if("death")
			return pick('sound/vo/mobs/direbear/direbear_death1.ogg', 'sound/vo/mobs/direbear/direbear_death2.ogg')

/obj/effect/decal/remains/bear
	name = "remains"
	desc = "This appears to be the remains of a mighty direbear. Never have the greatest not fallen as assuredly as the meekest."
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/direbear.dmi'

/datum/intent/simple/bite/bear
	clickcd = RAT_ATTACK_SPEED	//Slightly slower than wolfs by .1

/mob/living/simple_animal/hostile/retaliate/rogue/direbear/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/mob_cooldown/bear_swipe/swipe = new(src)
	swipe.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, swipe)

