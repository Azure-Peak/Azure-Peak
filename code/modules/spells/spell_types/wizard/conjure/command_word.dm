#define CONJURE_TAUNT_TELEGRAPH (1.5 SECONDS)
#define CONJURE_OVERLOAD_WINDUP (3.5 SECONDS)

/obj/effect/temp_visual/conjure_taunt
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	layer = BELOW_MOB_LAYER
	color = GLOW_COLOR_ARCANE
	duration = CONJURE_TAUNT_TELEGRAPH

/datum/action/cooldown/spell/command_word
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	sound = null
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	click_to_activate = TRUE
	cast_range = 12
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_NONE

	charge_required = FALSE
	cooldown_time = 1 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 0

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/current_mode = 1
	var/list/modes = list()
	var/command_range = 12
	var/focusing = FALSE

/datum/action/cooldown/spell/command_word/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/command_word/proc/apply_mode(index)
	if(!length(modes))
		return
	current_mode = index
	var/list/mode = modes[index]
	invocations = list(mode["invocation"])
	cooldown_time = mode["cooldown"]
	build_all_button_icons()
	update_mode_maptext()

/datum/action/cooldown/spell/command_word/toggle_alt_mode(mob/user)
	if(length(modes) < 2)
		return FALSE
	apply_mode((current_mode % length(modes)) + 1)
	if(user)
		user.balloon_alert(user, modes[current_mode]["name"])
	return TRUE

/datum/action/cooldown/spell/command_word/proc/update_mode_maptext()
	if(!length(modes))
		return
	var/list/mode = modes[current_mode]
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(mode["tag"])
		holder.maptext_x = 5
		holder.color = mode["color"]

/datum/action/cooldown/spell/command_word/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	if(length(modes))
		var/mdesc = modes[current_mode]["desc"]
		stats += span_info("Command (toggle with Shift+G): [modes[current_mode]["name"]][mdesc ? " - [mdesc]" : ""]")
	return stats

/datum/action/cooldown/spell/command_word/cast(atom/cast_on)
	. = ..()
	return fire_command(cast_on)

/datum/action/cooldown/spell/command_word/proc/get_summons_in_range()
	var/mob/living/user = owner
	var/list/found = list()
	if(!istype(user))
		return found
	for(var/mob/living/M in user.summoned_minions)
		if(QDELETED(M) || M.stat == DEAD || M == user)
			continue
		if(get_dist(user, M) > command_range)
			continue
		found += M
	return found

/datum/action/cooldown/spell/command_word/proc/find_nearest_enemy(mob/living/summon)
	var/mob/living/nearest
	var/nearest_dist = INFINITY
	for(var/mob/living/L in oview(9, summon))
		if(QDELETED(L) || L.stat == DEAD || L == summon)
			continue
		if(summon.faction_check_mob(L))
			continue
		var/d = get_dist(summon, L)
		if(d < nearest_dist)
			nearest_dist = d
			nearest = L
	return nearest

/datum/action/cooldown/spell/command_word/proc/fire_command(atom/cast_on)
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	var/list/summons = get_summons_in_range()
	if(!length(summons))
		to_chat(user, span_warning("I have no conjured servants at hand to command."))
		return FALSE

	var/atom/aim
	if(isliving(cast_on) && !(cast_on in summons) && cast_on != user)
		aim = cast_on
	else if(isturf(cast_on))
		aim = cast_on

	var/key = modes[current_mode]["key"]
	if(key == "focus")
		return do_focus(summons)
	if(key == "taunt")
		return do_taunt(summons, get_turf(cast_on))
	if(key == "overload")
		var/mob/living/bomb = pick_overload_summon(summons, cast_on)
		if(!bomb)
			return FALSE
		to_chat(user, span_userdanger("[bomb] surges with unstable arcyne power - it will overload!"))
		return summon_overload(bomb)

	var/count = 0
	var/balloon = "<font color='[modes[current_mode]["color"]]'>[lowertext(modes[current_mode]["name"])]!</font>"
	for(var/mob/living/summon in summons)
		if(command_summon(summon, key, aim))
			summon.balloon_alert_to_viewers(balloon)
			count++

	if(!count)
		to_chat(user, span_warning("None of my servants can answer that command right now."))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/command_word/proc/command_summon(mob/living/summon, key, atom/aim)
	switch(key)
		if("special")
			return summon_special(summon, aim)
		if("defend")
			return summon_guard(summon, aim)
		if("feint")
			return summon_feint(summon, aim)
		if("kick")
			return summon_kick(summon, aim)
		if("surge", "bloodrush", "empower")
			return empower_summon(summon, key, aim)
	return FALSE

