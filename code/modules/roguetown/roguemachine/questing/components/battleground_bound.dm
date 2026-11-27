/datum/component/battleground_bound
	var/turf/center
	var/range
	var/turf/last_inside
	var/next_message = 0

/datum/component/battleground_bound/Initialize(turf/center, range)
	if(!isliving(parent) || !center)
		return COMPONENT_INCOMPATIBLE
	src.center = center
	src.range = range
	last_inside = get_turf(parent)

/datum/component/battleground_bound/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_step))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/datum/component/battleground_bound/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED))

/datum/component/battleground_bound/Destroy()
	center = null
	last_inside = null
	return ..()

/datum/component/battleground_bound/proc/is_inside(turf/T)
	return T && is_in_zweb(T.z, center.z) && max(abs(T.x - center.x), abs(T.y - center.y)) <= range

/datum/component/battleground_bound/proc/check_step(atom/movable/source, atom/newloc)
	SIGNAL_HANDLER
	if(is_inside(get_turf(newloc)) || !is_inside(get_turf(source)))
		return
	warn("An unknown force holds you back. Stand and fight.")
	return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/component/battleground_bound/proc/on_moved(atom/movable/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	var/turf/T = get_turf(source)
	if(is_inside(T))
		last_inside = T
		return
	INVOKE_ASYNC(src, PROC_REF(pull_back))

/datum/component/battleground_bound/proc/pull_back()
	var/mob/living/L = parent
	if(QDELETED(L) || is_inside(get_turf(L)))
		return
	if(L.buckled)
		L.buckled.unbuckle_mob(L, TRUE)
	L.forceMove(last_inside || center)
	warn("An unknown force drags you back. Stand and fight.")

/datum/component/battleground_bound/proc/warn(message)
	if(world.time < next_message)
		return
	next_message = world.time + BATTLEGROUND_LEASH_MESSAGE_COOLDOWN
	to_chat(parent, span_userdanger(message))
