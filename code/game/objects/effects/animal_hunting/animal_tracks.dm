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
	/// Hunt leader or solo hunter
	var/datum/weakref/hunter_ref
	/// For group hunts
	var/list/datum/weakref/party_refs = list()
	var/list/image/party_images = list()

	/// The specific animal that will spawn at the end
	var/target_animal_type
	/// The category this hunt belongs to
	var/datum/hunting_category/hunt_category
	/// Total tracks to find before the animal spawns
	var/max_trail_depth = 8
	/// Category boosted by user.
	var/datum/hunting_category/preferred_hunt
	/// Hunting map influences
	var/datum/hunting_category/secret_map_influence
	var/influence_attempted = FALSE
	var/track_dir

/obj/effect/hunting_track/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("A fresh mound is dark brown, these can be used to start a hunt by interacting with them.")
	. += span_info("Mounds provide more info with high hunting skill.")
	. += span_info("Follow the direction of the track to find the next mound, only you can see it, it is lighter brown in color.")
	. += span_info("Find enough mounds to find an animal at the end!")
	. += span_info("Mounds respawn overtime where they originally spawned.")
	. += span_info("Buy hunting maps to improve odds at finding certain animals.")
	. += span_info("Higher hunting skill spawns better animals more often.")
	. += span_info("If you see a white stag, think twice before attacking. Maybe just run, to be safe.")
	. += span_info("Right click your eyeball to get directions to the nearest track you are tracking, provided it is on screen.")

/obj/effect/hunting_track/examine(mob/user)
	. = ..()
	if(trail_depth > 0)
		. += span_notice("You are tracking this track.")
	if(track_dir)
		var/dir_text = dir2text(track_dir)
		. += span_notice("The tracks seem to be heading <b>[dir_text]</b>.")
	var/skill = user.get_skill_level(/datum/skill/misc/hunting)
	if(skill < 4)
		return

	// Skill 4+ identifies the category
	if(hunt_category)
		. += span_notice("You identify these signs as belonging to <b>[hunt_category.name]</b>.")

	// Skill 5+ shows area efficiency
	if(skill >= 5)
		var/area/A = get_area(src)
		var/bonus = hunt_category?.preferred_areas[A.type]
		if(bonus)
			. += "<br><details><summary><span class='nicegreen'>Environmental Analysis</span></summary>"
			. += span_info("The local terrain ([A.name]) increases discovery chances by <b>[bonus]%</b>.")
			. += "</details>"

/obj/effect/hunting_track/attack_right(mob/user)
	if(trail_depth > 0 || track_revealed)
		return // Can only set preference on the starter mound

	var/skill = user.get_skill_level(/datum/skill/misc/hunting)
	if(skill < 4)
		to_chat(user, span_warning("You aren't skilled enough to influence the trail."))
		return

	var/area/A = get_area(src)
	var/list/valid_cats = list()

	// Find categories that actually like this specific area
	for(var/cat_type in subtypesof(/datum/hunting_category))
		var/datum/hunting_category/C = new cat_type()
		if(C.preferred_areas[A.type] > 0)
			valid_cats[C.name] = C

	if(!valid_cats.len)
		to_chat(user, span_warning("The local environment doesn't favor any specific prey enough to track."))
		return

	var/selection = tgui_input_list(user, "Choose a focus for this hunt:", "Hunting Focus", valid_cats)
	if(!selection)
		return

	preferred_hunt = valid_cats[selection]
	to_chat(user, span_nicegreen("You focus your senses on tracking [selection]."))

/obj/effect/hunting_track/Initialize(mapload)
	. = ..()
	layer = HIGH_LANDMARK_LAYER
	// Add some visual variety
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

/obj/effect/hunting_track/Destroy()
	clear_party_images()
	party_refs.Cut()
	hunter_ref = null
	return ..()

