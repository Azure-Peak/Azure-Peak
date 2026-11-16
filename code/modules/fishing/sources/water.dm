/datum/fish_source/water
	catalog_description = "Still Water"
	fish_table = list(
		FISHING_DUD = 6,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 10,
		/obj/item/reagent_containers/food/snacks/fish/carp = 8,
		/obj/item/reagent_containers/food/snacks/fish/eel = 5,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 2,
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/reagent_containers/glass/bottle/rogue = 2,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/sunny = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/carp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/eel = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 15,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 5 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 10

/datum/fish_source/pond
	catalog_description = "Duckweed Pond"
	fish_table = list(
		FISHING_DUD = 6,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 12,
		/obj/item/reagent_containers/food/snacks/fish/carp = 8,
		/obj/item/reagent_containers/food/snacks/fish/eel = 3,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 2,
		/obj/item/natural/worms/leech = 2,
		/obj/item/reagent_containers/food/snacks/smallrat = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/sunny = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/carp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/eel = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 15,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 5 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water/pond)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 5

/datum/fish_source/cleanshallow
	catalog_description = "Clean Shallows"
	background = "background_ice"
	fish_table = list(
		FISHING_DUD = 6,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 10,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 5,
		/obj/item/reagent_containers/food/snacks/fish/carp = 4,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 2,
		/obj/item/ammo_casing/caseless/rogue/arrow = 2,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/sunny = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/carp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 12,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/salmon = 8 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water/cleanshallow)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 5

/datum/fish_source/river
	catalog_description = "Flowing River"
	fish_table = list(
		FISHING_DUD = 6,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 10,
		/obj/item/reagent_containers/food/snacks/fish/carp = 8,
		/obj/item/reagent_containers/food/snacks/fish/eel = 6,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 5,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 2,
		/obj/item/reagent_containers/food/snacks/fish/sturgeon = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/cloth = 2,
		/obj/item/ammo_casing/caseless/rogue/arrow = 2,
		/obj/item/reagent_containers/glass/bottle/rogue = 2,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/sunny = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/carp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/eel = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 15,
		/obj/item/reagent_containers/food/snacks/fish/sturgeon = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/salmon = 6 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/sturgeon = 40 MINUTES,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 30 MINUTES,
		/obj/item/clothing/ring/gold = 60 MINUTES,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 45 MINUTES,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 60 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water/river)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 12

/datum/fish_source/river/murk
	catalog_description = "Murk River"
	background = "background_dank"
	fish_table = list(
		FISHING_DUD = 6,
		/obj/item/reagent_containers/food/snacks/fish/eel = 8,
		/obj/item/reagent_containers/food/snacks/fish/carp = 8,
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 6,
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = 3,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 1,
		/obj/item/natural/worms/leech = 3,
		/obj/item/reagent_containers/food/snacks/smallrat = 1,
		/obj/item/natural/cloth = 2,
		/obj/item/reagent_containers/glass/bottle/rogue = 2,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/eel = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/carp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 30 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water/river/flow/murk)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 10

/datum/fish_source/swamp
	catalog_description = "Murky Swamp"
	background = "background_dank"
	fish_table = list(
		FISHING_DUD = 8,
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 12,
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = 4,
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 2,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/natural/worms/leech = 3,
		/obj/item/reagent_containers/food/snacks/smallrat = 1,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 8,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 1,
		/obj/item/clothing/ring/gold = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 15 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 30 MINUTES,
		/obj/item/clothing/ring/gold = 60 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water/swamp)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 10

/datum/fish_source/swamp/deep
	catalog_description = "Deep Swamp Waters"
	fish_table = list(
		FISHING_DUD = 6,
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 8,
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = 3,
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 3,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 2,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/natural/worms/leech = 2,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 10,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 2,
		/obj/item/clothing/ring/gold = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 10 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 20 MINUTES,
		/obj/item/clothing/ring/gold = 60 MINUTES,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 60 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water/swamp/deep)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 20

/datum/fish_source/ocean
	catalog_description = "Shallow Ocean"
	background = "background_tray"
	fish_table = list(
		FISHING_DUD = 6,
		/obj/item/reagent_containers/food/snacks/fish/sole = 10,
		/obj/item/reagent_containers/food/snacks/fish/cod = 7,
		/obj/item/reagent_containers/food/snacks/fish/bass = 7,
		/obj/item/reagent_containers/food/snacks/fish/flounder = 7,
		/obj/item/reagent_containers/food/snacks/fish/mackerel = 7,
		/obj/item/reagent_containers/food/snacks/fish/crab = 5,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 4,
		/obj/item/reagent_containers/food/snacks/fish/beaksnapper = 2,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 2,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 2,
		/obj/item/reagent_containers/food/snacks/fish/clam = 1,
		/obj/item/reagent_containers/food/snacks/fish/oyster = 1,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
		/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed = 1,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 1,
		/obj/item/clothing/head/roguetown/octopus = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/roguegem/oyster = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/cloth = 2,
		/obj/item/reagent_containers/glass/bottle/rogue = 2,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/sole = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/cod = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/bass = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/flounder = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/mackerel = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/crab = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/beaksnapper = 12,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 12,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 12,
		/obj/item/reagent_containers/food/snacks/fish/clam = 6,
		/obj/item/reagent_containers/food/snacks/fish/oyster = 6,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
		/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed = 1,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 1,
		/obj/item/clothing/head/roguetown/octopus = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/roguegem/oyster = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/beaksnapper = 6 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 8 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 8 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/clam = 10 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/oyster = 10 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/angler = 20 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed = 15 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 20 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 45 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 60 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 60 MINUTES,
		/obj/item/clothing/head/roguetown/octopus = 45 MINUTES,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 30 MINUTES,
		/obj/item/clothing/ring/gold = 60 MINUTES,
		/obj/item/roguegem/oyster = 45 MINUTES,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 45 MINUTES,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 45 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water/ocean)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 15

/datum/fish_source/ocean/deep
	catalog_description = "Deep Ocean"
	fish_table = list(
		FISHING_DUD = 6,
		/obj/item/reagent_containers/food/snacks/fish/cod = 8,
		/obj/item/reagent_containers/food/snacks/fish/bass = 8,
		/obj/item/reagent_containers/food/snacks/fish/sole = 6,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 2,
		/obj/item/reagent_containers/food/snacks/fish/angler = 2,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 2,
		/obj/item/reagent_containers/food/snacks/fish/swordfish = 2,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 1,
		/obj/item/clothing/head/roguetown/octopus = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/rogue = 2,
		/mob/living/simple_animal/hostile/rogue/deepone = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 1,
		/mob/living/carbon/human/species/goblin/npc/sea = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/cod = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/bass = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/sole = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 12,
		/obj/item/reagent_containers/food/snacks/fish/angler = 10,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 15,
		/obj/item/reagent_containers/food/snacks/fish/swordfish = 6,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 2,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 1,
		/obj/item/clothing/head/roguetown/octopus = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/mob/living/simple_animal/hostile/rogue/deepone = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 1,
		/mob/living/carbon/human/species/goblin/npc/sea = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/plaice = 6 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/angler = 8 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 5 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/swordfish = 10 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 10 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 30 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 45 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 45 MINUTES,
		/obj/item/clothing/head/roguetown/octopus = 30 MINUTES,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 30 MINUTES,
		/obj/item/clothing/ring/gold = 45 MINUTES,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 30 MINUTES,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 60 MINUTES,
		/mob/living/simple_animal/hostile/rogue/deepone = 30 MINUTES,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 30 MINUTES,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 30 MINUTES,
		/mob/living/carbon/human/species/goblin/npc/sea = 45 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water/ocean/deep)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 15

/datum/fish_source/ocean/abyssal
	catalog_description = "Darkwater"
	background = "background_dank"
	fish_table = list(
		FISHING_DUD = 6,
		/obj/item/reagent_containers/food/snacks/fish/sole = 5,
		/obj/item/reagent_containers/food/snacks/fish/cod = 5,
		/obj/item/reagent_containers/food/snacks/fish/bass = 5,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 5,
		/obj/item/reagent_containers/food/snacks/fish/carp = 4,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 4,
		/obj/item/reagent_containers/food/snacks/fish/angler = 4,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 4,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 4,
		/obj/item/reagent_containers/food/snacks/fish/oyster = 4,
		/obj/item/reagent_containers/food/snacks/fish/crab = 3,
		/obj/item/reagent_containers/food/snacks/fish/mackerel = 3,
		/obj/item/reagent_containers/food/snacks/fish/flounder = 3,
		/obj/item/reagent_containers/food/snacks/fish/eel = 3,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 3,
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 3,
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = 3,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 2,
		/obj/item/reagent_containers/food/snacks/fish/beaksnapper = 2,
		/obj/item/reagent_containers/food/snacks/fish/sturgeon = 1,
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 1,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 1,
		/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed = 1,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 1,
		/obj/item/natural/worms/leech = 2,
		/obj/item/roguegem/oyster = 1,
		/obj/item/clothing/head/roguetown/octopus = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/reagent_containers/glass/bottle/rogue = 2,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 1,
		/mob/living/simple_animal/hostile/rogue/deepone = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 1,
		/mob/living/carbon/human/species/goblin/npc/sea = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/sole = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/cod = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/bass = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/sunny = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/carp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/plaice = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/angler = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/lobster = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/oyster = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/crab = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/mackerel = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/flounder = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/eel = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/salmon = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/beaksnapper = FISH_STOCK_UNLIMITED,
		/obj/item/reagent_containers/food/snacks/fish/sturgeon = 1,
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 1,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 2,
		/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed = 1,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 1,
		/obj/item/roguegem/oyster = 1,
		/obj/item/clothing/head/roguetown/octopus = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/mob/living/simple_animal/hostile/rogue/deepone = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 1,
		/mob/living/carbon/human/species/goblin/npc/sea = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/sturgeon = 40 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 20 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 10 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed = 15 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/murkfang = 20 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 20 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 30 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 30 MINUTES,
		/obj/item/roguegem/oyster = 45 MINUTES,
		/obj/item/clothing/head/roguetown/octopus = 30 MINUTES,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 20 MINUTES,
		/obj/item/clothing/ring/gold = 30 MINUTES,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 20 MINUTES,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 40 MINUTES,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 60 MINUTES,
		/mob/living/simple_animal/hostile/rogue/deepone = 20 MINUTES,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 20 MINUTES,
		/mob/living/simple_animal/hostile/rogue/deepone/hound = 20 MINUTES,
		/mob/living/carbon/human/species/goblin/npc/sea = 30 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water/ocean/abyssal)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 20

/datum/fish_source/sewer
	catalog_description = "Filthy Sewers"
	background = "background_dank"
	fish_table = list(
		FISHING_DUD = 5,
		/obj/item/roguecoin/copper = 3,
		/obj/item/reagent_containers/food/snacks/smallrat/dead = 3,
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2,
		/obj/item/natural/fibers = 2,
		/obj/item/clothing/shoes/roguetown/boots/leather = 1,
		/obj/item/reagent_containers/food/snacks/fish/eel = 1,
	)
	fish_counts = list(
		/obj/item/roguecoin/copper = 5,
		/obj/item/reagent_containers/food/snacks/smallrat/dead = 4,
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 3,
		/obj/item/natural/fibers = 3,
		/obj/item/clothing/shoes/roguetown/boots/leather = 1,
		/obj/item/reagent_containers/food/snacks/fish/eel = 1,
	)
	fish_count_regen = list(
		/obj/item/roguecoin/copper = 10 MINUTES,
		/obj/item/reagent_containers/food/snacks/smallrat/dead = 9 MINUTES,
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 8 MINUTES,
		/obj/item/natural/fibers = 5 MINUTES,
		/obj/item/clothing/shoes/roguetown/boots/leather = 45 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/eel = 60 MINUTES,
	)
	associated_safe_turfs = list(/turf/open/water/sewer)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 5
