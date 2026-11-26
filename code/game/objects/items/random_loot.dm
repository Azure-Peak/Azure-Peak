/obj/random/loot
	var/loot_table

/obj/random/loot/Initialize(mapload)
	. = ..()
	icon_state = null
	pick_loot(loc)
	qdel(src)

/obj/random/loot/proc/pick_loot(turf/T)
	var/item_to_spawn = pickweight(loot_table)
	new item_to_spawn(get_turf(src))
	qdel(src)

/obj/random/loot/spider_cave
	loot_table = list(
		/obj/item/rogueweapon/greataxe/dreamscape = 99,
		/obj/item/rogueweapon/greataxe/dreamscape/active = 1,
		/obj/item/clothing/neck/roguetown/leather = 150,
		/obj/item/clothing/neck/roguetown/chaincoif = 100,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass = 50,
		/obj/item/clothing/head/roguetown/helmet/heavy/volfplate = 100,
		/obj/item/rogueweapon/mace/warhammer/steel/silver = 100,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 150,
		/obj/item/clothing/gloves/roguetown/plate = 75,
		/obj/item/clothing/under/roguetown/platelegs = 75,
		/obj/item/clothing/head/roguetown/helmet/bascinet = 100
		)

/obj/random/loot/ingots
	loot_table = list(
		/obj/item/ingot/copper = 2,
		/obj/item/ingot/tin = 2,
		/obj/item/ingot/bronze = 10,
		/obj/item/ingot/iron = 10,
		/obj/item/ingot/steel = 15,
		/obj/item/ingot/gold = 15,
		/obj/item/ingot/blacksteel = 10,
		/obj/item/ingot/steelholy = 3,
		/obj/item/ingot/silver = 15,
		/obj/item/ingot/silverblessed = 3,
		/obj/item/ingot/lithmyc = 5,
		/obj/item/ingot/purifiedaalloy = 5,
		/obj/item/ingot/aalloy = 2
		)