/obj/effect/hunting_track/proc/setup_hunter_visibility()
	// Make the physical object invisible to everyone else
	invisibility = INVISIBILITY_MAXIMUM 

	for(var/datum/weakref/W in party_refs)
		var/mob/living/L = W.resolve()
		if(!L?.client)
			continue
		var/image/I = image(icon, src, icon_state, layer)
		I.color = src.color
		I.pixel_x = src.pixel_x
		I.pixel_y = src.pixel_y
		I.transform = src.transform
		// Add to client and our local tracker
		L.client.images += I
		party_images += I

/obj/effect/hunting_track/attack_hand(mob/living/user)
	if(track_revealed)
		return

	if(trail_depth == 0)
		var/datum/component/hunting_blocker/B = user.GetComponent(/datum/component/hunting_blocker)
		if(!B)
			B = user.AddComponent(/datum/component/hunting_blocker)
		if(!B.can_start_hunt())
			return

	// var/mob/living/H = hunter_ref?.resolve()

	// // Just in case anyone finds an invisible track somehow, this way they can't mess up someone's trail.
	// if(H && user != H)
	// 	return

	if(get_dist(user, src) < 1)
		to_chat(user, span_warning("You are standing too close to see where the trail leads. Step back."))
		return

	user.changeNext_move(CLICK_CD_MELEE)
	to_chat(user, span_info("You begin analyzing the signs..."))

	// Interaction time
	if(!do_after(user, get_hunting_do_time(user, 4 SECONDS), target = src))
		return
	// Do this check again to prevent duplicating tracks with multiple hunters...
	if(track_revealed)
		return

	if(uncover_trail(user))
		to_chat(user, span_nicegreen("The trail continues further ahead!"))
		distribute_party_exp(3)
		track_revealed = TRUE
		fade_and_die(user)
		//qdel(src)
		if(trail_depth == 0)
			var/datum/component/hunting_blocker/B = user.GetComponent(/datum/component/hunting_blocker)
			B?.register_hunt()
	else
		to_chat(user, span_warning("The trail seems to disappear into the brush here."))

/obj/effect/hunting_track/proc/uncover_trail(mob/living/user)
	var/skill = process_party_and_get_skill()

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
	var/deviation = 5 // Default for skill 0-2
	switch(skill)
		if(3)
			deviation = 4
		if(4)
			deviation = 3
		if(5)
			deviation = 2
		if(6)
			deviation = 1

	for(var/list/pattern in search_patterns)
		var/p_dx = pattern[1]
		var/p_dy = pattern[2]
		for(var/i in 1 to max_search_attempts)
			var/target_dist = base_dist + rand(0, 2)
			var/target_x = src.x + (p_dx * target_dist) + rand(-deviation, deviation)
			var/target_y = src.y + (p_dy * target_dist) + rand(-deviation, deviation)
			var/turf/T = locate(target_x, target_y, src.z)

			if(!T)
				continue

			for(var/turf/step in get_line(src, T))
				if(step.density)
					continue

			if(validate_turf(T))
				// Let's make sure tracks replenish themselves eventually.
				if(trail_depth == 0)
					new /obj/effect/landmark/hunting_spawner(get_turf(src))

				// Do this before reveal trail to make sure the icon is locked if need be
				if(trail_depth == 0 && !target_animal_type)
					initialize_hunt_group(user)
					initialize_hunt_chain(user)
				//Reveal THIS track before moving on
				reveal_track(T)

				// Spawn Animal if depth reached
				if(trail_depth >= max_trail_depth)
					to_chat(user, span_boldwarning("You see your quarry in the distance faintly!"))
					distribute_party_exp(35)
					var/mob/living/primary_target = new target_animal_type(T)
					if(spawn_group_bonus_animals(T, primary_target))
						visible_message(span_boldwarning("There seems to be a herd in the distance!"))
					return TRUE

				//Spawn the NEXT hidden mound
				var/obj/effect/hunting_track/next_trail = new(T)
				next_trail.party_refs = src.party_refs.Copy()
				next_trail.hunter_ref = src.hunter_ref
				next_trail.trail_depth = src.trail_depth + 1
				next_trail.max_trail_depth = src.max_trail_depth
				next_trail.target_animal_type = src.target_animal_type
				next_trail.hunt_category = src.hunt_category
				next_trail.locked_track_icon = src.locked_track_icon
				next_trail.linked_areas = src.linked_areas
				next_trail.color = "#ff9100" 
				next_trail.linked_areas = src.linked_areas
				next_trail.plane = GAME_PLANE_HIGHEST
				next_trail.setup_hunter_visibility()
				return TRUE
	return FALSE

