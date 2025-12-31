//the saiga

/mob/living/simple_animal/hostile/retaliate/rogue/saiga
	name = "saiga doe"
	desc = "Chiefly reputed friends of man, the saiga is the most ubiqutous beast of burden in the known world. They are driven to haul caravans and ploughs, ridden by mounted warriors on the field, and are much beloved by all."
	icon = 'icons/roguetown/mob/monster/saiga.dmi'
	icon_state = "saiga"
	icon_living = "saiga"
	icon_dead = "saiga_dead"
	icon_gib = "saiga_gib"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_see = list("looks around.", "chews some leaves.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	move_to_delay = 8//Fastest mount
	animal_species = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck
	botched_butcher_results = list(
								/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
								/obj/item/natural/bone = 4,
								/obj/item/alch/sinew = 1,
								)
	butcher_results = list(
						/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 2,
						/obj/item/natural/bundle/bone/full = 1,
						/obj/item/alch/sinew = 3,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 2
						)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/natural/hide = 4,
						/obj/item/natural/bundle/bone/full = 1,
						/obj/item/alch/sinew = 3,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 2,
						/obj/item/natural/head/saiga = 1)
	base_intents = list(/datum/intent/simple/headbutt/saiga)
	health = 156
	maxHealth = 156
	food_type = list(
				/obj/item/reagent_containers/food/snacks/grown/wheat,
				/obj/item/reagent_containers/food/snacks/grown/oat,
				/obj/item/reagent_containers/food/snacks/grown/apple,
				)
	tame_chance = 25
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = /obj/item/natural/poo/horse
	faction = list("saiga")
	attack_verb_continuous = "headbutts"
	attack_verb_simple = "headbutt"
	melee_damage_lower = 10
	melee_damage_upper = 25
	retreat_distance = 10
	minimum_distance = 10
	rapid_melee = 1
	STASPD = 15
	STACON = 8
	STASTR = 12
	childtype = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigakid = 70,
				/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigaboy = 30,
				)
	pixel_x = -8
	attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	can_buckle = TRUE
	buckle_lying = 0
	can_saddle = TRUE
	aggressive = 1
	remains_type = /obj/effect/decal/remains/saiga

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigakid
	name = "saiga calf"
	icon_state = "saigakid"
	icon_living = "saigakid"
	icon_dead = "saigakid_dead"
	icon_gib = "saigakid_gib"
	animal_species = null
	butcher_results = list(
					/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
					/obj/item/natural/bone = 3,
					)
	health = 20
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	maxHealth = 20
	melee_damage_lower = 1
	melee_damage_upper = 6
	STACON = 5
	STASTR = 5
	STASPD = 5
	defprob = 50
	pixel_x = -16
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/saiga
	tame = TRUE
	can_buckle = FALSE
	aggressive = 1
	base_intents = list(/datum/intent/simple/headbutt/saiga)

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck
	name = "saiga buck"
	icon_state = "buck"
	icon_living = "buck"
	icon_dead = "buck_dead"
	icon_gib = "buck_gib"
	gender = MALE
	emote_see = list("stares.")
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	faction = list("saiga")
	attack_verb_continuous = "headbutts"
	attack_verb_simple = "headbutt"
	health = 400
	maxHealth = 400
	melee_damage_lower = 60
	melee_damage_upper = 90
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	retreat_health = 0.3
	rapid_melee = 1
	milkies = FALSE //what the fuck
	STACON = 15
	STASTR = 12
	STASPD = 18
	attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	buckle_lying = 0
	tame_chance = 25
	bonus_tame_chance = 15
	aggressive = 1
	remains_type = /obj/effect/decal/remains/saiga
	base_intents = list(/datum/intent/simple/headbutt/saiga)

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigaboy
	name = "saiga calf"
	desc = ""
	gender = MALE
	icon_state = "saigaboy"
	icon_living = "saigaboy"
	icon_dead = "saigaboy_dead"
	icon_gib = "saigaboy_gib"
	animal_species = null
	butcher_results = list(
					/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
					/obj/item/natural/bone = 3,
					)
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
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck
	tame = TRUE
	can_buckle = FALSE
	aggressive = 1
	base_intents = list(/datum/intent/simple/headbutt/saiga)

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame
	tame = TRUE

