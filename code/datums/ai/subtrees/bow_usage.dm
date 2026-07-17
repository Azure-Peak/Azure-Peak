/datum/ai_planning_subtree/ranged_attack_subtree
	parent_type = /datum/ai_planning_subtree/archer_base

/datum/ai_planning_subtree/ranged_attack_subtree/SelectBehaviors(datum/ai_controller/controller, delta_time)
	if(!validate_archer_equipment(controller))
		return
	var/mob/living/carbon/human/pawn = controller.pawn
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!isliving(target))
		_restore_stashed_weapon(controller, pawn)
		return

	var/obj/item/quiver/Q = controller.blackboard[BB_ARCHER_NPC_QUIVER]
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow = controller.blackboard[BB_ARCHER_NPC_BOW]
	if(!length(Q?.arrows) && !bow?.chambered)
		AI_THINK(pawn, "BOW: out of arrows - falling back to melee")
		_restore_stashed_weapon(controller, pawn)
		return

	if(get_dist(pawn, target) <= ARCHER_NPC_KITE_FLOOR && !_archer_retreat_turf(pawn, target))
		AI_THINK(pawn, "BOW: boxed in at dist [get_dist(pawn, target)], no retreat turf - drawing steel")
		_restore_stashed_weapon(controller, pawn)
		return

	controller.queue_behavior(/datum/ai_behavior/ranged_attack_bow, BB_BASIC_MOB_CURRENT_TARGET)
	if(LAZYACCESS(controller.current_behaviors, GET_AI_BEHAVIOR(/datum/ai_behavior/ranged_attack_bow)))
		return SUBTREE_RETURN_FINISH_PLANNING
	AI_THINK(pawn, "BOW: ranged_attack_bow setup FAILED - could not enter bow stance")
	_restore_stashed_weapon(controller, pawn)

// A skirmisher, not a turret. The archer is always backpedalling away from its mark - before,
// during and after every shot - so it never roots in place. It fires on the move whenever a shot
// is ready, holds still only when the foe is past ARCHER_NPC_KITE_RANGE (no pressure) or a crossbow
// is cranking, and only draws steel when boxed into a corner with the foe adjacent.
/datum/ai_behavior/ranged_attack_bow
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	action_cooldown = 0.2 SECONDS
	required_distance = 0 // we choose a fresh destination every tick - never "arrive and plant"

/datum/ai_behavior/ranged_attack_bow/setup(datum/ai_controller/controller, target_key)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]
	if(!isliving(target))
		return FALSE

	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow = _find_archer_bow(pawn)
	if(!bow)
		AI_THINK(pawn, "BOW-STANCE: _find_archer_bow found nothing (bow not in hands/worn)")
		return FALSE

	if(pawn.get_active_held_item() != bow)
		_enter_bow_stance(controller, pawn, bow)
		var/obj/item/blocker = pawn.get_active_held_item()
		if(blocker != bow)
			AI_THINK(pawn, "BOW-STANCE: could not draw bow, active hand blocked by [blocker || "nothing"][blocker && HAS_TRAIT(blocker, TRAIT_NODROP) ? " (NODROP)" : ""]")
			return FALSE

	var/turf/retreat
	if(get_dist(pawn, target) <= ARCHER_NPC_KITE_RANGE)
		retreat = _archer_retreat_turf(pawn, target)
	set_movement_target(controller, retreat || get_turf(pawn))
	SEND_SIGNAL(controller.pawn, COMSIG_COMBAT_TARGET_SET, TRUE)
	if(istype(bow, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow))
		controller.set_blackboard_key(BB_ARCHER_NPC_NEXT_SHOT, world.time)
	else
		if(!_chamber_from_quiver(pawn, bow))
			return FALSE
		if(controller.blackboard[BB_ARCHER_NPC_NEXT_SHOT] < world.time) // a future stamp is a draw already in progress - replanning must not restart it
			controller.set_blackboard_key(BB_ARCHER_NPC_NEXT_SHOT, world.time + bow.get_npc_chargetime(pawn))
	return TRUE

