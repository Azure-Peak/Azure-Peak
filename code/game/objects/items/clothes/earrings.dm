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

/obj/item/earring/stud/glass
	name = "glass stud earring"
	color = "#00e1ff"

/obj/item/earring/stud/wood
	name = "wood stud earring"
	color = "#824b28"

/obj/item/earring/stud/iron
	name = "iron stud earring"
	color = "#5c5454"

/obj/item/earring/stud/steel
	name = "steel stud earring"
	color = "#666666"

/obj/item/earring/stud/silver
	name = "silver stud earring"
	color = "#d1e6e3"

/obj/item/earring/stud/gold
	name = "gold stud earring"
	color = "#edd12f"

/obj/item/earring/stud/platinum
	name = "platinum stud earring"
	color = "#9999ff"

/obj/item/earring/stud/onyx
	name = "onyx stud earring"
	color = "#070d23"

/obj/item/earring/stud/emerald
	name = "emerald stud earring"
	color = "#23a230"

/obj/item/earring/stud/amber
	name = "amber stud earring"
	color = "#da5806"

/obj/item/earring/stud/amethyst
	name = "amethyst stud earring"
	color = "#8332f9"

/obj/item/earring/stud/ruby
	name = "ruby stud earring"
	color = "#e53232"

/obj/item/earring/stud/sapphire
	name = "sapphire stud earring"
	color = "#228ded"

/obj/item/earring/stud/diamond
	name = "diamond stud earring"
	color = "#00ffe1"

/obj/item/earring/dangle
	name = "dangling earring"
	icon_state = "dangle"
	item_state = "dangle"
	base_icon = "dangle"

/obj/item/earring/dangle/glass
	name = "glass dangling earring"
	color = "#00e1ff"

/obj/item/earring/dangle/wood
	name = "wood dangling earring"
	color = "#824b28"

/obj/item/earring/dangle/iron
	name = "iron dangling earring"
	color = "#5c5454"

/obj/item/earring/dangle/steel
	name = "steel dangling earring"
	color = "#666666"

/obj/item/earring/dangle/silver
	name = "silver dangling earring"
	color = "#d1e6e3"

/obj/item/earring/dangle/gold
	name = "gold dangling earring"
	color = "#edd12f"

/obj/item/earring/dangle/platinum
	name = "platinum dangling earring"
	color = "#9999ff"

/obj/item/earring/dangle/onyx
	name = "onyx dangling earring"
	color = "#070d23"

/obj/item/earring/dangle/emerald
	name = "emerald dangling earring"
	color = "#23a230"

/obj/item/earring/dangle/amber
	name = "amber dangling earring"
	color = "#da5806"

/obj/item/earring/dangle/amethyst
	name = "amethyst dangling earring"
	color = "#8332f9"

/obj/item/earring/dangle/ruby
	name = "ruby dangling earring"
	color = "#e53232"

/obj/item/earring/dangle/sapphire
	name = "sapphire dangling earring"
	color = "#228ded"

/obj/item/earring/dangle/diamond
	name = "diamond dangling earring"
	color = "#00ffe1"

/obj/item/storage/belt/pouch/earrings/stud_silver/Initialize()
	. = ..()
	var/obj/item/earring/stud/silver/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/earring/stud/silver/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/pouch/earrings/stud_glass/Initialize()
	. = ..()
	var/obj/item/earring/stud/glass/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/earring/stud/glass/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/pouch/earrings/stud_gold/Initialize()
	. = ..()
	var/obj/item/earring/stud/gold/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/earring/stud/gold/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/pouch/earrings/dangle_silver/Initialize()
	. = ..()
	var/obj/item/earring/dangle/silver/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/earring/dangle/silver/C = new(loc)
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
