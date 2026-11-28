/obj/structure/closet/crate/chest/steward
	lockid = "steward"
	locked = TRUE
	masterkey = TRUE

/datum/crown_import/keyringsset
	name = "Man-At-Arms Keyring Set Crate"
	desc = "A set of keys for new hires."
	item_type = /obj/structure/closet/crate/chest/steward/keyringsset
	base_cost = 100

/obj/structure/closet/crate/chest/steward/keyringsset/Initialize(mapload)
	. = ..()
	new /obj/item/storage/keyring/manatarms(src)
	new /obj/item/storage/keyring/manatarms(src)
	new /obj/item/storage/keyring/manatarms(src)
	new /obj/item/storage/keyring/manatarms(src)
