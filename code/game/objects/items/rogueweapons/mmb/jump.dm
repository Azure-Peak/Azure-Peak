/datum/intent/jump
	name = "jump"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE
	pointer = 'icons/effects/mousemice/human_jump.dmi'

/datum/intent/jump/on_mmb(atom/target, mob/living/user, params)
	user.jump_action(target)

/mob/living/proc/jump_action(atom/A)
	if(istype(get_turf(src), /turf/open/water))
		to_chat(src, span_warning("I can't jump while floating."))
		return FALSE

	if(!A || QDELETED(A) || !A.loc)
		return FALSE

	if(A == src || A == loc)
		return FALSE

	if(src.get_num_legs() < 2)
		return FALSE

	if(pulledby && pulledby != src)
		to_chat(src, span_warning("I'm being grabbed."))
		changeNext_move(mmb_intent.clickcd)
		resist_grab()
		return FALSE

	if(IsOffBalanced())
		to_chat(src, span_warning("I haven't regained my balance yet."))
		return FALSE

	if(!(mobility_flags & MOBILITY_STAND))
		if(!HAS_TRAIT(src, TRAIT_LEAPER))// The Jester cares not for such social convention.
			to_chat(src, span_warning("I should stand up first."))
			return FALSE

	if(!isatom(A))
		return FALSE

	if(A.z != z)
		if(!HAS_TRAIT(src, TRAIT_ZJUMP))
			to_chat(src, span_warning("That's too high for me..."))
			return FALSE

	SEND_SIGNAL(src, COMSIG_LIVING_ONJUMP, A)

	changeNext_move(mmb_intent.clickcd)

	face_atom(A)

	var/jadded
	var/jrange
	var/jextra = FALSE
	var/jroot = FALSE

	if(m_intent == MOVE_INTENT_RUN)
		emote("leap", forced = TRUE)
		OffBalance(30)
		jadded = 45
		jrange = 3
		jroot = TRUE

		if(!HAS_TRAIT(src, TRAIT_LEAPER))// The Jester lands where the Jester wants.
			jextra = TRUE
	else
		emote("jump", forced = TRUE)
		OffBalance(20)
		jadded = 20
		jrange = 2

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		jadded += H.get_complex_pain()/50
		if(!H.check_armor_skill() || H.legcuffed)
			jadded += 50
			jrange = 1

	jump_action_resolve(A, jadded, jrange, jextra, jroot)
	return TRUE

#define FLIP_DIRECTION_CLOCKWISE 1
#define FLIP_DIRECTION_ANTICLOCKWISE 0

/mob/living/proc/jump_action_resolve(atom/A, jadded, jrange, jextra, jroot)
	var/do_a_flip
	var/flip_direction = FLIP_DIRECTION_CLOCKWISE
	var/prev_pixel_z = pixel_z
	var/prev_transform = transform
	if(get_skill_level(/datum/skill/misc/athletics) > 4)
		do_a_flip = TRUE
		if((dir & SOUTH) || (dir & WEST))
			flip_direction = FLIP_DIRECTION_ANTICLOCKWISE

	if(stamina_add(min(jadded,100)))
		if(do_a_flip)
			var/flip_angle = flip_direction ? 120 : -120
			animate(src, pixel_z = pixel_z + 6, transform = turn(transform, flip_angle), time = 1)
			animate(transform = turn(transform, flip_angle), time=1)
			animate(pixel_z = prev_pixel_z, transform = turn(transform, flip_angle), time=1)
			animate(transform = prev_transform, time = 0)
		else
			animate(src, pixel_z = pixel_z + 6, time = 1)
			animate(pixel_z = prev_pixel_z, transform = turn(transform, pick(-12, 0, 12)), time=2)
			animate(transform = prev_transform, time = 0)

		if(jextra)
			throw_at(A, jrange, 1, src, spin = FALSE)
			while(src.throwing)
				sleep(1)
			throw_at(get_step(src, src.dir), 1, 1, src, spin = FALSE)
		else
			throw_at(A, jrange, 1, src, spin = FALSE)
			while(src.throwing)
				sleep(1)
		if(jroot && !HAS_TRAIT(src, TRAIT_ZJUMP))	//Jesters and werewolves don't get immobilized at all
			Immobilize((HAS_TRAIT(src, TRAIT_LEAPER) ? 5 : 10))	//Acrobatics get half the time
		if(isopenturf(src.loc))
			var/turf/open/T = src.loc
			if(T.landsound)
				playsound(T, T.landsound, 100, FALSE)
			T.Entered(src)
	else
		animate(src, pixel_z = pixel_z + 6, time = 1)
		animate(pixel_z = prev_pixel_z, transform = turn(transform, pick(-12, 0, 12)), time=2)
		animate(transform = prev_transform, time = 0)
		throw_at(A, 1, 1, src, spin = FALSE)

	if(mob_offsets)
		for(var/o in mob_offsets)
			if(mob_offsets[o])
				reset_offsets(o)

#undef FLIP_DIRECTION_CLOCKWISE
#undef FLIP_DIRECTION_ANTICLOCKWISE

/mob/living/proc/get_jump_range()
	if(!check_armor_skill() || get_item_by_slot(SLOT_LEGCUFFED))
		return 1
	if(m_intent == MOVE_INTENT_RUN)
		return 3
	return 2

/// Returns the stamina cost to jump. Will never use more than 100 stam.
/mob/living/proc/get_jump_stam_cost()
	. = 10
	if(m_intent == MOVE_INTENT_RUN)
		. = 15
	var/mob/living/carbon/human/H = src
	if(istype(H))
		. += H.get_complex_pain()/50
	if(!check_armor_skill() || get_item_by_slot(SLOT_LEGCUFFED))
		. += 50
	return clamp(., 0, 100)

/mob/living/proc/get_jump_offbalance_time()
	if(m_intent == MOVE_INTENT_RUN)
		return 3 SECONDS
	return 2 SECONDS

/// Performs a jump. Used by the jump MMB intent. Returns TRUE if a jump was performed.
/mob/living/proc/can_jump(atom/A)
	var/turf/our_turf = get_turf(src)
	if(istype(our_turf, /turf/open/water))
		to_chat(src, span_warning("I'm floating in [our_turf]."))
		return FALSE
	if(!A || QDELETED(A) || !A.loc)
		return FALSE
	if(A == src || A == src.loc)
		return FALSE
	if(get_num_legs() < 2)
		return FALSE
	if(pulledby && pulledby != src)
		to_chat(src, span_warning("I'm being grabbed."))
		return FALSE
	if(IsOffBalanced())
		to_chat(src, span_warning("I haven't regained my balance yet."))
		return FALSE
	if(!(mobility_flags & MOBILITY_STAND) && !HAS_TRAIT(src, TRAIT_LEAPER))// The Jester cares not for such social convention.
		to_chat(src, span_warning("I should stand up first."))
		return FALSE
	if(A.z != z && !HAS_TRAIT(src, TRAIT_ZJUMP))
		return FALSE
	return TRUE
