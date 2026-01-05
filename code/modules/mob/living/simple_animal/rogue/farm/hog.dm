/mob/living/simple_animal/hostile/retaliate/rogue/swine
	icon = 'modular/Creechers/icons/piggie.dmi'
	name = "swine sow"
	desc = "A domesticated hog, won't be finding you any truffles."
	icon_state = "piggie_f"
	icon_living = "piggie_f"
	icon_dead = "piggie_dead"
	icon_gib = "piggie_dead"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_see = list("eyes the surroundings.", "flicks its ears.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	move_to_delay = 8
	animal_species = /mob/living/simple_animal/hostile/retaliate/rogue/swine/hog
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/fatty = 2, /obj/item/alch/sinew = 2, /obj/item/natural/bone = 4, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/fatty = 4,
						/obj/item/reagent_containers/food/snacks/fat = 2, /obj/item/natural/bundle/bone/full = 1, /obj/item/alch/sinew = 3, /obj/item/alch/bone = 1, /obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/fatty = 6,
						/obj/item/reagent_containers/food/snacks/fat = 4, /obj/item/natural/bundle/bone/full = 1, /obj/item/alch/sinew = 4, /obj/item/alch/bone = 1, /obj/item/alch/viscera = 2)//We get fat instead of hide - pig hide is terrible for much of anything.

	health = 140
	maxHealth = 140
	food_type = list(/obj/item/reagent_containers/food/snacks/grown/oat,/obj/item/reagent_containers/food/snacks/grown/potato/rogue,/obj/item/reagent_containers/food/snacks/rogue/meat)//Omnivores / Give me your öats bröther for I am starving.
	tame_chance = 25
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = /obj/item/natural/poo/horse
	faction = list("pigs")
	base_intents = list(/datum/intent/simple/headbutt/saiga)
	attack_verb_simple = "ram"
	attack_verb_continuous = "rams"
	melee_damage_lower = 15
	melee_damage_upper = 40 //Ever been rammed by a boar? Exactly.
	STACON = 15
	STAWIL = 20//Beefy
	STASTR = 12
	STASPD = 8
	move_to_delay = 8
	milkies = FALSE //Do not the hog
	childtype = list(/mob/living/simple_animal/hostile/retaliate/rogue/swine/piglet = 60, /mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/piglet = 40)
	remains_type = /obj/effect/decal/remains/pig

	//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/generic

/mob/living/simple_animal/hostile/retaliate/rogue/swine/get_sound(input)
	switch(input)
		if("aggro")
			return pick('modular/Creechers/sound/pighangry.ogg')
		if("pain")
			return pick('modular/Creechers/sound/pighangry.ogg')
		if("death")
			return pick('modular/Creechers/sound/piglin.ogg')
		if("idle")
			return pick('modular/Creechers/sound/pig1.ogg','modular/Creechers/sound/pig2.ogg',)

/mob/living/simple_animal/hostile/retaliate/rogue/swine/piglet
	name = "piglet"
	desc = "An infant swine."
	icon_state = "piggie_piglin"
	icon_living = "piggie_piglin"
	icon_dead = "piggie_piglin_dead"
	icon_gib = "piggie_piglin_dead"
	animal_species = null
	base_intents = list(/datum/intent/simple/headbutt)
	health = 20
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	maxHealth = 20
	milkies = FALSE
	melee_damage_lower = 1
	melee_damage_upper = 6
	STACON = 5
	STASTR = 5
	STASPD = 2
	defprob = 50
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/swine

/mob/living/simple_animal/hostile/retaliate/rogue/swine/simple_limb_hit(zone)
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

/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog
	icon = 'modular/Creechers/icons/piggie.dmi'
	name = "swine hog"
	desc = "A domesticated hog, won't be finding you any truffles. This one can even be saddled."
	icon_state = "piggie_m"
	icon_living = "piggie_m"
	icon_dead = "piggie_dead"
	icon_gib = "piggie_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_see = list("eyes the surroundings.", "flicks its ears.")
	stop_automated_movement_when_pulled = TRUE
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/fatty = 2, /obj/item/alch/sinew = 2, /obj/item/natural/bone = 4, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/fatty = 4,
						/obj/item/reagent_containers/food/snacks/fat = 2, /obj/item/natural/bundle/bone/full = 1, /obj/item/alch/sinew = 3, /obj/item/alch/bone = 1, /obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/fatty = 6,
						/obj/item/reagent_containers/food/snacks/fat = 4, /obj/item/natural/bundle/bone/full = 1, /obj/item/alch/sinew = 4, /obj/item/alch/bone = 1, /obj/item/alch/viscera = 2)//We get fat instead of hide - pig hide is terrible for much of anything.
	faction = list("pigs")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	attack_same = 0
	base_intents = list(/datum/intent/simple/headbutt/saiga)
	attack_verb_simple = "ram"
	attack_verb_continuous = "rams"
	health = 250
	maxHealth = 250
	melee_damage_lower = 35
	melee_damage_upper = 60
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	food_type = list(/obj/item/reagent_containers/food/snacks/grown/oat,/obj/item/reagent_containers/food/snacks/grown/potato/rogue,/obj/item/reagent_containers/food/snacks/rogue/meat)//Omnivores / Give me your öats bröther for I am starving.
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = /obj/item/natural/poo/horse
	STACON = 15
	STAWIL = 20//Beefy
	STASTR = 12
	STASPD = 6
	move_to_delay = 10//Slowest mount
	can_buckle = TRUE
	buckle_lying = 0
	can_saddle = TRUE//Hooooooog rider
	remains_type = /obj/effect/decal/remains/pig

/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/simple_limb_hit(zone)
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

/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/piglet
	name = "piglet"
	desc = "An infant swine."
	gender = MALE
	icon_state = "piggie_piglin"
	icon_living = "piggie_piglin"
	icon_dead = "piggie_piglin_dead"
	icon_gib = "piggie_piglin_dead"
	animal_species = null
	base_intents = list(/datum/intent/simple/headbutt)
	health = 20
	maxHealth = 20
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	can_buckle = FALSE
	can_saddle = FALSE
	melee_damage_lower = 1
	melee_damage_upper = 6
	STACON = 5
	STASTR = 5
	STASPD = 2
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/swine/hog

/mob/living/simple_animal/hostile/retaliate/rogue/swine/Initialize()
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)

/mob/living/simple_animal/hostile/retaliate/rogue/swine/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/tamed()
	..()
	deaggroprob = 50
	if(can_buckle)
		var/datum/component/riding/D = LoadComponent(/datum/component/riding/no_ocean)
		D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 6), TEXT_SOUTH = list(0, 6), TEXT_EAST = list(-2, 6), TEXT_WEST = list(2, 6)))
		D.set_vehicle_dir_layer(SOUTH, MOB_LAYER+0.1)
		D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
		D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
		D.set_vehicle_dir_layer(WEST, OBJ_LAYER)


/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		if(ssaddle)
			var/mutable_appearance/saddlet = mutable_appearance(icon, "saddle-above", 4.3)
			add_overlay(saddlet)
			saddlet = mutable_appearance(icon, "saddle")
			add_overlay(saddlet)
		if(has_buckled_mobs())
			var/mutable_appearance/mounted = mutable_appearance(icon, "piggie_mounted", 4.3)
			add_overlay(mounted)

/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()
