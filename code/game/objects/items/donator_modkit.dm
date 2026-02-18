//Handles donator modkit code - basically akin to old Citadel/F13 modkit donator system.
//Tl;dr - Click the assigned modkit to the object type's parent, it'll change it into the child. Modkits, aka enchanting kits, are what you get.
/obj/item/enchantingkit
	name = "morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item."
	icon = 'icons/obj/items/donor_objects.dmi'	//We default to here just to avoid tons of uneeded sprites.
	icon_state = "enchanting_kit"
	w_class = WEIGHT_CLASS_SMALL	//So can fit in a bag, we don't need these large. They're just used to apply to items.
	var/list/target_items = list()
	var/result_item = null

/obj/item/enchantingkit/pre_attack(obj/item/I, mob/user)
	if(is_type_in_list(I, target_items))
		var/obj/item/R
		if(target_items[I.type] && !result_item)
			R = target_items[I.type]
		else
			R = result_item
		R = new R(get_turf(user))
		to_chat(user, span_notice("You apply the [src] to [I], using the enchanting dust and tools to turn it into [R]."))
		R.name += " <font size = 1>([I.name])</font>"
		remove_item_from_storage(I)
		qdel(I)
		user.put_in_hands(R)
		qdel(src)
		return TRUE
	else
		return ..()

/////////////////////////////
// ! Player / Donor Kits ! //
/////////////////////////////

//Plexiant - Custom rapier type
/obj/item/enchantingkit/plexiant
	name = "'Rapier di Aliseo' morphing elixir"
	target_items = list(/obj/item/rogueweapon/sword/rapier)		//Takes any subpated rapier and turns it into unique one.
	result_item = /obj/item/rogueweapon/sword/rapier/aliseo

//Ryebread - Custom estoc type
/obj/item/enchantingkit/ryebread
	name = "'Worttrager' morphing elixir"
	target_items = list(/obj/item/rogueweapon/estoc)		//Takes any subpated rapier and turns it into unique one.
	result_item = /obj/item/rogueweapon/estoc/worttrager

//Srusu - Custom dress type
/obj/item/enchantingkit/srusu
	name = "'Emerald Dress' morphing elixir"
	target_items = list(/obj/item/clothing/suit/roguetown/shirt/dress)	//Literally any type of dress
	result_item = /obj/item/clothing/suit/roguetown/shirt/dress/emerald

//Strudel - Custom leather vest type and xylix tabard
/obj/item/enchantingkit/strudel1
	name = "'Grenzelhoft Mage Vest' morphing elixir"
	target_items = list(/obj/item/clothing/suit/roguetown/shirt/robe)
	result_item = /obj/item/clothing/suit/roguetown/shirt/robe/sofiavest

/obj/item/enchantingkit/strudel2
	name = "'Xylixian Fasching Leotard' morphing elixir"
	target_items = list(/obj/item/clothing/cloak/templar/xylixian/)
	result_item = /obj/item/clothing/cloak/templar/xylixian/faux

//Bat - Custom harp type
/obj/item/enchantingkit/bat
	name = "'Handcrafted Harp' morphing elixir"
	target_items = list(/obj/item/rogue/instrument/harp)
	result_item = /obj/item/rogue/instrument/harp/handcarved

//Rebel - Custom visored sallet type
/obj/item/enchantingkit/rebel
	name = "'Gilded Sallet' morphing elixir"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored)
	result_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/gilded

//Bigfoot - Custom knight helm type
/obj/item/enchantingkit/bigfoot
	name = "'Gilded Knight Helm' morphing elixir"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight)
	result_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded

//Bigfoot - Custom great axe type
/obj/item/enchantingkit/bigfoot_axe
	name = "'Gilded Great Axe' morphing elixir"
	target_items = list(/obj/item/rogueweapon/greataxe/steel)
	result_item = /obj/item/rogueweapon/greataxe/steel/gilded

//Zydras donator items - Iconoclast pyromaniac
/obj/item/enchantingkit/zydrasiconocrown
	name = "Barred Helmet morphing elixir"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/sheriff)
	result_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/zydrasiconocrown

