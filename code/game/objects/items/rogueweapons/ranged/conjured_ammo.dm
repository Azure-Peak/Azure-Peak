/obj/item/quiver/bolt/conjured
	name = "phantasmal quiver"
	desc = "A shimmering quiver of conjured bolts."
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/ferramancy

/obj/item/quiver/bolt/conjured/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/ferramancy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/conjured
	name = "phantasmal quiver"
	desc = "A shimmering quiver of conjured arrows."
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron/ferramancy

/obj/item/quiver/conjured/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/iron/ferramancy/A = new()
		arrows += A
	update_icon()
