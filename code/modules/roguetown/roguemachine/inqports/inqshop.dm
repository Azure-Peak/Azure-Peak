GLOBAL_LIST_EMPTY(inqsupplies)

/datum/inqports
	var/name = null
	var/item_type = null // What gets delivered. For crates, the crate that `contains` is packed into.
	var/list/contains = null // Typepath = count, spawned inside item_type.
	var/content_desc = null // MARQUETTE hover text. Replaces the generated contents list.
	var/marquescost = 0
	var/maximum = null // If there's no maximum, it's infinite.
	var/remaining = null // Limited stock items.
	var/category = null // MARQUETTE tab. Only categories with stocked items get a tab.

/datum/inqports/New()
	..()
	remaining = maximum

// Tabs follow the declaration order of these bases, and items within a tab follow their order in this file.
/datum/inqports/reliquary/
	category = "✤ RELIQUARY ✤"

/datum/inqports/bataille/
	category = "✤ BATAILLE ✤"

/datum/inqports/supplies/
	category = "✤ SUPPLIES ✤"

/datum/inqports/articles/
	category = "✤ ARTICLES ✤"

/datum/inqports/equipment/
	category = "✤ EQUIPMENT ✤"

/datum/inqports/wardrobe/
	category = "✤ WARDROBE ✤"


/obj/structure/closet/crate/chest/inqcrate/supplies/
	name = "inquisitorial supply crate"
	desc = "A crate of boswellia wood, marked with the sigil of the Holy Psydonic Inquisition."

/obj/structure/closet/crate/chest/inqcrate/articles/
	name = "inquisitorial article crate"
	desc = "A crate of boswellia wood, marked with the sigil of the Holy Psydonic Inquisition."

/obj/structure/closet/crate/chest/inqreliquary/relic/
	name = "reliquary crate"
	desc = "A decorated crate of boswellia wood, braced with silver and marked with the Archbishop's personal sigil."

/obj/structure/closet/crate/chest/inqcrate/equipment/
	name = "inquisitorial equipment crate"
	desc = "A crate of boswellia wood, marked with the sigil of the Holy Psydonic Inquisition."

/obj/structure/closet/crate/chest/inqcrate/wardrobe/
	name = "inquisitorial wardrobe crate"
	desc = "A crate of boswellia wood, marked with the sigil of the Holy Psydonic Inquisition."

/// ✤ RELIQUARY ✤ START HERE! WOW!

// Armaments

/datum/inqports/reliquary/psymaul
	name = "Relic - The Maul, Evershattering"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic
	contains = list(
		/obj/item/rogueweapon/mace/maul/grand/psy = 1,
		/obj/item/rogueweapon/scabbard/gwstrap = 1, //so you can lug it around
	)
	marquescost = 8 //its meant to be easy to acquire, even solo orthodoxist can get it. unique weapon/wall leveling tool, marq shop keeps it from being stolen until you get the thing.
	maximum = 1
	//it does 15% of max structure integ as damage, get siegebows if you want more leveling walls and faster.

//Intended to exist seperate to inquisitor.

/datum/inqports/reliquary/superbow
	name = "Relic - The Ballista, Eversundering"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic
	contains = list(
		/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/relic/marque = 1,
		/obj/item/quiver/bolt/heavy/stake_silver = 1,
	)
	marquescost = 16
	maximum = 1

/datum/inqports/reliquary/psyarmor
	name = "Relic - The Platemaille, Everwithstanding"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/ornate/ordinator = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/ordinator = 1,
		/obj/item/clothing/wrists/roguetown/bracers/psythorns = 1,
		/obj/item/clothing/head/roguetown/helmet/blacksteel/psychains = 1,
		/obj/item/clothing/shoes/roguetown/boots/otavan/inqboots = 1,
		/obj/item/clothing/gloves/roguetown/plate = 1,
		/obj/item/clothing/under/roguetown/platelegs = 1,
		/obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli = 1,
	)
	marquescost = 16
	maximum = 1

// Devices

