/obj/item/earring
	name = "stud earring"
	desc = "Stylish ear ornament."
	icon = 'icons/obj/items/clothes/earrings.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/earrings.dmi'
	icon_state = "ear_stud"
	item_state = "ear_stud"
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CAN_BE_HIT
	max_integrity = 200
	integrity_failure = 0
	slot_flags = SLOT_EARRING_L | SLOT_EARRING_R
	gendered = FALSE
	var/base_icon = "ear_stud"

/obj/item/earring/build_worn_icon(age = AGE_ADULT, default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, female, customi, sleeveindex, breast_size = 0, boobed_overlay = FALSE, clip_mask = null)
	icon_state = base_icon
	if(default_layer == EARRING_L_LAYER)
		icon_state = base_icon + "_l"
	else if (default_layer == EARRING_R_LAYER)
		icon_state = base_icon + "_r"
	. = ..()

/obj/item/earring/dropped(mob/user)
	icon_state = base_icon
	. = ..()

/obj/item/earring/glass
	name = "glass stud earring"
	color = "#00e1ff"

/obj/item/earring/wood
	name = "wood stud earring"
	color = "#824b28"

/obj/item/earring/iron
	name = "iron stud earring"
	color = "#5c5454"

/obj/item/earring/steel
	name = "steel stud earring"
	color = "#666666"

/obj/item/earring/silver
	name = "silver stud earring"
	color = "#d1e6e3"

/obj/item/earring/gold
	name = "gold stud earring"
	color = "#edd12f"

/obj/item/earring/platinum
	name = "platinum stud earring"
	color = "#9999ff"

/obj/item/earring/onyx
	name = "onyx stud earring"
	color = "#070d23"

/obj/item/earring/emerald
	name = "emerald stud earring"
	color = "#23a230"

/obj/item/earring/amber
	name = "amber stud earring"
	color = "#da5806"

/obj/item/earring/amethyst
	name = "amethyst stud earring"
	color = "#8332f9"

/obj/item/earring/ruby
	name = "ruby stud earring"
	color = "#e53232"

/obj/item/earring/sapphire
	name = "sapphire stud earring"
	color = "#228ded"

/obj/item/earring/diamond
	name = "diamond stud earring"
	color = "#00ffe1"

/obj/item/earring/dangle
	name = "dangle earring"
	icon_state = "ear_dangle"
	item_state = "ear_dangle"
	base_icon = "ear_dangle"

/obj/item/earring/dangle/glass
	name = "glass dangle earring"
	color = "#00e1ff"

/obj/item/earring/dangle/wood
	name = "wood dangle earring"
	color = "#824b28"

/obj/item/earring/dangle/iron
	name = "iron dangle earring"
	color = "#5c5454"

/obj/item/earring/dangle/steel
	name = "steel dangle earring"
	color = "#666666"

/obj/item/earring/dangle/silver
	name = "silver dangle earring"
	color = "#d1e6e3"

/obj/item/earring/dangle/gold
	name = "gold dangle earring"
	color = "#edd12f"

/obj/item/earring/dangle/platinum
	name = "platinum dangle earring"
	color = "#9999ff"

/obj/item/earring/dangle/onyx
	name = "onyx dangle earring"
	color = "#070d23"

/obj/item/earring/dangle/emerald
	name = "emerald dangle earring"
	color = "#23a230"

/obj/item/earring/dangle/amber
	name = "amber dangle earring"
	color = "#da5806"

/obj/item/earring/dangle/amethyst
	name = "amethyst dangle earring"
	color = "#8332f9"

/obj/item/earring/dangle/ruby
	name = "ruby dangle earring"
	color = "#e53232"

/obj/item/earring/dangle/sapphire
	name = "sapphire dangle earring"
	color = "#228ded"

/obj/item/earring/dangle/diamond
	name = "diamond dangle earring"
	color = "#00ffe1"

/obj/item/storage/belt/pouch/earrings/stud_silver/Initialize()
	. = ..()
	var/obj/item/earring/silver/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/earring/silver/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/pouch/earrings/stud_glass/Initialize()
	. = ..()
	var/obj/item/earring/glass/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/earring/glass/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/pouch/earrings/stud_gold/Initialize()
	. = ..()
	var/obj/item/earring/gold/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/earring/gold/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/pouch/earrings/dangle_silver/Initialize()
	. = ..()
	var/obj/item/earring/dangle/silver/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/earring/silver/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/pouch/earrings/dangle_glass/Initialize()
	. = ..()
	var/obj/item/earring/dangle/glass/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/earring/dangle/glass/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/pouch/earrings/dangle_gold/Initialize()
	. = ..()
	var/obj/item/earring/dangle/gold/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/earring/dangle/gold/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)