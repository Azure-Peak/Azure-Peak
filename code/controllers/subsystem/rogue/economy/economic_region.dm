GLOBAL_LIST_INIT(economic_regions, init_economic_regions())

/proc/init_economic_regions()
	var/list/result = list()
	for(var/datum/economic_region/er as anything in subtypesof(/datum/economic_region))
		var/datum/economic_region/instance = new er()
		if(!instance.region_id)
			continue
		result[instance.region_id] = instance
	return result

/datum/economic_region
	var/region_id
	var/name
	/// Italicized one-liner shown beneath the region name in the Lore Primer's
	/// AZURIA'S REGIONS section. The steward UI ignores it; only `description` shows there.
	var/subtitle = ""
	var/description = ""
	var/list/produces = list()
	var/list/demands = list()
	var/list/possible_standing_order_types = list()
	var/associated_marker_id
	var/is_region_blockaded = FALSE
	/// Null = this region cannot be blockaded.
	var/threat_region_id

	var/list/produces_today = list()
	var/list/demands_today = list()

	/// -1 = never cleared. Otherwise the cooldown window runs from this day.
	var/day_last_cleared = -1

/datum/economic_region/New()
	. = ..()
	produces_today = produces.Copy()
	demands_today = demands.Copy()
	if(!associated_marker_id)
		associated_marker_id = "[region_id]_blockade"

/datum/economic_region/kingsfield
	region_id = TRADE_REGION_KINGSFIELD
	name = "Kingsfield"
	subtitle = "The Royal Demesne, Heartland of Azuria"
	description = "The royal demesne of the Duke of Azuria, and their most valuable possession besides Azure Peak itself. A stretch of land some ten miles across the south bank of River Azur, home to dozens of agricultural settlements, hamlets, and smaller market towns. Its lands are rich, and its people aplenty. The agricultural heartland of Azuria, producing most of its grain, meat, and dairy, imported into Azure Peak daily and re-exported for profit. Many of Azure Peak's residents keep estates here. The Duke, owning most of the land directly, claims a tithe of ten percent of all produce from the region, and at least a quarter on any land directly owned by the Crown, as is their perogative, making this region vital to the Crown's coffers."
	threat_region_id = THREAT_REGION_AZURE_BASIN
	produces = list(
		TRADE_GOOD_GRAIN = TG_SUPPLY_LOCAL_GRAIN,
		TRADE_GOOD_OATS = TG_SUPPLY_FOREIGN_GRAIN,
		TRADE_GOOD_RICE = TG_SUPPLY_FOREIGN_GRAIN,
		TRADE_GOOD_MEAT = TG_SUPPLY_MEAT_BULK,
		TRADE_GOOD_PORK = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_POULTRY = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_RABBIT = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_SUPPLY_MEAT_BULK,
		TRADE_GOOD_BUTTER = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_CHEESE = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_FAT = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_TALLOW = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_CABBAGE = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_POTATO = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_ONION = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_CARROT = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_TURNIP = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_PUMPKIN = 2, // literal: trickle supply, not a staple
	)
	demands = list(
		TRADE_GOOD_PUMPKIN = 2, // literal: small local appetite for eating
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_IRON_ORE = TG_DEMAND_IRON,
		TRADE_GOOD_COPPER_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_TIN_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_COAL = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_STONE = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_CINNABAR = TG_DEMAND_PRECIOUS_METAL,
		TRADE_GOOD_GOLD_ORE = TG_DEMAND_PRECIOUS_METAL,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
		TRADE_GOOD_CALENDULA = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_DENDOR_ESSENCE = 1, // literal: deliberately scarce, not category-bound
		TRADE_GOOD_VISCERA = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
		TRADE_GOOD_FUR = TG_DEMAND_LEATHER,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_FIBERS = TG_DEMAND_CLOTH,
		TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
		TRADE_GOOD_TOPER = TG_DEMAND_GEM,
		TRADE_GOOD_GEMERALD = TG_DEMAND_GEM,
		TRADE_GOOD_FISH_FILET = TG_DEMAND_FISH_BULK,
		TRADE_GOOD_FISH_MINCE = TG_DEMAND_FISH_BULK,
		TRADE_GOOD_SALMON = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_COD = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_CRAB = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_BASS = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_CARP = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_SOLE = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_CLAM = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_LOBSTER = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_SHRIMP = TG_DEMAND_FISH_SPECIALTY,
	)

