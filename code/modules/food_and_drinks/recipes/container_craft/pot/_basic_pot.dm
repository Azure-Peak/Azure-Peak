/datum/container_craft/cooking
	abstract_type = /datum/container_craft/cooking
	category = FOOD_CAT_STEW
	crafting_time = 60 SECONDS
	reagent_requirements = list(
		/datum/reagent/water = STEW_WATER_REQUIRED
	)
	craft_verb = "cooking for "
	required_container = /obj/item/reagent_containers/glass/bucket/pot
	cook_method = COOK_BOIL
	var/datum/reagent/created_reagent
	var/water_conversion = 1
	var/datum/pollutant/finished_smell
	///the amount we pollute
	var/pollute_amount = 600
	///our required boiling temperature
	var/required_chem_temp = STEW_TEMPERATURE

/datum/container_craft/cooking/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/removing_items)
	. = ..()
	if(!created_output)
		return
	if(cooked_smell)
		created_output.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)

	for(var/obj/item/reagent_containers/food/snacks/item in removing_items)
		item.initialize_cooked_food(created_output, 1)

/datum/container_craft/cooking/try_craft(obj/item/crafter, list/pathed_items, mob/initiator, datum/callback/on_craft_start, datum/callback/on_craft_failed)
	if(!crafter.reagents || crafter.reagents.chem_temp < required_chem_temp)
		return FALSE
	. = ..()

/datum/container_craft/cooking/check_failure(obj/item/crafter, mob/user)
	if(!crafter.reagents || crafter.reagents.chem_temp < required_chem_temp)
		return TRUE
	return FALSE

/datum/container_craft/cooking/can_progress(obj/item/crafter, mob/user)
	if(!crafter.reagents || crafter.reagents.chem_temp < required_chem_temp)
		return FALSE
	return TRUE

/datum/container_craft/cooking/announce_stall(atom/crafter, mob/initiator)
	if(QDELETED(crafter))
		return
	crafter.visible_message(span_warning("[crafter] stops boiling."))

/datum/container_craft/cooking/announce_resume(atom/crafter, mob/initiator)
	if(QDELETED(crafter))
		return
	crafter.visible_message(span_notice("[crafter] comes back to a boil."))

/datum/container_craft/cooking/get_real_time(atom/host, mob/user, estimated_multiplier)
	var/real_cooking_time = crafting_time * estimated_multiplier
	return round(real_cooking_time / get_cooktime_divisor(user?.get_skill_level(used_skill)))

/datum/container_craft/cooking/create_item(obj/item/crafter, mob/initiator, list/removing_items)
	if(created_reagent)
		var/turf/pot_turf = get_turf(crafter)
		var/datum/reagent/first = reagent_requirements[1]
		var/reagent_amount = reagent_requirements[first]
		var/pot_temperature = crafter.reagents.chem_temp

		for(var/j = 1 to output_amount)
			crafter.reagents.add_reagent(created_reagent, reagent_amount * water_conversion, null, pot_temperature)

			after_craft(null, crafter, initiator, removing_items)
			if(finished_smell)
				pot_turf.pollute_turf(finished_smell, pollute_amount)
			SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_COMPLETE, null)
		playsound(pot_turf, "bubbles", 30, TRUE)
	else
		..()

/datum/container_craft/cooking/announce_start(atom/crafter, mob/initiator, estimated_multiplier)
	if(QDELETED(crafter))
		return
	crafter.visible_message(span_notice("[crafter] begins to simmer."))

/datum/container_craft/cooking/announce_fail(atom/crafter, mob/initiator)
	if(QDELETED(crafter))
		return
	crafter.visible_message(span_warning("[crafter] stops cooking."))

/datum/container_craft/cooking/extra_html()
	if(!created_reagent)
		return
	var/html
	var/datum/reagent/first = reagent_requirements[1]
	var/result_amount = reagent_requirements[first]
	if(water_conversion > 0)
		result_amount = CEILING((result_amount * water_conversion), 1)
	html += "[result_amount] [UNIT_FORM_STRING(result_amount)] of [initial(created_reagent.name)]."
	return html
