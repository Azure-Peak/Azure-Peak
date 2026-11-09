/datum/npc_loadout/kit/spellblade
	abstract_type = /datum/npc_loadout/kit/spellblade
	clear_slots = list("head", "l_hand", "r_hand")
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	pants = /obj/item/clothing/under/roguetown/trou/leather
	head = list(
		/obj/item/clothing/head/roguetown/bucklehat = 50,
		NPC_NOTHING = 50,
	)

/datum/npc_loadout/kit/spellblade/phalangite
	skills = list(/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN)
	weapons = list(
		list(/obj/item/rogueweapon/spear/spellblade, /obj/item/rogueweapon/shield/wood),
		list(/obj/item/rogueweapon/spear),
	)
