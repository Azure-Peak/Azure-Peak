/obj/structure/closet/crate/chest/loot_chest
	storage_capacity = 100
	anchored = TRUE
	/// our lootspawners. the spawner's lootcount var works additively with our dice string below and must be at least 1.
	var/list/loot_weighted_list = list(
		/obj/effect/spawner/lootdrop/general_loot_hi = 5,
		/obj/effect/spawner/lootdrop/general_loot_mid = 5,
		/obj/effect/spawner/lootdrop/valuable_candle_spawner = 1,
		/obj/effect/spawner/lootdrop/valuable_tableware_spawner = 1,
	)
	/// a string of dice to use when rolling number of contents.
	var/loot_spawn_dice_string = "1d3+1"
	/// Expected mammon value of this chest's contents. Used by the loot pool budget system.
	var/loot_value = LOOT_VALUE_CHEST
	/// Junk to spawn inside the chest when it loses the budget lottery
	var/list/junk_loot = list(
		/obj/item/ash = 5,
		/obj/item/natural/glass_shard = 5,
		/obj/item/natural/stone = 3,
	)

/obj/structure/closet/crate/chest/loot_chest/Initialize()
	. = ..()
	// Defer loot generation to the pool system
	GLOB.loot_chests_pending += src

/// Called by the pool when this chest loses the budget lottery
/obj/structure/closet/crate/chest/loot_chest/proc/spawn_junk()
	if(!junk_loot || !length(junk_loot))
		return
	var/junk_type = pickweight(junk_loot)
	new junk_type(src)

/// Actually generate chest contents from the weighted spawner list
/obj/structure/closet/crate/chest/loot_chest/proc/generate_loot()
	var/random_loot_amount = roll(loot_spawn_dice_string)
	for(var/loot_spawn in 1 to random_loot_amount)
		var/obj/new_loot = pickweight(loot_weighted_list)
		new new_loot(src)

/obj/structure/closet/crate/chest/loot_chest/locked
	locked = TRUE
	max_integrity = 1000
	loot_value = LOOT_VALUE_CHEST_LOCKED
	loot_weighted_list = list(
		/obj/effect/spawner/lootdrop/general_loot_hi = 4,
		/obj/effect/spawner/lootdrop/general_loot_mid = 1,
		/obj/effect/spawner/lootdrop/valuable_candle_spawner = 2,
		/obj/effect/spawner/lootdrop/valuable_clutter_spawner = 2,
		/obj/effect/spawner/lootdrop/valuable_jewelry_spawner = 1,
	)
	loot_spawn_dice_string = "1d2+1"

/obj/structure/closet/crate/chest/loot_chest/locked/indestructible //party up with rogues NOW
	max_integrity = 2000 //Changed from 'INFINITY'. Still greatly encourages taking a rogue or lockpick, but doesn't make it impossible to crack, in a pinch, with enough time and stamina.
	lock_strength = 200
	loot_value = LOOT_VALUE_CHEST_INDESTRUCTIBLE
	loot_weighted_list = list(
		/obj/effect/spawner/lootdrop/valuable_jewelry_spawner = 1,
		/obj/effect/spawner/lootdrop/general_loot_hi = 4,
		/obj/effect/spawner/lootdrop/general_loot_mid = 1,
	)

/obj/effect/landmark/chest_or_mimic/loot_chest
	chest_type = /obj/structure/closet/crate/chest/loot_chest

/obj/effect/landmark/chest_or_mimic/loot_chest/locked
	chest_type = /obj/structure/closet/crate/chest/loot_chest/locked
