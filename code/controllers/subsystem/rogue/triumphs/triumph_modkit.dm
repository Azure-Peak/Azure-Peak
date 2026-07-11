/////////////////////////////////
// ! TRIUMPH EXCLUSIVE KITS!   //
/////////////////////////////////
// Special enchanting kits that can be acquired via Triumphs. Refer to 'donator_modkits.dm' for more details and up-to-date examples.
// Try to keep anything specifically acquired via Triumphs - instead of Donations - here, if possible.

//'Replacement' variants. These specifically replace the item-in-question with a whole new instance. More bloatish, but ensures complete adherence to skin restrictions and allows for supplemental tweaks (like new onmobs.)
// No harm in using these if you prefer, but it's strongly suggested to implement reskins via the 'Skinned' system, below. This works best for clothing (like plate armor) and special weapons (like silver or avantyne.)

/obj/item/enchantingkit/triumph_armorkit
	name = "'Valorian Steel Armor' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can restore the original appearance of a Steel Cuirass, a Steel Halfplate, a set of Steel Plate Armor, or a set of Fluted Plate Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted 			= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass 				= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/full 					= /obj/item/clothing/suit/roguetown/armor/plate/full/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate	  					= /obj/item/clothing/suit/roguetown/armor/plate/legacy
		)
	result_item = null
	exact_type = TRUE

/obj/item/enchantingkit/triumph_armorkit_iron
	name = "'Valorian Iron Armor' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can restore the original appearance of an Iron Breastplate, an Iron Halfplate, or a set of Iron Plate Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron 			= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/full/iron	  			= /obj/item/clothing/suit/roguetown/armor/plate/full/iron/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/iron 					= /obj/item/clothing/suit/roguetown/armor/plate/iron/legacy
		)
	result_item = null

/obj/item/enchantingkit/triumph_armorkit_slimmedsteel
	name = "'Slimfitted Steel Armor' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can alter the appearance of a set of a Steel Halfplate, a Fluted Halfplate, a set of Steel Plate armor, or a set of Fluted Plate Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted 			= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass				= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate/full 					= /obj/item/clothing/suit/roguetown/armor/plate/full/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate/fluted				= /obj/item/clothing/suit/roguetown/armor/plate/fluted/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate	  					= /obj/item/clothing/suit/roguetown/armor/plate/triumph_slim
		)
	result_item = null
	exact_type = TRUE

