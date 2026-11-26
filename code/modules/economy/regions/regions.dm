/datum/economic_region/kingsfield
	region_id = TRADE_REGION_KINGSFIELD
	name = "Kingsfield"
	description = "The royal demesne of the Grand Duke of Azuria, and their most valuable possession besides Azure Peak itself. The agricultural heartland of Azuria, producing most of its grain, meat, and dairy, imported into Azure Peak daily and exported again for profit. Many of Azure Peak's residents keep estates here."
	subroute = /datum/trade_subroute/kingsfield_circuit
	tribute_goods = list(
		TRADE_GOOD_GRAIN,
		TRADE_GOOD_CHEESE,
	)
	estate_goods = list(
		TRADE_GOOD_GRAIN = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_CHEESE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_BUTTER = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_EEL = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_POULTRY = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CARP = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_EGG = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_MEAT = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer,
		/obj/item/reagent_containers/food/snacks/rogue/biscuit,
		/obj/item/soap/bath,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/temperate = REGION_SIZE_MEDIUM,
		/datum/region_type/pastoral/mixed = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/aquaculture = REGION_SIZE_MEDIUM,
		/datum/region_type/pastoral/swine = REGION_SIZE_SMALL,
		/datum/region_type/industry/weaving = REGION_SIZE_MEDIUM,
		/datum/region_type/population/urban = REGION_SIZE_MEDIUM,
		/datum/region_type/population/noble_presence = REGION_SIZE_MEDIUM,
	)

/datum/economic_region/rosawood
	region_id = TRADE_REGION_ROSAWOOD
	name = "Rosawood"
	description = "The last vassal of Azuria still ruled by an elven lord with a majority elven population. The forest of Rosawood runs north to south alongside the eastern slope of North Syons, ending near Rockhill, and has been home to the Rossan elves since the times of Tarichea. On its eastern shore stands Rosporth, leased to the Azurian Trading Company in 1412 and home to the largest dockyard in Azuria, its masts felled from the year-oaks of the forest."
	subroute = /datum/trade_subroute/eastern_shores
	tribute_goods = list(
		TRADE_GOOD_WOOD,
		TRADE_GOOD_PORK,
	)
	estate_goods = list(
		TRADE_GOOD_PORK = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_HAM = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_WOOD = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_MUSHROOM = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_FAT = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CURED_LEATHER = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_FUR = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SALMON = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/elfred,
		/obj/item/bouquet/rosa,
		/obj/item/perfume/rose,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/population/mariners = REGION_SIZE_MEDIUM,
		/datum/region_type/wilds/elven_forest = REGION_SIZE_MEDIUM,
		/datum/region_type/wilds/forest = REGION_SIZE_MEDIUM,
		/datum/region_type/wilds/hunting = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/northern = REGION_SIZE_SMALL,
		/datum/region_type/pastoral/swine = REGION_SIZE_MEDIUM,
		/datum/region_type/fishery/coastal_cold = REGION_SIZE_SMALL,
		/datum/region_type/industry/weaving = REGION_SIZE_SMALL,
		/datum/region_type/industry/tannery = REGION_SIZE_MEDIUM,
		/datum/region_type/industry/shipyard = REGION_SIZE_MEDIUM,
		/datum/region_type/scarcity/iron_poor = REGION_SIZE_MEDIUM,
		/datum/region_type/scarcity/salt_poor = REGION_SIZE_MEDIUM,
	)

