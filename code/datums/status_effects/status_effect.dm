//Status effects are used to apply temporary or permanent effects to mobs. Mobs are aware of their status effects at all times.
//This file contains their code, plus code for applying and removing them.
//When making a new status effect, add a define to status_effects.dm in __DEFINES for ease of use!

/mob/living
	/// ass list [id] = /datum/status_effect. ATTENTION THE CODER IS A RETARD THIS IS NOT SUPPOSED TO BE HERE I REPEART!!!!!!
	var/list/status_effects_by_id

/datum/status_effect
	/// The ID of the effect. ID is used in adding and removing effects to check for duplicates, among other things.
	var/id = "effect"
	/// When set initially / in on_creation, this is how long the status effect lasts in deciseconds.
	/// While processing, this becomes the world.time when the status effect will expire.
	/// -1 = infinite duration.
	var/duration = -1
	/// When set initially / in on_creation, this is how long between [proc/tick] calls in deciseconds.
	/// Note that this cannot be faster than the processing subsystem you choose to fire the effect on. (See: [var/processing_speed])
	/// While processing, this becomes the world.time when the next tick will occur.
	/// -1 = will prevent ticks, and if duration is also unlimited (-1), stop processing wholesale.
	var/tick_interval = 1 SECONDS
	/// The mob affected by the status effect.
	var/mob/living/owner
	/// How many of the effect can be on one mob, and/or what happens when you try to add a duplicate.
	var/status_type = STATUS_EFFECT_UNIQUE
	/// If TRUE, we call [proc/on_remove] when owner is deleted. Otherwise, we call [proc/be_replaced].
	var/on_remove_on_mob_delete = FALSE
	/// If defined, this text will appear when the mob is examined - to use he, she etc.
	/// use "SUBJECTPRONOUN" and replace it in the examines themselves
	var/examine_text
	/// The typepath to the alert thrown by the status effect when created.
	/// Status effect "name"s and "description"s are shown to the owner here.
	var/alert_type = /atom/movable/screen/alert/status_effect
	/// The alert itself, created in [proc/on_creation] (if alert_type is specified).
	var/atom/movable/screen/alert/status_effect/linked_alert = null
	/// Each entry defines a stat affected by the status effect during its duration.
	var/list/effectedstats = list()


	///Icon path for this effect's on-mob effect.
	var/mob_effect_icon = 'icons/mob/mob_effects.dmi'
	var/mob_effect_icon_state
	///How long the effect is meant to last. Will default to the duration otherwise.
	var/mob_effect_dur
	///The layer for the mob effect, keeping this unique (even by a 0.01) will ensure it gets deleted properly.
	var/mob_effect_layer = ABOVE_MOB_LAYER
	var/mob_effect_offset_x
	var/mob_effect_offset_y
	///A direct reference to the generated mob effect post-creation. Used for manipulation (or deletion) of the effect. Normally expires.
	var/atom/mob_effect

/datum/status_effect/New(list/arguments)
	on_creation(arglist(arguments))

/datum/status_effect/proc/on_creation(mob/living/new_owner, ...)
	testing("oncreation")
	if(new_owner)
		owner = new_owner
	if(owner)
		// ass list
		LAZYINITLIST(owner.status_effects)
		LAZYINITLIST(owner.status_effects_by_id)
		LAZYADD(owner.status_effects, src)
		owner.status_effects_by_id[id] = src

	if(!owner)
		qdel(src)
		return

	if(mob_effect_icon_state)
		if(!mob_effect_dur)
			mob_effect_dur = (duration - 1)	//-1 tick juuust in case something goes wrong between status effect deletion and the callback of the appearance itself.
		mob_effect = owner.play_overhead_indicator_flick(mob_effect_icon, mob_effect_icon_state, mob_effect_dur, mob_effect_layer, null, mob_effect_offset_y, mob_effect_offset_x)
		mob_effect.plane = ABOVE_LIGHTING_PLANE

	if(!on_apply())
		on_remove()
		qdel(src)
		return

	if(duration != -1)
		duration = world.time + duration
	tick_interval = world.time + tick_interval
	if(alert_type)
		var/atom/movable/screen/alert/status_effect/A = owner.throw_alert(id, alert_type)
		A?.attached_effect = src //so the alert can reference us, if it needs to
		linked_alert = A //so we can reference the alert, if we need to

	START_PROCESSING(SSfastprocess, src)
	return TRUE

/datum/status_effect/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(owner)
		linked_alert = null
		owner.clear_alert(id)

		// Remove+remove probably twice
		LAZYREMOVE(owner.status_effects, src)
		if(owner.status_effects_by_id && owner.status_effects_by_id[id] == src)
			owner.status_effects_by_id -= id

		on_remove()
		owner = null

	effectedstats = list()
	return ..()

/datum/status_effect/process(wait)
	if(QDELETED(owner))
		qdel(src)
		return
	if(tick_interval < world.time)
		tick(wait)
		tick_interval = world.time + initial(tick_interval)
	if(duration != -1 && duration < world.time)
		qdel(src)

