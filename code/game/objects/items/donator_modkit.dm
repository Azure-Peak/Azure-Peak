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
	/// Whether we'll be looking for exact types in target_items. This generally should be TRUE unless the user wants the elixir to be used on subtypes as well.
	var/exact_type = FALSE

/obj/item/enchantingkit/pre_attack(obj/item/I, mob/user)
	if(!I || !user)
		return ..()

	if(!is_type_in_list(I, target_items))
		return ..()

	var/R_type = null
	if(LAZYLEN(target_items))
		for(var/T in target_items)
			if(exact_type)
				if(I.type == T)
					R_type = target_items[T]
					break
			else
				if(istype(I, T))
					R_type = target_items[T]
					break

	if(!R_type && exact_type)
		return ..()

	if(!R_type && result_item)
		R_type = result_item

	if(!R_type && !result_item)
		CRASH("No result_item on a donator kit while R_type was empty. Something went wrong.")

	if(!R_type)
		to_chat(user, span_warning("[src] doesn't know how to morph [I]."))
		return TRUE

	if(I.GetComponent(/datum/component/conjured_item))
		to_chat(user, span_warning("[src] cannot morph conjured items."))
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
	TI.override_state = RI::icon_state
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

/// NOT ACTUALLY AN ENCHANTING KIT
/// Just wasn't sure where to put it, given its niche use.
/obj/item/heelkit
	name = "heel-morphing elixir"
	desc = "A small container of special morphing dust, specially designed to add heels to any foot-garment lacking them. Arcyne innovations have now reached fashion, much to the dismay of Otavan heel-smiths."
	icon = 'icons/obj/items/donor_objects.dmi'
	icon_state = "enchanting_kit"
	w_class = WEIGHT_CLASS_SMALL


/obj/item/heelkit/pre_attack(obj/item/I, mob/user)
	if(!user || !I)
		return
	if(!istype(I, /obj/item/clothing/shoes/roguetown))
		to_chat(user, span_warning("These are not the appropriate type of item for this elixir."))
		return
	I.visible_message(span_notice("The dust sparkles over the item, the contours shifting as \the [I] grows a pair of heels..?"))
	var/datum/component/SFX = I.GetComponent(/datum/component/item_equipped_movement_rustle)
	if(SFX)
		SFX.Destroy()
	I.name += " (Heeled)"
	I.AddComponent(/datum/component/item_equipped_movement_rustle, SFX_HEELS, 2)
	var/obj/item/clothing/shoes/roguetown/SH = I
	SH.stepnoise_flag = STEPNOISE_HEELS
	do_sparks(2, TRUE, get_turf(SH))
	qdel(src)

/////////////////////////////
// ! Unlocked Donor Kits ! //
/////////////////////////////

/obj/item/enchantingkit/maillekini
	name = "'Maillekini' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Bronze Hauberk, an Iron Hauberk, or a Steel Hauberk."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze			= /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze/donator,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron				= /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/donator,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk					= /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/donator
	)
	result_item = null

/obj/item/enchantingkit/gothicironarmor
	name = "'Gothic Iron Armor' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Breastplate, Iron Halfplate, or a set of Iron Plate Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/donator_gothic,
		/obj/item/clothing/suit/roguetown/armor/plate/full/iron			= /obj/item/clothing/suit/roguetown/armor/plate/full/iron/donator_gothic,
		/obj/item/clothing/suit/roguetown/armor/plate/iron				= /obj/item/clothing/suit/roguetown/armor/plate/iron/donator_gothic
	)
	result_item = null

/obj/item/enchantingkit/gothicsteelarmor
	name = "'Gothic Steel Armor' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Cuirass, Steel Halfplate, a set of Steel Plate Armor, or a set of Fluted Plate Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted			= /obj/item/clothing/suit/roguetown/armor/plate/full/donator_gothic,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass				= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/donator_gothic,
		/obj/item/clothing/suit/roguetown/armor/plate/full					= /obj/item/clothing/suit/roguetown/armor/plate/full/donator_gothic,
		/obj/item/clothing/suit/roguetown/armor/plate						= /obj/item/clothing/suit/roguetown/armor/plate/donator_gothic
	)
	result_item = null
	exact_type = TRUE

/obj/item/enchantingkit/croppedhaubergeon
	name = "'Cropped Haubergeon' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Bronze Haubergeon, an Iron Haubergeon, or a Steel Haubergeon."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/bronze		= /obj/item/clothing/suit/roguetown/armor/chainmail/bronze/donator,
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron			= /obj/item/clothing/suit/roguetown/armor/chainmail/iron/donator,
		/obj/item/clothing/suit/roguetown/armor/chainmail				= /obj/item/clothing/suit/roguetown/armor/chainmail/donator
	)
	result_item = null

