/obj/effect/spawner/lootdrop/roguetown/sewers
	name = "sewer spawner"
	lootcount = 3
	loot = list(
		// Materials
		/obj/item/natural/bundle/stick = 4,
		/obj/item/natural/fibers = 8,
		/obj/item/natural/stone = 8,
		/obj/item/rogueore/coal	= 8,
		/obj/item/ingot/iron = 1,
		/obj/item/ingot/steel = 1,
		/obj/item/rogueore/iron = 3,
		/obj/item/natural/bundle/fibers = 4,

		// Clothing
		/obj/item/clothing/cloak/stabard = 6,
		/obj/item/storage/backpack/rogue/satchel = 3,
		/obj/item/clothing/shoes/roguetown/simpleshoes = 8,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/random = 10,
		/obj/item/storage/belt/rogue/leather/cloth = 8,
		/obj/item/clothing/cloak/raincloak/mortus = 6,
		/obj/item/clothing/head/roguetown/armingcap = 4,
		/obj/item/clothing/cloak/apron/waist = 6,
		/obj/item/storage/belt/rogue/leather/rope = 6,
		/obj/item/clothing/under/roguetown/tights/vagrant = 8,
		/obj/item/clothing/gloves/roguetown/leather = 4,
		/obj/item/clothing/shoes/roguetown/boots = 8,
		/obj/item/clothing/shoes/roguetown/boots/leather = 8,
		/obj/item/storage/belt/rogue/leather/knifebelt/iron = 1,

		// Money
		/obj/item/roguecoin/copper = 10,
		/obj/item/roguecoin/silver = 5,
		/obj/item/roguecoin/gold = 5,
		/obj/item/roguecoin/copper/pile = 3,

		// Garbage and Miscellanous
		/obj/item/rogue/instrument/flute = 3,
		/obj/item/ash = 5,
		/obj/item/natural/glass_shard = 5,
		/obj/item/candle/yellow = 3,
		/obj/item/flashlight/flare/torch = 3,
		/obj/item/reagent_containers/glass/bowl = 4,
		/obj/item/reagent_containers/glass/cup = 4,
		/obj/item/reagent_containers/glass/cup/wooden = 4,
		/obj/item/reagent_containers/glass/cup/steel = 3,
		/obj/item/reagent_containers/glass/cup/golden = 1,
		/obj/item/reagent_containers/glass/cup/skull = 1,
		/obj/item/reagent_containers/glass/bucket = 6,
		/obj/item/natural/feather = 8,
		/obj/item/paper/scroll = 6,
		/obj/item/rope = 6,
		/obj/item/rope/chain = 6,
		/obj/item/storage/roguebag/crafted = 3,
		/obj/item/clothing/mask/cigarette/pipe = 6,
		/obj/item/paper = 6,
		/obj/item/reagent_containers/glass/bowl = 6,
		/obj/item/storage/bag/tray = 6,
		/obj/item/mundane/puzzlebox/medium = 2,
		/obj/item/mundane/puzzlebox/easy = 4,

		//medical
		/obj/item/needle = 4,
		/obj/item/natural/cloth = 10,
		/obj/item/natural/bundle/cloth = 3,

		//weapons
		/obj/item/rogueweapon/mace = 2,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 3,
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow = 2,
		/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 2,
		/obj/item/ammo_casing/caseless/rogue/arrow/iron = 4,
		/obj/item/ammo_casing/caseless/rogue/bolt = 4,
		/obj/item/rogueweapon/mace/woodclub/crafted = 3,
		/obj/item/rogueweapon/mace/cudgel = 2,
		/obj/item/rogueweapon/mace/wsword = 6,
		/obj/item/rogueweapon/huntingknife = 3,
		/obj/item/rogueweapon/huntingknife/stoneknife = 6,
		/obj/item/rogueweapon/halberd = 1,
		/obj/item/rogueweapon/woodstaff = 3,
		/obj/item/rogueweapon/spear = 1,
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,

		// tools
		/obj/item/rogueweapon/shovel = 6,
		/obj/item/rogueweapon/thresher = 6,
		/obj/item/flint = 8,
		/obj/item/rogueweapon/stoneaxe/woodcut = 3,
		/obj/item/rogueweapon/stoneaxe = 6,
		/obj/item/rogueweapon/hammer/stone = 6,
		/obj/item/rogueweapon/tongs = 6,
		/obj/item/rogueweapon/pick = 3,

		//armor
		/obj/item/clothing/suit/roguetown/armor/leather/studded = 2,
		/obj/item/clothing/suit/roguetown/armor/gambeson = 2,
		/obj/item/clothing/under/roguetown/chainlegs = 2,
		/obj/item/clothing/gloves/roguetown/chain = 2,
		/obj/item/clothing/suit/roguetown/armor/chainmail = 1,
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 2,
		/obj/item/clothing/neck/roguetown/gorget = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 1,
		/obj/item/clothing/head/roguetown/helmet/kettle = 1,
		/obj/item/clothing/head/roguetown/helmet/leather = 2,
		/obj/item/clothing/head/roguetown/helmet/horned = 1,
		/obj/item/clothing/head/roguetown/helmet/skullcap = 1,
		/obj/item/clothing/head/roguetown/helmet/winged = 1,


		//food
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked = 3,
		/obj/item/reagent_containers/food/snacks/butterslice = 6, //ew
		/obj/item/reagent_containers/powder/salt = 6,
		/obj/item/reagent_containers/food/snacks/egg = 6,

	)


