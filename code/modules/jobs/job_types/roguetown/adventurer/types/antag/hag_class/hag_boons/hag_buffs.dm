/datum/status_effect/buff/hag_boon/storm_rebirth
	id = "storm_rebirth"
	alert_type = /atom/movable/screen/alert/status_effect/buff/hag_boon/storm_rebirth
	duration = -1
	var/boon_type
	var/datum/component/hag_curio_tracker/tracker_ref

/atom/movable/screen/alert/status_effect/buff/hag_boon/storm_rebirth
	name = "Deathless"
	desc = "I will return from death."
	icon_state = "buff"

/datum/status_effect/buff/hag_boon/storm_rebirth/on_creation(mob/living/new_owner, set_boon_type, datum/component/hag_curio_tracker/set_tracker)
	src.boon_type = set_boon_type
	src.tracker_ref = set_tracker
	return ..()

/datum/status_effect/buff/hag_boon/storm_rebirth/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(handle_death))

/datum/status_effect/buff/hag_boon/storm_rebirth/on_remove()
	if(tracker_ref && owner)
		var/mob/living/L = owner
		SEND_SIGNAL(tracker_ref, COMSIG_STATUS_EFFECT_HAG_CURSE_CLEARED, L.real_name, boon_type)
	UnregisterSignal(COMSIG_LIVING_DEATH)
	return ..()

/datum/status_effect/buff/hag_boon/storm_rebirth/proc/handle_death(mob/living/L, gibbed)
	SIGNAL_HANDLER

	// Can't revive from a pile of meat
	if(gibbed)
		return

	L.visible_message(span_boldwarning("[L]'s body begins to shake with violent electrical energy!"))
	spawn_repel_blast(L)
	var/turf/center = get_turf(L)
	var/list/potential_targets = RANGE_TURFS(3, center)

	var/list/struck_turfs = list()
	for(var/i in 1 to 5)
		if(!length(potential_targets))
			break
		var/turf/T = pick(potential_targets)
		if(T && !(T in struck_turfs))
			struck_turfs += T
			addtimer(CALLBACK(src, PROC_REF(staggered_strike), L, T), i * 10)

	L.Jitter(100)
	addtimer(CALLBACK(src, PROC_REF(revive_owner), L), 10 SECONDS)

/datum/status_effect/buff/hag_boon/storm_rebirth/proc/staggered_strike(mob/living/L, turf/T)
	if(!T)
		return
	var/obj/effect/proc_holder/spell/invoked/thunderstrike/S = new /obj/effect/proc_holder/spell/invoked/thunderstrike()
	S.cast(list(T), L)

/datum/status_effect/buff/hag_boon/storm_rebirth/proc/revive_owner(mob/living/L)
	if(!L || L.stat != DEAD)
		return

	L.Jitter(100)
	L.grab_ghost(force = TRUE)
	L.emote("breathgasp")
	L.revive(full_heal = TRUE, admin_revive = FALSE)
	L.mind.remove_antag_datum(/datum/antagonist/zombie)
	L.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
	L.apply_status_effect(/datum/status_effect/debuff/hag_curse/storm_weakness)
	L.visible_message(span_notice("[L] wakes up!"))

	spawn_repel_blast(L)
	to_chat(L, span_boldnotice("The hag's bargain pulls you back from the brink, but at a heavy price..."))
	if(tracker_ref)
		var/list/B_list = list(tracker_ref.find_boon_by_type(L.real_name, /datum/hag_boon/storm_rebirth))
		// We let transmutation get rid of the status effect for us.
		tracker_ref.transmute_boons_to_curse(L.real_name, B_list, /datum/hag_boon/curse/storm_weakness, 85)
	//owner.remove_status_effect(src)

/datum/status_effect/buff/hag_boon/storm_rebirth/proc/spawn_repel_blast(mob/living/L)
	var/turf/T = get_turf(L)
	playsound(T, 'sound/magic/unmagnet.ogg', 100, TRUE)
	for(var/mob/living/victim in orange(2, T))
		var/turf/throw_target = get_edge_target_turf(L, get_dir(L, victim))
		victim.throw_at(throw_target, 5, 3)
