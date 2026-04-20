/datum/component/squad_controller
	var/list/mob/living/carbon/human/species/human/northern/goon/followers = list()
	var/list/turf/waypoints = list()	// 	as the leader moves, they mark the turfs they pass over as 'waypoints'
	var/max_waypoints = 40				//	followers move along said waypoints

/datum/component/squad_controller/Initialize()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_leader_moved))

/datum/component/squad_controller/Destroy()
	disband_squad()
	followers = null
	waypoints = null
	return ..()

/datum/component/squad_controller/proc/on_leader_moved(atom/movable/mover, atom/old_loc, direction, forced)
	var/turf/current_pos = get_turf(parent)
	if(!current_pos)
		return
	
	if(!waypoints.len || waypoints[1] != current_pos)
		waypoints.Insert(1, current_pos)
		if(waypoints.len > max_waypoints)
			waypoints.Cut(max_waypoints + 1)
	
	move_squad_waypoint()

/datum/component/squad_controller/proc/add_member(mob/living/carbon/human/species/human/northern/goon/new_member)
	followers |= new_member
	new_member.squad_leader = parent
	new_member.mode = NPC_AI_FOLLOW
	var/mob/living/carbon/human/leader = parent
	var/distance = get_dist(new_member, leader)

	if(distance > 2)
		new_member.target = leader
		new_member.start_pathing_to(leader, force = TRUE)

	return

/datum/component/squad_controller/proc/remove_member(mob/living/carbon/human/species/human/northern/goon/member)
	followers -= member
	member.squad_leader = null
	member.mode = NPC_AI_IDLE

/datum/component/squad_controller/proc/disband_squad()
	for(var/mob/living/carbon/human/M in followers)
		remove_member(M)

/datum/component/squad_controller/proc/move_squad_waypoint()
	var/list/sorted_followers = list()
	var/mob/living/carbon/human/leader = parent

	for(var/mob/living/carbon/human/species/human/northern/goon/goon in followers)
		if(goon.stat == CONSCIOUS)
			sorted_followers += goon
	
	if(!sorted_followers.len)
		return

	sorted_followers = sortTim(sorted_followers, GLOBAL_PROC_REF(cmp_dist_to_atom_dsc), leader)

	for(var/mob/living/carbon/human/species/human/northern/goon/goon in sorted_followers)
		goon.clear_path()
		var/turf/target_waypoint = next_best_waypoint(goon)
		
		if(!target_waypoint)
			continue
		
		var/step_dir = get_dir(goon, target_waypoint)
		if(!step_dir)
			continue
		try_move_grunt(goon, step_dir)

/datum/component/squad_controller/proc/try_move_grunt(mob/living/carbon/human/species/human/northern/goon/goon, move_dir)
	if(!move_dir)
		return
	
	var/turf/current_turf = get_turf(goon)
	var/turf/target_turf = get_step(current_turf, move_dir)
	
	if(!target_turf)
		return
	
	if(!target_turf.can_traverse_safely(goon))
		return FALSE
	
	for(var/mob/M in target_turf)
		if(M.density)
			if(istype(M, /mob/living/carbon/human/species/human/northern/goon))
				var/mob/living/carbon/human/species/human/northern/goon/other = M
				if(goon.warband_ID == other.warband_ID)
					if(goon.squad_leader != other.squad_leader)
						continue  // if another goon is in the same warband but inside a different squad, they can pass through one another during a Follow Command
		
			return FALSE
	
	return step(goon, move_dir)


/datum/component/squad_controller/proc/next_best_waypoint(mob/living/carbon/human/species/human/northern/goon/goon)
	if(!waypoints.len)
		return get_turf(parent)
	
	var/turf/goon_turf = get_turf(goon)
	var/turf/best_waypoint
	var/closest_dist = INFINITY
	
	for(var/turf/waypoint in waypoints)
		if(waypoint == goon_turf)
			continue  // skip the waypoint they're already standing on
		
		var/dist = get_dist(goon, waypoint)
		
		// prefer waypoints that are 1-3 tiles away
		if(dist > 0 && dist <= 3)
			if(dist < closest_dist)
				closest_dist = dist
				best_waypoint = waypoint
	
	// if there's no nearby waypoint, just take the closest one
	if(!best_waypoint)
		for(var/turf/waypoint in waypoints)
			if(waypoint == goon_turf)
				continue
			
			var/dist = get_dist(goon, waypoint)
			if(dist < closest_dist)
				closest_dist = dist
				best_waypoint = waypoint
	

	if(!best_waypoint)
		best_waypoint = get_turf(parent)
	
	return best_waypoint


// whenever the squad leader goes through a travel tile, we bring along any squadmates within 5 tiles of them
// we also bring along the squadmates nearby THOSE squadmates
// so we get a long chain of teleports
/datum/component/squad_controller/proc/teleport_squad(turf/destination, max_range = 5)
	var/list/qualified = get_qualified_members(max_range)
	
	// teleport qualified members
	for(var/mob/living/carbon/human/species/human/northern/goon/goon in qualified)
		goon.forceMove(destination)
		goon.recent_travel = world.time
	
	// if a squadmate didn't qualify for the TP, we remove them from the squad
	for(var/mob/living/carbon/human/species/human/northern/goon/goon in followers)
		if(!(goon in qualified))
			remove_member(goon)


/datum/component/squad_controller/proc/get_qualified_members(max_range = 5)
	var/mob/living/carbon/human/leader = parent
	var/list/to_check = list(leader)	
	var/list/qualified = list()
	var/list/checked = list()
	
	while(to_check.len)
		var/atom/current = to_check[1]
		to_check -= current
		checked += current
		
		for(var/mob/living/carbon/human/species/human/northern/goon/goon in followers)
			if(goon in qualified)
				continue  // skip anyone already marked for the teleport
			
			if(goon.stat != CONSCIOUS)
				continue  // skip anyone unconscious
			
			var/distance = get_dist(current, goon)
			if(distance <= max_range)
				qualified += goon
				if(!(goon in to_check) && !(goon in checked))
					to_check += goon
	
	return qualified