/datum/economic_region/rosawood
	region_id = TRADE_REGION_ROSAWOOD
	name = "Rosawood"
	subtitle = "The Elven Enclave, Lumber of the Cold Coast"
	description = "The last vassal of Azuria still ruled by an elven lord with a majority elven population. An elven enclave on a peninsula jutting north of Mount Decapitation, alongside a narrow strip of infertile coastal woodland known as the Southern Rosawood. Access is largely by sea. Lumber is exported from the southern edge. The county is unusually, almost magically cold, its growing season barely three months a yil. Its inhabitants feed themselves on those three months of harvest, supplemented by fish from the northern sea, though it never produces or exports enough to supply Azuria. The overland route through the passes below Decapitation is passable, but slow, and fraught with rogue Black Oaks. And the elves prefer it that way. Some say, the beautiful white cloaks of the Rosawood Count, are woven in the same manner as those of the Black Oaks, notorious mercenaries that are barely tolerated the Crown. As for any allegations of collusion, the Count of Rosawood has always been quick to deny them, and the Crown has never found any evidence to the contrary."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list(
		TRADE_GOOD_WOOD = TG_SUPPLY_CHEAP_RAW_MAT,
		TRADE_GOOD_FIBERS = TG_SUPPLY_FIBERS,
		TRADE_GOOD_HIDE = TG_SUPPLY_LEATHER,
		TRADE_GOOD_FUR = TG_SUPPLY_LEATHER,
		TRADE_GOOD_CURED_LEATHER = TG_SUPPLY_LEATHER,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
	)

/datum/economic_region/rockhill
	region_id = TRADE_REGION_ROCKHILL
	name = "Rockhill"
	subtitle = "The Orchards, Vintners and Herbalists of the Ridge"
	description = "A cluster of orchards and herb gardens to the north of Azuria, sheltered by a ridge that makes the climate there milder than it has any right to be. The many rolling hills of the county make for poor grain land but excellent orchard land. Rockhill wine and liquor are renowned throughout Azuria, and some are exported beyond. It is a quiet, quaint, agricultural county, dotted with noble estates. Rockhill apple brandy is the realm's most counterfeited drink. Every other inn from Bleakcoast to Heartfelt claims to serve it, but perhaps only a third of them actually do. The county is also known for its many country manor, with perhaps three quarter of the noble houses of the realm owning at least one in Rockhill."
	threat_region_id = THREAT_REGION_MOUNT_DECAP
	produces = list(
		TRADE_GOOD_APPLE = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_CALENDULA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_SUPPLY_SPECIALTY_HERB,
	)
	demands = list(
		TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
	)

/datum/economic_region/daftsmarch
	region_id = TRADE_REGION_DAFTSMARCH
	name = "Daftsmarch"
	subtitle = "The Mining March, Ores of the Mount"
	description = "The County of Daftsmarch is the heart of Azuria's mining industry, a long strip of land hugging the southern end of Mount Decapitation. It produces most of the raw ore and salt that Azuria depends on. The work pays well, and the veins are plentiful. But Daftsmarch sits uncomfortably close to the ruins of Tarichea, and the various denizens of the Underdark. The dangers posed by the drows and their ilk are a constant threat - many of them seeing Daftsmarch as a convenient source of slaves. But the ore vein are even richer - and the Crown is loathe to keep them up - sending adventurers, mercenaries and garrison alike to do battle with the Underdark's denizens and keep them at bay."
	threat_region_id = THREAT_REGION_UNDERDARK
	produces = list(
		TRADE_GOOD_IRON_ORE = TG_SUPPLY_IRON,
		TRADE_GOOD_COPPER_ORE = TG_SUPPLY_TIN_BRONZE,
		TRADE_GOOD_TIN_ORE = TG_SUPPLY_TIN_BRONZE,
		TRADE_GOOD_STONE = TG_SUPPLY_CHEAP_RAW_MAT,
		TRADE_GOOD_COAL = TG_SUPPLY_IRON,
		TRADE_GOOD_CINNABAR = TG_SUPPLY_PRECIOUS_METAL,
		TRADE_GOOD_GOLD_ORE = TG_SUPPLY_PRECIOUS_METAL,
		TRADE_GOOD_SALT = TG_SUPPLY_SALT,
		TRADE_GOOD_GLASS_BATCH = TG_SUPPLY_GLASS,
	)
	demands = list(
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
	)

