/datum/realm_condition/aavnr_border_skirmish
	id = "aavnr_border_skirmish"
	name = "Border Skirmish"
	description = "A border skirmish has been occuring in a province near the Aavnic border. While it hasn't escalated into a full scale war, grain trade is disrupted while livestocks are slaughtered for supplies. Hide sells cheap while iron ingots are driven up in price."
	weight = 10
	affected_realms = list(REALM_AAVNR)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_HIDE, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GRAIN, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/aavnr_steppe_drought
	id = "aavnr_steppe_drought"
	name = "Steppe Drought"
	description = "The Steppes are dust. The grain fields have failed and the herds are being slaughtered for what they can yield. The Potentate's heralds beg foreign caravans for any sack of grain or oats, while hide is sold off cheap from the cull."
	weight = 8
	affected_realms = list(REALM_AAVNR)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_GRAIN),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_HIDE, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/aavnr_trade_fair
	id = "aavnr_trade_fair"
	name = "Trade Fair"
	description = "A grand trade fair is being held in the heart of Aavnr. Merchants from across the realm gather to showcase their finest goods, attracting buyers and sellers alike. Hides become cheaper and unique goods are available in the market."
	weight = 6
	affected_realms = list(REALM_AAVNR)
	cultural_modifiers = list(
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/aavnr/szabrista_kit, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/aavnr/druzhina_kit, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/aavnr/saiga_sausage, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
	)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_HIDE, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/etrusca_civil_war
	id = "etrusca_civil_war"
	name = "Civil War"
	description = "Two noble houses have been locked in a bitter civil war for control of Etrusca. The conflict has disrupted trade and caused widespread instability, leading to a surge in demand for basic metals and a drop in luxury goods like famed fruits and salt."
	weight = 8
	affected_realms = list(REALM_ETRUSCA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_LEMON, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TANGERINE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_STEEL_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)
	cultural_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "typepath" = /datum/supply_pack/rogue/etrusca/vaquero_kit),
	)