///////////////////////
///    TOP-LEFT     ///
/// Size: X:26 Y:20 ///
///////////////////////

/obj/effect/landmark/map_load_mark/sewers_topleft
	name = "Sewers Top-Left Section"
	templates = list("sewers_topleft_1", "sewers_topleft_2", "sewers_topleft_3", "sewers_topleft_4")

/// Little prison
/datum/map_template/sewers_topleft_1
	name = "Sewers Top-Left Variant 1"
	id = "sewers_topleft_1"
	mappath = "_maps/map_files/templates/sewers/sewers_topleft_1.dmm"

///  Abandoned warehouse
/datum/map_template/sewers_topleft_2
	name = "Sewers Top-Left Variant 2"
	id = "sewers_topleft_2"
	mappath = "_maps/map_files/templates/sewers/sewers_topleft_2.dmm"

/// Beggar base
/datum/map_template/sewers_topleft_3
	name = "Sewers Top-Left Variant 3"
	id = "sewers_topleft_3"
	mappath = "_maps/map_files/templates/sewers/sewers_topleft_3.dmm"

/// More sewer tunnels
/datum/map_template/sewers_topleft_4
	name = "Sewers Top-Left Variant 4"
	id = "sewers_topleft_4"
	mappath = "_maps/map_files/templates/sewers/sewers_topleft_4.dmm"

///////////////////////
///   BOTTOM-LEFT   ///
/// Size: X:26 Y:18 ///
///////////////////////

/obj/effect/landmark/map_load_mark/sewers_bottomleft
	name = "Sewers Bottom-Left Section"
	templates = list("sewers_bottomleft_1", "sewers_bottomleft_2", "sewers_bottomleft_3")

/// Flooded large room
/datum/map_template/sewers_bottomleft_1
	name = "Sewers Bottom-Left Variant 1"
	id = "sewers_bottomleft_1"
	mappath = "_maps/map_files/templates/sewers/sewers_bottomleft_1.dmm"

///  Metalworking area
/datum/map_template/sewers_bottomleft_2
	name = "Sewers Bottom-Left Variant 2"
	id = "sewers_bottomleft_2"
	mappath = "_maps/map_files/templates/sewers/sewers_bottomleft_2.dmm"

