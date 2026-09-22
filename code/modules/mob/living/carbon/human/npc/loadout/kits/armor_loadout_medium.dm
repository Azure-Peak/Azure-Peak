//** IRON **//

/datum/npc_loadout/armor/medium
	abstract_type = /datum/npc_loadout/armor/medium

/datum/npc_loadout/armor/medium/iron_hauberk
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron

//** STEEL **//

/datum/npc_loadout/armor/medium/steel_mixed
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/brigandine/light,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
	)
	head = list(
		/obj/item/clothing/head/roguetown/helmet,
		/obj/item/clothing/head/roguetown/helmet/skullcap,
		/obj/item/clothing/head/roguetown/helmet/sallet,
	)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	pants = /obj/item/clothing/under/roguetown/brigandinelegs

//** CHAINMAIL **//

/datum/npc_loadout/armor/medium/chainmail
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/mask/rogue/facemask
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	head = list(
		/obj/item/clothing/head/roguetown/helmet/leather/volfhelm,
		/obj/item/clothing/head/roguetown/helmet/leather,
	)

//** DECREPIT ALLOY - SKELETONS **//

/datum/npc_loadout/armor/medium/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/aalloy //Legionnaire look

/datum/npc_loadout/armor/medium/aalloy_helm
	head = /obj/item/clothing/head/roguetown/helmet/kettle/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy

/datum/npc_loadout/armor/medium/aalloy_soldier
	head = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy

/datum/npc_loadout/armor/medium/aalloy_archer
	head = /obj/item/clothing/head/roguetown/helmet/kettle/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy

//** IRON CHAIN **//

/datum/npc_loadout/armor/medium/iron_chain
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	head = /obj/item/clothing/head/roguetown/helmet/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots

//** SCAVENGED **//

/datum/npc_loadout/armor/medium/scavenged
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron,
		/obj/item/clothing/suit/roguetown/armor/leather/hide,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper,
		/obj/item/clothing/suit/roguetown/armor/gambeson,
	)
	wrists = list(
		/obj/item/clothing/wrists/roguetown/bracers/leather,
		/obj/item/clothing/wrists/roguetown/bracers/copper,
	)
	pants = list(
		/obj/item/clothing/under/roguetown/chainlegs/iron,
		/obj/item/clothing/under/roguetown/chainlegs/iron/kilt,
		/obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt,
	)
	head = list( //60% of a random helmet
		/obj/item/clothing/head/roguetown/helmet/horned = 3, //SOVL
		/obj/item/clothing/head/roguetown/helmet/sallet/iron/banded = 3,
		/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = 3,
		/obj/item/clothing/head/roguetown/helmet/leather = 3,
		NPC_NOTHING = 8,
	)
	neck = list(
		/obj/item/clothing/neck/roguetown/gorget, //SOVL
		/obj/item/clothing/neck/roguetown/chaincoif/iron,
		/obj/item/clothing/neck/roguetown/bevor/iron,
	)
	gloves = list(
		/obj/item/clothing/gloves/roguetown/leather = 60,
		/obj/item/clothing/gloves/roguetown/plate/iron/banded = 40,
	)

/datum/npc_loadout/armor/medium/scavenged/archer
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	head = /obj/item/clothing/head/roguetown/helmet/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
