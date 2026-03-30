/datum/action/cooldown/spell/frozen_mist
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Frozen Mist"
	desc = "Conjure a persistent cloud of freezing mist over a large area. \
	Everyone caught within is immediately afflicted with full frost stacks and takes burn damage every second. \
	The mist lingers for 10 seconds."
	button_icon_state = "frozen_mist"
	sound = 'sound/spellbooks/crystal.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_CRYOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE
	secondary_resource_type = SPELL_COST_ENERGY
	secondary_resource_cost = 300

	invocations = list("Nebula Glacialis!")
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

	var/mist_duration = 10 SECONDS
	var/tick_damage = 10
	var/mist_radius = 2 // 5x5

/datum/action/cooldown/spell/frozen_mist/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/centerpoint = get_turf(cast_on)
	if(!centerpoint)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(centerpoint.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(centerpoint.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(centerpoint in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	new /obj/effect/frozen_mist(centerpoint, H, src)
	return TRUE

/obj/effect/frozen_mist
	name = "frozen mist"
	desc = "A cloud of freezing mist that chills to the bone."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	light_outer_range = 3
	light_color = GLOW_COLOR_ICE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/mob/living/caster
	var/datum/action/cooldown/spell/source_spell
	var/ticks_remaining
	var/tick_damage = 10
	var/effect_radius = 2
	var/list/mist_visuals = list()

/obj/effect/frozen_mist/Initialize(mapload, mob/living/summoner, datum/action/cooldown/spell/frozen_mist/spell_ref)
	. = ..()
	caster = summoner
	source_spell = spell_ref

	var/mist_duration = 10 SECONDS
	if(istype(spell_ref))
		mist_duration = spell_ref.mist_duration
		tick_damage = spell_ref.tick_damage
		effect_radius = spell_ref.mist_radius

	ticks_remaining = mist_duration / (1 SECONDS)

	var/turf/center = get_turf(src)
	for(var/turf/T in range(effect_radius, center))
		var/obj/effect/temp_visual/frozen_mist_tile/V = new(T, mist_duration + 2 SECONDS)
		mist_visuals += V

	playsound(src, 'sound/spellbooks/crystal.ogg', 80, TRUE)
	initial_frost(center)
	START_PROCESSING(SSprocessing, src)
	QDEL_IN(src, mist_duration + 1 SECONDS)

/obj/effect/frozen_mist/proc/initial_frost(turf/center)
	for(var/turf/T in range(effect_radius, center))
		for(var/mob/living/L in T.contents)
			if(L == caster)
				continue
			if(L.anti_magic_check())
				continue
			if(source_spell?.spell_guard_check(L))
				continue
			apply_frost_stack(L, 3)

/obj/effect/frozen_mist/Destroy()
	caster = null
	source_spell = null
	QDEL_LIST(mist_visuals)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/frozen_mist/process(delta_time)
	if(ticks_remaining <= 0)
		qdel(src)
		return

	ticks_remaining--
	playsound(src, pick('sound/spellbooks/icicle.ogg', 'sound/spellbooks/crystal.ogg'), 40, TRUE)

	var/turf/center = get_turf(src)
	for(var/turf/T in range(effect_radius, center))
		for(var/mob/living/L in T.contents)
			if(L == caster)
				continue
			if(L.anti_magic_check())
				continue
			if(source_spell?.spell_guard_check(L))
				continue
			apply_frost_stack(L, 3)
			var/actual_damage = rand(5, tick_damage)
			if(ishuman(L) && ishuman(caster))
				arcyne_strike(caster, L, null, actual_damage, BODY_ZONE_CHEST, \
					BCLASS_BURN, spell_name = "Frozen Mist", \
					damage_type = BURN, npc_simple_damage_mult = 1, \
					skip_animation = TRUE, skip_message = TRUE)
			else
				L.adjustFireLoss(actual_damage)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_ICE, SPELL_IMPACT_MEDIUM)

/obj/effect/temp_visual/frozen_mist_tile
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	name = "frozen mist"
	desc = "Freezing mist blankets the area."
	randomdir = FALSE
	layer = ABOVE_MOB_LAYER
	light_outer_range = 1
	light_color = GLOW_COLOR_ICE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/frozen_mist_tile/Initialize(mapload, custom_duration)
	if(custom_duration)
		duration = custom_duration
	. = ..()
