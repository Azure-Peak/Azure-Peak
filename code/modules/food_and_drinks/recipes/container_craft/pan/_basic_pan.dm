/datum/container_craft/pan
	abstract_type = /datum/container_craft/pan
	required_container = /obj/item/cooking/pan
	crafting_time = 30 SECONDS
	category = FOOD_CAT_PAN
	cook_method = COOK_FRY
	hides_from_books = TRUE
	synthesize_recipes = TRUE

	cooking_sound = /datum/looping_sound/frying

/datum/container_craft/pan/get_real_time(atom/host, mob/user, estimated_multiplier)
	var/real_cooking_time = crafting_time * estimated_multiplier
	return round(real_cooking_time / get_cooktime_divisor(user?.get_skill_level(used_skill)))

/datum/container_craft/pan/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/removing_items)
	. = ..()
	if(cooked_smell)
		created_output.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)

	for(var/obj/item/reagent_containers/food/snacks/item in removing_items)
		item.initialize_cooked_food(created_output, 1)

	for(var/obj/item/seeds/seed in removing_items)
		seed.initialize_cooked_seed(created_output, 1)

/datum/container_craft/pan/try_craft(obj/item/crafter, list/pathed_items, mob/initiator, datum/callback/on_craft_start, datum/callback/on_craft_failed)
	if(!istype(crafter.loc, /obj/machinery/light/rogue/hearth))
		return FALSE
	var/obj/machinery/light/rogue/hearth/hearth = crafter.loc
	if(!hearth.on)
		return FALSE
	. = ..()

/datum/container_craft/pan/check_failure(obj/item/crafter, mob/user)
	if(!istype(crafter.loc, /obj/machinery/light/rogue/hearth))
		return TRUE
	var/obj/machinery/light/rogue/hearth/hearth = crafter.loc
	if(!hearth.on)
		return TRUE
	return FALSE

/datum/container_craft/pan/meat_steak_troll_fried
	name = "Rendered Troll Fat"
	crafting_time = 150 SECONDS
	requirements = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll/fried = 1)
	output = /obj/item/reagent_containers/food/snacks/fat
	cooked_smell = /datum/pollutant/food/fried_meat

/datum/container_craft/pan/egg
	name = "Fried Egg"
	requirements = list(/obj/item/reagent_containers/food/snacks/rogue/egg = 1)
	output = /obj/item/reagent_containers/food/snacks/rogue/friedegg/fried

/datum/container_craft/pan/egg/announce_start(atom/crafter, mob/initiator, estimated_multiplier)
	. = ..()
	if(QDELETED(crafter))
		return
	playsound(crafter, 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
	var/count = 0
	for(var/obj/item/reagent_containers/food/snacks/rogue/egg/egg in crafter.contents)
		if(count >= estimated_multiplier)
			break
		egg.icon_state = "rawegg"
		count++
	crafter.update_icon()

/datum/container_craft/pan/handoff
	abstract_type = /datum/container_craft/pan/handoff
	synthesize_recipes = FALSE
	handoff_craft = TRUE
