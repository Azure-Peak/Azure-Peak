/datum/action/cooldown/spell/ensnare
	button_icon = 'icons/mob/actions/mage_geomancy.dmi'
	name = "Ensnare"
	desc = "Tendrils of arcyne force hold anyone in a small area in place for a short while."
	button_icon_state = "ensnare"
	sound = 'sound/magic/webspin.ogg'
	spell_color = GLOW_COLOR_EARTHEN
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_GEOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Impedio!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 25 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_LOW

	var/area_of_effect = 1
	var/ensnare_duration = 5 SECONDS
	var/delay = 0.8 SECONDS

/datum/action/cooldown/spell/ensnare/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(affected_turf.density)
			continue
		new /obj/effect/temp_visual/ensnare(affected_turf)

	addtimer(CALLBACK(src, PROC_REF(apply_ensnare), T, H), delay)
	playsound(T, 'sound/magic/webspin.ogg', 50, TRUE)
	return TRUE

/datum/action/cooldown/spell/ensnare/proc/apply_ensnare(turf/T, mob/living/caster)
	for(var/mob/living/simple_animal/hostile/animal in range(area_of_effect, T))
		animal.Paralyze(ensnare_duration, updating = TRUE, ignore_canstun = TRUE)
	for(var/mob/living/L in range(area_of_effect, T))
		if(L == caster)
			continue
		if(L.anti_magic_check())
			L.visible_message(span_warning("The tendrils of force can't seem to latch onto [L]!"))
			playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(L, TRUE, caster))
			L.visible_message(span_warning("[L] breaks free of the tendrils!"))
			continue
		L.Immobilize(ensnare_duration)
		L.OffBalance(ensnare_duration)
		L.visible_message(span_warning("[L] is held by tendrils of arcyne force!"))
		new /obj/effect/temp_visual/ensnare/long(get_turf(L))

/obj/effect/temp_visual/ensnare
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	duration = 1 SECONDS

/obj/effect/temp_visual/ensnare/long
	duration = 3 SECONDS