/datum/inqports/reliquary/crankbox
	name = "Relic - The Crankbox, Everwarding"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic
	contains = list(/obj/item/psydonmusicbox = 1)
	marquescost = 16
	maximum = 1

/datum/inqports/reliquary/bmirror
	name = "Relic - The Mirrors, Everseeing"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic
	contains = list(/obj/item/inqarticles/bmirror = 1)
	marquescost = 8
	maximum = 2

// ✤ BATAILLE ✤ RIGHT HERE!

// Melee, smallest to largest

/datum/inqports/bataille/silverstake
	name = "1 Silver-Tipped Stake"
	item_type = /obj/item/rogueweapon/huntingknife/idagger/steel/silver/stake/psy/preblessed
	maximum = 5
	marquescost = 4

/datum/inqports/bataille/dagger
	name = "1 Steel Dagger"
	item_type = /obj/item/rogueweapon/huntingknife/idagger/steel
	marquescost = 2

/datum/inqports/bataille/shortsword
	name = "1 Steel Shortsword"
	item_type = /obj/item/rogueweapon/sword/short
	marquescost = 2

/datum/inqports/bataille/armingsword
	name = "1 Arming Sword"
	item_type = /obj/item/rogueweapon/sword
	marquescost = 2

/datum/inqports/bataille/longsword
	name = "1 Longsword"
	item_type = /obj/item/rogueweapon/sword/long
	marquescost = 2

/datum/inqports/bataille/battleaxe
	name = "1 Battle Axe"
	item_type = /obj/item/rogueweapon/stoneaxe/battle
	marquescost = 2

/datum/inqports/bataille/flail
	name = "1 Steel Flail"
	item_type = /obj/item/rogueweapon/flail/steel
	marquescost = 2

/datum/inqports/bataille/billhook
	name = "1 Billhook"
	item_type = /obj/item/rogueweapon/spear/billhook
	marquescost = 2

/datum/inqports/bataille/halberd
	name = "1 Halberd"
	item_type = /obj/item/rogueweapon/halberd
	marquescost = 2

/datum/inqports/bataille/buckler
	name = "1 Buckler"
	item_type = /obj/item/rogueweapon/shield/buckler
	marquescost = 2

// Ranged

/datum/inqports/bataille/recurvebow
	name = "1 Recurve Bow"
	item_type = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	marquescost = 2

/datum/inqports/bataille/crossbow
	name = "1 Crossbow"
	item_type = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	marquescost = 2

/datum/inqports/bataille/slurbow
	name = "1 Slurbow"
	item_type = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	marquescost = 2

// Arrows

/datum/inqports/bataille/arrows
	name = "1 Quiver of Broadhead Arrows"
	item_type = /obj/item/quiver/arrows
	marquescost = 2

/datum/inqports/bataille/silvarrows
	name = "1 Quiver of Silver Arrows"
	item_type = /obj/item/quiver/silver
	marquescost = 4

// Light bolts

/datum/inqports/bataille/lightbolts
	name = "1 Quiver of Light Bolts"
	item_type = /obj/item/quiver/bolt/light
	marquescost = 2

/datum/inqports/bataille/blessedlightbolts
	name = "1 Quiver of Light Sunderbolts"
	item_type = /obj/item/quiver/bolt/lightholy
	marquescost = 4

// Bolts

/datum/inqports/bataille/bolts
	name = "1 Quiver of Bolts"
	item_type = /obj/item/quiver/bolt/standard
	marquescost = 2

/datum/inqports/bataille/silvbolts
	name = "1 Quiver of Silver Bolts"
	item_type = /obj/item/quiver/bolt/silver
	marquescost = 4

/datum/inqports/bataille/blessedbolts
	name = "1 Quiver of Sunderbolts"
	item_type = /obj/item/quiver/bolt/holy
	marquescost = 4

/datum/inqports/bataille/pyrobolts
	name = "1 Quiver of Pyrobolts"
	item_type = /obj/item/quiver/bolt/pyro
	marquescost = 4

// Heavy bolts

