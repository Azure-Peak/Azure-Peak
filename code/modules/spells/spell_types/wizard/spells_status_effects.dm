// Folder for any status effects that is shared between more than one spell. For now, just Frostbite
/datum/status_effect/buff/frost
	id = "frost"
	alert_type = /atom/movable/screen/alert/status_effect/buff/frost
	duration = 25 SECONDS
	effectedstats = list(STATKEY_SPD = -1)

/atom/movable/screen/alert/status_effect/buff/frost
	name = "Shivering"
	desc = "My body can't stop shaking."
	icon_state = "debuff"

/datum/status_effect/buff/frost/tick()
	var/mob/living/target = owner
	if(prob(20))
		target.emote(pick("shiver"))

/datum/status_effect/buff/frost/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.update_vision_cone()
	target.stamina_add(25)

/datum/status_effect/buff/frostbite
	id = "frostbite"
	alert_type = /atom/movable/screen/alert/status_effect/buff/frostbite
	duration = 6 SECONDS
	effectedstats = list("speed" = -2)

/atom/movable/screen/alert/status_effect/buff/frostbite
	name = "Frostbite"
	desc = "My limbs are frozen stiff!"
	icon_state = "debuff"

/datum/status_effect/buff/frostbite/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.update_vision_cone()
	var/newcolor = rgb(136, 191, 255)
	target.add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, newcolor), 20 SECONDS)
	target.add_movespeed_modifier(MOVESPEED_ID_ADMIN_VAREDIT, update=TRUE, priority=100, multiplicative_slowdown=4, movetypes=GROUND)
	target.stamina_add(25)

/datum/status_effect/buff/frostbite/tick()
	var/mob/living/target = owner
	target.stamina_add(5)

/datum/status_effect/buff/frostbite/on_remove()
	var/mob/living/target = owner
	target.update_vision_cone()
	target.remove_movespeed_modifier(MOVESPEED_ID_ADMIN_VAREDIT, TRUE)
	. = ..()

/datum/status_effect/buff/witherd
	id = "withered"
	alert_type = /atom/movable/screen/alert/status_effect/buff/witherd
	duration = 30 SECONDS
	effectedstats = list(STATKEY_SPD = -2, STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_WIL = -2)

/atom/movable/screen/alert/status_effect/buff/witherd
	name = "Withering"
	desc = "I can feel my physical prowess waning."
	icon_state = "debuff"
	color = "#b884f8" //talk about a coder sprite x2


/datum/status_effect/buff/witherd/on_apply()
	. = ..()
	to_chat(owner, span_warning("I feel sapped of vitality!"))
	var/mob/living/target = owner
	target.update_vision_cone()
	var/newcolor = rgb(207, 135, 255)
	target.add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, newcolor), 30 SECONDS)

/datum/status_effect/buff/witherd/on_remove()
	. = ..()
	to_chat(owner, span_warning("I feel my physical prowess returning."))

/datum/status_effect/buff/lightningstruck
	id = "lightningstruck"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lightningstruck
	duration = 6 SECONDS
	effectedstats = list("speed" = -2)

/atom/movable/screen/alert/status_effect/buff/lightningstruck
	name = "Lightning Struck"
	desc = "I can feel the electricity coursing through me."
	icon_state = "debuff"
	color = "#ffff00"

/datum/status_effect/buff/lightningstruck/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.update_vision_cone()
	target.add_movespeed_modifier(MOVESPEED_ID_LIGHTNINGSTRUCK, update=TRUE, priority=100, multiplicative_slowdown=4, movetypes=GROUND)

/datum/status_effect/buff/lightningstruck/on_remove()
	. = ..()
	var/mob/living/target = owner
	target.update_vision_cone()
	target.remove_movespeed_modifier(MOVESPEED_ID_LIGHTNINGSTRUCK, TRUE)





// arcane marks plus helper procs
// did my best to make this require minimal snowflake procs and accidentally created another snowflake proc. oops :3


// aura
#define ARCANEMARK_FILTER "mark_glow"

/proc/apply_arcane_mark(mob/living/target) //this is on a seperate proc bc multiple spells can do this
	if(!istype(target, /mob/living/carbon)) //idk if this gonna work on simplemobs so im not even gonna try lol. u already do silly dmg to em man
		return
	target.apply_status_effect(/datum/status_effect/debuff/arcanemark)

/proc/consume_arcane_mark_stacks(mob/living/target)
	if(!istype(target, /mob/living/carbon))
		return
	var/datum/status_effect/debuff/arcanemark/mark = target.has_status_effect(/datum/status_effect/debuff/arcanemark)
	if(!mark)
		return 0 //OH GOD IS THIS RIGHT IS THIS CORRECT???
	var/stack_count = mark.stacks
	target.remove_status_effect(/datum/status_effect/debuff/arcanemark)
	if(stack_count >= 3)
		target.remove_filter(ARCANEMARK_FILTER) //if anything runtimes, it's because of this. oops! lol!
		playsound(get_turf(target), 'sound/magic/mark_det.ogg', 100) //feedback
	return stack_count



/atom/movable/screen/alert/status_effect/debuff/arcanemark
	name = "Arcane Mark"
	desc = "Ethereal potential-death sirensongs myne soul. Finisher spells shalt consume the stacked marks and deal extra damage."
	icon_state = "debuff"

/datum/status_effect/debuff/arcanemark
	id = "arcanemark"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/arcanemark
	duration = 15 SECONDS //15 sec - combo spells are on an 8-10 sec cd so if you miss two you drop your combo. seems fair?
	status_type = STATUS_EFFECT_REFRESH
	var/outline_colour = "#c203fc"
	var/stacks = 1
	var/max_stacks = 3

/datum/status_effect/debuff/arcanemark/on_apply()
	effectedstats = list(STATKEY_LCK = -stacks) //this may be too much?
	.=..()
	update_alert()

/datum/status_effect/debuff/arcanemark/on_remove()
	.=..()
	owner.remove_filter(ARCANEMARK_FILTER) //if anything runtimes, it's because of this. oops! lol!


/datum/status_effect/debuff/arcanemark/refresh(mob/living/new_owner)

	.=..()
	stacks++
	if(stacks > max_stacks) //*scream
		stacks--
	else if(stacks == max_stacks)
		var/mob/living/target = owner
		if(target)
			target.visible_message(span_warning("[target]'s arcane marks flare as a finishing spell draws near!"), span_userdanger("MARKED."))
			target.add_filter(ARCANEMARK_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 100, "size" = 1))
			playsound(get_turf(target), 'sound/magic/mark_max.ogg', 100)
	update_alert()
	return

/datum/status_effect/debuff/arcanemark/proc/update_alert()
	if(!linked_alert)
		return
	linked_alert.name = "Arcane Mark ([stacks])"
	linked_alert.desc = "Ethereal potential-death sirensongs myne soul. Finisher spells shalt consume the stacked marks and deal extra damage."

#undef ARCANEMARK_FILTER
