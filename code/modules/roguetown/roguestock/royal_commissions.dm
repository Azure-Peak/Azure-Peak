/datum/royal_commission
	var/name = ""
	var/desc = ""
	var/list/contains = list()
	var/daily_stock = COMMISSION_DAILY_STOCK
	var/stock = 0

/datum/royal_commission/New()
	. = ..()
	stock = daily_stock

/datum/royal_commission/proc/get_price()
	var/total = 0
	for(var/obj/item/path as anything in contains)
		var/count = contains[path] || 1
		var/unit = initial(path.sellprice) || GLOB.derived_sellprices?[path] || lookup_derived_subtype_price(path)
		total += unit * count
	return max(1, round(total * COMMISSION_PRICE_MARKUP))

/datum/royal_commission/proc/restock()
	stock = daily_stock

/datum/royal_commission/proc/content_rows()
	var/list/rows = list()
	for(var/obj/item/path as anything in contains)
		rows += list(list(
			"name" = initial(path.name),
			"count" = contains[path] || 1,
		))
	return rows

/datum/royal_commission/crossbow
	name = "Crossbow Crate"
	desc = "Three crossbows and three full quivers."
	contains = list(
		/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 3,
		/obj/item/quiver/bolt/standard = 3,
	)

/datum/royal_commission/warden
	name = "Warden Equipment Crate"
	desc = "Equipment kit for a warden."
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/bascinet/antler,
		/obj/item/clothing/cloak/wardencloak,
		/obj/item/clothing/suit/roguetown/armor/leather/studded/warden,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
		/obj/item/clothing/wrists/roguetown/bracers/leather,
		/obj/item/clothing/gloves/roguetown/fingerless_leather,
		/obj/item/clothing/under/roguetown/trou/leather,
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced,
		/obj/item/rogueweapon/stoneaxe/woodcut/wardenpick,
		/obj/item/rogueweapon/huntingknife/idagger/warden_machete,
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/warden,
		/obj/item/quiver/arrows,
		/obj/item/storage/belt/rogue/leather,
		/obj/item/storage/keyring/warden,
	)

/datum/royal_commission/manatarms
	name = "Man-at-Arms Equipment Crate"
	desc = "Equipment kit for an armsman."
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/sallet/visored,
		/obj/item/clothing/neck/roguetown/bevor,
		/obj/item/clothing/cloak/tabard/stabard/surcoat/guard,
		/obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
		/obj/item/clothing/suit/roguetown/armor/chainmail,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/clothing/gloves/roguetown/plate,
		/obj/item/clothing/under/roguetown/chainlegs,
		/obj/item/clothing/shoes/roguetown/boots/armor,
		/obj/item/storage/belt/rogue/leather/steel,
		/obj/item/rogueweapon/scabbard/gwstrap,
		/obj/item/rogueweapon/halberd,
	)

/datum/royal_commission/knight
	name = "Knight Equipment Crate"
	desc = "Equipment kit for a dismounted knight."
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/knight,
		/obj/item/clothing/neck/roguetown/gorget/steel,
		/obj/item/clothing/cloak/tabard/knight/guard,
		/obj/item/clothing/suit/roguetown/armor/plate,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/clothing/gloves/roguetown/plate,
		/obj/item/clothing/under/roguetown/platelegs,
		/obj/item/clothing/shoes/roguetown/boots/armor,
		/obj/item/storage/belt/rogue/leather/steel,
		/obj/item/rogueweapon/scabbard/sword,
		/obj/item/rogueweapon/sword/long,
	)

/datum/royal_commission/caparison
	name = "Royal Caparison"
	desc = "A saiga caparison in ducal colours."
	contains = list(
		/obj/item/caparison/azure,
	)

GLOBAL_LIST_INIT(royal_commissions, init_royal_commissions())

/proc/init_royal_commissions()
	var/list/result = list()
	for(var/path in subtypesof(/datum/royal_commission))
		result += new path
	return result
