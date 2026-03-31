/*
 * Grasp of Psydon
 *
 * Targeted AoE yank — click a tile up to 4 tiles away on the same Z-level,
 * telegraph appears, then after a short delay all living targets in a 1-tile
 * radius are pulled toward the caster and off-balanced.
 * At 3+ momentum: consumes 3, each yanked target takes 40 blunt to aimed component.
 * 20s cooldown, 0.5s charge up.
 */

/obj/effect/proc_holder/spell/invoked/grasp_of_psydon
	name = "Grasp of Psydon"
	desc = "Slam your open palm forward, sending forth tendrils of arcyne force to a target area up to 4 paces away on the same level. After a brief telegraph, all targets in the area are yanked toward you. \
		At 3+ momentum: consumes 3 to deal 40 blunt damage to the aimed bodypart on each yanked target.\n\n\
		'Push forth your hand with your conduit open, and imagine, with His will, seizing upon the very object or person you desire within your grasp, then, pull your hand backward. Close, and clench your fist, pushing forward slightly, opening your conduit again, and you shall seize your enemy from afar, and pull them toward you.'"
	clothes_req = FALSE
	range = 5
	action_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	overlay_state = "grasp_of_psydon"
	sound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	active = FALSE
	releasedrain = SPELLCOST_MINOR_AOE
	chargedrain = 0
	chargetime = 5
	recharge_time = 20 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("Iqbid!") // https://en.wiktionary.org/wiki/%D9%82%D8%A8%D8%B6 -- "To seize, to take, to grab" in Arabic
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE
	xp_gain = FALSE
	var/area_of_effect = 1
	var/pull_distance = 7
	var/telegraph_delay = 0.8 SECONDS
	var/base_damage = 15
	var/empowered_damage = 40
	var/momentum_cost = 3

/obj/effect/proc_holder/spell/invoked/grasp_of_psydon/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/turf/T = get_turf(targets[1])
	if(!T)
		revert_cast()
		return

	// Same Z-level only — no cross-z casting
	var/turf/target_turf = get_turf(H)
	if(T.z != target_turf.z)
		to_chat(H, span_warning("The tendrils can't reach across planes!"))
		revert_cast()
		return

	// Check and consume momentum for empowerment
	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered grasp!"))

	H.emote("attack", forced = TRUE)

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(affected_turf.density)
			continue
		new /obj/effect/temp_visual/grasp_telegraph(affected_turf)

	playsound(T, 'sound/magic/webspin.ogg', 50, TRUE)

	addtimer(CALLBACK(src, PROC_REF(resolve_grasp), H, T, empowered), telegraph_delay)
	return TRUE

/obj/effect/proc_holder/spell/invoked/grasp_of_psydon/proc/resolve_grasp(mob/living/carbon/human/H, turf/center, empowered = FALSE)
	if(QDELETED(H) || H.stat == DEAD)
		return

	var/turf/caster_turf = get_turf(H)
	playsound(center, 'sound/combat/grabbreak.ogg', 80, TRUE)

	var/hit_count = 0
	for(var/mob/living/victim in range(area_of_effect, center))
		if(victim == H || victim.stat == DEAD)
			continue
		if(victim.anti_magic_check())
			victim.visible_message(span_warning("The tendrils of force can't seem to latch onto [victim]!"))
			playsound(get_turf(victim), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(victim, TRUE))
			victim.visible_message(span_warning("[victim] breaks free of the tendrils!"))
			continue
		var/def_zone = H.zone_selected || BODY_ZONE_CHEST
		arcyne_strike(H, victim, null, base_damage, def_zone, BCLASS_BLUNT, spell_name = "Grasp of Psydon")
		// Empowered: additional 40 blunt to aimed component
		if(empowered)
			arcyne_strike(H, victim, null, empowered_damage, def_zone, BCLASS_BLUNT, spell_name = "Grasp of Psydon (Empowered)")
		// Yank toward caster
		victim.throw_at(caster_turf, pull_distance, 4)

		victim.visible_message(span_warning("[victim] is yanked toward [H] by tendrils of arcyne force!"))
		new /obj/effect/temp_visual/grasp_telegraph/long(get_turf(victim))
		hit_count++

	if(hit_count)
		H.visible_message(span_danger("[H] clenches [H.p_their()] fist, pulling [hit_count > 1 ? "enemies" : "an enemy"] toward [H.p_them()]!"))

	log_combat(H, null, "used Grasp of Psydon[empowered ? " (empowered)" : ""]")

/obj/effect/temp_visual/grasp_telegraph
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	duration = 1 SECONDS

/obj/effect/temp_visual/grasp_telegraph/long
	duration = 2 SECONDS
