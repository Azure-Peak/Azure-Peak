/* Shared helper procs for Spellblade pseudo-melee abilities.
These mirror the species.dm melee attack flow (armor check -> apply_damage -> bodypart_attacked_by)
without going through the click pipeline, so spells can deliver weapon-style strikes. */

/proc/arcyne_strike(mob/living/carbon/human/user, mob/living/target, obj/item/weapon, damage, def_zone, blade_class_override, armor_penetration = 0, spell_name = "Arcyne Strike", skip_animation = FALSE, skip_message = FALSE)
	if(!user || !target || QDELETED(user) || QDELETED(target))
		return FALSE

	var/blade_class = BCLASS_CUT
	var/attack_flag = "slash"
	if(blade_class_override)
		blade_class = blade_class_override
	else
		var/datum/intent/current_intent = user.a_intent
		if(current_intent)
			blade_class = current_intent.blade_class

	switch(blade_class)
		if(BCLASS_BLUNT, BCLASS_SMASH)
			blade_class = BCLASS_BLUNT
			attack_flag = "blunt"
			armor_penetration = BLUNT_DEFAULT_PENFACTOR // It is BLUNT
		if(BCLASS_STAB, BCLASS_PICK)
			blade_class = BCLASS_STAB
			attack_flag = "stab"
		else
			blade_class = BCLASS_CUT
			attack_flag = "slash"

	if(!def_zone)
		def_zone = user.zone_selected || BODY_ZONE_CHEST

	// Zone accuracy uses the same system as ranged — precise zones are capped.
	// Base accuracy from PER/INT: 60 base + 10 per point of PER above 10 + 10 per point of INT above 10
	// Below 10 penalizes instead. A class-intended spellblade (PER ~12, INT ~12) gets ~100 base accuracy.
	// This feeds into bullet_hit_accuracy_check which caps ultra-precise at 50%, precise at 75%, face at 30%.
	if(def_zone != BODY_ZONE_CHEST && isliving(target))
		var/base_accuracy = 60
		base_accuracy += (user.STAPER - 10) * 10
		base_accuracy += (user.STAINT - 10) * 10
		def_zone = target.bullet_hit_accuracy_check(base_accuracy, def_zone)

	if(iscarbon(target))
		var/mob/living/carbon/C = target
		var/obj/item/bodypart/targeting = C.get_bodypart(check_zone(def_zone))
		if(!targeting)
			def_zone = BODY_ZONE_CHEST

	var/visual_effect = ATTACK_EFFECT_SLASH
	var/anim_type = ATTACK_ANIMATION_SWIPE
	switch(blade_class)
		if(BCLASS_BLUNT)
			visual_effect = ATTACK_EFFECT_SMASH
			anim_type = ATTACK_ANIMATION_BONK
		if(BCLASS_STAB)
			anim_type = ATTACK_ANIMATION_THRUST
	if(!skip_animation)
		user.do_attack_animation(target, visual_effect, weapon, item_animation_override = anim_type)

	var/armor_block = target.run_armor_check(def_zone, attack_flag, blade_dulling = blade_class, armor_penetration = armor_penetration, damage = damage)
	var/damage_dealt = target.apply_damage(damage, BRUTE, def_zone, armor_block)

	// Match standard melee flow: only apply wounds if damage actually got through armor
	if(damage_dealt)
		var/wound_damage = max(0, damage - armor_block)
		if(wound_damage > 0)
			if(iscarbon(target))
				var/mob/living/carbon/C = target
				var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(def_zone))
				if(affecting)
					affecting.bodypart_attacked_by(blade_class, wound_damage, user, def_zone, crit_message = TRUE, weapon = weapon)
			else
				target.simple_woundcritroll(blade_class, wound_damage, user, def_zone, crit_message = TRUE)

	var/attack_verb = "strikes"
	var/hit_sound
	switch(blade_class)
		if(BCLASS_CUT)
			attack_verb = "slashes"
			hit_sound = pick('sound/combat/hits/bladed/largeslash (1).ogg', 'sound/combat/hits/bladed/largeslash (2).ogg', 'sound/combat/hits/bladed/largeslash (3).ogg')
		if(BCLASS_BLUNT)
			attack_verb = "smashes"
			hit_sound = pick('sound/combat/hits/blunt/genblunt (1).ogg', 'sound/combat/hits/blunt/genblunt (2).ogg', 'sound/combat/hits/blunt/genblunt (3).ogg')
		if(BCLASS_STAB)
			attack_verb = "stabs"
			hit_sound = pick('sound/combat/hits/bladed/genthrust (1).ogg', 'sound/combat/hits/bladed/genthrust (2).ogg')

	playsound(get_turf(target), hit_sound, 100, TRUE)
	if(!skip_message)
		var/weapon_name = weapon ? weapon.name : "arcyne force"
		user.visible_message(
			span_danger("[user] [attack_verb] [target] with [weapon_name]!"),
			span_notice("I [attack_verb] [target] with my [weapon_name]!"))
	// Victim always sees where they were hit
	if(target != user)
		to_chat(target, span_danger("The strike hits my [span_userdanger(parse_zone(def_zone))]!"))

	log_combat(user, target, "spell-struck ([spell_name])")
	return max(0, damage - armor_block)

