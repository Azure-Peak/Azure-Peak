/* Shared helper procs for Spellblade pseudo-melee abilities.
These mirror the species.dm melee attack flow (armor check -> apply_damage -> bodypart_attacked_by)
without going through the click pipeline, so spells can deliver weapon-style strikes. */

/proc/arcyne_strike(mob/living/carbon/human/user, mob/living/target, obj/item/weapon, damage, def_zone, blade_class_override, armor_penetration = 0, spell_name = "Arcyne Strike", skip_animation = FALSE, skip_message = FALSE, allow_shield_check = FALSE, damage_type = BRUTE, npc_simple_damage_mult = 1, intdamage_factor, exact_zone = FALSE)
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
			armor_penetration = PEN_NONE // Blunt uses DR, not penetration
		if(BCLASS_STAB, BCLASS_PICK)
			blade_class = BCLASS_STAB
			attack_flag = "stab"
		if(BCLASS_PIERCE)
			blade_class = BCLASS_PIERCE
			attack_flag = "piercing"
		if(BCLASS_BURN)
			attack_flag = "fire"
		else
			blade_class = BCLASS_CUT
			attack_flag = "slash"

	if(!def_zone)
		def_zone = user.zone_selected || BODY_ZONE_CHEST

	// exact_zone bypasses the roll entirely, striking precisely where the caster aimed.
	if(!exact_zone && def_zone != BODY_ZONE_CHEST && isliving(target))
		// A bound weapon carries arcyne as its own skill, so Bind Armament transfers accuracy onto it.
		var/datum/skill/accuracy_skill = weapon?.associated_skill || /datum/skill/combat/arcyne
		var/accuracy_bonus = user.get_skill_level(accuracy_skill) * 8
		switch(blade_class)
			if(BCLASS_STAB)
				accuracy_bonus += 10
			if(BCLASS_CUT)
				accuracy_bonus += 6
			if(BCLASS_BLUNT)
				if(check_zone(def_zone) != def_zone)
					accuracy_bonus -= 10
		if(weapon?.wlength == WLENGTH_SHORT)
			accuracy_bonus += 10
		def_zone = resolve_aimed_zone(def_zone, user, target, accuracy_bonus)

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
		if(BCLASS_BURN)
			visual_effect = ATTACK_EFFECT_MECHFIRE
	if(!skip_animation)
		user.do_attack_animation(target, visual_effect, weapon, item_animation_override = anim_type)

	var/datum/status_effect/buff/clash/limbguard/LG = target.has_status_effect(/datum/status_effect/buff/clash/limbguard)
	if(LG?.is_active && LG.protected_zone == def_zone && user != target)
		LG.process_attack(target, target, user, weapon, def_zone)
		return 0

	// Optional shield check — blocked like a projectile (shield takes 25% as integrity damage).
	if(allow_shield_check && ishuman(target))
		var/mob/living/carbon/human/H = target
		if(user != H && H.check_shields(weapon, damage, spell_name, MELEE_ATTACK, armor_penetration))
			// Shield eats the hit but takes integrity damage, matching projectile behavior
			for(var/obj/item/I in H.held_items)
				if(I.block_chance > 0)
					I.take_damage(floor(damage / 4))
					break
			return 0

	// NPC damage multiplier (e.g. fireball's npc_simple_damage_mult)
	if(npc_simple_damage_mult != 1 && istype(target, /mob/living/simple_animal))
		damage = round(damage * npc_simple_damage_mult)

	// Default intdamage factor: blunt gets 1.6x; everything else gets 1.0
	if(isnull(intdamage_factor))
		intdamage_factor = (blade_class == BCLASS_BLUNT) ? BLUNT_DEFAULT_INT_DAMAGEFACTOR : 1
	var/armor_block = target.run_armor_check(def_zone, attack_flag, blade_dulling = blade_class, armor_penetration = armor_penetration, damage = damage, intdamfactor = intdamage_factor, no_debuff = TRUE)
	var/damage_dealt = target.apply_damage(damage, damage_type, def_zone, armor_block)
	SEND_SIGNAL(target, COMSIG_ATOM_WAS_ATTACKED, user, damage)

	// Match standard melee flow: only apply wounds if damage actually got through armor
	if(damage_dealt)
		var/wound_damage = max(0, damage - armor_block)
		if(wound_damage > 0)
			if(iscarbon(target))
				var/mob/living/carbon/C = target
				var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(def_zone))
				if(affecting)
					affecting.bodypart_attacked_by(blade_class, wound_damage, user, def_zone, crit_message = TRUE, weapon = weapon, no_debuff = TRUE)
					var/dismember_chance = affecting.get_spell_dismemberment_chance(damage, blade_class, def_zone)
					if(dismember_chance && prob(dismember_chance))
						affecting.dismember(damage_type, blade_class, user, def_zone)
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
		if(BCLASS_BURN)
			attack_verb = "scorches"
			hit_sound = 'sound/items/firelight.ogg'

	playsound(get_turf(target), hit_sound, 100, TRUE)
	if(!skip_message)
		var/weapon_name = weapon ? weapon.name : lowertext(spell_name)
		var/armor_msg = ""
		if(!damage_dealt)
			armor_msg += VISMSG_ARMOR_BLOCKED
			// Show armor integrity status (crumbling, cracking, etc.) matching normal melee
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/obj/item/clothing/C = H.get_best_worn_armor(def_zone, attack_flag)
				var/extra_msg = C?.get_armor_integ()
				if(extra_msg)
					armor_msg += extra_msg
		target.visible_message(
			span_danger("[user] [attack_verb] \the [target] with [weapon_name] in the [parse_zone(def_zone)]![armor_msg]"),
			span_danger("[user] [attack_verb] me in the [span_userdanger(parse_zone(def_zone))]![armor_msg]"),
			null, COMBAT_MESSAGE_RANGE)

	log_combat(user, target, "spell-struck ([spell_name])", zone=def_zone)
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
