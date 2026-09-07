/*
// Spawners that hold various types of magic-loot. Components for summoning & shit.
*/

// coders note: i've never done summoning so these drop %s and values are arbitrary. please adjust as needed, thanks.

/*
// GENERAL SPAWNERS: these spawn a random component of a given type. loot value = mixed for obvs reasons.
*/

/obj/effect/spawner/lootdrop/infernal_spawner
	name = "infernal summoning spawner"
	icon_state = "infernal"
	lootcount = 1
	loot_value = LOOT_VALUE_DUNGEON_MIXED
	junk_loot = list(/obj/item/ash = 2, /obj/item/candle/skull/lit = 1, /obj/item/candle/yellow = 1)
	loot = list(
		// TIER ONE - 70%
		/obj/item/magic/infernal/ash = 70,
		// TIER TWO - 20%
		/obj/item/magic/infernal/fang/ = 20,
		// TIER THREE - 8%
		/obj/item/magic/infernal/core = 8,
		// TIER FOUR - 2%
		/obj/item/magic/infernal/flame = 2,
	)


/obj/effect/spawner/lootdrop/fae_spawner
	name = "fae summoning spawner"
	icon_state = "fae"
	lootcount = 1
	loot_value = LOOT_VALUE_DUNGEON_MIXED
	junk_loot = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/fibers = 1, /obj/item/natural/thorn = 1)
	loot = list(
		// TIER ONE - 70%
		/obj/item/magic/fae/fairydust = 70,
		// TIER TWO - 20%
		/obj/item/magic/fae/iridescentscale = 20,
		// TIER THREE - 8%
		/obj/item/magic/fae/heartwoodcore = 8,
		// TIER FOUR - 2%
		/obj/item/magic/fae/sylvanessence = 2,
	)


/obj/effect/spawner/lootdrop/elemental
	name = "elemental summoning spawner"
	icon_state = "elemental"
	lootcount = 1
	loot_value = LOOT_VALUE_DUNGEON_MIXED
	junk_loot = list(/obj/item/natural/stone = 2, /obj/item/natural/feather = 1, /obj/item/flint = 1)
	loot = list(
		// TIER ONE - 70%
		/obj/item/magic/elemental/mote = 70,
		// TIER TWO - 20%
		/obj/item/magic/elemental/shard = 20,
		// TIER THREE - 8%
		/obj/item/magic/elemental/fragment = 8,
		// TIER FOUR - 2%
		/obj/item/magic/elemental/relic = 2,
	)

// spawns ANY of the above four loot-drops. chance for chalk, as well.
/obj/effect/spawner/lootdrop/general_mixed
	name = "general mixed summoning spawner"
	icon_state = "general_components"
	lootcount = 1
	loot_value = LOOT_VALUE_DUNGEON_MIXED
	junk_loot = list(/obj/item/natural/stone = 2, /obj/item/natural/feather = 1, /obj/item/flint = 1)
	loot = list(
		/obj/item/chalk = 1,
		/obj/effect/spawner/lootdrop/elemental = 2,
		/obj/effect/spawner/lootdrop/fae_spawner = 2,
		/obj/effect/spawner/lootdrop/infernal_spawner = 2
	)

/*
// TIER-based spawners. these will spawn a random component of a given tier.
*/

/obj/effect/spawner/lootdrop/component_spawner
	name = "component spawner tier 1"
	icon_state = "t1comp"
	lootcount = 1
	loot_value = LOOT_VALUE_COMPONENTS_TIER1
	junk_loot = list(/obj/item/natural/stone = 1, /obj/item/natural/feather = 1, /obj/item/flint = 1,
					/obj/item/candle/yellow = 1, /obj/item/ash = 1)
	loot = list(
		/obj/item/magic/infernal/ash = 1,
		/obj/item/magic/fae/fairydust = 1,
		/obj/item/magic/elemental/mote = 1,
	)

/obj/effect/spawner/lootdrop/component_spawner/tier_2
	name = "component spawner tier 2"
	icon_state = "t2comp"
	lootcount = 1
	loot_value = LOOT_VALUE_COMPONENTS_TIER2
	loot = list(
		/obj/item/magic/infernal/fang/ = 1,
		/obj/item/magic/fae/iridescentscale = 1,
		/obj/item/magic/elemental/shard = 1,
	)

/obj/effect/spawner/lootdrop/component_spawner/tier_3
	name = "component spawner tier 3"
	icon_state = "t3comp"
	lootcount = 1
	loot_value = LOOT_VALUE_COMPONENTS_TIER3
	loot = list(
		/obj/item/magic/infernal/core = 1,
		/obj/item/magic/fae/heartwoodcore = 1,
		/obj/item/magic/elemental/fragment = 1,
	)

/obj/effect/spawner/lootdrop/component_spawner/tier_4
	name = "component spawner tier 4"
	icon_state = "t4comp"
	lootcount = 1
	loot_value = LOOT_VALUE_COMPONENTS_TIER4
	loot = list(
		/obj/item/magic/infernal/flame = 1,
		/obj/item/magic/fae/sylvanessence = 1,
		/obj/item/magic/elemental/relic = 1,
	)
