//separate dm since hydro is getting bloated already

/obj/structure/glowshroom
	name = "kneestingers"
	desc = "Deceptively-delicate stalks sprout from the ground in luminous-green repose. Some scholars claim they're not really a fungus, even if the Dendorites insist otherwise. Either way they hurt like hell."
	anchored = TRUE
	opacity = 0
	density = FALSE
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "glowshroom1" //replaced in New
	layer = SPACEVINE_LAYER //A bit high but keeps it from fucking layering UNDER EVERYTHING
	light_system = MOVABLE_LIGHT
	max_integrity = 30
	blade_dulling = DULLING_CUT
	resistance_flags = FLAMMABLE
	light_outer_range = 2
	light_inner_range = 1
	light_power = 1.5
	light_color = "#d4fcac"
/obj/structure/glowshroom/fire_act(added, maxstacks)
	visible_message(span_warning("[src] catches fire!"))
	var/turf/T = get_turf(src)
	qdel(src)
	new /obj/effect/hotspot(T)

/obj/structure/glowshroom/CanAStarPass(ID, to_dir, caller)
	return !can_zap(caller)

/obj/structure/glowshroom/CanPass(atom/movable/mover, turf/target)
	if(isliving(mover) && mover.z == z)
		var/throwdir = get_dir(src, mover)
		var/mob/living/L = mover

		if(HAS_TRAIT(L, TRAIT_KNEESTINGER_IMMUNITY)) //Dendor kneestinger immunity
			return TRUE

		if(L.mind)
			if(world.time > L.last_client_interact + 0.2 SECONDS)
				return FALSE

		var/electrodam = 30
		if(world.time < (L.mob_timers["kneestinger"] + 30 SECONDS))
			electrodam = 15

		if(L.electrocute_act(electrodam, src))
			L.mob_timers["kneestinger"] = world.time
			src.take_damage(30)
			L.consider_ambush(always = TRUE)
			if(L.throwing)
				L.throwing.finalize(FALSE)
			if(mover.loc != loc && L.stat == CONSCIOUS)
				L.throw_at(get_step(L, throwdir), pick(1,5), 1, L, spin = FALSE)
			return FALSE
	. = ..()

/obj/structure/glowshroom/proc/can_zap(atom/movable/movable_victim)
	if(!isliving(movable_victim))
		return FALSE
	var/mob/living/victim = movable_victim
	if(HAS_TRAIT(victim, TRAIT_KNEESTINGER_IMMUNITY)) //Dendor kneestinger immunity
		return FALSE
	if(victim.mind)
		if(world.time > victim.last_client_interact + 0.2 SECONDS)
			return FALSE
	if(victim.throwing)	//Exemption from floor hazard, you're thrown over it.
		victim.throwing.finalize(FALSE)
	if(ismob(movable_victim))
		var/mob/mob_victim = movable_victim
		if(mob_victim.is_floor_hazard_immune())	//Floating, flying, etc
			return FALSE //why was this fucking commented out
	return TRUE

/obj/structure/glowshroom/proc/do_zap(atom/movable/movable_victim)
	if(!isliving(movable_victim))
		return FALSE
	var/mob/living/victim = movable_victim
	var/electrodam = 30
	if(world.time < (victim.mob_timers["kneestinger"] + 30 SECONDS))
		electrodam = 15
	if(victim.electrocute_act(electrodam, src))
		victim.mob_timers["kneestinger"] = world.time
		victim.emote("painscream")
		victim.update_sneak_invis(TRUE)
		victim.consider_ambush(always = TRUE)
		if(victim.throwing)
			victim.throwing.finalize(FALSE)
		return TRUE
	return FALSE

/obj/structure/glowshroom/Bumped(atom/movable/bumper)
	. = ..()
	if(can_zap(bumper))
		do_zap(bumper)

/obj/structure/glowshroom/Crossed(atom/movable/crosser)
	if(can_zap(crosser))
		do_zap(crosser)
	. = ..()


/obj/structure/glowshroom/attackby(obj/item/W, mob/user, params)
	if(isliving(user) && W && user.z == z)
		if(W.flags_1 & CONDUCT_1)
			var/mob/living/L = user
			if(L.electrocute_act(30, src)) // The kneestingers will let you pass if you worship dendor, but they won't take your stupid ass hitting them.
				L.emote("painscream")
				L.consider_ambush(always = TRUE)
				if(L.throwing)
					L.throwing.finalize(FALSE)
				return FALSE
	..()


/obj/structure/glowshroom/New(loc, obj/item/seeds/newseed, mutate_stats)
	..()
	icon_state = "glowshroom[rand(1,3)]"

	pixel_x = rand(-4, 4)
	pixel_y = rand(0,5)


/obj/structure/glowshroom/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	if(damage_type == BURN && damage_amount)
		playsound(src.loc, 'sound/blank.ogg', 100, TRUE)

/obj/structure/glowshroom/temperature_expose(exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		take_damage(5, BURN, 0, 0)

/obj/structure/glowshroom/acid_act(acidpwr, acid_volume)
	. = 1
	visible_message(span_danger("[src] melts away!"))
	var/obj/effect/decal/cleanable/molten_object/I = new (get_turf(src))
	I.desc = ""
	qdel(src)

/obj/structure/glowshroom/dendorite
	var/timeleft = null //5 MINUTES //balancing factor no longer relevant, uncommoent if gay. 

/obj/structure/glowshroom/dendorite/Initialize()
	. = ..()
	if(timeleft)
		QDEL_IN(src, timeleft)

/obj/structure/glowshroom/dendorite/attackby(obj/item/W, mob/user, params)
	// Dendorite glowshrooms don't electrocute when hit
	. = ..()