/datum/status_effect/proc/on_apply() //Called whenever the buff is applied; returning FALSE will cause it to autoremove itself.
	for(var/S in effectedstats)
		if(effectedstats[S] < 0)	//We only care about negative bonuses here
			if((owner.get_stat(S) + effectedstats[S]) < 1)	//The status effect would reduce our stats beyond the limit of !1! Not 0.
				for(var/i in 1 to abs(effectedstats[S]))
					if((owner.get_stat(S) + (effectedstats[S] + i)) == 1)	//We keep incrementing the status effect until it will reduce it to 1.
						effectedstats[S] = (effectedstats[S] + i)
						break
		else
			if((owner.get_stat(S) + effectedstats[S]) > 20)	//We check for overflow as well.
				effectedstats[S] = 20 - owner.get_stat(S)
		owner.change_stat(S, effectedstats[S])
	return TRUE

/datum/status_effect/proc/tick() //Called every tick.

/datum/status_effect/proc/on_remove() //Called whenever the buff expires or is removed; do note that at the point this is called, it is out of the owner's status_effects but owner is not yet null
	for(var/S in effectedstats)
		owner.change_stat(S, -(effectedstats[S]))
	if(mob_effect)
		owner.clear_overhead_indicator(mob_effect, mob_effect_layer)

/datum/status_effect/proc/be_replaced() //Called instead of on_remove when a status effect is replaced by itself or when a status effect with on_remove_on_mob_delete = FALSE has its mob deleted
	for(var/S in effectedstats)
		owner.change_stat(S, -(effectedstats[S]))
	owner.clear_alert(id)

	if(owner)
		LAZYREMOVE(owner.status_effects, src)
		if(owner.status_effects_by_id && owner.status_effects_by_id[id] == src)
			owner.status_effects_by_id -= id
		owner = null

	qdel(src)

/datum/status_effect/proc/refresh()
	var/original_duration = initial(duration)
	if(original_duration == -1)
		return
	duration = world.time + original_duration

//clickdelay/nextmove modifiers!
/datum/status_effect/proc/nextmove_modifier()
	return 1

/datum/status_effect/proc/nextmove_adjust()
	return 0

////////////////
// ALERT HOOK //
////////////////

/atom/movable/screen/alert/status_effect
	name = "Curse of Mundanity"
	desc = ""
	var/datum/status_effect/attached_effect

