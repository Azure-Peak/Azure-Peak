/////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// SPAWNING VALIDATION
/*
	if we can't find a landmark, we default to sending it to the usual Stewardry location
	if this happens you need to map in either a
	/obj/effect/landmark/territory_import/grove
	or: 
	/obj/effect/landmark/territory_import/city 
*/
/proc/validate_territory_spawn(spawnloc_name)
	if(spawnloc_name == "Warcamp")
		return TRUE
	var/is_grove = findtext(spawnloc_name, "Groveside")
	var/landmark_type = is_grove ? /obj/effect/landmark/territory_import/grove : /obj/effect/landmark/territory_import/city

	if(GLOB.landmarks_list && landmark_type)
		for(var/obj/effect/landmark/L in GLOB.landmarks_list)
			if(istype(L, landmark_type))
				return get_turf(L)
	
	message_admins("Could not find Territory Import landmark for [spawnloc_name]. Using warehouse fallback.")
	var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/warehouse]
	if(A)
		var/list/valid_turfs = list()
		for(var/turf/T in A)
			if(!T.density)
				valid_turfs += T
		if(valid_turfs.len)
			return pick(valid_turfs)
	
	return

/proc/validate_territory_import(datum/territory/estate, spawnloc_name, received_value)
	if(!estate || !spawnloc_name || !received_value || received_value <= 0)
		return FALSE

	if(!validate_territory_spawn(spawnloc_name))
		return FALSE

	var/city_tax = 60
	var/grove_tax = 0
	var/is_grove = findtext(spawnloc_name, "Groveside")

	// check for a blockade
	if(SSwarbands.warband_managers)
		for(var/atom/movable/screen/warband/manager/found_warband in SSwarbands.warband_managers)
			if(found_warband.selected_aspects && found_warband.selected_aspects.len)
				for(var/datum/warbands/aspects/found_aspect in found_warband.selected_aspects)
					if(istype(found_aspect, /datum/warbands/aspects/blockade))
						grove_tax = 30
						city_tax = 90
						break
			if(grove_tax == 30)
				break

	var/tax_percent = is_grove ? grove_tax : city_tax
	var/tax_deduction = received_value * (tax_percent / 100)
	var/post_tax_value = received_value - tax_deduction
	var/dist_calc = max(1, estate.distance)
	var/final_goods_value = round(post_tax_value / dist_calc)
	return final_goods_value

/proc/execute_territory_import(datum/territory/estate, spawnloc_name, received_value, mob/user)
	var/final_goods_value = validate_territory_import(estate, spawnloc_name, received_value)
	if(final_goods_value <= 0)
		return FALSE

	var/turf/spawn_turf
	if(spawnloc_name == "Warcamp" || spawnloc_name == "Warcamp (No Toll)")
		if(user && user.mind && user.mind.warband_manager)
			var/atom/movable/screen/warband/manager/manager = user.mind.warband_manager
			if(manager.warband_spawn_turf)
				spawn_turf = manager.warband_spawn_turf
		if(!spawn_turf)
			for(var/obj/structure/fluff/warband/campaign_planner/planner in SSwarbands.warband_machines)
				if(planner.warband_ID == user.mind.warband_ID)
					spawn_turf = get_turf(planner)
					break
	if(!spawn_turf)
		spawn_turf = validate_territory_spawn(spawnloc_name)
		if(spawn_turf == TRUE)
			return FALSE

	if(!spawn_turf)
		return FALSE

	// generate a unique lock number
	var/chest_lockhash = rand(100, 99999)
	while(chest_lockhash in GLOB.lockhashes)
		chest_lockhash = rand(100, 99999) // reroll it if it already exists
	GLOB.lockhashes += chest_lockhash

	var/obj/item/roguekey/custom/chest_key = new(user.loc)
	chest_key.lockhash = chest_lockhash
	chest_key.name = "estate shipment key"
	chest_key.desc = "A key to an estate shipment from [estate.name]."
	if(user)
		user.put_in_hands(chest_key)
		to_chat(user, span_notice("A key is ejected into my hands. It will open the shipment chest."))

	// if the spawn location is the fallback point, we skip the spawn delay because there'd really be no point
	// skip it for warbands too
	var/area/spawn_area = get_area(spawn_turf)
	var/is_warehouse = istype(spawn_area, /area/rogue/indoors/town/warehouse)
	var/is_warcamp = (spawnloc_name == "Warcamp (No Toll)")
	var/spawn_delay = is_warehouse || is_warcamp ? 0 : rand(7 MINUTES, 10 MINUTES)
	if(is_warehouse)
		to_chat(user, span_notice("(ERROR: Could not find Territory Import landmark for [spawnloc_name]. Send a bug report.)"))
		to_chat(user, span_notice("(Import location has defaulted to the interior of the Steward's warehouse.)"))	
	if(spawn_delay > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(spawn_estate_chest), spawn_turf, estate, final_goods_value, chest_lockhash, spawnloc_name), spawn_delay)
		if(findtext(spawnloc_name, "Groveside")) // notify bandits during grove imports
			for(var/obj/item/mattcoin/bandit_ring in SSroguemachine.scomm_machines)
				if(bandit_ring.loc.type == /mob/living/carbon/human && bandit_ring.listening)
					var/wearer = bandit_ring.loc
					to_chat(wearer, span_warning("The gem within my [bandit_ring.name] burns. Somewhere in the Grove, treasure flows."))
	else
		spawn_estate_chest(spawn_turf, estate, final_goods_value, chest_lockhash, spawnloc_name)

	return TRUE

