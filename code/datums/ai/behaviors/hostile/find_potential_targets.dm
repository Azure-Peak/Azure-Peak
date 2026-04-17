/// Static typecache list of things we are interested in
/// Consider this a union of the for loop and the hearers call from below
/// Must be kept up to date with the contents of hostile_machines
GLOBAL_LIST_INIT(target_interested_atoms, typecacheof(list(/mob)))

/datum/ai_behavior/find_potential_targets
	action_cooldown = 2 SECONDS
	/// How far can we see stuff?
	var/vision_range = 9

/datum/ai_behavior/find_potential_targets/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/living_mob = controller.pawn
	if(living_mob.pet_passive)
		finish_action(controller, succeeded = FALSE)
		return
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum)
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	var/atom/current_target = controller.blackboard[target_key]
	if (targetting_datum.can_attack(living_mob, current_target))
		finish_action(controller, succeeded = FALSE)
		return

	controller.clear_blackboard_key(target_key)

	// Wake/sleep is gated by spatial-grid cell tracking on the base controller.
	// When no clients are in our cells we don't tick, so scanning here is cheap.
	var/list/potential_targets = viewers(vision_range, controller.pawn) - living_mob

	if(!potential_targets.len)
		finish_action(controller, succeeded = FALSE)
		return

	var/list/filtered_targets = list()

	for(var/atom/pot_target in potential_targets)
		if(targetting_datum.can_attack(living_mob, pot_target))//Can we attack it?
			filtered_targets += pot_target
			continue

	for(var/mob/living/living_target in filtered_targets)
		if(living_target.stat == DEAD)
			filtered_targets -= living_target
			continue
		if(!living_target.rogue_sneaking)
			continue
		var/extra_chance = (living_mob.health <= living_mob.maxHealth * 50) ? 30 : 0 // if we're below half health, we're way more alert
		if (!living_mob.npc_detect_sneak(living_target, extra_chance))
			filtered_targets -= living_target

	if(!filtered_targets.len)
		finish_action(controller, succeeded = FALSE)
		return

	var/atom/target = pick_final_target(controller, filtered_targets)
	controller.set_blackboard_key(target_key, target)

	var/atom/potential_hiding_location = targetting_datum.find_hidden_mobs(living_mob, target)

	if(potential_hiding_location) //If they're hiding inside of something, we need to know so we can go for that instead initially.
		controller.set_blackboard_key(hiding_location_key, potential_hiding_location)

	finish_action(controller, succeeded = TRUE)

/datum/ai_behavior/find_potential_targets/finish_action(datum/ai_controller/controller, succeeded, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	if (succeeded)
		controller.CancelActions()
		controller.modify_cooldown(controller, world.time + get_cooldown(controller))

/// Returns the desired final target from the filtered list of targets
/datum/ai_behavior/find_potential_targets/proc/pick_final_target(datum/ai_controller/controller, list/filtered_targets)
	return pick(filtered_targets)

/datum/ai_behavior/find_potential_targets/human
	vision_range = 7

/datum/ai_behavior/find_potential_targets/rat
	vision_range = 2

/datum/ai_behavior/find_potential_targets/spider
	vision_range = 5

/datum/ai_behavior/find_potential_targets/mimic
	vision_range = 1

/datum/ai_behavior/find_potential_targets/mimic/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if (succeeded)
		controller.CancelActions()
		var/mob/living/simple_animal/hostile/retaliate/rogue/mimic/mimic_pawn = controller.pawn
		mimic_pawn.undisguise()


/datum/ai_behavior/find_potential_targets/mole
	vision_range = 9

/datum/ai_behavior/find_potential_targets/troll
	vision_range = 7

/datum/ai_behavior/find_potential_targets/bog_troll
	vision_range = 3

/datum/ai_behavior/find_potential_targets/bog_troll/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		if(istype(controller.pawn, /mob/living/simple_animal/hostile/retaliate/rogue/troll))
			var/mob/living/simple_animal/hostile/retaliate/rogue/troll/mob = controller.pawn
			mob.ambush()