/datum/action/cooldown/spell/command_word/proc/is_primordial(mob/living/summon)
	return istype(summon, /mob/living/simple_animal/hostile/retaliate/rogue/primordial)

/datum/action/cooldown/spell/command_word/proc/primordial_ward(mob/living/simple_animal/hostile/retaliate/rogue/primordial/P)
	P.defprob = min(initial(P.defprob) + 40, 95)
	addtimer(CALLBACK(src, PROC_REF(end_primordial_ward), P), 5 SECONDS)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/end_primordial_ward(mob/living/simple_animal/hostile/retaliate/rogue/primordial/P)
	if(QDELETED(P))
		return
	P.defprob = initial(P.defprob)

/datum/action/cooldown/spell/command_word/proc/primordial_shove(mob/living/simple_animal/hostile/retaliate/rogue/primordial/P, mob/living/target)
	var/shove_dir = get_dir(P, target)
	var/turf/dest = get_ranged_target_turf(target, shove_dir, 2)
	if(dest)
		target.throw_at(dest, 2, 1, P)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/primordial_heal(mob/living/simple_animal/hostile/retaliate/rogue/primordial/P)
	if(world.time < P.next_heal_time)
		return FALSE
	P.next_heal_time = world.time + 15 SECONDS
	P.adjustHealth(-round(P.maxHealth * 0.25))
	return TRUE

/datum/action/cooldown/spell/command_word/proc/primordial_overcharge(mob/living/simple_animal/hostile/retaliate/rogue/primordial/P)
	P.next_ability_use = 0
	return TRUE

/datum/action/cooldown/spell/command_word/proc/summon_special(mob/living/summon, atom/aim)
	var/atom/target = aim
	if(!target && summon.ai_controller)
		target = summon.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		target = find_nearest_enemy(summon)
	if(!target)
		return FALSE

	if(istype(summon, /mob/living/simple_animal/hostile/retaliate/rogue/primordial))
		var/mob/living/simple_animal/hostile/retaliate/rogue/primordial/P = summon
		if(world.time < P.next_ability_use)
			return FALSE
		P.face_atom(target)
		P.ability(get_turf(target), P)
		P.next_ability_use = world.time + P.ability_cooldown
		return TRUE

	if(summon.has_status_effect(/datum/status_effect/debuff/specialcd))
		return FALSE
	var/obj/item/rogueweapon/W = summon.get_active_held_item()
	if(!istype(W) || !W.special)
		return FALSE
	summon.face_atom(target)
	if(!W.special.check_reqs(summon, W))
		return FALSE
	if(!W.special.apply_cost(summon))
		return FALSE
	W.special.deploy(summon, W, target)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/summon_guard(mob/living/summon, atom/aim)
	var/atom/target = aim
	if(!target && summon.ai_controller)
		target = summon.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		target = find_nearest_enemy(summon)
	if(target)
		summon.face_atom(target)
	if(is_primordial(summon))
		return primordial_ward(summon)
	if(!ishuman(summon))
		return FALSE
	var/mob/living/carbon/human/H = summon
	H.cmode = TRUE
	return H.try_guard()