/obj/item/enchantingkit/heartplate
	name = "'Heartplate' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Bronze Cuirass, an Iron Breastplate, a Steel Cuirass, or a set of Leather Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/bronze		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/bronze/donator,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron			= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/donator,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass				= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/donator,
		/obj/item/clothing/suit/roguetown/armor/leather						= /obj/item/clothing/suit/roguetown/armor/leather/donator
	)
	result_item = null

/obj/item/enchantingkit/elvenchainmail
	name = "'Elven Haubergeon' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Haubergeon, or a Steel Haubergeon."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron		= /obj/item/clothing/suit/roguetown/armor/chainmail/iron/donator_elven,
		/obj/item/clothing/suit/roguetown/armor/chainmail			= /obj/item/clothing/suit/roguetown/armor/chainmail/donator_elven
	)
	result_item = null

/obj/item/enchantingkit/heroicleathercuirass
	name = "'Heroic Leather Cuirass' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a set of Leather Armor, Heavy Leather Armor, Studded Heavy Armor, or a Pyaltrist's Cuirass."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist 	= /obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist/donator_cuirass,
		/obj/item/clothing/suit/roguetown/armor/leather/studded				= /obj/item/clothing/suit/roguetown/armor/leather/studded/donator_cuirass,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy				= /obj/item/clothing/suit/roguetown/armor/leather/heavy/donator_cuirass,
		/obj/item/clothing/suit/roguetown/armor/leather						= /obj/item/clothing/suit/roguetown/armor/leather/donator_cuirass
	)
	result_item = null

/obj/item/enchantingkit/cackledagger
	name = "'Cackledagger' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Dagger, or a Decorated Dagger."
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel					= /obj/item/rogueweapon/huntingknife/idagger/steel/donator,
		/obj/item/rogueweapon/huntingknife/idagger/steel/decorated			= /obj/item/rogueweapon/huntingknife/idagger/steel/decorated/donator
	)
	result_item = null

/obj/item/enchantingkit/beltleather
	name = "'Belt of Caped Leather' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of any Belt."
	target_items = list(/obj/item/storage/belt/rogue/leather)
	result_item = /obj/item/storage/belt/rogue/leather/donator

/obj/item/enchantingkit/beltfur
	name = "'Belt of Caped Fur' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of any Belt."
	target_items = list(/obj/item/storage/belt/rogue/leather)
	result_item = /obj/item/storage/belt/rogue/leather/donator_fur

/obj/item/enchantingkit/beltbronzemaille
	name = "'Belt of Bronze Maille' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of any Belt."
	target_items = list(/obj/item/storage/belt/rogue/leather)
	result_item = /obj/item/storage/belt/rogue/leather/donator_bronze

/obj/item/enchantingkit/beltironmaille
	name = "'Belt of Iron Maille' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of any Belt."
	target_items = list(/obj/item/storage/belt/rogue/leather)
	result_item = /obj/item/storage/belt/rogue/leather/donator_iron

/obj/item/enchantingkit/beltsteelmaille
	name = "'Belt of Maille' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of any Belt."
	target_items = list(/obj/item/storage/belt/rogue/leather)
	result_item = /obj/item/storage/belt/rogue/leather/donator_steel

/obj/item/enchantingkit/triheartfelt
	name = "'Azurian Plate Armor' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of either a set of Steel Plate Armor, or a set of Fluted Plate Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy				= /obj/item/clothing/suit/roguetown/armor/plate/full/donator_triheartfelt,
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted						= /obj/item/clothing/suit/roguetown/armor/plate/full/donator_triheartfelt,
		/obj/item/clothing/suit/roguetown/armor/plate/full/legacy						= /obj/item/clothing/suit/roguetown/armor/plate/full/donator_triheartfelt,
		/obj/item/clothing/suit/roguetown/armor/plate/full								= /obj/item/clothing/suit/roguetown/armor/plate/full/donator_triheartfelt
	)
	result_item = null
	exact_type = TRUE

/obj/item/enchantingkit/weapon/donator_longsword
	name = "'Elegant Longsword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/donator_longsword

/obj/item/enchantingkit/weapon/donator_imbuedlongsword
	name = "'Imbued Longsword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/donator_imbuedlongsword

