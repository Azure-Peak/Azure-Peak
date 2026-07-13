/datum/crafting_recipe/roguetown/survival/net
	name = "net"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/net
	craftdiff = 2
	reqs = list(
		/obj/item/rope = 2,
		/obj/item/natural/stone = 3,
		)
	verbage_simple = "braid"
	verbage = "braids"

/datum/crafting_recipe/roguetown/survival/bowstring
	name = "fiber bowstring"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/natural/bowstring
	reqs = list(/obj/item/natural/fibers = 2)
	verbage_simple = "twist"
	verbage = "twists"

/datum/crafting_recipe/roguetown/survival/bowpartial
	name = "unstrung bow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/grown/log/tree/bowpartial
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tools = /obj/item/rogueweapon/huntingknife
	verbage_simple = "carve"
	verbage = "carves"

/datum/crafting_recipe/roguetown/survival/bow
	name = "wooden bow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	reqs = list(
		/obj/item/natural/bowstring = 1,
		/obj/item/grown/log/tree/bowpartial = 1,
		)
	verbage_simple = "string together"
	verbage = "strings together"
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/recurvepartial
	name = "unstrung recurve bow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/grown/log/tree/bowpartial/recurve
	reqs = list(
		/obj/item/grown/log/tree = 1,
		/obj/item/natural/bone = 2,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 2,
		)
	tools = /obj/item/rogueweapon/huntingknife
	verbage_simple = "carve"
	verbage = "carves"
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/recurvebow
	name = "recurve bow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	reqs = list(
		/obj/item/natural/bowstring = 1,
		/obj/item/grown/log/tree/bowpartial/recurve = 1,
		)
	verbage_simple = "string together"
	verbage = "strings together"
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/longbowpartial
	name = "unstrung long bow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/grown/log/tree/bowpartial/longbow
	reqs = list(
		/obj/item/grown/log/tree = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 2,
		)
	tools = /obj/item/rogueweapon/huntingknife
	verbage_simple = "carve"
	verbage = "carves"
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/longbow
	name = "long bow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	reqs = list(
		/obj/item/natural/bowstring = 1,
		/obj/item/grown/log/tree/bowpartial/longbow = 1,
		)
	verbage_simple = "string together"
	verbage = "strings together"
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/longbow_warden
	name = "blackhorn longbow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
	reqs = list(
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow = 1,
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden = 1,
	)
	verbage_simple = "re-string"
	verbage = "re-strings"
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/stonearrow
	name = "stone arrow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/stone = 1,
		)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/stonearrow_five
	name = "stone arrow (x5)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/stone,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone
		)
	reqs = list(
		/obj/item/grown/log/tree/stick = 5,
		/obj/item/natural/stone = 5,
		)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/bluntarrow
	name = "blunt arrow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/blunt
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/stone = 1,
	)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/bluntarrow_five
	name = "blunt arrow (x5)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/blunt,
		/obj/item/ammo_casing/caseless/rogue/arrow/blunt,
		/obj/item/ammo_casing/caseless/rogue/arrow/blunt,
		/obj/item/ammo_casing/caseless/rogue/arrow/blunt,
		/obj/item/ammo_casing/caseless/rogue/arrow/blunt,
	)
	reqs = list(
		/obj/item/grown/log/tree/stick = 5,
		/obj/item/natural/stone = 5,
		)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/poisonarrow
	name = "poisoned arrow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/poison
	reqs = list(
				/obj/item/ammo_casing/caseless/rogue/arrow/iron = 1,
				/datum/reagent/stampoison = 5
				)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/blessedbolt
	name = "holy water bolt"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/holy
	reqs = list(
				/obj/item/ammo_casing/caseless/rogue/bolt = 1,
				/datum/reagent/water/blessed = 5
				)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/poisonarrow_stone
	name = "poisoned stone arrow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/stone/poison
	reqs = list(
				/obj/item/ammo_casing/caseless/rogue/arrow/stone = 1,
				/datum/reagent/stampoison = 5
				)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/poisonarrow_five //Arrows and bolts can be smithed in batches of five. Makes sense for them to be dipped in batches of five, too
	name = "poisoned arrow (x5)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/poison,
		)
	reqs = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/iron = 5,
		/datum/reagent/stampoison = 25,
		)

	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/poisonarrow_five_stone
	name = "poisoned stone arrow (x5)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison,
		)
	reqs = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/stone = 5,
		/datum/reagent/stampoison = 25,
		)

	req_table = TRUE


/datum/crafting_recipe/roguetown/survival/waterbolt_ten
	name = "water bolt (x10)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
	)
	reqs = list(
		/obj/item/natural/glass_shard = 1,
		/obj/item/grown/log/tree/stick = 10,
		)
	req_table = TRUE
	craftdiff = 0
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/survival/waterbolt_twenty
	name = "water bolt (x20)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		)
	reqs = list(
		/obj/item/natural/glass_shard = 2,
		/obj/item/grown/log/tree/stick = 10,
		)
	req_table = TRUE
	craftdiff = 0
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/survival/waterarrow_ten
	name = "water arrow (x10)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		)
	reqs = list(
		/obj/item/natural/glass_shard = 1,
		/obj/item/grown/log/tree/stick = 10,
		)
	req_table = TRUE
	craftdiff = 0
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/survival/waterarrow_twenty
	name = "water arrow (x20)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		)
	reqs = list(
		/obj/item/natural/glass_shard = 2,
		/obj/item/grown/log/tree/stick = 20,
		)
	req_table = TRUE
	craftdiff = 0
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/survival/iron_slingbullets
	name = "hammered iron sling bullets (x10)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron,
	)
	reqs = list(/obj/item/ingot/iron = 1)
	tools = list(/obj/item/rogueweapon/hammer)
	req_table = TRUE
	craftdiff = 2
	skillcraft = /datum/skill/craft/engineering
	verbage_simple = "hammer out"
	verbage = "hammers out"

