/obj/structure/loot/pile
	name = "loot pile"
	desc = "Looters don't read, and readers don't loot"
	icon = 'icons/roguetown/mob/monster/wraith.dmi'
	icon_state = "hauntpile"
	layer = ABOVE_ALL_MOB_LAYER
	blade_dulling = DULLING_CUT
	max_integrity = 0
	climbable = FALSE
	dir = SOUTH
	debris = list()
	var/list/loot = list()
/obj/structure/loot/pile/coins/Initialize()
	var/i
	var/lootnumber = 1
	for(i=0, i<lootnumber, i++)
		loot.Add(pickweight(list(/obj/item/storage/belt/rogue/pouch/coins/poor/ = 10,
		/obj/item/storage/belt/rogue/pouch/coins/mid/ = 5,
		/obj/item/storage/belt/rogue/pouch/coins/rich/ = 1)))
	return ..()

/obj/structure/loot/pile/gear/Initialize()
	var/i
	var/lootnumber = 1
	for(i=0, i<lootnumber, i++)
		loot.Add(pickweight(list(
		/obj/item/rogueweapon/mace = 10,
		/obj/item/rogueweapon/sword = 10,
		/obj/item/clothing/suit/roguetown/armor/leather/hide = 5,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 5,
		/obj/item/clothing/head/roguetown/helmet/leather = 5,
		/obj/item/clothing/suit/roguetown/armor/leather/studded = 2,
		/obj/item/clothing/suit/roguetown/armor/plate/full = 1,
		/obj/item/clothing/head/roguetown/helmet/kettle = 3,
		/obj/item/clothing/head/roguetown/helmet/heavy/knight = 1)))
	return ..()

/obj/structure/loot/pile/spells/Initialize()
	var/i
	var/lootnumber = 1
	for(i=0, i<lootnumber, i++)
		loot.Add(pickweight(list(
		/obj/item/book/granter/spell/blackstone/fetch = 10,
		/obj/item/book/granter/spell/blackstone/lightning = 5,
		/obj/item/book/granter/spell/blackstone/fireball = 5,
		/obj/item/book/granter/spell/blackstone/sicknessray = 5,
		/obj/item/book/granter/spell/blackstone/bonechill = 3,
		/obj/item/book/granter/spell/blackstone/skeleton = 3,
		/obj/item/book/granter/spell/blackstone/invisibility = 3,
		/obj/item/book/granter/spell/blackstone/greaterfireball = 2)))
	return ..()

/obj/structure/loot/pile/attack_hand(mob/user)
	if(loot.len)
		var/obj/item/B = pick_n_take(loot)
		if(B)
			B = new B(user.loc)
			user.put_in_hands(B)
			user.visible_message(span_notice("[user] finds [B] in the [src]."))
			if(!loot.len)
				qdel(src)
			return
	else qdel(src)
	return