/// More sewer tunnels
/datum/map_template/sewers_bottomleft_3
	name = "Sewers Bottom-Left Variant 3"
	id = "sewers_bottomleft_3"
	mappath = "_maps/map_files/templates/sewers/sewers_bottomleft_3.dmm"

///////////////////////
///     CENTRE      ///
/// Size: X:14 Y:21 ///
///////////////////////

/obj/effect/landmark/map_load_mark/sewers_centre
	name = "Sewers Centre Section"
	templates = list("sewers_centre_1", "sewers_centre_2")

/// More sewer tunnels
/datum/map_template/sewers_centre_1
	name = "Sewers Centre Variant 1"
	id = "sewers_centre_1"
	mappath = "_maps/map_files/templates/sewers/sewers_centre_1.dmm"

/// Small rooms
/datum/map_template/sewers_centre_2
	name = "Sewers Centre Variant 2"
	id = "sewers_centre_2"
	mappath = "_maps/map_files/templates/sewers/sewers_centre_2.dmm"


///////////////////////
///     BOTTOM      ///
/// Size: X:15 Y:5  ///
///////////////////////

/obj/effect/landmark/map_load_mark/sewers_bottom
	name = "Sewers Bottom Section"
	templates = list("sewers_bottom_1", "sewers_bottom_2")

/// Small hobo camp
/datum/map_template/sewers_bottom_1
	name = "Sewers Centre Variant 1"
	id = "sewers_bottom_1"
	mappath = "_maps/map_files/templates/sewers/sewers_bottom_1.dmm"

/// Small side ruin
/datum/map_template/sewers_bottom_2
	name = "Sewers Bottom Variant 2"
	id = "sewers_bottom_2"
	mappath = "_maps/map_files/templates/sewers/sewers_bottom_2.dmm"

///////////////////////
///   BOTTOM-RIGHT  ///
/// Size: X:19 Y:11 ///
///////////////////////

/obj/effect/landmark/map_load_mark/sewers_bottomright
	name = "Sewers Bottom-Right Section"
	templates = list("sewers_bottomright_1", "sewers_bottomright_2")

/// Cultist hideout
/datum/map_template/sewers_bottomright_1
	name = "Sewers Bottom-Right Variant 1"
	id = "sewers_bottomright_1"
	mappath = "_maps/map_files/templates/sewers/sewers_bottomright_1.dmm"

/// Mortuary
/datum/map_template/sewers_bottomright_2
	name = "Sewers Bottom-Right Variant 2"
	id = "sewers_bottomright_2"
	mappath = "_maps/map_files/templates/sewers/sewers_bottomright_2.dmm"


///////////////////////
///      RIGHT      ///
/// Size: X:5 Y:8   ///
///////////////////////

/obj/effect/landmark/map_load_mark/sewers_right
	name = "Sewers Right Section"
	templates = list("sewers_right_1", "sewers_right_2")

/// Small hobo camp
/datum/map_template/sewers_right_1
	name = "Sewers Right Variant 1"
	id = "sewers_right_1"
	mappath = "_maps/map_files/templates/sewers/sewers_right_1.dmm"

/// Skeleton closet
/datum/map_template/sewers_right_2
	name = "Sewers Right Variant 2"
	id = "sewers_right_2"
	mappath = "_maps/map_files/templates/sewers/sewers_right_2.dmm"


///////////////////////
///      TOP        ///
/// Size: X:13 Y:11 ///
///////////////////////

/obj/effect/landmark/map_load_mark/sewers_top
	name = "Sewers Top Section"
	templates = list("sewers_top_1", "sewers_top_2")

/// More tunnels
/datum/map_template/sewers_top_1
	name = "Sewers Top Variant 1"
	id = "sewers_top_1"
	mappath = "_maps/map_files/templates/sewers/sewers_top_1.dmm"

/// Pipe room
/datum/map_template/sewers_top_2
	name = "Sewers Top Variant 2"
	id = "sewers_top_2"
	mappath = "_maps/map_files/templates/sewers/sewers_top_2.dmm"