/datum/economic_region/rockhill
	region_id = TRADE_REGION_ROCKHILL
	name = "Rockhill"
	description = "A cluster of orchards and herb gardens to the north of Azuria, sheltered by a ridge that makes the climate there milder than it has any right to be. Rockhill wine and liquor are renowned throughout Azuria, and some are exported beyond. The county is also known for its many country manors, with perhaps three quarters of the noble houses of the realm owning at least one in Rockhill."
	subroute = /datum/trade_subroute/eastern_shores
	tribute_goods = list(
		TRADE_GOOD_APPLE,
		TRADE_GOOD_PEAR,
	)
	estate_goods = list(
		TRADE_GOOD_APPLE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_PEAR = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_HONEY = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_PLUM = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_JACKSBERRY = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_STRAWBERRY = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_BLACKBERRY = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_LEMON = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/perfume/pear,
		/obj/item/clothing/mask/cigarette/rollie/apple,
		/obj/item/soap/jackberry,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/population/mariners = REGION_SIZE_SMALL,
		/datum/region_type/agriculture/orchard = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/citrus_orchard = REGION_SIZE_SMALL,
		/datum/region_type/agriculture/herb_gardens = REGION_SIZE_MEDIUM,
		/datum/region_type/population/noble_presence = REGION_SIZE_MEDIUM,
		/datum/region_type/industry/shipyard = REGION_SIZE_SMALL,
	)

/datum/economic_region/daftsmarch
	region_id = TRADE_REGION_DAFTSMARCH
	name = "Daftsmarch"
	description = "The County of Daftsmarch is the heart of Azuria's mining industry, a long strip of land hugging the southern end of Mount Decapitation. It produces most of the raw ore and salt that Azuria depends on. But Daftsmarch sits uncomfortably close to the ruins of Tarichea, and the various denizens of the Underdark."
	subroute = /datum/trade_subroute/terrorbog_causeway
	tribute_goods = list(
		TRADE_GOOD_IRON_ORE,
		TRADE_GOOD_COAL,
	)
	estate_goods = list(
		TRADE_GOOD_IRON_ORE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SALT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_COAL = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_CINNABAR = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_GLASS_BATCH = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/butterhairs,
		/obj/item/clothing/mask/cigarette/rollie/zigar,
		/obj/item/candle,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/mining/iron_steel = REGION_SIZE_MEDIUM,
		/datum/region_type/mining/precious_veins = REGION_SIZE_MEDIUM,
		/datum/region_type/mining/stone_quarry = REGION_SIZE_MEDIUM,
		/datum/region_type/mining/glass_quarry = REGION_SIZE_MEDIUM,
		/datum/region_type/mining/salt_mines = REGION_SIZE_MEDIUM,
	)

/datum/economic_region/blackholt
	region_id = TRADE_REGION_BLACKHOLT
	name = "Blackholt"
	description = "A settlement at the southern edge of the Terrorbog, part of the Royal Demesne, and the only part the Grand Duke never tours or manages directly. The locals have learned to make a living off the bog's strange yields: silk from its spiders, viscera from its inhabitants, and the rare Essence of Dendor that herbalists and mages pay handsomely for. Nobody moves there. People end up there."
	subroute = /datum/trade_subroute/terrorbog_causeway
	tribute_goods = list(
		TRADE_GOOD_SILK,
		TRADE_GOOD_VISCERA,
	)
	estate_goods = list(
		TRADE_GOOD_SILK = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_VISCERA = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SPIDER_HONEY = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_MUDSKIPPER = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_EEL = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SWAMP_SHRIMP = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_BOGMEAT = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_GRAIN = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/clothing/mask/cigarette/rollie/cannabis,
		/obj/item/candle/skull,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/wilds/swamp = REGION_SIZE_MEDIUM,
		/datum/region_type/wilds/hunting = REGION_SIZE_SMALL,
		/datum/region_type/fishery/swamp = REGION_SIZE_MEDIUM,
		/datum/region_type/mining/clay_pits = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/temperate = REGION_SIZE_SMALL,
		/datum/region_type/population/garrison = REGION_SIZE_SMALL,
	)