/datum/inqports/bataille/siegestake
	name = "1 Quiver of Siegestakes"
	item_type = /obj/item/quiver/bolt/heavy/stake
	marquescost = 4

/datum/inqports/bataille/silvheavybolts
	name = "1 Quiver of Silver Heavy Bolts"
	maximum = 3
	item_type = /obj/item/quiver/bolt/heavy/silver
	marquescost = 8

/datum/inqports/bataille/siegestakesilver
	name = "1 Quiver of Silver-Tipped Siegestakes"
	maximum = 3
	item_type = /obj/item/quiver/bolt/heavy/stake_silver
	marquescost = 8

/// ✤ SUPPLIES ✤ START HERE! WOW!

// The Archbishop's

/datum/inqports/supplies/extrafunding
	name = "The Archbishop's Allowance"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(/obj/item/roguecoin/silver/inqpile = 4)
	content_desc = "80 Ziliquae (400 mammons)"
	marquescost = 16
	maximum = 3

/obj/item/roguecoin/silver/inqpile/Initialize(mapload)
	. = ..()
	set_quantity(20)

/datum/inqports/supplies/bullion
	name = "The Archibishop's Bullion"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic
	contains = list(/obj/item/ingot/silverblessed/bullion = 6)
	marquescost = 16
	maximum = 5

/datum/inqports/supplies/quicksilver
	name = "The Archbishop's Poultice"
	item_type = /obj/item/quicksilver
	content_desc = "A quicksilver poultice to cure fiends"
	maximum = 1
	marquescost = 12

/datum/inqports/supplies/litany
	name = "The Archbishop's Litany"
	item_type = /obj/item/inqarticles/litany
	content_desc = "A singular blessing for Psydonic weaponary"
	maximum = 5
	marquescost = 6

// Medicine

/datum/inqports/supplies/medical
	name = "5 Needles and Bandaged Rolls"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(
		/obj/item/needle = 5,
		/obj/item/natural/bundle/cloth/bandage/full = 5,
	)
	marquescost = 2

/obj/item/natural/bundle/cloth/roll/Initialize(mapload)
	. = ..()
	icon_state = "clothroll2"
	amount = 10
	grid_width = 64

/datum/inqports/supplies/lifeblood
	name = "3 Bottles of Lifeblood"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 3)
	content_desc = "3 bottles of health potion (50u each)"
	marquescost = 10

/datum/inqports/supplies/restorationbig
	name = "3 Bottles of Restoration"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/restoration = 3)
	content_desc = "3 bottles of restoration potion (50u each)"
	marquescost = 12
	maximum = 3

/datum/inqports/supplies/restoration
	name = "3 Vials of Restoration"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/restoration = 3)
	content_desc = "3 vials of restoration potion (30u each)"
	marquescost = 6

/datum/inqports/supplies/manna
	name = "3 Bottles of Manna"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/manapot = 3)
	content_desc = "3 bottles of mana potion (50u each)"
	marquescost = 8

// Provisions

/datum/inqports/supplies/psybuns
	name = "The 'Otavan Bakery Special' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/psycrossbun = 10,
		/obj/item/reagent_containers/glass/bottle/alchemical/blessedwater = 10,
	)
	content_desc = "10 psycrossbuns & 10 vials of blessed water (30u each)"
	marquescost = 8

/datum/inqports/supplies/flint
	name = "1 Tool of Firestarting"
	item_type = /obj/item/flint
	marquescost = 1

// Explosives

/datum/inqports/supplies/smokes
	name = "3 Smokebombs"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(/obj/item/explosive/impact/smoke/bomb = 3)
	marquescost = 4

/datum/inqports/supplies/bottlebombs
	name = "3 Bottlebombs"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(/obj/item/explosive/fused/bottle = 3)
	marquescost = 4

/datum/inqports/supplies/tnt
	name = "3 Blastpowder Sticks"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(/obj/item/explosive/fused/powder/stick = 3)
	marquescost = 4
	maximum = 3

/datum/inqports/supplies/tntsatchel
	name = "1 Blastpowder Satchel"
	item_type = /obj/item/explosive/fused/powder/satchel
	marquescost = 8
	maximum = 3