/obj/item/enchantingkit/triumph_armorkit_drow
	name = "'Drowcraft Armor' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a set of Hardened Leather Armor, or a set of Studded Leather Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/leather/heavy 		= /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest,
		/obj/item/clothing/suit/roguetown/armor/leather/studded		= /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_axe
	name = "'Valorian Axe' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Axe, or an Iron Hatchet."
	target_items = list(
		/obj/item/rogueweapon/stoneaxe/handaxe							= /obj/item/rogueweapon/stoneaxe/handaxe/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut	  						= /obj/item/rogueweapon/stoneaxe/woodcut/triumph
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_axedouble
	name = "'Doublehead' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Axe, a Bronze Axe, a Steel Axe, a Battle Axe, a Silver War Axe, a Psydonic War Axe, or a Blacksteel Axe."
	target_items = list(
		/obj/item/rogueweapon/stoneaxe/woodcut/steel					= /obj/item/rogueweapon/stoneaxe/woodcut/steel/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut/bronze					= /obj/item/rogueweapon/stoneaxe/woodcut/bronze/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut/silver					= /obj/item/rogueweapon/stoneaxe/woodcut/silver/triumph,
		/obj/item/rogueweapon/stoneaxe/battle/blacksteel				= /obj/item/rogueweapon/stoneaxe/battle/blacksteel/triumph,
		/obj/item/rogueweapon/stoneaxe/battle/psyaxe					= /obj/item/rogueweapon/stoneaxe/battle/psyaxe/triumph,
		/obj/item/rogueweapon/stoneaxe/battle	  						= /obj/item/rogueweapon/stoneaxe/battle/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut							= /obj/item/rogueweapon/stoneaxe/woodcut/triumph_doublehead
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_fancymace
	name = "'Rungu-Shishpar' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Mace, an Iron Warhammer, a Steel Mace, a Steel Warhammer, or a Silver Mace."
	target_items = list(
		/obj/item/rogueweapon/mace/warhammer/steel				= /obj/item/rogueweapon/mace/warhammer/steel/shishpar,
		/obj/item/rogueweapon/mace/warhammer					= /obj/item/rogueweapon/mace/warhammer/shishpar,
		/obj/item/rogueweapon/mace/steel/silver					= /obj/item/rogueweapon/mace/steel/silver/rungu,
		/obj/item/rogueweapon/mace/steel						= /obj/item/rogueweapon/mace/steel/rungu,
		/obj/item/rogueweapon/mace								= /obj/item/rogueweapon/mace/rungu
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_kris
	name = "'Kris' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Bauernwehr, a Combat Knife, an Iron Dagger, or a Steel Dagger."
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel			= /obj/item/rogueweapon/huntingknife/idagger/steel/kris,
		/obj/item/rogueweapon/huntingknife/idagger					= /obj/item/rogueweapon/huntingknife/idagger/kris,
		/obj/item/rogueweapon/huntingknife/combat/iron				= /obj/item/rogueweapon/huntingknife/combat/iron/kris,
		/obj/item/rogueweapon/huntingknife/combat					= /obj/item/rogueweapon/huntingknife/combat/kris
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_njora
	name = "'Njora' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Dagger, an Iron Dagger, a Hunting Knife, or a Combat Knife."
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel				= /obj/item/rogueweapon/huntingknife/idagger/steel/njora,
		/obj/item/rogueweapon/huntingknife/idagger						= /obj/item/rogueweapon/huntingknife/idagger/njora,
		/obj/item/rogueweapon/huntingknife/combat						= /obj/item/rogueweapon/huntingknife/combat/njora,
		/obj/item/rogueweapon/huntingknife								= /obj/item/rogueweapon/huntingknife/njora
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_whip
	name = "'Alloytip' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Bronze Whip, a Whip, or a Silver Whip."
	target_items = list(
		/obj/item/rogueweapon/whip/silver				= /obj/item/rogueweapon/whip/silver/triumph,
		/obj/item/rogueweapon/whip/bronze				= /obj/item/rogueweapon/whip/bronze/triumph,
		/obj/item/rogueweapon/whip						= /obj/item/rogueweapon/whip/triumph
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_tri
	name = "'Valorian Longsword' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Longsword."
	target_items = list(/obj/item/rogueweapon/sword/long)
	result_item = /obj/item/rogueweapon/sword/long/triumph

/obj/item/enchantingkit/triumph_armorkit_agedskullcap
	name = "'Aged Skull Cap' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Skull Cap."
	target_items = list(
		/obj/item/clothing/head/roguetown/helmet/skullcap/steel				= /obj/item/clothing/head/roguetown/helmet/skullcap/old,
		/obj/item/clothing/head/roguetown/helmet/skullcap					= /obj/item/clothing/head/roguetown/helmet/skullcap/old
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_wide
	name = "'Wideguard' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Longsword, or a Rapier."
	target_items = list(
		/obj/item/rogueweapon/sword/long					= /obj/item/rogueweapon/sword/long/triumph/wideguard,
		/obj/item/rogueweapon/sword/rapier	  				= /obj/item/rogueweapon/sword/rapier/wideguard
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_sabre
	name = "'Sabreguard' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Longsword, or a Kriegmesser."
	target_items = list(
		/obj/item/rogueweapon/sword/long/kriegmesser	  			= /obj/item/rogueweapon/sword/long/kriegmesser/sabreguard,
		/obj/item/rogueweapon/sword/long							= /obj/item/rogueweapon/sword/long/triumph/sabreguard
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_estoc
	name = "'Kriegstetcher' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Stecher, or an Estoc."
	target_items = list(
		/obj/item/rogueweapon/sword/long/ap	  				= /obj/item/rogueweapon/sword/long/ap/triumph,
		/obj/item/rogueweapon/estoc							= /obj/item/rogueweapon/estoc/triumph
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_psy
	name = "'Psycrucifix' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Longsword, an Enduring Longsword, or a Psydonic Longsword."
	target_items = list(
		/obj/item/rogueweapon/sword/long/psysword	  				= /obj/item/rogueweapon/sword/long/psysword/psycrucifix,
		/obj/item/rogueweapon/sword/long/oldpsysword	  			= /obj/item/rogueweapon/sword/long/oldpsysword/psycrucifix,
		/obj/item/rogueweapon/sword/long							= /obj/item/rogueweapon/sword/long/triumph/psycrucifix
		)
	result_item = null

/obj/item/enchantingkit/sci_flame
	name = "'Flametongue' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Shamshir."
	target_items = list(
		/obj/item/rogueweapon/sword/sabre/shamshir = /obj/item/rogueweapon/sword/sabre/shamshir/dono_scidragon_flame
	)

/obj/item/enchantingkit/sci_sand
	name = "'Sandlash' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Shamshir."
	target_items = list(
		/obj/item/rogueweapon/sword/sabre/shamshir = /obj/item/rogueweapon/sword/sabre/shamshir/dono_scidragon_sand
	)

/obj/item/enchantingkit/triumph_armorkit_classiciron
	name = "'Aged Iron Breastplate' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Breastplate."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/triumph
	)

/obj/item/enchantingkit/triumph_armorkit_classicleather
	name = "'Classic Leathers' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Leather Coat, a set of Leather Armor, or a set of Hardened Leather Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/leather/cuirass			= /obj/item/clothing/suit/roguetown/armor/leather/cuirass/triumph,
		/obj/item/clothing/suit/roguetown/armor/leather					= /obj/item/clothing/suit/roguetown/armor/leather/triumph,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat		= /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/triumph
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_classicdaggers
	name = "'Classic Daggers' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Dagger or Steel Dagger."
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel		= /obj/item/rogueweapon/huntingknife/idagger/steel/triumph_classic,
		/obj/item/rogueweapon/huntingknife/idagger				= /obj/item/rogueweapon/huntingknife/idagger/triumph_classic
		)
	result_item = null

/obj/item/enchantingkit/triumph_transmutekit_armorkinis
	name = "'Armorkini' transmutation elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to turn a set of Hide Armor, Leather Armor, Studded Leather Armor, Haubergeon, or Plate Armor into their corseted equivalents."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/leather/hide					= /obj/item/clothing/suit/roguetown/armor/leather/hide/bikini,
		/obj/item/clothing/suit/roguetown/armor/leather							= /obj/item/clothing/suit/roguetown/armor/leather/bikini,
		/obj/item/clothing/suit/roguetown/armor/leather/studded					= /obj/item/clothing/suit/roguetown/armor/leather/studded/bikini,
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron					= /obj/item/clothing/suit/roguetown/armor/chainmail/bikini,
		/obj/item/clothing/suit/roguetown/armor/chainmail						= /obj/item/clothing/suit/roguetown/armor/chainmail/bikini,
		/obj/item/clothing/suit/roguetown/armor/plate/iron						= /obj/item/clothing/suit/roguetown/armor/plate/iron/bikini,
		/obj/item/clothing/suit/roguetown/armor/plate/full/iron					= /obj/item/clothing/suit/roguetown/armor/plate/iron/bikini,
		/obj/item/clothing/suit/roguetown/armor/plate							= /obj/item/clothing/suit/roguetown/armor/plate/bikini,
		/obj/item/clothing/suit/roguetown/armor/plate/full						= /obj/item/clothing/suit/roguetown/armor/plate/full/bikini
		)
	result_item = null

//'Skinned' variants. These are less thorough than the 'Replacement' variants, but are cleaner (and lead to a lot less extra instances that can clog up the spawning menu.)
// Unlike the 'Replacement' variants, these basically just apply a new sprite onto the old item and call it a day. If you need to give custom onmobs to a certain weapon to make it look good, use the former method instead.

/obj/item/enchantingkit/weapon/triumph_weaponkit_sword
	name = "'Valorian Sword' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Arming Sword, an Iron Dueling Sword, or a Maciejowski."
	target_items = list(
		/obj/item/rogueweapon/sword/iron,
		/obj/item/rogueweapon/sword/short/messer/iron/virtue,
		/obj/item/rogueweapon/sword/falchion/militia
		)
	result_item = /obj/item/rogueweapon/example/valorian_sword

/obj/item/enchantingkit/weapon/triumph_weaponkit_rock
	name = "'Rockhillian Broadsword' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Broadsword, a Steel Broadsword, or an Executioner Sword."
	target_items = list(
		/obj/item/rogueweapon/sword/long/broadsword/steel,
		/obj/item/rogueweapon/sword/long/broadsword,
		/obj/item/rogueweapon/sword/long/exe
		)
	result_item = /obj/item/rogueweapon/example/valorian_broadsword

/obj/item/enchantingkit/weapon/triumph_weaponkit_greatval
	name = "'Valorian Greatsword' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Greatsword, a Claymore, or a Flamberge."
	target_items = list(
		/obj/item/rogueweapon/greatsword,
		/obj/item/rogueweapon/greatsword/iron,
		/obj/item/rogueweapon/greatsword/zwei,
		/obj/item/rogueweapon/greatsword/grenz/flamberge
		)
	result_item = /obj/item/rogueweapon/example/valorian_greatsword

/obj/item/enchantingkit/weapon/triumph_weaponkit_kaskara
	name = "'Kaskara' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Arming Sword, a Steel Arming Sword, or a Rapier."
	target_items = list(
		/obj/item/rogueweapon/sword/rapier,
		/obj/item/rogueweapon/sword/iron,
		/obj/item/rogueweapon/sword
		)
	result_item = /obj/item/rogueweapon/example/kaskara

/obj/item/enchantingkit/weapon/triumph_weaponkit_ida
	name = "'Ida' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Shortsword or a Steel Shortsword."
	target_items = list(
		/obj/item/rogueweapon/sword/short/iron,
		/obj/item/rogueweapon/sword/short
		)
	result_item = /obj/item/rogueweapon/example/ida

/obj/item/enchantingkit/weapon/triumph_weaponkit_hwi
	name = "'Hwi' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Hunting Sword, an Iron Dueling Messer, a Steel Messer, a Steel Hunting Sword, or a Falchion."
	target_items = list(
		/obj/item/rogueweapon/sword/short/falchion,
		/obj/item/rogueweapon/sword/short/messer/iron/virtue,
		/obj/item/rogueweapon/sword/short/messer/iron,
		/obj/item/rogueweapon/sword/short/messer/alt,
		/obj/item/rogueweapon/sword/short/messer,
		)
	result_item = /obj/item/rogueweapon/example/hwi

/obj/item/enchantingkit/weapon/triumph_weaponkit_ngombe
	name = "'Ngombe' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Iron Hunting Sword, an Iron Dueling Messer, a Steel Messer, a Steel Hunting Sword, or a Falchion."
	target_items = list(
		/obj/item/rogueweapon/sword/short/falchion,
		/obj/item/rogueweapon/sword/short/messer/iron/virtue,
		/obj/item/rogueweapon/sword/short/messer/iron,
		/obj/item/rogueweapon/sword/short/messer/alt,
		/obj/item/rogueweapon/sword/short/messer
		)
	result_item = /obj/item/rogueweapon/example/ngombe

/obj/item/enchantingkit/weapon/triumph_weaponkit_ada
	name = "'Ada' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Sabre, a Steel Sabre, a Falx, or a Falchion."
	target_items = list(
		/obj/item/rogueweapon/sword/short/falchion,
		/obj/item/rogueweapon/sword/saber/iron,
		/obj/item/rogueweapon/sword/sabre,
		/obj/item/rogueweapon/sword/falx
		)
	result_item = /obj/item/rogueweapon/example/ada

/obj/item/enchantingkit/weapon/triumph_weaponkit_sengese
	name = "'Sengese' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Sabre, a Steel Sabre, a Falx, or a Falchion."
	target_items = list(
		/obj/item/rogueweapon/sword/short/falchion,
		/obj/item/rogueweapon/sword/saber/iron,
		/obj/item/rogueweapon/sword/sabre,
		/obj/item/rogueweapon/sword/falx
		)
	result_item = /obj/item/rogueweapon/example/sengese

/obj/item/enchantingkit/weapon/triumph_weaponkit_clericsword
	name = "'Anointed Longsword' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Longsword."
	target_items = list(
		/obj/item/rogueweapon/sword/long,
		)
	result_item = /obj/item/rogueweapon/example/clericsword

/obj/item/enchantingkit/triumph_armorkit_oldhelmets
	name = "'Valorian Steel Helmet' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can restore the original appearance of a Steel Sallet, a Steel Visored Sallet, a Steel Kettlehelm, or a Steel Knight's Armet."
	target_items = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/knight				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old,
		/obj/item/clothing/head/roguetown/helmet/sallet/visored 			= /obj/item/clothing/head/roguetown/helmet/sallet/visored/legacy,
		/obj/item/clothing/head/roguetown/helmet/sallet						= /obj/item/clothing/head/roguetown/helmet/sallet/legacy,
		/obj/item/clothing/head/roguetown/helmet/kettle	  					= /obj/item/clothing/head/roguetown/helmet/kettle/legacy
		)
	result_item = null
	exact_type = TRUE

/obj/item/enchantingkit/triumph_armorkit_ironoldhelmets
	name = "'Valorian Iron Helmet' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can restore the original appearance of an Iron Sallet, an Iron Visored Sallet, an Iron Kettlehelm, or an Iron Knight's Armet."
	target_items = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/knight/iron			= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old/iron,
		/obj/item/clothing/head/roguetown/helmet/sallet/visored/iron 		= /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron/legacy,
		/obj/item/clothing/head/roguetown/helmet/sallet/iron				= /obj/item/clothing/head/roguetown/helmet/sallet/iron/legacy,
		/obj/item/clothing/head/roguetown/helmet/kettle/iron	  			= /obj/item/clothing/head/roguetown/helmet/kettle/iron/legacy
		)
	result_item = null

//////////////////////////////
// TRIUMPH-RESKIN EXAMPLES! //
//////////////////////////////
// Handles Triumph-specific variants of the items in enchanting_examples.dm. Refer to that file for more detailed instructions and up-to-date examples.
// In essence, it works like a 'reskin' that specifically changes the icon, name, and description (without having to further alter any mechanical details.)

/obj/item/rogueweapon/example/valorian_sword
	name = "valorian sword"
	desc = "A modest take on a mythical design, hailing from the blood-splattered crossroads \
	between Valoria and Rockhill. It feels right at home, in the palm of your hand."
	icon_state = "iswordalt"
	sheathe_icon = "iswordalt"

/obj/item/rogueweapon/example/valorian_broadsword
	name = "valorian broadsword"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and well-balanced weapon. The broadsword - better known as a 'hand-and-a-halfer' - has dutifully served the \
	swordsmen of Psydonia in their clashes against man-and-monster alike since time immemmorial. The edge glimmers with purpose."
	icon_state = "longsword_rockhillalt"
	bigboy = TRUE

/obj/item/rogueweapon/example/valorian_greatsword
	name = "valorian claymore"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A massive two-handed sword, wieldable by only the strongest of Psydonia's children. One swing could surely cleave \
	even the mightiest foes in twain - not even a horde's might could hope to stop you, now!"
	icon_state = "longsword_rockhillg"
	bigboy = TRUE

/obj/item/rogueweapon/example/kaskara
	name = "kaskara"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	desc = "A heavier arming sword that's popular amongst the southern reaches of Psydonia. The Lakkarians were the first to lovingly assemble \
	its design, the Naledians were the first to bristle their armies with its blade, and the Ranesheni were the first to make a killing off its exports."
	icon_state = "kaskara"
	sheathe_icon = "sbroadsword"

/obj/item/rogueweapon/example/ida
	name = "ida"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	desc = "A heavier alternative to the 'Njora' dagger, lengthened to adopt the more rigorous labors of fighting fiends. These Naledic-Lakkarian shortswords \
	are said to be the closest inheritors of an ancient design; of the first swords wielded by Man, in the tymes before Syon, against the ultimate evil."
	icon_state = "ida"
	sheathe_icon = "sbroadsword"

/obj/item/rogueweapon/example/hwi
	name = "hwi"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	desc = "A cleaving sword with a wide crossguard, curled to protect the wielder's knuckles against harm. Like many weapons hailing from Psydonia's southern \
	reaches, so too does this one incorporate a sense of ornamentality into the blade. Pieces of metal have been meticulously punched out of the inner spine's \
	curve, in order to mimic the guise of a gazing saiga."
	icon_state = "hwi"
	sheathe_icon = "cutlass"

/obj/item/rogueweapon/example/ngombe
	name = "ngombe"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	desc = "At the height of Naledian indulgance, it was an executioner's honor; a hooked edge, sharp enough to sever a fogbeast's head from its neck without \
	qualm. Ever since the collapse, however, it has lost all ornamentality. Amongst the sands, it now lyves as a weapon without purpose, wielded for a war without reason."
	icon_state = "ngombe"
	sheathe_icon = "sbroadsword"

/obj/item/rogueweapon/example/ada
	name = "ada"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	desc = "Before heraldry was woven into parchment, it was forged into steel. As per ancient traditions, the most important facets of a family would be meticulously \
	pounded into the surface of a heirloom's blade; such was to ensure that the millennial descendants of its wielder would never lose the truths of their bloodline."
	icon_state = "ada"
	sheathe_icon = "sbroadsword"

/obj/item/rogueweapon/example/sengese
	name = "sengese"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	desc = "Hooked swords like these have always been archaic in nature, seldom-favorable for the fields of fire. Then again, even the dullest blade can be turned into \
	a lethal implement, if entrusted to the hands of a wielder whose skill in swordsmanship lays unmatched."
	icon_state = "sengese"
	sheathe_icon = "sgeneric"

/obj/item/rogueweapon/example/clericsword
	name = "anointed longsword"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	desc = "A cleric's longsword, adorned with a blade of cold iron and blessed to smite evil. Though this blessed alloy lacks the strength to \
	sunder those who bare greater curses, it nevertheless channels enough power to dispell the lesser curses of mindless fiends-and-foes. </br>'Strike \
	true, my child, for thy blade is thine God..'"
	icon_state = "crusaderlongsword"
	sheathe_icon = "crusaderlongsword"
	bigboy = TRUE

////////////////////////////////////////////////////
// ! TO BE ARCHIVED / REPLACED WITH BETTER CODE!  //
////////////////////////////////////////////////////
// Weapon-specific Triumphs. The original iteration, based off the old donator-transmorgification code.
// For two-handed sprites, replace the '_1' variant in their 64.dmi sprite with the '_2' variant - ir-or-when the time to fully replace them comes.

/obj/item/rogueweapon/sword/long/triumph
	name = "valorian longsword"
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This particular variant has a stouter crossguard and wider blade; a prevaling design \
	from the preceding century, oft-mantled in the homes of now-retired adventurers."
	icon = 'icons/roguetown/weapons/64.dmi'  //Framework for Triumph-purchasable longswords.
	icon_state = "longsword_triumph"

/obj/item/rogueweapon/sword/long/triumph/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/triumph/rockhill
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This particular variant has a narrow crossguard and lengthened blade; the proportions \
	of an ancient hero's claymore, resurrected through modern smithing techniques."
	icon_state = "longsword_rockhill"
	sheathe_icon = "gensword"

/obj/item/rogueweapon/sword/long/exe/rockhill //Alternate version of the Executioner Sword.
	name = "valorian claymore"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This sharp-edged variant has a narrow crossguard and lengthened blade; the proportions \
	of an ancient hero's claymore, resurrected through modern smithing techniques."
	icon_state = "longsword_rockhill"

/obj/item/rogueweapon/sword/long/exe/rockhill/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/triumph/sabreguard
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This particular variant has a curved crossguard and stouter blade; hallmarks of nobility, \
	whether professed atop a saiga or against a villain's edge."
	icon_state = "longsword_sabreguard"
	sheathe_icon = "cutlass"

/obj/item/rogueweapon/sword/long/kriegmesser/sabreguard
	name = "valorian greatsabre"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This broad-edged variant has a curved crossguard and stouter blade; hallmarks of nobility, \
	whether professed atop a saiga or against a villain's edge."
	icon_state = "longsword_sabreguard"
	sheathe_icon = "cutlass"

/obj/item/rogueweapon/sword/long/kriegmesser/sabreguard/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/triumph/wideguard
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This particular variant has a widened crossguard, adored by lightly-armored mercenaries \
	who cannot afford to leave a single riposte without interception."
	icon_state = "longsword_wideguard"
	sheathe_icon = "opsysword"

/obj/item/rogueweapon/sword/rapier/wideguard //Alternate variant for the Rapier.
	name = "valorian greatrapier"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This well-honed variant has a widened crossguard, adored by lightly-armored mercenaries \
	who cannot afford to leave a single riposte without interception."
	icon_state = "longsword_wideguard"
	sheathe_icon = "opsysword"

/obj/item/rogueweapon/sword/rapier/wideguard/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/triumph/psycrucifix
	name = "valorian psycrucific longsword"
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This particular variant has a psycruciformed crossguard; a masterwork, held in silent \
	reverance by those who've vowed to never forget the ultimate sacrifice."
	icon_state = "longsword_psycrucifix"
	sheathe_icon = "opsysword"

/obj/item/rogueweapon/sword/long/psysword/psycrucifix //Alternate variant for the Psydonic Longswords.
	name = "valorian silver longsword"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This silvered variant has a psycruciformed crossguard; a masterwork, held in silent \
	reverance by those who've vowed to never forget the ultimate sacrifice."
	icon_state = "longsword_psycrucifix"
	sheathe_icon = "opsysword"

/obj/item/rogueweapon/sword/long/psysword/psycrucifix/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/oldpsysword/psycrucifix //Alternate variant for the Old Psydonic Longswords.
	name = "valorian psycrucific longsword"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This silvered variant has a psycruciformed crossguard; a masterwork, held in silent \
	reverance by those who've vowed to never forget the ultimate sacrifice."
	icon_state = "longsword_psycrucifix"
	sheathe_icon = "opsysword"

/obj/item/rogueweapon/sword/long/oldpsysword/psycrucifix/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/estoc/triumph //Alternate variants for the Estoc series.
	name = "azurian estoc"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "estoc_triumph"
	desc = "A deviation from the traditional longsword, meant to pierce maille or find the gaps in an \
	opponent's plate armor. This edgeless blade is almost exclusively half-sworded on foot, or as a lance \
	from saigaback. Wrapped around the grip is a roll of leather, dyed in Azuria's stormier hues; an unfetterable \
	connection to the Peak's history."
	bigboy = TRUE

/obj/item/rogueweapon/sword/long/ap/triumph //Alternate variants for the Estoc series.
	name = "kriegstecher"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "aplongsword_triumph"
	sheathe_icon = "aplongsword"
	desc = "A sword possessed of a quite long and tapered blade that is intended to be thrust between the \
	gaps in an opponent's armor. These are often produced without a cutting edge, especially in munitions grade \
	examples as weary armorers try and prevent their levies from dulling swords on chopping firewood."
	bigboy = TRUE

/obj/item/rogueweapon/mace/warhammer/steel/shishpar
	name = "steel shishpar"
	desc = "A heavy steel mace with a sword-like handle, fashioned for the hands of Lakkarian shieldbearers. The weight makes it \
	a little hard to wield, but it nevertheless remains capable of delivering devastating blows."
	icon_state = "shishpar"

/obj/item/rogueweapon/mace/warhammer/shishpar
	name = "shishpar"
	desc = "A heavy mace with a sword-like handle, exported by Lakkaria and oft-wielded by Naledian clerics. The weight makes it \
	a little hard to wield, but it nevertheless remains capable of delivering devastating blows."
	icon_state = "ishishpar"

/obj/item/rogueweapon/mace/steel/rungu
	name = "steel rungu"
	desc = "A steel craning mace from the southern reaches of Psydonia, following an ancient design that has survived for \
	centuries-hence. Many-a-fool have been humbled by a fact it professes the most: steel does not discriminate."
	icon_state = "rungu"

/obj/item/rogueweapon/mace/rungu
	name = "rungu"
	desc = "A craning mace from the southern reaches of Psydonia, following an ancient design that has survived for centuries-hence."
	icon_state = "irungu"

/obj/item/rogueweapon/mace/steel/silver/rungu
	name = "silver rungu"
	desc = "A silver craning mace from the southern reaches of Psydonia, following an ancient design that has survived \
	for centuries-hence. It is cherished by the clerics of Lakkari, Naledi, and Ranenshen."
	icon_state = "silverrungu"

/obj/item/rogueweapon/huntingknife/combat/iron/kris
	name = "kris"
	desc = "A large dagger with a unique, flame-shaped blade. Ancient yet elegant, with a purportedly dark \
	purpose; to turn the tip of the Archdevil's own designs against itself."
	icon_state = "ikris"
	sheathe_icon = "idagger"

/obj/item/rogueweapon/huntingknife/combat/kris
	name = "steel kris"
	desc = "A large steel dagger with a unique, flame-shaped blade. It is coveted as a ceremonial tool by Astratan \
	priests and clerics, especially during rites of sacrifice; symbolically, of course."
	icon_state = "kris"
	sheathe_icon = "sdagger"

/obj/item/rogueweapon/huntingknife/idagger/kris
	name = "kris"
	desc = "A large dagger with a unique, flame-shaped blade. Ancient yet elegant, with a purportedly dark \
	purpose; to turn the tip of the Archdevil's own designs against itself."
	icon_state = "ikris"
	sheathe_icon = "idagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/kris
	name = "steel kris"
	desc = "A large steel dagger with a unique, flame-shaped blade. It is coveted as a ceremonial tool by Astratan \
	priests and clerics, especially during rites of sacrifice; symbolically, of course."
	icon_state = "kris"
	sheathe_icon = "sdagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/njora
	name = "steel njora"
	desc = "A guardless dagger with a unique, leaf-shaped blade. As the mythos goes, the Lakkarians were the \
	first non-dwarven overdwellers to solve the riddle of steel; a solution passed down to their Naledian cousins."
	icon_state = "njora"
	sheathe_icon = "sdagger"

/obj/item/rogueweapon/huntingknife/idagger/njora
	name = "njora"
	desc = "A guardless dagger with a unique, leaf-shaped blade. Beloved by the peasantry and professional soldiers of \
	Lakkaria, this ancient-yet-elegant knife excels at both attending to labors and languishing foes."
	icon_state = "injora"
	sheathe_icon = "sdagger"

/obj/item/rogueweapon/huntingknife/combat/njora
	name = "steel mjora"
	desc = "A guardless dagger with a unique, leaf-shaped blade. As the mythos goes, the Lakkarians were the first \
	non-dwarven overdwellers to solve the riddle of steel; a solution passed down to their Naledian cousins."
	icon_state = "njora"
	sheathe_icon = "sdagger"

/obj/item/rogueweapon/huntingknife/njora
	name = "njora"
	desc = "A guardless dagger with a unique, leaf-shaped blade. Beloved by the peasantry and professional soldiers \
	of Lakkaria, this ancient-yet-elegant knife excels at both attending to labors and languishing foes."
	icon_state = "injora"
	sheathe_icon = "sdagger"

/obj/item/rogueweapon/huntingknife/idagger/triumph_classic
	icon_state = "kavrick_idagger"
	sheathe_icon = "kavrick_idagger"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/huntingknife/idagger/steel/triumph_classic
	icon_state = "kavrick_sdagger"
	sheathe_icon = "kavrick_sdagger"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/whip/triumph
	name = "alloy-tipped whip"
	desc = "'When there's a whip, there's a way!'"
	icon_state = "whip_iron"

/obj/item/rogueweapon/whip/bronze/triumph
	name = "bronze-tipped whip"
	desc = "'A man chooses; a slave obeys! Now, would you kindly.. ?'"
	icon_state = "whip_bronze"

/obj/item/rogueweapon/whip/silver/triumph
	name = "silver-tipped whip"
	desc = "'What is a man, but a miserable pile of secrets? But enough talk - have at you!'"
	icon_state = "whip_steel"

/obj/item/rogueweapon/stoneaxe/woodcut/triumph
	name = "valorian axe"
	icon_state = "axelegacy"
	desc = "'Through thick-and-thin, I have never failed you. May we trounce through the Terrorbog, one last time, before Astrata's glare vanishes 'neath the horizon?'"

/obj/item/rogueweapon/stoneaxe/handaxe/triumph
	name = "valorian hatchet"
	icon_state = "hatchetlegacy"
	desc = "'What is that rag for, anyways?'"

/obj/item/rogueweapon/stoneaxe/woodcut/triumph_doublehead
	name = "double-headed axe"
	desc = "'For Karl!'"
	icon_state = "axedouble"
	swingsound = BLADEWOOSH_HUGE

/obj/item/rogueweapon/stoneaxe/woodcut/bronze/triumph
	name = "double-headed bronze axe"
	desc = "'Give them nothing.. but take from them, EVERYTHING!'"
	icon_state = "bronzeaxedouble"
	swingsound = BLADEWOOSH_HUGE

/obj/item/rogueweapon/stoneaxe/woodcut/steel/triumph
	name = "double-headed steel axe"
	desc = "'Last man alive, lock the doors!'"
	icon_state = "saxedouble"
	swingsound = BLADEWOOSH_HUGE

/obj/item/rogueweapon/stoneaxe/battle/triumph
	name = "double-headed battle axe"
	desc = "'Never thought I'd die side-by-side wi' an elve.' </br>'How about with a friend?' </br>'Aye, I coul' do that.'"
	icon_state = "battleaxedouble"
	swingsound = BLADEWOOSH_HUGE

/obj/item/rogueweapon/stoneaxe/woodcut/silver/triumph
	name = "double-headed silver axe"
	desc = "'I'll swallow your soul, I'll swallow your soul!' </br>'Swallow this.'"
	icon_state = "silveraxedouble"
	swingsound = BLADEWOOSH_HUGE

/obj/item/rogueweapon/stoneaxe/battle/psyaxe/triumph
	name = "double-headed psydonic axe"
	desc = "'Hail to the king, baby.'"
	icon_state = "psyaxedouble"
	swingsound = BLADEWOOSH_HUGE

/obj/item/rogueweapon/stoneaxe/battle/blacksteel/triumph
	name = "double-headed blacksteel axe"
	desc = "'Get away from them, you bitch!'"
	icon_state = "bs_axedouble"
	swingsound = BLADEWOOSH_HUGE

/obj/item/clothing/suit/roguetown/armor/leather/cuirass/triumph
	name = "leather cuirass"
	icon_state = "legacyleather"
	color = null

/obj/item/clothing/suit/roguetown/armor/leather/triumph
	name = "leather armor"
	icon_state = "legacyroguearmor"
	color = null

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/triumph
	name = "hardened leather coat"
	icon_state = "legacyroguearmor_coat"
	color = null

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/triumph
	name = "aged iron breastplate"
	desc = "An aged iron cuirass. It looks to've been hewn from the same kind of low-quality iron that's traditionally reserved for \
	cookware, long ago. Despite its ignoble origins, this cuirass has clearly outlived most of its far-more-expensive compatriots. Maybe \
	there is some truth in the old adage of 'keeping it simple, stupid'."
	icon_state = "legacyibreastplate"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy
    name = "valorian cuirass"
    desc = "A steel cuirass. Do you still remember the first time you tasted blood; that sanguine succor, dribbling from a busted lip?"
    icon_state = "legacycuirass"
    item_state = "legacycuirass"

/obj/item/clothing/suit/roguetown/armor/plate/legacy
    name = "valorian half-plate"
    desc = "A padded steel cuirass, 'adventurer-fitted' with a pair of pauldrons. Before you is your weapon; when was the last time \
	you had ever thought without its presence?"
    icon_state = "legacyhalfplate"
    item_state = "legacyhalfplate"

/obj/item/clothing/suit/roguetown/armor/plate/full/legacy
    name = "valorian plate armor"
    desc = "A complete set of steel plate armor, fitted with tassets and bracers for additional coverage. When the kingdom comes \
	crashing down, will you deliver its people from evil; or will you be the one to string up 'pon the pyre?"
    icon_state = "legacyplate"
    item_state = "legacyplate"

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy
    name = "valorian fluted plate armor"
    desc = "A resplendant set of steel plate armor, decorated with silver flutings. Blessed dreamer, accursed heathen, lowly \
	fool; the curtain call is a mere heartbeat away. Are you ready for one last dance, before midnight calls?"
    icon_state = "legacyornateplate"
    item_state = "legacyornateplate"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/legacy
	name = "valorian iron breastplate"
	desc = "An iron cuirass. Where everyone else perished, you persevered; with every broken bone, did you still swear that you lyved?"
	icon_state = "ilegacycuirass"

/obj/item/clothing/suit/roguetown/armor/plate/iron/legacy
	name = "valorian iron half-plate"
	desc = "An padded iron cuirass, fitted with tassets for additional coverage. Will you let your past command the absolute fate of what \
	is yet to come?"
	icon_state = "ilegacytassetplate"

/obj/item/clothing/suit/roguetown/armor/plate/full/iron/legacy
	name = "valorian iron plate armor"
	desc = "A complete set of iron plate armor, fitted with tassets and bracers for additional coverage. Ask yourself one last question, before \
	you twist the blade; is humenity still worth saving?"
	icon_state = "ilegacyplate"

/obj/item/clothing/head/roguetown/helmet/kettle/legacy
	name = "valorian kettle helmet"
	desc = "A steel helmet which protects the top and sides of the head. Will you stand fast when the time to fight for your God and your Kingdom arise?"
	icon_state = "kettleclassic"

/obj/item/clothing/head/roguetown/helmet/sallet/legacy
	name = "valorian sallet"
	icon_state = "salletclassic"
	desc = "A steel helmet which covers most of the head, offering superior coverage to the kettle helmet. Will you ever know what meal will be your last, before your heart falls still?"

/obj/item/clothing/head/roguetown/helmet/sallet/visored/legacy
	name = "valorian visored sallet"
	desc = "A steel 'sallet'-styled helmet with an adjustable visor. Where do your loyalties lie; with thine Kingdom, or with thine God?"
	icon_state = "salletclassic_visor"

/obj/item/clothing/head/roguetown/helmet/kettle/iron/legacy
	name = "valorian iron kettle helmet"
	desc = "An iron helmet which protects the top and sides of the head. What can you do, when all you have are bows and arrows against the lightning?"
	icon_state = "ikettleclassic"

/obj/item/clothing/head/roguetown/helmet/sallet/iron/legacy
	name = "valorian iron sallet"
	icon_state = "isalletclassic"
	desc = "An iron helmet which covers most of the head, offering superior coverage to the kettle helmet. March to the cadence, follow your betters into death; but why?"

/obj/item/clothing/head/roguetown/helmet/sallet/visored/iron/legacy
	name = "valorian iron visored sallet"
	desc = "An iron 'sallet'-styled helmet with an adjustable visor. What will they remember of you, once the dust has settled?"
	icon_state = "isalletclassic_visor"

/obj/item/clothing/head/roguetown/helmet/skullcap/old
	name = "aged skull cap"
	desc = "An aged helmet which covers the top of the head."
	icon_state = "skullcapold"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/triumph_slim
    icon_state = "ornatecuirassslim"
    item_state = "ornatecuirassslim"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/triumph_slim
    icon_state = "ornatechestplateslim"
    item_state = "ornatechestplateslim"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/triumph_slim
    icon_state = "cuirassslim"
    item_state = "cuirassslim"

/obj/item/clothing/suit/roguetown/armor/plate/triumph_slim
    icon_state = "halfplateslim"
    item_state = "halfplateslim"

/obj/item/clothing/suit/roguetown/armor/plate/full/triumph_slim
    icon_state = "plateslim"
    item_state = "plateslim"

/obj/item/clothing/suit/roguetown/armor/plate/fluted/triumph_slim
    icon_state = "ornatehalfplateslim"
    item_state = "ornatehalfplateslim"

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/triumph_slim
    icon_state = "ornateplateslim"
    item_state = "ornateplateslim"

/obj/item/enchantingkit/craftable_armorkit_slimmedsteel
	name = "plate-slimming refitter's kit"
	desc = "A small array of plates, scripts, and tools; perfect for refitting a single set of plated armor. This can tighten the straps and \
	reduce the visible bulkines of a Steel Halfplate, a Fluted Halfplate, a set of Plate Armor, or a set of Fluted Plate Armor."
	icon_state = "metalrefittingkit"
	icon = 'icons/roguetown/items/misc.dmi'
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted 			= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass				= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate/full 					= /obj/item/clothing/suit/roguetown/armor/plate/full/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate/fluted				= /obj/item/clothing/suit/roguetown/armor/plate/fluted/triumph_slim,
		/obj/item/clothing/suit/roguetown/armor/plate	  					= /obj/item/clothing/suit/roguetown/armor/plate/triumph_slim
		)
	result_item = null
	exact_type = TRUE
