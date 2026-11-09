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
	spellblade_chant = "blade"
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

/datum/npc_loadout/kit/spellblade/blade/drow
	traits = list(TRAIT_DUALWIELDER)
	weapons = list(
		list(/obj/item/rogueweapon/sword/falx/stalker, /obj/item/rogueweapon/sword/falx/stalker, 100),
		list(/obj/item/rogueweapon/huntingknife/idagger/steel/stalker, /obj/item/rogueweapon/huntingknife/idagger/steel/stalker, 100),
	)

/datum/npc_loadout/kit/spellblade/phalangite
	spellblade_chant = "phalangite"
	skills = list(/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN)
	weapons = list(
		list(/obj/item/rogueweapon/spear/spellblade, /obj/item/rogueweapon/shield/wood),
		list(/obj/item/rogueweapon/spear),
	)

/datum/npc_loadout/kit/spellblade/macebearer
	spellblade_chant = "macebearer"
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

/datum/npc_loadout/kit/spellblade_champion
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 50,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 50,
	)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
