
/obj/item/bait
	name = "bag of bait"
	desc = "Horrid smell to me, wonderful smell to big game."
	icon_state = "bait"
	icon = 'icons/roguetown/items/misc.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	var/check_counter = 0
	var/list/attracted_types = list(/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 10,
										/mob/living/simple_animal/hostile/retaliate/rogue/goat = 33,
									/mob/living/simple_animal/hostile/retaliate/rogue/goatmale = 33,
									/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit = 33,
									/mob/living/simple_animal/hostile/retaliate/rogue/chicken = 55)
	var/attraction_chance = 100
	var/deployed = 0
	var/deploy_speed = 2 SECONDS
	var/refund_bag = TRUE
	resistance_flags = FLAMMABLE
	grid_height = 32
	grid_width = 32

/obj/item/bait/Initialize()
	. = ..()
	check_counter = world.time

/obj/item/bait/attack_self(mob/user)
	var/area/A = get_area(user.loc)
	if(!is_valid_hunting_area(A))
		to_chat(user, span_warning("I should save [name] for the wilderness..."))
		return

	. = ..()
	user.visible_message(span_notice("[user] begins deploying the bait..."), \
						span_notice("I begin deploying the bait..."))
	if(do_after(user, deploy_speed, target = src)) //rogtodo hunting skill
		user.dropItemToGround(src)
		START_PROCESSING(SSobj, src)
		name = "bait"
		icon_state = "[icon_state]1"
		deployed = 1

/obj/item/bait/attack_hand(mob/user)
	if(deployed)
		user.visible_message(span_notice("[user] begins gathering up the bait..."), \
							span_notice("I begin gathering up the bait..."))
		if(do_after(user, deploy_speed, target = src)) //rogtodo hunting skill
			STOP_PROCESSING(SSobj, src)
			name = initial(name)
			deployed = 0
			icon_state = initial(icon_state)
			..()
	else
		..()

/obj/item/bait/process()
	if(deployed)
		if(world.time > check_counter + 10 SECONDS)
			check_counter = world.time
			var/area/A = get_area(src)
			if(A.outdoors)
				var/list/possible_targets = list()
				for(var/obj/item/bait/B in range(7, src))
					if(B == src)
						continue
					if(can_see(src, B, 7))
						possible_targets += B
				if(possible_targets.len)
					return
				possible_targets = list()
				for(var/obj/structure/flora/roguetree/RT in range(7, src))
					if(can_see(src, RT, 7))
						possible_targets += RT
				for(var/obj/structure/flora/roguegrass/bush/RT in range(7, src))
					if(can_see(src, RT, 7))
						possible_targets += RT
				if(!possible_targets.len)
					return
				var/cume = 0
				for(var/mob/living/carbon/human/L in viewers(src, 7))
					if(L.stat == CONSCIOUS)
						cume++
				if(!cume)
					if(prob(attraction_chance))
//						var/turf/T = get_turf(pick(possible_targets))
						var/turf/T = get_turf(src)
						if(T)
							var/mob/M = pickweight(attracted_types)
							if(has_world_trait(/datum/world_trait/zizo_pet_cementery))
								if(GLOB.animal_to_undead[M])
									if(prob(75))
										M = GLOB.animal_to_undead[M]
							new M(T)
							if(refund_bag)
								if(prob(66))
									new /obj/item/storage/roguebag/crafted(T)
								else
									new /obj/item/natural/cloth(T)
							qdel(src)
					else
						qdel(src)
	..()

/obj/item/bait/sweet
	name = "bag of sweetbait"
	desc = "This bait doesn't smell as bad as the others. I might even try a bite..."
	icon_state = "baitp"
	attracted_types = list(/mob/living/simple_animal/hostile/retaliate/rogue/goat = 33,
							/mob/living/simple_animal/hostile/retaliate/rogue/goatmale = 33,
							/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit = 40, 	// Rabbits love sweet things
							/mob/living/simple_animal/hostile/retaliate/rogue/saiga = 20,
							/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck = 20,
							/mob/living/simple_animal/hostile/retaliate/rogue/fox = 20,				//Scavenger, so lower chance
							/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 10,			//Scavenger, so lower chance
							/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 5)				//Predator, doesn't eat berries but attacted to prey


/obj/item/bait/bloody
	name = "bag of bloodbait"
	desc = "Imagine if vampires got attracted to these!"
	icon_state = "baitb"
	attracted_types = list(/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 35,
							/mob/living/simple_animal/hostile/retaliate/rogue/mole = 20,
							/mob/living/simple_animal/hostile/retaliate/rogue/fox = 20,	
							/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 15,		//Annoying bastards
							/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 10,
							/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 5)			//RUH-ROH

/obj/item/bait/spider
	name = "silk bag of bloodbait"
	desc = "Bait for my little pet!"
	icon_state = "baits"
	attracted_types = list(/mob/living/simple_animal/hostile/retaliate/rogue/drider/tame/saddled = 100)

/obj/item/bait/leech
	name = "bag of leechbait"
	desc = "Bait that might attract a little pestran friend."
	icon_state = "baitb"
	refund_bag = FALSE
	attracted_types = list(/obj/item/leechtick = 43,
							/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 5,
							/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 2)
