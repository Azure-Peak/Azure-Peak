/obj/item/earring
	abstract_type = /obj/item/earring
	name = "earring"
	desc = "Stylish ear ornament."
	icon = 'icons/obj/items/clothes/earrings.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/earrings.dmi'
	icon_state = "stud"
	item_state = "stud"
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CAN_BE_HIT
	max_integrity = 200
	integrity_failure = 0
	slot_flags = NONE
	extra_slot_flags = EXTRA_SLOT_EARRING_L | EXTRA_SLOT_EARRING_R
	gendered = FALSE
	var/base_icon = "stud"

/obj/item/earring/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, female = FALSE, customi = null, sleeveindex, boobed_overlay = FALSE, icon/clip_mask = null, breast_size = null)
	if(default_layer == EARRING_L_LAYER)
		override_state = base_icon + "_l"
	else if(default_layer == EARRING_R_LAYER)
		override_state = base_icon + "_r"
	. = ..()

/obj/item/earring/dropped(mob/user)
	icon_state = base_icon
	. = ..()

/obj/item/earring/stud
	abstract_type = /obj/item/earring/stud
	name = "stud earring"

/obj/item/earring/silver
	name = "silver earring"
	icon_state = "silver"
	item_state = "silver"
	base_icon = "silver"

/obj/item/earring/gold
	name = "gold earring"
	icon_state = "gold"
	item_state = "gold"
	base_icon = "gold"

/obj/item/earring/hoop
	abstract_type = /obj/item/earring/hoop
	icon_state = "hoop_silver"
	item_state = "hoop_silver"
	base_icon = "hoop_silver"

/obj/item/earring/hoop/silver
	name = "silver hoop earring"

/obj/item/earring/hoop/gold
	name = "gold hoop earring"
	icon_state = "hoop_gold"
	item_state = "hoop_gold"
	base_icon = "hoop_gold"

/obj/item/earring/stud/silver
	name = "silver stud earring"
	color = "#d1e6e3"

/obj/item/earring/stud/gold
	name = "gold stud earring"
	color = "#edd12f"

/obj/item/earring/dangle
	abstract_type = /obj/item/earring/dangle
	name = "dangling earring"
	icon_state = "dangle"
	item_state = "dangle"
	base_icon = "dangle"

/obj/item/earring/dangle/silver
	name = "silver dangling earring"
	color = "#d1e6e3"

/obj/item/earring/dangle/gold
	name = "gold dangling earring"
	color = "#edd12f"

/obj/item/storage/belt/pouch/earrings/stud_silver
	populate_contents = list(
		/obj/item/earring/stud/silver,
		/obj/item/earring/stud/silver,
	)

/obj/item/storage/belt/pouch/earrings/stud_gold
	populate_contents = list(
		/obj/item/earring/stud/gold,
		/obj/item/earring/stud/gold,
	)

/obj/item/storage/belt/pouch/earrings/dangle_silver
	populate_contents = list(
		/obj/item/earring/dangle/silver,
		/obj/item/earring/dangle/silver,
	)

/obj/item/storage/belt/pouch/earrings/dangle_gold
	populate_contents = list(
		/obj/item/earring/dangle/gold,
		/obj/item/earring/dangle/gold,
	)
