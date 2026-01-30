/obj/item/reagent_containers/glass/crucible
	name = "crucible"
	desc = "A clay crucible for melting metals. Handle with care when hot."
	icon = 'icons/roguetown/items/anvil_casting.dmi'
	icon_state = "crucible"
	item_state = "crucible"
	force = 10
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_BULKY
	reagent_flags = OPENCONTAINER
	volume = 5 // Holds up to 5 ingots
	var/max_ingots = 5
	var/list/ingots = list()
	var/hot = FALSE
	var/heat_progress = 0
	var/heat_capacity = 100
	var/heat_rate = 10
	var/cool_rate = 5
	var/last_heat_time = 0
	var/duplication_threshold = 4 // Every 4 ingots deposited will duplicate the last one
	var/list/ingots_added_total = list()

/obj/item/reagent_containers/glass/crucible/proc/add_ingot(var/ingot_type, var/mob/user)
	// Initialize counters if they don't exist
	if(!ingots[ingot_type])
		ingots[ingot_type] = 0
	if(!ingots_added_total[ingot_type])
		ingots_added_total[ingot_type] = 0

	var/current_total = get_total_ingots()
	var/ingots_to_add = 1
	var/should_duplicate = FALSE

	// Check if we should duplicate (every 4th ingot of this type added overall)
	ingots_added_total[ingot_type]++
	if(ingots_added_total[ingot_type] % duplication_threshold == 0)
		ingots_added_total[ingot_type] = 0
		should_duplicate = TRUE
		ingots_to_add = 2

	var/available_space = max_ingots - current_total
	var/actual_ingots_added = min(ingots_to_add, available_space)
	var/extra_ingots = ingots_to_add - actual_ingots_added
	ingots[ingot_type] += actual_ingots_added

	if(extra_ingots > 0)
		for(var/i = 1; i <= extra_ingots; i++)
			var/obj/item/ingot/new_ingot = new ingot_type(get_turf(src))
			new_ingot.forceMove(get_turf(src))
			to_chat(user, span_notice("The crucible overflows! An extra [new_ingot.name] falls to the ground."))

	// Give appropriate feedback
	if(should_duplicate)
		if(actual_ingots_added == 2)
			to_chat(user, span_notice("As you add the ingot, it seems to multiply in the crucible!"))
		else if(actual_ingots_added == 1)
			to_chat(user, span_notice("The ingot starts to multiply but the crucible is almost full!"))
	else if(actual_ingots_added == 1)
		to_chat(user, span_info("You add the ingot to the crucible."))

	heat_progress = 0
	update_icon()
	return actual_ingots_added

/obj/item/reagent_containers/glass/crucible/update_icon()
	cut_overlays()
	if(length(ingots) > 0 && hot)
		icon_state = "crucible_full"
	else
		icon_state = "crucible"

/obj/item/reagent_containers/glass/crucible/examine(mob/user)
	. = ..()
	if(length(ingots) > 0)
		. += span_info("It contains:")
		for(var/ingot_type in ingots)
			var/count = ingots[ingot_type]
			var/obj/item/ingot/I = ingot_type
			. += span_info("- [count] [initial(I.name)][count > 1 ? "s" : ""]")
		if(hot)
			. += span_warning("It's glowing hot with molten metal!")
		else if(heat_progress > 0)
			. += span_info("It's [round(heat_progress)]% heated.")
		else
			. += span_warning("The metal has solidified.")
	else
		. += span_info("It's empty.")

/obj/item/reagent_containers/glass/crucible/proc/heat_up(amount = 0)
	if(amount > 0)
		heat_progress = min(heat_progress + amount, heat_capacity)
		last_heat_time = world.time
	if(!hot && heat_progress >= heat_capacity && length(ingots) > 0)
		hot = TRUE
		playsound(src.loc, 'sound/items/firelight.ogg', 50, TRUE)
		update_icon()
	if(heat_progress > 0)
		update_icon()

/obj/item/reagent_containers/glass/crucible/proc/cool_down(amount = 0)
	if(amount > 0)
		heat_progress = max(heat_progress - amount, 0)
	if(hot && heat_progress < heat_capacity)
		hot = FALSE
		update_icon()