/proc/arcyne_get_weapon(mob/living/carbon/human/H)
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M?.bound_weapon)
		return null
	if(H.is_holding(M.bound_weapon))
		return M.bound_weapon
	return null

/* Shared blink/teleport validation used by Blink, Caedo, and any future teleport spell.
Returns null on success, or an error string describing the failure. */
/proc/arcyne_validate_blink_dest(turf/dest, mob/user)
	if(!dest)
		return "Invalid target location!"
	if(dest.teleport_restricted)
		return "I can't teleport here!"
	var/turf/start = get_turf(user)
	if(dest.z != start.z)
		return "I can only teleport on the same plane!"
	if(istransparentturf(dest))
		return "I cannot teleport to the open air!"
	if(dest.density)
		return "I cannot teleport into a wall!"
	for(var/obj/structure/roguewindow/W in dest)
		if(W.density)
			return "I cannot teleport through a window!"
	for(var/obj/structure/mineral_door/door in dest)
		if(door.density)
			return "I cannot teleport through a door!"
	for(var/obj/structure/bars/B in dest)
		if(B.density)
			return "I cannot teleport through bars!"
	for(var/obj/structure/gate/G in dest)
		if(G.density)
			return "I cannot teleport through a gate!"
	return null

/* Validates the path between start and dest for obstacles.
Excludes dest turf from wall checks (you're landing there, not passing through).
Returns null on success, or an error string. */
/proc/arcyne_validate_blink_path(turf/start, turf/dest)
	var/list/turf_list = getline(start, dest)
	if(length(turf_list) > 0)
		turf_list.len--
	for(var/turf/T in turf_list)
		if(T == start)
			continue
		if(T.density)
			return "I cannot teleport through walls!"
		for(var/obj/structure/mineral_door/door in T.contents)
			if(door.density)
				return "I cannot teleport through doors!"
		for(var/obj/structure/roguewindow/window in T.contents)
			if(window.density && !window.climbable)
				return "I cannot teleport through windows!"
		for(var/obj/structure/bars/B in T.contents)
			if(B.density)
				return "I cannot teleport through bars!"
		for(var/obj/structure/gate/G in T.contents)
			if(G.density)
				return "I cannot teleport through gates!"
	return null

/* Walks toward target up to max_range tiles, returning the farthest valid turf.
Used by Caedo to clamp distance instead of failing when out of range. */
/proc/arcyne_find_max_blink_dest(mob/user, turf/target, max_range)
	var/turf/start = get_turf(user)
	if(!start || !target)
		return null
	var/list/full_line = getline(start, target)
	var/turf/best = null
	var/steps = 0
	for(var/turf/T in full_line)
		if(T == start)
			continue
		steps++
		if(steps > max_range)
			break
		var/err = arcyne_validate_blink_dest(T, user)
		if(err)
			break
		var/path_err = arcyne_validate_blink_path(start, T)
		if(path_err)
			break
		best = T
	return best
