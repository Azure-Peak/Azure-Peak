/datum/economic_region/kingsfield
	region_id = TRADE_REGION_KINGSFIELD
	name = "Kingsfield"
	subtitle = "The Royal Demesne, Heartland of Azuria"
	description = "The royal demesne of the Grand Duke of Azuria, and their most valuable possession besides Azure Peak itself. A stretch of land some ten miles across the south bank of River Azur, home to dozens of agricultural settlements, hamlets, and smaller market towns. Its lands are rich, and its people aplenty. The agricultural heartland of Azuria, producing most of its grain, meat, and dairy, imported into Azure Peak daily and exported again for profit. Many of Azure Peak's residents keep estates here. The Grand Duke, owning most of the land directly, claims a tithe of ten percent of all produce from the region, and at least a quarter on any land directly owned by the Crown, as is their prerogative, making this region vital to the Crown's coffers."
	subroute = /datum/trade_subroute/kingsfield_circuit
	tribute_goods = list(
		TRADE_GOOD_GRAIN,
		TRADE_GOOD_CHEESE,
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
	subtitle = "The Elven Enclave, Lumber of the North Coast"
	description = "The last vassal of Azuria still ruled by an elven lord with a majority elven population. An elven enclave on a peninsula jutting north of Mount Decapitation, alongside a narrow strip of infertile coastal woodland known as the Southern Rosawood. Access is largely by sea. Lumber is exported from the southern edge. The county is unusually, almost magically cold, its growing season barely three months a yil. Its inhabitants feed themselves on those three months of harvest, supplemented by fish from the northern sea, though it never produces or exports enough to supply Azuria. The overland route through the passes below Decapitation is passable, but slow, and fraught with rogue Black Oaks. And the elves prefer it that way. Some say the beautiful white cloaks of the Rosawood Count are woven in the same manner as those of the Black Oaks, notorious mercenaries that are barely tolerated by the Crown. As for any allegations of collusion, the Count of Rosawood has always been quick to deny them, and the Crown has never found any evidence to the contrary."
	subroute = /datum/trade_subroute/eastern_shores
	tribute_goods = list(
		TRADE_GOOD_WOOD,
		TRADE_GOOD_PORK,
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
	subtitle = "The Orchards, Vintners and Herbalists of the Ridge"
	description = "A cluster of orchards and herb gardens to the north of Azuria, sheltered by a ridge that makes the climate there milder than it has any right to be. The many rolling hills of the county make for poor grain land but excellent orchard land. Rockhill wine and liquor are renowned throughout Azuria, and some are exported beyond. It is a quiet, quaint, agricultural county, dotted with noble estates. Rockhill apple brandy is the realm's most counterfeited drink. Every other inn from Bleakisles to Heartfelt claims to serve it, but perhaps only a third of them actually do. The county is also known for its many country manors, with perhaps three quarters of the noble houses of the realm owning at least one in Rockhill."
	subroute = /datum/trade_subroute/eastern_shores
	tribute_goods = list(
		TRADE_GOOD_APPLE,
		TRADE_GOOD_PEAR,
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
	subtitle = "The Mining March, Ores of the Mount"
	description = "The County of Daftsmarch is the heart of Azuria's mining industry, a long strip of land hugging the southern end of Mount Decapitation. It produces most of the raw ore and salt that Azuria depends on. The work pays well, and the veins are plentiful. But Daftsmarch sits uncomfortably close to the ruins of Tarichea, and the various denizens of the Underdark. The dangers posed by the drows and their ilk are a constant threat, and many of them see Daftsmarch as a convenient source of slaves. But the ore veins are richer still, and the Crown is loath to leave them unworked. It sends adventurers, mercenaries and garrison alike to do battle with the Underdark's denizens and keep them at bay."
	subroute = /datum/trade_subroute/terrorbog_causeway
	tribute_goods = list(
		TRADE_GOOD_IRON_ORE,
		TRADE_GOOD_COAL,
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
	subtitle = "The Bog's Edge, Huntsmarshal's Demesne"
	description = "A settlement at the southern edge of the Terrorbog, part of the Royal Demesne, and the only part the Grand Duke never tours or manages directly. Instead, management is assigned to a special courtier, the Huntsmarshal of Blackholt. It straddles the bog proper and the undrained marshland at its edge. The locals have learned to make a living off the bog's strange yields, which some say Psydon blessed: silk from its spiders, viscera from its inhabitants, and the rare Essence of Dendor that herbalists and mages pay handsomely for. Blackholt itself is a grim, functional place. Nobody moves there. People end up there."
	subroute = /datum/trade_subroute/terrorbog_causeway
	tribute_goods = list(
		TRADE_GOOD_SILK,
		TRADE_GOOD_VISCERA,
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
	subtitle = "The Coastal Town, Fisheries of the Realm"
	description = "A settlement southeast of Azure Peak, around a day's ride away, located on the coast of Kingsfield. It was settled first by immigrants from Hammerhold and later by settlers from southern Gronn. The town is divided starkly into two parts: The curing houses and salt farms owned mostly by the town's dwarven and Hammerholdian settlers, while those of Gronnic descent make up most of the fishermen and sailors. The two groups marry each other rarely and argue often, but coexist somewhat harmoniously in the same town either way. Of course, Hammerholdian and Gronnmen are not the only inhabitants. Many people down on their luck or seeking work also reside. Salt is imported from Daftsmarch, used to preserve the fish caught by local fishermen, and then exported throughout Azuria and Psydonia."
	subroute = /datum/trade_subroute/kingsfield_circuit
	tribute_goods = list(
		TRADE_GOOD_SALT,
		TRADE_GOOD_DRIED_FISH,
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
	subtitle = "The Bleakisles Seamarch, Pirate Archipelago"
	description = "Also known as the Bleakisles Seamarch. A series of rocky outcrops said to have been created when Comet Syon impacted near the Terrorbog, radiating outward and hurling the islands from the sea itself. The archipelago numbers in the hundreds and makes navigation along all but a narrow stretch of Azuria's coast treacherous. What it lacks in fertile land it makes up for in the bounty of its seas. Schools of fish swarm in the shallow, rocky bottoms and swim as far as Azuria's coast, feeding thousands. But that bounty is not for Bleakisles inhabitants to enjoy. The isles are infested with pirates, the notorious Bleakisles Reavers, who prey on any merchant or fisherman that strays too far from shore. The Duchy maintains several garrisons to keep them in check, and has, once every two generations, undertaken a harrying of the isles, burning every civilian settlement and salting it. Within a generation, the pirates always return."
	subroute = /datum/trade_subroute/southern_shore
	tribute_goods = list(
		TRADE_GOOD_FISH_FILET,
		TRADE_GOOD_GLASS_BATCH,
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
	subroute = /datum/trade_subroute/east_bank_of_arwin
	tribute_goods = list(
		TRADE_GOOD_COPPER_ORE,
		TRADE_GOOD_TIN_ORE,
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
	subtitle = "The Borderland, Greatest Vassal of Azuria"
	description = "The County of Heartfelt is Azuria's most powerful vassal, comprising nearly the entirety of the western borderland, bordering Otava, Grenzelhoft, Naledi, and Aavnr. The Count of Heartfelt has always been afforded considerable liberty in how they raise revenues and how many men they keep under arms, for if Heartfelt falls, Azuria's heartland would be exposed. Its defense is funded by a network of estates, holdings, and acres scattered across hundreds of pockets in Azuria outside Heartfelt proper, which the Count uses to purchase armaments and pay retinue alike. But any ruler of Azuria knows there is no greater threat to themselves than the one who claims to be the greatest defender of Azuria."
	subroute = /datum/trade_subroute/east_bank_of_arwin
	tribute_goods = list(
		TRADE_GOOD_MEAT,
		TRADE_GOOD_HIDE,
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
	subtitle = "The Industrial Heart, Forges of the Coppiced Wood"
	description = "The industrial heart of Azuria, sitting on the northern face of Mount Decapitation, where Daftsmarch's ore is taken by mules to be smelted, refined, and forged. Hagenwald produces nearly every ingot of iron, steel, copper, and tin the duchy uses. Without its furnaces, Azuria's smiths would be working scrap. The town's wealth is built on coppiced woodland that flanks it on three sides, cut and cut again on a generational rotation so the fires never go out. Its workforce is half Grenzelhoftian by descent, drawn over the centuries by wages, and the streets are perpetually grey with soot. The Crown keeps a garrison there."
	subroute = /datum/trade_subroute/syonic_passes
	tribute_goods = list(
		TRADE_GOOD_IRON_INGOT,
		TRADE_GOOD_STEEL_INGOT,
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
	subroute = /datum/trade_subroute/rossan_coast
	tribute_goods = list(
		TRADE_GOOD_WOOD,
		TRADE_GOOD_ROCKNUT,
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
	subroute = /datum/trade_subroute/rossan_coast
	tribute_goods = list(
		TRADE_GOOD_COD,
		TRADE_GOOD_SALMON,
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
	subroute = /datum/trade_subroute/southern_shore
	tribute_goods = list(
		TRADE_GOOD_CHEESE,
		TRADE_GOOD_FUR,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_SMALL,
		/datum/region_type/pastoral/mountain = REGION_SIZE_SMALL,
	)

/datum/economic_region/north_syons
	region_id = TRADE_REGION_NORTH_SYONS
	name = "North Syons"
	subroute = /datum/trade_subroute/syonic_passes
	tribute_goods = list(
		TRADE_GOOD_LEMON,
		TRADE_GOOD_CHEESE,
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
	subroute = /datum/trade_subroute/riverine_azuria
	tribute_goods = list(
		TRADE_GOOD_CARP,
		TRADE_GOOD_GRAIN,
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
	subroute = /datum/trade_subroute/riverine_azuria
	tribute_goods = list(
		TRADE_GOOD_GRAIN,
		TRADE_GOOD_PORK,
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
	subroute = /datum/trade_subroute/east_bank_of_arwin
	tribute_goods = list(
		TRADE_GOOD_CHEESE,
		TRADE_GOOD_APPLE,
	)
	region_types = list(
		/datum/region_type/population/settlement = REGION_SIZE_MEDIUM,
		/datum/region_type/pastoral/mixed = REGION_SIZE_MEDIUM,
		/datum/region_type/agriculture/orchard = REGION_SIZE_MEDIUM,
		/datum/region_type/fishery/riverine = REGION_SIZE_MEDIUM,
	)