/datum/realm_condition/etrusca_gronnic_raid
	id = "etrusca_gronnic_raid"
	name = "Punitive Gronnic Raid"
	description = "Ceaseless raiding has grown intolerable for the people of Etrusca. Its legendary fleet has been sent to raid the coastal cities of Gronn and burn them down. Food and fruits grow scarce while demand for wood, hide and iron spike as the war effort ramps up."
	weight = 8
	affected_realms = list(REALM_ETRUSCA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_LEMON, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TANGERINE, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FISH_FILET, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/etrusca_harvest_festival
	id = "etrusca_harvest_festival"
	name = "Harvest Festival"
	description = "A harvest festival held in honor of Astrata, Dendor and Eora is underway. Abundant fruits and alcohol are being exported, while silk and fur are in high demand for festival garments, costumes, and customary gifts."
	weight = 10
	affected_realms = list(REALM_ETRUSCA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TOMATO, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GARLICK, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_EGGPLANT, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	cultural_modifiers = list(
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/alcohol/limoncello, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/etrusca/jamon, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/etrusca/cheese, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/grenzelhoft_mage_purge
	id = "grenzelhoft_mage_purge"
	name = "Mage Purge"
	description = "The Emperor's Magi have called for a sweep of the unregistered, and the Holy See has answered with fire. Confiscated staves and magos mantles flood the markets while the court trims its silk to look less ornate. Leather is in short supply and dear demand."
	weight = 8
	affected_realms = list(REALM_GRENZELHOFT)
	cultural_modifiers = list(
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/merc_weapons/grenzelstaff, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/grenzelhoft/magos_mantle, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/grenzelhoft/blacksteel_cuirass, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	) 
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/grenzelhoft_grain_boom
	id = "grenzelhoft_grain_boom"
	name = "Grain Boom"
	description = "A bountiful harvest has led to a surplus of grain and oats in Grenzelhoft. Prices for these staples have plummeted, while demand for fibers has surged as the population seeks to capitalize on the agricultural abundance and sew and buy new garments."
	weight = 10
	affected_realms = list(REALM_GRENZELHOFT)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GRAIN, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_OATS, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/grenzelhoft_holy_pilgrimage
	id = "grenzelhoft_holy_pilgrimage"
	name = "Holy Pilgrimage"
	description = "A grand procession from the Eleven Cathedrals winds through the inner provinces. Pilgrims demand tangerines and sugar for offerings, and Saffira for the reliquaries the Holy See is gilding for the occasion."
	weight = 6
	affected_realms = list(REALM_GRENZELHOFT)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TANGERINE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SUGAR, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
	)

/datum/realm_condition/gronn_raid_season
	id = "gronn_raid_season"
	name = "Raid Season"
	description = "Longships return from the southern coast laden with loot. Iron, fur, and seized luxuries are sold cheap at the Volfshaven docks. Crews stocking for the next voyage will pay heavy for salt and cured leather."
	weight = 12
	affected_realms = list(REALM_GRONN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FUR, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/gronn_long_winter
	id = "gronn_long_winter"
	name = "Long Winter"
	description = "The Fjall is three months under snow and the straits froze early. Hide is hoarded against the cold, the holds hunger for grain at any price, and coal trades for its weight in silver."
	weight = 8
	affected_realms = list(REALM_GRONN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_HIDE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
	)

/datum/realm_condition/gronn_great_hunt
	id = "gronn_great_hunt"
	name = "Great Hunt"
	description = "A great migration of game has come down from the north. The Iskarn hunters return with more hide and meat than the realm can salt. The clan leaders want southern silk for the feasts."
	weight = 6
	affected_realms = list(REALM_GRONN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_HIDE, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_MEAT, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FUR, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/hammerhold_dwarf_strike
	id = "hammerhold_dwarf_strike"
	name = "Dwarf Strike"
	description = "The Mountainhomes have closed their gates over an ancestral dispute. Copper, stone, and forgework aboveground are starved. Norwardine's smiths will pay handsomely for finished steel and southern timber to bridge the gap."
	weight = 8
	affected_realms = list(REALM_HAMMERHOLD)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COPPER_ORE, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_VERY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COPPER_INGOT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_VERY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_STONE, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)

/datum/realm_condition/hammerhold_brigand_uprising
	id = "hammerhold_brigand_uprising"
	name = "Brigand Uprising"
	description = "The Bana marcher lords have failed in their duty, and brigand bands move down from the granite passes. Fur is hard to come by, and Norwardine pays well for cloth, grain, and cured leather to outfit a sweep."
	weight = 8
	affected_realms = list(REALM_HAMMERHOLD)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FUR, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CLOTH, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GRAIN, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/hammerhold_royal_wedding
	id = "hammerhold_royal_wedding"
	name = "Royal Wedding"
	description = "An heir of Harlond is to wed, and Norwardine prepares a feast a generation will remember. Smoked sausage and bacon flood the markets, while silk, citrus, and saffira are demanded for gifts."
	weight = 5
	affected_realms = list(REALM_HAMMERHOLD)
	cultural_modifiers = list(
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/hammerhold/smoked_sausage, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/hammerhold/bacon, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TANGERINE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_LEMON, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/kazengun_rebellion
	id = "kazengun_rebellion"
	name = "Hangyaku Uprising"
	description = "A Hangyaku captain has raised banners in the southern home isles. Rice does not leave the home ports and silk trade is restricted. The court orders iron, coal, and cured leather at any price to outfit the loyalist daimyos."
	weight = 8
	affected_realms = list(REALM_KAZENGUN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_RICE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COAL, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/kazengun_mainland_expedition
	id = "kazengun_mainland_expedition"
	name = "Mainland Expedition"
	description = "The clans have committed forces to the mainland. Cured leather and cloth are demanded at premium for the army's outfitting, and tea export has slowed as the southern routes are commandeered."
	weight = 8
	affected_realms = list(REALM_KAZENGUN)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CURED_LEATHER, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CLOTH, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TEA, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)

/datum/realm_condition/kazengun_imperial_gala
	id = "kazengun_imperial_gala"
	name = "Imperial Gala"
	description = "The Capital holds a Gala of seven nights. Tea and silk traders cut prices to flatter the visiting daimyos, and the Tsukita Clan opens its wardrobes to the markets. The court purses are heavy for Saffira and fine northern fur."
	weight = 5
	affected_realms = list(REALM_KAZENGUN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TEA, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	cultural_modifiers = list(
		list("op" = CONDITION_OP_ADD, "typepath" = /datum/supply_pack/rogue/luxury/fancyteaset),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/kazengun/captainrobe, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/kazengun/chonin_kit, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/cross_chengtian_uprising
	id = "cross_chengtian_uprising"
	name = "Chengtian Uprising"
	description = "The Chengtianhui rebels have crossed the Yanshe river and the Lingyuese heartland burns. The Xinyi court mobilizes for a counterattack while the Kazengunese suzerain reinforces its mainland army from the isles; both realms strip their markets for war supply."
	weight = 12
	cross_realm = TRUE
	affected_realms = list(REALM_LINGYUE, REALM_KAZENGUN)
	per_realm_modifiers = list(
		REALM_LINGYUE = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_RICE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_SILK),
			),
			"demand" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
		REALM_KAZENGUN = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TEA, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CURED_LEATHER, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
	)

/datum/realm_condition/lingyue_imperial_examinations
	id = "lingyue_imperial_examinations"
	name = "Imperial Examinations"
	description = "The triennial Examinations have brought scholar aspirants to Shenzhou by the thousands. Enchscrolls and paper sell at desperate premium, while tea and cloth flow cheap from the surrounding prefectures."
	weight = 6
	affected_realms = list(REALM_LINGYUE)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_ENCHSCROLL_BASIC, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
	)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TEA, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CLOTH, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)

/datum/realm_condition/lingyue_river_flood
	id = "lingyue_river_flood"
	name = "River Flood"
	description = "The Ciwai has overrun its banks for the first time in twelve yils. The paddies are drowned and the cloth-villages are washed downstream. The dispossessed of three counties demand foreign grain and rice at any cost."
	weight = 8
	affected_realms = list(REALM_LINGYUE)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_RICE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CLOTH, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
	)

/datum/realm_condition/lirvas_debt_collection
	id = "lirvas_debt_collection"
	name = "Debt Collection"
	description = "Zarvlor has called in the outer rings' debts. Gold flows out cheap as defaulters' hoards are seized, and confiscated gems are dumped at discount. Grain is demanded at premium - the indentured must be fed."
	weight = 8
	affected_realms = list(REALM_LIRVAS)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GOLD_INGOT, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GOLD_ORE, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/lirvas_famine
	id = "lirvas_famine"
	name = "Famine"
	description = "The Lirvasian harvests have failed three seasons running, and the lowest rings starve while their debts mount. Lirvas opens its vaults - gems and gold ore sell for whatever foreign grain they can buy. Fibers and oats are demanded in huge measure."
	weight = 10
	affected_realms = list(REALM_LIRVAS)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GEMERALD, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SAFFIRA, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GOLD_ORE, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/naledi_djinn_resurgence
	id = "naledi_djinn_resurgence"
	name = "Djinn Resurgence"
	description = "The Olindar warscholars report the Djinn are bold again in the dunes. Steel and iron are demanded by the desperate warscholars; silk trade has all but stopped while caravans take cover in the cities."
	weight = 10
	affected_realms = list(REALM_NALEDI)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_STEEL_INGOT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
	)

