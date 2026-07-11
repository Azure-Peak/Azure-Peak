#define VALID_FISHING_SPOTS list(\
	/turf/open/water/river,\
	/turf/open/water/cleanshallow,\
	/turf/open/water/ocean,\
	/turf/open/water/ocean/deep,\
	/turf/open/water/ocean/deep/dark,\
	/turf/open/water/ocean/abyssal,\
	/turf/open/water/swamp,\
	/turf/open/water/swamp/deep )

//Valid spots for fishing add to it if there's more.
/proc/is_valid_fishing_spot(turf/T)
	for(var/i in VALID_FISHING_SPOTS)
		if(istype(T, i))
			return TRUE
	return FALSE

/proc/createFreshWaterFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod)
	var/list/weightList = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 270*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 340*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 180*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/eel = 180*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 150 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/sturgeon = 200 * commonMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 15*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 15*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 50*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 10*ceruleanMod,
		/obj/item/grown/log/tree/stick = 1*trashMod,
		/obj/item/natural/cloth = 1*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod, //That's not a fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createFreshWaterFishWeightListModlist(list/fishingMods)
	return createFreshWaterFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"],fishingMods["cheeseFishingMod"])

/proc/createCoastalSeaFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/cod = 210*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 70*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/sole = 300*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 60*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 70*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 210*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/clam = 40*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 10*rareMod + 100*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 1*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 5*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 1*rareMod + 10*ceruleanMod,
		/obj/item/clothing/head/roguetown/octopus = 15*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed = 40 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/flounder = 200 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/mackerel = 210 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/beaksnapper = 100 * rareMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 15*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 15*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 50*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 10*ceruleanMod,
		/obj/item/grown/log/tree/stick =  1*trashMod,
		/obj/item/natural/cloth = 1*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod, //That's not a coastal fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createCoastalSeaFishWeightListModlist(list/fishingMods)
	return createCoastalSeaFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"],fishingMods["cheeseFishingMod"])

/proc/createDeepSeaFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/cod = 100*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 150*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/sole = 50*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 150*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 100*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 100*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/clam = 150*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 50*rareMod + 200*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 2*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 7*rareMod + 10*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 2*rareMod + 10*ceruleanMod,
		/obj/item/clothing/head/roguetown/octopus = 21*rareMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 30*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 30*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 75*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 40*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 15*ceruleanMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod, //That's not a deep sea fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
		/mob/living/carbon/human/species/goblin/npc/sea = 50*dangerMod,
		/mob/living/simple_animal/hostile/rogue/deepone = 50*dangerMod,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 50*dangerMod,
	)
	return counterlist_ceiling(weightList)

/proc/createDeepSeaFishWeightListModlist(list/fishingMods)
	return createDeepSeaFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"],fishingMods["cheeseFishingMod"],fishingMods["cheeseFishingMod"])

/proc/createMudFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = 200 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 100 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/zizo_abberation = 20 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 790*commonMod,
		/obj/item/natural/worms/leech = 180*rareMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 30*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod, //Thats one dirty... not a fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createMudFishWeightListModlist(list/fishingMods)
	return createMudFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"],fishingMods["cheeseFishingMod"],fishingMods["cheeseFishingMod"])

/proc/createCageFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod)
	var/weightList = list(
			/obj/item/reagent_containers/food/snacks/fish/oyster = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/shrimp = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/crab = 250*rareMod,
			/obj/item/reagent_containers/food/snacks/fish/lobster = 250*commonMod,
			/obj/item/roguegem/oyster = 50*rareMod,
			/obj/item/reagent_containers/food/snacks/smallrat = 1 + 15*cheeseMod, //Oh for fucks sake!
			/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 1*cheeseMod,
			/obj/item/grown/log/tree/stick =  100*trashMod,
	)
	return counterlist_ceiling(weightList)

/proc/createCageFishWeightListModlist(list/fishingMods)
	return createCageFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"],fishingMods["cheeseFishingMod"])

/proc/createAbyssalSeaFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod, cheeseMod)
	var/weightList = list(
		// --- Fish ---
		/obj/item/reagent_containers/food/snacks/fish/carp = 270 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 340 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 180 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/eel = 180 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/black_bass = 150 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/sturgeon = 200 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/cod = 310 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 220 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/sole = 350 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 210 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 310 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/clam = 190 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed = 40 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/flounder = 200 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/mackerel = 210 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/beaksnapper = 100 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp = 200 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/swamp_mother = 100 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/zizo_abberation = 20 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 200 * commonMod,
		/obj/item/natural/worms/leech = 180 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/oyster = 250 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 250 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/crab = 250 * rareMod,
		/obj/item/roguegem/oyster = 50 * rareMod,
		/obj/item/clothing/head/roguetown/octopus = 36 * rareMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 170 * rareMod + 250 * commonMod,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 60 * rareMod + 300 * ceruleanMod,

		// --- Rare Fish ---
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 10 * rareMod + 20 * ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 10 * rareMod + 20 * ceruleanMod,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 10 * rareMod + 20 * ceruleanMod,

		// --- Treasure Pool ---
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 3 * treasureMod + 60 * ceruleanMod,
		/obj/item/clothing/ring/gold = 4 * treasureMod + 90 * ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 3 * treasureMod + 175 * ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 60 * ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 15 * ceruleanMod,

		// --- Trash Pool ---
		/obj/item/grown/log/tree/stick = 102 * trashMod,
		/obj/item/natural/cloth = 2 * trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 2 * trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 3 * trashMod,

		// --- Rodent menace ---
		/obj/item/reagent_containers/food/snacks/smallrat = 5 + 75 * cheeseMod,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 5 * cheeseMod,

		// --- Danger / Monsters ---
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 90,
		/mob/living/carbon/human/species/goblin/npc/sea = 50 * dangerMod,
		/mob/living/simple_animal/hostile/rogue/deepone = 50 * dangerMod,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 50 * dangerMod
	)
	return counterlist_ceiling(weightList)

/proc/createAbyssalSeaFishWeightListModlist(list/fishingMods)
	return createAbyssalSeaFishWeightList(fishingMods["commonFishingMod"], fishingMods["rareFishingMod"], fishingMods["treasureFishingMod"], fishingMods["trashFishingMod"], fishingMods["dangerFishingMod"], fishingMods["ceruleanFishingMod"], fishingMods["cheeseFishingMod"])