/datum/economic_region/blackholt
	region_id = TRADE_REGION_BLACKHOLT
	name = "Blackholt"
	subtitle = "The Bog's Edge, Huntsmarshal's Demesne"
	description = "A settlement at the southern edge of the Terrorbog, part of the Royal Demesne, and the only part the Duke never tours or manages directly. Instead, management is assigned to a special courtier, the Huntsmarshal of Blackholt. It straddles the bog proper and the undrained marshland at its edge. The locals have learned to make a living off the bog's unusual, some say Psydon-blessed yields: silk from its moths, viscera from its inhabitants, and the rare Essence of Dendor that herbalists and mages pay handsomely for. Blackholt itself is a grim, functional place. Nobody moves there. People end up there."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list(
		TRADE_GOOD_SILK = TG_SUPPLY_SILK,
		TRADE_GOOD_VISCERA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_DENDOR_ESSENCE = 1, // literal: deliberately scarce, not category-bound
		TRADE_GOOD_CALENDULA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_CLAY = TG_SUPPLY_CHEAP_RAW_MAT,
		TRADE_GOOD_HIDE = 2, // literal: bog-game byproduct, backup supply if Rosawood is blockaded
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
	)

/datum/economic_region/saltwick
	region_id = TRADE_REGION_SALTWICK
	name = "Saltwick"
	subtitle = "The Coastal Town, Fisheries of the Realm"
	description = "A settlement southeast of Azure Peak, around a day's ride. Located along the Azurian coast, it was settled first by immigrants from Hammerhold and later by settlers from southern Gronn. The town is divided starkly into two parts: The curing houses and salt farms owned mostly by the town's dwarven and Hammerholdian settlers, while those of Gronnic descent makes up most of the fishermen and sailors. The two groups marry eachother rarely and argue often - but coexists somewhat harmoniously in the same town either way. Of course, Hammerholdian and Gronnmen are not the only inhabitants - many people down on their luck or seeking work also reside. Salt is imported from Daftsmarch, used to preserve the fish caught by local fishermen, and then exported throughout Azuria and Psydonia."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list(
		TRADE_GOOD_FISH_FILET = TG_SUPPLY_FISH_BULK,
		TRADE_GOOD_FISH_MINCE = TG_SUPPLY_FISH_MINCE,
		TRADE_GOOD_SALMON = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_COD = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_CRAB = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_BASS = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_CARP = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_SOLE = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_CLAM = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_LOBSTER = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_SHRIMP = TG_SUPPLY_FISH_SPECIALTY,
	)
	demands = list(
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_FIBERS = TG_DEMAND_CLOTH,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_PUMPKIN = 2, // literal: small local appetite for eating
	)

/datum/economic_region/bleakcoast
	region_id = TRADE_REGION_BLEAKCOAST
	name = "Bleakcoast"
	subtitle = "The Bleakisles Seamarch, Pirate Archipelago"
	description = "Also known as the Bleakisles Seamarch. A series of rocky outcrops said to have been created when Comet Syon impacted near the Terrorbog, radiating outward and hurling the islands from the sea itself. The archipelago numbers in the hundreds and makes navigation along all but a narrow stretch of Azuria's coast treacherous. What it lacks in fertile land it makes up for in the bounty of its seas. Schools of fish swarm in the shallow, rocky bottoms and swim as far as Azuria's coast, feeding thousands. But that bounty is not for Bleakisles inhabitants to enjoy. The isles are infested with pirates, the notorious Bleakisles Reavers, who prey on any merchant or fisherman that strays too far from shore. The Duchy maintains several garrisons to keep them in check, and has, once every two generations, undertaken a harrying of the isles, burning every non-military settlement and salting it. To no avail. Within a generation, the pirates always return, for trade is lucrative, and piracy even more so."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list()
	demands = list(
		TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_PORK = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_POULTRY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_FAT = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_TALLOW = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_OATS = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_RICE = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_POTATO = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_ONION = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CARROT = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_TURNIP = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CABBAGE = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_APPLE = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
	)

