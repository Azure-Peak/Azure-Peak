#define GRAVITY_ANCHOR_TELEGRAPH (TELEGRAPH_DODGEABLE)
#define GRAVITY_ANCHOR_MOVESPEED_ID "gravity_anchor_slow"
#define GRAVITY_ANCHOR_FILTER "gravity_anchor_glow"

/datum/action/cooldown/spell/gravity_anchor
	button_icon = 'icons/mob/actions/mage_kinesis.dmi'
	name = "Gravity Anchor"
	desc = "Massively increase gravity in a 5x5 area, weighing down everyone within - including yourself. \
	Targets are heavily slowed while inside the zone. \
	The zone persists for 20 seconds. Debuff lingers for 3 seconds after leaving."
	button_icon_state = "gravity_anchor"
	sound = 'sound/magic/gravity.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_KINESIS

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Ancora Gravitatis!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 25 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/zone_duration = 20 SECONDS
	var/zone_radius = 2 // 5x5

/datum/action/cooldown/spell/gravity_anchor/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(!(T in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	new /obj/effect/gravity_anchor_zone(T, zone_radius, zone_duration, H)
	return TRUE

/obj/effect/gravity_anchor_zone
	name = "gravity anchor"
	desc = "The air shimmers with crushing gravitational force."
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_squares"
	light_outer_range = 3
	light_color = GLOW_COLOR_KINESIS
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BELOW_MOB_LAYER

	var/radius = 2
	var/mob/living/caster
	var/list/zone_turfs = list()
	var/list/zone_visuals = list()
	var/list/gritted = list()

/obj/effect/gravity_anchor_zone/Initialize(mapload, zone_radius = 2, duration = 15 SECONDS, mob/living/zone_caster = null)
	. = ..()
	radius = zone_radius
	caster = zone_caster

	for(var/turf/affected in range(radius, src))
		zone_turfs += affected
		new /obj/effect/temp_visual/trap/kinesis(affected)

	addtimer(CALLBACK(src, PROC_REF(activate_zone), duration), GRAVITY_ANCHOR_TELEGRAPH)
	QDEL_IN(src, duration + GRAVITY_ANCHOR_TELEGRAPH)

/obj/effect/gravity_anchor_zone/proc/activate_zone(duration)
	for(var/turf/affected in zone_turfs)
		var/obj/effect/temp_visual/gravity_anchor_ground/V = new(affected, null, duration)
		zone_visuals += V

	playsound(get_turf(src), 'sound/magic/gravity.ogg', 80)
	START_PROCESSING(SSfastprocess, src)

/obj/effect/gravity_anchor_zone/process()
	for(var/turf/T in zone_turfs)
		for(var/mob/living/L in T.contents)
			if(L in gritted)
				continue
			if(L.anti_magic_check())
				continue
			var/datum/status_effect/buff/clash/guard = L.has_status_effect(/datum/status_effect/buff/clash)
			if(guard)
				gritted += L
				guard.deflected_spell = TRUE
				L.remove_status_effect(/datum/status_effect/buff/clash)
				L.apply_status_effect(/datum/status_effect/buff/parry_buffer)
				L.visible_message(span_warning("[L] braces against the crushing gravity!"))
				to_chat(L, span_notice("I brace myself against the gravity, enduring it through sheer will!"))
				var/obj/item/held = L.get_active_held_item()
				if(held?.parrysound)
					playsound(get_turf(L), pick(held.parrysound), 100)
				else
					playsound(get_turf(L), pick(L.parry_sound), 100)
				continue
			var/datum/status_effect/debuff/gravity_anchored/existing = L.has_status_effect(/datum/status_effect/debuff/gravity_anchored)
			if(existing)
				existing.refresh()
			else
				L.apply_status_effect(/datum/status_effect/debuff/gravity_anchored)
				to_chat(L, span_userdanger("Crushing gravity weighs me down!"))
				new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_KINESIS, SPELL_IMPACT_MEDIUM)

/obj/effect/gravity_anchor_zone/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	for(var/obj/effect/temp_visual/V in zone_visuals)
		qdel(V)
	zone_visuals.Cut()
	zone_turfs.Cut()
	caster = null
	return ..()

// Ground visual - persistent gravity distortion on each tile
/obj/effect/temp_visual/gravity_anchor_ground
	icon = 'icons/effects/effects.dmi'
	icon_state = "purplesparkles"
	light_outer_range = 1
	light_color = GLOW_COLOR_KINESIS
	layer = BELOW_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	randomdir = FALSE
	alpha = 80

/obj/effect/temp_visual/gravity_anchor_ground/Initialize(mapload, duration_override = 20 SECONDS)
	duration = duration_override
	. = ..()

// Telegraph visual
/obj/effect/temp_visual/trap/kinesis
	color = GLOW_COLOR_KINESIS
	light_color = GLOW_COLOR_KINESIS
	duration = GRAVITY_ANCHOR_TELEGRAPH

// Debuff: -4 SPD stat + x2 multiplicative movement slowdown
/datum/status_effect/debuff/gravity_anchored
	id = "gravity_anchored"
	duration = 3 SECONDS
	effectedstats = list(STATKEY_SPD = -4)
	alert_type = /atom/movable/screen/alert/status_effect/debuff/gravity_anchored

/atom/movable/screen/alert/status_effect/debuff/gravity_anchored
	name = "Gravity Anchored"
	desc = "Crushing gravity weighs me down, slowing my movements. (-4 SPD)"
	icon_state = "debuff"

/datum/status_effect/debuff/gravity_anchored/on_apply()
	. = ..()
	owner.add_movespeed_modifier(GRAVITY_ANCHOR_MOVESPEED_ID, update = TRUE, priority = 100, override = TRUE, multiplicative_slowdown = 2)
	var/filter = owner.get_filter(GRAVITY_ANCHOR_FILTER)
	if(!filter)
		owner.add_filter(GRAVITY_ANCHOR_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_KINESIS, "alpha" = 30, "size" = 1))

/datum/status_effect/debuff/gravity_anchored/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(GRAVITY_ANCHOR_MOVESPEED_ID)
	owner.remove_filter(GRAVITY_ANCHOR_FILTER)

#undef GRAVITY_ANCHOR_FILTER
#undef GRAVITY_ANCHOR_TELEGRAPH
#undef GRAVITY_ANCHOR_MOVESPEED_ID