/datum/economic_region/saltwick
	region_id = TRADE_REGION_SALTWICK
	name = "Saltwick"
	description = "A settlement southeast of Azure Peak, around a day's ride away, located on the coast of Kingsfield. It was settled first by immigrants from Hammerhold and later by settlers from southern Gronn. Salt is imported from Daftsmarch, used to preserve the fish caught by local fishermen, and then exported throughout Azuria and Psydonia."
	subroute = /datum/trade_subroute/kingsfield_circuit
	tribute_goods = list(
		TRADE_GOOD_SALT,
		TRADE_GOOD_DRIED_FISH,
	)
	estate_goods = list(
		TRADE_GOOD_SALT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_DRIED_FISH = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_MACKEREL = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_FISH_FILET = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_CRAB = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SHRIMP = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SAUSAGE = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SALUMOI = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena,
		/obj/item/reagent_containers/food/snacks/rogue/fryfish,
		/obj/item/clothing/mask/cigarette/rollie/nicotine,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/population/mariners = REGION_SIZE_MEDIUM,
		/datum/region_type/fishery/coastal_temperate = REGION_SIZE_MEDIUM,
		/datum/region_type/fishery/shellfish_beds = REGION_SIZE_SMALL,
		/datum/region_type/mining/salt_flats = REGION_SIZE_MEDIUM,
		/datum/region_type/industry/curing = REGION_SIZE_MEDIUM,
		/datum/region_type/industry/brewery = REGION_SIZE_SMALL,
	)

/datum/economic_region/bleakisles
	region_id = TRADE_REGION_BLEAKISLES
	name = "Bleakisles"
	description = "A series of rocky outcrops said to have been created when Comet Syon impacted near the Terrorbog, radiating outward and hurling the islands from the sea itself. What it lacks in fertile land it makes up for in the bounty of its seas. The isles are infested with pirates, the notorious Bleakisles Reavers, who prey on any merchant or fisherman that strays too far from shore."
	subroute = /datum/trade_subroute/southern_shore
	tribute_goods = list(
		TRADE_GOOD_FISH_FILET,
		TRADE_GOOD_GLASS_BATCH,
	)
	estate_goods = list(
		TRADE_GOOD_FISH_FILET = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_GLASS_BATCH = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_MACKEREL = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_CRAB = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_CLAM = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_PLAICE = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_GRAIN = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SALT = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/zagul,
		/obj/item/reagent_containers/food/snacks/rogue/fryfish,
		/obj/item/clothing/mask/cigarette/rollie/mentha,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/population/garrison = REGION_SIZE_MEDIUM,
		/datum/region_type/population/mariners = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/temperate = REGION_SIZE_MEDIUM,
		/datum/region_type/fishery/coastal_temperate = REGION_SIZE_MEDIUM,
		/datum/region_type/fishery/shellfish_beds = REGION_SIZE_MEDIUM,
		/datum/region_type/mining/glass_quarry = REGION_SIZE_MEDIUM,
	)

/datum/economic_region/northmarch
	region_id = TRADE_REGION_NORTHMARCH
	name = "Northmarch"
	description = "The county of Northmarch, also known as Arwingouw to the locals, was a part of the Duchy of Heartfelt before its incorporation into the Grand Duchy of Azuria. It is home to a large Grenzelhoftian population, many of whom work in the foothills of Menez Glas, a weathered, old mountain range with rich mineral resources and well-managed forestry. The Count of Northmarch is one of the three great marcher lords of the west, though by far the weakest."
	subroute = /datum/trade_subroute/east_bank_of_arwin
	tribute_goods = list(
		TRADE_GOOD_COPPER_ORE,
		TRADE_GOOD_TIN_ORE,
	)
	estate_goods = list(
		TRADE_GOOD_COPPER_ORE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_TIN_ORE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_WOOD = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_MUSHROOM = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_BRONZE_INGOT = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/hagwoodbitter,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/population/garrison = REGION_SIZE_MEDIUM,
		/datum/region_type/mining/copper_tin = REGION_SIZE_MEDIUM,
		/datum/region_type/wilds/forest = REGION_SIZE_MEDIUM,
		/datum/region_type/industry/toolworks = REGION_SIZE_MEDIUM,
	)

