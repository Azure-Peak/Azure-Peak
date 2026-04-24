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
	description = "The royal demesne of the Duke of Azuria, and their most valuable possession besides Azure Peak itself. A stretch of land some ten miles across the south bank of River Azur, home to dozens of agricultural settlements, hamlets, and smaller market towns. The agricultural heartland of Azuria, producing most of its grain, meat, and dairy, imported into Azure Peak daily and re-exported for profit. Many of Azure Peak's residents keep estates here."
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
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_IRON_ORE = TG_DEMAND_IRON,
		TRADE_GOOD_COPPER_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_TIN_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_COAL = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_STONE = TG_DEMAND_CHEAP_RAW_MAT,
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
	description = "The last vassal of Azuria still ruled by an elven lord with a majority elven population. An elven enclave on a peninsula jutting north of Mount Decapitation, alongside a narrow strip of infertile coastal woodland known as the Southern Rosawood. Access is largely by sea. Lumber is exported from the southern edge. The county is unusually, almost magically cold, its growing season barely three months a yil. Its inhabitants feed themselves on those three months of harvest, supplemented by fish from the northern sea, though it never produces or exports enough to supply Azuria. The overland route through the passes below Decapitation is passable, but slow, and fraught with rogue Black Oaks. And the elves prefer it that way."
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
	description = "A cluster of orchards and herb gardens to the north of Azuria, sheltered by a ridge that makes the climate there milder than it has any right to be. The many rolling hills of the county make for poor grain land but excellent orchard land. Rockhill wine and liquor are renowned throughout Azuria, and some are exported beyond. It is a quiet, quaint, agricultural county, dotted with noble estates."
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
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
	)

/datum/economic_region/daftsmarch
	region_id = TRADE_REGION_DAFTSMARCH
	name = "Daftsmarch"
	description = "The County of Daftsmarch is the heart of Azuria's mining industry, a long strip of land hugging the southern end of Mount Decapitation. It produces most of the raw ore and salt that Azuria depends on. The work pays well, and the veins are plentiful. But Daftsmarch sits uncomfortably close to the ruins of Tarichea, and the various denizens of the Underdark."
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
	description = "A settlement at the southern edge of the Terrorbog, part of the Royal Demesne, and the only part the Duke never tours or manages directly. Instead, management is assigned to a special courtier, the Huntsmarshal of Blackholt. It straddles the bog proper and the undrained marshland at its edge. The locals have learned to make a living off the bog's unusual, some say Psydon-blessed yields: silk from its moths, viscera from its inhabitants, and the rare Essence of Dendor that herbalists and mages pay handsomely for. Blackholt itself is a grim, functional place. Nobody moves there. People end up there."
	threat_region_id = THREAT_REGION_TERRORBOG
	produces = list(
		TRADE_GOOD_SILK = TG_SUPPLY_SILK,
		TRADE_GOOD_VISCERA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_DENDOR_ESSENCE = 1, // literal: deliberately scarce, not category-bound
		TRADE_GOOD_CALENDULA = TG_SUPPLY_SPECIALTY_HERB,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
	)

/datum/economic_region/saltwick
	region_id = TRADE_REGION_SALTWICK
	name = "Saltwick"
	description = "A settlement southeast of Azure Peak, around a day's ride. Located along the Azurian coast, it was settled first by immigrants from Hammerhold and later by settlers from southern Gronn. Salt is imported from Daftsmarch, used to preserve the fish caught by local fishermen, and then exported throughout Azuria and Psydonia."
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
	)

/datum/economic_region/bleakcoast
	region_id = TRADE_REGION_BLEAKCOAST
	name = "Bleakcoast"
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
	)

/datum/economic_region/heartfelt
	region_id = TRADE_REGION_HEARTFELT
	name = "Heartfelt"
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
	)
