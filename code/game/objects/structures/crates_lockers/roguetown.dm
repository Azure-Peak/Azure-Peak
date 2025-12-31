/obj/structure/closet/crate/chest
	name = "chest"
	desc = "A wooden chest with a lid held on metal hinges."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "chest3s"
	base_icon_state = "chest3s"
	drag_slowdown = 2
	open_sound = 'sound/misc/chestopen.ogg'
	close_sound = 'sound/misc/chestclose.ogg'
	keylock = TRUE
	locked = FALSE
	sellprice = 1
	max_integrity = 200
	blade_dulling = DULLING_BASHCHOP
	mob_storage_capacity = 1
	allow_dense = FALSE

/obj/structure/closet/crate/chest/gold
	icon_state = "chest3"
	base_icon_state = "chest3"

/obj/structure/closet/crate/chest/inqreliquary
	name = "otavan reliquary"
	desc = "A foreboding red chest with a intricate lock design. It seems to only fit a very specific key. Choose wisely."
	icon_state = "chestweird1"
	base_icon_state = "chestweird1"

/obj/structure/closet/crate/chest/inqcrate
	name = "otavan chest"
	desc = "A foreboding red chest with black dye-washed silver embellishments."
	icon_state = "chestweird2"
	base_icon_state = "chestweird2"	

//obj/structure/closet/crate/chest/Initialize(mapload)
//	. = ..()
//	base_icon_state = "chestweird2"
//	update_icon()

/obj/structure/closet/crate/chest/merchant
	lockid = "shop"
	locked = TRUE
	masterkey = TRUE

/obj/structure/closet/crate/chest/lootbox/PopulateContents()
	var/list/loot = list(/obj/item/cooking/pan=33,
		/obj/item/bomb=6,
		/obj/item/rogueweapon/huntingknife/idagger=33,
		/obj/item/clothing/suit/roguetown/armor/gambeson=33,
		/obj/item/clothing/suit/roguetown/armor/leather=33,
		/obj/item/roguestatue/gold/loot=1,
		/obj/item/ingot/iron=22,
		/obj/item/rogueweapon/huntingknife/cleaver=22,
		/obj/item/rogueweapon/mace=22,
		/obj/item/clothing/cloak/raincloak/mortus=22,
		/obj/item/reagent_containers/food/snacks/butter=22,
		/obj/item/clothing/mask/cigarette/pipe=10,
		/obj/item/clothing/mask/cigarette/pipe/westman=10,
		/obj/item/storage/backpack/rogue/satchel=33,
		/obj/item/storage/roguebag=33,
		/obj/item/roguegem/ruby=1,
		/obj/item/roguegem/blue=2,
		/obj/item/roguegem/violet=4,
		/obj/item/roguegem/green=6,
		/obj/item/roguegem/yellow=10,
		/obj/item/roguecoin/silver/pile=4,
		/obj/item/rogueweapon/pick=23,
		/obj/item/riddleofsteel=2,
		/obj/item/clothing/neck/roguetown/talkstone=2)
	if(prob(70))
		var/I = pickweight(loot)
		new I(src)

/obj/structure/closet/crate/roguecloset
	name = "closet"
	desc = "A simple wooden closet, used to store whatever it is you would like out of sight."
	icon = 'icons/roguetown/misc/structure.dmi'
	base_icon_state = "closet"
	icon_state = "closet"
	drag_slowdown = 4
	horizontal = FALSE
	allow_dense = FALSE
	open_sound = 'sound/foley/doors/creak.ogg'
	close_sound = 'sound/foley/latch.ogg'
	max_integrity = 200
	blade_dulling = DULLING_BASHCHOP
	dense_when_open = FALSE
	mob_storage_capacity = 2

/obj/structure/closet/crate/roguecloset/inn/south
	base_icon_state = "closet3"
	icon_state = "closet3"
	dir = SOUTH
	pixel_y = 16

/obj/structure/closet/crate/roguecloset/inn
	base_icon_state = "closet3"
	icon_state = "closet3"

/obj/structure/closet/crate/roguecloset/inn/chest
	base_icon_state = "woodchest"
	icon_state = "woodchest"

/obj/structure/closet/crate/roguecloset/dark
	base_icon_state = "closetdark"
	icon_state = "closetdark"