/datum/ai_behavior/ranged_attack_bow/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]

	if(!isliving(target) || target.stat == DEAD)
		finish_action(controller, FALSE, target_key)
		return
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow = pawn.get_active_held_item()
	if(!istype(bow))
		finish_action(controller, FALSE, target_key)
		return

	var/dist = get_dist(pawn, target)
	var/is_crossbow = istype(bow, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow)

	if(!bow.chambered)
		if(is_crossbow)
			if(!_quiver_has_ammo(pawn))
				finish_action(controller, FALSE, target_key)
				return
			if(!_reload_crossbow(controller, pawn, bow, target))
				return
		else if(!_chamber_from_quiver(pawn, bow))
			finish_action(controller, FALSE, target_key)
			return

	pawn.face_atom(target)

	var/has_los = can_see(pawn, target, ARCHER_NPC_SHOOT_RANGE)
	// Loose the instant a shot is ready; we never stop moving to do it (move-and-perform).
	if(bow.chambered && world.time >= controller.blackboard[BB_ARCHER_NPC_NEXT_SHOT] && has_los)
		_loose_arrow(pawn, target, bow)
		if(is_crossbow)
			controller.set_blackboard_key(BB_ARCHER_NPC_NEXT_SHOT, world.time)
		else
			controller.set_blackboard_key(BB_ARCHER_NPC_NEXT_SHOT, world.time + bow.get_npc_chargetime(pawn))
		var/turf/juke = _archer_reposition_turf(pawn, target)
		if(juke)
			controller.set_blackboard_key(BB_ARCHER_NPC_REPOSITION_TURF, juke)
			controller.set_blackboard_key(BB_ARCHER_NPC_REPOSITION_UNTIL, world.time + ARCHER_NPC_REPOSITION_TIME)

	var/draw_slow = _bow_draw_slowdown(bow)
	if(draw_slow && world.time < controller.blackboard[BB_ARCHER_NPC_NEXT_SHOT])
		pawn.add_movespeed_modifier(MOVESPEED_ID_CHARGING, update = TRUE, priority = 100, override = TRUE, multiplicative_slowdown = draw_slow, movetypes = GROUND)
	else
		pawn.remove_movespeed_modifier(MOVESPEED_ID_CHARGING)

	if(dist > ARCHER_NPC_SHOOT_RANGE)
		set_movement_target(controller, target)
		return
	var/turf/juke_to = controller.blackboard[BB_ARCHER_NPC_REPOSITION_TURF]
	if(juke_to && world.time < controller.blackboard[BB_ARCHER_NPC_REPOSITION_UNTIL] && get_turf(pawn) != juke_to && !juke_to.is_blocked_turf(exclude_mobs = TRUE))
		set_movement_target(controller, juke_to)
		return
	controller.clear_blackboard_key(BB_ARCHER_NPC_REPOSITION_TURF)
	if(dist > ARCHER_NPC_KITE_RANGE)
		if(has_los)
			controller.ai_movement.stop_moving_towards(controller) // in the pocket (kite < dist <= shoot) - hold and loose
			return
		var/turf/vantage = _archer_los_turf(pawn, target)
		set_movement_target(controller, vantage || target) // sight blocked - sidestep for an angle, or push in until one opens
		return
	var/turf/retreat = _archer_retreat_turf(pawn, target)
	if(retreat)
		set_movement_target(controller, retreat)
	else if(dist <= ARCHER_NPC_KITE_FLOOR)
		finish_action(controller, FALSE, target_key) // boxed in with the foe adjacent - draw steel
	else
		controller.ai_movement.stop_moving_towards(controller) // boxed in but they're not adjacent - stand and shoot

/datum/ai_behavior/ranged_attack_bow/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	_restore_stashed_weapon(controller, pawn)

/proc/_archer_retreat_turf(mob/living/carbon/human/pawn, atom/target)
	var/away = get_dir(target, pawn)
	var/turf/best = null
	var/turf/probe = get_turf(pawn)
	for(var/i in 1 to ARCHER_NPC_RETREAT_PROJECT)
		var/turf/next = get_step(probe, away)
		if(!next || next.is_blocked_turf(exclude_mobs = TRUE))
			break
		if(get_dist(next, target) > ARCHER_NPC_KITE_RANGE + 2)
			break
		best = next
		probe = next
	if(best)
		return best
	var/cur_dist = get_dist(pawn, target)
	var/list/dirs = GLOB.alldirs.Copy()
	dirs -= get_dir(pawn, target)
	shuffle_inplace(dirs)
	for(var/dir in dirs)
		var/turf/step = get_step(pawn, dir)
		if(!step || step.is_blocked_turf(exclude_mobs = TRUE))
			continue
		if(get_dist(step, target) >= cur_dist)
			return step
	return null

