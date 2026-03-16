/*
 * Fist of Psydon
 *
 * Lineal punch — wind up, then slam arcyne force in a 3-tile line
 * in front of the caster. Like Shatter but unarmed and standalone damage.
 * Short telegraph (2 ticks) before damage resolves.
 * 10s cooldown, 0.5s charge up.
 * 50% bonus damage versus simple-minded creechurs.
 * Can be deflected by Defend stance.
 */

/obj/effect/proc_holder/spell/invoked/fist_of_psydon
	name = "Fist of Psydon"
	desc = "Wind up and punch forward, sending a shockwave of arcyne force in a 3-paces line. \
		Brief telegraph before the strike lands. Deals blunt damage and knocks targets back 1 tile. \
		Damage increased by 50% against simple-minded creechurs. \
		Can be deflected by Defend stance.\n\n\
		'Step forward, rotating your fist into the punch. And, as you strike, envision yourself repeating the same strike in your mynd, and open the arcyne conduit of your arms, but close that of your legs, so that all of your body's weight is behind the strike. Then, at the very last moment, close the conduit of your arms as well, and thus arrest the strike before it come out, and you shall strike as if the fist of Psydon Himself were behind the blow.'"
	clothes_req = FALSE
	range = 7
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
	var/base_damage = 60
	var/line_length = 3
	var/npc_simple_damage_mult = 1.5
	var/push_dist = 1
	var/telegraph_delay = 4

/obj/effect/proc_holder/spell/invoked/fist_of_psydon/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/atom/target = targets[1]
	var/turf/target_turf = get_turf(target)
	var/turf/start = get_turf(H)
	var/facing = get_dir(start, target_turf) || H.dir

	// Build the line of tiles in front of the caster
	var/list/line_turfs = list()
	var/turf/current = start
	for(var/i in 1 to line_length)
		current = get_step(current, facing)
		if(!current || current.density)
			break
		var/struct_blocked = FALSE
		for(var/obj/structure/S in current.contents)
			if(S.density && !S.climbable)
				struct_blocked = TRUE
				break
		if(struct_blocked)
			break
		line_turfs += current

	if(!length(line_turfs))
		to_chat(H, span_warning("There's no room to punch!"))
		revert_cast()
		return

	// Telegraph — show warning on affected tiles
	for(var/turf/T in line_turfs)
		new /obj/effect/temp_visual/air_strike_telegraph(T)

	// Grunt as they wind up the punch
	H.emote("attackgrunt", forced = TRUE)

	addtimer(CALLBACK(src, PROC_REF(resolve_punch), H, line_turfs, facing), telegraph_delay)
	return TRUE

/obj/effect/proc_holder/spell/invoked/fist_of_psydon/proc/resolve_punch(mob/living/carbon/human/H, list/line_turfs, facing)
	if(QDELETED(H) || H.stat == DEAD)
		return

	// Visual and sound effects
	for(var/turf/T in line_turfs)
		new /obj/effect/temp_visual/kinetic_blast(T)
	playsound(get_turf(H), pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)

	H.emote("attack", forced = TRUE)

	// Damage all living targets in the line
	var/hit_count = 0
	var/deflected = FALSE
	var/list/already_hit = list()
	for(var/turf/T in line_turfs)
		for(var/mob/living/victim in T)
			if(victim == H || victim.stat == DEAD || (victim in already_hit))
				continue
			if(spell_guard_check(victim, FALSE, deflected ? null : H))
				deflected = TRUE
				continue
			var/def_zone = H.zone_selected || BODY_ZONE_CHEST
			arcyne_strike(H, victim, null, base_damage, def_zone, BCLASS_BLUNT, spell_name = "Fist of Psydon", npc_simple_damage_mult = npc_simple_damage_mult)
			hit_count++
			already_hit += victim
			// Knockback away from caster
			var/push_dir = get_dir(H, victim)
			if(!push_dir)
				push_dir = facing
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, H, force = MOVE_FORCE_STRONG)

	if(hit_count)
		H.visible_message(span_danger("[H] punches forward, sending a shockwave of arcyne force!"))
	else
		H.visible_message(span_notice("[H] punches forward, sending a shockwave into the air!"))

	log_combat(H, null, "used Fist of Psydon")
