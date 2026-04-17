#define HUMAN_NPC_BASE_JUKE_CHANCE              15
#define HUMAN_NPC_JUKE_MIN_SPD                  10
#define HUMAN_NPC_JUKE_PER_OVERSPD              5
#define HUMAN_NPC_WEAKPOINT_SCAN_CHANCE         15
#define HUMAN_NPC_WEAKPOINT_CACHE_DURATION      (6 SECONDS)
#define HUMAN_NPC_WEAPON_SPECIAL_CHANCE         15  // base chance, INT-scaled. Was 35 — too spammy
#define HUMAN_NPC_INTENT_SWITCH_CHANCE          25  // chance per attack to start a new intent sequence
#define HUMAN_NPC_RMB_ATTEMPT_CHANCE			25
#define HUMAN_NPC_MIN_INT_FOR_TACTICS        8   // minimum INT to use weapon specials or feint
#define HUMAN_NPC_FEINT_COOLDOWN             (30 SECONDS)
// Post-attack click recovery jitter — added onto clickcd as (1 + rand(MIN, MAX)).
// Bigger numbers = slower, less consistent swing cadence (less "frame perfect").
#define HUMAN_NPC_CLICK_RECOVERY_JITTER_MIN  0.15
#define HUMAN_NPC_CLICK_RECOVERY_JITTER_MAX  0.3
// Feint adds extra delay on top of the base recovery, since it's a committed whiff-bait.
#define HUMAN_NPC_FEINT_RECOVERY_MULT        1.6
// AI weapon-special cooldown is multiplied by this over the player baseline to simulate
// human reaction delay / decision cost. 1.0 = parity with players.
#define HUMAN_NPC_SPECIAL_CD_PENALTY         1.5
// Reaction window (deciseconds) between locking on and the swing actually landing.
// If the target steps off the snapshot turf during this window, the swing resolves
// against the (now empty) stale turf — a real whiff that still pays stamina/clickcd.
// Scales down by (STAINT + STAPER): smarter/sharper NPCs re-aim faster.
#define HUMAN_NPC_REACTION_TIME_BASE         5
#define HUMAN_NPC_REACTION_TIME_MIN          2
#define HUMAN_NPC_REACTION_PER_STAT_POINT    12  // total stat points needed to shave 1 ds
// Whiff floor/ceiling: keep the result non-binary. Even a stationary target gets missed
// sometimes (sloppy swing), and even a moving target sometimes gets tracked and hit.
// Both are INT-scaled via AI_INT_SCALE_PROB — dumber NPCs whiff more and track less.
#define HUMAN_NPC_WHIFF_FLOOR_CHANCE         8   // % chance to whiff even when target is stationary
#define HUMAN_NPC_TRACK_CEILING_CHANCE       40  // % chance to still land a hit when target moved off the snapshot


//Note alot of this is just adapted from old code so its probably not the best

/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/human_npc
	end_planning = TRUE

/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/mob/living/carbon/human/pawn = controller.pawn
	if(istype(pawn))
		// If we're disarmed and a weapon is reachable nearby, skip melee planning so find_weapon
		// can run (it's the next subtree). Otherwise we'd just punch the target empty-handed forever.
		var/obj/item/r_held = pawn.get_item_for_held_index(1)
		var/obj/item/l_held = pawn.get_item_for_held_index(2)
		var/has_weapon = istype(r_held, /obj/item/rogueweapon) || istype(l_held, /obj/item/rogueweapon)
		if(!has_weapon)
			for(var/obj/item/rogueweapon/nearby_weapon in view(7, pawn))
				if(!isturf(nearby_weapon.loc))
					continue
				return // yield to find_weapon — there's a weapon worth grabbing
	return ..()

