/// Quest ambush payload component.
/// Attached to a quest mob silently. When the mob dies, spawns ambush mobs from the
/// stored ambush_config and notifies the killer that they walked into an ambush.
/// No extra reward is given for killing ambush mobs.

/datum/component/quest_ambush_payload
	/// The /datum/ambush_config typepath to spawn on death
	var/ambush_config_type
	/// Whether the ambush has already triggered (prevent double-fire)
	var/triggered = FALSE

/datum/component/quest_ambush_payload/Initialize(ambush_config_path)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	ambush_config_type = ambush_config_path
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_carrier_death))

/datum/component/quest_ambush_payload/Destroy()
	UnregisterSignal(parent, COMSIG_MOB_DEATH)
	return ..()

/datum/component/quest_ambush_payload/proc/on_carrier_death(mob/living/dead_mob, gibbed)
	SIGNAL_HANDLER

	if(triggered)
		return
	triggered = TRUE

	// Defer spawning to next tick to avoid issues in the death chain
	INVOKE_ASYNC(src, PROC_REF(trigger_ambush), dead_mob)

/datum/component/quest_ambush_payload/proc/trigger_ambush(mob/living/dead_mob)
	var/turf/death_turf = get_turf(dead_mob)
	if(!death_turf)
		qdel(src)
		return

	var/datum/ambush_config/config = new ambush_config_type
	if(!length(config.mob_types))
		qdel(config)
		qdel(src)
		return

	var/list/spawned_mobs = list()
	for(var/mob_type in config.mob_types)
		var/count = config.mob_types[mob_type]
		for(var/i in 1 to count)
			var/turf/spawn_turf = find_ambush_spawn_turf(death_turf)
			var/mob/living/ambush_mob = new mob_type(spawn_turf)
			ambush_mob.faction |= "quest_ambush"
			spawned_mobs += ambush_mob

	qdel(config)

	// Notify nearby players
	for(var/mob/living/carbon/human/player in get_hearers_in_view(world.view, death_turf))
		if(!player.client)
			continue
		to_chat(player, span_boldwarning("You've walked into an ambush!"))

	qdel(src)

/datum/component/quest_ambush_payload/proc/find_ambush_spawn_turf(turf/center)
	var/list/possible_turfs = list()
	for(var/turf/open/floor/T in view(4, center))
		if(T.density)
			continue
		var/blocked = FALSE
		for(var/obj/O in T)
			if(O.density)
				blocked = TRUE
				break
		if(!blocked)
			possible_turfs += T

	return length(possible_turfs) ? pick(possible_turfs) : center