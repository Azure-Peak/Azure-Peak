/obj/item/reagent_containers/food/snacks/smallrat
	name = "rat"
	desc = "A scurrying rodent often found in sewers and pantries."
	icon_state = "srat"
	icon = 'icons/roguetown/mob/monster/rat.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	foodtype = RAW
	verb_say = "squeaks"
	verb_yell = "squeaks"
	obj_flags = CAN_BE_HIT
	var/dead = FALSE
	eat_effect = /datum/status_effect/debuff/uncookedfood
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/friedrat
	max_integrity = 10
	sellprice = 0
	rotprocess = null
	grid_width = 32
	grid_height = 32


/obj/item/reagent_containers/food/snacks/smallrat/onbite(mob/living/carbon/human/user)
	if(loc == user)
		if(user.mind && user.mind.has_antag_datum(/datum/antagonist/vampire))
			if(dead)
				to_chat(user, span_warning("It's dead."))
				return
			if(do_after(user, 30, target = src))
				user.visible_message(span_warning("[user] drinks from [src]!"),\
				span_warning("I drink from [src]!"))
				playsound(user.loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)
				user.adjust_bloodpool(50)
				dead = TRUE
				playsound(get_turf(user), 'sound/vo/mobs/rat/rat_death.ogg', 100, FALSE, -1)
				icon_state = "srat1"
				rotprocess = SHELFLIFE_SHORT
				user.add_stress(/datum/stressevent/drankrat)
			return
	return ..()

/obj/item/reagent_containers/food/snacks/rogue/friedrat
	name = "fried rat"
	desc = ""
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "cookedrat"
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("burnt flesh" = 1)
	eat_effect = null
	rotprocess = SHELFLIFE_SHORT
	sellprice = 0

/obj/item/reagent_containers/food/snacks/smallrat/burning(input as num)
	if(!dead)
		if(burning >= burntime)
			dead = TRUE
			playsound(src, 'sound/vo/mobs/rat/rat_death.ogg', 100, FALSE, -1)
			icon_state = "srat1"
			rotprocess = SHELFLIFE_SHORT
	. = ..()

/obj/item/reagent_containers/food/snacks/smallrat/Crossed(mob/living/L)
	. = ..()
	if(L)
		if(!dead)
			if(isturf(loc))
				dir = pick(GLOB.cardinals)
				step(src, dir)
//				playsound(src, pick('sound/vo/mobs/rat/rat_life.ogg','sound/vo/mobs/rat/rat_life2.ogg','sound/vo/mobs/rat/rat_life3.ogg'), 100, TRUE, -1)



/obj/item/reagent_containers/food/snacks/smallrat/dead
	dead = TRUE
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/smallrat/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	if(dead)
		icon_state = "sratl"
		rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/smallrat/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(dead)
		..()
	else
		if(isturf(loc))
			if(isliving(user))
				var/mob/living/L = user
				if(prob(L.STASPD * 1.5))
					..()
				else
					dir = pick(GLOB.cardinals)
					step(src, dir)
					to_chat(user, span_warning("I fail to snatch it by the tail!"))
					playsound(src, pick('sound/vo/mobs/rat/rat_life.ogg','sound/vo/mobs/rat/rat_life2.ogg','sound/vo/mobs/rat/rat_life3.ogg'), 100, TRUE, -1)
					return
	..()

/obj/item/reagent_containers/food/snacks/smallrat/process()
	..()
	if(dead)
		return
	if(!isturf(loc)) //no floating out of bags
		return
	if(prob(5))
		playsound(src, pick('sound/vo/mobs/rat/rat_life.ogg','sound/vo/mobs/rat/rat_life2.ogg','sound/vo/mobs/rat/rat_life3.ogg'), 100, TRUE, -1)
	if(prob(75) && !dead)
		dir = pick(GLOB.cardinals)
		step(src, dir)
		for(var/obj/item/reagent_containers/food/snacks/S in loc)
			if(S != src)
				qdel(S)
				playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
				if(prob(23))
					var/turf/T = src.loc
					if(T)
						new /mob/living/simple_animal/hostile/retaliate/rogue/bigrat(T)
						dead = TRUE
						qdel(src)
				break

/obj/item/reagent_containers/food/snacks/smallrat/obj_destruction(damage_flag)
	//..()
	if(!dead)
		dead = TRUE
		rotprocess = SHELFLIFE_SHORT
		playsound(src, 'sound/vo/mobs/rat/rat_death.ogg', 100, FALSE, -1)
		icon_state = "[icon_state]1"
		return 1
	. = ..()

/obj/item/reagent_containers/food/snacks/smallrat/attackby(obj/item/I, mob/user, params)
	if(!dead)
		if(isliving(user))
			var/mob/living/L = user
			if(prob(L.STASPD * 2))
				..()
			else
				if(isturf(loc))
					dir = pick(GLOB.cardinals)
					step(src, dir)
					to_chat(user, span_warning("The vermin dodges my attack."))
					playsound(src, pick('sound/vo/mobs/rat/rat_life.ogg','sound/vo/mobs/rat/rat_life2.ogg','sound/vo/mobs/rat/rat_life3.ogg'), 100, TRUE, -1)
					return
	..()
