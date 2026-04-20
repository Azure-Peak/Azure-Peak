/obj/item/clothing/gloves/roguetown
	slot_flags = ITEM_SLOT_GLOVES
	body_parts_covered = HANDS
	body_parts_inherent = HANDS
	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon = 'icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	bloody_icon_state = "bloodyhands"
	sleevetype = "shirt"
	max_heat_protection_temperature = 361
	experimental_inhand = TRUE
	/// Flat unarmed damage bonus (for pure fists / wrestling only)
	var/unarmed_bonus = 0

/obj/item/clothing/gloves/roguetown/get_mechanics_examine(mob/user)
	. = ..()
	if(unarmed_bonus > 0)
		. += span_notice("Unarmed damage bonus: +[unarmed_bonus] (flat, applied after strength scaling).")
