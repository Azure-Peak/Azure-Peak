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
		TRADE_GOOD_GRAIN = 8,
		TRADE_GOOD_OATS = 4,
		TRADE_GOOD_RICE = 3,
		TRADE_GOOD_MEAT = 4,
		TRADE_GOOD_PORK = 3,
		TRADE_GOOD_POULTRY = 3,
		TRADE_GOOD_RABBIT = 2,
		TRADE_GOOD_EGG = 5,
		TRADE_GOOD_BUTTER = 2,
		TRADE_GOOD_CHEESE = 3,
		TRADE_GOOD_FAT = 3,
		TRADE_GOOD_TALLOW = 2,
		TRADE_GOOD_CABBAGE = 3,
		TRADE_GOOD_POTATO = 4,
		TRADE_GOOD_ONION = 3,
		TRADE_GOOD_CARROT = 3,
		TRADE_GOOD_TURNIP = 2,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = 3,
		TRADE_GOOD_CLOTH = 4,
		TRADE_GOOD_SALT = 3,
		TRADE_GOOD_IRON_ORE = 3,
		TRADE_GOOD_COPPER_ORE = 2,
		TRADE_GOOD_TIN_ORE = 2,
		TRADE_GOOD_COAL = 3,
		TRADE_GOOD_STONE = 4,
		TRADE_GOOD_CINNABAR = 1,
		TRADE_GOOD_GOLD_ORE = 1,
		TRADE_GOOD_SILK = 1,
		TRADE_GOOD_CALENDULA = 2,
		TRADE_GOOD_POPPY = 1,
		TRADE_GOOD_DENDOR_ESSENCE = 1,
		TRADE_GOOD_VISCERA = 2,
		TRADE_GOOD_HIDE = 2,
		TRADE_GOOD_FUR = 1,
		TRADE_GOOD_CURED_LEATHER = 2,
		TRADE_GOOD_WOOD = 3,
		TRADE_GOOD_FIBERS = 2,
		TRADE_GOOD_GLASS_BATCH = 1,
		TRADE_GOOD_TOPER = 1,
		TRADE_GOOD_GEMERALD = 1,
		TRADE_GOOD_FISH_FILET = 3,
		TRADE_GOOD_FISH_MINCE = 2,
		TRADE_GOOD_SALMON = 1,
		TRADE_GOOD_COD = 1,
		TRADE_GOOD_CRAB = 1,
		TRADE_GOOD_BASS = 1,
		TRADE_GOOD_CARP = 1,
		TRADE_GOOD_SOLE = 1,
		TRADE_GOOD_CLAM = 1,
		TRADE_GOOD_LOBSTER = 1,
		TRADE_GOOD_SHRIMP = 1,
	)

/datum/economic_region/rosawood
	region_id = TRADE_REGION_ROSAWOOD
	name = "Rosawood"
	description = "The last vassal of Azuria still ruled by an elven lord with a majority elven population. An elven enclave on a peninsula jutting north of Mount Decapitation, alongside a narrow strip of infertile coastal woodland known as the Southern Rosawood. Access is largely by sea. Lumber is exported from the southern edge. The county is unusually, almost magically cold, its growing season barely three months a yil. Its inhabitants feed themselves on those three months of harvest, supplemented by fish from the northern sea, though it never produces or exports enough to supply Azuria. The overland route through the passes below Decapitation is passable, but slow, and fraught with rogue Black Oaks. And the elves prefer it that way."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list(
		TRADE_GOOD_WOOD = 10,
		TRADE_GOOD_FIBERS = 8,
		TRADE_GOOD_HIDE = 3,
		TRADE_GOOD_FUR = 2,
		TRADE_GOOD_CURED_LEATHER = 2,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_GRAIN = 3,
		TRADE_GOOD_SALT = 1,
	)

/datum/economic_region/rockhill
	region_id = TRADE_REGION_ROCKHILL
	name = "Rockhill"
	description = "A cluster of orchards and herb gardens to the north of Azuria, sheltered by a ridge that makes the climate there milder than it has any right to be. The many rolling hills of the county make for poor grain land but excellent orchard land. Rockhill wine and liquor are renowned throughout Azuria, and some are exported beyond. It is a quiet, quaint, agricultural county, dotted with noble estates."
	threat_region_id = THREAT_REGION_MOUNT_DECAP
	produces = list(
		TRADE_GOOD_APPLE = 4,
		TRADE_GOOD_PEAR = 3,
		TRADE_GOOD_JACKSBERRY = 4,
		TRADE_GOOD_CALENDULA = 3,
		TRADE_GOOD_POPPY = 2,
	)
	demands = list(
		TRADE_GOOD_GLASS_BATCH = 1,
		TRADE_GOOD_CLOTH = 2,
		TRADE_GOOD_GRAIN = 2,
	)

