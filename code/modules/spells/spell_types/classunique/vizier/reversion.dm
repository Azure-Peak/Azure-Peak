// Reversion - Origin Magic (Vizier)
// The Vizier marks an adjacent ally or themselves, snapshotting their state and position.
// Leaves a mark on the ground - that they can then activate at will to teleport back
// It expires after 15 seconds

#define REVERSION_MARK_DURATION (15 SECONDS)

/datum/action/cooldown/spell/reversion
	button_icon = 'icons/mob/actions/classuniquespells/vizier.dmi'
	name = "Reversion"
	desc = "Marks an adjacent ally's body and position, granting them the ability to revert to their marked state within 15 seconds. The target chooses when to activate the revert."
	button_icon_state = "reversion"
	sound = 'sound/magic/timeforward.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 7
	self_cast_possible = TRUE
	aim_assist = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = 60

	invocations = list("Irji'!")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 0.5 SECONDS
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// Fatigue/mana cost for the Vizier's origin magic system.
	var/cost = 3

/datum/action/cooldown/spell/reversion/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(cast_on))
		if(owner)
			to_chat(owner, span_warning("That is not a valid target!"))
		return FALSE
	if(!iscarbon(cast_on))
		if(owner)
			to_chat(owner, span_warning("I cannot mark that!"))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/reversion/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/carbon/target = cast_on
	if(!istype(target))
		return FALSE

	// Snapshot the target's current state
	var/datum/action/cooldown/spell/reversion_trigger/trigger = new
	trigger.origin = get_turf(target)
	trigger.brute = target.getBruteLoss()
	trigger.burn = target.getFireLoss()
	trigger.oxy = target.getOxyLoss()
	trigger.toxin = target.getToxLoss()
	trigger.blood = target.blood_volume

	var/datum/status_effect/fire_handler/fire_stacks/fire_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
	trigger.firestacks = fire_status?.stacks

	var/datum/status_effect/fire_handler/fire_stacks/sunder/sunder_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder)
	trigger.sunderfirestacks = sunder_status?.stacks

	var/datum/status_effect/fire_handler/fire_stacks/divine/divine_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/divine)
	trigger.divinefirestacks = divine_status?.stacks

	// Snapshot current wounds so we can remove new ones on revert
	trigger.snapshot_wounds = target.get_wounds()

	// Grant the trigger spell to the target
	trigger.Grant(target)

	// Audio + visual feedback on the target
	playsound(target.loc, 'sound/magic/timeforward.ogg', 50, FALSE)
	target.apply_status_effect(/datum/status_effect/buff/reversion)

	// Feedback
	if(target == H)
		to_chat(H, span_notice("I mark myself for reversion. I can activate the revert at will."))
	else
		to_chat(target, span_warning("I feel a part of me was left behind... I can choose to revert back."))
		to_chat(H, span_notice("I mark [target] for reversion. They can activate the revert at will."))

	return TRUE

/datum/action/cooldown/spell/reversion_trigger
	button_icon = 'icons/mob/actions/classuniquespells/vizier.dmi'
	name = "Revert"
	desc = "Activate to snap back to your marked position and restore your state."
	button_icon_state = "reversion"
	sound = 'sound/magic/timereverse.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE

	primary_resource_type = SPELL_COST_NONE
	primary_resource_cost = 0

	invocations = null
	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 0.5 SECONDS
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 0

	associated_skill = null
	associated_stat = null
	spell_tier = 0
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// Snapshot data - set by the Reversion caster spell before granting.
	var/turf/origin
	var/brute = 0
	var/burn = 0
	var/oxy = 0
	var/toxin = 0
	var/firestacks = 0
	var/divinefirestacks = 0
	var/sunderfirestacks = 0
	var/blood = 0
	/// Wounds that existed at mark time - anything not in this list gets removed on revert.
	var/list/datum/wound/snapshot_wounds
	/// Timer for auto-expiry.
	var/expiry_timer
	/// Ground marker effect at the origin point.
	var/obj/effect/reversion_marker/ground_marker

/datum/action/cooldown/spell/reversion_trigger/Grant(mob/grant_to)
	. = ..()
	if(!owner)
		return
	// Set a timer to auto-remove this spell when the mark expires
	expiry_timer = addtimer(CALLBACK(src, PROC_REF(expire)), REVERSION_MARK_DURATION, TIMER_STOPPABLE)
	// Place a ground marker at the return point
	if(origin)
		ground_marker = new(origin)

/datum/action/cooldown/spell/reversion_trigger/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/target = owner
	if(!istype(target))
		return FALSE

	// Teleport back
	do_teleport(target, origin, no_effects = TRUE)

	// Restore snapshot state
	var/brutenew = target.getBruteLoss()
	var/burnnew = target.getFireLoss()
	var/oxynew = target.getOxyLoss()
	target.adjust_fire_stacks(firestacks)
	target.adjust_fire_stacks(sunderfirestacks, /datum/status_effect/fire_handler/fire_stacks/sunder)
	target.adjust_fire_stacks(divinefirestacks, /datum/status_effect/fire_handler/fire_stacks/divine)
	target.adjustBruteLoss(brutenew * -1 + brute)
	target.adjustFireLoss(burnnew * -1 + burn)
	target.adjustOxyLoss(oxynew * -1 + oxy)
	target.adjustToxLoss(target.getToxLoss() * -1 + toxin)
	target.blood_volume = blood

	// Remove any wounds gained after the mark
	for(var/datum/wound/wound as anything in target.get_wounds())
		if(wound in snapshot_wounds)
			continue
		if(wound.bodypart_owner)
			wound.bodypart_owner.remove_wound(wound)
		else
			target.simple_remove_wound(wound)

	playsound(target.loc, 'sound/magic/timereverse.ogg', 100, FALSE)
	to_chat(target, span_warning("Time reverses - my body snaps back!"))

	// Remove the status effect and clean up
	target.remove_status_effect(/datum/status_effect/buff/reversion)
	cleanup()
	return TRUE

/// Called when the mark expires without being used.
/datum/action/cooldown/spell/reversion_trigger/proc/expire()
	if(!owner)
		qdel(src)
		return
	to_chat(owner, span_notice("The reversion mark fades."))
	var/mob/living/L = owner
	L.remove_status_effect(/datum/status_effect/buff/reversion)
	cleanup()

/// Remove this spell from the target and delete it.
/datum/action/cooldown/spell/reversion_trigger/proc/cleanup()
	if(expiry_timer)
		deltimer(expiry_timer)
		expiry_timer = null
	QDEL_NULL(ground_marker)
	if(owner)
		Remove(owner)
	qdel(src)

/datum/action/cooldown/spell/reversion_trigger/Destroy()
	if(expiry_timer)
		deltimer(expiry_timer)
		expiry_timer = null
	QDEL_NULL(ground_marker)
	snapshot_wounds = null
	origin = null
	return ..()

// -------------------------------------------------------------------
// Ground marker effect placed at the reversion return point.
// -------------------------------------------------------------------

/obj/effect/reversion_marker
	name = "temporal mark"
	desc = "A shimmering imprint of origin magick lingers here."
	icon = 'icons/effects/effects.dmi'
	icon_state = "blessed"
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = TRUE
	density = FALSE
	alpha = 128
	color = GLOW_COLOR_ARCANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

#undef REVERSION_MARK_DURATION