/proc/spawn_estate_chest(turf/spawn_turf, datum/territory/estate, final_goods_value, chest_lockhash, spawnloc_name)
	var/obj/structure/closet/crate/chest/gold/estate/chest = new(spawn_turf)
	chest.name = "Estate Shipment: [estate.name]"
	chest.desc = "A shipment containing goods from [estate.name]."

	chest.keylock = TRUE
	chest.locked = TRUE
	chest.lockhash = chest_lockhash
	
	var/datum/goods/G = new estate.prized_good
	var/object_limit = 80
	var/items_spawned = 0

	while(final_goods_value > 0)
		if(items_spawned >= object_limit) // items in excess of the object limit (80) are imported as silver coins	
			var/coins_needed = max(1, round(final_goods_value / 10))
			var/max_stack = 20
			while(coins_needed > 0)
				var/stack_size = min(coins_needed, max_stack)
				var/obj/item/roguecoin/silver/pile/silver = new(chest)
				silver.quantity = stack_size
				silver.update_icon()
				coins_needed -= stack_size
			final_goods_value = 0
			break

		var/item_type = pick(G.items)
		var/atom/movable/I = new item_type(chest)

		var/item_cost = 25 // minimum/default value for a single imported Prized Good is 25
		if(G.unique_import_value)
			item_cost = G.unique_import_value
		else if(istype(I, /obj/item))
			var/obj/item/spawned_item = I
			if(spawned_item.sellprice >= 25)
				item_cost = spawned_item.sellprice
			else
				item_cost = 25
		final_goods_value -= item_cost
		items_spawned++

/proc/finalize_import_writ_payment(obj/item/import_writ/writ, turf/drop_location)
	if(!writ)
		return
	
	if(writ.attached_grant)
		var/obj/item/grant/G = writ.attached_grant
		var/excess_value = G.grant_amount - writ.import_amount
		
		// if there's excess value, we need to create a refund
		if(excess_value > 0 && drop_location)
			var/remaining_to_return = excess_value
			for(var/obj/item/roguecoin/C in G.contents)
				if(remaining_to_return <= 0)
					break
				var/coin_value = C.get_real_price()
				if(coin_value <= remaining_to_return)
					C.forceMove(drop_location)
					remaining_to_return -= coin_value
				else
					if(istype(C, /obj/item/roguecoin/silver/pile) || istype(C, /obj/item/roguecoin/copper/pile) || istype(C, /obj/item/roguecoin/gold/pile))
						var/coin_unit_value = coin_value / C.quantity
						var/coins_to_return = round(remaining_to_return / coin_unit_value)
						if(coins_to_return > 0)
							var/obj/item/roguecoin/returned_stack = new C.type(drop_location)
							returned_stack.quantity = coins_to_return
							returned_stack.update_icon()
							C.quantity -= coins_to_return
							C.update_icon()
							remaining_to_return -= (coins_to_return * coin_unit_value)
		qdel(G)
		writ.attached_grant = null
		writ.update_icon_state()

