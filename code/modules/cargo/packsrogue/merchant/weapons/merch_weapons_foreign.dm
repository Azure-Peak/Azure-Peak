// Special Mercenary Weapons, at exorbitant prices.
// I just wish someone explained how to price these.
/datum/supply_pack/rogue/merc_weapons
	group = "Weapons (Foreign)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/merc_weapons/navaja
	name = "Navaja"
	cost = 80
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/navaja)

/datum/supply_pack/rogue/merc_weapons/saildagger
	name = "Sail Dagger"
	cost = 80
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero)

/datum/supply_pack/rogue/merc_weapons/erapier
	name = "Cup-Hilt Rapier"
	cost = 120
	contains = list(/obj/item/rogueweapon/sword/rapier/vaquero)

/datum/supply_pack/rogue/merc_weapons/etruscanlongsword
	name = "Etruscan Longsword"
	cost = 409 // 409 because the Flos Duellatorum was written between 1400-1409 & Fiore is part of the reason frei gets an etruscan class
	contains = list(/obj/item/rogueweapon/sword/long/etruscan)

/datum/supply_pack/rogue/merc_weapons/shamshir
	name = "Shamshir"
	cost = 140
	contains = list(/obj/item/rogueweapon/sword/sabre/shamshir)

/datum/supply_pack/rogue/merc_weapons/naledistaff
	name = "Naledi Warstaff"
	cost = 140
	contains = list(/obj/item/rogueweapon/woodstaff/implement/grand/naledi)

/datum/supply_pack/rogue/merc_weapons/grenzelstaff
	name = "Grenzelhoftian Blacksteel Staff"
	cost = 140
	contains = list(/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel)

/datum/supply_pack/rogue/merc_weapons/glaive
	name = "Glaive"
	cost = 200
	contains = list(/obj/item/rogueweapon/halberd/glaive)

/datum/supply_pack/rogue/merc_weapons/pulaxe
	name = "Pulaski Axe"
	cost = 140
	contains = list(/obj/item/rogueweapon/stoneaxe/woodcut/pick)

/datum/supply_pack/rogue/merc_weapons/nagaika
	name = "Nagaika Whip"
	cost = 120
	contains = list(/obj/item/rogueweapon/whip/nagaika)

/datum/supply_pack/rogue/merc_weapons/naginata
	name = "Naginata"
	cost = 140
	contains = list(/obj/item/rogueweapon/spear/naginata)

/datum/supply_pack/rogue/merc_weapons/hookblade
	name = "Hook Sword"
	cost = 150
	contains = list(/obj/item/rogueweapon/sword/sabre/hook)

/datum/supply_pack/rogue/merc_weapons/hwando
	name = "Hwando and Scabbard"
	no_name_quantity = TRUE
	cost = 250
	contains = list(
		/obj/item/rogueweapon/sword/sabre/mulyeog,
		/obj/item/rogueweapon/scabbard/sword/kazengun
	)

/datum/supply_pack/rogue/merc_weapons/ssangsudo
	name = "Ssangsudo and Scabbard"
	no_name_quantity = TRUE
	cost = 250
	contains = list(
		/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo,
		/obj/item/rogueweapon/scabbard/sword/kazengun/noparry
	)

/datum/supply_pack/rogue/merc_weapons/kodachi
	name = "Kodachi and Scabbard"
	no_name_quantity = TRUE
	cost = 150
	contains = list(
		/obj/item/rogueweapon/sword/short/kazengun,
		/obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
	)

/datum/supply_pack/rogue/merc_weapons/tanto
	name = "Tanto and Sheathe"
	no_name_quantity = TRUE
	cost = 120 // This is just a reskinned sail dagger, but this one comes with a sheathe.
	contains = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun,
		/obj/item/rogueweapon/scabbard/sheath/kazengun
	)

/datum/supply_pack/rogue/merc_weapons/beardedaxe
	name = "Bearded Axe"
	cost = 140
	contains = list(/obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi)

/datum/supply_pack/rogue/merc_weapons/handclaw_iron
	name = "Iron Claw"
	cost = 150
	contains = list(/obj/item/rogueweapon/handclaw)

/datum/supply_pack/rogue/merc_weapons/handclaw_steel
	name = "Steel Claw"
	cost = 200
	contains = list(/obj/item/rogueweapon/handclaw/steel)
