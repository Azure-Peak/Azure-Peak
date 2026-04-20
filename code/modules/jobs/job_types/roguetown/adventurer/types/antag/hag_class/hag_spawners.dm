/obj/effect/spawner/lootdrop/hag/enchanted_moss
	name = "enchanted moss spawner"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	icon_state = "spawner_ench"
	lootcount = 1
	loot = list(
		// Low Rarity Enchanted
		/obj/item/alch/hag_moss/enchanted/random/low = 6,
		/obj/item/alch/hag_moss/enchanted/crawling   = 5,
		/obj/item/alch/hag_moss/enchanted/deathless  = 4,
		/obj/item/alch/hag_moss/enchanted/corrosive  = 4,
		// Mid Rarity Enchanted
		/obj/item/alch/hag_moss/enchanted/random/mid = 3,
		/obj/item/alch/hag_moss/enchanted/caring     = 2,
		/obj/item/alch/hag_moss/enchanted/rooted     = 2,
		/obj/item/alch/hag_moss/enchanted/creeping   = 2,
		// High Rarity Enchanted
		/obj/item/alch/hag_moss/enchanted/random/high = 1,
		/obj/item/alch/hag_moss/enchanted/gilded      = 1,
		/obj/item/alch/hag_moss/enchanted/drowned     = 1
	)

/obj/effect/spawner/lootdrop/hag/mothers_cache
	name = "Mother's Cache spawner"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	icon_state = "spawner_cache"
	lootcount = 1
	loot = list(
		// 90% chance for Raw Botanicals (Weights total 90)
		/obj/item/alch/hag_moss/sorrow = 25,
		/obj/item/alch/hag_moss/fury   = 20,
		/obj/item/alch/hag_moss/envy   = 20,
		/obj/item/alch/hag_moss/mercy  = 10,
		/obj/item/alch/hag_moss/grief  = 10,
		/obj/item/alch/hag_moss/lullaby = 3,
		/obj/item/alch/hag_moss/pride   = 2,
		// 10% chance to drop the Enchanted Spawner itself
		/obj/effect/spawner/lootdrop/hag/enchanted_moss = 10 
	)

/obj/effect/spawner/lootdrop/hag/raw_botanicals
	name = "hag moss spawner"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	icon_state = "spawner_moss"
	lootcount = 1
	loot = list(
		// Common (Low Tier)
		/obj/item/alch/hag_moss/sorrow = 10,
		/obj/item/alch/hag_moss/fury   = 8,
		/obj/item/alch/hag_moss/envy   = 8,
		// Uncommon (Mid Tier)
		/obj/item/alch/hag_moss/mercy  = 5,
		/obj/item/alch/hag_moss/grief  = 5,
		// Rare (High Tier)
		/obj/item/alch/hag_moss/lullaby = 2,
		/obj/item/alch/hag_moss/pride   = 2
	)

/obj/effect/spawner/lootdrop/hag/wyrd_artifacts
	name = "wyrd artifact spawner"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	icon_state = "moss_blank"
	lootcount = 1
	loot = list(
		/obj/item/clothing/neck/roguetown/psicross/hag = 1,
		/obj/item/rogueweapon/greataxe/steel/hag       = 1,
		/obj/item/rogueweapon/sword/long/hag          = 1,
		/obj/item/rogueweapon/halberd/hag             = 1
	)
