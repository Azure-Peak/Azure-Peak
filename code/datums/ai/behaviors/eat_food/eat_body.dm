///Since we aren't eating anything with a ckey, if a mob finds a player corpse it will congregate around it without eating it.
/// as well as ignoring other bodies around it.
/datum/ai_behavior/eat_dead_body
	action_cooldown = 1.5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/eat_dead_body/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	//Hiding location is priority
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, (target))

/datum/ai_behavior/eat_dead_body/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/simple_animal/living_pawn = controller.pawn
	//targetting datum will kill the action if not real anymore
	var/mob/living/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	var/mob/living/carbon/C = target

	var/hiding_target = targetting_datum.find_hidden_mobs(living_pawn, target) //If this is valid, theyre hidden in something!



	if(QDELETED(living_pawn) || QDELETED(target) || !isnull(target.ckey)) //We don't want to eat anything with a ckey
		return
	//nor do we want to eat anything with a mind
	if(iscarbon(target))
		if(C.mind || C.last_mind)
			finish_action(controller, FALSE, target_key)
			return
	else
		C = null

	controller.set_blackboard_key(hiding_location_key, hiding_target)

	living_pawn.face_atom()
	living_pawn.visible_message(span_danger("[living_pawn] starts to rip apart [target]!"))
	if(do_after(living_pawn, 10 SECONDS, target = target)) // Eating time
		if(C)	//carbon corpse disposal
			var/obj/item/bodypart/limb
			var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			for(var/zone in limb_list)
				limb = C.get_bodypart(zone)
				if(limb && prob(2)) //2% chance per limb to appear and be dismembered
					limb.dismember()
					finish_action(controller, TRUE)
					return
			limb = C.get_bodypart(BODY_ZONE_HEAD)
			if(limb)					// Head is always 100%
				limb.dismember()
				finish_action(controller, TRUE)
				return
			limb = C.get_bodypart(BODY_ZONE_CHEST)
			if(limb)
				if(!limb.dismember())
					C.gib()
		else
			if(living_pawn.attack_sound)
				playsound(living_pawn, pick(living_pawn.attack_sound), 100, TRUE, -1)
			target.gib()
		finish_action(controller, TRUE)
	finish_action(controller, TRUE)


/datum/ai_behavior/eat_dead_body/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)

//Mobs which turn into unique icon after dining
/datum/ai_behavior/eat_dead_body/bog_troll/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)
		controller.pawn.icon_state = "Trollso"

/datum/ai_behavior/eat_dead_body/mimic/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		var/mob/living/simple_animal/hostile/basic_mob = controller.pawn
		if(!basic_mob.stat) // if the mimic's not dead
			basic_mob.Aggro() // someone interrupted us! go get 'em!
