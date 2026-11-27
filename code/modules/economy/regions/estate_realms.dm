GLOBAL_LIST_INIT(estate_realms, init_estate_realms())

/proc/init_estate_realms()
	var/list/result = list()
	for(var/path in subtypesof(/datum/estate_realm))
		var/datum/estate_realm/realm = new path()
		result[realm.id] = realm
	return result

/datum/estate_realm
	var/id
	var/name
	var/description = ""
	var/carrier = "the ATC office"
	var/sender = "Azurian Trading Company"
	var/list/estate_goods = list()
	var/list/gifts = list()

/datum/estate_realm/aavnr
	id = REALM_AAVNR
	name = "Aavnr"
	estate_goods = list(
		TRADE_GOOD_HIDE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_MEAT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_GRAIN = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_DRIED_FISH = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_FUR = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_TALLOW = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CLAM = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SALT = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/avarrice,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/saigamilk,
	)

/datum/estate_realm/etrusca
	id = REALM_ETRUSCA
	name = "Etrusca"
	estate_goods = list(
		TRADE_GOOD_LEMON = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_TANGERINE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SALT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_DRIED_FISH = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_LIME = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_TOMATO = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_GARLICK = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SUGAR = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/limoncello,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
		/obj/item/soap/citrus,
	)

/datum/estate_realm/grenzelhoft
	id = REALM_GRENZELHOFT
	name = "Grenzelhoft"
	estate_goods = list(
		TRADE_GOOD_GRAIN = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_IRON_INGOT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_STEEL_INGOT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_BUTTER = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_COAL = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CHEESE = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CURED_LEATHER = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_OATS = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/apfelweinheim,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk,
	)

/datum/estate_realm/gronn
	id = REALM_GRONN
	name = "Gronn"
	estate_goods = list(
		TRADE_GOOD_FUR = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_HIDE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_IRON_ORE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_TALLOW = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_MEAT = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_PORK = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CURED_LEATHER = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_VISCERA = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead,
		/obj/item/reagent_containers/food/snacks/rogue/honey/spider,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
	)

/datum/estate_realm/hammerhold
	id = REALM_HAMMERHOLD
	name = "Hammerhold"
	estate_goods = list(
		TRADE_GOOD_COPPER_INGOT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_COPPER_ORE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_IRON_ORE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_COAL = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SALT = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_FUR = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_HIDE = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SILK = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/nred,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/stonebeardreserve,
	)

/datum/estate_realm/kazengun
	id = REALM_KAZENGUN
	name = "Kazengun"
	estate_goods = list(
		TRADE_GOOD_SILK = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_RICE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_TEA = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SUGAR = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SALT = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_COFFEE = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CINNABAR = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunsake,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunplum,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunlager,
	)

/datum/estate_realm/lingyue
	id = REALM_LINGYUE
	name = "Lingyue"
	estate_goods = list(
		TRADE_GOOD_TEA = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SILK = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_RICE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_CINNABAR = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_PLUM = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SUGAR = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CLOTH = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/huangjiu,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/yaojiu,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/shejiu,
	)

/datum/estate_realm/lirvas
	id = REALM_LIRVAS
	name = "Lirvas"
	estate_goods = list(
		TRADE_GOOD_ROSESTONE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_CINNABAR = ESTATE_GOOD_REGULAR,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/rtoper,
		/obj/item/candle/gold,
		/obj/item/perfume/myrrh,
	)

/datum/estate_realm/naledi
	id = REALM_NALEDI
	name = "Naledi"
	estate_goods = list(
		TRADE_GOOD_GLASS_BATCH = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SALT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_LENTILS = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_BEANS = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SILK = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CLOTH = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_COFFEE = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SUGAR = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/perfume/sandalwood,
		/obj/item/perfume/frankincense,
		/obj/item/candle/silver,
	)

/datum/estate_realm/otava
	id = REALM_OTAVA
	name = "Otava"
	estate_goods = list(
		TRADE_GOOD_CHEESE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_TANGERINE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_LEMON = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_PLUM = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_STRAWBERRY = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_COD = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_DRIED_FISH = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SALT = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/redwine,
		/obj/item/reagent_containers/glass/bottle/rogue/whitewine,
		/obj/item/perfume/strawberry,
	)

/datum/estate_realm/raneshen
	id = REALM_RANESHEN
	name = "Raneshen"
	estate_goods = list(
		TRADE_GOOD_COFFEE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SUGAR = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SILK = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_RICE = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_TEA = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_GARLICK = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_GLASS_BATCH = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_SALT = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/wine,
		/obj/item/soap/coffee,
		/obj/item/perfume/cinnamon,
	)

/datum/estate_realm/underdark
	id = REALM_UNDERDARK
	name = "Underdark"
	estate_goods = list(
		TRADE_GOOD_SILK = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_MUSHROOM = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_BOGMEAT = ESTATE_GOOD_REGULAR,
		TRADE_GOOD_SPIDER_HONEY = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_VISCERA = ESTATE_GOOD_OCCASIONAL,
		TRADE_GOOD_CINNABAR = ESTATE_GOOD_OCCASIONAL,
	)
	gifts = list(
		/obj/item/candle/skull,
		/obj/item/reagent_containers/powder/moondust,
		/obj/item/perfume/myrrh,
	)
