/proc/initialize_abyssal_rituals()
	GLOB.abyssal_rituals = list()
	for(var/datum/abyssal_ritual/R as anything in subtypesof(/datum/abyssal_ritual))
		if(R == /datum/abyssal_ritual)
			continue
		var/datum/abyssal_ritual/instance = new R()
		GLOB.abyssal_rituals[instance.name] = instance

/datum/abyssal_ritual
	var/name = "Generic Ritual"
	var/desc = ""
	/// Channel time required in deciseconds (e.g., 150 = 15 seconds)
	var/base_channel_time = 150
	var/list/required_ingredients = list()
	var/list/invocation_phases  = list(
		"Abyssor, hwja'ajaba!",
		"Iä! Iä! Abyssor fhtagn!",
		"The deep rises to my call!",
		"By the salt and the tide, awaken!"
	)
	/// An associative list of items spawned upon completion: list(/obj/item/path = count)
	var/list/reward_items = list()
	/// The sound file played upon successful completion
	var/success_sound = 'sound/magic/whale.ogg'

/datum/abyssal_ritual/proc/get_calculated_ingredients(list/mob/living/channelers)
	if(!length(required_ingredients))
		return list()

	var/list/discounted_ingredients = required_ingredients.Copy()

	var/total_items = 0
	for(var/req_type in discounted_ingredients)
		total_items += discounted_ingredients[req_type]
	if(total_items <= 1)
		return discounted_ingredients

	var/abyssorite_count = 0
	var/holy_count = 0
	for(var/mob/living/M in channelers)
		if(M.get_skill_level(/datum/skill/magic/holy) < 1)
			continue
		if(istype(M.patron, /datum/patron/divine/abyssor))
			abyssorite_count++
		else
			holy_count++

	abyssorite_count = min(3, abyssorite_count)
	holy_count = min(3, holy_count)
	if(!abyssorite_count && !holy_count)
		return discounted_ingredients

	var/items_to_discount = 0

	if(total_items >= 3)
		if(prob(20 * abyssorite_count) || prob(15 * holy_count))
			items_to_discount++
		if(prob(15 * abyssorite_count) || prob(12 * holy_count))
			items_to_discount++
	else if(total_items == 2)
		if(prob(15 * abyssorite_count) || prob(12 * holy_count))
			items_to_discount++

	items_to_discount = min(items_to_discount, total_items - 1)

	while(items_to_discount > 0)
		var/list/valid_keys = list()
		for(var/req_type in discounted_ingredients)
			if(discounted_ingredients[req_type] > 0)
				valid_keys += req_type
		if(!length(valid_keys))
			break
		var/chosen_key = pick(valid_keys)
		discounted_ingredients[chosen_key]--
		if(discounted_ingredients[chosen_key] <= 0)
			discounted_ingredients -= chosen_key
		items_to_discount--

	return discounted_ingredients

/datum/abyssal_ritual/proc/check_ingredients(obj/structure/roguemachine/dream_pool/P)
	if(!length(required_ingredients))
		return TRUE
	var/list/pool_inventory = list()
	for(var/turf/T in P.get_outer_rim_turfs())
		for(var/obj/item/I in T)
			var/count = hasvar(I, "amount") ? I:amount : 1
			for(var/req_type in required_ingredients)
				if(istype(I, req_type))
					pool_inventory[req_type] += count
	for(var/req_type in required_ingredients)
		var/required_amount = required_ingredients[req_type]
		var/available_amount = pool_inventory[req_type] || 0
		if(available_amount < required_amount)
			return FALSE
	return TRUE

/datum/abyssal_ritual/proc/consume_ingredients(obj/structure/roguemachine/dream_pool/P, list/mob/living/channelers)
	if(!length(required_ingredients))
		return

	var/list/to_consume = get_calculated_ingredients(channelers)

	for(var/turf/T in P.get_outer_rim_turfs())
		for(var/obj/item/I in T)
			for(var/req_type in to_consume)
				if(!to_consume[req_type])
					continue
				if(istype(I, req_type))
					var/needed = to_consume[req_type]
					if(hasvar(I, "amount"))
						var/stack_amount = I:amount
						if(stack_amount > needed)
							I:amount -= needed
							to_consume[req_type] = 0
						else
							to_consume[req_type] -= stack_amount
							qdel(I)
					else
						to_consume[req_type]--
						qdel(I)
					break

/datum/abyssal_ritual/proc/on_success(obj/structure/roguemachine/dream_pool/P, mob/living/leader, list/mob/living/channelers)
	if(success_sound)
		playsound(P, success_sound, 100, TRUE)

	var/turf/spawn_turf = get_turf(leader)
	if(spawn_turf)
		for(var/reward_type in reward_items)
			var/spawn_count = reward_items[reward_type]
			if(spawn_count <= 0)
				continue
			for(var/i in 1 to spawn_count)
				new reward_type(spawn_turf)
	return TRUE

/datum/abyssal_ritual/proc/can_commence_ritual(obj/structure/roguemachine/dream_pool/P, mob/living/leader)
	return TRUE
