//Handles donator modkit code - basically akin to old Citadel/F13 modkit donator system.
//Tl;dr - Click the assigned modkit to the object type's parent, it'll change it into the child. Modkits, aka enchanting kits, are what you get.
/obj/item/enchantingkit
	name = "morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item."
	icon = 'icons/obj/items/donor_objects.dmi'	//We default to here just to avoid tons of uneeded sprites.
	icon_state = "enchanting_kit"
	w_class = WEIGHT_CLASS_SMALL	//So can fit in a bag, we don't need these large. They're just used to apply to items.
	var/list/target_items = list()
	/// Result item we'll exchange it to. Currently /weapon/ type kits use this as an example they'll copy all the visual data from. Keep this in mind if this never gets properly refactored!
	var/result_item = null

/obj/item/enchantingkit/pre_attack(obj/item/I, mob/user)
	if(!I || !user)
		return ..()

	if(!is_type_in_list(I, target_items))
		return ..()

	var/R_type = null
	if(LAZYLEN(target_items))
		for(var/T in target_items)
			if(istype(I, T))
				R_type = target_items[T]
				break

	if(!R_type && result_item)
		R_type = result_item

	if(!R_type && !result_item)
		CRASH("No result_item on a donator kit while R_type was empty. Something went wrong.")

	if(!R_type)
		to_chat(user, span_warning("[src] doesn't know how to morph [I]."))
		return TRUE

	if(I.loc == user)
		// pulls from hands/slots/inventory cleanly
		user.temporarilyRemoveItemFromInventory(I, TRUE)

	remove_item_from_storage(I)
	var/turf/T = get_turf(user)
	if(!T)
		T = get_turf(I)
	if(!T)
		to_chat(user, span_warning("Nowhere to morph [I]."))
		return TRUE

	var/obj/item/R = new R_type(T)
	to_chat(user, span_notice("You apply the [src] to [I], using the enchanting dust and tools to turn it into [R]."))
	R.name += " <font size = 1>([I.name])</font>"
	qdel(I)
	if(!user.put_in_hands(R))
		R.forceMove(get_turf(user))

	if(ismob(user))
		var/mob/M = user
		M.update_body()

	qdel(src)
	return TRUE

/obj/item/enchantingkit/weapon/pre_attack(obj/item/I, mob/user)
	if(!I || !user)
		return ..()

	if(!isturf(I.loc))
		to_chat(user, span_info("This should be on the floor, lest I spill it onto myself."))
		return

	if(!istype(I, /obj/item/rogueweapon))
		return ..()

	if(!is_type_in_list(I, target_items))
		return ..()

	var/R_type = result_item

	if(!R_type)
		to_chat(user, span_warning("[src] doesn't know how to morph [I]."))
		return TRUE
	
	var/obj/item/rogueweapon/RI = R_type
	var/obj/item/rogueweapon/TI = I
	TI.icon = RI::icon
	TI.icon_state = RI::icon_state
	TI.item_state = RI::item_state
	TI.toggle_state = RI::icon_state
	TI.lefthand_file = RI::lefthand_file
	TI.righthand_file = RI::righthand_file
	TI.sheathe_icon = RI::sheathe_icon ? RI::sheathe_icon : TI.sheathe_icon
	TI.bigboy = RI::bigboy

	to_chat(user, span_notice("You apply the [src] to [I], using the enchanting dust and tools to turn it into [RI::name]."))
	I.name = "[RI::name] <font size = 1>([I.name])</font>"
	I.desc = RI::desc
	I.update_transform()

	if(ismob(user))
		var/mob/M = user
		M.update_body()

	qdel(src)
	return TRUE

/obj/item/enchantingkit/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking the appropriate item with this elixir will gift it a unique appearance.")

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
/obj/item/enchantingkit/weapon/eiren
	name = "'Regret' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/greatsword/grenz/flamberge,
		/obj/item/rogueweapon/greatsword/zwei,
		/obj/item/rogueweapon/greatsword
		)
	result_item = /obj/item/rogueweapon/example/eiren_greatsword

/obj/item/enchantingkit/weapon/eirensabre
	name = "'Lunae' morphing elixir"
	target_items = list(/obj/item/rogueweapon/sword/sabre)
	result_item = /obj/item/rogueweapon/example/eiren_sabre