/datum/realm_condition/naledi_sandstorm_season
	id = "naledi_sandstorm_season"
	name = "Sandstorm Season"
	description = "The Arisole storms have begun early and run long. Glass and gold dust harvests are choked by sand. The desert cities want cloth and cured leather to mend caravans and cover the images of Psydon during the blow."
	weight = 10
	affected_realms = list(REALM_NALEDI)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GLASS_BATCH, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GOLD_ORE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/naledi_warscholar_council
	id = "naledi_warscholar_council"
	name = "Warscholar Council"
	description = "The four Ndavere have called a council at Olindar. Hierophant kits and Treatises are produced cheaper for the visiting initiates, and the council pays desperate prices for enchscrolls, paper, and silk for ceremonial gifts."
	weight = 5
	affected_realms = list(REALM_NALEDI)
	cultural_modifiers = list(
		list("op" = CONDITION_OP_ADD, "typepath" = /datum/supply_pack/rogue/naledi/hierophant_kit),
		list("op" = CONDITION_OP_ADD, "typepath" = /datum/supply_pack/rogue/naledi/treatise),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/naledi/treatise, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_ENCHSCROLL_BASIC, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/otava_inquisition_writ
	id = "otava_inquisition_writ"
	name = "Inquisition Writ"
	description = "The Holy Tribunal has issued a writ against the Vallouise-sur-Mer docks. Confessor detachments need cured leather and iron at premium, while seized silk and gems from heretic houses appear cheap at the Esperance auction-block. Tallow is dear; the Inquisition burns much."
	weight = 8
	affected_realms = list(REALM_OTAVA)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CURED_LEATHER, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TALLOW, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
	)

