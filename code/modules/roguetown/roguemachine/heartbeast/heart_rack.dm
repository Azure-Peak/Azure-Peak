/obj/structure/stone_rack
	name = "Aspect rack"
	desc = "A specialized holder designed to securely hold chimeric aspect canisters. The crystal reinforces the creature's personality, increases it's thinking capacity. The brighter the red glow of the crystal, the better the aspects match the creature."
	icon = 'icons/obj/structures/heart_rack.dmi'
	icon_state = "rack"
	var/datum/component/chimeric_heart_beast/heart_component
	pixel_y = 32
	resistance_flags = INDESTRUCTIBLE

	var/list/obj/item/heart_canister/slots = list(null, null, null, null, null, null) // 6 slots
	var/list/slot_types = list("archetype", "trait", "trait", "quirk", "quirk", "quirk") // Fixed slot types
	var/tech_multiplier = 1.0
	var/crystal_intensity = 0

/obj/structure/stone_rack/update_icon()
	. = ..()
	cut_overlays()

	// Add fluid overlays for filled canisters only
	for(var/i in 1 to 6)
		var/obj/item/heart_canister/canister = slots[i]
		if(canister && canister.filled)
			var/mutable_appearance/fluid_overlay = mutable_appearance('icons/obj/structures/heart_rack.dmi', "fluid_[i]")
			fluid_overlay.color = canister.current_color
			add_overlay(fluid_overlay)
		else if(canister && canister.broken)
			var/mutable_appearance/broken_canister = mutable_appearance('icons/obj/structures/heart_rack.dmi', "broken_[i]")
			add_overlay(broken_canister)

	if(crystal_intensity)
		var/mutable_appearance/crystal_glow = mutable_appearance('icons/obj/structures/heart_rack.dmi', "crystal")
		crystal_glow.alpha = (crystal_intensity * 255)
		add_overlay(crystal_glow)

/obj/structure/stone_rack/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/heart_canister))
		var/obj/item/heart_canister/canister = I

		if(!canister.filled)
			to_chat(user, span_warning("The canister needs to be filled first!"))
			return TRUE

		if(has_duplicate_aspect(canister.aspect_datum_ref))
			to_chat(user, span_warning("A canister with that exact aspect is already in the rack!"))
			return TRUE

		// Determine what type of aspect this canister holds
		var/canister_type
		if(istype(canister.aspect_datum_ref, /datum/flesh_archetype))
			canister_type = "archetype"
		else if(istype(canister.aspect_datum_ref, /datum/flesh_trait))
			canister_type = "trait"
		else if(istype(canister.aspect_datum_ref, /datum/flesh_quirk))
			canister_type = "quirk"
		else
			to_chat(user, span_warning("This canister doesn't seem to hold a valid aspect."))
			return TRUE

		// Find empty slot of the right type
		var/slot_number
		for(var/i in 1 to 6)
			if(slot_types[i] == canister_type && !slots[i])
				slot_number = i
				break

		if(!slot_number)
			to_chat(user, span_warning("No available [canister_type] slots in the rack."))
			return TRUE

		// Insert the canister
		if(user.transferItemToLoc(canister, src))
			slots[slot_number] = canister
			canister.forceMove(src)
			canister.parent_rack = src
			to_chat(user, span_notice("You place the [canister.name] into the rack."))
			update_icon()
			return TRUE

	return ..()

/obj/structure/stone_rack/proc/has_duplicate_aspect(datum/aspect_datum)
	// Checks if the given aspect datum is already present in a canister in the rack
	if(!aspect_datum)
		return FALSE

	for(var/obj/item/heart_canister/canister in slots)
		if(canister && canister.aspect_datum_ref == aspect_datum)
			return TRUE
	return FALSE

/obj/structure/stone_rack/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	// Show slot selection menu for removal
	var/list/options = list()
	for(var/i in 1 to 6)
		var/obj/item/heart_canister/canister = slots[i]
		if(canister)
			options["Remove [canister.name]"] = i
	
	if(!options.len)
		to_chat(user, span_warning("The rack is empty."))
		return

	options["Cancel"] = 0

	var/choice = input(user, "Select a canister to remove:", "Rack Contents") as null|anything in options
	if(!choice || choice == "Cancel")
		return

	var/slot_number = options[choice]
	if(slot_number == 0)
		return

	var/obj/item/heart_canister/canister = slots[slot_number]
	if(canister && user.put_in_hands(canister))
		slots[slot_number] = null
		to_chat(user, span_notice("You remove the [canister.name] from the rack."))
		canister.parent_rack = null
		update_icon()

/obj/structure/stone_rack/examine(mob/user)
	. = ..()

	var/has_canisters = FALSE
	for(var/i in 1 to 6)
		var/obj/item/heart_canister/canister = slots[i]
		if(canister)
			if(!has_canisters)
				. += span_notice("It contains:")
				has_canisters = TRUE
			. += span_notice("- [canister.name] in the [slot_types[i]] slot")
		else
			. += span_notice("- an empty void in the [slot_types[i]] slot")

	if(!has_canisters)
		. += span_notice("All slots are empty.")

/obj/structure/stone_rack/proc/advance_calibration()
	for(var/obj/item/heart_canister/canister in slots)
		if(!canister.broken)
			canister.advance_calibration()
	update_icon()

/obj/structure/stone_rack/proc/update_rack_stats()
	if(!heart_component)
		return

	var/calibrated_count
	var/total_penalty = 0

	for(var/i in 1 to 6)
		var/obj/item/heart_canister/canister = slots[i]
		// A SINGLE broken canister or missing canister spoils the bunch
		if(canister && canister.broken)
			total_penalty = 1
			break
		if(!canister)
			total_penalty = 1
			break
		if(canister.calibrated)
			calibrated_count++
		else
			if(istype(canister.aspect_datum_ref, /datum/flesh_archetype))
				total_penalty += 0.35
			else if(istype(canister.aspect_datum_ref, /datum/flesh_trait))
				total_penalty += 0.15
			else if(istype(canister.aspect_datum_ref, /datum/flesh_quirk))
				total_penalty += 0.10

	crystal_intensity = calibrated_count / 6
	tech_multiplier = 1 - total_penalty
	return tech_multiplier
