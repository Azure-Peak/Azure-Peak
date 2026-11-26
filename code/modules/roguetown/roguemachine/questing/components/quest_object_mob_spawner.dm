/datum/component/quest_object/mob_spawner
	override_compatibility = TRUE
	no_outline = TRUE

/datum/component/quest_object/mob_spawner/Initialize(datum/quest/target_quest)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

/datum/component/quest_object/mob_spawner/on_quest_deleted(datum/source)
	if(QDELETED(parent))
		return

	qdel(parent)
	qdel(src)
