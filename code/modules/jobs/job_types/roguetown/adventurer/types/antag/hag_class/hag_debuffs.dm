/datum/status_effect/debuff/hag_curse
	id = "Generic hag curse"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/excomm
	// We neither need processing, and are removed by special conditions.
	duration = -1
	needs_processing = FALSE
	var/boon_type
	var/datum/component/hag_curio_tracker/tracker_ref
	var/curse_points = 1

/atom/movable/screen/alert/status_effect/debuff/hag_curse
	name = "Cursed by the hag!"
	desc = "This is a generic curse!"
	icon_state = "debuff"

/datum/status_effect/debuff/hag_curse/on_creation(mob/living/new_owner, set_boon_type, datum/component/hag_curio_tracker/set_tracker, set_points)
	src.boon_type = set_boon_type
	src.tracker_ref = set_tracker
	// Just in case no points are passed along.
	if(set_points)
		src.curse_points = set_points

	return ..()

/datum/status_effect/debuff/hag_curse/on_remove()
	if(tracker_ref && owner)
		// Send signal to the tracker: (Victim's Name, The Type of Curse Cleared)
		var/mob/living/carbon/C = owner
		SEND_SIGNAL(tracker_ref, COMSIG_STATUS_EFFECT_HAG_CURSE_CLEARED, C.real_name, boon_type)
	return ..()

/datum/status_effect/debuff/hag_curse/rotting_touch
	id = "rotting_touch"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hag_curse/rotting_touch

/datum/status_effect/debuff/hag_curse/rotting_touch/on_apply()
	. = ..()
	if(!.)
		return
	RegisterSignal(owner, COMSIG_ITEM_EQUIPPED, PROC_REF(handle_touch))
	return TRUE

/datum/status_effect/debuff/hag_curse/rotting_touch/proc/handle_touch(mob/living/L, obj/item/I, slot)
	SIGNAL_HANDLER

	// Only hands, only food
	if(!(slot & ITEM_SLOT_HANDS) || !istype(I, /obj/item/reagent_containers/food/snacks))
		return

	var/obj/item/reagent_containers/food/snacks/food = I

	// Check if it's already rotten to avoid wasting a curse point on a literal piece of garbage
	if(food.eat_effect == /datum/status_effect/debuff/rotfood)
		return

	to_chat(L, span_warning("Your touch withers \the [food] instantly!"))
	food.become_rotten()

	// Reusing my mushroom cloud because it's rot-like
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/spore(get_turf(L))
	H.color = "#4b5320" 
	curse_points--

	if(curse_points <= 0)
		to_chat(L, span_notice("The oily, putrid sensation in your hands finally fades."))
		owner.remove_status_effect(src)

/atom/movable/screen/alert/status_effect/debuff/hag_curse/rotting_touch
	name = "Rotten Touch"
	desc = "Your touch is a blight upon the world's bounty. Everything you attempt to eat turns to rot."
	icon_state = "debuff"
