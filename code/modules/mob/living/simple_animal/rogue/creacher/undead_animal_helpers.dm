
/datum/component/infection_spreader
	var/infection_chance = 20
	//More time than a standard infection to compensate for the fact these things will dwell in the woods.
	var/infection_timer = 5 MINUTES

/datum/component/infection_spreader/Initialize()
	. = ..()
	if(!istype(parent, /mob/living))
		return COMPONENT_INCOMPATIBLE

/datum/component/infection_spreader/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOB_AFTERATTACK_SUCCESS, PROC_REF(on_bite))

/datum/component/infection_spreader/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOB_AFTERATTACK_SUCCESS)

/datum/component/infection_spreader/proc/on_bite(mob/living/source, mob/living/target)
	SIGNAL_HANDLER
	if(prob(infection_chance) && ishuman(target))
		var/mob/living/carbon/human/H = target
		// This looks really weird but because checking antag statuses makes a DB call that sleeps a proc at some point, it's not allowed to run as is within a component....
		// I've solved this here by executing the check asyncrously on the next tick.
		addtimer(CALLBACK(src, PROC_REF(try_infect_human), H), 0)

/datum/component/infection_spreader/proc/try_infect_human(mob/living/carbon/human/H)
	if(QDELETED(H) || !H.zombie_check_can_convert())
		return
	to_chat(H, span_danger("A growing cold seeps into my body. I feel horrible... REALLY horrible..."))
	H.infected = TRUE
	H.apply_status_effect(/datum/status_effect/zombie_infection, infection_timer, "wound")

GLOBAL_LIST_INIT(animal_to_undead, list(
	/mob/living/simple_animal/hostile/retaliate/rogue/saiga = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/wolf = /mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead,
))
#define ZOMBIE_REANIMATION_CHANCE 25
#define ZOMBIE_REANIMATION_TIMER 15 MINUTES

/datum/component/deadite_animal_reanimation
	var/reanimation_timer
	var/undead_to_spawn

/datum/component/deadite_animal_reanimation/Initialize()
	if(!istype(parent, /mob/living/simple_animal))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/simple_animal/mob = parent
	if(mob.stat != DEAD || !GLOB.animal_to_undead[mob.type])
		//unregister here not to throw runtimes in intended cases.
		UnregisterFromParent()
		return

	//KEEP IN MIND. IF YOU EDIT THIS TIMER TO BE LONGER THAN THE ROT COMPONENT, YOU WILL BREAK THIS.
	reanimation_timer = addtimer(CALLBACK(src, PROC_REF(reanimate)), get_reanimation_time(), TIMER_STOPPABLE)

/datum/component/deadite_animal_reanimation/proc/reanimate()
	var/mob/living/simple_animal/mob = parent
	if(!prob(get_reanimation_chance()) || QDELETED(mob) || mob.stat != DEAD)
		UnregisterFromParent()
		return

	var/undead_type = GLOB.animal_to_undead[mob.type]
	new undead_type(mob.loc)
	mob.visible_message(span_danger("[mob] walks again... As a terrifying deadite!"))

	qdel(mob)

/datum/component/deadite_animal_reanimation/proc/get_reanimation_chance()
	if(has_world_trait(/datum/world_trait/zizo_pet_cementery))
		return 100
	return ZOMBIE_REANIMATION_CHANCE

/datum/component/deadite_animal_reanimation/proc/get_reanimation_time()
	if(has_world_trait(/datum/world_trait/zizo_pet_cementery))
		return 1.5 MINUTES
	return ZOMBIE_REANIMATION_TIMER


#undef ZOMBIE_REANIMATION_CHANCE
#undef ZOMBIE_REANIMATION_TIMER