/obj/effect/hunting_track/proc/initialize_hunt_group(mob/living/revealer)
	var/list/potential_party = list(revealer)
	for(var/mob/living/L in range(3, src))
		if(L.stat == DEAD || !L.mind)
			continue
		potential_party |= L

	var/mob/living/best_hunter
	var/highest_skill = -1

	// 2. Determine leader and store all as weakrefs
	for(var/mob/living/L in potential_party)
		var/L_skill = L.get_skill_level(/datum/skill/misc/hunting)
		if(L_skill > highest_skill)
			highest_skill = L_skill
			best_hunter = L

		party_refs |= WEAKREF(L)

	hunter_ref = WEAKREF(best_hunter)

	if(potential_party.len > 1)
		to_chat(potential_party, "<b>Group Hunt started!</b> [best_hunter.name] is leading the tracks. There are [party_refs.len] hunters participating.")

/obj/effect/hunting_track/proc/process_party_and_get_skill()
	var/highest_skill = 0
	var/mob/living/current_leader
	var/list/valid_party = list()

	for(var/datum/weakref/W in party_refs)
		var/mob/living/L = W.resolve()
		// Cleanup: Remove if deleted, dead, or further than 7 tiles from THIS track
		if(!L || L.stat == DEAD || get_dist(src, L) > 7)
			continue

		valid_party |= W

		// Determine who the best hunter CURRENTLY at the track is
		var/L_skill = L.get_skill_level(/datum/skill/misc/hunting)
		if(L_skill >= highest_skill)
			highest_skill = L_skill
			current_leader = L

	// Update the track's state
	party_refs = valid_party
	hunter_ref = WEAKREF(current_leader)
	
	return highest_skill

/obj/effect/hunting_track/proc/distribute_party_exp(base_amount)
	var/mob/living/leader = hunter_ref?.resolve()

	for(var/datum/weakref/W in party_refs)
		var/mob/living/L = W.resolve()
		if(!L || L.stat == DEAD || !L.mind)
			continue

		var/hunting_exp_modifier = max(1 + ((L.STAINT - 10) / 10), 0.1)
		var/final_amount = base_amount

		// If they aren't the leader, they get half
		if(L != leader)
			final_amount *= 0.5
		L.mind.add_sleep_experience(/datum/skill/misc/hunting, final_amount * hunting_exp_modifier)

/obj/effect/hunting_track/proc/reveal_track(turf/target_turf)
	// Pick a random visual style
	if(!locked_track_icon)
		locked_track_icon = pick(track_types)

	clear_party_images()

	invisibility = 0
	plane = GAME_PLANE
	icon_state = locked_track_icon
	name = "[icon_state] tracks"
	desc = "Fresh prints leading away into the wilderness."
	color = null

	// Calculate rotation
	var/direction = get_dir(src, target_turf)
	src.track_dir = direction
	var/angle = dir2angle(direction)

	// Apply rotation via matrix (assumes tracks point North/Up by default)
	var/matrix/M = matrix()
	M.Turn(angle)
	transform = M

/obj/effect/hunting_track/proc/validate_turf(turf/T)
	if(!T || T.density)
		return FALSE
	if(istransparentturf(T))
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