/datum/action/cooldown/spell/command_word/proc/summon_feint(mob/living/summon, atom/aim)
	var/atom/target = aim
	if(!target && summon.ai_controller)
		target = summon.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		target = find_nearest_enemy(summon)
	if(!isliving(target))
		return FALSE
	summon.face_atom(target)
	var/datum/rmb_intent/feint/F = new()
	F.special_attack(summon, target)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/summon_kick(mob/living/summon, atom/aim)
	var/atom/target = aim
	if(!target && summon.ai_controller)
		target = summon.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		target = find_nearest_enemy(summon)
	if(!isliving(target) || !summon.Adjacent(target))
		return FALSE
	summon.face_atom(target)
	if(is_primordial(summon))
		return primordial_shove(summon, target)
	INVOKE_ASYNC(src, PROC_REF(do_kick), summon, target)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/do_kick(mob/living/summon, mob/living/target)
	if(QDELETED(summon) || QDELETED(target))
		return
	var/old_mmb = summon.mmb_intent
	summon.mmb_intent = new INTENT_KICK(summon)
	summon.try_kick(target)
	QDEL_NULL(summon.mmb_intent)
	summon.mmb_intent = old_mmb

/datum/action/cooldown/spell/command_word/proc/do_focus(list/summons)
	focusing = !focusing
	var/mob/living/user = owner
	var/zone = user.zone_selected
	var/count = 0
	for(var/mob/living/summon in summons)
		if(!summon.ai_controller)
			continue
		if(focusing)
			summon.ai_controller.set_blackboard_key(BB_FORCED_ATTACK_ZONE, zone)
			summon.balloon_alert_to_viewers("<font color='[modes[current_mode]["color"]]'>focus!</font>")
		else
			summon.ai_controller.clear_blackboard_key(BB_FORCED_ATTACK_ZONE)
		count++
	if(!count)
		return TRUE
	if(focusing)
		to_chat(user, span_notice("My servants lock onto where I aim - the [parse_zone(zone)]."))
	else
		to_chat(user, span_notice("My servants return to striking where they see fit."))
	return TRUE

/datum/action/cooldown/spell/command_word/proc/overload_scale(mob/living/summon)
	if(istype(summon, /mob/living/carbon/human/species/goblin/npc/conjured))
		return 1/3
	if(istype(summon, /mob/living/simple_animal/hostile/retaliate/rogue/primordial))
		return 0.5
	return 1

/datum/action/cooldown/spell/command_word/proc/pick_overload_summon(list/summons, atom/cast_on)
	if(isliving(cast_on) && (cast_on in summons))
		return cast_on
	var/turf/ref = get_turf(cast_on)
	if(!ref)
		ref = get_turf(owner)
	var/mob/living/best
	var/best_dist = INFINITY
	for(var/mob/living/S in summons)
		var/d = get_dist(S, ref)
		if(d < best_dist)
			best_dist = d
			best = S
	return best

/datum/action/cooldown/spell/command_word/proc/summon_overload(mob/living/summon)
	summon.do_jitter_animation(1000)
	summon.Slowdown(3)
	summon.balloon_alert_to_viewers("<font color='[GLOW_COLOR_FIRE]'>detonating! (-4 spd)</font>")
	addtimer(CALLBACK(src, PROC_REF(do_overload), summon, overload_scale(summon)), CONJURE_OVERLOAD_WINDUP)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/do_overload(mob/living/summon, scale)
	if(QDELETED(summon) || summon.stat == DEAD)
		return
	var/turf/epicenter = get_turf(summon)
	if(!epicenter)
		return
	var/mob/living/carbon/human/caster = owner
	if(!istype(caster))
		caster = null
	var/zone = summon.zone_selected || BODY_ZONE_CHEST
	var/damage = round(120 * scale)
	var/curtain_life = (scale >= 1) ? 8 SECONDS : 3 SECONDS
	new /obj/effect/temp_visual/explosion(epicenter)
	new /obj/effect/temp_visual/fire_pillar(epicenter)
	playsound(epicenter, pick('sound/misc/explode/explosionclose (1).ogg', 'sound/misc/explode/explosionclose (2).ogg', 'sound/misc/explode/explosionclose (3).ogg'), 100, TRUE)
	for(var/turf/T in range(1, epicenter))
		new /obj/effect/temp_visual/dragonfire(T)
		new /obj/effect/curtain_fire(T, curtain_life, caster)
		for(var/mob/living/victim in T)
			if(victim == summon || victim == caster || victim.stat == DEAD)
				continue
			if(summon.faction_check_mob(victim))
				continue
			if(victim.guard_deflect_spell("Overloaded", TRUE, caster))
				continue
			if(caster && !QDELETED(caster))
				arcyne_strike(caster, victim, null, damage, zone, BCLASS_BURN, spell_name = "Overloaded", damage_type = BURN, skip_animation = TRUE)
			else
				victim.adjustFireLoss(damage)
			apply_scorch_stack(victim, 2, zone)
			victim.apply_status_effect(/datum/status_effect/debuff/exposed, 4 SECONDS)
	summon.death()

