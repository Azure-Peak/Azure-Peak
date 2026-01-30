
/datum/supply_pack/rogue/Sellsword
	group = "Sellsword"
	crate_name = "Gifts of Coinspillers"
	crate_type = /obj/structure/closet/crate/chest/merchant

//////////
// HEAD //
//////////

/datum/supply_pack/rogue/Sellsword/sallet
	name = "Sallet"
	cost = 30
	contains = list(/obj/item/clothing/head/roguetown/helmet/sallet)

/datum/supply_pack/rogue/Sellsword/visoredsallet
	name = "Visored Sallet"
	cost = 50
	contains = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored)

/datum/supply_pack/rogue/Sellsword/steelmask
	name = "Steel Mask"
	cost = 30
	contains = list(/obj/item/clothing/mask/rogue/facemask/steel)

//////////
// NECK //
//////////

/datum/supply_pack/rogue/Sellsword/coif
	name = "Steel Coif"
	cost = 20
	contains = list(/obj/item/clothing/neck/roguetown/chaincoif)

/datum/supply_pack/rogue/Sellsword/coiffull
	name = "Steel Coif - Full"
	cost = 40
	contains = list(/obj/item/clothing/neck/roguetown/chaincoif/full)

/datum/supply_pack/rogue/Sellsword/Bevor
	name = "Bevor"
	cost = 30
	contains = list(/obj/item/clothing/neck/roguetown/bevor)

/datum/supply_pack/rogue/Sellsword/sgorget
	name = "Steel Gorget"
	cost = 40
	contains = list(/obj/item/clothing/neck/roguetown/gorget/steel)

///////////
// CHEST //
///////////

/datum/supply_pack/rogue/Sellsword/hgambeson
	name = "Heavy Gambeson"
	cost = 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)

/datum/supply_pack/rogue/Sellsword/hauberk
	name = "Hauberk"
	cost = 40
	contains = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk)

/datum/supply_pack/rogue/Sellsword/steelcuirass
	name = "Steel Cuirass"
	cost = 50
	contains =  list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass)

///////////////////
// WRISTS/GLOVES //
///////////////////

/datum/supply_pack/rogue/Sellsword/bracers
	name = "Steel Bracers"
	cost = 40
	contains = list(/obj/item/clothing/wrists/roguetown/bracers)

/datum/supply_pack/rogue/Sellsword/chaingauntlets
	name = "Steel Chain Gauntlets"
	cost = 20
	contains = list(/obj/item/clothing/gloves/roguetown/chain)

///////////////
// LEGS/FEET //
///////////////

/datum/supply_pack/rogue/Sellsword/chainlegs
	name = "Chain Chausses"
	cost = 40
	contains = list(/obj/item/clothing/under/roguetown/chainlegs)

/datum/supply_pack/rogue/Sellsword/boots
	name = "Steel Boots"
	cost = 30
	contains = list(/obj/item/clothing/shoes/roguetown/boots/armor)

/////////////////////
// WEAPONS - MELEE //
/////////////////////

/datum/supply_pack/rogue/Sellsword/shortsword
	name = "Falchion"
	cost = 30
	contains = list(/obj/item/rogueweapon/sword/short/falchion)

/datum/supply_pack/rogue/Sellsword/lsword
	name = "Kriegmesser"
	cost = 30
	contains = list(/obj/item/rogueweapon/sword/long/kriegmesser)

/datum/supply_pack/rogue/Sellsword/SZweihandersword
	name = "Steel Zweihander"
	cost = 100
	contains = list(/obj/item/rogueweapon/greatsword/grenz)

/datum/supply_pack/rogue/Sellsword/halberd
	name = "Halberd"
	cost = 60
	contains = list(/obj/item/rogueweapon/halberd)

/datum/supply_pack/rogue/Sellsword/partizan
	name = "Partizan"
	cost = 80
	contains = list(/obj/item/rogueweapon/spear/partizan)

/datum/supply_pack/rogue/Sellsword/ebeak
	name = "Eagle's Beak"
	cost = 80
	contains = list(/obj/item/rogueweapon/eaglebeak)