/datum/realm_condition/otava_wine_glut
	id = "otava_wine_glut"
	name = "Wine Glut"
	description = "An exceptional season in the Val-du-Lac vineyards has flooded the Pais-Occitanie with plums and strawberries. The winemakers' single-mindedness has left the realm short of grain and salt, both wanted at premium."
	weight = 8
	affected_realms = list(REALM_OTAVA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_PLUM, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_STRAWBERRY, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)

/datum/realm_condition/otava_feast_of_saints
	id = "otava_feast_of_saints"
	name = "Feast of Saints"
	description = "The Feast of Saints draws every department to the Esperance cathedrals for a week of liturgy and table. Cheese flows from the Falaises ovens in heavy quantity, and the wine merchants of the Compact cut prices to fill the festival cups. Saffira and gems for reliquary gifts are demanded desperately."
	weight = 6
	affected_realms = list(REALM_OTAVA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CHEESE, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
	)
	cultural_modifiers = list(
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/alcohol/winevalorred, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/alcohol/winevalorwhite, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/raneshen_caravan_raids
	id = "raneshen_caravan_raids"
	name = "Caravan Raids"
	description = "Bandits ride the eastern passes between Nshkormh and Vrdaqnan. Sugar and coffee caravans arrive light and late, and the Sheikh of the affected counties pays premium for iron and cured leather to outfit a counter-raid."
	weight = 8
	affected_realms = list(REALM_RANESHEN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SUGAR, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COFFEE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/raneshen_silk_boom
	id = "raneshen_silk_boom"
	name = "Silk Boom"
	description = "The Chorodiaki silk houses have brought in a record season. Bolts spill into the markets at low prices, and dyestuffs - cinnabar especially - are demanded by the looms at premium."
	weight = 8
	affected_realms = list(REALM_RANESHEN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CLOTH, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)

/datum/realm_condition/raneshen_philosopher_gathering
	id = "raneshen_philosopher_gathering"
	name = "Philosopher Gathering"
	description = "The geometers and dervishes of the four members have gathered at Mücevkabher for a season of discourse. Enchscrolls, paper, and the finest teas are demanded for the symposia and their long nights."
	weight = 5
	affected_realms = list(REALM_RANESHEN)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_ENCHSCROLL_BASIC, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/cross_continental_war
	id = "cross_continental_war"
	name = "Continental War"
	description = "A formal war has been declared between Grenzelhoft and Otava. Grain is removed from both realms' export ledgers, steel and iron demand spikes brutally, and the looting markets quietly offer foreign silk and gemstones at discount."
	weight = 6
	cross_realm = TRUE
	affected_realms = list(REALM_GRENZELHOFT, REALM_OTAVA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_GRAIN),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_STEEL_INGOT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/cross_northern_raids
	id = "cross_northern_raids"
	name = "Northern Raids"
	description = "Gronnic longships harry the Grenzelhoftian coast. The raiders return to Volfshaven with loot; the Grenzel ports rearm at any price and offer ransom gold cheap to recover their kin."
	weight = 8
	cross_realm = TRUE
	affected_realms = list(REALM_GRONN, REALM_GRENZELHOFT)
	per_realm_modifiers = list(
		REALM_GRONN = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FUR, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_COPPER_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
			),
			"demand" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
		REALM_GRENZELHOFT = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GRAIN, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CURED_LEATHER, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
	)

/datum/realm_condition/cross_eastern_unrest
	id = "cross_eastern_unrest"
	name = "Eastern Unrest"
	description = "Disorder rolls across the Asemai. Silk and tea from both Kazengun and Lingyue arrive thin and dear, while the eastern realms collectively demand iron and coal to settle the unrest."
	weight = 6
	cross_realm = TRUE
	affected_realms = list(REALM_KAZENGUN, REALM_LINGYUE)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TEA, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COAL, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
	)

