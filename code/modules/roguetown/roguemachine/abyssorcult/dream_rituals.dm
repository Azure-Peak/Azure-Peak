/proc/initialize_abyssal_rituals()
	GLOB.abyssal_rituals = list()
	for(var/datum/abyssal_ritual/R as anything in subtypesof(/datum/abyssal_ritual))
		var/datum/abyssal_ritual/instance = new R()
		GLOB.abyssal_rituals[instance.name] = instance

/datum/abyssal_ritual
	var/name = "Generic Ritual"
	var/desc = ""
	/// Base devotion cost required to execute
	var/base_devotion_cost = 200
	/// Channel time required in deciseconds (e.g., 150 = 15 seconds)
	var/base_channel_time = 150
	var/list/required_ingredients = list()

/datum/abyssal_ritual/proc/get_calculated_costs(list/mob/living/channelers)
	var/maged_count = 0
	for(var/mob/living/M in channelers)
		if(isarcyne(M)) 
			maged_count++
	var/extra_helpers = max(0, maged_count - 1)
	var/discount_multiplier = max(0.5, 1 - (extra_helpers * 0.15))
	return round(base_devotion_cost * discount_multiplier)

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

/datum/abyssal_ritual/proc/consume_ingredients(obj/structure/roguemachine/dream_pool/P)
	if(!length(required_ingredients))
		return

	var/list/to_consume = required_ingredients.Copy()
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
	return TRUE