/datum/economic_region/heartfelt
	region_id = TRADE_REGION_HEARTFELT
	name = "Heartfelt"
	description = "The County of Heartfelt is Azuria's most powerful vassal, comprising half of the western borderland, bordering Otava and Aavnr. The Count of Heartfelt has always been afforded considerable liberty in how they raise revenues and how many men they keep under arms, for if Heartfelt falls, Azuria's heartland would be exposed. But any ruler of Azuria knows there is no greater threat to themselves than the one who claims to be the greatest defender of Azuria."
	subroute = /datum/trade_subroute/east_bank_of_arwin
	tribute_goods = list(
		TRADE_GOOD_MEAT,
		TRADE_GOOD_HIDE,
	)
	estate_goods = list(
		TRADE_GOOD_MEAT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_HIDE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_GRAIN = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_TALLOW = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_VENISON = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_BEANS = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_ONION = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/spicedwine,
		/obj/item/bouquet/salvia,
		/obj/item/perfume/frankincense,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/population/garrison = REGION_SIZE_MEDIUM,
		/datum/region_type/population/noble_presence = REGION_SIZE_MEDIUM,
		/datum/region_type/population/urban = REGION_SIZE_SMALL,
		/datum/region_type/agriculture/temperate = REGION_SIZE_MEDIUM,
		/datum/region_type/pastoral/saiga = REGION_SIZE_MEDIUM,
	)

/datum/economic_region/hagenwald
	region_id = TRADE_REGION_HAGENWALD
	name = "Hagenwald"
	description = "The industrial heart of Azuria, sitting on the northern face of Mount Decapitation, where Daftsmarch's ore is taken by mules to be smelted, refined, and forged. Hagenwald produces nearly every ingot of iron, steel, copper, and tin the duchy uses. The town's wealth is built on coppiced woodland that flanks it on three sides, cut and cut again on a generational rotation so the fires never go out."
	subroute = /datum/trade_subroute/syonic_passes
	tribute_goods = list(
		TRADE_GOOD_IRON_INGOT,
		TRADE_GOOD_STEEL_INGOT,
	)
	estate_goods = list(
		TRADE_GOOD_IRON_INGOT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_STEEL_INGOT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_COAL = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_BRONZE_INGOT = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_COPPER_INGOT = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_TIN_INGOT = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/apfelweinheim,
		/obj/item/clothing/mask/cigarette/rollie/zigar,
		/obj/item/soap/bath,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/industry/refinement = REGION_SIZE_MEDIUM,
		/datum/region_type/industry/charcoal_burning = REGION_SIZE_MEDIUM,
		/datum/region_type/industry/toolworks = REGION_SIZE_MEDIUM,
		/datum/region_type/industry/brewery = REGION_SIZE_SMALL,
		/datum/region_type/industry/mint = REGION_SIZE_SMALL,
	)

/datum/economic_region/eveswood
	region_id = TRADE_REGION_EVESWOOD
	name = "Eveswood"
	description = "The forest of Eveswood is larger, yet poorer than that of Rosawood to the east, with less fertile soil. It is considered the ancestral homeland of the Rossan elves, ruled by a Highwarden who swore direct fealty to the Grand Duke. Its nominal capital, the city of Farrick was built around 1215 as the home base for a new Azurian navy, but has long since declined, its shipyards half empty since the shipbuilding moved east to Rosporth."
	subroute = /datum/trade_subroute/rossan_coast
	tribute_goods = list(
		TRADE_GOOD_WOOD,
		TRADE_GOOD_ROCKNUT,
	)
	estate_goods = list(
		TRADE_GOOD_WOOD = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_PORK = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_HAM = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_MUSHROOM = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_ROCKNUT = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_FAT = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_POTATO = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_TURNIP = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/elfblue,
		/obj/item/bouquet/matricaria,
		/obj/item/clothing/mask/cigarette/rollie/calendula,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/population/garrison = REGION_SIZE_SMALL,
		/datum/region_type/population/mariners = REGION_SIZE_SMALL,
		/datum/region_type/wilds/elven_forest = REGION_SIZE_LARGE,
		/datum/region_type/wilds/forest = REGION_SIZE_MEDIUM,
		/datum/region_type/pastoral/swine = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/northern = REGION_SIZE_SMALL,
		/datum/region_type/industry/shipyard = REGION_SIZE_SMALL,
		/datum/region_type/scarcity/iron_poor = REGION_SIZE_MEDIUM,
	)

