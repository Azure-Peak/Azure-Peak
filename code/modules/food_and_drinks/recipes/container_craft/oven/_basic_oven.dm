/datum/container_craft/oven
	abstract_type = /datum/container_craft/oven
	required_container = /obj/machinery/light/rogue/oven
	crafting_time = 60 SECONDS
	category = FOOD_CAT_OVEN
	cook_method = COOK_BAKE
	hides_from_books = TRUE
	synthesize_recipes = TRUE


/datum/container_craft/oven/proc/lit_oven(atom/crafter)
	var/obj/machinery/light/rogue/oven/oven = crafter
	if(!istype(oven))
		oven = crafter.loc
	if(!istype(oven))
		return null
	if(!oven.on)
		return null
	return oven

/datum/container_craft/oven/get_real_time(atom/host, mob/user, estimated_multiplier)
	var/real_cooking_time = crafting_time * estimated_multiplier
	return round(real_cooking_time / get_cooktime_divisor(user?.get_skill_level(used_skill)))

/datum/container_craft/oven/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/removing_items)
	. = ..()
	if(cooked_smell)
		created_output.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)

	for(var/obj/item/reagent_containers/food/snacks/item in removing_items)
		item.initialize_cooked_food(created_output, 1)

	for(var/obj/item/seeds/seed in removing_items)
		seed.initialize_cooked_seed(created_output, 1)

/datum/container_craft/oven/try_craft(obj/item/crafter, list/pathed_items, mob/initiator, datum/callback/on_craft_start, datum/callback/on_craft_failed)
	if(!lit_oven(crafter))
		return FALSE
	. = ..()

/datum/container_craft/oven/check_failure(obj/item/crafter, mob/user)
	if(!lit_oven(crafter))
		return TRUE
	return FALSE

/datum/container_craft/oven/handoff
	abstract_type = /datum/container_craft/oven/handoff
	synthesize_recipes = FALSE
	handoff_craft = TRUE