/datum/supply_pack/rogue/Sellsword/lance
	name = "Lance"
	cost = 120
	contains = list(/obj/item/rogueweapon/spear/lance)

/////////////
// SHIELDS //
/////////////

/datum/supply_pack/rogue/Sellsword/buckler
	name = "Buckler Shield"
	cost = 10
	contains = list(/obj/item/rogueweapon/shield/buckler)

/datum/supply_pack/rogue/Sellsword/heatshield
	name = "Heater Shield"
	cost = 10
	contains = list(/obj/item/rogueweapon/shield/heater)

//////////////////////
// WEAPONS - RANGED //
//////////////////////

/datum/supply_pack/rogue/Sellsword/crossbow
	name = "Crossbow"
	cost = 40
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow)

/////////////////////////////
// WEAPONS - RANGED - AMMO //
/////////////////////////////

/datum/supply_pack/rogue/Sellsword/bolts
	name = "Quiver of Bolts"
	cost = 30
	contains = list(/obj/item/quiver/bolts)

//////////////////////
// EQUIPMENT CRATES //
//////////////////////

/datum/supply_pack/rogue/Sellsword/Grenzelcrate
	name = "Grenzelhoft Equipment Crate"
	cost = 260
	contains = list(/obj/structure/closet/crate/chest/bandit/grenzel)

/obj/structure/closet/crate/chest/bandit/grenzel/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/grenzelhofthat(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft(src)
	new /obj/item/clothing/gloves/roguetown/angle/grenzelgloves(src)
	new /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants(src)
	new /obj/item/clothing/shoes/roguetown/grenzelhoft(src)
	new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grenzelhoft(src)

/datum/supply_pack/rogue/Sellsword/Otavancrate
	name = "Otavan Equipment Crate"
	cost = 260
	contains = list(/obj/structure/closet/crate/chest/bandit/otavan)

/obj/structure/closet/crate/chest/bandit/otavan/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/otavan(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/otavan(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan(src)
	new /obj/item/clothing/gloves/roguetown/otavan(src)
	new /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan(src)
	new /obj/item/clothing/shoes/roguetown/boots/otavan(src)
	new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/routier(src)

/datum/supply_pack/rogue/Sellsword/Etruscancrate
	name = "Etruscan Equipment Crate"
	cost = 260
	contains = list(/obj/structure/closet/crate/chest/bandit/etruscan)

/obj/structure/closet/crate/chest/bandit/etruscan/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan(src)
	new /obj/item/clothing/suit/roguetown/armor/brigandine(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy(src)
	new /obj/item/clothing/gloves/roguetown/plate(src)
	new /obj/item/clothing/under/roguetown/heavy_leather_pants(src)
	new /obj/item/clothing/shoes/roguetown/boots/armor/iron(src)
	new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/condottiero(src)

/datum/supply_pack/rogue/Sellsword/Forlorncrate
	name = "Forlorn Equipment Crate"
	cost = 260
	contains = list(/obj/structure/closet/crate/chest/bandit/forlorn)

/obj/structure/closet/crate/chest/bandit/forlorn/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/heavy/volfplate(src)
	new /obj/item/clothing/neck/roguetown/gorget/forlorncollar(src)
	new /obj/item/clothing/suit/roguetown/armor/brigandine(src)
	new /obj/item/clothing/wrists/roguetown/splintarms(src)
	new /obj/item/clothing/under/roguetown/splintlegs(src)
	new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/forlorn(src)

/datum/supply_pack/rogue/Sellsword/Longswordcrate
	name = "Longswordsman Equipment Crate"
	cost = 350
	contains = list(/obj/structure/closet/crate/chest/bandit/longsword)

/obj/structure/closet/crate/chest/bandit/longsword/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/sallet/visored(src)
	new /obj/item/clothing/neck/roguetown/bevor(src)
	new /obj/item/clothing/suit/roguetown/armor/plate(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy(src)
	new /obj/item/clothing/wrists/roguetown/bracers(src)
	new /obj/item/clothing/gloves/roguetown/plate(src)
	new /obj/item/clothing/under/roguetown/chainlegs(src)
	new /obj/item/clothing/shoes/roguetown/boots/armor(src)
	new /obj/item/rogueweapon/sword/long(src)
