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
	L.visible_message(span_boldnotice("[L] wakes up!"))

	spawn_repel_blast(L)
	to_chat(L, span_boldnotice("The hag's bargain pulls you back from the brink, but at a heavy price..."))
	if(tracker_ref)
		var/list/B_list = list(tracker_ref.find_boon_by_type(L.real_name, /datum/hag_boon/buff/storm_rebirth))
		// We let transmutation get rid of the status effect for us.
		tracker_ref.transmute_boons_to_curse(L.real_name, B_list, /datum/hag_boon/curse/storm_weakness, 85)
	//owner.remove_status_effect(src)

/datum/status_effect/buff/hag_boon/storm_rebirth/proc/spawn_repel_blast(mob/living/L)
	var/turf/T = get_turf(L)
	playsound(T, 'sound/magic/unmagnet.ogg', 100, TRUE)
	for(var/mob/living/victim in orange(2, T))
		var/turf/throw_target = get_edge_target_turf(L, get_dir(L, victim))
		victim.throw_at(throw_target, 5, 3)

/datum/status_effect/buff/hag_boon/natural_communion
	id = "natural_communion"
	duration = -1
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/natural_communion
	var/energy_cooldown = 0
	var/static/list/natural_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/snow,
								  /turf/open/floor/rogue/grass, /turf/open/floor/rogue/grassyel, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grasscold,
								  /turf/open/water/swamp,)

/atom/movable/screen/alert/status_effect/buff/natural_communion
	name = "Natural Communion"
	desc = "The soil will nourish my tired muscles."
	icon_state = "buff"

/datum/status_effect/buff/hag_boon/natural_communion/tick()
	var/turf/T = get_turf(owner)

	if(!is_type_in_list(T, natural_turfs))
		return

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		// 5% of max stamina.
		var/stam_regen = 0.05 * H.max_stamina
		H.stamina_add(-stam_regen)
		var/obj/effect/temp_visual/heal/H_stam = new /obj/effect/temp_visual/heal_rogue/hag(get_turf(owner))
		H_stam.color = "#fffb00"

	if(world.time >= energy_cooldown)
		energy_cooldown = world.time + 25 SECONDS
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			// 5% of max blue.
			var/energy_regen = 0.05 * H.max_energy
			H.energy_add(energy_regen)
			var/obj/effect/temp_visual/heal/H_energy = new /obj/effect/temp_visual/heal_rogue/hag(get_turf(owner))
			H_energy.color = "#002fff"

/obj/effect/temp_visual/heal_rogue/hag
	icon = 'icons/effects/miracle-healing.dmi'
	icon_state = "hag_boon"

/datum/status_effect/buff/hag_boon/creeping_moss
	id = "creeping_moss"
	duration = -1
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/creeping_moss
	examine_text = "SUBJECTPRONOUN is getting increasingly bogged down by clinging moss. Perhaps it can be BURNT off!"

	/// Used to determine when to advance moss.
	var/total_healed = 0
	/// Layers 0 - 6
	var/moss_layer = 0
	/// Points needed to up a layer.
	var/heal_treshhold = 200
	var/image/moss_image

	var/static/list/natural_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/snow,
								  /turf/open/floor/rogue/grass, /turf/open/floor/rogue/grassyel, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grasscold,
								  /turf/open/water/swamp,)

/atom/movable/screen/alert/status_effect/buff/creeping_moss
	name = "Healing Moss"
	desc = "The soil will soothe my wounds and knit my flesh. It might be able to be BURNT off."
	icon_state = "buff"

/datum/status_effect/buff/hag_boon/creeping_moss/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))