/obj/item/enchantingkit/eirensabre2
	name = "'Cinis' morphing elixir"
	target_items = list(/obj/item/rogueweapon/sword/saber)
	result_item = /obj/item/rogueweapon/example/eiren_sabre_alt

/obj/item/enchantingkit/weapon/eiren_m
	name = "glintstone longsword"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/eirenxiv/eiren_m

/obj/item/enchantingkit/weapon/eirensword
	name = "stygian longsword"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/eirenxiv/eirensword

//pretzel - custom steel greatsword. PSYDON LYVES. PSYDON ENDVRES.
/obj/item/enchantingkit/waff
	name = "'Weeper's Lathe' morphing elixir"
	target_items = list(/obj/item/rogueweapon/greatsword)
	result_item = /obj/item/rogueweapon/example/waffai_greatsword

//inverserun claymore
/obj/item/enchantingkit/weapon/inverserun
	name = "'Votive Thorns' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/greatsword/grenz/flamberge,
		/obj/item/rogueweapon/greatsword/zwei,
		/obj/item/rogueweapon/greatsword
		)
	result_item = /obj/item/rogueweapon/example/inverserun_greatsword

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

//Dakken12 - Armet/Hounskull/Swords
/obj/item/enchantingkit/dakken_zizhelm
	name = "'armoured avantyne barbute' morphing elixir"
	target_items = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dakken,
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/dakken,
		/obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor            = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor/dakken
	)
	result_item = null

/obj/item/enchantingkit/dakken_alloybsword
	name = "'avantyne-threaded sword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long	= /obj/item/rogueweapon/sword/long/dakken_longsword,
		/obj/item/rogueweapon/sword			= /obj/item/rogueweapon/sword/dakken_sword
	)
	result_item = null

//StinkethStonketh - Shashka & pike
/obj/item/enchantingkit/stinketh_shashka
	name = "'fencer's shashka' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/sabre/freifechter,
		/obj/item/rogueweapon/sword/sabre/steppesman
	)
	result_item = /obj/item/rogueweapon/example/stinketh_sabre

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

//Koruu - Kukri
/obj/item/enchantingkit/weapon/koruu_kukri
	name = "'Leachwhacker' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/rogueweapon/huntingknife/combat,
		/obj/item/rogueweapon/huntingknife
		)
	result_item = /obj/item/rogueweapon/koruu/kukri

/obj/item/enchantingkit/weapon/koruu_kukri/warden
	name = "'Warden Leachwhacker' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/warden_machete
		)
	result_item = /obj/item/rogueweapon/koruu/kukri/warden

//DRD21 - Longsword
/obj/item/enchantingkit/drd_lsword
	name = "'ornate basket-hilt longsword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/sword/long/drd

//DRD21 - Shield
/obj/item/enchantingkit/weapon/drd_shield
	name = "'House Woerden shield' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/shield/tower/metal
	)
	result_item = /obj/item/rogueweapon/drd/shield

//Lmwevil - Beak Mask
/obj/item/enchantingkit/lmwevil_brassbeak
	name = "brass beak mask morphing elixir"
	target_items = list(
		/obj/item/clothing/mask/rogue/courtphysician, 
		/obj/item/clothing/mask/rogue/physician
	)
	result_item = /obj/item/clothing/mask/rogue/courtphysician/brassbeak

//Shudderfly - Steel Dagger
/obj/item/enchantingkit/shudderfly_dagger
	name = "'Eoran Spike' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel
	)
	result_item = /obj/item/rogueweapon/huntingknife/idagger/steel/shudderfly

//Maesune - Sabre/Shield
/obj/item/enchantingkit/weapon/maesune_shield
	name = "'Fy Annwyl' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/shield/tower/metal
	)
	result_item = /obj/item/rogueweapon/maesune/shield

/obj/item/enchantingkit/weapon/maesune_sabre
	name = "'Y Ceirw' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/short/falchion,
		/obj/item/rogueweapon/sword/long,
		/obj/item/rogueweapon/sword/long/silver,
		/obj/item/rogueweapon/sword,
		/obj/item/rogueweapon/sword/silver,
		/obj/item/rogueweapon/sword/long/kriegmesser
	)
	result_item = /obj/item/rogueweapon/maesune/sabre

//NeroCavalier - Sword
/obj/item/enchantingkit/weapon/noire_flsword
	name = "'Blacksteel Longsword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/nerocavalier/flsword