/atom/movable/screen/alert/status_effect/examine_ui(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	if(desc)
		inspec += "<br>[desc]"

	for(var/S in attached_effect?.effectedstats)
		if(attached_effect.effectedstats[S] > 0)
			inspec += "<br><span class='purple'>[S]</span> \Roman [attached_effect.effectedstats[S]]"
		if(attached_effect.effectedstats[S] < 0)
			var/newnum = attached_effect.effectedstats[S] * -1
			inspec += "<br><span class='danger'>[S]</span> \Roman [newnum]"

	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")

/atom/movable/screen/alert/status_effect/Destroy()
	attached_effect = null
	return ..()

//////////////////
// HELPER PROCS //
//////////////////

// applies a given status effect to this mob, returning the effect if it was successful
/mob/living/proc/apply_status_effect(effect, ...)
	. = FALSE
	LAZYINITLIST(status_effects)
	LAZYINITLIST(status_effects_by_id)

	var/datum/status_effect/template = effect
	var/effect_id = initial(template.id)

	var/list/arguments = args.Copy()
	arguments[1] = src

	// ID CHECK
	var/datum/status_effect/current = status_effects_by_id[effect_id]

	if(current && current.status_type)
		if(current.status_type == STATUS_EFFECT_REPLACE)
			// Remove old create one
			current.be_replaced(arglist(arguments))
		else if(current.status_type == STATUS_EFFECT_REFRESH)
			// Refresh update current's timer if we already have the effect
			current.refresh(arglist(arguments))
			return
		else
			// STATUS_EFFECT_UNIQUE we need only 1 per time
			return

	// No old effect or its been removed (apply brand new)
	var/datum/status_effect/new_effect = new effect(arguments)
	. = new_effect

// removes all of a given status effect from this mob, returning TRUE if at least one was removed
/mob/living/proc/remove_status_effect(effect)
	. = FALSE
	if(!status_effects_by_id)
		return

	var/datum/status_effect/template = effect
	var/effect_id = initial(template.id)

	var/datum/status_effect/S = status_effects_by_id[effect_id]
	if(S)
		qdel(S)
		. = TRUE

/mob/living/proc/has_status_effect(datum/status_effect/checked_effect)
	RETURN_TYPE(/datum/status_effect)

	if(!status_effects_by_id)
		return null

	var/effect_id = initial(checked_effect.id)
	return status_effects_by_id[effect_id]

/mob/living/proc/has_status_effect_list(datum/status_effect/checked_effect)
	RETURN_TYPE(/list)

	var/list/effects_found = list()
	if(!status_effects_by_id)
		return effects_found

	var/effect_id = initial(checked_effect.id)
	var/datum/status_effect/S = status_effects_by_id[effect_id]
	if(S)
		effects_found += S

	return effects_found

//////////////////////
// STACKING EFFECTS //
//////////////////////

/datum/status_effect/stacking
	id = "stacking_base"
	duration = -1 //removed under specific conditions
	alert_type = null
	var/stacks = 0 //how many stacks are accumulated, also is # of stacks that target will have when first applied
	var/delay_before_decay //deciseconds until ticks start occuring, which removes stacks (first stack will be removed at this time plus tick_interval)
	tick_interval = 10 //deciseconds between decays once decay starts
	var/stack_decay = 1 //how many stacks are lost per tick (decay trigger)
	var/stack_threshold //special effects trigger when stacks reach this amount
	var/max_stacks //stacks cannot exceed this amount
	var/consumed_on_threshold = TRUE //if status should be removed once threshold is crossed
	var/threshold_crossed = FALSE //set to true once the threshold is crossed, false once it falls back below
	var/overlay_file
	var/underlay_file
	var/overlay_state // states in .dmi must be given a name followed by a number which corresponds to a number of stacks. put the state name without the number in these state vars
	var/underlay_state // the number is concatonated onto the string based on the number of stacks to get the correct state name
	var/mutable_appearance/status_overlay
	var/mutable_appearance/status_underlay

/datum/status_effect/stacking/proc/threshold_cross_effect() //what happens when threshold is crossed

/datum/status_effect/stacking/proc/stacks_consumed_effect() //runs if status is deleted due to threshold being crossed

/datum/status_effect/stacking/proc/fadeout_effect() //runs if status is deleted due to being under one stack

/datum/status_effect/stacking/proc/stack_decay_effect() //runs every time tick() causes stacks to decay

/datum/status_effect/stacking/proc/on_threshold_cross()
	threshold_cross_effect()
	if(consumed_on_threshold)
		stacks_consumed_effect()
		qdel(src)

/datum/status_effect/stacking/proc/on_threshold_drop()

/datum/status_effect/stacking/proc/can_have_status()
	return owner.stat != DEAD

/datum/status_effect/stacking/proc/can_gain_stacks()
	return owner.stat != DEAD

/datum/status_effect/stacking/tick()
	if(!can_have_status())
		qdel(src)
	else
		add_stacks(-stack_decay)
		stack_decay_effect()

/datum/status_effect/stacking/proc/add_stacks(stacks_added)
	if(stacks_added > 0 && !can_gain_stacks())
		return FALSE
	owner.cut_overlay(status_overlay)
	owner.underlays -= status_underlay
	stacks += stacks_added
	if(stacks > 0)
		if(stacks >= stack_threshold && !threshold_crossed) //threshold_crossed check prevents threshold effect from occuring if changing from above threshold to still above threshold
			threshold_crossed = TRUE
			on_threshold_cross()
		else if(stacks < stack_threshold && threshold_crossed)
			threshold_crossed = FALSE //resets threshold effect if we fall below threshold so threshold effect can trigger again
			on_threshold_drop()
		if(stacks_added > 0)
			tick_interval += delay_before_decay //refreshes time until decay
		stacks = min(stacks, max_stacks)
		status_overlay.icon_state = "[overlay_state][stacks]"
		status_underlay.icon_state = "[underlay_state][stacks]"
		owner.add_overlay(status_overlay)
		owner.underlays += status_underlay
	else
		fadeout_effect()
		qdel(src) //deletes status if stacks fall under one

/datum/status_effect/stacking/on_creation(mob/living/new_owner, stacks_to_apply)
	..()
	src.add_stacks(stacks_to_apply)

/datum/status_effect/stacking/on_apply()
	if(!can_have_status())
		return FALSE
	status_overlay = mutable_appearance(overlay_file, "[overlay_state][stacks]")
	status_underlay = mutable_appearance(underlay_file, "[underlay_state][stacks]")
	var/icon/I = icon(owner.icon, owner.icon_state, owner.dir)
	var/icon_height = I.Height()
	status_overlay.pixel_x = -owner.pixel_x
	status_overlay.pixel_y = FLOOR(icon_height * 0.25, 1)
	status_overlay.transform = matrix() * (icon_height/world.icon_size) //scale the status's overlay size based on the target's icon size
	status_underlay.pixel_x = -owner.pixel_x
	status_underlay.transform = matrix() * (icon_height/world.icon_size) * 3
	status_underlay.alpha = 40
	owner.add_overlay(status_overlay)
	owner.underlays += status_underlay
	return ..()

/datum/status_effect/stacking/Destroy()
	if(owner)
		owner.cut_overlay(status_overlay)
		owner.underlays -= status_underlay
	QDEL_NULL(status_overlay)
	return ..()