/datum/ai_behavior/basic_melee_attack/human_npc
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/basic_melee_attack/human_npc/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	var/obj/item/held_item = pawn.get_active_held_item()
	// If holding a shield in the active hand and a real weapon in the other, swap so we
	// attack with the weapon. Shields are rogueweapons so isweapon() passes for them.
	if(istype(held_item, /obj/item/rogueweapon/shield))
		var/obj/item/offhand = pawn.get_inactive_held_item()
		if(isweapon(offhand) && !istype(offhand, /obj/item/rogueweapon/shield))
			pawn.swap_hand()
	else if(!isweapon(held_item))
		pawn.swap_hand()
		for(var/slot in list(ITEM_SLOT_BACK, ITEM_SLOT_HIP, ITEM_SLOT_BELT, ITEM_SLOT_BACK_L, ITEM_SLOT_BACK_R))
			if(!pawn.get_item_by_slot(slot))
				if(pawn.equip_to_slot_if_possible(held_item, slot, disable_warning = TRUE))
					break

	var/list/possible_intents = list()
	for(var/datum/intent/intent as anything in pawn.possible_a_intents)
		if(istype(intent, /datum/intent/unarmed/help) || istype(intent, /datum/intent/unarmed/shove) || istype(intent, /datum/intent/unarmed/grab))
			continue
		possible_intents |= intent
	if(length(possible_intents))
		pawn.a_intent = pick(possible_intents)
		pawn.used_intent = pawn.a_intent

	if(prob(HUMAN_NPC_WEAKPOINT_SCAN_CHANCE) && isliving(target))
		_scan_for_weakpoint(controller, pawn, target) // initial scan on setup

