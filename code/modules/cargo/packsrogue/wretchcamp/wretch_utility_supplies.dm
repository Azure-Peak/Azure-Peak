/datum/supply_pack/rogue/medical_utility_wretch
	group = "Illict Utility Supplies"
	crate_name = "suspicious crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/medical_utility_wretch/smokebomb
	name = "Smoke Bomb III Pack"
	cost =	20
	contains = list(
					/obj/item/bomb/smoke,
					/obj/item/bomb/smoke,
					/obj/item/bomb/smoke
				)

/datum/supply_pack/rogue/medical_utility_wretch/bottlebombs
	name = "Bottle Bomb V Pack"
	cost = 35
	contains = list(
					/obj/item/bomb,
					/obj/item/bomb,
					/obj/item/bomb,
					/obj/item/bomb,
					/obj/item/bomb
				)

/datum/supply_pack/rogue/medical_utility_wretch/lockpicks
	name = "Ring of Lockpicks, III"
	cost = 15 //Cheaper, because Matthiosian miracles exist
	contains = list(/obj/item/lockpickring/mundane)

/datum/supply_pack/rogue/medical_utility_wretch/grapplinghook
	name =	"Grappling Hook"
	cost =	200 //Still extremely expensive compared to artificer but considering you need a virtue/soft antagonist to lead you here. IDC anymore.
	contains = list(/obj/item/grapplinghook)

//Technically medical but this bloats up the catagory less (artificer is still tenfold cheaper for these)

/datum/supply_pack/rogue/medical_utility_wretch/prarmlbrz
	name = "Prostethic Bronze Arm (L)"
	cost = 120
	contains = list(/obj/item/bodypart/l_arm/prosthetic/bronzeleft)

/datum/supply_pack/rogue/medical_utility_wretch/prarmrbrz
	name = "Prostethic Bronze Arm (R)"
	cost = 120
	contains = list(/obj/item/bodypart/r_arm/prosthetic/bronzeright)

/datum/supply_pack/rogue/medical_utility_wretch/prleglbrz
	name = "Prostethic Bronze Leg (L)"
	cost = 80
	contains = list(/obj/item/bodypart/l_leg/prosthetic/bronzeleft)

/datum/supply_pack/rogue/medical_utility_wretch/prlegrbrz
	name = "Prostethic Bronze Leg (R)"
	cost = 80
	contains = list(/obj/item/bodypart/r_leg/prosthetic/bronzeright)
