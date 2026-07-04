/datum/component/hunting_blocker
	/// Timestamp of when we last started a depth 0 track
	var/last_hunt_start = 0
	/// Cooldown period (90 seconds)
	var/hunt_cooldown = 90 SECONDS

/datum/component/hunting_blocker/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/hunting_blocker/proc/can_start_hunt()
	if(world.time < last_hunt_start + hunt_cooldown)
		var/time_left = DisplayTimeText(last_hunt_start + hunt_cooldown - world.time)
		to_chat(parent, span_warning("You've recently disturbed a fresh trail. You need to wait [time_left] before you can scout another new one."))
		return FALSE
	return TRUE

/datum/component/hunting_blocker/proc/register_hunt()
	last_hunt_start = world.time
