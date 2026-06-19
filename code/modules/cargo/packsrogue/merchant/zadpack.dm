/datum/supply_pack/rogue/zadpack
	group = "Zadpacks"
	crate_name = "trained zad crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/zadpack/merchant
	name = "Pack of Trained Zads"
	cost = ZADPACK_PRICE_MERCHANT
	contains = list(/obj/item/zadpack)
	not_in_public = TRUE

/datum/supply_pack/rogue/zadpack/bathhouse
	name = "Discreet Zad Pack"
	group = "Discreet Zads"
	cost = ZADPACK_PRICE_BATHHOUSE
	contains = list(/obj/item/zadpack)
	contraband = TRUE

/datum/supply_pack/rogue/zadpack/cheap_bombs
	name = "Bottle Bomb (Bulk)"
	cost = 35
	contains = list(
		/obj/item/bomb,
		/obj/item/bomb,
		/obj/item/bomb,
		/obj/item/bomb,
		/obj/item/bomb,
	)
	not_in_public = TRUE

/datum/supply_pack/rogue/zadpack/new_cage
	name = "Spare Zadcage"
	cost = ZADCOTE_NEW_CAGE_COST_MAMMON
	contains = list(/obj/item/zadcage)
	not_in_public = TRUE

/datum/supply_pack/rogue/zadpack/new_cage_bathhouse
	name = "Discreet Zadcage"
	group = "Discreet Zads"
	cost = ZADCOTE_NEW_CAGE_COST_MAMMON
	contains = list(/obj/item/zadcage)
	contraband = TRUE

/datum/crown_import/zad_pack
	name = "Pack of Court Zads"
	desc = "A trained flock of carrier zads, raised at the Crown's expense. Strike the pack against a zadcote to restock its reserve."
	item_type = /obj/item/zadpack
	base_cost = ZADPACK_PRICE_STEWARD

/datum/crown_import/zad_cage
	name = "Spare Zadcage"
	desc = "A spare wicker cage bonded to no zadcote yet. Strike it against any zadcote your faction operates to claim a slot."
	item_type = /obj/item/zadcage
	base_cost = ZADCOTE_NEW_CAGE_COST_MAMMON

/obj/item/zadpack
	name = "pack of trained zads"
	desc = "A small crate of zads, well-trained and well-fed, ready for the cote. Strike it on a zadcote to restock the reserve."
	icon = 'icons/roguetown/clothing/storage.dmi'
	icon_state = "deliverypackage3"
	item_state = "deliverypackage"
	w_class = WEIGHT_CLASS_NORMAL
	var/bundle_size = ZADPACK_BUNDLE_SIZE

/obj/item/zadpack/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return ..()
	if(!istype(target, /obj/item/roguemachine/zadcote))
		return ..()
	var/obj/item/roguemachine/zadcote/cote = target
	if(!cote.can_restock(user))
		to_chat(user, span_warning("Only the zadcote's owners may restock it."))
		return
	cote.restock(bundle_size)
	to_chat(user, span_notice("The zadcote chirps as [bundle_size] fresh zads join the reserve."))
	playsound(cote.loc, 'sound/misc/hiss.ogg', 50, FALSE, -1)
	qdel(src)
