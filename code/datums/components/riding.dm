/datum/component/riding
	var/vehicle_move_delay = 4 //tick delay between movements, lower = faster, higher = slower
	var/keytype
	var/riding_xp_move_counter = 0 //Plays with the new EXP-obtaining mechanic, courtesy of PR #768 from Ophaq.

	var/list/riding_offsets = list()	//position_of_user = list(dir = list(px, py)), or RIDING_OFFSET_ALL for a generic one.
	var/list/directional_vehicle_layers = list()	//["[DIRECTION]"] = layer. Don't set it for a direction for default, set a direction to null for no change.
	var/list/allowed_turf_typecache
	var/list/forbid_turf_typecache					//allow typecache for only certain turfs, forbid to allow all but those. allow only certain turfs will take precedence.
	var/allow_one_away_from_valid_turf = TRUE		//allow moving one tile away from a valid turf but not more.

	var/mob/living/driver
	/// world.time the driver may next move
	var/nextmove = 0
	/// Tiles of momentum built up
	var/momentum = 0
	/// Tiles of travel needed to reach full speed
	var/ramp = 4
	/// Move delay multiplier when starting from a standstill
	var/startmult = 2
	/// Direction of the last successful move
	var/heading

/datum/component/riding/Initialize(mapload)
	if(!ismovableatom(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOVABLE_BUCKLE, PROC_REF(vehicle_mob_buckle))
	RegisterSignal(parent, COMSIG_MOVABLE_UNBUCKLE, PROC_REF(vehicle_mob_unbuckle))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(vehicle_moved))

/datum/component/riding/no_ocean/Initialize(mapload)//no copy paste
	. = ..()
	forbid_turf_typecache = typecacheof(/turf/open/water/ocean/deep)

/datum/component/riding/proc/vehicle_mob_buckle(datum/source, mob/living/M, force = FALSE)
	var/atom/movable/AM = parent
	M.set_glide_size(AM.glide_size)
	M.updating_glide_size = FALSE
	if(!driver && !M.incapacitated())
		driver = M
	handle_vehicle_layer()
	handle_vehicle_offsets()

/datum/component/riding/proc/vehicle_mob_unbuckle(datum/source, mob/living/M, force = FALSE)
	var/atom/movable/AM = parent
	M.reset_offsets("riding")
	M.updating_glide_size = TRUE
	if(M == driver)
		driver = null
	if(AM.has_buckled_mobs())
		handle_vehicle_offsets()
		return
	var/mob/living/L = AM
	if(!istype(L) || !L.lying)
		AM.layer = initial(AM.layer)

/datum/component/riding/proc/handle_vehicle_layer()
	var/atom/movable/AM = parent
	if(!AM.has_buckled_mobs())
		return
	var/static/list/defaults = list(TEXT_NORTH = OBJ_LAYER, TEXT_SOUTH = ABOVE_MOB_LAYER, TEXT_EAST = ABOVE_MOB_LAYER, TEXT_WEST = ABOVE_MOB_LAYER)
	var/newlayer = directional_vehicle_layers["[AM.dir]"] || defaults["[AM.dir]"]
	if(newlayer)
		AM.layer = newlayer

/datum/component/riding/proc/vehicle_moved(datum/source)
	var/atom/movable/AM = parent
	if(!AM.has_buckled_mobs())
		return
	if(driver?.m_intent == MOVE_INTENT_RUN)
		riding_xp_move_counter++
		if(riding_xp_move_counter >= 5)					// Determines how many steps are needed before Riding-type EXP is rewarded. In this case, you obtain EXP every time you travel five tiles while riding a mount.
			driver.mind?.add_sleep_experience(/datum/skill/misc/riding, driver.STAINT * 0.1)	// Scales the amount of Riding-type EXP that's rewarded, based on your character's INT. Same as every other skill.
			riding_xp_move_counter = 0
	else
		riding_xp_move_counter = 0							// Resets the counter if you're not running while riding.
	handle_vehicle_offsets()
	handle_vehicle_layer()

/datum/component/riding/proc/handle_vehicle_offsets()
	var/atom/movable/AM = parent
	var/dirtext = "[AM.dir]"
	var/side = AM.dir == EAST ? 1 : (AM.dir == WEST ? -1 : 0)
	var/count = length(AM.buckled_mobs)
	var/passengers = AM.max_buckled_mobs > 1
	for(var/mob/living/rider as anything in AM.buckled_mobs)
		var/seat = rider == driver ? 1 : ++passengers
		if(!rider.fixedeye)
			rider.setDir(AM.dir)
		var/list/offsets = get_offsets(seat)[dirtext]
		if(!offsets)
			continue
		var/xoff = offsets[1]
		var/yoff = length(offsets) >= 2 ? offsets[2] : 0
		if(seat > 1)
			xoff -= side * 10
		else if(count > 1)
			xoff += side * 2
		if(length(offsets) == 3)
			rider.layer = offsets[3]
		else
			switch(AM.dir)
				if(SOUTH)
					rider.layer = seat == 1 ? MOB_LAYER : BELOW_MOB_LAYER
				if(NORTH)
					rider.layer = seat == 1 ? ABOVE_MOB_LAYER : ABOVE_ALL_MOB_LAYER
				else
					rider.layer = seat == 1 ? ABOVE_MOB_LAYER : MOB_LAYER
		rider.set_mob_offsets("riding", _x = xoff, _y = yoff)

//Override this to set my vehicle's various pixel offsets
/datum/component/riding/proc/get_offsets(pass_index) // list(dir = x, y, layer)
	var/static/list/zero = list(TEXT_NORTH = list(0, 0), TEXT_SOUTH = list(0, 0), TEXT_EAST = list(0, 0), TEXT_WEST = list(0, 0))
	return riding_offsets["[pass_index]"] || riding_offsets[RIDING_OFFSET_ALL] || zero

