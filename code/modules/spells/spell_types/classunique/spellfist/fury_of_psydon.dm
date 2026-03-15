// Powerful leap attack - min distance gives it some counterplay (of getting close)
// Since otherwise it can be used as a disengagement tool
/obj/effect/proc_holder/spell/invoked/fury_of_psydon
	name = "Fury of Psydon"
	desc = "Channel mana into your legs and leap toward a distant target, flying through the air with the fury of Psydon. \
		On reaching the target, deliver a single devastating kick that cannot be parried or dodged, sending them flying. \
		Can cross gaps, lava, and obstacles during the leap. Can be deflected by Defend stance.\n\n\
		Can only be cast on someone at least 3 paces away.\n\n\
		'Temper the storm within, and unleash it only upon those who stray from His ways.'"
	clothes_req = FALSE
	range = 7
	action_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	overlay_state = "fury_of_psydon"
	sound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	active = FALSE
	releasedrain = 70 // To make you REALLY commit to the kick instead of weaving it in easily
	chargedrain = 0
	chargetime = 2 SECONDS
	recharge_time = 45 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 0
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	invocations = list()
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = TRUE
	xp_gain = FALSE
	var/start_invocation = "'Asifa!"
	var/dash_range = 7
	var/step_delay = 1
	var/kick_damage = 50
	var/npc_simple_damage_mult = 2
	var/knockback_dist = 3
	var/minimum_dist = 2

/obj/effect/proc_holder/spell/invoked/fury_of_psydon/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	// Determine preferred target from click target
	var/mob/living/preferred_target
	var/atom/clicked = targets[1]
	if(isliving(clicked))
		preferred_target = clicked
	else
		var/turf/clicked_turf = get_turf(clicked)
		if(clicked_turf)
			for(var/mob/living/L in clicked_turf)
				if(L != H && L.stat != DEAD)
					preferred_target = L
					break

	// No preferred target, revert cast, no punishment
	if(!preferred_target)
		to_chat(H, span_warning("I need a target to focus my fury on!"))
		revert_cast()
		return

	if(get_dist(H, preferred_target) <= minimum_dist)
		to_chat(H, span_warning("My target is too close for the kick to gather strength!"))
		revert_cast()
		return

	// Shout invocation at the start
	H.say(start_invocation, forced = "spell")

	var/turf/start = get_turf(H)
	var/facing = get_dir(start, get_turf(preferred_target)) || H.dir
	H.dir = facing

	// Already adjacent — skip dash, go straight to kick
	if(get_dist(H, preferred_target) <= 1)
		if(preferred_target.anti_magic_check())
			preferred_target.visible_message(span_warning("The fury dissipates on contact with [preferred_target]!"))
			return
		deliver_kick(H, preferred_target)
		return TRUE

	var/old_pass = H.pass_flags
	var/old_throwing = H.throwing
	H.pass_flags |= PASSMOB
	H.throwing = TRUE
	var/prev_pixel_z = H.pixel_z
	var/prev_transform = H.transform

	animate(H, pixel_z = prev_pixel_z + 18, time = 1, easing = EASE_OUT)

	var/mob/living/hit_target
	for(var/i in 1 to dash_range)
		if(H.stat != CONSCIOUS || H.IsParalyzed() || H.IsStun() || QDELETED(H))
			break

		if(get_dist(H, preferred_target) <= 1)
			hit_target = preferred_target
			break

		facing = get_dir(get_turf(H), get_turf(preferred_target))
		if(!facing)
			break
		H.dir = facing

		var/turf/next = get_step(get_turf(H), facing)
		if(!next)
			break

		step(H, facing)

		if(i < dash_range)
			sleep(step_delay)

	// Slam down with impact tilt
	var/land_angle = pick(-20, -15, 15, 20)
	animate(H, pixel_z = prev_pixel_z, transform = turn(prev_transform, land_angle), time = 1, easing = EASE_IN)
	animate(transform = prev_transform, time = 2)

	H.pass_flags = old_pass
	H.throwing = old_throwing

	// Check adjacency after dash
	if(!hit_target && get_dist(H, preferred_target) <= 1)
		hit_target = preferred_target

	// Missed — full cooldown
	if(!hit_target)
		to_chat(H, span_warning("My fury finds no purchase!"))
		return

	// Anti-magic check
	if(hit_target.anti_magic_check())
		hit_target.visible_message(span_warning("The fury dissipates on contact with [hit_target]!"))
		return

	deliver_kick(H, hit_target)
	return TRUE

/obj/effect/proc_holder/spell/invoked/fury_of_psydon/proc/deliver_kick(mob/living/carbon/human/user, mob/living/target)
	// Guard check — defend stance can still deflect
	if(spell_guard_check(target, FALSE, user))
		log_combat(user, target, "used Fury of Psydon (deflected)")
		return

	user.visible_message(span_danger("<b>[user] delivers a devastating flying kick to [target]!</b>"))
	user.emote("attack", forced = TRUE)

	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	arcyne_strike(user, target, null, kick_damage, def_zone, BCLASS_BLUNT, spell_name = "Fury of Psydon", npc_simple_damage_mult = npc_simple_damage_mult)
	playsound(get_turf(target), pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg'), 100, TRUE)
	playsound(get_turf(target), 'sound/magic/antimagic.ogg', 60, TRUE)

	// Knockback
	var/atom/throw_target = get_edge_target_turf(user, get_dir(user, target))
	target.safe_throw_at(throw_target, knockback_dist, 4)

	log_combat(user, target, "used Fury of Psydon")