/datum/economic_region/daftsmarch
	region_id = TRADE_REGION_DAFTSMARCH
	name = "Daftsmarch"
	description = "The County of Daftsmarch is the heart of Azuria's mining industry, a long strip of land hugging the southern end of Mount Decapitation. It produces most of the raw ore and salt that Azuria depends on. The work pays well, and the veins are plentiful. But Daftsmarch sits uncomfortably close to the ruins of Tarichea, and the various denizens of the Underdark."
	threat_region_id = THREAT_REGION_UNDERDARK
	produces = list(
		TRADE_GOOD_IRON_ORE = 6,
		TRADE_GOOD_COPPER_ORE = 4,
		TRADE_GOOD_TIN_ORE = 4,
		TRADE_GOOD_STONE = 10,
		TRADE_GOOD_COAL = 6,
		TRADE_GOOD_CINNABAR = 2,
		TRADE_GOOD_GOLD_ORE = 3,
		TRADE_GOOD_SALT = 5,
		TRADE_GOOD_GLASS_BATCH = 2,
	)
	demands = list(
		TRADE_GOOD_GRAIN = 4,
		TRADE_GOOD_MEAT = 3,
		TRADE_GOOD_CLOTH = 2,
	)

/datum/economic_region/blackholt
	region_id = TRADE_REGION_BLACKHOLT
	name = "Blackholt"
	description = "A settlement at the southern edge of the Terrorbog, part of the Royal Demesne, and the only part the Duke never tours or manages directly. Instead, management is assigned to a special courtier, the Huntsmarshal of Blackholt. It straddles the bog proper and the undrained marshland at its edge. The locals have learned to make a living off the bog's unusual, some say Psydon-blessed yields: silk from its moths, viscera from its inhabitants, and the rare Essence of Dendor that herbalists and mages pay handsomely for. Blackholt itself is a grim, functional place. Nobody moves there. People end up there."
	threat_region_id = THREAT_REGION_TERRORBOG
	produces = list(
		TRADE_GOOD_SILK = 3,
		TRADE_GOOD_VISCERA = 3,
		TRADE_GOOD_DENDOR_ESSENCE = 1,
		TRADE_GOOD_CALENDULA = 2,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_CLOTH = 2,
	)

/datum/economic_region/saltwick
	region_id = TRADE_REGION_SALTWICK
	name = "Saltwick"
	description = "A settlement southeast of Azure Peak, around a day's ride. Located along the Azurian coast, it was settled first by immigrants from Hammerhold and later by settlers from southern Gronn. Salt is imported from Daftsmarch, used to preserve the fish caught by local fishermen, and then exported throughout Azuria and Psydonia."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list(
		TRADE_GOOD_FISH_FILET = 6,
		TRADE_GOOD_FISH_MINCE = 4,
		TRADE_GOOD_SALMON = 2,
		TRADE_GOOD_COD = 2,
		TRADE_GOOD_CRAB = 2,
		TRADE_GOOD_BASS = 2,
		TRADE_GOOD_CARP = 2,
		TRADE_GOOD_SOLE = 2,
		TRADE_GOOD_CLAM = 2,
		TRADE_GOOD_LOBSTER = 1,
		TRADE_GOOD_SHRIMP = 2,
	)
	demands = list(
		TRADE_GOOD_SALT = 4,
		TRADE_GOOD_FIBERS = 3,
		TRADE_GOOD_CLOTH = 2,
		TRADE_GOOD_WOOD = 2,
		TRADE_GOOD_IRON_INGOT = 1,
	)