/obj/item/reagent_containers/glass/crucible/proc/get_total_ingots()
	var/total = 0
	for(var/ingot_type in ingots)
		total += ingots[ingot_type]
	return total

/obj/item/reagent_containers/glass/crucible/proc/get_primary_metal()
	// Return the most common metal type in the crucible
	if(length(ingots) == 0)
		return null
	var/primary_type
	var/highest_count = 0
	for(var/ingot_type in ingots)
		if(ingots[ingot_type] > highest_count)
			highest_count = ingots[ingot_type]
			primary_type = ingot_type
	return primary_type

/obj/item/sprue_funnel
	name = "sprue and funnel"
	desc = "A combined sprue and funnel for directing molten metal into a mold."
	icon = 'icons/roguetown/items/anvil_casting.dmi'
	icon_state = "sprue"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/mold
	name = "blade mold"
	desc = "A steel mold for casting blades."
	icon = 'icons/roguetown/items/anvil_casting.dmi'
	icon_state = "mold_blank"
	var/blade_type = null
	var/obj/item/sprue_funnel/attached_sprue = null
	var/pouring = FALSE
	var/cooling = FALSE
	var/cooling_progress = 0
	// Roughly two minutes (this is the lazy way)
	var/cooling_time = 120
	var/cooling_metal_type = null

	// Associate ingot types with blade types
	var/list/metal_to_blade = list(
		/obj/item/ingot/iron = /obj/item/blade/iron_sword, // Default fallback
	)

/obj/item/mold/examine(mob/user)
	. = ..()
	if(attached_sprue)
		if(pouring)
			. += span_info("It has a sprue and funnel attached and is currently being poured.")
		else
			. += span_info("It has a sprue and funnel attached, ready for pouring.")
	else
		. += span_info("It needs a sprue and funnel to be used.")

/obj/item/mold/attackby(obj/item/W, mob/user, params)
	// Attach sprue and funnel
	if(istype(W, /obj/item/sprue_funnel))
		if(attached_sprue)
			to_chat(user, span_warning("This mold already has a sprue and funnel attached."))
			return

		if(!user.transferItemToLoc(W, src))
			return

		attached_sprue = W
		update_icon()
		user.visible_message(span_info("[user] attaches the sprue and funnel to the mold."))
		return

	// Pour from crucible
	if(istype(W, /obj/item/reagent_containers/glass/crucible))
		var/obj/item/reagent_containers/glass/crucible/crucible = W

		if(!attached_sprue)
			to_chat(user, span_warning("This mold needs a sprue and funnel to pour metal into."))
			return

		if(pouring || cooling)
			to_chat(user, span_warning("This mold is already being used."))
			return

		if(!crucible.hot)
			to_chat(user, span_warning("The metal in the crucible isn't hot enough to pour."))
			return

		if(crucible.get_total_ingots() <= 0)
			to_chat(user, span_warning("The crucible is empty."))
			return

		user.visible_message(span_info("[user] begins pouring molten metal into the mold."))
		pouring = TRUE
		update_icon()

		if(do_after(user, 30, target = src))
			// Determine the blade type based on primary metal
			var/primary_metal = crucible.get_primary_metal()
			if(crucible.ingots[primary_metal] && crucible.ingots[primary_metal] > 0)
				crucible.ingots[primary_metal]--
				// If that was the last ingot of that type, remove the entry
				if(crucible.ingots[primary_metal] <= 0)
					crucible.ingots -= primary_metal

				// If crucible is now empty, reset heat
				if(crucible.get_total_ingots() <= 0)
					crucible.heat_progress = 0
					crucible.hot = FALSE

				crucible.update_icon()
				pouring = FALSE
				cooling = TRUE
				cooling_progress = 0
				cooling_metal_type = primary_metal
				update_icon()

				user.visible_message(span_info("[user] pours the molten metal into the mold. It will need time to cool and solidify."))
				START_PROCESSING(SSprocessing, src)
			else
				to_chat(user, span_warning("Couldn't find the appropriate metal in the crucible."))
				pouring = FALSE
				update_icon()
		else
			// If interrupted, reset pouring state
			pouring = FALSE
			update_icon()

		return

	..()

/obj/item/mold/process()
	if(!cooling)
		STOP_PROCESSING(SSprocessing, src)
		return

	cooling_progress++
	if(cooling_progress >= cooling_time)
		finish_cooling()