/obj/item/enchantingkit/jadehalfmask
	name = "'Jade Halfmask' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of an Iron Mask, Steel Mask, Bronze Mask, or a Carved Jade Mask."
	target_items = list(
		/obj/item/clothing/mask/rogue/facemask/carved/jademask		= /obj/item/clothing/mask/rogue/facemask/carved/jademask/donator,
		/obj/item/clothing/mask/rogue/facemask/bronze				= /obj/item/clothing/mask/rogue/facemask/bronze/donator,
		/obj/item/clothing/mask/rogue/facemask/steel				= /obj/item/clothing/mask/rogue/facemask/steel/donator,
		/obj/item/clothing/mask/rogue/facemask						= /obj/item/clothing/mask/rogue/facemask/donator
	)
	result_item = null

/obj/item/enchantingkit/plackart
	name = "'Plackart' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Bronze Cuirass, an Iron Breastplate, a Steel Cuirass, a Fencing Cuirass, or a set of Leather Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron			= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/donator_girdle,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/bronze		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/bronze/donator_girdle,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/donator_girdle,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass				= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/donator_girdle,
		/obj/item/clothing/suit/roguetown/armor/leather						= /obj/item/clothing/suit/roguetown/armor/leather/donator_girdle
	)
	result_item = null

/obj/item/enchantingkit/donator_universal_armory
	name = "'Elegant Armory' morphing elixir" //Small compromise to avoid bloating the Loadout tab.
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of most Steel weapons, including the Decorated Sword and Dagger."
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/decorated 			= /obj/item/rogueweapon/huntingknife/idagger/steel/decorated/donator_elegant,
		/obj/item/rogueweapon/huntingknife/idagger/steel					= /obj/item/rogueweapon/huntingknife/idagger/steel/donator_elegant,
		/obj/item/rogueweapon/mace/warhammer/steel 							= /obj/item/rogueweapon/mace/warhammer/steel/donator_elegant,
		/obj/item/rogueweapon/mace/steel/silver 							= /obj/item/rogueweapon/mace/steel/silver/donator_elegant,
		/obj/item/rogueweapon/mace/goden/steel								= /obj/item/rogueweapon/mace/goden/steel/donator_elegant,
		/obj/item/rogueweapon/sword/short/messer							= /obj/item/rogueweapon/sword/short/messer/donator_elegant,
		/obj/item/rogueweapon/sword/long/dec 								= /obj/item/rogueweapon/sword/long/dec/donator_elegant,
		/obj/item/rogueweapon/sword/long/exe								= /obj/item/rogueweapon/sword/long/exe/donator_elegant,
		/obj/item/rogueweapon/sword/rapier/dec								= /obj/item/rogueweapon/sword/rapier/dec/donator_elegant,
		/obj/item/clothing/gloves/roguetown/knuckles						= /obj/item/clothing/gloves/roguetown/knuckles/donator_elegant,
		/obj/item/rogueweapon/stoneaxe/woodcut/steel						= /obj/item/rogueweapon/stoneaxe/woodcut/steel/donator_elegant,
		/obj/item/rogueweapon/woodstaff/quarterstaff/steel					= /obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant,
		/obj/item/rogueweapon/sword/rapier									= /obj/item/rogueweapon/sword/rapier/donator_elegant,
		/obj/item/rogueweapon/sword/short									= /obj/item/rogueweapon/sword/short/donator_elegant,
		/obj/item/rogueweapon/sword/long									= /obj/item/rogueweapon/sword/long/donator_elegant,
		/obj/item/rogueweapon/sword/sabre									= /obj/item/rogueweapon/sword/sabre/donator_elegant,
		/obj/item/rogueweapon/sword/decorated								= /obj/item/rogueweapon/sword/decorated/donator_elegant,
		/obj/item/rogueweapon/flail/sflail									= /obj/item/rogueweapon/flail/sflail/donator_elegant,
		/obj/item/rogueweapon/greataxe/steel								= /obj/item/rogueweapon/greataxe/steel/donator_elegant,
		/obj/item/rogueweapon/spear/lance									= /obj/item/rogueweapon/spear/lance/donator_elegant,
		/obj/item/rogueweapon/mace/steel									= /obj/item/rogueweapon/mace/steel/donator_elegant,
		/obj/item/rogueweapon/stoneaxe/battle								= /obj/item/rogueweapon/stoneaxe/battle/donator_elegant,
		/obj/item/rogueweapon/spear/boar									= /obj/item/rogueweapon/spear/boar/donator_elegant,
		/obj/item/rogueweapon/greatsword									= /obj/item/rogueweapon/greatsword/donator_elegant,
		/obj/item/rogueweapon/katar 										= /obj/item/rogueweapon/katar/donator_elegant,
		/obj/item/rogueweapon/halberd										= /obj/item/rogueweapon/halberd/donator_elegant,
		/obj/item/rogueweapon/eaglebeak										= /obj/item/rogueweapon/eaglebeak/donator_elegant,
		/obj/item/rogueweapon/sword											= /obj/item/rogueweapon/sword/donator_elegant
	)
	result_item = null

