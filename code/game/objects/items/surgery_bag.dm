/obj/item/storage/belt/rogue/surgery_bag
	name = "surgeon's bag"
	desc = "Made to hold everything a people-butcher will need. Contains a list of implements... what even IS a Sisrat?"
	icon = 'icons/roguetown/clothing/storage.dmi'
	mob_overlay_icon = null
	icon_state = "surgery_bag"
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE
	preload = TRUE
	component_type = /datum/component/storage/concrete/roguetown/surgery_bag
	populate_contents = list(
		/obj/item/rogueweapon/surgery/scalpel,
		/obj/item/rogueweapon/surgery/saw,
		/obj/item/rogueweapon/surgery/hemostat/first,
		/obj/item/rogueweapon/surgery/hemostat/second, //Different types for multiple surgery sites.
		/obj/item/rogueweapon/surgery/hemostat/third,
		/obj/item/rogueweapon/surgery/retractor,
		/obj/item/rogueweapon/surgery/retractor,
		/obj/item/rogueweapon/surgery/bonesetter,
		/obj/item/rogueweapon/surgery/cautery,
		/obj/item/rogueweapon/surgery/hammer,
		/obj/item/natural/bundle/cloth/bandage/full,
		/obj/item/needle
	)

/obj/item/storage/belt/rogue/surgery_bag/PopulateContents()
	for(var/path in populate_contents)
		var/obj/item/new_item = SSwardrobe.provide_type(path, loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))
			new_item.inventory_flip(null, TRUE)
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))

				SSwardrobe.recycle_object(new_item)

/obj/item/storage/belt/rogue/surgery_bag/get_types_to_preload()
	return populate_contents

/obj/item/storage/belt/rogue/surgery_bag/full/physician
	populate_contents = list(
	/obj/item/rogueweapon/surgery/scalpel,
	/obj/item/rogueweapon/surgery/saw,
	/obj/item/rogueweapon/surgery/hemostat/first,  //Different types for multiple surgery sites.
	/obj/item/rogueweapon/surgery/hemostat/second,
	/obj/item/rogueweapon/surgery/hemostat/third,
	/obj/item/rogueweapon/surgery/retractor,
	/obj/item/rogueweapon/surgery/retractor,
	/obj/item/rogueweapon/surgery/bonesetter,
	/obj/item/rogueweapon/surgery/cautery,
	/obj/item/natural/bundle/cloth/bandage/full,
	/obj/item/rogueweapon/surgery/hammer,
	/obj/item/needle/pestra //Gets the special needle!
	)

/obj/item/storage/belt/rogue/surgery_bag/full/physician/get_types_to_preload()
	return populate_contents

/obj/item/storage/belt/rogue/surgery_bag/empty
	preload = FALSE 
	
/obj/item/storage/belt/rogue/surgery_bag/empty
	populate_contents = list(
	)

/obj/item/storage/belt/rogue/pouch/medicine
	populate_contents = list(
	/obj/item/needle,
	/obj/item/natural/bundle/cloth/bandage/full,
	/obj/item/reagent_containers/glass/bottle/alchemical/healthpot
	)

/obj/item/storage/belt/rogue/pouch/medicine/get_types_to_preload()
	return populate_contents
