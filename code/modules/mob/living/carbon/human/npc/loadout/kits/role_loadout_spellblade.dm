/datum/npc_loadout/kit/spellblade
	abstract_type = /datum/npc_loadout/kit/spellblade
	clear_slots = list("l_hand", "r_hand")
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 50,
		/obj/item/clothing/suit/roguetown/armor/leather/studded = 30,
		/obj/item/clothing/suit/roguetown/armor/leather = 20,
	)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/mask/rogue/facemask
	head = list(
		/obj/item/clothing/head/roguetown/helmet/kettle/iron = 40,
		/obj/item/clothing/head/roguetown/helmet/sallet/iron = 30,
		/obj/item/clothing/head/roguetown/helmet/skullcap = 30,
	)

/datum/npc_loadout/kit/spellblade/blade
	skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
	)
	weapons = list(
		list(/obj/item/rogueweapon/sword/iron, /obj/item/rogueweapon/shield/wood),
		list(/obj/item/rogueweapon/sword/sabre/iron, /obj/item/rogueweapon/shield/buckler),
		list(/obj/item/rogueweapon/sword/short/iron, /obj/item/rogueweapon/shield/wood),
		list(/obj/item/rogueweapon/huntingknife/idagger, /obj/item/rogueweapon/shield/buckler),
		list(/obj/item/rogueweapon/sword/long/iron),
	)

/datum/npc_loadout/kit/spellblade/phalangite
	skills = list(/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN)
	weapons = list(
		list(/obj/item/rogueweapon/spear/spellblade, /obj/item/rogueweapon/shield/wood),
		list(/obj/item/rogueweapon/spear),
	)

/datum/npc_loadout/kit/spellblade/macebearer
	skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
	)
	weapons = list(
		list(/obj/item/rogueweapon/mace, /obj/item/rogueweapon/shield/wood),
		list(/obj/item/rogueweapon/mace/warhammer, /obj/item/rogueweapon/shield/wood),
		list(/obj/item/rogueweapon/stoneaxe/woodcut, /obj/item/rogueweapon/shield/wood),
		list(/obj/item/rogueweapon/mace/goden),
		list(/obj/item/rogueweapon/greataxe),
	)