/obj/item/enchantingkit/weapon/donator_universal_whips
	name = "'Elegant Whip' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Whip."
	target_items = list(/obj/item/rogueweapon/whip)
	result_item = /obj/item/rogueweapon/example/donator_elegant_whip

/obj/item/enchantingkit/weapon/donator_universal_urumi
	name = "'Elegant Urumi' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of any Whip with an Alloyed Tip."
	target_items = list(
		/obj/item/rogueweapon/whip/antique,
		/obj/item/rogueweapon/whip/bronze,
		/obj/item/rogueweapon/whip/blacksteel,
		/obj/item/rogueweapon/whip/silver,
		/obj/item/rogueweapon/whip/psywhip_lesser
	)
	result_item = /obj/item/rogueweapon/example/donator_elegant_urumi

/obj/item/enchantingkit/donator_universal_shield
	name = "'Elegant Kite Shield' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Kite Shield."
	target_items = list(/obj/item/rogueweapon/shield/tower/metal)
	result_item = /obj/item/rogueweapon/shield/tower/metal/donator_elegant

/obj/item/enchantingkit/weapon/donator_universal_grenzshortsword
	name = "'Katzbalger Shortsword' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Shortsword."
	target_items = list(/obj/item/rogueweapon/sword/short)
	result_item = /obj/item/rogueweapon/example/donator_grenzshortsword

/obj/item/enchantingkit/donator_universal_grenzrapier
	name = "'Smallsword Rapier' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of a Steel Rapier."
	target_items = list(/obj/item/rogueweapon/sword/rapier)
	result_item = /obj/item/rogueweapon/sword/donator_smallsword

/obj/item/enchantingkit/donator_universal_armharness
	name = "'Plate Arm Harness' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of Steel Bracers."
	target_items = list(/obj/item/clothing/wrists/roguetown/bracers)
	result_item = /obj/item/clothing/wrists/roguetown/bracers/armharness

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
	target_items = list(/obj/item/clothing/suit/roguetown/shirt/robe,
						/obj/item/clothing/suit/roguetown/shirt)
	result_item = /obj/item/clothing/cloak/tabard/stabard/surcoat/sofiavest

/obj/item/enchantingkit/strudel2
	name = "'Xylixian Fasching Leotard' morphing elixir"
	target_items = list(/obj/item/clothing/cloak/templar/xylixian/)
	result_item = /obj/item/clothing/cloak/templar/xylixian/faux

/obj/item/enchantingkit/strudel3
	name = "'Etruscan Design Cloak' morphing elixir"
	target_items = list(/obj/item/clothing/cloak/poncho)
	result_item = /obj/item/clothing/cloak/poncho/dittocloak

/obj/item/enchantingkit/strudel4
	name = "'Form-fitting Padded Gambeson' morphing elixir"
	target_items = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)
	result_item = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/strudels

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
	name = "'Aureline' morphing elixir"
	target_items = list(/obj/item/rogueweapon/greataxe/steel)
	result_item = /obj/item/rogueweapon/greataxe/steel/gilded

//Zydras donator items - Ironclad baddie
/obj/item/enchantingkit/zydrashauberk
	name = "Mailled Cuirass morphing elixir"
	target_items = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy)
	result_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass

/obj/item/enchantingkit/zydrasgreataxe
	name = "Greataxe morphing elixir"
	target_items = list(/obj/item/rogueweapon/greataxe)
	result_item = /obj/item/rogueweapon/greataxe/zygreataxe

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

/obj/item/enchantingkit/weapon/eirensabre2
	name = "'Cinis' morphing elixir"
	target_items = list(/obj/item/rogueweapon/sword/saber)
	result_item = /obj/item/rogueweapon/example/eiren_sabre_alt

/obj/item/enchantingkit/weapon/eiren_m
	name = "'glintstone longsword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/eirenxiv/eiren_m

/obj/item/enchantingkit/weapon/eirensword
	name = "'stygian longsword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/eirenxiv/eirensword