/datum/economic_region/northfort
	region_id = TRADE_REGION_NORTHFORT
	name = "Northfort"
	subtitle = "The Border Fort, Watch on the Northern Approach"
	description = "A fortified castle at the northern approach into Azuria, the only direct overland route from the north. As economically unproductive as a fort can be, which is very. The crown feeds it because without it, the border between Grenzelhoft and Azuria becomes negotiable."
	threat_region_id = THREAT_REGION_MOUNT_DECAP
	produces = list()
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_FUR = TG_DEMAND_LEATHER,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_OATS = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_PORK = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_POULTRY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_BUTTER = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_CHEESE = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_FAT = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_TALLOW = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_POTATO = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_TURNIP = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CARROT = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CABBAGE = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_ONION = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_COAL = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
	)

/datum/economic_region/heartfelt
	region_id = TRADE_REGION_HEARTFELT
	name = "Heartfelt"
	subtitle = "The Borderland, Greatest Vassal of Azuria"
	description = "The County of Heartfelt is Azuria's most powerful vassal, comprising nearly the entirety of the western borderland, bordering Otava, Grenzelhoft, Naledi, and Aavnr. The Count of Heartfelt has always been afforded considerable liberty in how they raise revenues and how many men they keep under arms, for if Heartfelt falls, Azuria's heartland would be exposed. Its defense is funded by a network of estates, holdings, and acres scattered across hundreds of pockets in Azuria outside Heartfelt proper, which the Count uses to purchase armaments and pay retinue alike. But any ruler of Azuria knows there is no greater threat to themselves than the self-professed greatest defender of Azuria."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list()
	demands = list(
		TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_POULTRY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_RABBIT = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_CHEESE = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_BUTTER = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_RICE = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_APPLE = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_CALENDULA = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_FIBERS = TG_DEMAND_CLOTH,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
	)

/datum/economic_region/hagenwald
	region_id = TRADE_REGION_HAGENWALD
	name = "Hagenwald"
	subtitle = "The Industrial Heart, Forges of the Coppiced Wood"
	description = "The industrial heart of Azuria, sitting on the northern face of Mount Decapitation, where Daftsmarch's ore is taken by mules to be smelted, refined, and forged. Hagenwald produces nearly every ingot of iron, steel, copper, and tin the kingdom uses - without its furnaces, Azuria's smiths would be reduced to working scrap. The town's wealth is built on coppiced woodland that flanks it on three sides, cut and re-cut on a generational rotation so the fire never go out. Its workforce is half Grenzelhoftian by descent, drawn over the centuries by wages, and the streets are perpetually grey with soot. The Crown garrisons it quietly."
	threat_region_id = THREAT_REGION_MOUNT_DECAP
	produces = list(
		TRADE_GOOD_IRON_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_STEEL_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_COPPER_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_TIN_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_COAL = TG_SUPPLY_IRON,
	)
	demands = list(
		TRADE_GOOD_IRON_ORE = TG_DEMAND_IRON,
		TRADE_GOOD_COPPER_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_TIN_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
	)

/// Builds the AZURIA'S REGIONS section of the Lore Primer from the economic_region datums,
/// so steward UI prose and primer prose stay in sync from a single source.
/proc/build_regions_primer_html()
	var/list/parts = list()
	parts += "<details>"
	parts += "<summary><strong><span style='font-size:130%'> REGIONS OF AZURIA </span></strong></summary>"
	parts += "<strong><span style='font-size:115%'> THE INTERNAL VASSALS AND DEMESNES </span></strong>"
	parts += "<br><br>"
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!region)
			continue
		parts += "<details>"
		parts += "<summary><strong> [uppertext(region.name)] </strong></summary>"
		parts += "<br>"
		if(region.subtitle)
			parts += "<em>[region.subtitle]</em>"
			parts += "<br><br>"
		parts += region.description
		parts += "<br>"
		parts += "</details>"
	parts += "<br><br>"
	parts += "</details>"
	return jointext(parts, "\n")
