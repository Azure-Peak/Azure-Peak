/obj/item/clothing/head/roguetown
	name = "hat"
	desc = ""
	icon = 'icons/roguetown/clothing/head.dmi'
	icon_state = "top_hat"
	item_state = "that"
	body_parts_covered = HEAD|HAIR
	body_parts_inherent = HEAD
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	dynamic_hair_suffix = "+generic"
	bloody_icon_state = "helmetblood"
	experimental_onhip = FALSE
	/// Override if we want to always respect our inv flags if the helm is in a mask slot.
	var/mask_override = FALSE
	experimental_inhand = FALSE
	var/hidesnoutADJ = FALSE
	/// Tracks if we're currently over or under the armor layer. Mainly used for the feedback message.
	var/overarmor = TRUE

/obj/item/clothing/head/roguetown/equipped(mob/user, slot)
	. = ..()
	user.update_fov_angles()
	if(slot != SLOT_HEAD && !mask_override)
		flags_inv = null
	else
		flags_inv = initial(flags_inv)

/obj/item/clothing/head/roguetown/dropped(mob/user)
	. = ..()
	user.update_fov_angles()