/datum/action/cooldown/spell/command_word/proc/empower_summon(mob/living/summon, key, atom/aim)
	if(is_primordial(summon))
		switch(key)
			if("surge", "bloodrush")
				return primordial_heal(summon)
			if("empower")
				return primordial_overcharge(summon)
		return FALSE
	switch(key)
		if("surge")
			return do_surge(summon)
		if("bloodrush")
			summon.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
			return TRUE
		if("empower")
			if(summon.has_status_effect(/datum/status_effect/buff/empowered_strike))
				return FALSE
			summon.apply_status_effect(/datum/status_effect/buff/empowered_strike, 10 SECONDS)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/command_word/proc/do_surge(mob/living/summon)
	summon.SetUnconscious(0)
	summon.SetSleeping(0)
	summon.SetParalyzed(0)
	summon.SetImmobilized(0)
	summon.SetStun(0)
	summon.SetKnockdown(0)
	if(summon.has_status_effect(/datum/status_effect/incapacitating/off_balanced))
		summon.remove_status_effect(/datum/status_effect/incapacitating/off_balanced)
	if(iscarbon(summon))
		var/mob/living/carbon/C = summon
		C.stam_paralyzed = FALSE
	summon.set_resting(FALSE)
	summon.stamina_add(-10)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/do_taunt(list/summons, turf/dest)
	if(!isturf(dest) || !length(summons))
		return FALSE
	new /obj/effect/temp_visual/conjure_taunt(dest)
	for(var/mob/living/summon in summons)
		if(QDELETED(summon) || summon.stat == DEAD)
			continue
		summon.Beam(dest, "purple_lightning", time = CONJURE_TAUNT_TELEGRAPH)
	playsound(dest, 'sound/magic/charging.ogg', 60, TRUE)
	addtimer(CALLBACK(src, PROC_REF(finish_taunt), summons.Copy(), dest), CONJURE_TAUNT_TELEGRAPH)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/finish_taunt(list/summons, turf/dest)
	if(!isturf(dest))
		return
	new /obj/effect/temp_visual/blink(dest)
	playsound(dest, 'sound/magic/blink.ogg', 60, TRUE)
	for(var/mob/living/summon in summons)
		if(QDELETED(summon) || summon.stat == DEAD)
			continue
		if(!do_teleport(summon, dest, precision = 2, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE))
			var/turf/landing = get_teleport_turf(dest, 2)
			if(landing)
				summon.forceMove(landing)
		summon.balloon_alert_to_viewers("<font color='#e0a020'>taunt!</font>")
		summon.emote("warcry")
		if(summon.ai_controller)
			var/mob/living/foe = find_nearest_enemy(summon)
			if(foe)
				summon.ai_controller.set_blackboard_key(BB_CURRENT_PET_TARGET, foe)
				summon.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, foe)
		if(isanimal(summon))
			var/mob/living/simple_animal/SA = summon
			SA.pet_passive = FALSE
		for(var/mob/living/enemy in oview(5, summon))
			if(QDELETED(enemy) || enemy.stat == DEAD || enemy == summon)
				continue
			if(summon.faction_check_mob(enemy))
				continue
			var/datum/component/ai_aggro_system/A = enemy.GetComponent(/datum/component/ai_aggro_system)
			if(A)
				A.add_threat_to_mob(summon, 100)