/obj/item/mold/proc/finish_cooling()
	if(!cooling_metal_type)
		cooling = FALSE
		STOP_PROCESSING(SSprocessing, src)
		return

	var/blade_path = metal_to_blade[cooling_metal_type]

	if(!blade_path)
		blade_path = metal_to_blade[/obj/item/ingot/iron]

	var/obj/item/blade/new_blade = new blade_path(get_turf(src))
	new_blade.forceMove(get_turf(src))
	
	if(attached_sprue)
		attached_sprue.forceMove(get_turf(src))
		attached_sprue = null
	cooling = FALSE
	cooling_metal_type = null
	cooling_progress = 0
	update_icon()

	STOP_PROCESSING(SSprocessing, src)

	visible_message(span_info("The metal in the mold has cooled and solidified. The sprue pops off!"))

/obj/item/mold/attack_hand(mob/user)
	if(attached_sprue && !pouring && !cooling)
		user.put_in_hands(attached_sprue)
		attached_sprue = null
		update_icon()
		user.visible_message(span_info("[user] removes the sprue and funnel from the mold."))
		return
	..()

/obj/item/mold/update_icon()
	cut_overlays()
	if(attached_sprue)
		var/mutable_appearance/sprue_overlay = mutable_appearance(icon, "sprue")
		sprue_overlay.pixel_x = -1
		sprue_overlay.pixel_y = 0
		add_overlay(sprue_overlay)

// Specific mold types with metal mappings
/obj/item/mold/axe
	name = "axe blade mold"
	desc = "A steel mold for casting axe blades."
	icon_state = "base_axe"
	blade_type = /obj/item/blade/iron_axe
	metal_to_blade = list(
		/obj/item/ingot/iron = /obj/item/blade/iron_axe,
		/obj/item/ingot/steel = /obj/item/blade/steel_axe,
		/obj/item/ingot/bronze = /obj/item/blade/bronze_axe
	)

/obj/item/mold/sword
	name = "sword blade mold"
	desc = "A steel mold for casting sword blades."
	icon_state = "base_sword"
	blade_type = /obj/item/blade/iron_sword
	metal_to_blade = list(
		/obj/item/ingot/iron = /obj/item/blade/iron_sword,
		/obj/item/ingot/steel = /obj/item/blade/steel_sword,
		/obj/item/ingot/bronze = /obj/item/blade/bronze_sword
	)

/obj/item/mold/knife
	name = "knife blade mold"
	desc = "A steel mold for casting knife blades."
	icon_state = "base_knife"
	blade_type = /obj/item/blade/iron_knife
	metal_to_blade = list(
		/obj/item/ingot/iron = /obj/item/blade/iron_knife,
		/obj/item/ingot/steel = /obj/item/blade/steel_knife,
		/obj/item/ingot/bronze = /obj/item/blade/bronze_knife
	)

/obj/item/mold/mace
	name = "mace head mold"
	desc = "A steel mold for casting mace heads."
	icon_state = "base_mace"
	blade_type = /obj/item/blade/iron_mace
	metal_to_blade = list(
		/obj/item/ingot/iron = /obj/item/blade/iron_mace,
		/obj/item/ingot/steel = /obj/item/blade/steel_mace,
		/obj/item/ingot/bronze = /obj/item/blade/bronze_mace
	)

/obj/item/mold/polearm
	name = "polearm blade mold"
	desc = "A steel mold for casting polearm blades."
	icon_state = "base_polearm"
	blade_type = /obj/item/blade/iron_polearm
	metal_to_blade = list(
		/obj/item/ingot/iron = /obj/item/blade/iron_polearm,
		/obj/item/ingot/steel = /obj/item/blade/steel_polearm,
		/obj/item/ingot/bronze = /obj/item/blade/bronze_polearm
	)

/obj/item/mold/plate
	name = "plate mold"
	desc = "A steel mold for casting armor plates."
	icon_state = "base_plate"
	blade_type = /obj/item/blade/iron_plate
	metal_to_blade = list(
		/obj/item/ingot/iron = /obj/item/blade/iron_plate,
		/obj/item/ingot/steel = /obj/item/blade/steel_plate,
		/obj/item/ingot/bronze = /obj/item/blade/bronze_plate
	)
