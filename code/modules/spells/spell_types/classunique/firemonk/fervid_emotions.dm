/datum/action/cooldown/spell/fervid_emotions
	button_icon = 'icons/mob/actions/classuniquespells/firemonk.dmi'
	button_icon_state = "fervid"
	name = "Fervid Emotions"
	desc = "Convert the energy stored in your tattoos into raw, unfiltered flames - inflicting burn to those around you. \
		Deals minor blunt damage. Inflicts 4 Burn. \
		Can be deflected by Defend stance."

	spell_color = GLOW_COLOR_FIREMONK
	glow_intensity = GLOW_INTENSITY_LOW

	cast_range = 5

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_POKE

	invocations = list("Bào fā!") // tl: to break (out of), to burst
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 12 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	associated_skill = /datum/skill/magic/arcane

	sound = list('sound/magic/firemonk/hitblunt.ogg','sound/magic/firemonk/hitbluntstrong.ogg')
	spell_tier = 2

	var/base_damage = 10
	var/empowered_mult = 2
	var/momentum_cost = 3
	var/area_of_effect = 1 //piss poor damage. its 4 burn application
	var/telegraph_delay = TELEGRAPH_DODGEABLE

/datum/action/cooldown/spell/fervid_emotions/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < momentum_cost)
		if(feedback)
			to_chat(H, span_warning("Not enough momentum! I need at least [momentum_cost] stacks!"))
		return FALSE
	return TRUE


/datum/action/cooldown/spell/fervid_emotions/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/T = get_turf(H)
	if(!T)
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < momentum_cost)
		return FALSE

	var/damage = base_damage
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	// Telegraph on 3x3 area
	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/fervid_emotion_telegraph(affected_turf)
	playsound(T, 'sound/magic/firemonk/prep.ogg', 60, TRUE)
	H.emote("attackgrunt", forced = TRUE)
	H.visible_message(span_warning("[H] crouches down, kicking a leg out..."))

	sleep(telegraph_delay)

	if(QDELETED(H) || H.stat == DEAD)
		return

	// Resolve — visual + damage on 3x3
	var/hit_count = 0
	var/deflected = FALSE
	var/obj/effect/temp_visual/fervid_emotion_spin/spinning_flames = new /obj/effect/temp_visual/fervid_emotion_spin(T)
	spinning_flames.SpinAnimation(8,1,0)
	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		for(var/mob/living/victim in affected_turf)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, deflected ? null : H))
				deflected = TRUE
				continue
			arcyne_strike(H, victim, null, damage, def_zone, BCLASS_BLUNT, spell_name = "Fervid Emotions")
			victim.apply_burn(4)
			hit_count++

	playsound(T, pick('sound/magic/firemonk/hitblunt.ogg', 'sound/magic/firemonk/hitbluntstrong.ogg'), 100, TRUE)

	if(hit_count)
		H.visible_message(span_danger("[H] leaps like a bouncing tiger, spreading flames around!"))
	else
		H.visible_message(span_notice("[H] leaps like a bouncing tiger, spreading flames around!"))

	log_combat(H, null, "used Fervid Emotions")
	return TRUE


/obj/effect/temp_visual/fervid_emotion_telegraph
	icon = 'icons/effects/effects.dmi'
	icon_state = "flame_noburst"
	light_outer_range = 1
	duration = 3
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/fervid_emotion_spin
	icon = 'icons/effects/96x96.dmi'
	icon_state = "flames"
	light_outer_range = 1
	duration = 10
	layer = MASSIVE_OBJ_LAYER
	pixel_x = -32
	pixel_y = -32
