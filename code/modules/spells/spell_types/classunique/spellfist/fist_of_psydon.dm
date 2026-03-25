/*
 * Fist of Psydon
 *
 * Targeted 3x3 ground slam — click a tile up to 5 tiles away,
 * telegraph appears, then arcyne force slams the area.
 * 40 blunt damage via arcyne_strike, doubled to 80 if empowered (3 momentum consumed).
 * No knockback — pure damage poke.
 * Dodgeable telegraph (8 ticks).
 * Blade Burst pattern but with arcyne_strike, aimed bodypart, momentum-empowerable.
 */

/obj/effect/proc_holder/spell/invoked/fist_of_psydon
	name = "Fist of Psydon"
	desc = "Slam your fist downward, sending arcyne force crashing into a 3x3 target area up to 5 paces away. \
		Brief telegraph before the strike lands. Deals blunt damage to the aimed bodypart. \
		At 3+ momentum: consumes 3 to double damage. \
		Can be deflected by Defend stance.\n\n\
		'Step forward, rotating your fist into the punch. And, as you strike, envision yourself repeating the same strike in your mynd, and open the arcyne conduit of your arms, but close that of your legs, so that all of your body's weight is behind the strike. Then, at the very last moment, close the conduit of your arms as well, and thus arrest the strike before it come out, and you shall strike as if the fist of Psydon Himself were behind the blow.'"
	clothes_req = FALSE
	range = 5
	action_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	overlay_state = "fist_of_psydon"
	sound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	releasedrain = SPELLCOST_SB_POKE
	chargedrain = 0
	chargetime = 5
	recharge_time = 12 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("Idrib!") // https://en.wiktionary.org/wiki/%D8%B6%D8%B1%D8%A8 -- "To strike, to beat, to hit" in Arabic
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE
	xp_gain = FALSE
	var/base_damage = 40
	var/empowered_mult = 2
	var/momentum_cost = 3
	var/area_of_effect = 1 // 1-tile radius = 3x3
	var/telegraph_delay = TELEGRAPH_DODGEABLE

/obj/effect/proc_holder/spell/invoked/fist_of_psydon/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/turf/T = get_turf(targets[1])
	if(!T)
		revert_cast()
		return

	// Check and consume momentum for empowerment
	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered strike!"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	// Telegraph on 3x3 area
	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/air_strike_telegraph(affected_turf)
	playsound(T, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 60, TRUE)
	H.emote("attackgrunt", forced = TRUE)

	sleep(telegraph_delay)

	if(QDELETED(H) || H.stat == DEAD)
		return

	// Resolve — visual + damage on 3x3
	var/hit_count = 0
	var/deflected = FALSE
	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/kinetic_blast(affected_turf)
		for(var/mob/living/victim in affected_turf)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, deflected ? null : H))
				deflected = TRUE
				continue
			arcyne_strike(H, victim, null, damage, def_zone, BCLASS_BLUNT, spell_name = "Fist of Psydon")
			hit_count++

	playsound(T, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)
	H.emote("attack", forced = TRUE)

	if(hit_count)
		H.visible_message(span_danger("[H] slams [H.p_their()] fist down, sending a shockwave of arcyne force crashing into the ground!"))
	else
		H.visible_message(span_notice("[H] slams [H.p_their()] fist down, sending a shockwave into empty ground!"))

	log_combat(H, null, "used Fist of Psydon[empowered ? " (empowered)" : ""]")
	return TRUE
