// Thievery Related Supplies. I sure hope this don't go wrong!!!
// Took lockpicks out so it don't get spammed. Get the expensive hairpins instead.

/datum/supply_pack/rogue/bath_rogue
	group = "Roguery"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

// Same as merchant
/datum/supply_pack/rogue/bath_rogue/chains
	name = "Chains"
	cost = 15
	contains = list(
		/obj/item/rope/chain,
		/obj/item/rope/chain,
		/obj/item/rope/chain,
	)

/datum/supply_pack/rogue/bath_rogue/goldpin
	name = "Golden Hairpin"
	cost = 70
	contains = list(/obj/item/lockpick/goldpin)

/datum/supply_pack/rogue/bath_rogue/silverpin
	name = "Silver Hairpin"
	cost = 140
	contains = list(/obj/item/lockpick/goldpin/silver)

/datum/supply_pack/rogue/bath_rogue/smokebomb
	name = "Smoke Bomb"
	cost = 25
	contains = list(
		/obj/item/bomb/smoke,
		/obj/item/bomb/smoke,
		/obj/item/bomb/smoke)

/datum/supply_pack/rogue/bath_rogue/waterarrows
	name = "Water Arrows"
	cost = 20
	contains = list (
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
	)

/datum/supply_pack/rogue/bath_rogue/waterbolts
	name = "Water Bolts"
	cost = 20
	contains = list (
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
	)

/datum/supply_pack/rogue/bath_rogue/quiver
	name = "Empty Quiver"
	cost = 5
	contains = list(/obj/item/quiver)

/datum/supply_pack/rogue/bath_rogue/net
	name = "Net"
	cost = 20
	contains = list(/obj/item/net)

/datum/supply_pack/rogue/bath_rogue/grappler
	name = "Grappler"
	cost = 200
	contains = list(/obj/item/grapplinghook)

/datum/supply_pack/rogue/bath_rogue/climbing_gear
	name = "Climbing Gear"
	cost = 150
	contains = list(/obj/item/clothing/climbing_gear)

// these dont techniiiically count as "roguery" but candles r used in the bathhouse a lot for if a room is 
// busy or whatever. + its cool.
/datum/supply_pack/rogue/bath_rogue/eoran_candles
	name = "Eoran Candles"
	cost = 30 // recipe is super easy. 
	contains = list(/obj/item/candle/eora, /obj/item/candle/eora, /obj/item/candle/eora)
