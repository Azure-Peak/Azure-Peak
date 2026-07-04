/datum/status_effect/buff/hag_boon/creeping_moss/curse
	id = "choking_shroud"
	examine_text = "SUBJECTPRONOUN is being overtaken by a thick, parasitic moss! Perhaps it can be BURNED away!"

	heal_treshhold = 200
	alert_type = /atom/movable/screen/alert/status_effect/debuff/creeping_moss

/atom/movable/screen/alert/status_effect/debuff/creeping_moss
	name = "Choking Shroud"
	desc = "Moss is trying to creep over my face. It might be able to be BURNT off."
	icon_state = "debuff"

/datum/status_effect/buff/hag_boon/creeping_moss/curse/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner

	if(moss_layer >= 6 && H.stat != DEAD)
		H.adjustOxyLoss(10)
		if(prob(10))
			to_chat(H, span_userdanger("The moss is forcing its way into your throat! You can't breathe!"))

	if(H.on_fire && moss_layer > 0)
		if(prob(10))
			to_chat(H, span_danger("The flames sear away some of the parasite!"))
			trim_moss()
			return

	var/turf/T = get_turf(owner)
	if(!is_type_in_list(T, natural_turfs))
		return
	total_healed += (2 + (2 * moss_layer))

	if(total_healed >= heal_treshhold && moss_layer < 6)
		total_healed = 0
		grow_moss(H)

/obj/effect/temp_visual/heal_rogue/bubble
	icon = 'icons/effects/miracle-healing.dmi'
	icon_state = "bubbles"

/datum/status_effect/curse/waterlogged
	id = "waterlogged"
	duration = -1
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/curse/waterlogged

/atom/movable/screen/alert/status_effect/curse/waterlogged
	name = "Waterlogged"
	desc = "The water is heavy. Stand still too long and you'll sink. Fall down, and you'll drown."
	icon_state = "debuff"

/datum/status_effect/curse/waterlogged/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/turf/T = get_turf(H)

	if(!istype(T, /turf/open/water))
		return

	if(H.stat != DEAD)
		var/stam_drain = 10
		var/obj/effect/temp_visual/heal/H_drown = new /obj/effect/temp_visual/heal_rogue/bubble(get_turf(H))
		H_drown.color = "#00aeff"
		if(!H.stamina_add(stam_drain) && (H.mobility_flags & MOBILITY_STAND))
			to_chat(H, span_userdanger("The murky depths claim your footing!"))
			H.Knockdown(30)
		if(!(H.mobility_flags & MOBILITY_STAND))
			if(prob(15))
				to_chat(H, span_danger("You can feel watery spiderlegs crawl into your mouth!"))
			H.adjustOxyLoss(6)

/datum/status_effect/curse/waterlogged/on_apply()
	. = ..()
	to_chat(owner, span_boldwarning("You feel your limbs grow heavy as if soaked in lead... stay clear of the water."))

/datum/status_effect/curse/hag_slumber
	id = "hag_slumber"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/curse/somnambulance

/atom/movable/screen/alert/status_effect/curse/somnambulance
	name = "Somnambulance"
	desc = "The sandman is coming, and he is not kind."
	icon_state = "debuff"

/datum/status_effect/curse/hag_slumber/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_SLEEPY_TIME, PROC_REF(handle_night_fall))

/datum/status_effect/curse/hag_slumber/proc/handle_night_fall(mob/living/carbon/human/H)
	SIGNAL_HANDLER

	addtimer(CALLBACK(src, PROC_REF(clear_standard_sleep)), 5 SECONDS)

	to_chat(H, span_warning("Your exhaustion fades... replaced by a cold, heavy weight behind your eyes. You are falling asleep, and soon too."))
	addtimer(CALLBACK(src, PROC_REF(force_dream_drag)), 1 MINUTES)

/datum/status_effect/curse/hag_slumber/proc/clear_standard_sleep()
	var/mob/living/carbon/human/H = owner
	if(!H || !istype(H))
		return

	H.remove_status_effect(/datum/status_effect/debuff/sleepytime)
	to_chat(H, span_notice("You feel a sudden, unnatural surge of clarity. The tiredness is gone... but you feel the call of the deep growing louder."))

/datum/status_effect/curse/hag_slumber/proc/force_dream_drag()
	var/mob/living/carbon/human/H = owner
	if(!H || H.stat == DEAD)
		return

	to_chat(H, span_userdanger("The Dream reaches out and grabs your heart! SLEEP!"))

	H.Knockdown(10)
	H.blur_eyes(20)
	teleport_to_dream(H, 1, 1, FALSE, 40 SECONDS, force = TRUE)

/datum/status_effect/curse/hag_slumber/on_remove()
	UnregisterSignal(owner, COMSIG_SLEEPY_TIME)
	..()