/obj/item/enchantingkit/zydrasiconopauldrons
	name = "Light Brigandine morphing elixir"
	target_items = list(/obj/item/clothing/suit/roguetown/armor/brigandine/light)
	result_item = /obj/item/clothing/suit/roguetown/armor/brigandine/light/zydrasiconopauldrons

/obj/item/enchantingkit/zydrasiconosash
	name = "Iron Hauberk morphing elixir"
	target_items = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron)
	result_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/zydrasiconosash

//Eiren - Zweihander and sabres
/obj/item/enchantingkit/eiren
	name = "'Regret' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/greatsword/zwei 				= /obj/item/rogueweapon/greatsword/zwei/eiren,
		/obj/item/rogueweapon/greatsword	  				= /obj/item/rogueweapon/greatsword/eiren,
		/obj/item/rogueweapon/greatsword/grenz/flamberge 	= /obj/item/rogueweapon/greatsword/grenz/flamberge/eiren
		)
	result_item = null

/obj/item/enchantingkit/eirensabre
	name = "'Lunae' morphing elixir"
	target_items = list(/obj/item/rogueweapon/sword/sabre)
	result_item = /obj/item/rogueweapon/sword/sabre/eiren

/obj/item/enchantingkit/eirensabre2
	name = "'Cinis' morphing elixir"
	target_items = list(/obj/item/rogueweapon/sword/sabre)
	result_item = /obj/item/rogueweapon/sword/sabre/eiren/small

//pretzel - custom steel greatsword. PSYDON LYVES. PSYDON ENDVRES.
/obj/item/enchantingkit/waff
	name = "'Weeper's Lathe' morphing elixir"
	target_items = list(/obj/item/rogueweapon/greatsword)		// i, uh. i really do promise i'm only gonna use it on steel greatswords.
	result_item = /obj/item/rogueweapon/greatsword/weeperslathe

//inverserun claymore
/obj/item/enchantingkit/inverserun
	name = "'Votive Thorns' morphing elixir"
	target_items = list(/obj/item/rogueweapon/greatsword/zwei)
	result_item = /obj/item/rogueweapon/greatsword/zwei/inverserun

//Zoe - Tytos Blackwood cloak
/obj/item/enchantingkit/zoe
	name = "'Shroud of the Undermaiden' morphing elixir"
	target_items = list(/obj/item/clothing/cloak/darkcloak/bear)
	result_item = /obj/item/clothing/cloak/raincloak/feather_cloak

//Zoe - Shovel
/obj/item/enchantingkit/zoe_shovel
	name = "'Silence' morphing elixir"
	target_items = list(/obj/item/rogueweapon/shovel)
	result_item = /obj/item/rogueweapon/shovel/zoe_silence

//DasFox - Armet
/obj/item/enchantingkit/dasfox_helm
	name = "'archaic valkyrhelm' morphing elixir"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet)
	result_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dasfox

//DasFox - Cuirass
/obj/item/enchantingkit/dasfox_cuirass
	name = "'archaic cermonial cuirass' morphing elixir"
	target_items = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted)
	result_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/dasfox

//DasFox - Lance
/obj/item/enchantingkit/dasfox_lance
	name = "'decorated jousting lance' morphing elixir"
	target_items = list(/obj/item/rogueweapon/spear/lance)
	result_item = /obj/item/rogueweapon/spear/lance/dasfox

//Ryan180602 - Armet
/obj/item/enchantingkit/ryan_psyhelm
	name = "'maimed psydonic helm' morphing elixir"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm)
	result_item = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/ryan

//Dakken12 - Armet/Hounskull
/obj/item/enchantingkit/dakken_zizhelm
	name = "'armoured avantyne barbute' morphing elixir"
	target_items = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet, 
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
	)
	result_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/dakken

//StinkethStonketh - Shashka & pike
/obj/item/enchantingkit/stinketh_shashka
	name = "'fencer's shashka' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/sabre/freifechter	= /obj/item/rogueweapon/sword/sabre/freifechter/stinketh,
		/obj/item/rogueweapon/sword/sabre/steppesman	= /obj/item/rogueweapon/sword/sabre/steppesman/stinketh
		)
	result_item = null

