#define BLADE_DANCE_RADIUS 3
#define BLADE_DANCE_DURATION 10 SECONDS
#define BLADE_DANCE_TICK_DAMAGE 30
#define BLADE_DANCE_WINDUP 1.5 SECONDS

/datum/action/cooldown/spell/blade_dance
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	name = "Blade Dance"
	desc = "PLACEHOLDER MASTERY SPELL - may be replaced later.\n\n\
	Project arcyne energy into an area, conjuring a whirling storm of spectral blades \
	that slash everything caught within. You must remain still to maintain the effect.\n\n\
	The blades take a moment to expand before they begin dealing damage. \
	Targets your aimed zone, with reduced accuracy for precise zones. \
	Deals 30 brute damage per second for 10 seconds to all targets in a 7x7 area."
	button_icon_state = "iron_tempest"
	sound = 'sound/magic/scrapeblade.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_FERRAMANCY

	click_to_activate = TRUE
	cast_range = 14

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("Saltatio Gladiorum!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/effect/blade_dance_zone/active_zone

/datum/action/cooldown/spell/blade_dance/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE

	if(target_turf.z != H.z)
		to_chat(H, span_warning("I must target the same level!"))
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(!(target_turf in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	H.visible_message(span_boldwarning("[H] conjures a whirling storm of spectral blades!"))

	active_zone = new(target_turf, H, src)
	RegisterSignal(H, COMSIG_MOVABLE_MOVED, PROC_REF(caster_moved))
	RegisterSignal(H, list(COMSIG_MOB_DEATH, COMSIG_MOB_LOGOUT), PROC_REF(caster_interrupted))
	return TRUE

/datum/action/cooldown/spell/blade_dance/proc/caster_moved()
	SIGNAL_HANDLER
	end_dance()

/datum/action/cooldown/spell/blade_dance/proc/caster_interrupted()
	SIGNAL_HANDLER
	end_dance()

/datum/action/cooldown/spell/blade_dance/proc/end_dance()
	if(owner)
		UnregisterSignal(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_DEATH, COMSIG_MOB_LOGOUT))
		owner.balloon_alert(owner, "Blade Dance ended.")
	if(active_zone && !QDELETED(active_zone))
		qdel(active_zone)
	active_zone = null

// --- The persistent blade zone ---

/obj/effect/blade_dance_zone
	name = "blade dance"
	desc = "A whirling maelstrom of spectral blades!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	light_outer_range = 3
	light_color = GLOW_COLOR_METAL
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/mob/living/carbon/human/caster
	var/datum/action/cooldown/spell/blade_dance/source_spell
	var/ticks_remaining
	var/tick_damage = BLADE_DANCE_TICK_DAMAGE
	var/effect_radius = BLADE_DANCE_RADIUS
	var/list/blade_visuals = list()
	var/datum/beam/caster_beam
	var/winding_up = TRUE

/obj/effect/blade_dance_zone/Initialize(mapload, mob/living/carbon/human/summoner, datum/action/cooldown/spell/blade_dance/spell_ref)
	. = ..()
	caster = summoner
	source_spell = spell_ref
	ticks_remaining = BLADE_DANCE_DURATION / (1 SECONDS)
	INVOKE_ASYNC(src, PROC_REF(setup_visuals))

/obj/effect/blade_dance_zone/proc/setup_visuals()
	// Visible beam from zone center to caster
	caster_beam = new(src, caster, 'icons/effects/beam.dmi', "b_beam", BLADE_DANCE_DURATION + 1 SECONDS, maxdistance = 20)
	caster_beam.Start()

	// Spawn spinning daggers - they expand outward during the windup telegraph
	var/turf/center = get_turf(src)
	var/expand_time = BLADE_DANCE_WINDUP / (1 DECISECONDS) // ticks for the expansion
	for(var/turf/T in range(effect_radius, center))
		if(T == center)
			continue
		var/obj/effect/temp_visual/spinning_dagger/D = new(center, BLADE_DANCE_DURATION + BLADE_DANCE_WINDUP + 2 SECONDS, FALSE)
		blade_visuals += D
		var/dx = (T.x - center.x) * 32
		var/dy = (T.y - center.y) * 32
		animate(D, pixel_x = dx, pixel_y = dy, time = expand_time, easing = EASE_OUT)
		addtimer(CALLBACK(D, TYPE_PROC_REF(/obj/effect/temp_visual/spinning_dagger, start_spinning)), expand_time)

	playsound(src, 'sound/magic/scrapeblade.ogg', 80, TRUE, 6)
	// Damage starts after windup - gives targets time to see the zone and move
	addtimer(CALLBACK(src, PROC_REF(begin_damage)), BLADE_DANCE_WINDUP)
	QDEL_IN(src, BLADE_DANCE_DURATION + BLADE_DANCE_WINDUP + 1 SECONDS)

/obj/effect/blade_dance_zone/Destroy()
	if(caster_beam)
		caster_beam.End()
		caster_beam = null
	if(source_spell)
		source_spell.end_dance()
	source_spell = null
	caster = null
	QDEL_LIST(blade_visuals)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/blade_dance_zone/proc/begin_damage()
	if(QDELETED(src))
		return
	winding_up = FALSE
	playsound(src, 'sound/magic/scrapeblade.ogg', 80, TRUE, 6)
	START_PROCESSING(SSprocessing, src)

/obj/effect/blade_dance_zone/process(delta_time)
	if(winding_up || ticks_remaining <= 0 || QDELETED(caster) || caster.stat != CONSCIOUS)
		qdel(src)
		return

	ticks_remaining--
	playsound(src, pick('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg'), 60, TRUE)

	var/turf/center = get_turf(src)
	for(var/turf/T in range(effect_radius, center))
		for(var/mob/living/L in T.contents)
			if(L == caster)
				continue
			if(L.anti_magic_check())
				continue
			if(source_spell?.spell_guard_check(L))
				continue
			if(ishuman(L))
				var/target_zone = caster.zone_selected || BODY_ZONE_CHEST
				arcyne_strike(caster, L, null, tick_damage, target_zone, \
					BCLASS_CUT, spell_name = "Blade Dance", \
					damage_type = BRUTE, npc_simple_damage_mult = 1, \
					skip_animation = TRUE, skip_message = TRUE, \
					allow_shield_check = TRUE)
			else
				L.adjustBruteLoss(tick_damage)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_METAL, SPELL_IMPACT_MEDIUM)

#undef BLADE_DANCE_RADIUS
#undef BLADE_DANCE_DURATION
#undef BLADE_DANCE_TICK_DAMAGE
#undef BLADE_DANCE_WINDUP
