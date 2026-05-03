
/obj/effect/proc_holder/spell/invoked/dropkick // 1st of the grapple spells, this one does 50 damage and throws the target a good distance.
	name = "Dropkick"
	desc = "Requires an aggressive grab. After a brief wind up, kicks the target far away from you, knock both of you over."

	recharge_time = 60 SECONDS
	invocation_type = "emote"
	overlay_icon = 'icons/mob/roguehudgrabs.dmi'
	action_icon = 'icons/mob/roguehudgrabs.dmi'
	overlay_state = "grabbing"
	action_icon_state = "grabbing"
	var/damage = 0

/obj/effect/proc_holder/spell/invoked/dropkick/cast(list/targets, mob/living/user,)
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

	to_chat(user, span_notice("You begin lining up your kick onto [target]!"))
	to_chat(target, span_userdanger("[user] lines up for a massive kick!"))

	tracker.channeling_throw = TRUE
	user.emote("attack") // plays the sound effect
	
	// Store original position for animation
	var/original_pixel_x = user.pixel_x
	var/original_pixel_y = user.pixel_y
	var/original_pixel_z = user.pixel_z
	
	// Calculate back up direction (opposite of target direction)
	var/back_dir = turn(get_dir(user, target), 180)
	var/back_distance = 10
	var/back_dx = 0
	var/back_dy = 0
	switch(back_dir)
		if(NORTH)
			back_dy = back_distance
		if(SOUTH)
			back_dy = -back_distance
		if(EAST)
			back_dx = back_distance
		if(WEST)
			back_dx = -back_distance
		if(NORTHEAST)
			back_dx = back_distance
			back_dy = back_distance
		if(NORTHWEST)
			back_dx = -back_distance
			back_dy = back_distance
		if(SOUTHEAST)
			back_dx = back_distance
			back_dy = -back_distance
		if(SOUTHWEST)
			back_dx = -back_distance
			back_dy = -back_distance
	
	// Animate backing up during channel
	animate(user, pixel_x = original_pixel_x + back_dx, pixel_y = original_pixel_y + back_dy, time = channel_time)
	
	animate(user, pixel_z = original_pixel_z + 12, time = 2)
	
	if(user.IsKnockdown()) // can't do it while on the floor.
		tracker.channeling_throw = FALSE
		user.stop_pulling(TRUE)
		to_chat(user, span_notice("I'm interupted!"))
		revert_cast()
		animate(user, pixel_x = original_pixel_x, pixel_y = original_pixel_y, pixel_z = original_pixel_z, time = 1 SECONDS)
		return FALSE

	if(!do_after(user, channel_time, target = target)) //saftey check
		tracker.channeling_throw = FALSE
		revert_cast()
		animate(user, pixel_x = original_pixel_x, pixel_y = original_pixel_y, pixel_z = original_pixel_z, time = 1 SECONDS)
		return FALSE

	// break grab
	user.stop_pulling(TRUE)
	
	// if we dont pause here they don't get tossed, this is also your chance to parry it. (sorry!)
	sleep(0.1 SECONDS)
	
	// Throw the target away from the user and knocks you and the other guy down.
	var/throw_dir = get_dir(user, target)
	var/turf/throw_target = get_ranged_target_turf(target, throw_dir, 3)
	
	
	// Animate rushing forward
	var/rush_distance = 26
	var/rush_dx = 0
	var/rush_dy = 0
	switch(throw_dir)
		if(NORTH)
			rush_dy = rush_distance
		if(SOUTH)
			rush_dy = -rush_distance
		if(EAST)
			rush_dx = rush_distance
		if(WEST)
			rush_dx = -rush_distance
		if(NORTHEAST)
			rush_dx = rush_distance
			rush_dy = rush_distance
		if(NORTHWEST)
			rush_dx = -rush_distance
			rush_dy = rush_distance
		if(SOUTHEAST)
			rush_dx = rush_distance
			rush_dy = -rush_distance
		if(SOUTHWEST)
			rush_dx = -rush_distance
			rush_dy = -rush_distance
	animate(user, pixel_x = original_pixel_x + rush_dx, pixel_y = original_pixel_y + rush_dy, time = 2 SECONDS)
	
	// Reset position after rush
	animate(user, pixel_x = original_pixel_x, pixel_y = original_pixel_y, pixel_z = original_pixel_z, time = 1 SECONDS)
	
	if(target.has_status_effect(/datum/status_effect/buff/clash)) // if you parry this you knock down the guy and take no damage
		damage = 0
		user.Knockdown(2 SECONDS)
		target.safe_throw_at(throw_target, 2, 4, user, force = MOVE_FORCE_DEFAULT)
		target.remove_status_effect(/datum/status_effect/buff/clash)
		to_chat(user, span_notice("A reversal!"))
		playsound(user, 'sound/combat/crowdcheer.ogg', 100, TRUE) // sick parry dude
	
	else
		target.safe_throw_at(throw_target, 7, 4, user, force = MOVE_FORCE_OVERPOWERING)
		damage = 75
		target.Knockdown(2 SECONDS)
		user.Knockdown(2 SECONDS)
		playsound(user, 'sound/combat/tf2crit.ogg', 100, TRUE)
		to_chat(user, span_notice("[user] rushes forward and dropkicks [target]!"))


	// using spellblade melee thing for the damage and aimed zone.
	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	arcyne_strike(user, target, null, damage, def_zone, spell_name = "Dropkick", skip_animation = TRUE)
	tracker.channeling_throw = FALSE
	return TRUE

/datum/component/wrestle_combat_tracker // keeps track of if were channeling or not, used for all wrestling spells
	channeling_throw = FALSE