/datum/ai_behavior/basic_melee_attack/human_npc/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	controller.behavior_cooldowns[src] = world.time + get_cooldown(controller)
	var/mob/living/carbon/human/pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/td = controller.blackboard[targetting_datum_key]

	var/obj/item/held_weapon = pawn.get_active_held_item()
	if(!istype(held_weapon, /obj/item/rogueweapon))
		// Snatch a dropped weapon adjacent to us — recovers from getting disarmed mid-fight
		for(var/obj/item/rogueweapon/candidate in range(1, pawn))
			if(!isturf(candidate.loc))
				continue
			if(pawn.put_in_active_hand(candidate))
				held_weapon = candidate
				break

	if(!td.can_attack(pawn, target))
		AI_THINK(pawn, "ATTACK: can't attack [target] - td rejected")
		finish_action(controller, FALSE, target_key)
		return
	if(ismob(target) && target:stat == DEAD)
		AI_THINK(pawn, "ATTACK: target [target] is dead")
		finish_action(controller, FALSE, target_key)
		return

	SEND_SIGNAL(pawn, COMSIG_MOB_TRY_BARK)
	var/hiding_target = td.find_hidden_mobs(pawn, target)
	controller.set_blackboard_key(hiding_location_key, hiding_target)

	pawn.face_atom(target)
	_choose_attack_zone(controller, pawn, target)

	// Pass active held item so reach > 1 weapons (whips, polearms) detect properly on carbons
	if(!pawn.CanReach(target, pawn.get_active_held_item()))
		AI_THINK(pawn, "ATTACK: can't reach [target]")
		finish_action(controller, FALSE, target_key)
		return

	if(pawn.STAINT >= HUMAN_NPC_MIN_INT_FOR_TACTICS)
		// Don't open with a special — need a few normal swings first
		var/attacks_done = controller.blackboard[BB_HUMAN_NPC_ATTACK_ZONE_COUNTER]
		if(attacks_done >= 2 && _try_weapon_special(controller))
			return

	_update_combat_intent(controller, pawn, target)
	var/list/modifiers = list()
	if(pawn.STAINT >= HUMAN_NPC_MIN_INT_FOR_TACTICS && AI_INT_SCALE_PROB(pawn, HUMAN_NPC_RMB_ATTEMPT_CHANCE))
		#ifdef NPC_THINK_DEBUG
		AI_THINK(pawn, "RMB: intent=[pawn.rmb_intent?.type] stam=[pawn.stamina]/[pawn.max_stamina]")
		#endif
		var/feint_ready = world.time >= (controller.blackboard[BB_HUMAN_NPC_FEINT_COOLDOWN] || 0)
		var/technique_ready = world.time >= (controller.blackboard[BB_HUMAN_NPC_TECHNIQUE_CD] || 0)
		if(feint_ready && technique_ready && pawn.stamina < pawn.max_stamina * 0.7 && istype(pawn.rmb_intent, /datum/rmb_intent/feint))
			AI_THINK(pawn, "FEINT: attempting feint on [target]!")
			modifiers = list(RIGHT_CLICK = TRUE)
			controller.set_blackboard_key(BB_HUMAN_NPC_FEINT_COOLDOWN, world.time + HUMAN_NPC_FEINT_COOLDOWN)
			controller.set_blackboard_key(BB_HUMAN_NPC_TECHNIQUE_CD, world.time + 3 SECONDS)
		#ifdef NPC_THINK_DEBUG
		else if(istype(pawn.rmb_intent, /datum/rmb_intent/feint) && !feint_ready)
			AI_THINK(pawn, "FEINT: on cooldown ([controller.blackboard[BB_HUMAN_NPC_FEINT_COOLDOWN] - world.time]ds remaining)")
		else if(istype(pawn.rmb_intent, /datum/rmb_intent/feint))
			AI_THINK(pawn, "FEINT: too exhausted ([pawn.stamina] >= [pawn.max_stamina * 0.7])")
		#endif

	// Stale-prediction whiff: snapshot the target's tile, wait a reaction window, then
	// swing at whatever is on that snapshot. A stationary target gets hit; a moving target
	// can step off and make us whack empty air. No RNG — purely about whether they moved.
	var/turf/locked_turf = get_turf(target)
	var/reaction_time = max(HUMAN_NPC_REACTION_TIME_MIN, HUMAN_NPC_REACTION_TIME_BASE - round((pawn.STAPER + pawn.STAINT) / HUMAN_NPC_REACTION_PER_STAT_POINT))
	sleep(reaction_time)

	// Re-validate after sleep — pawn/target may have died, moved out of reach, etc.
	if(QDELETED(pawn) || QDELETED(target) || QDELETED(controller) || controller.pawn != pawn)
		return
	var/swing_reach = pawn.used_intent?.reach || 1
	if(!pawn.CanReach(target, pawn.get_active_held_item()) && locked_turf && get_dist(pawn, locked_turf) > swing_reach)
		finish_action(controller, FALSE, target_key)
		return

	var/atom/swing_at = hiding_target || target
	if(!hiding_target && locked_turf && get_dist(pawn, locked_turf) <= swing_reach)
		var/target_moved = (get_turf(target) != locked_turf)
		if(target_moved)
			// Ceiling: small chance to track the target and hit anyway.
			if(AI_INT_SCALE_PROB(pawn, HUMAN_NPC_TRACK_CEILING_CHANCE))
				AI_THINK(pawn, "WHIFF: target moved but we tracked - hit anyway")
			else
				swing_at = locked_turf
				AI_THINK(pawn, "WHIFF: target stepped off [locked_turf], swinging at empty tile")
		else
			// Floor: small chance to whiff even when stationary (sloppy swing).
			if(!AI_INT_SCALE_PROB(pawn, 100 - HUMAN_NPC_WHIFF_FLOOR_CHANCE))
				// Pick an adjacent turf to swing at instead
				var/list/nearby = list()
				for(var/turf/T in range(1, locked_turf))
					if(T == locked_turf || T.density)
						continue
					nearby += T
				if(length(nearby))
					swing_at = pick(nearby)
					AI_THINK(pawn, "WHIFF: sloppy swing, hit [swing_at] instead of target")

	controller.ai_interact(swing_at, TRUE, TRUE, modifiers)

	if(pawn.next_click < world.time)
		// Post-attack click cooldown. Extra multiplier on feint — this is a committed action
		// that should have a bigger opening between it and the next real swing.
		var/recovery_mult = modifiers[RIGHT_CLICK] ? HUMAN_NPC_FEINT_RECOVERY_MULT : 1.0
		var/jitter = 1 + rand(HUMAN_NPC_CLICK_RECOVERY_JITTER_MIN, HUMAN_NPC_CLICK_RECOVERY_JITTER_MAX)
		pawn.next_click = world.time + (pawn.used_intent?.clickcd * recovery_mult * jitter)
		SEND_SIGNAL(pawn, COMSIG_MOB_BREAK_SNEAK)

	// Skilled fighters scan for weakpoints more often
	var/scan_chance = HUMAN_NPC_WEAKPOINT_SCAN_CHANCE
	var/obj/item/scan_weapon = pawn.get_active_held_item()
	if(scan_weapon?.associated_skill)
		var/scan_skill = pawn.get_skill_level(scan_weapon.associated_skill)
		scan_chance += scan_skill * 5 // +5% per skill level: novice 20%, journeyman 30%, expert 35%, master 40%
	if(prob(scan_chance) && isliving(target))
		_scan_for_weakpoint(controller, pawn, target)

	_try_backstep(pawn, target)