//waffai - silver for monsters, steel for men
/obj/item/enchantingkit/weapon/waff
	name = "'Weeper's Lathe' morphing elixir"
	target_items = list(/obj/item/rogueweapon/sword/long/kriegmesser/silver)
	result_item = /obj/item/rogueweapon/example/waffai_broadsword // silver broadsword is actually a kriegmesser subtype, who knew?

/obj/item/enchantingkit/weapon/wafflamberge
	name = "'Xenolalia' morphing elixir"
	target_items = list(/obj/item/rogueweapon/greatsword/grenz/flamberge)
	result_item = /obj/item/rogueweapon/example/waffai_flamberge

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
/* REMOVED BY REQUEST.
/obj/item/enchantingkit/weapon/noire_flsword
	name = "'Blacksteel Longsword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/nerocavalier/flsword
*/

/obj/item/enchantingkit/aisuwand
    name = "Crystalline Rapier morphing elixir"
    target_items = list(/obj/item/rogueweapon/sword/rapier)
    result_item = /obj/item/rogueweapon/sword/rapier/aisu

/obj/item/enchantingkit/weapon/regnum
	name = "'Regnum' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long,
		/obj/item/rogueweapon/sword/long/judgement
	)
	result_item = /obj/item/rogueweapon/example/regnum

/obj/item/enchantingkit/weapon/aeternum
	name = "'Aeternum' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/greatsword,
		/obj/item/rogueweapon/greatsword/zwei,
		/obj/item/rogueweapon/greatsword/grenz,
		/obj/item/rogueweapon/greatsword/grenz/flamberge,
		/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
	)
	result_item = /obj/item/rogueweapon/example/aeternum

/obj/item/enchantingkit/weapon/darling
	name = "'Darling' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/example/darling

/obj/item/enchantingkit/weapon/sumquoderis
	name = "'Vial of Crimson Ichor'"
	target_items = list(
		/obj/item/rogueweapon/sword/long/exe
	)
	result_item = /obj/item/rogueweapon/example/sumquoderis

/obj/item/enchantingkit/weapon/euthanasia
	name = "'Ritual Dagger Mould'"
	target_items = list(
		/obj/item/rogueweapon/huntingknife/combat
	)
	result_item = /obj/item/rogueweapon/example/euthanasia

/obj/item/enchantingkit/weapon/nicksonessang
	name = "'Dark Delight' morphing elixir"
	target_items = list(/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo)
	result_item = /obj/item/rogueweapon/example/ssangsudo_long

//more koruu stuff below
/obj/item/enchantingkit/weapon/koruu_kukri_silver
	name = "'Psydonic Leachwhacker' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger,
		/obj/item/rogueweapon/huntingknife/idagger/silver

	)
	result_item = /obj/item/rogueweapon/koruu/kukri/silver

/obj/item/enchantingkit/weapon/koruu_longsword
	name = "'Excaliber' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long,
		/obj/item/rogueweapon/sword/long/dec,
		/obj/item/rogueweapon/sword/long/etruscan)
	result_item = /obj/item/rogueweapon/koruu/longsword

/obj/item/enchantingkit/weapon/koruu_etrusc
	name = "'Colada' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long,
		/obj/item/rogueweapon/sword/long/dec,
		/obj/item/rogueweapon/sword/long/etruscan)
	result_item = /obj/item/rogueweapon/koruu/etrusca

/obj/item/enchantingkit/weapon/koruu_judgement
	name = "'A Durthurian Tale' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long,
		/obj/item/rogueweapon/sword/long/dec,
		/obj/item/rogueweapon/sword/long/etruscan,
		/obj/item/rogueweapon/sword/long/judgement)
	result_item = /obj/item/rogueweapon/koruu/judgement

// Nerocavalier
/obj/item/enchantingkit/weapon/nero_lsword
	name = "Sylvan Longsword morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long,
		/obj/item/rogueweapon/sword/long/dec,
		/obj/item/rogueweapon/sword/long/ap
	)
	result_item = /obj/item/rogueweapon/example/nero_sylvanlsword

/obj/item/enchantingkit/weapon/nero_sabre
	name = "Sylvan Sabre morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/sabre,
		/obj/item/rogueweapon/sword/sabre/elf,
		/obj/item/rogueweapon/sword/sabre/dec,
		/obj/item/rogueweapon/sword/sabre/banneret
	)
	result_item = /obj/item/rogueweapon/example/nero_sylvansabre