/datum/realm_condition/cross_raneshen_drought
	id = "cross_raneshen_drought"
	name = "Ranesheni Drought"
	description = "The Raneshen continent's harvests have collapsed. The Ranesheni heartlands ship no rice or garlick this season, and Lirvas's tributary fields wither in tandem. Both realms beg for foreign grain and oats."
	weight = 6
	cross_realm = TRUE
	affected_realms = list(REALM_RANESHEN, REALM_LIRVAS)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_RICE),
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_GARLICK),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/cross_aavnr_naledi_drought
	id = "cross_aavnr_naledi_drought"
	name = "Southern Drought"
	description = "A scorching season has dried the Aavnic steppes and the dunes alike. The Naledian rice paddies have gone to dust, while both the Potentate and the Malikat beg the seafaring realms for grain and oats."
	weight = 6
	cross_realm = TRUE
	affected_realms = list(REALM_AAVNR, REALM_NALEDI)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_RICE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)
/datum/realm_condition/cross_gronn_etrusca_raids
	id = "cross_gronn_etrusca_raids"
	name = "Southern Raids"
	description = "Gronnic longships have ranged south to the Resting Ocean and struck the coastal cities of Navarno. The Gronnic raiders return with citrus and Etruscan luxuries in their holds; Gran Zafiro mobilizes the Armadas while Falaises-Rouges weeps for its salt flats."
	weight = 5
	cross_realm = TRUE
	affected_realms = list(REALM_GRONN, REALM_ETRUSCA)
	per_realm_modifiers = list(
		REALM_GRONN = list(
			"supply" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
		REALM_ETRUSCA = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FISH_FILET, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
			"cultural" = list(
				list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/etrusca/vaquero_kit, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
			),
		),
	)

/datum/realm_condition/cross_etrusca_raneshen_war
	id = "cross_etrusca_raneshen_war"
	name = "Etruscan Offensive"
	description = "House Zaragoza has answered an old grievance with steel. The Etruscan Armadas sail east; Raneshen's Sheikh of the coastal counties calls for the levies and the dervish houses dim their candles."
	weight = 5
	cross_realm = TRUE
	affected_realms = list(REALM_ETRUSCA, REALM_RANESHEN)
	per_realm_modifiers = list(
		REALM_ETRUSCA = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_LEMON, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
			"cultural" = list(
				list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/etrusca/condottieri_kit, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/etrusca/crossbow, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
			),
		),
		REALM_RANESHEN = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COFFEE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GLASS_BATCH, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
	)

/datum/realm_condition/cross_raneshen_etrusca_war
	id = "cross_raneshen_etrusca_war"
	name = "Ranesheni Offensive"
	description = "The Autarch has called the levies. Ranesheni galleys cross the Resting Ocean to strike the Navarno coast - and the Vaqueros ride the hills once again. Gran Zafiro pulls every keel to the chain while the Sheikh of Vrdaqnan empties his stores for the campaign."
	weight = 5
	cross_realm = TRUE
	affected_realms = list(REALM_RANESHEN, REALM_ETRUSCA)
	per_realm_modifiers = list(
		REALM_RANESHEN = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COFFEE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
		REALM_ETRUSCA = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_LEMON, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FISH_FILET, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
			"cultural" = list(
				list("op" = CONDITION_OP_MODIFY_CULTURAL, "typepath" = /datum/supply_pack/rogue/etrusca/vaquero_kit, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
			),
		),
	)
