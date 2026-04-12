/datum/ai_planning_subtree/generic_wield/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/living_pawn = controller.pawn
	var/obj/item/active = living_pawn.get_active_held_item()
	var/obj/item/inactive = living_pawn.get_inactive_held_item()
	if(active && inactive)
		return
	var/obj/item/unwielded_twohander = null
	if(active?.gripped_intents && !active.wielded)
		unwielded_twohander = active
	else if(inactive?.gripped_intents && !inactive.wielded)
		unwielded_twohander = inactive
	if(unwielded_twohander)
		controller.queue_behavior(/datum/ai_behavior/wield_weapon)

/datum/ai_behavior/wield_weapon/perform(seconds_per_tick, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	var/obj/item/active = living_pawn.get_active_held_item()
	var/obj/item/inactive = living_pawn.get_inactive_held_item()
	var/obj/item/to_wield = null
	if(active?.gripped_intents && !active.wielded)
		to_wield = active
	else if(inactive?.gripped_intents && !inactive.wielded)
		to_wield = inactive
	if(to_wield)
		to_wield.wield(living_pawn)
	finish_action(controller, TRUE)