/obj/structure/closet/crate/roguecloset/lord
	desc = "An unusually ornate closet, fit for a lord!"
	keylock = TRUE
	lockid = "lord"
	locked = TRUE
	masterkey = TRUE
	base_icon_state = "closetlord"
	icon_state = "closetlord"

/obj/structure/closet/crate/drawer
	name = "drawer"
	desc = "A wooden drawer."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "drawer5"
	base_icon_state = "drawer5"
	drag_slowdown = 2
	open_sound = 'sound/misc/chestopen.ogg'
	close_sound = 'sound/misc/chestclose.ogg'
	keylock = FALSE
	locked = FALSE
	sellprice = 1
	max_integrity = 50
	blade_dulling = DULLING_BASHCHOP
	mob_storage_capacity = 1
	allow_dense = FALSE

/obj/structure/closet/crate/drawer/inn
	name = "drawer"
	desc = "A wooden drawer."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "drawer5"
	base_icon_state = "drawer5"
	dir = SOUTH
	pixel_y = 16

//Stonekeep port
/obj/structure/closet/crate/chest/crate
	name = "crate"
	base_icon_state = "woodchest"
	icon_state = "woodchest"

/obj/structure/closet/crate/chest/wicker
	name = "wicker basket"
	desc = "Fibers interwoven to make a cheap storage bin."
	base_icon_state = "wicker"
	icon_state = "wicker"
	open_sound = 'sound/items/book_open.ogg'
	open_sound = 'sound/items/book_close.ogg'
	close_sound = 'sound/items/book_close.ogg'

/obj/structure/closet/crate/chest/neu
	name = "sturdy oak chest"
	icon_state = "chest_neu"
	base_icon_state = "chest_neu"

/obj/structure/closet/crate/chest/neu_iron
	name = "reinforced chest"
	icon_state = "chestiron_neu"
	base_icon_state = "chestiron_neu"

/obj/structure/closet/crate/chest/neu_fancy
	name = "fancy chest"
	icon_state = "chestfancy_neu"
	base_icon_state = "chestfancy_neu"

/obj/structure/closet/crate/chest/old_crate
	name = "old crate"
	base_icon_state = "woodchestalt"
	icon_state = "woodchestalt"

/obj/structure/closet/crate/drawer/random
	icon_state = "drawer1"
	base_icon_state = "drawer1"
	pixel_y = 8

/obj/structure/closet/crate/drawer/random/Initialize()
	. = ..()
	if(icon_state == "drawer1")
		base_icon_state = "drawer[rand(1,4)]"
		icon_state = "[base_icon_state]"
	else
		base_icon_state = "drawer1"
		pixel_y = 8
/**
 * Closet preset for the duke ().
 * When opened for the first time by the ruler mob - spawns the blacksteel armor set.
 * Done to prevent nobles taking regency just to loot blacksteel
*/
/obj/structure/closet/crate/roguecloset/lord/duke_preset
	desc = "Covered in strange runic symbols that seem to pulse with some sort of energy in the dark."
	/// Set to TRUE after it has spawned the gear.
	var/has_spawned_gear = FALSE

/obj/structure/closet/crate/roguecloset/lord/duke_preset/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_TICKER_RULERMOB_SET, PROC_REF(spawn_blacksteel))

/obj/structure/closet/crate/roguecloset/lord/duke_preset/Destroy()
	UnregisterSignal(SSdcs, COMSIG_TICKER_RULERMOB_SET)
	return ..()

/obj/structure/closet/crate/roguecloset/lord/duke_preset/proc/spawn_blacksteel(mob/living/user)
	if(has_spawned_gear)
		return

	new /obj/item/rogueweapon/sword/long/judgement(get_turf(src))
	new /obj/item/clothing/wrists/roguetown/bracers(get_turf(src))
	new /obj/item/clothing/neck/roguetown/gorget/steel(get_turf(src))
	new /obj/item/storage/belt/rogue/leather/steel/tasset(get_turf(src))
	new /obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves(get_turf(src))
	new /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet(get_turf(src))
	new /obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots(get_turf(src))
	new /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern(get_turf(src))
	new /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern(get_turf(src))
	has_spawned_gear = TRUE
	close()
