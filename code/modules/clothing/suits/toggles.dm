// Hoods for cloaks

/obj/item/clothing
	var/hoodtype
	var/connected_hood
	var/hoodtoggled = FALSE
	var/adjustable = CANT_CADJUST

/obj/item/clothing/attack_right(mob/user)
	. = ..()
	if(adjustable && loc == user)
		AdjustClothes(user)
	if(hoodtype)
		ToggleHood(user)

/obj/item/clothing/proc/AdjustClothes(mob/user)
	return //override this in the clothing item itself so we can update the right inv

/obj/item/clothing/proc/ResetAdjust(mob/user)
	adjustable = initial(adjustable)
	icon_state = "[initial(icon_state)]"
	slowdown = initial(slowdown)
	body_parts_covered = initial(body_parts_covered)
	body_parts_covered_dynamic = body_parts_covered
	flags_inv = initial(flags_inv)
	flags_cover = initial(flags_cover)
	block2add = initial(block2add)

/obj/item/clothing/equipped(mob/user, slot)
	..()
	if(adjustable)
		ResetAdjust(user)

	if(hoodtoggled)
		hoodtoggled = FALSE
		if(toggle_icon_state)
			icon_state = initial(icon_state)

/obj/item/clothing/dropped(mob/user)
	..()
	// Delete any linked hood.
	if(connected_hood) 
		qdel(connected_hood)

	// Reset dropped clothes to base state.
	hoodtoggled = FALSE
	if(toggle_icon_state)
		icon_state = initial(icon_state)

	if(adjustable)
		ResetAdjust()

// Called on the cloak by the linked hood right before it's destroyed.
/obj/item/clothing/proc/RemoveHood()
	hoodtoggled = FALSE
	if(toggle_icon_state)
		icon_state = initial(icon_state)

	// Update the mob's icons
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_wear_suit()
		H.update_inv_cloak()
		H.update_inv_neck()
		H.update_inv_pants()
		H.update_fov_angles()

// Logic for raising and lowering the hood.
/obj/item/clothing/proc/ToggleHood(mob/user)
	if(!ishuman(user) || src.loc != user)
		return

	var/mob/living/carbon/human/H = user
 
	// Hood is already UP, make it go DOWN
	if(hoodtoggled)
		if(connected_hood)
			H.dropItemToGround(connected_hood, force = FALSE, silent = TRUE) // This will call the hood's dropped() proc.
			user.update_fov_angles() //For some reason, the dropped() proc can't find the user.
			return
		else
			RemoveHood() // Correct state if mismatched.

	// Make hood go UP
	var/is_worn_correctly = ((slot_flags & ITEM_SLOT_ARMOR) && H.wear_armor == src) || ((slot_flags & ITEM_SLOT_CLOAK) && H.cloak == src)

	if(!is_worn_correctly)
		to_chat(H, span_warning("I should put [src] on properly first."))
		return

	if(H.head)
		to_chat(H, span_warning("I need to take off my [H.head.name] first."))
		return

	var/obj/item/clothing/head/hooded/new_hood = new hoodtype()
	new_hood.connected_cloak = src
	src.connected_hood = new_hood
	new_hood.color = src.color
	// Copy the cloak's overlays to the new hood.
	for(var/mutable_appearance/O in src.overlays)
		new_hood.add_overlay(O)

	if(H.equip_to_slot_if_possible(new_hood, SLOT_HEAD, qdel_on_fail = TRUE, disable_warning = TRUE, redraw_mob = FALSE))
		hoodtoggled = TRUE

		// redraw_mob = FALSE because we'll do that here.
		if(toggle_icon_state)
			src.icon_state = "[initial(icon_state)]_t"
		
		H.update_inv_wear_suit()
		H.update_inv_cloak()
		H.update_inv_head()
		H.update_fov_angles()


/obj/item/clothing/head/hooded
	var/obj/item/clothing/connected_cloak
	dynamic_hair_suffix = ""
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/hooded/Destroy()
	if(connected_cloak)
		connected_cloak.RemoveHood() // Notify the linked cloak.
		connected_cloak = null
	return ..()

/obj/item/clothing/head/hooded/attack_right(mob/user)
	if(connected_cloak)
		// Ask the linked cloak to run the toggle logic.
		connected_cloak.ToggleHood(user)
	else
		// This is an orphaned hood and should not exist.
		qdel(src)

/obj/item/clothing/head/hooded/equipped(mob/user, slot)
	. = ..()
	user.update_fov_angles()

/obj/item/clothing/head/hooded/dropped(mob/user)
	..()
	user.update_fov_angles()
	// A hood should not physically exist in the world.
	// Destroy() handles notifying the linked cloak.
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/head/hooded/equipped(mob/user, slot)
	..()
	if(slot != SLOT_HEAD)
		qdel(src)

//Toggle exosuits for different aesthetic styles (hoodies, suit jacket buttons, etc)

/obj/item/clothing/suit/toggle/AltClick(mob/user)
	..()
	if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	else
		suit_toggle(user)

/obj/item/clothing/suit/toggle/ui_action_click()
	suit_toggle()

/obj/item/clothing/suit/toggle/proc/suit_toggle()
	set src in usr

	if(!can_use(usr))
		return 0

	to_chat(usr, span_notice("I toggle [src]'s [togglename]."))
	if(src.hoodtoggled)
		src.icon_state = "[initial(icon_state)]"
		src.hoodtoggled = FALSE
	else if(!src.hoodtoggled)
		if(toggle_icon_state)
			src.icon_state = "[initial(icon_state)]_t"
		src.hoodtoggled = TRUE
	usr.update_inv_wear_suit()
	for(var/X in actions)
		var/datum/action/A = X
		A.build_all_button_icons()

/obj/item/clothing/suit/toggle/examine(mob/user)
	. = ..()
	. += "Alt-click on [src] to toggle the [togglename]."
