/obj/effect/proc_holder/spell/invoked/fortifyingvapors
	name = "Fortifying Vapors"
	desc = "An insuffulation of medicinal vapor. Provides long, slow healing."
	action_icon = 'icons/mob/actions/antiquarianspells.dmi'
	overlay_icon = 'icons/mob/actions/antiquarianspells.dmi'
	overlay_state = "fortifyingvapors"
	releasedrain = 3 SECONDS
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/diagnose.ogg'
	invocation_type = "emote"
	invocations = list("wafts clarifying vapor from a tin of smoldering herbs.")
	associated_skill = /datum/skill/misc/reading
	antimagic_allowed = FALSE
	recharge_time = 12 SECONDS
	miracle = FALSE
	devotion_cost = 0
	ignore_los = FALSE

/obj/effect/proc_holder/spell/invoked/fortifyingvapors/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(targets[1]))
		revert_cast()
		return FALSE
	
	var/mob/living/target = targets[1]
	
	if(target.has_status_effect(/datum/status_effect/buff/fortifyingvapors))
		to_chat(user, span_warning("They are already under the effects of the vapors!"))
		revert_cast()
		return FALSE

	to_chat(target, span_warning("A heady scent fills my nostrils. My pulse quickens; I feel clear and sharp."))
	var/healing = 2.5 //not exactly sure where this appears in the healing code, but i tested and it definitely scales healing
	user.Beam(target, icon_state="lichbeam", time=1 SECONDS)
	target.apply_status_effect(/datum/status_effect/buff/fortifyingvapors, healing)
	target.playsound_local(target, 'sound/magic/heartbeat.ogg', 100)
	return TRUE

#define VAPORS_HEALING_FILTER "fortifying_vapors_glow"

/atom/movable/screen/alert/status_effect/buff/fortifyingvapors
	name = "Fortifying Vapors"
	desc = "A heady scent fills my nostrils. My pulse quickens; I feel clear and sharp."
	icon_state = "vigorized"

/datum/status_effect/buff/fortifyingvapors
	id = "fortifyingvapors"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fortifyingvapors
	duration = 20 SECONDS
	examine_text = "SUBJECTPRONOUN is surrounded by subtle, heady vapors."
	var/healing_on_tick = 0.5 //half of miracle, twice the duration
	var/outline_colour = "#9ebb5b"

/datum/status_effect/buff/fortifyingvapors/on_apply()
	var/filter = owner.get_filter(VAPORS_HEALING_FILTER)
	if (!filter)
		owner.add_filter(VAPORS_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/fortifyingvapors/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/fortifyingvapors(get_turf(owner))
	H.color = "#9ebb5b"
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume+healing_on_tick, BLOOD_VOLUME_NORMAL)
	var/list/wCount = owner.get_wounds()
	if(length(wCount))
		owner.heal_wounds(healing_on_tick)
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

/datum/status_effect/buff/fortifyingvapors/on_remove()
	owner.remove_filter(VAPORS_HEALING_FILTER)
	owner.update_damage_hud()

#undef VAPORS_HEALING_FILTER
