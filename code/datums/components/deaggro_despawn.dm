/datum/component/deaggro_despawn
	var/delay
	var/last_aggro

/datum/component/deaggro_despawn/Initialize(delay)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	src.delay = delay
	last_aggro = world.time
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_death))
	START_PROCESSING(SSprocessing, src)

/datum/component/deaggro_despawn/Destroy(force)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/deaggro_despawn/proc/on_death(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/deaggro_despawn/process()
	var/mob/living/living_parent = parent
	var/datum/ai_controller/controller = living_parent.ai_controller
	if(!controller || living_parent.client || controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		last_aggro = world.time
		return
	if(world.time < last_aggro + delay)
		return
	for(var/obj/structure/flora/flora in view(6, living_parent))
		if(istype(flora, /obj/structure/flora/roguetree/stump))
			continue
		if(istype(flora, /obj/structure/flora/roguetree) || istype(flora, /obj/structure/flora/rogueshroom))
			qdel(living_parent)
			return
