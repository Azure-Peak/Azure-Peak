// Light Armor Pack. Only includes the "highest tier" plus a special package of budget armor.
// Pricing principles - Based on uhh sell price x 1.5 approx lol.

/datum/supply_pack/rogue/light_armor
	group = "Armor (Light)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/light_armor/padded_gambeson
	name = "Padded Gambeson"
	cost = 60 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)

/datum/supply_pack/rogue/light_armor/leather_gorget
	name = "Leather Gorget"
	cost = 30 // Base sellprice of 10
	contains = list(/obj/item/clothing/neck/roguetown/leather)

/datum/supply_pack/rogue/light_armor/leather_bracers
	name = "Hardened Leather Bracers"
	cost = 30 // Base sellprice of 10
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/leather/heavy)

/datum/supply_pack/rogue/light_armor/heavy_leather_pants
	name = "Hardened Leather Pants"
	cost = 40 // Base sellprice of 20
	contains = list(/obj/item/clothing/under/roguetown/heavy_leather_pants)

/datum/supply_pack/rogue/light_armor/hide_armor
	name = "Hide Armor"
	cost = 35 // Base sellprice of 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/hide)

/datum/supply_pack/rogue/light_armor/heavy_leather_armor
	name = "Hardened Leather Armor"
	cost = 40 // Base sellprice of 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy)

/datum/supply_pack/rogue/light_armor/studded_leather_armor
	name = "Studded Leather Armor"
	cost = 45 // I added 5 to the base sellprice of 25 because it cost 1 ingot
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/studded)

/datum/supply_pack/rogue/light_armor/studded_leather_cuirass
	name = "Studded Leather Cuirass, 'Cuir-Bouilli'-Style"
	cost = 45
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli)

/datum/supply_pack/rogue/light_armor/heavy_leather_coat
	name = "Hardened Leather Coat"
	cost = 40 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat)

/datum/supply_pack/rogue/light_armor/heavy_leather_jacket
	name = "Hardened Leather Jacket"
	cost = 40 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket)

/datum/supply_pack/rogue/light_armor/heavy_leather_gloves
	name = "Heavy Leather Gloves"
	cost = 20 // No one buying this lmao it costs 1 fur
	contains = list(/obj/item/clothing/gloves/roguetown/angle)

/datum/supply_pack/rogue/light_armor/heavy_padded_coif
	name = "Heavy Padded Coif"
	cost = 45 // Equivalent to a padded gambeson on the head, so pricier
	contains = list(/obj/item/clothing/neck/roguetown/coif/heavypadding)

/datum/supply_pack/rogue/light_armor/sewingkit
	name = "Sewing Kit"
	cost = 40
	contains = list(/obj/item/repair_kit)

/datum/supply_pack/rogue/light_armor/lightgambeson
	name = "Light Gambeson"
	cost = 24 // these are actually really easy to make
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/light)

/datum/supply_pack/rogue/light_armor/paddedcoif
	name = "Padded Coif"
	cost = 26 // ditto
	contains = list(/obj/item/clothing/neck/roguetown/coif/padded)

/datum/supply_pack/rogue/light_armor/gambeson
	name = "Gambeson"
	cost = 32 // more expensive than clothes but not by a whole lot
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson)

/datum/supply_pack/rogue/light_armor/arming_jacket
	name = "Arming Jacket"
	cost = 40 // superior gambeson. idk if its on par w/ the actual padded one or not
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/lord)

/datum/supply_pack/rogue/light_armor/arming_jacket
	name = "Padded Arming Jacket"
	cost = 58 // padded gambeson equiv. but it lacks leg prot?
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy)

/datum/supply_pack/rogue/light_armor/grenzel_hat
	name = "Grenzelhoftian Hat"
	cost = 70 // it must be expensive. craftable, but high diff, and its heavily armored.
	contains = list(/obj/item/clothing/head/roguetown/grenzelhofthat)

/datum/supply_pack/rogue/light_armor/spellsinger_hat
	name = "Spellsinger Hat"
	cost = 75// ditto
	contains = list(/obj/item/clothing/head/roguetown/spellcasterhat)

/datum/supply_pack/rogue/light_armor/spellsigner_robes
	name = "Spellsinger Robes"
	cost = 90// high material cost, high skill req (6). this is probably overtuned but its also Maybe Fine.
	contains = list(/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe)
