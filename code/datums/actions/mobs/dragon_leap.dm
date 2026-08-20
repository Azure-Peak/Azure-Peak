/datum/action/cooldown/mob_cooldown/dragon_leap
	name = "Dragon Leap"
	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "fireball"
	desc = "Leap towards the enemy!"
	cooldown_time = 15 SECONDS
	var/cast_time	= 1 SECONDS
	
	var/range = 8

/datum/action/cooldown/mob_cooldown/dragon_leap/Activate(atom/target)
	if(!target || target == owner)
		return FALSE
	var/dist = get_dist(owner, target)
	if(can_see(owner, target, range) && dist < range && dist > 1) //can see, in range and not adjacent
		owner.visible_message(span_alert("[owner] leans back on its haunches, eyeing [target]."))
		addtimer(CALLBACK(src, PROC_REF(leap_target), target), cast_time)
		StartCooldown()
	return TRUE


/datum/action/cooldown/mob_cooldown/dragon_leap/proc/leap_target(atom/target)

	if(!QDELETED(target))
		return
	var/turf/cur_turf = get_turf(target)
	if(!cur_turf)
		return
	
//Check damage here
	if(cur_turf.can_traverse_safely(owner))
		owner.throw_at(target = target, range = range, speed = 0.3, thrower = owner, spin = 0, diagonals_first = FALSE, callback = CALLBACK(src, PROC_REF(leapt_on_target), target), force = 1)

		return
	
	//if we can't land on their turf, look for adjacent turf as tar
	var/list/open_turfs = list()

	for(var/turf/possible_turf in get_adjacent_open_turfs(target))
		if(possible_turf.is_blocked_turf() && possible_turf.can_traverse_safely(owner))
			continue
		open_turfs += possible_turf

	if(!length(open_turfs))//They are in the perfect no jumping spot. We lose.
		owner.visible_message(span_alert("[owner] roars in frustration."))
		return

	var/turf/final_turf = get_closest_atom(/turf, open_turfs, owner)
	owner.visible_message(span_alert("[owner] leaps into the air and lands near [target]!"))
	owner.throw_at(target = final_turf, range = range, speed = 0.3, thrower = owner, spin = 0, diagonals_first = FALSE, callback = null, force = 1)

/datum/action/cooldown/mob_cooldown/dragon_leap/proc/leapt_on_target(mob/living/victim)
	owner.visible_message(span_alert("[owner] leaps into the air and lands atop [victim]!"))
	if(!QDELETED(victim))
		victim.OffBalance(30)
