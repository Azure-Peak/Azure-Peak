/datum/action/cooldown/spell/augment_buff/grasp
	name = "Grasp"
	desc = "Reach out to a target within 7 tiles and wrench them to your side after a 2-second channel. An arcyne tether links you to them while you reel them in, warning them to ready themselves. They must share a fellowship with you and still be within your sight when the channel completes."
	button_icon_state = "grasp"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 7
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_TELEPORT

	invocations = list("Ad Me!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 45 SECONDS

	point_cost = 1
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	var/channel_time = 1.5 SECONDS
	var/channeling = FALSE

/datum/action/cooldown/spell/augment_buff/grasp/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(channeling)
		return FALSE
	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/target = cast_on
	if(target == H)
		to_chat(H, span_warning("I cannot grasp myself!"))
		return FALSE
	if(!shares_fellowship(H, target) && !H.faction_check_mob(target))
		to_chat(H, span_warning("[target] shares no bond with me!"))
		return FALSE

	var/datum/beam/tether = H.Beam(target, "purple_lightning", time = channel_time)

	H.visible_message(span_warning("[H] reaches toward [target], arcyne force arcing between them!"), span_notice("I lock onto [target] and begin to reel them in..."))
	to_chat(target, span_warning("Arcyne force coils around you - [H] is wrenching you toward them! Ready yourself."))
	target.balloon_alert_to_viewers("<font color='[spell_color]'>grasping!</font>")

	channeling = TRUE
	var/completed = do_after(H, channel_time, needhand = FALSE, progress = TRUE, no_interrupt = TRUE, allow_movement = TRUE)
	channeling = FALSE
	if(tether)
		qdel(tether)
	if(!completed)
		to_chat(H, span_warning("My grasp on [target] slips away."))
		return FALSE

	if(QDELETED(target) || !isliving(target))
		return FALSE
	if(!shares_fellowship(H, target) && !H.faction_check_mob(target))
		to_chat(H, span_warning("[target] is no longer bound to me - the grasp unravels."))
		return FALSE
	if(!can_see(H, target, cast_range))
		to_chat(H, span_warning("[target] has slipped from my sight - the grasp fails!"))
		return FALSE

	var/turf/dest = get_turf(H)
	var/turf/origin = get_turf(target)
	target.balloon_alert_to_viewers("<font color='[spell_color]'>grasped!</font>")
	do_teleport(target, dest, channel = TELEPORT_CHANNEL_MAGIC)
	new /obj/effect/temp_visual/blink(origin, H.dir)
	new /obj/effect/temp_visual/blink(dest, H.dir)
	playsound(origin, 'sound/magic/blink.ogg', 40, TRUE)
	playsound(dest, 'sound/magic/blink.ogg', 50, TRUE)
	new /obj/effect/temp_visual/spell_impact(dest, spell_color, spell_impact_intensity)
	target.visible_message(span_warning("[target] is wrenched across the ground to [H]'s side!"), span_notice("Arcyne force yanks me across to [H]!"))
	return TRUE
