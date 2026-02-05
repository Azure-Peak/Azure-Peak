						//PRIMORDIALS//
					//////////////////////
						//////////////

//The idea for Primordials is that they are conjurable companions for arcyne types. They should cost essentia to conjure, and will follow the command minion order spell.
//Three differant types, air water and fire. Potential for unique effects/attacks for all three. Perhaps delineate between speed health and damage.
//Might also be worth looking into a spell to adjust their 'modes' from melee to ranged, or a command for special abilities.

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/Initialize(mapload, mob/user)
	if(user)
		if(user.mind && user.mind.current)
			summoner = user.mind.current.real_name
		else
			summoner = user.name
	// adds the name of the summoner to the faction, to avoid the hooded "Unknown" bug with Skeleton IDs
	if(user && user.mind && user.mind.current)
		faction |= "[user.mind.current.real_name]_faction"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BASHDOORS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	. = ..()

/datum/intent/simple/claw/primordial
	name = "claw"
	icon_state = "instrike"
	attack_verb = list("claws", "pecks")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 0
	candodge = TRUE
	canparry = TRUE
	miss_text = "slash the air"
	item_d_type = "slash"
	clickcd = 12

/mob/living/simple_animal/hostile/retaliate/rogue/primordial
	icon = 'icons/roguetown/mob/monster/primordial.dmi'
	AIStatus = AI_OFF
	can_have_ai = FALSE
	faction = list("neutral")
	var/next_ability_use
	var/ability_cooldown = 30 SECONDS

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/death()
	..()
	spill_embedded_objects()
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/proc/ability(turf/target_location, mob/living/user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire
	name = "flame primordial"
	desc = "Billowing heat strikes your face and threatens to singe your eyebrows! \
	It may be wise not to touch it."
	icon_state = "primordial_fire"
	icon_living = "primordial_fire"
	icon_dead = ""
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	turns_per_move = 6
	see_in_dark = 10
	move_to_delay = 3

	attack_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

	base_intents = list(/datum/intent/simple/claw/primordial)
	health = 300
	maxHealth = 300
	melee_damage_lower = 20
	melee_damage_upper = 30
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	projectiletype = /obj/projectile/magic/aoe/fireball/spitfire	//if we ever get ranged toggling working
	projectilesound = 'sound/magic/whiteflame.ogg'
	next_ability_use
	STACON = 10
	STASTR = 10
	STASPD = 13
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	defprob = 30
	retreat_health = 0
	food = 0
	next_ability_use
	ai_controller = /datum/ai_controller/flame_primordial

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire/ability(turf/target_location, mob/living/user)
	if(world.time < src.next_ability_use)
		to_chat(user, "[src] is not yet ready to use it's special ability.")
		return FALSE
	if(!do_after(src,1 SECONDS, src))
		return
	var/range = 3
	var/angle = 60 // cone angle in degrees

	// Get facing vector from mob → target
	var/dx = target_location.x - src.x
	var/dy = target_location.y - src.y

	var/dir_angle = ATAN2(dy, dx) // radians

	visible_message(span_danger("[src] exhales a cone of searing fire!"))

	for(var/turf/T in view(range, src))
		var/tx = T.x - src.x
		var/ty = T.y - src.y
		var/mag = sqrt(tx*tx + ty*ty)
		if(mag == 0)
			continue

		tx /= mag
		ty /= mag

		var/angle_to_turf = ATAN2(ty, tx)
		var/delta = abs(dir_angle - angle_to_turf)
		if(delta > 180)
			delta = 360 - delta // handle wrap-around

		if(delta <= angle/2) // inside cone
			new /obj/effect/hotspot(T)
			// Damage mobs on this turf
			for(var/mob/living/M in T)
				if(M == src)
					continue
				M.adjustFireLoss(15)

	src.next_ability_use = world.time + src.ability_cooldown
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/water
	name = "water primordial"
	desc = "A torrential flood, magically animated and bound to service. It seems \
	to draw moisture from the ground it traverses."
	icon_state = "primordial_water"
	icon_living = "primordial_water"
	icon_dead = ""
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 10
	move_to_delay = 3

	attack_sound = list('sound/misc/undertow.ogg')

	base_intents = list(/datum/intent/simple/claw/primordial)

	health = 400
	maxHealth = 400
	melee_damage_lower = 15
	melee_damage_upper = 25
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0

	STACON = 10
	STASTR = 10
	STASPD = 8
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	defprob = 20
	retreat_health = 0
	food = 0

	ai_controller = /datum/ai_controller/water_primordial

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/water/ability(turf/target_location, mob/living/user)
	if(world.time < src.next_ability_use)
		to_chat(user, "[src] is not yet ready to use it's special ability.")
		return FALSE
	if(!do_after(src,1 SECONDS, src))
		return
	if(!target_location)
		return
	visible_message(span_danger("[src] unleashes a spiralling wave of floodwaters!"))
	src.next_ability_use = world.time + src.ability_cooldown
	// Create the whirlpool effect centered on the target that handles temporary tiles
	new /obj/effect/whirlpool(target_location)

/obj/effect/whirlpool
	name = "floodwave"
	desc = "A swirling wavepool churns violently."
	icon_state = "blueshatter2"
	anchored = TRUE
	density = FALSE
	var/list/turf_data = list()
	var/duration = 15 SECONDS

/obj/effect/whirlpool/Initialize(mapload, turf/center)
	. = ..()
	if(!center)
		center = get_turf(src)
	// Build a 3x3 block around the center
	var/list/affected = block(
		locate(center.x - 1, center.y - 1, center.z),
		locate(center.x + 1, center.y + 1, center.z)
	)
	// Save original turfs
	for(var/turf/T in affected)
		turf_data[T] = T.type
	// Apply whirlpool layout
	for(var/turf/T in affected)
		var/dx = T.x - center.x
		var/dy = T.y - center.y
		if(dx == 0 && dy == 0)
			T.ChangeTurf(/turf/open/water/ocean/deep, flags = CHANGETURF_IGNORE_AIR)	//deep center
		else if(dx == 0) // vertical (north/south)
			if(dy > 0)
				T.ChangeTurf(/turf/open/water/river/flow, flags = CHANGETURF_IGNORE_AIR)
			else
				T.ChangeTurf(/turf/open/water/river/flow/north, flags = CHANGETURF_IGNORE_AIR)
		else if(dy == 0) // horizontal (east/west)
			if(dx > 0)
				T.ChangeTurf(/turf/open/water/river/flow/west, flags = CHANGETURF_IGNORE_AIR)
			else
				T.ChangeTurf(/turf/open/water/river/flow/east, flags = CHANGETURF_IGNORE_AIR)
		else
			if(dx < 0 && dy < 0) // SW corner
				T.ChangeTurf(/turf/open/water/river/flow/east, flags = CHANGETURF_IGNORE_AIR)
			else if(dx > 0 && dy < 0) // SE corner
				T.ChangeTurf(/turf/open/water/river/flow/north, flags = CHANGETURF_IGNORE_AIR)
			else if(dx > 0 && dy > 0) // NE corner
				T.ChangeTurf(/turf/open/water/river/flow/west, flags = CHANGETURF_IGNORE_AIR)
			else if(dx < 0 && dy > 0) // NW corner
				T.ChangeTurf(/turf/open/water/river/flow, flags = CHANGETURF_IGNORE_AIR)
	// Auto-remove after duration
	spawn(duration)
		qdel(src)

/obj/effect/whirlpool/Destroy()
	// Restore saved turfs
	for(var/turf/T in turf_data)
		if(T)
			T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/air
	name = "air primordial"
	desc = "Storm-winds whip at the air wherever this creature travels! \
	It is scarcely even easy to keep one's footing while close."
	icon_state = "primordial_air"
	icon_living = "primordial_air"
	icon_dead = ""
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 2
	see_in_dark = 10
	move_to_delay = 3

	attack_sound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')

	base_intents = list(/datum/intent/simple/claw/primordial)

	health = 250
	maxHealth = 250
	melee_damage_lower = 25
	melee_damage_upper = 35
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0


	STACON = 10
	STASTR = 10
	STASPD = 13
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	defprob = 40
	retreat_health = 0
	food = 0

	ai_controller = /datum/ai_controller/air_primordial

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/air/ability(turf/target_location, mob/living/user)
	if(world.time < src.next_ability_use)
		to_chat(user, "[src] is not yet ready to use it's special ability.")
		return FALSE
	if(!do_after(src,1 SECONDS, src))
		return
	if(!target_location)
		return
	var/dir_to_target = get_dir(src, target_location)

	// Starting turf = just in front of the primordial
	var/turf/current = get_step(get_turf(src), dir_to_target)

	// Collect the 3-length line outward from source
	var/list/wave_rows = list()
	for(var/i = 1, i <= 3, i++)
		if(!current)
			break
		var/list/row = list()
		row += current
		row += get_step(current, turn(dir_to_target, 90))
		row += get_step(current, turn(dir_to_target, -90))

		wave_rows += list(row) // push row as sublist
		current = get_step(current, dir_to_target)

	// Now release rows one after another
	var/delay = 3 // deciseconds = 0.3s between rows
	for(var/row_index = 1, row_index <= wave_rows.len, row_index++)
		var/list/row = wave_rows[row_index]
		spawn(delay * (row_index - 1))
			for(var/turf/T in row)
				if(!T)
					continue
				for(var/mob/living/L in T)
					if(L == src)
						continue
					knockback(L, dir_to_target, 8)
				new /obj/effect/temp_visual/gust(T, dir_to_target)
	visible_message(span_danger("[src] exhales a violent gust of wind!"))
	playsound(src, 'sound/weather/rain/wind_6.ogg', 100, TRUE)


/mob/living/simple_animal/hostile/retaliate/rogue/primordial/air/proc/knockback(mob/living/L, dir, distance)
	if(!L || !isturf(L.loc))
		return
	var/turf/target_turf = get_ranged_target_turf(L, dir, distance)
	if(!target_turf)
		return
	L.throw_at(target_turf, 7, 4)

/obj/effect/temp_visual/gust
	icon = 'icons/effects/effects.dmi'
	icon_state = "kick"
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	duration = 8

