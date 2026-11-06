/obj/item/earrings
	name = "gold earrings"
	gender = PLURAL
	desc = "A pair of stylish ear ornaments."
	icon = 'icons/obj/items/clothes/earrings.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/earrings.dmi'
	icon_state = "gold"
	item_state = "gold"
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CAN_BE_HIT
	max_integrity = 200
	integrity_failure = 0
	slot_flags = NONE
	extra_slot_flags = EXTRA_SLOT_EARRINGS
	gendered = FALSE
	// Render above hair, while retaining the dedicated integer overlay cache index.
	alternate_worn_layer = CUSTOM_HAIR_ABOVE_SNOUT_LAYER - 0.1

/obj/item/earrings/silver
	name = "silver earrings"
	icon_state = "silver"
	item_state = "silver"

/obj/item/earrings/hoop
	name = "gold hoop earrings"
	icon_state = "hoop_gold"
	item_state = "hoop_gold"

/obj/item/earrings/hoop/silver
	name = "silver hoop earrings"
	icon_state = "hoop_silver"
	item_state = "hoop_silver"

/obj/item/earrings/stud
	name = "gold stud earrings"
	icon_state = "stud"
	item_state = "stud"
	color = "#edd12f"

/obj/item/earrings/stud/silver
	name = "silver stud earrings"
	color = "#d1e6e3"

/obj/item/earrings/dangle
	name = "gold dangling earrings"
	icon_state = "dangle"
	item_state = "dangle"
	color = "#edd12f"

/obj/item/earrings/dangle/silver
	name = "silver dangling earrings"
	color = "#d1e6e3"

/obj/item/storage/belt/pouch/earrings/stud_silver
	populate_contents = list(/obj/item/earrings/stud/silver)

/obj/item/storage/belt/pouch/earrings/stud_gold
	populate_contents = list(/obj/item/earrings/stud)

/obj/item/storage/belt/pouch/earrings/dangle_silver
	populate_contents = list(/obj/item/earrings/dangle/silver)

/obj/item/storage/belt/pouch/earrings/dangle_gold
	populate_contents = list(/obj/item/earrings/dangle)