// ✤ ARTICLES ✤ RIGHT HERE! THAT'S RIGHT!

// INDEXERs and writs

/datum/inqports/articles/indexers
	name = "3 INDEXERs"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles
	contains = list(/obj/item/inqarticles/indexer = 3)
	marquescost = 3

/datum/inqports/articles/accusations
	name = "3 Writs of Accusation"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles
	contains = list(/obj/item/paper/inqslip/accusation = 3)
	marquescost = 6

/datum/inqports/articles/indexaccused
	name = "3 INDEXERs and Writs of Accusation"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles
	contains = list(
		/obj/item/inqarticles/indexer = 3,
		/obj/item/paper/inqslip/accusation = 3,
	)
	marquescost = 6
	maximum = 1

/datum/inqports/articles/confessions
	name = "3 Writs of Confession"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles
	contains = list(/obj/item/paper/inqslip/confession = 3)
	marquescost = 6

// Sealing

/datum/inqports/articles/blessedring
	name = "1 Blessed Signet Ring"
	item_type = /obj/item/clothing/ring/signet/psy
	marquescost = 1

/datum/inqports/articles/stamppot
	name = "1 Tallowpot"
	item_type = /obj/item/tallowpot
	marquescost = 1

/datum/inqports/articles/stampstuff
	name = "1 Lump of Redtallow"
	item_type = /obj/item/reagent_containers/food/snacks/tallow/red
	marquescost = 1

// ✤ EQUIPMENT ✤ BELONGS HERE! JUST BELOW!

// Espionage

/datum/inqports/equipment/listener
	name = "1 Listening Device"
	item_type = /obj/item/listeningdevice
	marquescost = 2

/datum/inqports/equipment/whisperer
	name = "1 Secret Whisperer"
	item_type = /obj/item/speakerinq
	marquescost = 2

/datum/inqports/equipment/nocshades
	name = "1 Pair of Nocshade-Lenses"
	item_type = /obj/item/clothing/mask/rogue/spectacles/inq
	marquescost = 6

// Utility

/datum/inqports/equipment/climbinggear
	name = "1 Set of Climbing Gear"
	item_type = /obj/item/clothing/climbing_gear
	marquescost = 6

/datum/inqports/equipment/psybles
	name = "3 Books of the Psydonic Orthodoxy"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles
	contains = list(/obj/item/book/rogue/bibble/psy = 3)
	marquescost = 1

// Restraints

/datum/inqports/equipment/inqcordage
	name = "3 Spools of Inquiry Cordage"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment
	contains = list(/obj/item/rope/inqarticles/inquirycord = 3)
	marquescost = 2

/datum/inqports/equipment/chains
	name = "3 Lengths of Chain"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies
	contains = list(/obj/item/rope/chain = 3)
	marquescost = 1

/datum/inqports/equipment/blackbags
	name = "3 Black Bags"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment
	contains = list(/obj/item/clothing/head/inqarticles/blackbag = 3)
	marquescost = 2

/datum/inqports/equipment/garrote
	name = "1 Seizing Garrote"
	item_type = /obj/item/inqarticles/garrote
	marquescost = 4



// ✤ WARDROBE ✤ STARTS HERE! YEP!

/obj/item/clothing/neck/roguetown/fencerguard/inq
	color = "#8b1414"
	detail_color = "#99b2b1"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq
	color = "#8b1414"
	detail_color = "#99b2b1"

// Psycrosses

/datum/inqports/wardrobe/psycross
	name = "1 Psycross"
	item_type = /obj/item/clothing/neck/roguetown/psicross
	marquescost = 1

/datum/inqports/wardrobe/psycrosssilver
	name = "1 Silver Psycross"
	item_type = /obj/item/clothing/neck/roguetown/psicross/silver
	marquescost = 12

// Satchels

/datum/inqports/wardrobe/otavansatchel
	name = "1 Satchel, Otavan"
	item_type = /obj/item/storage/backpack/rogue/satchel/otavan
	marquescost = 3