/obj/item/enchantingkit/weapon/nero_dagger
	name = "Sylvan Dagger morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/rogueweapon/huntingknife/idagger/steel/decorated,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special
	)
	result_item = /obj/item/rogueweapon/example/nero_sylvandagger

// Desminus
/obj/item/enchantingkit/weapon/des_gaebolg
	name = "'Gae Bolg' morphing elixer"
	target_items = list(
		/obj/item/rogueweapon/spear,
		/obj/item/rogueweapon/spear/partizan,
		/obj/item/rogueweapon/halberd,
		/obj/item/rogueweapon/halberd/glaive,
		/obj/item/rogueweapon/eaglebeak
	)
	result_item = /obj/item/rogueweapon/example/des_gaebolg

// inverserun
/obj/item/enchantingkit/weapon/arra_amdir
	name = "'Amdir' morphing elixir"
	target_items = list(
	/obj/item/rogueweapon/greataxe/steel/knight,
	/obj/item/rogueweapon/greataxe/steel/knight/silver,
	/obj/item/rogueweapon/greataxe/steel/knight/psy

	)
	result_item = /obj/item/rogueweapon/example/arra_amdir

//sakuyzo
/obj/item/enchantingkit/weapon/sakuyzo
	name = "'Hævatein' morphing elixir"
	target_items = list(/obj/item/rogueweapon/sword/long/kriegmesser/noc)
	result_item = /obj/item/rogueweapon/sakuyzo/sword

// Ollanius
/obj/item/enchantingkit/ollanius_maille
	name = "'shoulderless haubergeon' morphing elixir"
	target_items = list(/obj/item/clothing/suit/roguetown/armor/chainmail)
	result_item = /obj/item/clothing/suit/roguetown/armor/chainmail/ollanius_maille

/obj/item/enchantingkit/weapon/ollanius
	name = "'azurosa-wrapped sword' morphing elixer"
	target_items = list(
		/obj/item/rogueweapon/sword/short/messer,
		/obj/item/rogueweapon/sword/short,
		/obj/item/rogueweapon/sword/sabre,
		/obj/item/rogueweapon/sword
	)
	result_item = /obj/item/rogueweapon/ollanius_sword

//Olympus7
/obj/item/enchantingkit/olygsword
    name = "'Gre'as'anto d'Shar' morphing elixir"
    target_items = list(/obj/item/rogueweapon/greatsword)
    result_item = /obj/item/rogueweapon/greatsword/olygsword

//SpartanBobby
/obj/item/enchantingkit/bobby_helm
	name = "'Holy Astratan Bascinet' morphing elixir"
	target_items = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/astratan,
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface

	)
	result_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/spartanbobby

//spaz - Armet/Hounskull/Barbute
/obj/item/enchantingkit/spaz_helm
	name = "'hound-nosed bascinet' morphing elixir"
	target_items = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/spaz,
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/spaz,
		/obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor            = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor/spaz
	)
	result_item = null

//MortoSasye - Ice Staffs
/obj/item/enchantingkit/morto_staff
	name = "'Frozen Vow' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/woodstaff/implement/grand				=	/obj/item/rogueweapon/woodstaff/implement/grand/morto,
		/obj/item/rogueweapon/woodstaff/implement/grand/magos		=	/obj/item/rogueweapon/woodstaff/implement/grand/magos/morto,
		/obj/item/rogueweapon/woodstaff/implement/greater/quartz	= 	/obj/item/rogueweapon/woodstaff/implement/greater/quartz/morto,
		/obj/item/rogueweapon/woodstaff/implement/amethyst			= 	/obj/item/rogueweapon/woodstaff/implement/amethyst/morto
	)
	result_item = null

/obj/item/enchantingkit/weapon/tyesca_sword
	name = "'Szöréndnížine montante' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long/etruscan/freifechter
	)
	result_item = /obj/item/rogueweapon/sword/long/etruscan/freifechter/tyesca

/obj/item/enchantingkit/tyesca_brigandine
	name = "'fencer's brigandine' morphing elixir"
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/tyesca,
		/obj/item/clothing/suit/roguetown/armor/brigandine/light			= /obj/item/clothing/suit/roguetown/armor/brigandine/light/tyesca
	)
	result_item = null
	exact_type = TRUE

//Racobio - Obsidian Staff
/obj/item/enchantingkit/racobio_staff
	name = "'Obsidian Tower' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/woodstaff/implement/grand
	)
	result_item = /obj/item/rogueweapon/woodstaff/implement/grand/racobio