/obj/item/enchantingkit/stinketh_pike
	name = "'Kindness of Ravens Standard' morphing elixir"
	target_items = list(/obj/item/rogueweapon/spear/boar/frei/pike)
	result_item = /obj/item/rogueweapon/spear/boar/frei/pike/stinketh

//Koruu - Glaive
/obj/item/enchantingkit/koruu_glaive
	name = "'Sixty Five Yils' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/spear/naginata	= /obj/item/rogueweapon/spear/naginata/koruu,
		/obj/item/rogueweapon/halberd/glaive	= /obj/item/rogueweapon/halberd/glaive/koruu
		)
	result_item = null

//DRD21 - Longsword
/obj/item/enchantingkit/drd_lsword
	name = "'ornate basket-hilt longsword' morphing elixir"
	target_items = list(/obj/item/rogueweapon/sword/long)
	result_item = /obj/item/rogueweapon/sword/long/drd

/////////////////////////////
// ! Triumph-Exc. Kits !   //
/////////////////////////////

/obj/item/enchantingkit/triumph_armorkit
	name = "'Valorian' armor morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can restore the original appearance of.. </br>..a Steel Cuirass.. </br>..a Steel Halfplate.. </br>..a set of Steel Plate Armor.. </br>..or a set of Fluted Plate Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass 		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate	  			= /obj/item/clothing/suit/roguetown/armor/plate/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/full 			= /obj/item/clothing/suit/roguetown/armor/plate/full/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted 	= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_axe
	name = "'Valorian' axe morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..an Iron Axe.. </br>..or an Iron Hatchet."
	target_items = list(
		/obj/item/rogueweapon/stoneaxe/handaxe							= /obj/item/rogueweapon/stoneaxe/handaxe/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut	  						= /obj/item/rogueweapon/stoneaxe/woodcut/triumph
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_tri
	name = "'Valorian' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a Steel Longsword."
	target_items = list(/obj/item/rogueweapon/sword/long)
	result_item = /obj/item/rogueweapon/sword/long/triumph

/obj/item/enchantingkit/triumph_weaponkit_wide
	name = "'Wideguard' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a Steel Longsword </br>..or a Rapier."
	target_items = list(
		/obj/item/rogueweapon/sword/long					= /obj/item/rogueweapon/sword/long/triumph/wideguard,
		/obj/item/rogueweapon/sword/rapier	  			= /obj/item/rogueweapon/sword/rapier/wideguard
		)
	result_item = null


/obj/item/enchantingkit/triumph_weaponkit_rock
	name = "'Rockhillian' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a Steel Longsword.. </br>..a Steel Broadsword.. </br>..or an Executioner Sword."
	target_items = list(
		/obj/item/rogueweapon/sword/long						= /obj/item/rogueweapon/sword/long/triumph/rockhill,
		/obj/item/rogueweapon/sword/long/exe	  				= /obj/item/rogueweapon/sword/long/exe/rockhill,
		/obj/item/rogueweapon/sword/long/broadsword/steel		= /obj/item/rogueweapon/sword/long/broadsword/steel/rockhill
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_sabre
	name = "'Sabreguard' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a Steel Longsword.. </br>..or a Kriegmesser."
	target_items = list(
		/obj/item/rogueweapon/sword/long							= /obj/item/rogueweapon/sword/long/triumph/sabreguard,
		/obj/item/rogueweapon/sword/long/kriegmesser	  			= /obj/item/rogueweapon/sword/long/kriegmesser/sabreguard
		)
	result_item = null

/obj/item/enchantingkit/triumph_weaponkit_psy
	name = "'Psycrucifix' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a Steel Longsword.. </br>..or a Psydonic Longsword."
	target_items = list(
		/obj/item/rogueweapon/sword/long						= /obj/item/rogueweapon/sword/long/triumph/psycrucifix,
		/obj/item/rogueweapon/sword/long/psysword	  			= /obj/item/rogueweapon/sword/long/psysword/psycrucifix
		)
	result_item = null