/datum/inqports/wardrobe/otavansatchel/short
	name = "1 Short Satchel, Otavan"
	item_type = /obj/item/storage/backpack/rogue/satchel/otavan/short
	marquescost = 4

/datum/inqports/wardrobe/satchelbelted
	name = "1 Satchel, Belted"
	item_type = /obj/item/storage/backpack/rogue/satchel/beltpack
	marquescost = 6

// Masks

/datum/inqports/wardrobe/psysack
	name = "1 Psydonian Facemask"
	item_type = /obj/item/clothing/mask/rogue/sack/psy
	marquescost = 3

/datum/inqports/wardrobe/strangemask
	name = "1 Confessor's Strange Mask"
	item_type = /obj/item/clothing/mask/rogue/facemask/steel/confessor
	marquescost = 6

// Psydonian armour

/datum/inqports/wardrobe/psydonchains
	name = "1 Psydonian Chain-Orle"
	item_type = /obj/item/clothing/head/roguetown/helmet/blacksteel/psychains
	marquescost = 6

/datum/inqports/wardrobe/psydonthorns
	name = "1 Psydonian Crown of Thorns"
	item_type = /obj/item/clothing/wrists/roguetown/bracers/psythorns
	marquescost = 12

/datum/inqports/wardrobe/psydonhelms
	name = "The 'Greathelms of Psydon' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/ornate/barbute = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/ornate/sallet = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/ornate/bucket = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/ornate/armet = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/ornate/volfhelm = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/ornate/absolver/unblessed = 1,
	)
	marquescost = 12
	maximum = 1

// Outfits

/datum/inqports/wardrobe/inspector
	name = "The 'Inquisitor's Personal Wardrobe' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe
	contains = list(
		/obj/item/clothing/head/roguetown/inqhat = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat = 1,
		/obj/item/clothing/gloves/roguetown/otavan/inqgloves = 1,
		/obj/item/clothing/shoes/roguetown/boots/otavan/inqboots = 1,
	)
	marquescost = 12

/datum/inqports/wardrobe/inspectorcoat
	name = "The 'Inquisitior's Spare Laundry' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe
	contains = list(
		/obj/item/clothing/head/roguetown/inqhat = 2,
		/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat = 2,
	)
	marquescost = 12

/datum/inqports/wardrobe/psydonianstandard
	name = "The 'Inquisitorial Standard' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe
	contains = list(
		/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan = 1,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq = 1,
		/obj/item/clothing/gloves/roguetown/otavan/psygloves = 1,
		/obj/item/clothing/shoes/roguetown/boots/psydonboots = 1,
	)
	marquescost = 12

/datum/inqports/wardrobe/confessionalcombo
	name = "The 'Confessional Combination' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe
	contains = list(
		/obj/item/clothing/head/roguetown/roguehood/psydon/confessor = 1,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor = 1,
	)
	marquescost = 12

/datum/inqports/wardrobe/fencerset
	name = "The 'Otavan Fencer's Padded Wardrobe' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq = 1,
		/obj/item/clothing/neck/roguetown/fencerguard/inq = 1,
		/obj/item/clothing/gloves/roguetown/otavan = 1,
		/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan = 1,
		/obj/item/clothing/shoes/roguetown/boots/otavan = 1,
	)
	marquescost = 12

/datum/inqports/wardrobe/fencersthree
	name = "The 'Otavan Fencer's Triple Gambeson' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq = 3)
	marquescost = 12

/datum/inqports/wardrobe/nobledressup
	name = "The 'Cost Of Nobility' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe
	contains = list(
		/obj/item/clothing/cloak/lordcloak/ladycloak = 1,
		/obj/item/clothing/cloak/lordcloak = 1,
		/obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat = 1,
		/obj/item/clothing/suit/roguetown/shirt/dress/royal = 1,
		/obj/item/clothing/wrists/roguetown/royalsleeves = 1,
		/obj/item/clothing/suit/roguetown/shirt/dress/royal/prince = 1,
		/obj/item/clothing/neck/roguetown/psicross/g = 2,
	)
	marquescost = 8