//MOVEMENT
/datum/component/riding/proc/turf_check(turf/next, turf/current)
	if(allowed_turf_typecache && !allowed_turf_typecache[next.type])
		return (allow_one_away_from_valid_turf && allowed_turf_typecache[current.type])
	else if(forbid_turf_typecache && forbid_turf_typecache[next.type])
		return (allow_one_away_from_valid_turf && !forbid_turf_typecache[current.type])
	return TRUE

/datum/component/riding/proc/handle_ride(mob/living/user, direction)
	var/atom/movable/AM = parent
	if(user != driver)
		if((driver && !driver.incapacitated()) || user.incapacitated())
			return
		driver = user
		handle_vehicle_offsets()
	if(user.incapacitated())
		user.visible_message(span_warning("[user] falls off of [AM]!"), span_warning("I fall off of [AM]!"))
		AM.unbuckle_mob(user)
		return
	if(world.time < nextmove)
		return
	var/turf/current = AM.loc
	var/turf/next = get_step(AM, direction)
	if(!isturf(current) || !next)
		return
	if(keytype && !user.is_holding_item_of_type(keytype))
		var/obj/item/key = keytype
		to_chat(user, span_warning("I need \a [initial(key.name)] in hand to steer [AM]."))
		nextmove = world.time + vehicle_move_delay
		momentum = 0
		return TRUE
	if(!turf_check(next, current))
		to_chat(user, span_warning("[AM] can't go onto [next]!"))
		nextmove = world.time + vehicle_move_delay
		momentum = 0
		return

	if(world.time > nextmove + 0.5 SECONDS)
		momentum = 0
	else if(heading && direction != heading)
		var/turn = abs(dir2angle(direction) - dir2angle(heading))
		momentum = max(momentum - ramp * min(turn, 360 - turn) / 180, 0)
	var/delay = vehicle_move_delay
	if(ramp)
		delay *= 1 + (startmult - 1) * (1 - momentum / ramp)
	if(ISDIAGONALDIR(direction))
		delay *= 2
	nextmove = world.time + delay
	AM.set_glide_size(DELAY_TO_GLIDE_SIZE(delay))

	step(AM, direction)
	if(AM.loc == current)
		momentum = 0
		handle_vehicle_layer()
		handle_vehicle_offsets()
		return TRUE
	heading = get_dir(current, AM.loc)
	momentum = min(momentum + 1, ramp)
	return TRUE

///////Yes, I said humans. No, this won't end well...//////////
/datum/component/riding/human

/datum/component/riding/human/vehicle_mob_unbuckle(datum/source, mob/living/M, force = FALSE)
	var/mob/living/carbon/human/H = parent
	H.remove_movespeed_modifier(MOVESPEED_ID_HUMAN_CARRYING)
	. = ..()
	if(!H.has_buckled_mobs())
		qdel(src)

/datum/component/riding/human/vehicle_mob_buckle(datum/source, mob/living/M, force = FALSE)
	. = ..()
	var/mob/living/carbon/human/H = parent
	var/amt2use = HUMAN_CARRY_SLOWDOWN
	var/reqstrength = 10
	if(H.r_grab?.grabbed == M && H.l_grab?.grabbed == M)
		reqstrength -= 2
	if(H.STASTR < reqstrength)
		amt2use += 2
	H.add_movespeed_modifier(MOVESPEED_ID_HUMAN_CARRYING, multiplicative_slowdown = amt2use)

/datum/component/riding/human/handle_vehicle_layer()
	var/atom/movable/AM = parent
	if(AM.has_buckled_mobs())
		for(var/mob/M in AM.buckled_mobs) //ensure proper layering of piggyback and carry, sometimes weird offsets get applied
			M.layer = MOB_LAYER
		if(!AM.buckle_lying)
			if(AM.dir == SOUTH)
				AM.layer = ABOVE_MOB_LAYER
			else
				AM.layer = OBJ_LAYER
		else
			if(AM.dir == NORTH)
				AM.layer = OBJ_LAYER
			else
				AM.layer = ABOVE_MOB_LAYER
	else
		AM.layer = MOB_LAYER

/datum/component/riding/human/get_offsets(pass_index)
	var/mob/living/carbon/human/human = parent
	var/obj/item/bodypart/taur/taur = human.get_taur_tail()
	if(human.buckle_lying)
		return list(TEXT_NORTH = list(0, 6), TEXT_SOUTH = list(0, 6), TEXT_EAST = list(0, 6), TEXT_WEST = list(0, 6))
	else if(istype(parent, /mob/living/carbon/human/species/wildshape)) //Snowflake druid travel
		return list(TEXT_NORTH = list(8, 6), TEXT_SOUTH = list(8, 6), TEXT_EAST = list(8, 6), TEXT_WEST = list(8, 6))
	else if(taur)
		return list(TEXT_NORTH = list(0, 6), TEXT_SOUTH = list(0, 6), TEXT_EAST = list(-12, 4), TEXT_WEST = list(12, 4))
	else
		return list(TEXT_NORTH = list(0, 6), TEXT_SOUTH = list(0, 6), TEXT_EAST = list(-6, 4), TEXT_WEST = list(6, 4))

/datum/component/riding/human/proc/force_dismount(mob/living/user)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(user)
	user.Paralyze(60)
	user.visible_message(span_warning("[AM] pushes [user] off of [AM.p_them()]!"), \
						span_warning("[AM] pushes me off of [AM.p_them()]!"))