/proc/_archer_reposition_turf(mob/living/carbon/human/pawn, atom/target)
	var/cur_dist = get_dist(pawn, target)
	var/list/dirs = GLOB.alldirs.Copy()
	dirs -= get_dir(pawn, target)
	dirs -= get_dir(target, pawn)
	shuffle_inplace(dirs)
	for(var/dir in dirs)
		var/turf/best = null
		var/turf/probe = get_turf(pawn)
		for(var/i in 1 to rand(2, 3))
			var/turf/next = get_step(probe, dir)
			if(!next || next.is_blocked_turf(exclude_mobs = TRUE))
				break
			best = next
			probe = next
		if(best && get_dist(best, target) >= cur_dist && get_dist(best, target) <= ARCHER_NPC_SHOOT_RANGE)
			return best
	return null

/proc/_archer_los_turf(mob/living/carbon/human/pawn, atom/target)
	var/list/dirs = GLOB.alldirs.Copy()
	dirs -= get_dir(pawn, target)
	dirs -= get_dir(target, pawn)
	shuffle_inplace(dirs)
	for(var/dir in dirs)
		var/turf/probe = get_turf(pawn)
		for(var/i in 1 to 3)
			var/turf/next = get_step(probe, dir)
			if(!next || next.is_blocked_turf(exclude_mobs = TRUE))
				break
			probe = next
			if(get_dist(probe, target) > ARCHER_NPC_SHOOT_RANGE)
				break
			if(can_see(probe, target, ARCHER_NPC_SHOOT_RANGE))
				return probe
	return null

/proc/_bow_draw_slowdown(obj/item/gun/ballistic/revolver/grenadelauncher/bow)
	for(var/datum/intent/intent_type as anything in bow.possible_item_intents)
		if(!ispath(intent_type, /datum/intent))
			continue
		var/slow = initial(intent_type.charging_slowdown)
		if(slow)
			return slow
	return 0

/proc/_find_archer_bow(mob/living/carbon/human/pawn)
	var/obj/item/active = pawn.get_active_held_item()
	if(istype(active, /obj/item/gun/ballistic/revolver/grenadelauncher))
		return active
	var/obj/item/inactive = pawn.get_inactive_held_item()
	if(istype(inactive, /obj/item/gun/ballistic/revolver/grenadelauncher))
		return inactive
	for(var/obj/item/worn in pawn.get_equipped_items())
		if(istype(worn, /obj/item/gun/ballistic/revolver/grenadelauncher))
			return worn
	return null

/proc/_find_archer_quiver(mob/living/carbon/human/pawn)
	var/obj/item/quiver/fallback = null
	for(var/obj/item/quiver/Q in pawn.get_equipped_items())
		if(length(Q.arrows))
			return Q
		fallback ||= Q
	return fallback

/proc/_draw_into_hand(mob/living/carbon/human/pawn, obj/item/it, active = TRUE)
	if(it.loc == pawn)
		pawn.temporarilyRemoveItemFromInventory(it, force = TRUE)
	if(active)
		return pawn.put_in_active_hand(it)
	return pawn.put_in_inactive_hand(it)

/proc/_enter_bow_stance(datum/ai_controller/controller, mob/living/carbon/human/pawn, obj/item/gun/ballistic/revolver/grenadelauncher/bow)
	var/is_sling = istype(bow, /obj/item/gun/ballistic/revolver/grenadelauncher/sling)
	var/obj/item/active = pawn.get_active_held_item()
	if(active && active != bow && !istype(active, /obj/item/gun/ballistic/revolver/grenadelauncher))
		_stash_melee_weapon(controller, pawn, active, remember = TRUE)
	if(!is_sling)
		var/obj/item/offhand = pawn.get_inactive_held_item()
		if(offhand && offhand != bow && !istype(offhand, /obj/item/gun/ballistic/revolver/grenadelauncher))
			_stash_melee_weapon(controller, pawn, offhand, remember = FALSE)
	if(pawn.get_active_held_item() != bow)
		_draw_into_hand(pawn, bow, active = TRUE)

/proc/_stash_melee_weapon(datum/ai_controller/controller, mob/living/carbon/human/pawn, obj/item/weapon, remember = TRUE)
	var/stashed = FALSE
	if(pawn.belt)
		for(var/slot in list(SLOT_BELT_R, SLOT_BELT_L))
			if(!pawn.get_item_by_slot(slot) && pawn.equip_to_slot_if_possible(weapon, slot, disable_warning = TRUE))
				stashed = TRUE
				break
	if(!stashed)
		pawn.dropItemToGround(weapon, TRUE, TRUE)
	if(remember)
		controller.set_blackboard_key(BB_ARCHER_NPC_STASHED_WEAPON, weapon)