/datum/action/cooldown/spell/command_word/fray
	name = "Fray"
	desc = "Battle order. Order your summon to unleash a Special, or a primordial's special attack. Defend makes it guard. Toggle with Shift-G."
	button_icon_state = "order_servants"
	invocation_type = INVOCATION_SHOUT
	invocations = list("Impetum!")
	cooldown_time = 1 SECONDS
	modes = list(
		list("name" = "Special", "tag" = "SPC", "key" = "special", "color" = GLOW_COLOR_FIRE, "invocation" = "Impetum!", "cooldown" = 1 SECONDS, "desc" = ""),
		list("name" = "Defend", "tag" = "DEF", "key" = "defend", "color" = "#cfe8ff", "invocation" = "Praesidium!", "cooldown" = 1 SECONDS, "desc" = ""),
	)

/datum/action/cooldown/spell/command_word/harry
	name = "Harry"
	desc = "Order your summons to Feint or Kick your enemies. Toggle with Shift+G. "
	button_icon_state = "aetherknife"
	invocation_type = INVOCATION_SHOUT
	invocations = list("Fallere!")
	cooldown_time = 6 SECONDS
	modes = list(
		list("name" = "Feint", "tag" = "FNT", "key" = "feint", "color" = "#c9a0ff", "invocation" = "Fallere!", "cooldown" = 6 SECONDS, "desc" = ""),
		list("name" = "Kick", "tag" = "KCK", "key" = "kick", "color" = "#e0a020", "invocation" = "Calcitra!", "cooldown" = 6 SECONDS, "desc" = ""),
	)

/datum/action/cooldown/spell/command_word/quicken
	name = "Quicken"
	desc = "Powerful abilities to quicken your summons. Empower let their next strike bypass Guard, and reset a Primordial's ability cooldown. Surge removes stun and Blood Rush floods it with vigor and blood. Toggle with Shift+G."
	button_icon_state = "conjure_aegis"
	invocation_type = INVOCATION_SHOUT
	invocations = list("Vera Manus!")
	cooldown_time = 25 SECONDS
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF
	modes = list(
		list("name" = "Empower", "tag" = "EMP", "key" = "empower", "color" = GLOW_COLOR_BUFF, "invocation" = "Vera Manus!", "cooldown" = 30 SECONDS, "desc" = ""),
		list("name" = "Surge", "tag" = "SRG", "key" = "surge", "color" = GLOW_COLOR_BUFF, "invocation" = "Resurge!", "cooldown" = 30 SECONDS, "desc" = ""),
		list("name" = "Blood Rush", "tag" = "RSH", "key" = "bloodrush", "color" = "#d13b2e", "invocation" = "Concita!", "cooldown" = 30 SECONDS, "desc" = ""),
	)

/datum/action/cooldown/spell/command_word/beckon
	name = "Beckon"
	desc = "Taunt teleport your servants to a marked spot and attract their aggression, Overload makes one explode with arcyne energy, Focus sets them to strike the zone you are aiming at, it does not guarantee they'll hit."
	button_icon_state = "primetriangle"
	invocation_type = INVOCATION_SHOUT
	invocations = list("Provoco!")
	cooldown_time = 30 SECONDS
	modes = list(
		list("name" = "Taunt", "tag" = "TNT", "key" = "taunt", "color" = "#e0a020", "invocation" = "Provoco!", "cooldown" = 30 SECONDS, "desc" = ""),
		list("name" = "Overloaded", "tag" = "OVL", "key" = "overload", "color" = GLOW_COLOR_FIRE, "invocation" = "Displode!", "cooldown" = 0, "desc" = ""),
		list("name" = "Focus", "tag" = "FCS", "key" = "focus", "color" = "#66ff66", "invocation" = "Coniunge!", "cooldown" = 0, "desc" = ""),
	)

#undef CONJURE_TAUNT_TELEGRAPH
#undef CONJURE_OVERLOAD_WINDUP
