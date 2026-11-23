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
	var/list/tribute_goods = list()
	var/list/gifts = list()

/datum/estate_realm/aavnr
	id = REALM_AAVNR
	name = "Aavnr"
	tribute_goods = list(
		TRADE_GOOD_HIDE,
		TRADE_GOOD_DRIED_FISH,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/avarrice,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/saigamilk,
	)

/datum/estate_realm/etrusca
	id = REALM_ETRUSCA
	name = "Etrusca"
	tribute_goods = list(
		TRADE_GOOD_LEMON,
		TRADE_GOOD_SALT,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/limoncello,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
		/obj/item/soap/citrus,
	)

/datum/estate_realm/grenzelhoft
	id = REALM_GRENZELHOFT
	name = "Grenzelhoft"
	tribute_goods = list(
		TRADE_GOOD_IRON_INGOT,
		TRADE_GOOD_BUTTER,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/apfelweinheim,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk,
	)

/datum/estate_realm/gronn
	id = REALM_GRONN
	name = "Gronn"
	tribute_goods = list(
		TRADE_GOOD_FUR,
		TRADE_GOOD_IRON_ORE,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead,
		/obj/item/reagent_containers/food/snacks/rogue/honey/spider,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
	)

/datum/estate_realm/hammerhold
	id = REALM_HAMMERHOLD
	name = "Hammerhold"
	tribute_goods = list(
		TRADE_GOOD_COPPER_INGOT,
		TRADE_GOOD_COAL,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/nred,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/stonebeardreserve,
	)

/datum/estate_realm/kazengun
	id = REALM_KAZENGUN
	name = "Kazengun"
	tribute_goods = list(
		TRADE_GOOD_SILK,
		TRADE_GOOD_RICE,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunsake,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunplum,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunlager,
	)

/datum/estate_realm/lingyue
	id = REALM_LINGYUE
	name = "Lingyue"
	tribute_goods = list(
		TRADE_GOOD_TEA,
		TRADE_GOOD_PLUM,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/huangjiu,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/yaojiu,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/shejiu,
	)

/datum/estate_realm/lirvas
	id = REALM_LIRVAS
	name = "Lirvas"
	tribute_goods = list(
		TRADE_GOOD_ROSESTONE,
		TRADE_GOOD_CINNABAR,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/rtoper,
		/obj/item/candle/gold,
		/obj/item/perfume/myrrh,
	)

/datum/estate_realm/naledi
	id = REALM_NALEDI
	name = "Naledi"
	tribute_goods = list(
		TRADE_GOOD_GLASS_BATCH,
		TRADE_GOOD_LENTILS,
	)
	gifts = list(
		/obj/item/perfume/sandalwood,
		/obj/item/perfume/frankincense,
		/obj/item/candle/silver,
	)

/datum/estate_realm/otava
	id = REALM_OTAVA
	name = "Otava"
	tribute_goods = list(
		TRADE_GOOD_CHEESE,
		TRADE_GOOD_TANGERINE,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/redwine,
		/obj/item/reagent_containers/glass/bottle/rogue/whitewine,
		/obj/item/perfume/strawberry,
	)

/datum/estate_realm/raneshen
	id = REALM_RANESHEN
	name = "Raneshen"
	tribute_goods = list(
		TRADE_GOOD_COFFEE,
		TRADE_GOOD_SUGAR,
	)
	gifts = list(
		/obj/item/reagent_containers/glass/bottle/rogue/wine,
		/obj/item/soap/coffee,
		/obj/item/perfume/cinnamon,
	)

/datum/estate_realm/underdark
	id = REALM_UNDERDARK
	name = "Underdark"
	tribute_goods = list(
		TRADE_GOOD_SPIDER_HONEY,
		TRADE_GOOD_SILK,
	)
	gifts = list(
		/obj/item/candle/skull,
		/obj/item/reagent_containers/powder/moondust,
		/obj/item/perfume/myrrh,
	)