/datum/economic_region/bleakcoast
	region_id = TRADE_REGION_BLEAKCOAST
	name = "Bleakcoast"
	description = "Also known as the Bleakisles Seamarch. A series of rocky outcrops said to have been created when Comet Syon impacted near the Terrorbog, radiating outward and hurling the islands from the sea itself. The archipelago numbers in the hundreds and makes navigation along all but a narrow stretch of Azuria's coast treacherous. What it lacks in fertile land it makes up for in the bounty of its seas. Schools of fish swarm in the shallow, rocky bottoms and swim as far as Azuria's coast, feeding thousands. But that bounty is not for Bleakisles inhabitants to enjoy. The isles are infested with pirates, the notorious Bleakisles Reavers, who prey on any merchant or fisherman that strays too far from shore. The Duchy maintains several garrisons to keep them in check, and has, once every two generations, undertaken a harrying of the isles, burning every non-military settlement and salting it. To no avail. Within a generation, the pirates always return, for trade is lucrative, and piracy even more so."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list()
	demands = list(
		TRADE_GOOD_STEEL_INGOT = 3,
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_CLOTH = 4,
		TRADE_GOOD_MEAT = 4,
		TRADE_GOOD_PORK = 3,
		TRADE_GOOD_POULTRY = 2,
		TRADE_GOOD_EGG = 3,
		TRADE_GOOD_FAT = 2,
		TRADE_GOOD_TALLOW = 2,
		TRADE_GOOD_GRAIN = 5,
		TRADE_GOOD_OATS = 3,
		TRADE_GOOD_RICE = 2,
		TRADE_GOOD_POTATO = 3,
		TRADE_GOOD_ONION = 2,
		TRADE_GOOD_CARROT = 2,
		TRADE_GOOD_TURNIP = 2,
		TRADE_GOOD_CABBAGE = 2,
		TRADE_GOOD_APPLE = 2,
		TRADE_GOOD_PEAR = 1,
		TRADE_GOOD_JACKSBERRY = 2,
		TRADE_GOOD_CURED_LEATHER = 2,
		TRADE_GOOD_HIDE = 1,
	)

/datum/economic_region/northfort
	region_id = TRADE_REGION_NORTHFORT
	name = "Northfort"
	description = "A fortified castle at the northern approach into Azuria, the only direct overland route from the north. As economically unproductive as a fort can be, which is very. The crown feeds it because without it, the border between Grenzelhoft and Azuria becomes negotiable."
	threat_region_id = THREAT_REGION_MOUNT_DECAP
	produces = list()
	demands = list(
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_STEEL_INGOT = 2,
		TRADE_GOOD_FUR = 2,
		TRADE_GOOD_HIDE = 2,
		TRADE_GOOD_CURED_LEATHER = 1,
		TRADE_GOOD_CLOTH = 3,
		TRADE_GOOD_GRAIN = 4,
		TRADE_GOOD_OATS = 3,
		TRADE_GOOD_MEAT = 3,
		TRADE_GOOD_PORK = 2,
		TRADE_GOOD_POULTRY = 2,
		TRADE_GOOD_BUTTER = 1,
		TRADE_GOOD_CHEESE = 2,
		TRADE_GOOD_FAT = 2,
		TRADE_GOOD_TALLOW = 2,
		TRADE_GOOD_EGG = 2,
		TRADE_GOOD_POTATO = 3,
		TRADE_GOOD_TURNIP = 2,
		TRADE_GOOD_CARROT = 2,
		TRADE_GOOD_CABBAGE = 2,
		TRADE_GOOD_ONION = 2,
		TRADE_GOOD_SALT = 2,
		TRADE_GOOD_COAL = 3,
	)

/datum/economic_region/heartfelt
	region_id = TRADE_REGION_HEARTFELT
	name = "Heartfelt"
	description = "The County of Heartfelt is Azuria's most powerful vassal, comprising nearly the entirety of the western borderland, bordering Otava, Grenzelhoft, Naledi, and Aavnr. The Count of Heartfelt has always been afforded considerable liberty in how they raise revenues and how many men they keep under arms, for if Heartfelt falls, Azuria's heartland would be exposed. Its defense is funded by a network of estates, holdings, and acres scattered across hundreds of pockets in Azuria outside Heartfelt proper, which the Count uses to purchase armaments and pay retinue alike. But any ruler of Azuria knows there is no greater threat to themselves than the self-professed greatest defender of Azuria."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list()
	demands = list(
		TRADE_GOOD_STEEL_INGOT = 3,
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_MEAT = 3,
		TRADE_GOOD_POULTRY = 2,
		TRADE_GOOD_RABBIT = 2,
		TRADE_GOOD_CHEESE = 2,
		TRADE_GOOD_BUTTER = 1,
		TRADE_GOOD_EGG = 2,
		TRADE_GOOD_GRAIN = 4,
		TRADE_GOOD_RICE = 2,
		TRADE_GOOD_APPLE = 2,
		TRADE_GOOD_PEAR = 2,
		TRADE_GOOD_JACKSBERRY = 2,
		TRADE_GOOD_CALENDULA = 2,
		TRADE_GOOD_POPPY = 1,
		TRADE_GOOD_CLOTH = 3,
		TRADE_GOOD_FIBERS = 2,
		TRADE_GOOD_CURED_LEATHER = 2,
		TRADE_GOOD_HIDE = 1,
	)