/datum/status_effect/buff/hag_boon/creeping_moss/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner

	// Choke if we've got too much moss
	if(moss_layer >= 6 && H.stat != DEAD)
		H.adjustOxyLoss(10)
		if(prob(10))
			to_chat(H, span_userdanger("The moss is squeezing your insides! It hurts!"))

	if(H.on_fire && moss_layer > 0)
		if(prob(5))
			to_chat(H, span_danger("The fire singes away a layer of moss!"))
			trim_moss()
			return

	var/turf/T = get_turf(owner)
	if(!is_type_in_list(T, natural_turfs))
		return

	// Only heal if we actually have brute damage or wounds
	var/list/wounds = H.get_wounds()
	if(H.getBruteLoss() <= 0 && !length(wounds))
		return

	// Scaling heal based on moss layer
	// Layer 0: 2 per tick | Layer 6: 14 per tick
	var/healing_on_tick = 2 + (moss_layer * 2)

	// Clamping as to not punish for health that wasn't healed
	var/actual_brute_healed = min(H.getBruteLoss(), healing_on_tick)

	var/obj/effect/temp_visual/heal/H_heal = new /obj/effect/temp_visual/heal_rogue/hag(get_turf(owner))
	H_heal.color = "#b60000"
	H.adjustBruteLoss(-healing_on_tick)
	if(length(wounds))
		H.heal_wounds(healing_on_tick)
	if(H.blood_volume < BLOOD_VOLUME_NORMAL)
		H.blood_volume = min(owner.blood_volume + healing_on_tick, BLOOD_VOLUME_NORMAL)

	total_healed += actual_brute_healed

	if(total_healed >= heal_treshhold && moss_layer < 6)
		total_healed -= heal_treshhold
		grow_moss(H)

#define MOVESPEED_ID_MOSS_SLOW "movespeed_moss_slow"

/datum/status_effect/buff/hag_boon/creeping_moss/proc/grow_moss(mob/living/carbon/human/H)
	H.remove_movespeed_modifier(MOVESPEED_ID_MOSS_SLOW)
	moss_layer = min(moss_layer + 1, 6)
	H.cut_overlay(moss_image)
	moss_image = image('icons/mob/mossoverlay.dmi', "moss[moss_layer]")
	moss_image.appearance_flags = RESET_COLOR // Keep the moss green regardless of mob color
	H.add_overlay(moss_image)

	// Apply scaling slow
	var/current_slow = 0.2 * moss_layer
	H.add_movespeed_modifier(MOVESPEED_ID_MOSS_SLOW, update=TRUE, priority=10, multiplicative_slowdown=current_slow)

	to_chat(H, span_warning("You feel a heavy, damp weight spreading across your skin..."))

/datum/status_effect/buff/hag_boon/creeping_moss/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.cut_overlay(moss_image)
		H.remove_movespeed_modifier(MOVESPEED_ID_MOSS_SLOW)
		UnregisterSignal(COMSIG_PARENT_ATTACKBY)
	return ..()

/datum/status_effect/buff/hag_boon/creeping_moss/proc/on_attackby(datum/source, obj/item/W, mob/user, params)
	SIGNAL_HANDLER

	if(user.cmode == TRUE) 
		return

	if(!istype(W, /obj/item/flashlight/flare/torch))
		return

	var/obj/item/flashlight/flare/torch/T = W
	if(!T.on)
		return

	if(moss_layer <= 0)
		to_chat(user, span_warning("There is no moss on [owner] left to trim."))
		return

	INVOKE_ASYNC(src, PROC_REF(begin_trimming), user, W)
	return COMPONENT_NO_AFTERATTACK

/datum/status_effect/buff/hag_boon/creeping_moss/proc/begin_trimming(mob/user, obj/item/W)
	if(!user || !W || !owner)
		return

	user.visible_message(span_notice("[user] begins carefully burning the moss off of [owner] with [W]."), \
						 span_notice("You begin burning the damp moss off of [owner]."))

	if(!do_after(user, 3 SECONDS, target = owner))
		return
	if(moss_layer <= 0)
		return

	trim_moss()

/datum/status_effect/buff/hag_boon/creeping_moss/proc/trim_moss()
	moss_layer = max(moss_layer - 1, 0)
	total_healed = 0

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return

	H.cut_overlay(moss_image)
	if(moss_layer > 0)
		H.remove_movespeed_modifier(MOVESPEED_ID_MOSS_SLOW)
		moss_image = image('icons/mob/mossoverlay.dmi', "moss[moss_layer]")
		moss_image.appearance_flags = RESET_COLOR
		H.add_overlay(moss_image)

		var/current_slow = 0.2 * moss_layer
		H.add_movespeed_modifier(MOVESPEED_ID_MOSS_SLOW, update=TRUE, priority=10, multiplicative_slowdown=current_slow)
	else
		H.remove_movespeed_modifier(MOVESPEED_ID_MOSS_SLOW)

	H.update_icons()
	to_chat(owner, span_notice("You feel a bit lighter as some of the moss is removed."))

#undef MOVESPEED_ID_MOSS_SLOW
