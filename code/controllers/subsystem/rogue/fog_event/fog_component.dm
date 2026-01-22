/datum/component/fogged
	// Only allow one of these components per mob
	dupe_mode = COMPONENT_DUPE_UNIQUE

	// Configurable variables
	var/ambush_chance = 50 // 2% chance per step
	var/ambush_cooldown = 30 SECONDS // Don't spam spawn volfs
	var/last_ambush_time = 0

/datum/component/fogged/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	// Listen for movement
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/on_moved)

/datum/component/fogged/proc/on_moved()
	// Check cooldown
	if(world.time < last_ambush_time + ambush_cooldown)
		return

	// Roll dice
	if(prob(ambush_chance))
		trigger_ambush()

/datum/component/fogged/proc/trigger_ambush()
	var/mob/living/victim = parent
	
	// 1. Play scary sound
	victim.playsound_local(victim, 'sound/misc/jumpscare (1).ogg', 100, FALSE)
	to_chat(victim, span_userdanger("You feel eyes watching you from the fog..."))

	var/turf/T = get_step(victim, pick(SOUTH, NORTH, WEST, EAST))
	if(!T || T.is_blocked_turf())
		T = get_turf(victim)

	new /mob/living/simple_animal/hostile/retaliate/rogue/wolf(T)

	last_ambush_time = world.time
