/obj/random/loot
	var/loot_table

/obj/random/loot/Initialize()
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
