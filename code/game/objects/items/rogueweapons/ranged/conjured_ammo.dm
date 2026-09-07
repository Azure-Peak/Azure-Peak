/obj/item/ammo_casing/caseless/rogue/bolt/conjured
	name = "phantasmal bolt"
	color = GLOW_COLOR_ARCANE
	projectile_type = /obj/projectile/bullet/reusable/bolt/conjured

/obj/projectile/bullet/reusable/bolt/conjured
	color = GLOW_COLOR_ARCANE
	trains_ranged_skill = FALSE

/obj/projectile/bullet/reusable/bolt/conjured/on_hit()
	. = ..()
	QDEL_NULL(dropped)

/obj/projectile/bullet/reusable/bolt/conjured/handle_drop()
	QDEL_NULL(dropped)
	return

/obj/item/ammo_casing/caseless/rogue/arrow/iron/conjured
	name = "phantasmal arrow"
	color = GLOW_COLOR_ARCANE
	projectile_type = /obj/projectile/bullet/reusable/arrow/iron/conjured

/obj/projectile/bullet/reusable/arrow/iron/conjured
	color = GLOW_COLOR_ARCANE
	trains_ranged_skill = FALSE

/obj/projectile/bullet/reusable/arrow/iron/conjured/on_hit()
	. = ..()
	QDEL_NULL(dropped)

/obj/projectile/bullet/reusable/arrow/iron/conjured/handle_drop()
	QDEL_NULL(dropped)
	return

/obj/item/quiver/bolt/conjured
	name = "phantasmal quiver"
	desc = "A shimmering quiver of conjured bolts."
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/conjured

/obj/item/quiver/bolt/conjured/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/conjured/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/conjured
	name = "phantasmal quiver"
	desc = "A shimmering quiver of conjured arrows."
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron/conjured

/obj/item/quiver/conjured/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/iron/conjured/A = new()
		arrows += A
	update_icon()

/obj/item/ammo_casing/caseless/rogue/arrow/stone/conjured
	name = "phantasmal stone arrow"
	color = GLOW_COLOR_ARCANE
	projectile_type = /obj/projectile/bullet/reusable/arrow/stone/conjured

/obj/projectile/bullet/reusable/arrow/stone/conjured
	color = GLOW_COLOR_ARCANE
	trains_ranged_skill = FALSE

/obj/projectile/bullet/reusable/arrow/stone/conjured/on_hit()
	. = ..()
	QDEL_NULL(dropped)

/obj/projectile/bullet/reusable/arrow/stone/conjured/handle_drop()
	QDEL_NULL(dropped)
	return

/obj/item/quiver/conjured_stone
	name = "phantasmal quiver"
	desc = "A shimmering quiver of conjured stone arrows."
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone/conjured

/obj/item/quiver/conjured_stone/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/stone/conjured/A = new()
		arrows += A
	update_icon()
