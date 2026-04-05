
/obj/effect/proc_holder/spell/invoked/headbutt // 1st of the grapple spells, this one does 50 damage and throws the target a good distance.
	name = "Headbutt"
	desc = "Requires an aggressive grab. After a brief wind up, slams your head into the target, knocking you both over and leaving the target vulnerable."

	recharge_time = 60 SECONDS
	invocation_type = "emote"
	overlay_icon = 'icons/mob/roguehudgrabs.dmi'
	action_icon = 'icons/mob/roguehudgrabs.dmi'
	overlay_state = "grabbing"
	action_icon_state = "grabbing"
	var/damage = 0
	var/vulnerable_dur = 6 SECONDS

/obj/effect/proc_holder/spell/invoked/headbutt/cast(list/targets, mob/living/user,)
	if(targets[1] == user)
		to_chat(user, span_notice("You can't wrestle yourself."))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/target = targets[1]
	if(!ishuman(target))
		to_chat(user, span_warning("This spell only works on humans!"))
		revert_cast()
		return FALSE

	if(user.pulling != target || user.grab_state < GRAB_AGGRESSIVE)
		to_chat(user, span_warning("You must have an aggressive grab on [target] to begin the wrestling!"))
		revert_cast()
		return FALSE

	var/datum/component/wrestle_combat_tracker/tracker = user.GetComponent(/datum/component/wrestle_combat_tracker)
	if(!tracker)
		tracker = user.AddComponent(/datum/component/wrestle_combat_tracker)

	var/channel_time = 1 SECONDS

	var/original_user_pixel_x = user.pixel_x
	var/original_user_pixel_y = user.pixel_y
	var/original_user_transform = user.transform
	var/original_target_pixel_x = target.pixel_x
	var/original_target_pixel_y = target.pixel_y
	var/original_target_transform = target.transform

	to_chat(user, span_notice("You line up with [target]!"))
	to_chat(target, span_userdanger("[user] winds up for a headbutt!"))
	tracker.channeling_throw = TRUE
	user.emote("attack")
	
	// User faces the target
	var/dir_to_target = get_dir(user, target)
	user.setDir(dir_to_target)
	
	// Both pull away from each other
	var/pull_distance = 8
	var/user_back_dir = turn(get_dir(user, target), 180)
	var/target_back_dir = turn(get_dir(target, user), 180)
	var/user_back_dx = 0
	var/user_back_dy = 0
	var/target_back_dx = 0
	var/target_back_dy = 0
	switch(user_back_dir)
		if(NORTH)
			user_back_dy = pull_distance
		if(SOUTH)
			user_back_dy = -pull_distance
		if(EAST)
			user_back_dx = pull_distance
		if(WEST)
			user_back_dx = -pull_distance
		if(NORTHEAST)
			user_back_dx = pull_distance
			user_back_dy = pull_distance
		if(NORTHWEST)
			user_back_dx = -pull_distance
			user_back_dy = pull_distance
		if(SOUTHEAST)
			user_back_dx = pull_distance
			user_back_dy = -pull_distance
		if(SOUTHWEST)
			user_back_dx = -pull_distance
			user_back_dy = -pull_distance
	switch(target_back_dir)
		if(NORTH)
			target_back_dy = pull_distance
		if(SOUTH)
			target_back_dy = -pull_distance
		if(EAST)
			target_back_dx = pull_distance
		if(WEST)
			target_back_dx = -pull_distance
		if(NORTHEAST)
			target_back_dx = pull_distance
			target_back_dy = pull_distance
		if(NORTHWEST)
			target_back_dx = -pull_distance
			target_back_dy = pull_distance
		if(SOUTHEAST)
			target_back_dx = pull_distance
			target_back_dy = -pull_distance
		if(SOUTHWEST)
			target_back_dx = -pull_distance
			target_back_dy = -pull_distance
	animate(user, pixel_x = original_user_pixel_x + user_back_dx, pixel_y = original_user_pixel_y + user_back_dy, time = channel_time)
	animate(target, pixel_x = original_target_pixel_x + target_back_dx, pixel_y = original_target_pixel_y + target_back_dy, time = channel_time)
	

	// makes the guy stand up if he's laying down to keep sprites from breaking.
	if(target.lying)
		target.set_resting(FALSE)



	if(user.IsKnockdown()) // can't do it while on the floor.
		tracker.channeling_throw = FALSE
		user.stop_pulling(TRUE)
		to_chat(user, span_notice("I'm interupted!"))
		animate(user, pixel_x = original_user_pixel_x, pixel_y = original_user_pixel_y, transform = original_user_transform, time = 1 SECONDS) // reset animation
		animate(target, pixel_x = original_target_pixel_x, pixel_y = original_target_pixel_y, transform = original_target_transform, time = 1 SECONDS) // reset animation
		revert_cast()

		return FALSE

	if(!do_after(user, channel_time, target = target)) //saftey check
		tracker.channeling_throw = FALSE
		animate(user, pixel_x = original_user_pixel_x, pixel_y = original_user_pixel_y, transform = original_user_transform, time = 1 SECONDS) // reset animation
		animate(target, pixel_x = original_target_pixel_x, pixel_y = original_target_pixel_y, transform = original_target_transform, time = 1 SECONDS) // reset animation
		revert_cast()

		return FALSE

	
	
	// Ram into each other
	var/ram_distance = 16
	var/ram_dir = get_dir(user, target)
	var/target_ram_dir = turn(ram_dir, 180)
	var/user_ram_dx = 0
	var/user_ram_dy = 0
	var/target_ram_dx = 0
	var/target_ram_dy = 0
	switch(ram_dir)
		if(NORTH)
			user_ram_dy = ram_distance
		if(SOUTH)
			user_ram_dy = -ram_distance
		if(EAST)
			user_ram_dx = ram_distance
		if(WEST)
			user_ram_dx = -ram_distance
		if(NORTHEAST)
			user_ram_dx = ram_distance
			user_ram_dy = ram_distance
		if(NORTHWEST)
			user_ram_dx = -ram_distance
			user_ram_dy = ram_distance
		if(SOUTHEAST)
			user_ram_dx = ram_distance
			user_ram_dy = -ram_distance
		if(SOUTHWEST)
			user_ram_dx = -ram_distance
			user_ram_dy = -ram_distance
	switch(target_ram_dir)
		if(NORTH)
			target_ram_dy = ram_distance
		if(SOUTH)
			target_ram_dy = -ram_distance
		if(EAST)
			target_ram_dx = ram_distance
		if(WEST)
			target_ram_dx = -ram_distance
		if(NORTHEAST)
			target_ram_dx = ram_distance
			target_ram_dy = ram_distance
		if(NORTHWEST)
			target_ram_dx = -ram_distance
			target_ram_dy = ram_distance
		if(SOUTHEAST)
			target_ram_dx = ram_distance
			target_ram_dy = -ram_distance
		if(SOUTHWEST)
			target_ram_dx = -ram_distance
			target_ram_dy = -ram_distance
	animate(user, pixel_x = original_user_pixel_x + user_ram_dx, pixel_y = original_user_pixel_y + user_ram_dy, time = 0.5 SECONDS)
	animate(target, pixel_x = original_target_pixel_x + target_ram_dx, pixel_y = original_target_pixel_y + target_ram_dy, time = 0.5 SECONDS)
	
	// break grab
	user.stop_pulling(TRUE)
	// if we dont pause here they don't get tossed, this is also your chance to parry it. (sorry!)
	sleep(0.1 SECONDS)
	

	var/throw_dir = get_dir(user, target)
	var/turf/throw_target = get_ranged_target_turf(target, throw_dir, 3)
	
	

	if(target.has_status_effect(/datum/status_effect/buff/clash)) // if you parry this you knock down the guy and take no damage
		damage = 0
		user.Knockdown(2 SECONDS)
		target.safe_throw_at(throw_target, 2, 4, user, force = MOVE_FORCE_DEFAULT)
		target.remove_status_effect(/datum/status_effect/buff/clash)
		to_chat(user, span_notice("A reversal!"))
		playsound(user, 'sound/combat/crowdcheer.ogg', 100, TRUE) // sick parry dude
	
	else
		target.safe_throw_at(throw_target, 1, 4, user, force = MOVE_FORCE_DEFAULT)
		damage = 50
		target.Knockdown(2 SECONDS)
		user.Knockdown(2 SECONDS)
		playsound(user, 'sound/combat/tf2crit.ogg', 100, TRUE)
		to_chat(user, span_notice("[user] slams their forehead into [target]!"))
		var/def_zone = user.zone_selected || BODY_ZONE_CHEST // this one does the strike here to not eat the expose
		arcyne_strike(user, target, null, damage, def_zone, spell_name = "Stunner", skip_animation = TRUE)
	
		target.apply_status_effect(/datum/status_effect/debuff/vulnerable, vulnerable_dur)
	// using spellblade melee thing for the damage and aimed zone.

	tracker.channeling_throw = FALSE
	return TRUE


/datum/component/wrestle_combat_tracker // keeps track of if were channeling or not, used for all wrestling spells
	channeling_throw = FALSE
