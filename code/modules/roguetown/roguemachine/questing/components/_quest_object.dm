/datum/component/quest_object
	var/datum/weakref/quest_ref
	var/is_mob = FALSE
	var/no_outline = FALSE
	var/override_compatibility = FALSE
	var/outline_filter_id = "quest_item_outline"

/datum/component/quest_object/Initialize(datum/quest/target_quest)
	if(!override_compatibility && !isitem(parent) && !ismob(parent))
		return COMPONENT_INCOMPATIBLE

	quest_ref = WEAKREF(target_quest)
	is_mob = ismob(parent)

	if(!no_outline)
		if(is_mob)
			var/mob/M = parent
			M.add_filter(outline_filter_id, 2, list("type" = "outline", "color" = "#ff0000", "size" = 0.5))
			RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_target_death))
			RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_mob_examine))
		else
			var/obj/item/I = parent
			I.add_filter(outline_filter_id, 2, list("type" = "outline", "color" = "#008cff", "size" = 0.5))
			RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
			RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))
			RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_item_dropped))

	RegisterSignal(target_quest, COMSIG_PARENT_QDELETING, PROC_REF(on_quest_deleted))

/datum/component/quest_object/Destroy()
	if(QDELETED(parent))
		return ..()

	var/datum/quest/Q = quest_ref?.resolve()
	if(Q && !Q.complete && isitem(parent))
		var/obj/item/I = parent
		I.remove_filter(outline_filter_id)
		if(Q.quest_type == QUEST_COURIER && (Q.target_delivery_item && istype(I, Q.target_delivery_item)) && !QDELETED(I))
			Q.target_delivery_item = null
			qdel(I)

	return ..()

/datum/component/quest_object/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/datum/quest/Q = quest_ref.resolve()
	if(!Q || Q.complete || !holds_quest_scroll(user, Q))
		return
	examine_list += span_notice("This looks like an item you need for your contract: [Q.title]!")

/datum/component/quest_object/proc/on_mob_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/datum/quest/Q = quest_ref.resolve()
	if(!Q || Q.complete || !holds_quest_scroll(user, Q))
		return
	examine_list += span_notice("This looks like the target of your contract: [Q.title]!")
	if(Q.target_spawn_area != get_area_name(get_turf(parent)))
		examine_list += span_notice("It was last reported in the [Q.target_spawn_area] area.")

/datum/component/quest_object/proc/holds_quest_scroll(mob/user, datum/quest/Q)
	var/obj/item/quest_writ/scroll = Q.quest_scroll_ref?.resolve()
	return scroll && get(scroll, /mob) == user

/datum/component/quest_object/proc/on_target_death(mob/living/dead_mob, gibbed)
	SIGNAL_HANDLER

	var/datum/quest/Q = quest_ref.resolve()
	if(!Q || Q.complete)
		return

	dead_mob.remove_filter("quest_item_outline")

	Q.progress_current++
	Q.on_progress_update()

/datum/component/quest_object/proc/on_item_dropped(obj/item/dropped_item, mob/user)
	SIGNAL_HANDLER
	// Override in subtypes

/datum/component/quest_object/proc/on_quest_deleted(datum/source)
	SIGNAL_HANDLER

	if(QDELETED(parent))
		return

	var/datum/quest/Q = quest_ref?.resolve()

	if(ismob(parent))
		var/mob/M = parent
		M.remove_filter(outline_filter_id)
	else if(isitem(parent))
		var/obj/item/I = parent
		I.remove_filter(outline_filter_id)
		if(Q && !Q.complete && Q.is_contract_item(I))
			qdel(I)
	qdel(src)