/datum/ai_behavior/basic_melee_attack/human_npc/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	// cmode stays TRUE - it's managed by the aggro system, not the attack cycle.
	// Clearing it here caused NPCs to lose the ability to parry/dodge between attacks.
	SEND_SIGNAL(pawn, COMSIG_COMBAT_TARGET_SET, FALSE)

/datum/ai_behavior/basic_melee_attack/human_npc/proc/_update_combat_intent(datum/ai_controller/controller, mob/living/carbon/human/pawn, mob/living/target)
	var/attacks_left = controller.blackboard[BB_HUMAN_NPC_CURRENT_INTENT_ATTACKS_LEFT]

	if(attacks_left > 0)
		controller.set_blackboard_key(BB_HUMAN_NPC_CURRENT_INTENT_ATTACKS_LEFT, attacks_left - 1)
		return

	if(!AI_INT_SCALE_PROB(pawn, HUMAN_NPC_INTENT_SWITCH_CHANCE))
		return

	var/skill_level = SKILL_LEVEL_NONE
	var/obj/item/held = pawn.get_active_held_item()
	if(held?.associated_skill)
		skill_level = pawn.get_skill_level(held.associated_skill)

	var/list/weighted = list()
	for(var/datum/rmb_intent/available in pawn.possible_rmb_intents)
		if(istype(available, /datum/rmb_intent/feint))
			weighted[available.type] = 15
		else if(istype(available, /datum/rmb_intent/strong))
			weighted[available.type] = 30
		else if(istype(available, /datum/rmb_intent/swift))
			weighted[available.type] = 15
		else if(istype(available, /datum/rmb_intent/aimed))
			weighted[available.type] = 5
		else if(istype(available, /datum/rmb_intent/weak))
			weighted[available.type] = 20
		else if(istype(available, /datum/rmb_intent/riposte))
			weighted[available.type] = 0

	if(!length(weighted))
		return

	if(skill_level >= SKILL_LEVEL_EXPERT)
		if(weighted[/datum/rmb_intent/aimed])
			weighted[/datum/rmb_intent/aimed] += 20
		if(weighted[/datum/rmb_intent/swift])
			weighted[/datum/rmb_intent/swift] += 10
		if(weighted[/datum/rmb_intent/riposte])
			weighted[/datum/rmb_intent/riposte] += 10
	else if(skill_level >= SKILL_LEVEL_JOURNEYMAN)
		if(weighted[/datum/rmb_intent/aimed])
			weighted[/datum/rmb_intent/aimed] += 10
		if(weighted[/datum/rmb_intent/strong])
			weighted[/datum/rmb_intent/strong] += 10
		if(weighted[/datum/rmb_intent/riposte])
			weighted[/datum/rmb_intent/riposte] += 5

	if(isliving(target))
		var/mob/living/carbon/human/htarget = target
		if(istype(htarget?.rmb_intent, /datum/rmb_intent/riposte) || istype(htarget?.rmb_intent, /datum/rmb_intent/guard))
			if(weighted[/datum/rmb_intent/feint])
				weighted[/datum/rmb_intent/feint] += 30

	var/chosen_type = pickweight(weighted)
	var/datum/rmb_intent/chosen = locate(chosen_type) in pawn.possible_rmb_intents
	if(chosen)
		pawn.rmb_intent = chosen
		AI_THINK(pawn, "INTENT: picked [chosen.type]")

	controller.set_blackboard_key(BB_HUMAN_NPC_CURRENT_INTENT_ATTACKS_LEFT, rand(3, 6))


