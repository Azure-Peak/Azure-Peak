/////////////////////////////////
// ! TRIUMPH EXCLUSIVE KITS!   //
/////////////////////////////////
// Special enchanting kits that can be acquired via Triumphs. Refer to 'donator_modkits.dm' for more details and up-to-date examples.
// Try to keep anything specifically acquired via Triumphs - instead of Donations - here.

//'Replacement' variants. These specifically replace the item-in-question with a whole new instance. More bloatish, but ensures complete adherence to skin restrictions and allows for supplemental tweaks (like new onmobs.)
// No harm in using these if you prefer, but it's strongly suggested to implement reskins via the 'Skinned' system, below. This works best for clothing (like plate armor) and special weapons (like silver or avantyne.)

/obj/item/enchantingkit/triumph_armorkit
	name = "'Valorian' armor morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can restore the original appearance of a Steel Cuirass, a Steel Halfplate, a set of Steel Plate Armor, or a set of Fluted Plate Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass 		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted 	= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/full 			= /obj/item/clothing/suit/roguetown/armor/plate/full/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate	  			= /obj/item/clothing/suit/roguetown/armor/plate/legacy
		)
	result_item = null

/obj/item/enchantingkit/triumph_armorkit_drow
	name = "'Drowcraft' armor morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a set of Hardened Leather Armor, or a set of Studded Leather Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/leather/heavy 		= /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest,
		/obj/item/clothing/suit/roguetown/armor/leather/studded		= /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_axe
	name = "'Valorian' axe morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Axe, or an Iron Hatchet."
	target_items = list(
		/obj/item/rogueweapon/stoneaxe/handaxe							= /obj/item/rogueweapon/stoneaxe/handaxe/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut	  						= /obj/item/rogueweapon/stoneaxe/woodcut/triumph
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_axedouble
	name = "'Doublehead' axe morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Axe, a Bronze Axe, a Steel Axe, a Battle Axe, a Silver War Axe, or a Psydonic War Axe."
	target_items = list(
		/obj/item/rogueweapon/stoneaxe/woodcut/steel					= /obj/item/rogueweapon/stoneaxe/woodcut/steel/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut/bronze					= /obj/item/rogueweapon/stoneaxe/woodcut/bronze/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut/silver					= /obj/item/rogueweapon/stoneaxe/woodcut/silver/triumph,
		/obj/item/rogueweapon/stoneaxe/battle/psyaxe					= /obj/item/rogueweapon/stoneaxe/battle/psyaxe/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut							= /obj/item/rogueweapon/stoneaxe/woodcut/triumphalt,
		/obj/item/rogueweapon/stoneaxe/battle	  						= /obj/item/rogueweapon/stoneaxe/battle/triumph
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_fancymace
	name = "'Rungu-Shishpar' mace morphing elixir"
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
	name = "'Kris' dagger morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Bauernwehr, a Combat Knife, an Iron Dagger, or a Steel Dagger."
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel			= /obj/item/rogueweapon/huntingknife/idagger/steel/kris,
		/obj/item/rogueweapon/huntingknife/idagger					= /obj/item/rogueweapon/huntingknife/idagger/kris,
		/obj/item/rogueweapon/huntingknife/combat/iron				= /obj/item/rogueweapon/huntingknife/combat/iron/kris,
		/obj/item/rogueweapon/huntingknife/combat					= /obj/item/rogueweapon/huntingknife/combat/kris
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_njora
	name = "'Njora' dagger morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Dagger, an Iron Dagger, a Hunting Knife, or a Combat Knife."
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel				= /obj/item/rogueweapon/huntingknife/idagger/steel/njora,
		/obj/item/rogueweapon/huntingknife/idagger						= /obj/item/rogueweapon/huntingknife/idagger/njora,
		/obj/item/rogueweapon/huntingknife/combat						= /obj/item/rogueweapon/huntingknife/combat/njora,
		/obj/item/rogueweapon/huntingknife								= /obj/item/rogueweapon/huntingknife/njora
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_whip
	name = "'Alloytip' whip morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Bronze Whip, a Whip, or a Silver Whip."
	target_items = list(
		/obj/item/rogueweapon/whip/silver				= /obj/item/rogueweapon/whip/silver/triumph,
		/obj/item/rogueweapon/whip/bronze				= /obj/item/rogueweapon/whip/bronze/triumph,
		/obj/item/rogueweapon/whip						= /obj/item/rogueweapon/whip/triumph
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_tri
	name = "'Valorian' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Longsword."
	target_items = list(/obj/item/rogueweapon/sword/long)
	result_item = /obj/item/rogueweapon/sword/long/triumph

/obj/item/enchantingkit/triumph_weaponkit_wide
	name = "'Wideguard' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Longsword, or a Rapier."
	target_items = list(
		/obj/item/rogueweapon/sword/long					= /obj/item/rogueweapon/sword/long/triumph/wideguard,
		/obj/item/rogueweapon/sword/rapier	  				= /obj/item/rogueweapon/sword/rapier/wideguard
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_sabre
	name = "'Sabreguard' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Longsword, or a Kriegmesser."
	target_items = list(
		/obj/item/rogueweapon/sword/long/kriegmesser	  			= /obj/item/rogueweapon/sword/long/kriegmesser/sabreguard,
		/obj/item/rogueweapon/sword/long							= /obj/item/rogueweapon/sword/long/triumph/sabreguard
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_estoc
	name = "'Kriegstetcher' estoc morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Stecher, or an Estoc."
	target_items = list(
		/obj/item/rogueweapon/sword/long/ap	  				= /obj/item/rogueweapon/sword/long/ap/triumph,
		/obj/item/rogueweapon/estoc							= /obj/item/rogueweapon/estoc/triumph
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_psy
	name = "'Psycrucifix' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Longsword, an Enduring Longsword, or a Psydonic Longsword."
	target_items = list(
		/obj/item/rogueweapon/sword/long/psysword	  				= /obj/item/rogueweapon/sword/long/psysword/psycrucifix,
		/obj/item/rogueweapon/sword/long/oldpsysword	  			= /obj/item/rogueweapon/sword/long/oldpsysword/psycrucifix,
		/obj/item/rogueweapon/sword/long							= /obj/item/rogueweapon/sword/long/triumph/psycrucifix
		)
	result_item = null

//
//'Skinned' variants. These are less thorough than the 'Replacement' variants, but are cleaner (and lead to a lot less extra instances that can clog up the spawning menu.)
// Unlike the 'Replacement' variants, these basically just apply a new sprite onto the old item and call it a day. If you need to give custom onmobs to a certain weapon to make it look good, use the former method instead.

/obj/item/enchantingkit/weapon/triumph_weaponkit_sword
	name = "'Valorian' sword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Arming Sword, an Iron Dueling Sword, or a Maciejowski."
	target_items = list(
		/obj/item/rogueweapon/sword/iron,
		/obj/item/rogueweapon/sword/short/messer/iron/virtue,
		/obj/item/rogueweapon/sword/falchion/militia
		)
	result_item = /obj/item/rogueweapon/example/valorian_sword

/obj/item/enchantingkit/weapon/triumph_weaponkit_rock
	name = "'Rockhillian' broadsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Broadsword, a Steel Broadsword, or an Executioner Sword."
	target_items = list(
		/obj/item/rogueweapon/sword/long/broadsword/steel,
		/obj/item/rogueweapon/sword/long/broadsword,
		/obj/item/rogueweapon/sword/long/exe
		)
	result_item = /obj/item/rogueweapon/example/valorian_broadsword

/obj/item/enchantingkit/weapon/triumph_weaponkit_greatval
	name = "'Valorian' greatsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Greatsword, a Claymore, or a Flamberge."
	target_items = list(
		/obj/item/rogueweapon/greatsword,
		/obj/item/rogueweapon/greatsword/iron,
		/obj/item/rogueweapon/greatsword/zwei,
		/obj/item/rogueweapon/greatsword/grenz/flamberge
		)
	result_item = /obj/item/rogueweapon/example/valorian_greatsword

/obj/item/enchantingkit/weapon/triumph_weaponkit_wodao
	name = "'Wodao' sabre morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Sabre, a Steel Sabre, a Cutlass, or a Falchion."
	target_items = list(
		/obj/item/rogueweapon/sword/short/falchion,
		/obj/item/rogueweapon/sword/saber/iron,
		/obj/item/rogueweapon/sword/sabre,
		/obj/item/rogueweapon/sword/cutlass
		)
	result_item = /obj/item/rogueweapon/example/wodao

/obj/item/enchantingkit/weapon/triumph_weaponkit_dadao
	name = "'Dadao' messer morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Hunting Sword, an Iron Dueling Messer, a Steel Messer, a Steel Hunting Sword, a Falchion, or a Falx."
	target_items = list(
		/obj/item/rogueweapon/sword/short/falchion,
		/obj/item/rogueweapon/sword/short/messer/iron/virtue,
		/obj/item/rogueweapon/sword/short/messer/iron,
		/obj/item/rogueweapon/sword/short/messer/alt,
		/obj/item/rogueweapon/sword/short/messer,
		/obj/item/rogueweapon/sword/falx
		)
	result_item = /obj/item/rogueweapon/example/dadao

/obj/item/enchantingkit/weapon/triumph_weaponkit_gdadao
	name = "'Greatdadao' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Kriegmesser, or a Rhomphaia."
	target_items = list(
		/obj/item/rogueweapon/sword/long/rhomphaia,
		/obj/item/rogueweapon/sword/long/kriegmesser
		)
	result_item = /obj/item/rogueweapon/example/gdadao

/obj/item/enchantingkit/weapon/triumph_weaponkit_kaskara
	name = "'Kaskara' sword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Arming Sword, a Steel Arming Sword, or a Rapier."
	target_items = list(
		/obj/item/rogueweapon/sword/rapier,
		/obj/item/rogueweapon/sword/iron,
		/obj/item/rogueweapon/sword
		)
	result_item = /obj/item/rogueweapon/example/kaskara

/obj/item/enchantingkit/weapon/triumph_weaponkit_ida
	name = "'Ida' shortsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Shortsword or a Steel Shortsword."
	target_items = list(
		/obj/item/rogueweapon/sword/short/iron,
		/obj/item/rogueweapon/sword/short
		)
	result_item = /obj/item/rogueweapon/example/ida

/obj/item/enchantingkit/weapon/triumph_weaponkit_hwi
	name = "'Hwi' messer morphing elixir"
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
	name = "'Ngombe' axesword morphing elixir"
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
	name = "'Ada' sabre morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Sabre, a Steel Sabre, a Falx, or a Falchion."
	target_items = list(
		/obj/item/rogueweapon/sword/short/falchion,
		/obj/item/rogueweapon/sword/saber/iron,
		/obj/item/rogueweapon/sword/sabre,
		/obj/item/rogueweapon/sword/falx
		)
	result_item = /obj/item/rogueweapon/example/ada

/obj/item/enchantingkit/weapon/triumph_weaponkit_sengese
	name = "'Sengese' sabre morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Sabre, a Steel Sabre, a Falx, or a Falchion."
	target_items = list(
		/obj/item/rogueweapon/sword/short/falchion,
		/obj/item/rogueweapon/sword/saber/iron,
		/obj/item/rogueweapon/sword/sabre,
		/obj/item/rogueweapon/sword/falx
		)
	result_item = /obj/item/rogueweapon/example/sengese

//////////////////////////////
// TRIUMPH-RESKIN EXAMPLES! //
//////////////////////////////
// Handles Triumph-specific variants of the items in enchanting_examples.dm. Refer to that file for more detailed instructions and up-to-date examples.
// In essence, works like a 'reskin' that specifically changes the icon, name, and description (without having to further alter any mechanical details.)

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

/obj/item/rogueweapon/example/valorian_greatsword
	name = "valorian claymore"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A massive two-handed sword, wieldable by only the strongest of Psydonia's children. One swing could surely cleave \
	even the mightiest foes in twain - not even a horde's might could hope to stop you, now!"
	icon_state = "longsword_rockhillg"

/obj/item/rogueweapon/example/wodao
	name = "wodao"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	desc = "A slightly curved blade that has been proliferated everywhere from Naledian allspice caravans to \
	Kazengunite diplomat-militants. While less durable compared to other arming swords, it's swift balance and unique design \
	makes it great for unleashing precise strikes."
	icon_state = "wodao"
	sheathe_icon = "wodao"

/obj/item/rogueweapon/example/dadao
	name = "dadao"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	desc = "A heavier alternative to the 'Wodao' sabre, this well-balanced cleaver is informally known amongst Ranensheni pikemen as \
	the 'Saigachopper'; termed such for its purported ability to decapitate a calvaryman's steed in but a single blow."
	icon_state = "dadao"
	sheathe_icon = "dadao"

/obj/item/rogueweapon/example/gdadao
	name = "greatdadao"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "Larger than the 'Wodao' sabre, sharper than the 'Dadao' cleaver, and nastier than the sum of its parts. A single stroke dares to \
	part even the thickest-of-foes into gorey halves."
	icon_state = "gdadao"
	sheathe_icon = "dadao"

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

/obj/item/rogueweapon/sword/long/ap/triumph //Alternate variants for the Estoc series.
	name = "kriegstecher"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "aplongsword_triumph"
	sheathe_icon = "aplongsword"
	desc = "A sword possessed of a quite long and tapered blade that is intended to be thrust between the \
	gaps in an opponent's armor. These are often produced without a cutting edge, especially in munitions grade \
	examples as weary armorers try and prevent their levies from dulling swords on chopping firewood."

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

/obj/item/rogueweapon/stoneaxe/woodcut/triumphalt
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