/proc/_restore_stashed_weapon(datum/ai_controller/controller, mob/living/carbon/human/pawn)
	pawn.remove_movespeed_modifier(MOVESPEED_ID_CHARGING)
	controller.clear_blackboard_key(BB_ARCHER_NPC_REPOSITION_TURF)
	var/obj/item/stashed = controller.blackboard[BB_ARCHER_NPC_STASHED_WEAPON]
	if(QDELETED(stashed))
		controller.clear_blackboard_key(BB_ARCHER_NPC_STASHED_WEAPON)
		return
	var/obj/item/held = pawn.get_active_held_item()
	if(istype(held, /obj/item/gun/ballistic/revolver/grenadelauncher)) // never drop the bow: it must stay in inventory to re-draw
		var/stowed = FALSE
		if(pawn.belt)
			for(var/slot in list(SLOT_BELT_R, SLOT_BELT_L))
				if(!pawn.get_item_by_slot(slot) && pawn.equip_to_slot_if_possible(held, slot, disable_warning = TRUE))
					stowed = TRUE
					break
		if(!stowed && !pawn.get_inactive_held_item())
			_draw_into_hand(pawn, held, active = FALSE)
			stowed = TRUE
		if(!stowed)
			return
	_draw_into_hand(pawn, stashed, active = TRUE)
	controller.clear_blackboard_key(BB_ARCHER_NPC_STASHED_WEAPON)

/proc/_quiver_has_ammo(mob/living/carbon/human/pawn)
	for(var/obj/item/quiver/Q in pawn.get_equipped_items())
		if(length(Q.arrows))
			return TRUE
	return FALSE


/proc/_reload_crossbow(datum/ai_controller/controller, mob/living/carbon/human/pawn, obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/bow, atom/target)
	if(get_dist(pawn, target) > (ARCHER_NPC_MIN_RANGE + 4))
		return FALSE
	controller.ai_movement.stop_moving_towards(controller)
	pawn.face_atom(target)
	if(!bow.cocked)
		if(pawn.doing)
			return FALSE
		if(bow.cock_sound)
			playsound(pawn, bow.cock_sound, 100, FALSE)
		if(!do_after(pawn, bow.get_npc_chargetime(pawn), pawn, progress = FALSE))
			return FALSE
		bow.cocked = TRUE
		bow.update_icon()
	. = _chamber_from_quiver(pawn, bow)
	if(. && bow.load_sound)
		playsound(pawn, bow.load_sound, bow.load_sound_volume, bow.load_sound_vary)

/proc/_chamber_from_quiver(mob/living/carbon/human/pawn, obj/item/gun/ballistic/revolver/grenadelauncher/bow)
	if(bow.chambered)
		return TRUE
	var/wanted_caliber = bow.magazine?.caliber
	for(var/obj/item/quiver/Q in pawn.get_equipped_items())
		for(var/obj/item/ammo_casing/arrow in Q.arrows)
			if(wanted_caliber && arrow.caliber != wanted_caliber)
				continue
			Q.arrows -= arrow
			Q.update_icon()
			arrow.newshot()
			arrow.forceMove(bow)
			bow.chambered = arrow
			bow.update_icon()
			return TRUE
	return FALSE

/proc/_loose_arrow(mob/living/carbon/human/pawn, atom/target, obj/item/gun/ballistic/revolver/grenadelauncher/bow)
	var/should_arc = FALSE
	var/turf/pt = get_turf(pawn)
	var/turf/tt = get_turf(target)
	if(pt && tt)
		for(var/turf/T in getline(pt, tt))
			if(T == pt || T == tt)
				continue
			for(var/mob/living/M in T)
				if(M == pawn || M == target || M.stat == DEAD)
					continue
				if(pawn.faction_check_mob(M))
					should_arc = TRUE
					break
			if(should_arc)
				break
	bow.npc_force_arc = should_arc
	var/bonus_spread = ARCHER_NPC_BASE_SPREAD + max(0, 15 - pawn.STAPER) * ARCHER_NPC_SPREAD_PER_POINT
	if(should_arc)
		bonus_spread += ARCHER_NPC_ARC_SPREAD_PENALTY
	bow.process_fire(target, pawn, TRUE, null, "", bonus_spread)
	bow.npc_force_arc = FALSE
