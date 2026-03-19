/obj/effect/proc_holder/spell/invoked/reversion
	name = "Reversion"
	desc = "Marks a target's body and position. Recast to instantly revert them to their marked state. If the mark expires, nothing happens."
	releasedrain = 60
	chargedrain = 0
	chargetime = 5 // 0.5 seconds
	recharge_time = 60 SECONDS
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/timeforward.ogg'
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'icons/mob/actions/classuniquespells/vizier.dmi'
	overlay_state = "reversion"
	invocations = list("Irji'!") // https://en.wiktionary.org/wiki/%D8%A7%D8%B1%D8%AC%D8%B9
	invocation_type = "whisper"
	miracle = FALSE
	ignore_los = FALSE
	cost = 3
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	var/mob/living/carbon/reversion_target
	var/brute = 0
	var/burn = 0
	var/oxy = 0
	var/toxin = 0
	var/turf/origin
	var/firestacks = 0
	var/divinefirestacks = 0
	var/sunderfirestacks = 0
	var/blood = 0
	var/reversion_active = FALSE
	var/mark_time = 0

/obj/effect/proc_holder/spell/invoked/reversion/cast(list/targets, mob/user = usr)
	// Recast while mark active — trigger revert instantly
	if(reversion_active)
		if(world.time < mark_time + 10) // 1 second grace to prevent double-fire
			revert_cast()
			return FALSE
		if(!reversion_target || QDELETED(reversion_target))
			to_chat(user, span_warning("The marked target is gone!"))
			clear_mark()
			return FALSE
		revert_reversion()
		return TRUE

	// First cast — mark the clicked target
	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/carbon/target = targets[1]
	reversion_target = target
	reversion_active = TRUE
	target.apply_status_effect(/datum/status_effect/buff/reversion)
	brute = target.getBruteLoss()
	burn = target.getFireLoss()
	oxy = target.getOxyLoss()
	toxin = target.getToxLoss()
	origin = get_turf(target)
	blood = target.blood_volume
	var/datum/status_effect/fire_handler/fire_stacks/fire_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
	firestacks = fire_status?.stacks
	var/datum/status_effect/fire_handler/fire_stacks/sunder/sunder_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder)
	sunderfirestacks = sunder_status?.stacks
	var/datum/status_effect/fire_handler/fire_stacks/divine/divine_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/divine)
	divinefirestacks = divine_status?.stacks
	to_chat(target, span_warning("I feel a part of me was left behind..."))
	to_chat(user, span_notice("I mark [target] for reversion. Recast to trigger the revert."))
	play_indicator(target, 'icons/mob/overhead_effects.dmi', "timestop", 100, OBJ_LAYER)
	mark_time = world.time
	addtimer(CALLBACK(src, PROC_REF(expire_reversion)), wait = 15 SECONDS)
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/reversion/proc/revert_reversion()
	if(!reversion_active || !reversion_target || QDELETED(reversion_target))
		clear_mark()
		return
	var/mob/living/carbon/target = reversion_target
	clear_mark()
	target.remove_status_effect(/datum/status_effect/buff/reversion)
	do_teleport(target, origin, no_effects=TRUE)
	var/brutenew = target.getBruteLoss()
	var/burnnew = target.getFireLoss()
	var/oxynew = target.getOxyLoss()
	target.adjust_fire_stacks(firestacks)
	target.adjust_fire_stacks(sunderfirestacks, /datum/status_effect/fire_handler/fire_stacks/sunder)
	target.adjust_fire_stacks(divinefirestacks, /datum/status_effect/fire_handler/fire_stacks/divine)
	target.adjustBruteLoss(brutenew*-1 + brute)
	target.adjustFireLoss(burnnew*-1 + burn)
	target.adjustOxyLoss(oxynew*-1 + oxy)
	target.adjustToxLoss(target.getToxLoss()*-1 + toxin)
	target.blood_volume = blood
	playsound(target.loc, 'sound/magic/timereverse.ogg', 100, FALSE)
	to_chat(target, span_warning("Time reverses - my body snaps back!"))

/obj/effect/proc_holder/spell/invoked/reversion/proc/expire_reversion()
	if(!reversion_active)
		return
	if(reversion_target && !QDELETED(reversion_target))
		reversion_target.remove_status_effect(/datum/status_effect/buff/reversion)
		to_chat(reversion_target, span_notice("The reversion mark fades."))
	clear_mark()
	charge_counter = 0
	start_recharge()
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/invoked/reversion/proc/clear_mark()
	reversion_active = FALSE
	reversion_target = null

/obj/effect/proc_holder/spell/invoked/reversion/proc/play_indicator(mob/living/carbon/target, icon_path, overlay_name, clear_time, overlay_layer)
	if(!ishuman(target))
		return
	if(target.stat != DEAD)
		var/mob/living/carbon/humie = target
		var/datum/species/species = humie.dna.species
		var/list/offset_list
		if(humie.gender == FEMALE)
			offset_list = species.offset_features[OFFSET_HEAD_F]
		else
			offset_list = species.offset_features[OFFSET_HEAD]
			var/mutable_appearance/appearance = mutable_appearance(icon_path, overlay_name, overlay_layer)
			if(offset_list)
				appearance.pixel_x += (offset_list[1])
				appearance.pixel_y += (offset_list[2]+12)
			appearance.appearance_flags = RESET_COLOR
			target.overlays_standing[OBJ_LAYER] = appearance
			target.apply_overlay(OBJ_LAYER)
			update_icon()
			addtimer(CALLBACK(humie, PROC_REF(clear_overhead_indicator), appearance, target), clear_time)

/obj/effect/proc_holder/spell/invoked/reversion/proc/clear_overhead_indicator(appearance, mob/living/carbon/target)
	target.remove_overlay(OBJ_LAYER)
	cut_overlay(appearance, TRUE)
	qdel(appearance)
	update_icon()
	return
