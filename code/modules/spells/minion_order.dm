/obj/effect/proc_holder/spell/invoked/minion_order
	name = "Order Minions"
	desc = "Cast on turf to head in that direction ignoring all else. \
	Cast on a minion to set to aggressive, cast on self to passive and follow, cast on target to focus them. \
	Does not work on greater skeletons."
	range = 12
	associated_skill = /datum/skill/misc/athletics
	chargedrain = 1
	chargetime = 0 SECONDS
	releasedrain = 0
	recharge_time = 3 SECONDS
	var/order_range = 12
	var/faction_ordering = FALSE ///this sets whether it orders mobs the user is aligned with in range or just mobs who are the character's 'friends' (ie, their summons)

/obj/effect/proc_holder/spell/invoked/minion_order/lich //as an example, this should allow the lich to command the entire undead faction
	faction_ordering = TRUE

/obj/effect/proc_holder/spell/invoked/minion_order/cast(list/targets, mob/user)
	var/mob/caster = user
	var/target = targets[1]
	var/faction_tag = "[caster.mind.current.real_name]_faction"

	// Target is one of our own minions
	if(ismob(target) && istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/minion = target
		if(faction_tag in minion.faction)
			src.process_minions(order_type = "toggle_stance", target = minion, faction_tag = faction_tag)
			return

	// Minions goto turf
	if(isturf(target))
		src.process_minions(order_type = "goto", target_location = target, faction_tag = faction_tag)
		return

	// Target is the caster (set minions to passive and follow)
	else if(target == caster)
		src.process_minions(order_type = "follow", target = caster, faction_tag = faction_tag)
		return

	// Target is another mob
	else if(ismob(target))
		var/mob/living/mob_target = target
		if(faction_tag in mob_target.faction)//We're only checking for faction tagged individuals. Potential issue may arise with commanded mobs attacking mobs with same faction leading to cheese circumstances, but most mobs are retaliatory.
			src.process_minions(order_type = "aggressive", target = target, faction_tag = faction_tag)
			return
		else
			// Set all minions to focus on the enemy target
			src.process_minions(order_type = "attack", target = target, faction_tag = faction_tag)
			return
	else
		revert_cast()
		return

/obj/effect/proc_holder/spell/invoked/minion_order/proc/process_minions(var/order_type, turf/target_location = null, mob/living/target = null, var/faction_tag = null)
	var/mob/caster = usr
	var/count = 0
	var/msg = ""

	for (var/mob/other_mob in oview(src.order_range, caster))
		if (istype(other_mob, /mob/living/simple_animal) && !other_mob.client) // Only simple_mobs for now
			var/mob/living/simple_animal/minion = other_mob

			if ((faction_ordering && caster.faction_check_mob(minion)) || (!faction_ordering && faction_tag && (faction_tag in minion.faction)))
				minion.ai_controller.CancelActions()	//this should immediately halt present actions/orders given.
				minion.ai_controller.clear_blackboard_key(BB_FOLLOW_TARGET)
				minion.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
				minion.ai_controller.clear_blackboard_key(BB_TRAVEL_DESTINATION)
				minion.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
				count += 1
				switch (order_type)
					if ("goto")
						minion.ai_controller.set_blackboard_key(BB_TRAVEL_DESTINATION, target_location)
						msg = "go to [target_location]"
					if ("follow")
						minion.ai_controller.set_blackboard_key(BB_FOLLOW_TARGET, target)
						msg = "follow you."
					if ("aggressive")
						msg = "roam free."
					if ("attack")
						minion.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
						msg = "attack [target.name]"
					if("toggle_stance")
						if(minion == target) // single minion clicked
							if("neutral" in minion.faction) // currently passive → switch to aggressive
								minion.faction -= "neutral"
								msg = "[minion.name] becomes hostile to nearby strangers."
							else
								minion.faction += "neutral"
								msg = "[minion.name] calms down."
	if(count>0)
		to_chat(caster, "Ordered [count] minions to " + msg)
	else
		to_chat(caster, "We weren't able to order anyone.")
