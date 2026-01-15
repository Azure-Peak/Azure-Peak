/mob/living/simple_animal/hostile/retaliate/rogue/horse
	icon = 'icons/roguetown/mob/monster/horse.dmi'
	name = "horse"
	desc = ""
	icon_state = "horsewhite"
	icon_living = "horsewhite"
	icon_dead = "saiga_dead"
	icon_gib = "saiga_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_see = list("looks around.", "chews some leaves.", "neighs")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	move_to_delay = 8
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 4,
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/natural/hide = 4, /obj/item/natural/bundle/bone/full = 1)
	base_intents = list(/datum/intent/simple/horse)
	animal_species = /mob/living/simple_animal/hostile/retaliate/rogue/horse/male
	health = 180
	maxHealth = 180
	food_type = list(/obj/item/reagent_containers/food/snacks/grown/wheat,/obj/item/reagent_containers/food/snacks/grown/oat,/obj/item/reagent_containers/food/snacks/grown/apple)
	tame_chance = 15
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = /obj/item/natural/poo/horse
	faction = list("horse")
	attack_verb_continuous = "tramples"
	attack_verb_simple = "kicks"
	melee_damage_lower = 10
	melee_damage_upper = 25
	retreat_distance = 0.
	minimum_distance = 10
	milkies = FALSE
	STASPD = 15
	STACON = 8
	STASTR = 12
	STAWIL = 15
	pixel_x = -8
	attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	can_buckle = TRUE
	buckle_lying = 0
	can_saddle = TRUE
	aggressive = 1
	remains_type = /obj/effect/decal/remains/saiga


/mob/living/simple_animal/hostile/retaliate/rogue/horse/male
	icon_state = "horsewhite"
	icon_living = "horsewhite"
	icon_dead = "horsewhite_dead"
	icon_gib = "horsewhite_gib"
	gender = MALE
	retreat_distance = 0.3
	minimum_distance = 10
	milkies = FALSE


/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/white


/mob/living/simple_animal/hostile/retaliate/rogue/horse/white
	icon_state = "horsewhite"
	icon_living = "horsewhite"
	icon_dead = "horsewhite_dead"
	icon_gib = "horsewhite_gib"
	gender = FEMALE
	retreat_distance = 0.3
	minimum_distance = 10
	milkies = TRUE
	childtype = list(/mob/living/simple_animal/hostile/retaliate/rogue/foal/white_male = 70, /mob/living/simple_animal/hostile/retaliate/rogue/foal/white_female = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/foal/brown_male = 70, /mob/living/simple_animal/hostile/retaliate/rogue/foal/brown_female = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/foal/black_male = 70, /mob/living/simple_animal/hostile/retaliate/rogue/foal/black_female = 30)

/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/brown
	icon_state = "horsebrown"
	icon_living = "horsebrown"
	icon_dead = "horsebrown_dead"
	icon_gib = "horsebrown_gib"
	gender = MALE
	retreat_distance = 0.3
	minimum_distance = 10
	milkies = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/horse/brown
	icon_state = "horsebrown"
	icon_living = "horsebrown"
	icon_dead = "horsebrown_dead"
	icon_gib = "horsebrown_gib"
	gender = FEMALE
	retreat_distance = 0.3
	minimum_distance = 10
	milkies = TRUE
	childtype = list(/mob/living/simple_animal/hostile/retaliate/rogue/foal/white_male = 70, /mob/living/simple_animal/hostile/retaliate/rogue/foal/white_female = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/foal/brown_male = 70, /mob/living/simple_animal/hostile/retaliate/rogue/foal/brown_female = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/foal/black_male = 70, /mob/living/simple_animal/hostile/retaliate/rogue/foal/black_female = 30)

/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/black
	icon_state = "horseblack"
	icon_living = "horseblack"
	icon_dead = "horseblack_dead"
	icon_gib = "horseblack_gib"
	gender = MALE
	retreat_distance = 0.3
	minimum_distance = 10
	milkies = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/horse/black
	icon_state = "horseblack"
	icon_living = "horseblack"
	icon_dead = "horseblack_dead"
	icon_gib = "horseblack_gib"
	gender = FEMALE
	retreat_distance = 0.3
	minimum_distance = 10
	milkies = TRUE
	childtype = list(/mob/living/simple_animal/hostile/retaliate/rogue/foal/white_male = 70, /mob/living/simple_animal/hostile/retaliate/rogue/foal/white_female = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/foal/brown_male = 70, /mob/living/simple_animal/hostile/retaliate/rogue/foal/brown_female = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/foal/black_male = 70, /mob/living/simple_animal/hostile/retaliate/rogue/foal/black_female = 30)


// FOAL

/mob/living/simple_animal/hostile/retaliate/rogue/foal
	icon = 'icons/roguetown/mob/monster/horse.dmi'
	name = "foal"
	desc = ""
	icon_state = "foal"
	icon_living = "foal"
	icon_dead = "foal"
	icon_gib = "foal"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_see = list("looks around.", "chews some leaves.", "neighs")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	move_to_delay = 8
	animal_species = null
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1, /obj/item/natural/bone = 3)
	base_intents = list(/datum/intent/simple/horse)
	faction = list("horse")
	health = 20
	maxHealth = 20
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	milkies = FALSE
	melee_damage_lower = 1
	melee_damage_upper = 6
	STACON = 5
	STASTR = 5
	STASPD = 5
	tame = TRUE
	can_buckle = FALSE
	aggressive = 1

