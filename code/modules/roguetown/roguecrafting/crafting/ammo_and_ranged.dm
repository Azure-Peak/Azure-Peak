/datum/crafting_recipe/roguetown/survival/net
	name = "net"
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
	category = "Ranged"
	result = /obj/item/natural/bowstring
	reqs = list(/obj/item/natural/fibers = 2)
	verbage_simple = "twist"
	verbage = "twists"

/datum/crafting_recipe/roguetown/survival/bowpartial
	name = "unstrung bow"
	category = "Ranged"
	result = /obj/item/grown/log/tree/bowpartial
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tools = /obj/item/rogueweapon/huntingknife
	verbage_simple = "carve"
	verbage = "carves"

/datum/crafting_recipe/roguetown/survival/bow
	name = "wooden bow"
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
	category = "Ranged"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/stone = 1,
		)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/stonearrow_five
	name = "stone arrow (x5)"
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
	category = "Ranged"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/blunt
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/stone = 1,
	)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/bluntarrow_five
	name = "blunt arrow (x5)"
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
	category = "Ranged"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/poison
	reqs = list(
				/obj/item/ammo_casing/caseless/rogue/arrow/iron = 1,
				/datum/reagent/stampoison = 5
				)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/blessedbolt
	name = "holy water bolt"
	category = "Ranged"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/holy
	reqs = list(
				/obj/item/ammo_casing/caseless/rogue/bolt = 1,
				/datum/reagent/water/blessed = 5
				)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/poisonarrow_stone
	name = "poisoned stone arrow"
	category = "Ranged"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/stone/poison
	reqs = list(
				/obj/item/ammo_casing/caseless/rogue/arrow/stone = 1,
				/datum/reagent/stampoison = 5
				)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/poisonarrow_five //Arrows and bolts can be smithed in batches of five. Makes sense for them to be dipped in batches of five, too
	name = "poisoned arrow (x5)"
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

/datum/crafting_recipe/roguetown/survival/slingcraft
	name = "sling"
	category = "Ranged"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
	reqs = list(/obj/item/natural/fibers = 6)
	verbage_simple = "twist"
	verbage = "twists"
	craftdiff = 1 //you should make some ammo first!
	
/datum/crafting_recipe/roguetown/survival/slingpouchcraft
	name = "sling bullet pouch"
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
