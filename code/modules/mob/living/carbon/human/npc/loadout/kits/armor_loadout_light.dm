//** GAMBESON **//

/datum/npc_loadout/armor/light
	abstract_type = /datum/npc_loadout/armor/light

/datum/npc_loadout/armor/light/gambeson
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather

/datum/npc_loadout/armor/light/gambeson/helmeted
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/leather = 1,
		NPC_NOTHING = 3,
	)
	head = list(
		/obj/item/clothing/head/roguetown/helmet/kettle/iron = 2,
		/obj/item/clothing/head/roguetown/helmet/sallet/iron = 1,
		/obj/item/clothing/head/roguetown/helmet/skullcap = 2,
		/obj/item/clothing/head/roguetown/armingcap = 1,
		NPC_NOTHING = 1,
	)

//** LEATHER **//

/datum/npc_loadout/armor/light/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather

/datum/npc_loadout/armor/light/leather/iron_bracers
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron

//** HIDE **//

/datum/npc_loadout/armor/light/hide
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	head = /obj/item/clothing/head/roguetown/helmet/leather

/datum/npc_loadout/armor/light/hide/mixed
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/leather/hide,
		/obj/item/clothing/suit/roguetown/armor/leather,
	)
	head = list(
		/obj/item/clothing/head/roguetown/helmet/horned = 1, //SOVL
		/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = 1,
		/obj/item/clothing/head/roguetown/helmet/leather = 1,
		NPC_NOTHING = 3,
	)

/datum/npc_loadout/armor/light/hide/gambeson
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/leather
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/mask/rogue/facemask
	shoes = /obj/item/clothing/shoes/roguetown/boots
	head = list(
		/obj/item/clothing/head/roguetown/helmet/skullcap,
		/obj/item/clothing/head/roguetown/helmet/horned,
	)

//** STUDDED **//

/datum/npc_loadout/armor/light/studded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather

//** BRIGANDINE **//

/datum/npc_loadout/armor/light/brigandine
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/brigandinelegs
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
