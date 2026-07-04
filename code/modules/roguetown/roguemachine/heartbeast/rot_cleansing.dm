/atom/movable/screen/alert/status_effect/buff/rot_cleansing
	name = "Rot cleansing"
	desc = "My body is fighting off the black rot. Being hit by more sources may diminish the effect, I should avoid exposure whilst I heal."
	icon_state = "rotcleanse"

#define ROT_CLEANSE_FILTER "rot_cleanse_filter"

/datum/status_effect/buff/rot_cleansing
	id = "rot_cleansing"
	tick_interval = 5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/rot_cleansing
	examine_text = "SUBJECTPRONOUN seems to have the rot afflicting them recede gradually."

	var/total_to_cleanse = 10
	var/currently_cleansed = 0
	var/stacks_per_cleanse = 1
	var/outline_colour = "#2a4b00"

/datum/status_effect/buff/rot_cleansing/on_creation(mob/living/new_owner, stacks_to_cleanse = 10, set_stacks_per_cleanse = 1)
	if(stacks_to_cleanse)
		total_to_cleanse = stacks_to_cleanse
	if(set_stacks_per_cleanse)
		stacks_per_cleanse = set_stacks_per_cleanse

	var/total_ticks = ceil(total_to_cleanse / stacks_per_cleanse)
	duration = total_ticks * tick_interval

	switch(stacks_per_cleanse)
		if(1 to 2)
			examine_text = "SUBJECTPRONOUN seems to have the rot afflicting them recede slowly."
		if(3 to 5)
			examine_text = "SUBJECTPRONOUN seems to have the rot afflicting them recede gradually."
		if(6 to 9)
			examine_text = "SUBJECTPRONOUN seems to have the rot afflicting them recede rapidly!"
		if(10 to INFINITY)
			examine_text = "SUBJECTPRONOUN is aggressively purging the rot afflicting them!"
	return ..()

/datum/status_effect/buff/rot_cleansing/on_apply()
	owner.add_filter(ROT_CLEANSE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 80, "size" = 1))
	return TRUE

/datum/status_effect/buff/rot_cleansing/tick()
	var/datum/status_effect/black_rot/rot = owner.has_status_effect(/datum/status_effect/black_rot)
	
	if(!rot || total_to_cleanse <= currently_cleansed)
		owner.remove_status_effect(src)
		return

	var/to_remove = min(stacks_per_cleanse, total_to_cleanse - currently_cleansed)
	rot.remove_stack(to_remove)
	currently_cleansed += to_remove

	if(!owner.has_status_effect(/datum/status_effect/black_rot) || total_to_cleanse <= currently_cleansed)
		owner.remove_status_effect(src)

/datum/status_effect/buff/rot_cleansing/on_remove()
	var/remainder = total_to_cleanse - currently_cleansed
	if(remainder > 0)
		var/datum/status_effect/black_rot/rot = owner.has_status_effect(/datum/status_effect/black_rot)
		if(rot)
			rot.remove_stack(remainder)
	owner.remove_filter(ROT_CLEANSE_FILTER)
	return ..()

/datum/status_effect/buff/rot_cleansing/proc/reduce_cleansing_cap(amount)
	total_to_cleanse = max(0, total_to_cleanse - amount)
	if(total_to_cleanse <= currently_cleansed)
		owner.remove_status_effect(src)

/datum/status_effect/buff/rot_cleansing/proc/can_override(new_stacks_to_cleanse, new_stacks_per_cleanse)
	var/remaining_current_cleanse = total_to_cleanse - currently_cleansed
	if(new_stacks_per_cleanse > src.stacks_per_cleanse)
		return TRUE
	if(new_stacks_to_cleanse > remaining_current_cleanse)
		return TRUE
	return FALSE

#undef ROT_CLEANSE_FILTER