/datum/economic_region/rhu_rosha
	region_id = TRADE_REGION_RHU_ROSHA
	name = "Rhu Rosha"
	description = "Rhu Rosha, called North Rosawood on Azurian maps, is the arable peninsula that juts out from the northern end of Mount Syons, administratively part of the County of Rosawood and home to the harbor city of Calrosh. It is unnaturally cold, colder than most of Grenzelhoft to the north, with a short growing season. This coldness however brings an unnaturally rich fishery to its shore."
	subroute = /datum/trade_subroute/rossan_coast
	tribute_goods = list(
		TRADE_GOOD_COD,
		TRADE_GOOD_SALMON,
	)
	estate_goods = list(
		TRADE_GOOD_COD = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SALMON = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_FISH_FILET = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_POTATO = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_LOBSTER = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_TURNIP = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_OATS = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CABBAGE = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/food/snacks/rogue/fryfish,
		/obj/item/soap/citrus,
		/obj/item/reagent_containers/food/snacks/rogue/tangerinebiscuit,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/population/mariners = REGION_SIZE_SMALL,
		/datum/region_type/population/urban = REGION_SIZE_SMALL,
		/datum/region_type/agriculture/northern = REGION_SIZE_MEDIUM,
		/datum/region_type/fishery/coastal_cold = REGION_SIZE_LARGE,
	)

/datum/economic_region/south_syons
	region_id = TRADE_REGION_SOUTH_SYONS
	name = "South Syons"
	description = "The South Syons mountain range separates Azuria from Aavnr, along with the island chain that extends from it. Its valleys and foothills are home to the Earii, who have lived a transhumance life for centuries herding sheep between South Syons and the alluvial plains of River Azur."
	subroute = /datum/trade_subroute/southern_shore
	tribute_goods = list(
		TRADE_GOOD_CHEESE,
		TRADE_GOOD_FUR,
	)
	estate_goods = list(
		TRADE_GOOD_CHEESE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_FUR = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_BUTTER = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_MEAT = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_HIDE = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/clothing/mask/cigarette/rollie/salvia,
		/obj/item/bouquet/calendula,
		/obj/item/soap/tea,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_SMALL,
		/datum/region_type/pastoral/mountain = REGION_SIZE_SMALL,
	)

/datum/economic_region/north_syons
	region_id = TRADE_REGION_NORTH_SYONS
	name = "North Syons"
	description = "The mountains of North Syons are said to be created by the impact of Comet SYON, and stretch north to south parallel to the eastern Azurian coast. Its valleys are home to saiga herds and Earii settlements, thanks to their unusually pleasant climate, said to be because of the heat from the mountain itself. The Mount was home to the old capital of the Exarchate of Tarichea, the eponymous city of Tarichea."
	subroute = /datum/trade_subroute/syonic_passes
	tribute_goods = list(
		TRADE_GOOD_LEMON,
		TRADE_GOOD_CHEESE,
	)
	estate_goods = list(
		TRADE_GOOD_CHEESE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_LEMON = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_TANGERINE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_APPLE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_LIME = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_PEAR = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_BUTTER = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_FUR = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/perfume/citrus,
		/obj/item/clothing/mask/cigarette/rollie/lime,
		/obj/item/soap/vanilla,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_SMALL,
		/datum/region_type/pastoral/mountain = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/orchard = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/citrus_orchard = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/temperate = REGION_SIZE_SMALL,
	)

