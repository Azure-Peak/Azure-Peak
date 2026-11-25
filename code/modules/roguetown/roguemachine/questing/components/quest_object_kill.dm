/datum/component/quest_object/kill
	var/counted = FALSE

/datum/component/quest_object/kill/Initialize(datum/quest/target_quest)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_parent_qdel))

/datum/component/quest_object/kill/on_target_death(mob/living/dead_mob, gibbed)
	dead_mob?.remove_filter("quest_item_outline")
	count_kill()

/datum/component/quest_object/kill/proc/on_parent_qdel(datum/source)
	SIGNAL_HANDLER
	count_kill()

/datum/component/quest_object/kill/proc/count_kill()
	if(counted)
		return
	counted = TRUE
	var/datum/quest/Q = quest_ref?.resolve()
	if(!Q || Q.complete)
		return
	var/datum/quest/kill/KQ = Q
	if(istype(KQ))
		if(KQ.failed)
			return
		KQ.last_guardian_kill = world.time
		KQ.on_guardian_killed()
		if(!KQ.kills_count_progress)
			return
	Q.progress_current++
	Q.on_progress_update()
