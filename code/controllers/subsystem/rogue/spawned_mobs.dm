#define SPAWNED_MOBS_DEFAULT_LIFESPAN 10 MINUTES

GLOBAL_LIST_INIT(spawnmob_lifespan, list(
	"Necromancer" = 15 MINUTES,
	"Lich" = 60 MINUTES
))

GLOBAL_LIST_INIT(spawnmob_lifespan_override, list())

SUBSYSTEM_DEF(spawned_mobs)
	name = "Spawned Mob Cull"
	wait = 30 SECONDS
	flags = SS_BACKGROUND | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/list/tracked_mobs = list()
	var/list/currentrun = list()

/datum/controller/subsystem/spawned_mobs/stat_entry()
	..("T:[length(tracked_mobs)]")

/datum/controller/subsystem/spawned_mobs/fire(resumed = FALSE)
	if(!resumed)
		currentrun = list()
		for(var/datum/weakref/mobref as anything in tracked_mobs)
			currentrun += mobref

	while(currentrun.len)
		var/datum/weakref/mobref = currentrun[currentrun.len]
		currentrun.len--

		var/expires = tracked_mobs[mobref]
		if(!expires)
			if(MC_TICK_CHECK)
				return
			continue

		var/mob/living/target = mobref.resolve()
		if(!target || QDELETED(target) || target.stat == DEAD || target.client)
			unregister_mob(mobref, target)
			if(MC_TICK_CHECK)
				return
			continue

		if(expires <= world.time)
			unregister_mob(mobref, target)
			target.visible_message(span_warning("[target] unravels as the power binding it expires!"))
			target.death(FALSE)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/spawned_mobs/proc/get_role_lifespan(role)
	if(role && GLOB.spawnmob_lifespan[role])
		return GLOB.spawnmob_lifespan[role]

/datum/controller/subsystem/spawned_mobs/proc/get_type_lifespan(mob/living/target)
	var/current_type = target?.type
	while(current_type)
		if(GLOB.spawnmob_lifespan_override[current_type])
			return GLOB.spawnmob_lifespan_override[current_type]
		current_type = type2parent(current_type)

/datum/controller/subsystem/spawned_mobs/proc/get_lifespan(mob/living/target, mob/living/summoner, lifespan)
	if(isnum(lifespan))
		return lifespan

	var/type_lifespan = get_type_lifespan(target)
	if(type_lifespan)
		return type_lifespan

	var/role_lifespan = get_role_lifespan(summoner?.advjob)
	if(role_lifespan)
		return role_lifespan

	role_lifespan = get_role_lifespan(summoner?.job)
	if(role_lifespan)
		return role_lifespan

	role_lifespan = get_role_lifespan(summoner?.mind?.assigned_role)
	if(role_lifespan)
		return role_lifespan

	return SPAWNED_MOBS_DEFAULT_LIFESPAN

/datum/controller/subsystem/spawned_mobs/proc/register_mob(mob/living/target, mob/living/summoner, lifespan)
	if(!target || target.client)
		return FALSE

	var/timer = get_lifespan(target, summoner, lifespan)
	if(!isnum(timer) || timer <= 0 || timer == INFINITY)
		return FALSE

	var/datum/weakref/mobref = WEAKREF(target)
	if(!tracked_mobs[mobref])
		RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_mob_examine))
	tracked_mobs[mobref] = world.time + timer
	return TRUE

/datum/controller/subsystem/spawned_mobs/proc/unregister_mob(datum/weakref/mobref, mob/living/target)
	tracked_mobs -= mobref
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_EXAMINE)

/datum/controller/subsystem/spawned_mobs/proc/get_remaining_lifespan(mob/living/target)
	if(!target || target.client || target.stat == DEAD)
		return 0

	var/expires = tracked_mobs[WEAKREF(target)]
	if(!expires)
		return 0

	return max(0, expires - world.time)

/datum/controller/subsystem/spawned_mobs/proc/on_mob_examine(mob/living/source, mob/user, list/examine_list)
	var/remaining_lifespan = get_remaining_lifespan(source)
	if(!remaining_lifespan)
		return

	examine_list += span_notice("A fading force binds [source] together. It will last for [DisplayTimeText(remaining_lifespan)].")

/proc/apply_mob_lifespan(mob/living/target, mob/living/summoner, lifespan)
	return SSspawned_mobs.register_mob(target, summoner, lifespan)

#undef SPAWNED_MOBS_DEFAULT_LIFESPAN
