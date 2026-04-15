/obj/effect/hunting_track
	name = "disturbed earth"
	desc = "A mound of dirt and broken twigs. Something passed through here recently."
	icon = 'icons/obj/flora/animaltracks.dmi'
	icon_state = "hidden"
	anchored = TRUE
	invisibility = 0
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	/// How many successful tracks have been found in this chain
	var/trail_depth = 0
	/// Max attempts to find a valid turf for the next track
	var/max_search_attempts = 9
	/// List of area types this trail is allowed to move into
	var/list/linked_areas = list()
	var/static/list/track_types = list("cervine", "small", "ursine", "canine")
	var/locked_track_icon = null
	var/track_revealed = FALSE
	var/datum/weakref/hunter_ref
	var/image/track_image

/obj/effect/hunting_track/Initialize(mapload)
	. = ..()
	layer = ABOVE_OPEN_TURF_LAYER
	// Add some visual variety
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

/obj/effect/hunting_track/Destroy()
	var/mob/living/L = hunter_ref?.resolve()
	if(L?.client && track_image)
		L.client.images -= track_image
	track_image = null
	hunter_ref = null
	return ..()

/obj/effect/hunting_track/proc/setup_hunter_visibility(mob/living/new_hunter)
	if(!new_hunter)
		return

	hunter_ref = WEAKREF(new_hunter)
	// Make the physical object invisible to everyone else
	invisibility = INVISIBILITY_MAXIMUM 

	if(!new_hunter.client)
		return

	track_image = image(icon, src, icon_state, layer)
	track_image.color = src.color
	track_image.pixel_x = src.pixel_x
	track_image.pixel_y = src.pixel_y
	track_image.transform = src.transform
	new_hunter.client.images += track_image

/obj/effect/hunting_track/attack_hand(mob/living/user)
	if(track_revealed)
		return

	var/mob/living/H = hunter_ref?.resolve()

	// Just in case anyone finds an invisible track somehow, this way they can't mess up someone's trail.
	if(H && user != H)
		return

	if(get_dist(user, src) < 1)
		to_chat(user, span_warning("You are standing too close to see where the trail leads. Step back."))
		return

	user.changeNext_move(CLICK_CD_MELEE)
	to_chat(user, span_info("You begin analyzing the signs..."))

	// Interaction time
	if(!do_after(user, get_hunting_do_time(user, 4 SECONDS), target = src))
		return

	if(uncover_trail(user))
		to_chat(user, span_nicegreen("The trail continues further ahead!"))
		track_revealed = TRUE
		fade_and_die(user)
		//qdel(src)
	else
		to_chat(user, span_warning("The trail seems to disappear into the brush here."))

/obj/effect/hunting_track/proc/uncover_trail(mob/living/user)
	var/skill = 0
	skill = user.get_skill_level(/datum/skill/misc/hunting)

	var/base_dx = clamp(src.x - user.x, -1, 1)
	var/base_dy = clamp(src.y - user.y, -1, 1)

	if(!base_dx && !base_dy)
		base_dy = 1 

	var/list/search_patterns = list(
		list(base_dx, base_dy),   // Forward
		list(-base_dy, base_dx),  // Left
		list(base_dy, -base_dx)   // Right
	)

	var/base_dist = 9
	var/deviation = max(0, 6 - skill) 

	for(var/list/pattern in search_patterns)
		var/p_dx = pattern[1]
		var/p_dy = pattern[2]
		for(var/i in 1 to max_search_attempts)
			var/target_dist = base_dist + rand(0, 2)
			var/target_x = src.x + (p_dx * target_dist) + rand(-deviation, deviation)
			var/target_y = src.y + (p_dy * target_dist) + rand(-deviation, deviation)
			var/turf/T = locate(target_x, target_y, src.z)

			if(validate_turf(T))
				//Reveal THIS track before moving on
				reveal_track(T)

				//Spawn the NEXT hidden mound
				var/obj/effect/hunting_track/next_trail = new(T)
				next_trail.trail_depth = src.trail_depth + 1
				next_trail.linked_areas = src.linked_areas
				if(src.locked_track_icon)
					next_trail.locked_track_icon = src.locked_track_icon
				//qdel(src)

				next_trail.color = "#e6d2b5" 
				next_trail.setup_hunter_visibility(user)
				return TRUE
	return FALSE

/obj/effect/hunting_track/proc/reveal_track(turf/target_turf)
	// Pick a random visual style
	if(!locked_track_icon)
		locked_track_icon = pick(track_types)

	var/mob/living/H = hunter_ref?.resolve()
	if(H?.client && track_image)
		H.client.images -= track_image
	track_image = null

	invisibility = 0
	icon_state = locked_track_icon
	name = "[icon_state] tracks"
	desc = "Fresh prints leading away into the wilderness."
	color = null

	// Calculate rotation
	var/direction = get_dir(src, target_turf)
	var/angle = dir2angle(direction)

	// Apply rotation via matrix (assumes tracks point North/Up by default)
	var/matrix/M = matrix()
	M.Turn(angle)
	transform = M

	if(track_image)
		track_image.icon_state = icon_state
		track_image.transform = transform
		track_image.color = null 
	else
		color = null

/obj/effect/hunting_track/proc/validate_turf(turf/T)
	if(!T || T.density)
		return FALSE

	// Check for wall-like objects
	if(T.is_blocked_turf())
		return FALSE

	// Area persistence check
	var/area/A = get_area(src)
	var/area/target_A = get_area(T)

	if(target_A == A || (target_A.type in linked_areas))
		return TRUE
	return FALSE

/obj/effect/hunting_track/proc/fade_and_die(mob/living/user)
	var/skill = user.get_skill_level(/datum/skill/misc/hunting)
	var/wait_time = 5 SECONDS + (skill * 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(start_fade_animation)), wait_time)

/obj/effect/hunting_track/proc/start_fade_animation()
	animate(src, alpha = 0, time = 200, easing = EASE_OUT)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), 20 SECONDS)