/datum/crafting_recipe/roguetown/survival/steel_scattershot
	name = "hammered steel scattershot (x10)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot,
	)
	reqs = list(/obj/item/ingot/steel = 1)
	tools = list(/obj/item/rogueweapon/hammer)
	req_table = TRUE
	craftdiff = 3
	skillcraft = /datum/skill/craft/engineering
	verbage_simple = "hammer out"
	verbage = "hammers out"

/datum/crafting_recipe/roguetown/survival/heavy_sling_bullet
	name = "heavy sling bullet (x2)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/heavy_sling_bullet,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/heavy_sling_bullet,
	)
	reqs = list(/obj/item/natural/stone = 3)
	req_table = TRUE
	verbage_simple = "shape"
	verbage = "shapes"
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/fire_pot
	name = "fire pot (x4)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/fire_pot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/fire_pot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/fire_pot,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/fire_pot,
	)
	reqs = list(
		/obj/item/alch/firedust = 1,
		/obj/item/natural/clay = 1,
	)
	req_table = TRUE
	craftdiff = 3
	skillcraft = /datum/skill/craft/alchemy
	verbage_simple = "prepare"
	verbage = "prepares"

/datum/crafting_recipe/roguetown/survival/runicflask
	name = "runic tincture flask"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/runicflask/charged
	reqs = list(
		/obj/item/alch/firedust = 2,
		/obj/item/alch/waterdust = 2,
		/obj/item/natural/hide/cured = 2,
	)
	req_table = TRUE
	craftdiff = 4
	skillcraft = /datum/skill/craft/alchemy
	verbage_simple = "assemble"
	verbage = "assembles"

/datum/crafting_recipe/roguetown/survival/slingcraft
	name = "sling"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
	reqs = list(/obj/item/natural/fibers = 6)
	verbage_simple = "twist"
	verbage = "twists"
	craftdiff = 1 //you should make some ammo first!
	
/datum/crafting_recipe/roguetown/survival/slingpouchcraft
	name = "sling bullet pouch"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = /obj/item/quiver/sling/
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/cloth = 1,
		)
	verbage_simple = "craft"
	verbage = "crafts"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/stonebullets
	name = "sling bullets - stone (x2)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		)
	reqs = list(/obj/item/natural/stone = 1)
	verbage_simple = "smooth"
	verbage = "smooths"
	craftdiff = 0
	
/datum/crafting_recipe/roguetown/survival/stonebullets10x
	name = "sling bullets - stone (x10)"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Ranged"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		)
	reqs = list(/obj/item/natural/stone = 5)
	verbage_simple = "smooth"
	verbage = "smooths"
	craftdiff = 0

//

/datum/crafting_recipe/roguetown/survival/heattreat_silverstake
	name = "heat-treat silver stake into silver shotstakes (x3)"
	result = list(
				/obj/item/ammo_casing/caseless/rogue/stake/silver,
				/obj/item/ammo_casing/caseless/rogue/stake/silver,
				/obj/item/ammo_casing/caseless/rogue/stake/silver,
				)
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger/silver/stake = 1)
	structurecraft = /obj/machinery/light/rogue
	craftdiff = 0
	craftsound = 'sound/misc/frying.ogg'
	verbage_simple = "heat-treat"
	verbage = "heat-treats"

/datum/crafting_recipe/roguetown/survival/heattreat_otavanstake
	name = "heat-treat otavan stake into silver shotstakes (x3)"
	result = list(
				/obj/item/ammo_casing/caseless/rogue/stake/silver,
				/obj/item/ammo_casing/caseless/rogue/stake/silver,
				/obj/item/ammo_casing/caseless/rogue/stake/silver,
				)
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger/silver/stake/psy = 1)
	structurecraft = /obj/machinery/light/rogue
	craftdiff = 0
	craftsound = 'sound/misc/frying.ogg'
	verbage_simple = "heat-treat"
	verbage = "heat-treats"

/datum/crafting_recipe/roguetown/survival/heattreat_sharpstake
	name = "heat-treat sharpened stake into shotstakes (x3)"
	result = list(
				/obj/item/ammo_casing/caseless/rogue/stake,
				/obj/item/ammo_casing/caseless/rogue/stake,
				/obj/item/ammo_casing/caseless/rogue/stake,
				)
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger/stake = 1)
	structurecraft = /obj/machinery/light/rogue
	craftdiff = 0
	craftsound = 'sound/misc/frying.ogg'
	verbage_simple = "heat-treat"
	verbage = "heat-treats"

/datum/crafting_recipe/roguetown/survival/heattreat_stake
	name = "heat-treat stake into shotstake"
	result = list(
				/obj/item/ammo_casing/caseless/rogue/stake,
				)
	reqs = list(/obj/item/grown/log/tree/stake = 1)
	structurecraft = /obj/machinery/light/rogue
	craftdiff = 0
	craftsound = 'sound/misc/frying.ogg'
	verbage_simple = "heat-treat"
	verbage = "heat-treats"

//