/datum/ai_behavior/basic_melee_attack/human_npc/proc/_choose_attack_zone(datum/ai_controller/controller, mob/living/carbon/human/pawn, mob/living/target)
	var/list/wp = controller.blackboard[BB_HUMAN_NPC_WEAKPOINT]
	if(wp && world.time < wp[2] && wp[3] == target)
		var/aimheight = _zone_to_aimheight(wp[1])
		if(aimheight)
			pawn.aimheight_change(aimheight)
			AI_THINK(pawn, "ZONE: hitting cached weakpoint [wp[1]] (aim [aimheight])")
		return

	// Skilled fighters commit to a zone longer before switching
	var/obj/item/held = pawn.get_active_held_item()
	var/skill_level = SKILL_LEVEL_NONE
	if(held?.associated_skill)
		skill_level = pawn.get_skill_level(held.associated_skill)
	var/switch_threshold = 3
	switch(skill_level)
		if(SKILL_LEVEL_JOURNEYMAN)
			switch_threshold = 4
		if(SKILL_LEVEL_EXPERT)
			switch_threshold = 5
		if(SKILL_LEVEL_MASTER to INFINITY)
			switch_threshold = 6

	var/counter = controller.blackboard[BB_HUMAN_NPC_ATTACK_ZONE_COUNTER]
	if(counter < switch_threshold)
		controller.set_blackboard_key(BB_HUMAN_NPC_ATTACK_ZONE_COUNTER, counter + 1)
		AI_THINK(pawn, "ZONE: committing to current zone ([counter+1]/[switch_threshold], skill [skill_level])")
		return

	controller.set_blackboard_key(BB_HUMAN_NPC_ATTACK_ZONE_COUNTER, 0)
	controller.clear_blackboard_key(BB_HUMAN_NPC_WEAKPOINT)
	AI_THINK(pawn, "ZONE: switching up! (skill [skill_level], threshold was [switch_threshold])")

	// Parity with npc_choose_attack_zone aimheight picks
	if(pawn.mind?.has_antag_datum(/datum/antagonist/zombie))
		pawn.aimheight_change(pawn.deadite_get_aimheight(target))
		return
	if(!(pawn.mobility_flags & MOBILITY_STAND))
		pawn.aimheight_change(rand(1, 4))
		return
	if(HAS_TRAIT(target, TRAIT_BLOODLOSS_IMMUNE))
		pawn.aimheight_change(rand(12, 19))
		return

	// Before going random, skilled fighters try to re-scan for a weakpoint
	if(skill_level >= SKILL_LEVEL_APPRENTICE && isliving(target))
		_scan_for_weakpoint(controller, pawn, target)
		wp = controller.blackboard[BB_HUMAN_NPC_WEAKPOINT]
		if(wp)
			var/aimheight = _zone_to_aimheight(wp[1])
			if(aimheight)
				pawn.aimheight_change(aimheight)
				AI_THINK(pawn, "ZONE: re-scan found weakpoint [wp[1]] (aim [aimheight])")
				return
		AI_THINK(pawn, "ZONE: re-scan found nothing, going random")

	// Skilled fighters favor the chest - it's practical and reliable
	var/new_aim
	if(skill_level >= SKILL_LEVEL_JOURNEYMAN)
		new_aim = pick(50;rand(9, 11), 25;rand(5, 8), 25;rand(12, 19))
		AI_THINK(pawn, "ZONE: skilled random pick -> aim [new_aim] (chest-favored)")
	else
		new_aim = pick(rand(5, 8), rand(9, 11), rand(12, 19))
		AI_THINK(pawn, "ZONE: random pick -> aim [new_aim]")
	pawn.aimheight_change(new_aim)

