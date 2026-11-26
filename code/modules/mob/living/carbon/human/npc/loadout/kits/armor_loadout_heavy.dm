//** IRON CHAIN **//

/datum/npc_loadout/armor/heavy
	abstract_type = /datum/npc_loadout/armor/heavy

/datum/npc_loadout/armor/heavy/iron_chain
	abstract_type = /datum/npc_loadout/armor/heavy/iron_chain
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	belt = /obj/item/storage/belt/rogue/leather

/datum/npc_loadout/armor/heavy/iron_chain/iron_plate
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron

/datum/npc_loadout/armor/heavy/iron_chain/cuirass
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron

// Marksmen will not wear a close helm
/datum/npc_loadout/armor/heavy/iron_chain/cuirass/open_helm
	head = list(
		/obj/item/clothing/head/roguetown/helmet/kettle/iron = 50,
		/obj/item/clothing/head/roguetown/helmet/sallet/iron = 50,
	)

/datum/npc_loadout/armor/heavy/iron_chain/full_plate
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full

/datum/npc_loadout/armor/heavy/iron_chain/full_plate/iron_coif
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron

/datum/npc_loadout/armor/heavy/iron_chain/mixed_plate
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron,
		/obj/item/clothing/suit/roguetown/armor/plate/scale,
	)
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle

/datum/npc_loadout/armor/heavy/iron_chain/scale
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/iron
	head = /obj/item/clothing/head/roguetown/helmet/sallet/iron/banded
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron/banded

//** BANDED IRON **//

/datum/npc_loadout/armor/heavy/banded_iron
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron/banded
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	head = /obj/item/clothing/head/roguetown/helmet/sallet/iron/banded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced //Stays cause this is slightly-higher-ended
	neck = list(
		/obj/item/clothing/neck/roguetown/gorget, //SOVL
		/obj/item/clothing/neck/roguetown/chaincoif/iron,
		/obj/item/clothing/neck/roguetown/bevor/iron,
	)

//** DeCREPIT ALLOY - SKELETONS **//

/datum/npc_loadout/armor/heavy/decrepit
	pants = /obj/item/clothing/under/roguetown/platelegs/ancient/decrepit
	shoes = /obj/item/clothing/shoes/roguetown/boots/ancient/decrepit
	neck = /obj/item/clothing/neck/roguetown/gorget/ancient/decrepit
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient/decrepit

/datum/npc_loadout/armor/heavy/decrepit/plated
	gloves = /obj/item/clothing/gloves/roguetown/plate/ancient/decrepit
	head = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient/decrepit = 60,
		/obj/item/clothing/head/roguetown/helmet/heavy/knight/ancient/decrepit = 40,
	)

/datum/npc_loadout/armor/heavy/decrepit/plated/guard
	head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient/decrepit

/datum/npc_loadout/armor/heavy/decrepit_cuirass
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/ancient/decrepit
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit

/datum/npc_loadout/armor/heavy/decrepit_hauberk
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit/heavy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit/chain

/datum/npc_loadout/armor/heavy/decrepit_plate
	armor = /obj/item/clothing/suit/roguetown/armor/plate/ancient/decrepit
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit

//** BLACK KNIGHT **//

/datum/npc_loadout/armor/heavy/black_knight
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/blkknight/death
	armor = /obj/item/clothing/suit/roguetown/armor/plate/blkknight/death
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blkknight/death
	pants = /obj/item/clothing/under/roguetown/platelegs/blkknight/death
	neck = /obj/item/clothing/neck/roguetown/bevor
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/black
	belt = /obj/item/storage/belt/rogue/leather/black

//** STEEL CHAIN **//

/datum/npc_loadout/armor/heavy/steel_chain
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	head = /obj/item/clothing/head/roguetown/helmet
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/brigandinelegs

//** HEDGE KNIGHT IN FULL BLACKSTEEL **//
/datum/npc_loadout/armor/heavy/hedgeknight
	wrists = /obj/item/clothing/wrists/roguetown/bracers/blacksteel/modern
	gloves = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	armor = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel/modern
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	neck = /obj/item/clothing/neck/roguetown/bevor/blacksteel/modern
	head = list(
		/obj/item/clothing/head/roguetown/helmet/blacksteel/modern = 80,
		/obj/item/clothing/head/roguetown/helmet/blacksteel/modern/grenzelhoft = 20,
	)