/obj/effect/hunting_track/proc/initialize_hunt_chain(mob/living/user)
	var/skill = user.get_skill_level(/datum/skill/misc/hunting)
	var/area/A = get_area(src)
	src.linked_areas = SShunting.get_linked_areas(A.type)

	// Calculate total tracks needed: 10 base, minus 1 for each level above 3
	max_trail_depth = clamp(max_trail_depth - (max(0, skill - 3)), 5, max_trail_depth)
	var/list/cat_weights = list()

	if(secret_map_influence)
		hunt_category = new secret_map_influence()
	else
		for(var/cat_type in subtypesof(/datum/hunting_category))
			var/datum/hunting_category/C = new cat_type()
			var/weight = C.skill_weights[skill + 1]

			// Exact type matching for area bonus to avoid using subtypes
			var/area_bonus = C.preferred_areas[A.type]
			if(area_bonus)
				weight *= (1 + (area_bonus / 100))

			// Right-click preference boost
			if(preferred_hunt && C.type == preferred_hunt.type)
				var/boost = 1.0
				switch(skill)
					if(4)
						boost = 1.25
					if(5)
						boost = 1.50
					if(6)
						boost = 2.0
				weight *= boost
			if(weight > 0)
				cat_weights[C] = weight

	if(!cat_weights.len && !hunt_category) // Emergency fallback
		hunt_category = new /datum/hunting_category/low_tier()
	else if (!hunt_category)
		hunt_category = pickweight(cat_weights)

	target_animal_type = pickweight(hunt_category.animals)

	// Skill 4+ uses preferred tracks
	if(skill >= 4 && hunt_category.preferred_tracks[target_animal_type])
		locked_track_icon = hunt_category.preferred_tracks[target_animal_type]
	else
		locked_track_icon = pick(track_types)

/obj/effect/hunting_track/proc/spawn_group_bonus_animals(turf/T, mob/living/primary_target)
	if(!hunt_category || !primary_target)
		return

	var/mob/living/leader = hunter_ref?.resolve()
	var/spawned_count = 0

	// We start at the target turf and look for nearby spots
	for(var/datum/weakref/W in party_refs)
		if(spawned_count >= hunt_category.bonus_animal_amount)
			break

		var/mob/living/L = W.resolve()
		if(!L || L == leader || L.stat == DEAD)
			continue

		var/skill = L.get_skill_level(/datum/skill/misc/hunting)
		// 14% per skill up to 98%
		var/success_chance = (skill + 1) * 14

		if(prob(success_chance))
			// Find a nearby valid turf so they aren't stacked
			var/turf/spawn_turf = T
			var/list/nearby_turfs = list()

			for(var/dir in GLOB.alldirs)
				var/turf/neighbor = get_step(T, dir)
				if(validate_turf(neighbor))
					nearby_turfs += neighbor

			// If neighbors are clear, pick one. Otherwise, stay on T (last resort)
			if(nearby_turfs.len)
				spawn_turf = pick(nearby_turfs)

			var/bonus_type = pickweight(hunt_category.animals)
			var/mob/living/bonus_mob = new bonus_type(spawn_turf)

			// Sync factions so the pack stays friendly
			if(primary_target.faction && primary_target.faction.len)
				bonus_mob.faction = primary_target.faction.Copy()
			spawned_count++
	return spawned_count

/obj/effect/hunting_track/proc/clear_party_images()
	if(!party_images.len)
		return

	// Iterate backwards through the image list for safety while deleting
	for(var/i in party_images.len to 1 step -1)
		var/image/I = party_images[i]
		if(!I)
			continue

		// Remove from every client in the party
		for(var/datum/weakref/W in party_refs)
			var/mob/living/L = W.resolve()
			if(L?.client)
				L.client.images -= I

		// Explicitly qdel the image object to avoid hard deletes
		qdel(I)

	party_images.Cut()