/datum/ai_behavior/basic_melee_attack/human_npc/proc/_try_weapon_special(datum/ai_controller/controller)
	var/mob/living/carbon/human/pawn = controller.pawn

	if(pawn.has_status_effect(/datum/status_effect/debuff/specialcd))
		return FALSE

	// Shared technique cooldown prevents kick/feint/special from chaining back-to-back.
	var/next_technique = controller.blackboard[BB_HUMAN_NPC_TECHNIQUE_CD]
	if(next_technique && world.time < next_technique)
		return FALSE

	var/obj/item/held_weapon = pawn.get_active_held_item()
	if(!istype(held_weapon, /obj/item/rogueweapon) || !held_weapon:special)
		return FALSE

	if(!AI_INT_SCALE_PROB(pawn, HUMAN_NPC_WEAPON_SPECIAL_CHANCE))
		return FALSE

	var/datum/special_intent/special = held_weapon:special
	if(special.stamcost)
		var/cost = (special.stamcost < 1) ? (pawn.max_stamina * special.stamcost) : special.stamcost
		if(pawn.stamina + cost > pawn.max_stamina)
			return FALSE

	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return FALSE
	var/obj/item/weapon = pawn.get_active_held_item()
	if(!weapon)
		return FALSE
	if(!special.check_reqs(pawn, weapon))
		return FALSE
	if(!special.apply_cost(pawn))
		return FALSE
	SEND_SIGNAL(pawn, COMSIG_MOB_TRY_BARK, 100)
	special.deploy(pawn, weapon, target)
	controller.set_blackboard_key(BB_HUMAN_NPC_TECHNIQUE_CD, world.time + 3 SECONDS)
	// AI penalty: re-stamp the special cooldown longer than the player baseline so NPCs
	// can't chain specials as tightly as a human player could. Override replaces the
	// debuff applied inside deploy() with our extended version.
	special.apply_cooldown(special.cooldown * HUMAN_NPC_SPECIAL_CD_PENALTY, override = TRUE)
	// Recovery: block the next swing for longer than a normal attack so specials don't chain
	if(pawn.next_click < world.time + pawn.used_intent?.clickcd * 1.8)
		pawn.next_click = world.time + (pawn.used_intent?.clickcd * 1.8)
	return TRUE

