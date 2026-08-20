/mob/living/simple_animal
	var/combat_skill = null
	var/anatomy_type
	var/list/part_damage
	var/list/broken_parts
	var/list/announced_exposed
	var/no_reanimate = FALSE
	var/last_damage_stage = 0
	var/last_hit_part
	var/next_reach_warning = 0

/proc/combat_skill_for_threat(threat)
	switch(threat)
		if(THREAT_ELITE to INFINITY)
			return SKILL_LEVEL_MASTER
		if(THREAT_DEADLY to THREAT_ELITE)
			return SKILL_LEVEL_EXPERT
		if(THREAT_TOUGH to THREAT_DEADLY)
			return SKILL_LEVEL_JOURNEYMAN
		if(THREAT_MODERATE to THREAT_TOUGH)
			return SKILL_LEVEL_APPRENTICE
		if(THREAT_LOW to THREAT_MODERATE)
			return SKILL_LEVEL_NOVICE
	return SKILL_LEVEL_NONE

/mob/living/simple_animal/proc/apply_anatomy_traits()
	var/datum/anatomy/profile = get_anatomy()
	if(profile?.bloodless)
		ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/proc/apply_combat_skill()
	var/level = isnull(combat_skill) ? combat_skill_for_threat(threat_point) : combat_skill
	if(level <= SKILL_LEVEL_NONE)
		return
	adjust_skillrank_up_to(/datum/skill/combat/unarmed, level, TRUE)

/mob/living/proc/register_part_damage(zone, damage, mob/living/user, obj/item/weapon, ranged = FALSE, bclass, penfactor = PEN_NONE, part_mult = 1)
	return

/mob/living/proc/get_zone_melee_hit_bonus(zone)
	return 0

/mob/living/proc/get_zone_ranged_hit_bonus(zone)
	return 0

/mob/living/simple_animal/proc/get_anatomy()
	if(!anatomy_type)
		return null
	return GLOB.anatomy_profiles[anatomy_type]

/mob/living/simple_animal/simple_limb_hit(zone)
	var/datum/anatomy/profile = get_anatomy()
	if(profile?.limb_names)
		var/named = profile.limb_names[zone] || profile.limb_names[check_zone(zone)]
		if(named)
			return named
	return ..()

/mob/living/simple_animal/hit_zone_name(hit_zone)
	return simple_limb_hit(hit_zone)

/mob/living/simple_animal/proc/resolve_reachable_zone(zone, mob/living/user)
	var/datum/anatomy/profile = get_anatomy()
	if(!profile)
		return zone
	var/datum/anatomy_zone/hit_zone = profile.get_zone(zone)
	if(!hit_zone || !hit_zone.requires_prone || is_prone())
		return zone
	if(user?.client && world.time > next_reach_warning)
		next_reach_warning = world.time + REACH_WARNING_COOLDOWN
		to_chat(user, span_warning("I can't land a blow on [p_their()] [hit_zone.hint] while [p_they()] stand[p_s()] - I need to topple [p_them()] first."))
	return BODY_ZONE_CHEST

/mob/living/simple_animal/proc/weakpoint_damage_mod(zone)
	var/datum/anatomy/profile = get_anatomy()
	if(!profile)
		return 1
	var/datum/anatomy_zone/hit_zone = profile.get_zone(zone)
	if(!hit_zone)
		return 1
	if(check_zone(zone) in broken_parts)
		return 1
	return hit_zone.damage_mult

/mob/living/simple_animal/get_zone_melee_hit_bonus(zone)
	var/datum/anatomy/profile = get_anatomy()
	if(!profile)
		return 0
	var/datum/anatomy_zone/hit_zone = profile.get_zone(zone)
	if(!hit_zone)
		return 0
	return hit_zone.melee_hit_bonus

/mob/living/simple_animal/get_zone_ranged_hit_bonus(zone)
	var/datum/anatomy/profile = get_anatomy()
	if(!profile)
		return 0
	var/datum/anatomy_zone/hit_zone = profile.get_zone(zone)
	if(!hit_zone)
		return 0
	return hit_zone.ranged_hit_bonus

