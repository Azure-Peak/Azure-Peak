/datum/hag_boon/item/wyrd_cross
	name = "Wyrd Cross"
	desc = "A cross that can take the shape of any other via right click, it can inject a healing tonic into the user once on middle click."
	points = 20

/obj/item/clothing/neck/roguetown/psicross/hag
	name = "Wyrd Cross"
	desc = "I can't really pin down what this is supposed to be. The silhouette's edges wave and warp whilst I look at it."
	icon_state = "wyrd_cross"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	/// What cross we're mimicking.
	var/mimic_type = null
	var/static/list/hag_radial_choices
	var/static/list/hag_path_map

/obj/item/clothing/neck/roguetown/psicross/hag/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/hag_magical_item, /datum/hag_boon/item/wyrd_cross)

/obj/item/clothing/neck/roguetown/psicross/hag/attack_self(mob/user)
	. = ..()
	if(can_use_wyrd_power(user, TRUE))
		change_shape(user)

/obj/item/clothing/neck/roguetown/psicross/hag/proc/setup_radial_cache()
	// If the cache is already built, stop here.
	if(hag_radial_choices && hag_path_map)
		return

	hag_radial_choices = list()
	hag_path_map = list()

	hag_radial_choices["Wyrd Form"] = image('icons/roguetown/items/hag/hag_items.dmi', "wyrd_cross")

	var/list/valid_types = typesof(/obj/item/clothing/neck/roguetown/psicross)
	for(var/path in valid_types)
		// Skip self
		if(path == /obj/item/clothing/neck/roguetown/psicross/hag)
			continue

		var/obj/item/clothing/neck/roguetown/psicross/C = path
		var/c_name = initial(C.name)

		// Generate the radial icon image and map the name to the typepath
		hag_radial_choices[c_name] = image(initial(C.icon), initial(C.icon_state))
		hag_path_map[c_name] = path

/obj/item/clothing/neck/roguetown/psicross/hag/proc/change_shape(mob/user)
	// Build the cache if it hasn't been built this round yet
	setup_radial_cache()

	var/selection = show_radial_menu(user, src, hag_radial_choices)
	if(!selection)
		return

	if(selection == "Wyrd Form")
		mimic_type = null
		name = initial(name)
		desc = initial(desc)
		icon = initial(icon)
		icon_state = initial(icon_state)
		mob_overlay_icon = initial(mob_overlay_icon)
		slot_flags = initial(slot_flags)
		to_chat(user, span_notice("The cross warps back into its indecipherable, shifting form."))
	else
		var/target_path = hag_path_map[selection]
		mimic_type = target_path

		// Cast the path to a variable so we can safely pull 'initial' values
		var/obj/item/clothing/neck/roguetown/psicross/C = target_path

		// Visual Inheritance
		name = initial(C.name)
		desc = initial(C.desc)
		icon = initial(C.icon)
		icon_state = initial(C.icon_state)
		mob_overlay_icon = initial(C.mob_overlay_icon)

		// Mechanical Inheritance
		src.sellprice = initial(C.sellprice)
		src.resistance_flags = initial(C.resistance_flags)
		src.overarmor = initial(C.overarmor)
		src.slot_flags = initial(C.slot_flags)
		// I'm not implementing this yet for brevity.
		src.wrist_display = initial(C.wrist_display)
		
		to_chat(user, span_notice("The strange cross shudders, mimicking the weight and presence of \a [name]."))

	// Ensure the floor and in-hand sprites update
	update_icon()

	if(isliving(loc))
		var/mob/living/L = loc
		L.regenerate_clothes()

/obj/item/clothing/neck/roguetown/psicross/hag/update_icon()
	. = ..()
	if(mimic_type)
		// If we are mimicking, FORCE the appearance to stay as the mimic
		var/obj/item/clothing/neck/roguetown/psicross/C = mimic_type
		icon = initial(C.icon)
		icon_state = initial(C.icon_state)
		name = initial(C.name)
		return

/obj/item/clothing/neck/roguetown/psicross/hag/dropped(mob/user)
	. = ..()
	if(mimic_type)
		// Ensure the ground sprite is correct immediately upon dropping
		var/obj/item/clothing/neck/roguetown/psicross/C = mimic_type
		icon = initial(C.icon)
		icon_state = initial(C.icon_state)

/obj/item/clothing/neck/roguetown/psicross/hag/proc/can_use_wyrd_power(mob/living/user, hag_allowed)
	if(hag_allowed && HAS_TRAIT(user, TRAIT_ANCIENT_HAG))
		return TRUE

	var/datum/component/hag_magical_item_affinity/Keychain = user.GetComponent(/datum/component/hag_magical_item_affinity)
	if(Keychain && (initial(name) in Keychain.authorized_ids))
		return TRUE

	return FALSE
