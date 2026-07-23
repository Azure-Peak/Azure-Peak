// I can't believe we didn't have the ability to stock up on, you know, bathing equipment before? Anyway the new alchemical stuff goes here
/datum/supply_pack/rogue/bath_supplies
	group = "Bath Supplies"
	crate_name = "bathing supplies crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/bath_supplies/bathbomb
	name = "Herbal Diffuser (Salvia)"
	cost = 10
	contains = list(/obj/item/alchemical_bathbomb)

/datum/supply_pack/rogue/bath_supplies/rosabathbomb
	name = "Floral Diffuser (Rosa)"
	cost = 10
	contains = list(/obj/item/alchemical_bathbomb/rosa)

/datum/supply_pack/rogue/bath_supplies/herbalsoap // this one has no mechanical effects
	name = "Herbal Soap (3x)"
	cost = 15
	contains = list(
		/obj/item/soap/bath,
		/obj/item/soap/bath,
		/obj/item/soap/bath,
	)

/datum/supply_pack/rogue/bath_supplies/eorasoap
	name = "Restorative Soap (3x)" // weak healing soap; merchant sells health pots, you get soap
	cost = 30
	contains = list(
		/obj/item/soap/alch,
		/obj/item/soap/alch,
		/obj/item/soap/alch
	)
