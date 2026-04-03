// Wither 2.0 — Hex Minor Aspect
// Ground-targeted AoE debuff zone. Weakens anyone standing in it.

/datum/action/cooldown/spell/wither
	button_icon = 'icons/mob/actions/mage_hex.dmi'
	name = "Wither"
	desc = "Curse an area with withering energy, sapping the strength, speed and constitution of anyone standing within.\n\
	The zone persists for 20 seconds. Debuff lingers for 3 seconds after leaving the zone.\n\
	5x5 area of effect."
	button_icon_state = "wither"
	sound = 'sound/magic/shadowstep_destination.ogg'
	spell_color = GLOW_COLOR_HEX
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Arescentem!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/zone_duration = 20 SECONDS
	var/zone_radius = 2 // 5x5

/datum/action/cooldown/spell/wither/cast(atom/cast_on)
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

	// Spawn the wither zone
	new /obj/effect/wither_zone(T, zone_radius, zone_duration, H)
	return TRUE

// Persistent AOE zone that debuffs anyone inside
/obj/effect/wither_zone
	name = "withering curse"
	desc = "A patch of dark, cursed energy that saps vitality."
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	light_outer_range = 3
	light_color = GLOW_COLOR_HEX
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BELOW_MOB_LAYER

	var/radius = 2
	var/mob/living/caster
	var/list/zone_turfs = list()
	var/list/zone_visuals = list()
	var/list/gritted = list() // Mobs who guarded through — permanently immune to this zone

/obj/effect/wither_zone/Initialize(mapload, zone_radius = 2, duration = 20 SECONDS, mob/living/zone_caster = null)
	. = ..()
	radius = zone_radius
	caster = zone_caster

	// Build the zone turfs and show telegraph visuals
	for(var/turf/affected in range(radius, src))
		zone_turfs += affected
		new /obj/effect/temp_visual/trap/hex(affected)

	// After 1.2s telegraph, activate the zone
	addtimer(CALLBACK(src, PROC_REF(activate_zone), duration), 1.2 SECONDS)

	// Self-destruct after telegraph + duration
	QDEL_IN(src, duration + 1.2 SECONDS)

/obj/effect/wither_zone/proc/activate_zone(duration)
	// Spawn persistent ground visuals
	for(var/turf/affected in zone_turfs)
		if(affected != get_turf(src))
			var/obj/effect/temp_visual/wither_ground/V = new(affected, null, duration)
			zone_visuals += V

	playsound(get_turf(src), 'sound/magic/shadowstep_destination.ogg', 80)
	START_PROCESSING(SSfastprocess, src)

/obj/effect/wither_zone/process()
	for(var/turf/T in zone_turfs)
		for(var/mob/living/L in T.contents)
			if(L in gritted)
				continue
			if(L.anti_magic_check())
				continue
			// Guard check — if guarding, they grit through and become permanently immune to this zone
			var/datum/status_effect/buff/clash/guard = L.has_status_effect(/datum/status_effect/buff/clash)
			if(guard)
				gritted += L
				guard.deflected_spell = TRUE
				L.remove_status_effect(/datum/status_effect/buff/clash)
				L.apply_status_effect(/datum/status_effect/buff/parry_buffer)
				L.visible_message(span_warning("[L] grits through the withering curse!"))
				to_chat(L, span_notice("I steel myself against the curse, enduring it through sheer will!"))
				var/obj/item/held = L.get_active_held_item()
				if(held?.parrysound)
					playsound(get_turf(L), pick(held.parrysound), 100)
				else
					playsound(get_turf(L), pick(L.parry_sound), 100)
				continue
			// Apply or refresh the wither debuff
			var/datum/status_effect/debuff/withered/existing = L.has_status_effect(/datum/status_effect/debuff/withered)
			if(existing)
				existing.refresh()
			else
				L.apply_status_effect(/datum/status_effect/debuff/withered)
				to_chat(L, span_userdanger("A withering curse saps my strength!"))
				new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_HEX, SPELL_IMPACT_MEDIUM)

/obj/effect/wither_zone/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	for(var/obj/effect/temp_visual/V in zone_visuals)
		qdel(V)
	zone_visuals.Cut()
	zone_turfs.Cut()
	caster = null
	return ..()

// Ground visual for each tile in the zone
/obj/effect/temp_visual/wither_ground
	icon = 'icons/effects/effects.dmi'
	icon_state = "curse"
	light_outer_range = 1
	light_color = GLOW_COLOR_HEX
	layer = BELOW_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	randomdir = FALSE
	alpha = 120

/obj/effect/temp_visual/wither_ground/Initialize(mapload, duration_override = 20 SECONDS)
	duration = duration_override
	. = ..()

// Wither debuff — lasts 3 seconds after leaving the zone, refreshed while inside
#define WITHER_FILTER "wither_glow"

/datum/status_effect/debuff/withered
	id = "withered"
	duration = 3 SECONDS
	effectedstats = list(STATKEY_STR = -2, STATKEY_SPD = -2, STATKEY_CON = -2)
	alert_type = /atom/movable/screen/alert/status_effect/debuff/withered
	var/outline_colour = GLOW_COLOR_HEX

/atom/movable/screen/alert/status_effect/debuff/withered
	name = "Withered"
	desc = "A dark curse saps my strength, speed and constitution. (-2 STR, -2 SPD, -2 CON)"
	icon_state = "debuff"

/datum/status_effect/debuff/withered/on_apply()
	. = ..()
	var/filter = owner.get_filter(WITHER_FILTER)
	if(!filter)
		owner.add_filter(WITHER_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 30, "size" = 1))

/datum/status_effect/debuff/withered/on_remove()
	. = ..()
	owner.remove_filter(WITHER_FILTER)

#undef WITHER_FILTER

/obj/effect/temp_visual/trap/hex
	color = GLOW_COLOR_HEX
	light_color = GLOW_COLOR_HEX
