/datum/container_craft/cooking/render
	abstract_type = /datum/container_craft/cooking/render
	category = FOOD_CAT_DEEPFRIED
	crafting_time = 2 SECONDS
	reagent_requirements = null
	complete_message = "The fat melts down into oil."

/datum/container_craft/cooking/render/try_craft(obj/item/crafter, list/pathed_items, mob/initiator, datum/callback/on_craft_start, datum/callback/on_craft_failed)
	if(crafter.reagents?.has_reagent(/datum/reagent/water))
		return FALSE
	. = ..()

/datum/container_craft/cooking/render/check_failure(obj/item/crafter, mob/user)
	if(crafter.reagents?.has_reagent(/datum/reagent/water))
		return TRUE
	return ..()

/datum/container_craft/cooking/render/create_item(obj/item/crafter, mob/initiator, list/removing_items)
	var/rendered = 0
	for(var/obj/item/reagent_containers/food/snacks/source in removing_items)
		rendered += source.fat_yield
	if(!rendered)
		return
	var/pot_temperature = crafter.reagents.chem_temp
	crafter.reagents.add_reagent(/datum/reagent/consumable/oil/tallow, rendered, null, pot_temperature)
	playsound(get_turf(crafter), 'sound/items/Fish_out.ogg', 20, TRUE)
	SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_COMPLETE, null)

/datum/container_craft/cooking/render/announce_start(atom/crafter, mob/initiator, estimated_multiplier)
	if(QDELETED(crafter))
		return
	crafter.visible_message(span_notice("The fat begins to render down in [crafter]."))

/datum/container_craft/cooking/render/announce_fail(atom/crafter, mob/initiator)
	if(QDELETED(crafter))
		return
	crafter.visible_message(span_warning("The fat stops rendering in [crafter]."))

/datum/container_craft/cooking/render/announce_stall(atom/crafter, mob/initiator)
	if(QDELETED(crafter))
		return
	crafter.visible_message(span_warning("[crafter] cools, and the fat stops rendering."))

/datum/container_craft/cooking/render/announce_resume(atom/crafter, mob/initiator)
	if(QDELETED(crafter))
		return
	crafter.visible_message(span_notice("[crafter] heats back up, and the fat renders again."))

/datum/container_craft/cooking/render/extra_html()
	var/obj/item/reagent_containers/food/snacks/source = requirements[1]
	var/tallow_yield = initial(source.fat_yield)
	return "[tallow_yield] [UNIT_FORM_STRING(tallow_yield)] of tallow."

/datum/container_craft/cooking/render/fat
	name = "Rendered Fat"
	requirements = list(/obj/item/reagent_containers/food/snacks/fat = 1)

/datum/container_craft/cooking/render/tallow
	name = "Rendered Tallow"
	requirements = list(/obj/item/reagent_containers/food/snacks/tallow = 1)