/mob/living/simple_animal/register_part_damage(zone, damage, mob/living/user, obj/item/weapon, ranged = FALSE, bclass, penfactor = PEN_NONE, part_mult = 1)
	if(damage <= 0 || !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return
	var/datum/anatomy/profile = get_anatomy()
	if(!profile)
		return
	var/datum/anatomy_zone/hit_zone = profile.get_zone(zone)
	if(!hit_zone || !hit_zone.break_wound)
		return
	if(hit_zone.requires_prone && !is_prone())
		return
	var/norm_zone = check_zone(zone)
	if(norm_zone in broken_parts)
		return
	if(!hit_zone.is_exposed(broken_parts))
		warn_unexposed(hit_zone, user)
		return
	if(!part_damage)
		part_damage = list()
	var/pen_mult = profile.get_pen_part_mult(penfactor, bclass)
	part_damage[norm_zone] += damage * part_mult * (ranged ? RANGED_PART_CONTRIBUTION : 1) * profile.get_part_damage_mult(bclass) * pen_mult
	if(pen_mult > 1)
		announce_penetration(pen_mult, profile.pen_flavor)
	var/part_health = max(hit_zone.part_health_minimum, round(maxHealth * hit_zone.part_health_fraction, 1))
	if(part_damage[norm_zone] < part_health)
		return
	var/break_path = hit_zone.break_wound
	var/datum/wound/cripple/new_break = new break_path()
	new_break.crippled_zone = norm_zone
	new_break.struck_by = user
	if(!simple_add_wound(new_break, crit_message = TRUE) && !has_wound(break_path))
		return
	LAZYADD(broken_parts, norm_zone)
	if(user?.client)
		record_round_statistic(STATS_CRITS_MADE)
	announce_newly_exposed(profile)

/mob/living/simple_animal/proc/announce_penetration(mult, flavor)
	if(mult >= PEN_PART_MULT_BSTEEL)
		next_attack_msg += " [span_boldwarning("The point punches clean through the [flavor]!")]"
	else if(mult >= PEN_PART_MULT_HEAVY)
		next_attack_msg += " [span_warning("The point sinks deep into the [flavor]!")]"
	else
		next_attack_msg += " [span_warning("The point bites into the [flavor].")]"

/mob/living/simple_animal/proc/warn_unexposed(datum/anatomy_zone/hit_zone, mob/living/user)
	if(!user?.client || world.time <= next_reach_warning || !length(broken_parts))
		return
	var/datum/anatomy/profile = get_anatomy()
	var/list/shields = list()
	for(var/zone_needed in hit_zone.requires_broken)
		if(zone_needed in broken_parts)
			continue
		var/datum/anatomy_zone/shield = profile?.get_zone(zone_needed)
		shields |= shield?.hint || parse_zone(zone_needed)
	if(!length(shields))
		return
	next_reach_warning = world.time + REACH_WARNING_COOLDOWN
	to_chat(user, span_warning("[p_their(TRUE)] [hit_zone.hint] is still shielded - I need to break the [english_list(shields)] first."))

/mob/living/simple_animal/proc/announce_newly_exposed(datum/anatomy/profile)
	for(var/zone_key in profile.zones)
		var/datum/anatomy_zone/candidate = profile.zones[zone_key]
		if(!candidate.exposed_message || (candidate.zone in announced_exposed))
			continue
		if(!candidate.is_exposed(broken_parts))
			continue
		LAZYADD(announced_exposed, candidate.zone)
		balloon_alert_to_viewers("<font color='#ff3b3b'>[candidate.exposed_message]</font>")

/mob/living/simple_animal/proc/clear_part_damage(zone)
	if(part_damage)
		part_damage[zone] = 0
	LAZYREMOVE(broken_parts, zone)

/mob/living/simple_animal/proc/reset_part_damage()
	for(var/datum/wound/cripple/crippled in simple_wounds?.Copy())
		simple_remove_wound(crippled)
	part_damage = null
	broken_parts = null
	announced_exposed = null

/mob/living/simple_animal/proc/topple(duration = 3 SECONDS)
	Knockdown(duration, ignore_canstun = TRUE)
	addtimer(CALLBACK(src, PROC_REF(recover_footing)), duration, TIMER_UNIQUE|TIMER_OVERRIDE)

/mob/living/simple_animal/proc/recover_footing()
	if(QDELETED(src) || stat == DEAD)
		return
	if(has_wound(/datum/wound/cripple/limb/topple))
		return
	SetKnockdown(0, ignore_canstun = TRUE)
	set_resting(FALSE, TRUE)
	visible_message(span_warning("[src] recovers its footing."))

/mob/living/simple_animal/proc/is_prone()
	return resting || has_wound(/datum/wound/cripple/limb/topple)

/mob/living/simple_animal/proc/sprite_drawn_prone()
	return LAZYLEN(prone_icon_states) && (icon_state in prone_icon_states)

/mob/living/simple_animal/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, blocked = 0, forced = FALSE, spread_damage = FALSE)
	if(def_zone)
		last_hit_part = def_zone
	return ..()

/mob/living/simple_animal/proc/show_damage_stage()
	if(maxHealth < DAMAGE_STAGE_MIN_HEALTH || stat == DEAD)
		return
	var/ratio = health / maxHealth
	var/stage = 0
	if(ratio < DAMAGE_STAGE_BLOODIED)
		stage = 1
	if(ratio < DAMAGE_STAGE_MANGLED)
		stage = 2
	if(ratio < DAMAGE_STAGE_SAVAGED)
		stage = 3
	if(stage > last_damage_stage)
		var/part = last_hit_part || "body"
		var/word
		switch(stage)
			if(1)
				word = "[part] <br><font color='#c77b7b'>bloodied</font>"
			if(2)
				word = "[part] <br><font color='#bd4b4b'>mangled</font>"
			if(3)
				word = "[part] <br><font color='#7a1e1e'>savaged</font>"
		balloon_alert_to_viewers(word)
	last_damage_stage = stage
