/datum/foreign_nation/hammerhold
	id = NATIONALITY_HAMMERHOLD
	name = "Hammerhold"
	auto_discovered = FALSE
	roll_weight = TRADE_NATION_WEIGHT_DISTANT
	ship_name_words = list(
		"Æthel", "Beorht", "Hammer", "Anvil", "Grim",
		"Wulf", "Stan", "Hild", "Mæst",
		"Fyr", "Dæg", "Gold",
	)
	captain_first_names = list(
		"Wulfstan", "Godric", "Leofric", "Beorn", "Cuthwine",
		"Oswin", "Eadwulf", "Cynehelm", "Beornræd", "Deorwine",
		"Wynflæd", "Eadgyth", "Mildþryth", "Beorhtflæd", "Cyneburg",
	)
	captain_last_names = list(
		"Hammerson", "Stanforge", "Grimaxe", "Coldhammer", "Ironbeard",
		"Ætheling", "Wulfing", "se Reada", "Eorling", "Stoneward",
	)
	ship_types = list(
		list("name" = "Knarr", "tonnage" = 25, "weight" = 10),
		list("name" = "Ballinger", "tonnage" = 50, "weight" = 25),
		list("name" = "Cog", "tonnage" = 120, "weight" = 35),
		list("name" = "Hulk", "tonnage" = 250, "weight" = 20),
		list("name" = "Great Ship", "tonnage" = 700, "weight" = 10),
	)
	name_prefixes = list(
		list("text" = "Eorl ", "chance" = 4),
		list("text" = "Cyne ", "chance" = 3),
		list("text" = "the ", "chance" = 60),
	)
	city_tags = list(
		"Norwardine", "Quicksilver Hold", "Granite Fort", "Walnut Grove",
		"the Bán", "the Mountainhomes",
	)
	city_tag_chance = 30
	city_tag_format = "of %CITY%"
	cultural_goods = list()
	preferred_imports = list()
	preferred_exports = list()