/mob/living/simple_animal/hostile/retaliate/rogue/foal/white_male
	icon_state = "foalwhite"
	icon_living = "foalwhite"
	icon_dead = "foalwhite_dead"
	icon_gib = "foalwhite_gib"
	gender = MALE
	retreat_distance = 0.3
	minimum_distance = 10
	milkies = FALSE
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/horse/male/white

/mob/living/simple_animal/hostile/retaliate/rogue/foal/white_female
	icon_state = "foalwhite"
	icon_living = "foalwhite"
	icon_dead = "foalwhite_dead"
	icon_gib = "foalwhite_gib"
	gender = FEMALE
	retreat_distance = 0.3
	minimum_distance = 10
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/horse/white

/mob/living/simple_animal/hostile/retaliate/rogue/foal/brown_male
	icon_state = "foalbrown"
	icon_living = "foalbrown"
	icon_dead = "foalbrown_dead"
	icon_gib = "foalbrown_gib"
	gender = MALE
	retreat_distance = 0.3
	minimum_distance = 10
	milkies = FALSE
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/horse/male/brown

/mob/living/simple_animal/hostile/retaliate/rogue/foal/brown_female
	icon_state = "foalbrown"
	icon_living = "foalbrown"
	icon_dead = "foalbrown_dead"
	icon_gib = "foalbrown_gib"
	gender = FEMALE
	retreat_distance = 0.3
	minimum_distance = 10
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/horse/brown

/mob/living/simple_animal/hostile/retaliate/rogue/foal/black_male
	icon_state = "foalblack"
	icon_living = "foalblack"
	icon_dead = "foalblack_dead"
	icon_gib = "foalblack_gib"
	gender = MALE
	retreat_distance = 0.3
	minimum_distance = 10
	milkies = FALSE
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/horse/male/black

/mob/living/simple_animal/hostile/retaliate/rogue/foal/black_female
	icon_state = "foalblack"
	icon_living = "foalblack"
	icon_dead = "foalblack_dead"
	icon_gib = "foalblack_gib"
	gender = FEMALE
	retreat_distance = 0.3
	minimum_distance = 10
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/horse/black



// TAMED


/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/white/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/horse/white/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/white/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/horse/white/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/brown/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/horse/brown/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/brown/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/horse/brown/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/black/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/horse/black/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/black/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/horse/black/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()


// BEHAVIORS
/mob/living/simple_animal/hostile/retaliate/rogue/horse/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		if(ssaddle)
			var/mutable_appearance/saddlet = mutable_appearance(icon, "saddle-above", 4.3)
			add_overlay(saddlet)
			saddlet = mutable_appearance(icon, "saddle")
			add_overlay(saddlet)
		if(has_buckled_mobs())
			var/mutable_appearance/mounted = mutable_appearance(icon, "[icon_state]_mounted", 4.3)
			add_overlay(mounted)


/mob/living/simple_animal/hostile/retaliate/rogue/horse/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/saiga/pain (1).ogg','sound/vo/mobs/saiga/pain (2).ogg','sound/vo/mobs/saiga/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/saiga/death (1).ogg','sound/vo/mobs/saiga/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/saiga/idle (1).ogg','sound/vo/mobs/saiga/idle (2).ogg','sound/vo/mobs/saiga/idle (3).ogg','sound/vo/mobs/saiga/idle (4).ogg','sound/vo/mobs/saiga/idle (5).ogg','sound/vo/mobs/saiga/idle (6).ogg','sound/vo/mobs/saiga/idle (7).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/horse/Initialize()
	..()
	if(tame)
		tamed()

/mob/living/simple_animal/hostile/retaliate/rogue/horse/find_food()
	..()
	var/obj/structure/vine/SV = locate(/obj/structure/vine) in loc
	if(SV)
		SV.eat(src)
		food = max(food + 30, 100)

/mob/living/simple_animal/hostile/retaliate/rogue/horse/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return


/mob/living/simple_animal/hostile/retaliate/rogue/horse/tamed()
	..()
	deaggroprob = 20
	if(can_buckle)
		var/datum/component/riding/D = LoadComponent(/datum/component/riding/no_ocean)
		D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 8), TEXT_SOUTH = list(0, 8), TEXT_EAST = list(-2, 8), TEXT_WEST = list(2, 8)))
		D.set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
		D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
		D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
		D.set_vehicle_dir_layer(WEST, OBJ_LAYER)

/mob/living/simple_animal/hostile/retaliate/rogue/horse/death()
	unbuckle_all_mobs()
	.=..()

/mob/living/simple_animal/hostile/retaliate/rogue/horse/eat_plants()
	//..()
	var/obj/structure/vine/SV = locate(/obj/structure/vine) in loc
	if(SV)
		SV.eat(src)
		food = max(food + 30, 100)


/mob/living/simple_animal/hostile/retaliate/rogue/horse/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "snout"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "snout"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()


// INTENT


/datum/intent/simple/horse
	name = "horse"
	icon_state = "instrike"
	attack_verb = list("tramples", "rams", "kicks")
	animname = "blank22"
	blade_class = BCLASS_BLUNT
	hitsound = "punch_hard"
	chargetime = 0
	penfactor = 10
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_d_type = "blunt"
	clickcd = SAIGA_ATTACK_SPEED


