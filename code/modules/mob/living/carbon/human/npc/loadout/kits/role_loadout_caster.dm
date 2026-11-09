/datum/npc_loadout/kit/caster
	clear_slots = list("head", "armor", "cloak", "l_hand", "r_hand")
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	cloak = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/black = 60,
		/obj/item/clothing/suit/roguetown/shirt/robe/white = 40,
	)
	head = list(
		/obj/item/clothing/head/roguetown/roguehood/black = 70,
		NPC_NOTHING = 30,
	)
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	r_hand = /obj/item/rogueweapon/woodstaff/implement

/datum/npc_loadout/kit/caster/fulgurmancer
	cloak = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/mageblue = 50,
		/obj/item/clothing/suit/roguetown/shirt/robe/mageyellow = 50,
	)
	head = list(
		/obj/item/clothing/head/roguetown/roguehood/mageblue = 50,
		/obj/item/clothing/head/roguetown/roguehood/black = 30,
		NPC_NOTHING = 20,
	)

/datum/npc_loadout/kit/caster/pyromancer
	cloak = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/mageorange = 60,
		/obj/item/clothing/suit/roguetown/shirt/robe/black = 40,
	)
	head = list(
		/obj/item/clothing/head/roguetown/roguehood/red = 50,
		/obj/item/clothing/head/roguetown/roguehood/black = 35,
		NPC_NOTHING = 15,
	)