/datum/economic_region/dalesworth
	region_id = TRADE_REGION_DALESWORTH
	name = "Dalesworth"
	description = "The county of Dalesworth is a peaceful, agricultural county on the southern reach of River Azur, centred on its capital of Wendale, an ordinary riverine market city best known for the University of Wendale. Since the Count of Dalesworth died in the War of the Valley, Wendale has held royal immediacy, and its Lord Mayor rules the county, collecting taxes and tithes on behalf of the church and the crown."
	subroute = /datum/trade_subroute/riverine_azuria
	tribute_goods = list(
		TRADE_GOOD_CARP,
		TRADE_GOOD_GRAIN,
	)
	estate_goods = list(
		TRADE_GOOD_GRAIN = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_CARP = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_BLACK_BASS = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_EEL = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SALMON = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_RICE = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_BEANS = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CABBAGE = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/candle,
		/obj/item/perfume/lavender,
		/obj/item/reagent_containers/food/snacks/rogue/chocolatebiscuit,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/population/urban = REGION_SIZE_SMALL,
		/datum/region_type/population/garrison = REGION_SIZE_SMALL,
		/datum/region_type/agriculture/temperate = REGION_SIZE_MEDIUM,
		/datum/region_type/fishery/riverine = REGION_SIZE_MEDIUM,
	)

/datum/economic_region/avondale
	region_id = TRADE_REGION_AVONDALE
	name = "Avondale"
	description = "The county of Avondale consists of a triangular area of land to the west of the mountainous counties, framed to the south by River Azur. Avondale has the highest elven, half-elven and elvish ancestry of all subpolities in Azuria outside of North Azuria itself, a legacy of the Great Migration out of Eveswood. It is ruled by the Count of Avondale, who reigns from their castle in Aberavon."
	subroute = /datum/trade_subroute/riverine_azuria
	tribute_goods = list(
		TRADE_GOOD_GRAIN,
		TRADE_GOOD_PORK,
	)
	estate_goods = list(
		TRADE_GOOD_GRAIN = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_PORK = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_BEANS = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_CABBAGE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_RICE = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CARP = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_ONION = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_HAM = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian,
		/obj/item/perfume/jasmine,
		/obj/item/soap/rosa,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/population/urban = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/temperate = REGION_SIZE_LARGE,
		/datum/region_type/pastoral/swine = REGION_SIZE_SMALL,
		/datum/region_type/fishery/riverine = REGION_SIZE_SMALL,
	)

/datum/economic_region/bewmarch
	region_id = TRADE_REGION_BEWMARCH
	name = "Bewmarch"
	description = "The land of Bewmarch was directly created as the result of the Otavan Accords, which divided the lands along the Arwin river, west to Otava and east to Azuria, with the river toll collected at Vaucourt and the proceeds split in half. Vaucourt, its capital, was the most prominent Otavan and Psydonite settlement east of the river, and retains a distinctively Otavais style. The county has no notable specialized export except for cheese and wine, which are often traded down the Boway and resold as Otavais wine and cheese."
	subroute = /datum/trade_subroute/east_bank_of_arwin
	tribute_goods = list(
		TRADE_GOOD_CHEESE,
		TRADE_GOOD_APPLE,
	)
	estate_goods = list(
		TRADE_GOOD_CHEESE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_BUTTER = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_APPLE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_POULTRY = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_EGG = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_PLUM = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CARP = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/redwine,
		/obj/item/reagent_containers/glass/bottle/rogue/whitewine,
		/obj/item/reagent_containers/food/snacks/rogue/plumbiscuit,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/pastoral/mixed = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/orchard = REGION_SIZE_MEDIUM,
		/datum/region_type/fishery/riverine = REGION_SIZE_MEDIUM,
	)
