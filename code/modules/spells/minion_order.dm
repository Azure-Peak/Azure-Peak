/datum/action/cooldown/spell/minion_order
	name = "Order Minions"
	desc = "Issues commands to your summoned minions within 12 tiles. \
	Cast on a turf to send them marching there, ignoring all else along the way. \
	Cast on yourself to recall them - they will turn passive and follow you. \
	Cast on an enemy to focus them; minions will pursue and attack that target. \
	Cast on one of your own minions to toggle its stance: a passive minion becomes hostile and will hunt strangers on its own; a hostile minion calms down and reverts to follow-and-defend. \
	Does not work on greater skeletons."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "raiseskele"
	cast_range = 12
	associated_skill = /datum/skill/misc/athletics
	charge_required = FALSE
	primary_resource_type = SPELL_COST_NONE
	cooldown_time = 2 SECONDS
	spell_requirements = SPELL_REQUIRES_SAME_Z
	zizo_spell = TRUE
	has_visual_effects = FALSE
	sound = null
	var/order_range = 12
	var/faction_ordering = FALSE

/datum/action/cooldown/spell/minion_order/lich
	faction_ordering = TRUE

/datum/action/cooldown/spell/minion_order/cast(atom/cast_on)
	. = ..()
	var/faction_tag = "[owner.mind.current.real_name]_faction"

	if(ismob(cast_on) && istype(cast_on, /mob/living/simple_animal))
		var/mob/living/simple_animal/minion = cast_on
		if(faction_tag in minion.faction)
			process_minions(order_type = "toggle_stance", target = minion, faction_tag = faction_tag)
			return TRUE

	if(isturf(cast_on))
		process_minions(order_type = "goto", target_location = cast_on, faction_tag = faction_tag)
		return TRUE

	if(cast_on == owner)
		process_minions(order_type = "follow", target = owner, faction_tag = faction_tag)
		return TRUE

	if(ismob(cast_on))
		var/mob/living/mob_target = cast_on
		if(faction_tag in mob_target.faction)
			process_minions(order_type = "aggressive", target = mob_target, faction_tag = faction_tag)
		else
			process_minions(order_type = "attack", target = mob_target, faction_tag = faction_tag)
		return TRUE

	reset_spell_cooldown()
	return FALSE

/datum/action/cooldown/spell/minion_order/proc/process_minions(order_type, turf/target_location, mob/living/target, faction_tag)
	var/count = 0
	var/msg = ""

	for(var/mob/other_mob in oview(order_range, owner))
		if(istype(other_mob, /mob/living/simple_animal) && !other_mob.client)
			var/mob/living/simple_animal/minion = other_mob

			if((faction_ordering && owner.faction_check_mob(minion)) || (!faction_ordering && faction_tag && (faction_tag in minion.faction)))
				minion.ai_controller.CancelActions()
				minion.ai_controller.clear_blackboard_key(BB_FOLLOW_TARGET)
				minion.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
				minion.ai_controller.clear_blackboard_key(BB_TRAVEL_DESTINATION)
				minion.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
				count += 1
				switch(order_type)
					if("goto")
						minion.ai_controller.set_blackboard_key(BB_TRAVEL_DESTINATION, target_location)
						msg = "go to [target_location]"
					if("follow")
						minion.ai_controller.set_blackboard_key(BB_FOLLOW_TARGET, target)
						msg = "follow you."
					if("aggressive")
						msg = "roam free."
					if("attack")
						minion.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
						msg = "attack [target.name]"
					if("toggle_stance")
						if(minion == target)
							if("neutral" in minion.faction)
								minion.faction -= "neutral"
								minion.pet_passive = FALSE
								msg = "[minion.name] becomes hostile to nearby strangers."
							else
								minion.faction += "neutral"
								minion.pet_passive = TRUE
								msg = "[minion.name] calms down."
	if(count > 0)
		to_chat(owner, "Ordered [count] minions to [msg]")
	else
		to_chat(owner, "We weren't able to order anyone.")