//the saiga's procs

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/find_food()
	..()
	var/obj/structure/vine/SV = locate(/obj/structure/vine) in loc
	if(SV)
		SV.eat(src)
		food = max(food + 30, 100)

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		if(ssaddle)
			var/mutable_appearance/saddlet = mutable_appearance(icon, gender == FEMALE ? "saddle-f-above" : "saddle-above", 4.3)
			add_overlay(saddlet)
			saddlet = mutable_appearance(icon, gender == FEMALE ? "saddle-f" : "saddle")
			add_overlay(saddlet)
		if(has_buckled_mobs())
			var/mutable_appearance/mounted = mutable_appearance(icon, gender == FEMALE ? "saiga_mounted" : "buck_mounted", 4.3)
			add_overlay(mounted)

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/tamed()
	..()
	deaggroprob = 30
	if(can_buckle)
		var/datum/component/riding/D = LoadComponent(/datum/component/riding/no_ocean)
		D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 8), TEXT_SOUTH = list(0, 8), TEXT_EAST = list(-2, 8), TEXT_WEST = list(2, 8)))
		D.set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
		D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
		D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
		D.set_vehicle_dir_layer(WEST, OBJ_LAYER)

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/death()
	unbuckle_all_mobs()
	. = ..()
	if(!QDELETED(src))
		src.AddComponent(/datum/component/deadite_animal_reanimation)

/// If we're a mount and are hit while sprinting, throw our rider off
/// Also called if the rider is hit
/mob/living/simple_animal/hostile/retaliate/rogue/saiga/proc/check_sprint_dismount()
	SIGNAL_HANDLER
	for(var/mob/living/carbon/human/rider in buckled_mobs)
		if(rider.m_intent == MOVE_INTENT_RUN)
			violent_dismount(rider)

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/post_buckle_mob(mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_MOB_APPLY_DAMGE, PROC_REF(check_sprint_dismount))
	if(!has_buckled_mobs())
		RegisterSignal(src, COMSIG_MOB_APPLY_DAMGE, PROC_REF(check_sprint_dismount))

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/post_unbuckle_mob(mob/living/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_APPLY_DAMGE, PROC_REF(check_sprint_dismount))
	if(!has_buckled_mobs())
		UnregisterSignal(src, COMSIG_MOB_APPLY_DAMGE, PROC_REF(check_sprint_dismount))

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/obj/effect/decal/remains/saiga
	name = "remains"
	desc = "The remains of a once-proud saiga. Perhaps it was killed for food, or slain in battle with a valiant knight atop?"
	gender = PLURAL
	icon_state = "skele"
	icon = 'icons/roguetown/mob/monster/saiga.dmi'

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/saiga/pain (1).ogg','sound/vo/mobs/saiga/pain (2).ogg','sound/vo/mobs/saiga/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/saiga/death (1).ogg','sound/vo/mobs/saiga/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/saiga/idle (1).ogg','sound/vo/mobs/saiga/idle (2).ogg','sound/vo/mobs/saiga/idle (3).ogg','sound/vo/mobs/saiga/idle (4).ogg','sound/vo/mobs/saiga/idle (5).ogg','sound/vo/mobs/saiga/idle (6).ogg','sound/vo/mobs/saiga/idle (7).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
			return "snout"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigaboy
	icon = 'icons/roguetown/mob/monster/saiga.dmi'
	name = "saiga"
	gender = MALE
	icon_state = "saigaboy"
	icon_living = "saigaboy"
	icon_dead = "saigaboy_dead"
	icon_gib = "saigaboy_gib"
	animal_species = null
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1, /obj/item/natural/bone = 3)
	base_intents = list(/datum/intent/simple/headbutt/saiga)
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
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck
	tame = TRUE
	can_buckle = FALSE
	aggressive = 1

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame
	tame = TRUE


/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

// Custom headbutt intent for saiga with proper attack speed
/datum/intent/simple/headbutt/saiga
	clickcd = SAIGA_ATTACK_SPEED