/// Scan target bodyparts for wounded (brute/burn > 20) or unarmored zones.
/// Caches as list(zone, expiry_time, target_ref).
/datum/ai_behavior/basic_melee_attack/human_npc/proc/_scan_for_weakpoint(datum/ai_controller/controller, mob/living/carbon/human/pawn, mob/living/target)
	if(!istype(target, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/htarget = target

	// Resolve weapon skill and blade class from active intent
	var/skill_type = null
	var/bclass = null
	var/intent_reach = 1
	if(pawn.used_intent)
		bclass = pawn.used_intent.blade_class
		intent_reach = pawn.used_intent.reach || 1
		var/obj/item/held = pawn.get_active_held_item()
		if(held?.associated_skill)
			skill_type = held.associated_skill

	var/skill_level = skill_type ? pawn.get_skill_level(skill_type) : SKILL_LEVEL_NONE
	var/armor_rating = bclass ? bclass_to_armor_rating(bclass) : "blunt"

	var/list/wounded  = list()
	var/list/exposed  = list()
	var/list/soft     = list() // armored but below meaningful resistance for our damage type

	for(var/obj/item/bodypart/part in htarget.bodyparts)
		if(!part)
			continue

		//requires trained eye AND good perception
		if(skill_level >= SKILL_LEVEL_JOURNEYMAN && pawn.STAPER >= 10)
			if(part.brute_dam > 20 || part.burn_dam > 20)
				wounded += part.body_zone

		var/obj/item/clothing/worn = htarget.get_best_worn_armor(part.body_zone, armor_rating)
		if(!worn)
			exposed += part.body_zone
			continue

		// Basic+ fighters read armor and seek soft coverage for their damage type
		if(skill_level >= SKILL_LEVEL_NOVICE)
			var/rating = worn.armor.getRating(armor_rating)
			if(rating < 25)
				soft += part.body_zone

	// Priority: wounded > bare exposed > soft armor coverage > armored fallback (experts only)
	var/chosen = null
	if(length(wounded))
		chosen = pick(wounded)
	else if(length(exposed))
		chosen = pick(exposed)
	else if(length(soft))
		chosen = pick(soft)
	else if(skill_level >= SKILL_LEVEL_EXPERT)
		// Expert fallback: just pick whatever zone has the lowest resistance for our damage type
		var/lowest_rating = INFINITY
		var/lowest_zone = null
		for(var/obj/item/bodypart/part in htarget.bodyparts)
			if(!part)
				continue
			var/obj/item/clothing/fallback_armor = htarget.get_best_worn_armor(part.body_zone, armor_rating)
			if(!fallback_armor)
				continue
			var/rating = fallback_armor.armor.getRating(armor_rating)
			if(rating < lowest_rating)
				lowest_rating = rating
				lowest_zone = part.body_zone
		chosen = lowest_zone

	if(!chosen)
		AI_THINK(pawn, "SCAN: no weakpoint found (wounded=[length(wounded)] exposed=[length(exposed)] soft=[length(soft)], skill [skill_level])")
		return

	AI_THINK(pawn, "SCAN: targeting [chosen] (skill [skill_level])")

	// Skill scales how long the targeting solution stays valid
	//longer weapons can maintain solutions longer
	// since the fighter isn't scrambling to stay close
	var/cache_duration = HUMAN_NPC_WEAKPOINT_CACHE_DURATION
	switch(skill_level)
		if(SKILL_LEVEL_NONE)
			cache_duration *= 0.1
		if(SKILL_LEVEL_NOVICE)
			cache_duration *= 0.5
		if(SKILL_LEVEL_APPRENTICE)
			cache_duration *= 0.75
		if(SKILL_LEVEL_JOURNEYMAN)
			cache_duration *= 1.0
		if(SKILL_LEVEL_EXPERT)
			cache_duration *= 1.5
		if(SKILL_LEVEL_MASTER)
			cache_duration *= 2.0
		if(SKILL_LEVEL_LEGENDARY to INFINITY)
			cache_duration *= 3.0

	// Reach bonus: each point of reach beyond 1 adds 10% duration
	// rationale: you're not fighting in a scramble, you have space to think
	cache_duration *= (1 + ((intent_reach - 1) * 0.1))

	controller.set_blackboard_key(BB_HUMAN_NPC_WEAKPOINT, list(
		chosen,
		world.time + cache_duration,
		target,
	))

/// Zone string -> aimheight int.
/datum/ai_behavior/basic_melee_attack/human_npc/proc/_zone_to_aimheight(zone)
	switch(zone)
		if(BODY_ZONE_HEAD)
			return rand(12, 19)
		if(BODY_ZONE_CHEST)
			return rand(9, 11)
		if(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
			return rand(5, 8)
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			return rand(1, 4)
	return null

/datum/ai_behavior/basic_melee_attack/human_npc/proc/_try_backstep(mob/living/carbon/human/pawn, atom/target)
	if(pawn.mind?.has_antag_datum(/datum/antagonist/zombie))
		return FALSE
	if(!pawn.ai_controller.can_move())
		return FALSE
	if(!(pawn.mobility_flags & MOBILITY_STAND))
		return FALSE
	if(pawn.ai_controller.blackboard[BB_HUMAN_NPC_HARASS_MODE])
		return FALSE
	if(!target || !isturf(pawn.loc) || !isturf(target.loc))
		return FALSE

	if(world.time < pawn.ai_controller.blackboard[BB_HUMAN_NPC_JUKE_COOLDOWN])
		return FALSE

	var/juke_chance = HUMAN_NPC_BASE_JUKE_CHANCE
	if(pawn.STASPD > HUMAN_NPC_JUKE_MIN_SPD)
		juke_chance += (pawn.STASPD - HUMAN_NPC_JUKE_MIN_SPD) * HUMAN_NPC_JUKE_PER_OVERSPD

	if(!prob(juke_chance))
		return FALSE

	pawn.tempfixeye = TRUE
	pawn.nodirchange = TRUE
	var/was_fixedeye = pawn.fixedeye
	if(!was_fixedeye)
		pawn.fixedeye = TRUE

	var/list/candidates = pawn.get_dodge_destinations(target, null)
	if(!length(candidates))
		pawn.tempfixeye = FALSE
		if(!was_fixedeye)
			pawn.fixedeye = FALSE
		return FALSE

	var/turf/juke_turf = pick(candidates)
	// Don't pass cached_multiplicative_slowdown as glide — that's a delay value, not a glide size,
	// and using it directly produces the "smoothed dance" interpolation between attack tiles.
	pawn.Move(juke_turf, get_dir(pawn, juke_turf))
	pawn.nodirchange = FALSE
	pawn.face_atom(target)

	pawn.ai_controller.set_blackboard_key(BB_HUMAN_NPC_JUKE_COOLDOWN, world.time + 1.5 SECONDS)
	pawn.tempfixeye = FALSE
	if(!was_fixedeye)
		pawn.fixedeye = FALSE
	return TRUE

///Maps weapon bclass to armor rating category for weakpoint scanning
/proc/bclass_to_armor_rating(bclass)
	switch(bclass)
		if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PUNCH, BCLASS_LASHING)
			return "blunt"
		if(BCLASS_CUT, BCLASS_CHOP)
			return "slash"
		if(BCLASS_STAB, BCLASS_DRILL, BCLASS_PICK, BCLASS_TWIST, BCLASS_BITE)
			return "stab"
		if(BCLASS_PIERCE)
			return "piercing"
		if(BCLASS_BURN)
			return "fire"
	return "blunt" // safest fallback - everything has some blunt resistance defined

#undef HUMAN_NPC_BASE_JUKE_CHANCE
#undef HUMAN_NPC_JUKE_MIN_SPD
#undef HUMAN_NPC_JUKE_PER_OVERSPD
#undef HUMAN_NPC_WEAKPOINT_SCAN_CHANCE
#undef HUMAN_NPC_WEAKPOINT_CACHE_DURATION
#undef HUMAN_NPC_WEAPON_SPECIAL_CHANCE
#undef HUMAN_NPC_INTENT_SWITCH_CHANCE
#undef HUMAN_NPC_RMB_ATTEMPT_CHANCE
#undef HUMAN_NPC_MIN_INT_FOR_TACTICS
#undef HUMAN_NPC_FEINT_COOLDOWN
#undef HUMAN_NPC_CLICK_RECOVERY_JITTER_MIN
#undef HUMAN_NPC_CLICK_RECOVERY_JITTER_MAX
#undef HUMAN_NPC_FEINT_RECOVERY_MULT
#undef HUMAN_NPC_SPECIAL_CD_PENALTY
#undef HUMAN_NPC_REACTION_TIME_BASE
#undef HUMAN_NPC_REACTION_TIME_MIN
#undef HUMAN_NPC_REACTION_PER_STAT_POINT
#undef HUMAN_NPC_WHIFF_FLOOR_CHANCE
#undef HUMAN_NPC_TRACK_CEILING_CHANCE
