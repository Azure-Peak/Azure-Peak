/datum/inqports/reliquary/
	category = 1 // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", "✤ RELIQUARY ✤", "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/supplies/
	category = 2  // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", "✤ RELIQUARY ✤", "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/articles/
	category = 3  // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", "✤ RELIQUARY ✤", "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/equipment/
	category = 4 // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", "✤ RELIQUARY ✤", "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/wardrobe/
	category = 5 // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", "✤ RELIQUARY ✤", "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".


/obj/structure/closet/crate/chest/inqcrate/supplies/
	name = "inquisitorial supply crate"
	desc = "A crate of boswellia wood, marked with the sigil of the Holy Psydonic Inquisition." 

/obj/structure/closet/crate/chest/inqcrate/articles/
	name = "inquisitorial article crate"
	desc = "A crate of boswellia wood, marked with the sigil of the Holy Psydonic Inquisition." 

/obj/structure/closet/crate/chest/inqreliquary/relic/
	name = "reliquary crate"
	desc = "A decorated crate of boswellia wood, braced with silver and marked with the Archbishop's personal sigil. It houses a " 

/obj/structure/closet/crate/chest/inqcrate/equipment/
	name = "inquisitorial equipment crate"
	desc = "A crate of boswellia wood, marked with the sigil of the Holy Psydonic Inquisition." 

/obj/structure/closet/crate/chest/inqcrate/wardrobe/
	name = "inquisitorial wardrobe crate"
	desc = "A crate of boswellia wood, marked with the sigil of the Holy Psydonic Inquisition." 

/// ✤ RELIQUARY ✤ START HERE! WOW!

//No idea how to make this show up. Relocate 'relic'-type items here, when able.

/// ✤ SUPPLIES ✤ START HERE! WOW!

/datum/inqports/supplies/extrafunding
	name = "The Archbishop's Allowance - Hundreds Of Mammons"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/extrafunding
	marquescost = 16
	maximum = 1

/obj/item/roguecoin/silver/inqpile/Initialize()
	. = ..()
	set_quantity(20)

/obj/structure/closet/crate/chest/inqcrate/supplies/extrafunding/Initialize()
	. = ..()
	new /obj/item/roguecoin/silver/inqpile(src)
	new /obj/item/roguecoin/silver/inqpile(src)
	new /obj/item/roguecoin/silver/inqpile(src)
	new /obj/item/roguecoin/silver/inqpile(src)

/datum/inqports/supplies/bullion
	name = "The Archibishop's Bullion - Blessed Silver Ingots"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic/bullion/
	marquescost = 16
	maximum = 3

/obj/structure/closet/crate/chest/inqreliquary/relic/bullion/Initialize()
	. = ..()
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)

/datum/inqports/supplies/quicksilver
	name = "The Archbishop's Poultice"
	item_type = /obj/item/quicksilver
	maximum = 1
	marquescost = 12

/datum/inqports/supplies/psybuns
	name = "The 'Otavan Bakery Special' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/psybuns
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/supplies/psybuns/Initialize()
	. = ..()
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)

/datum/inqports/supplies/medical
	name = "5 Needles and Bandaged Rolls"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/medical
	marquescost = 6

/obj/item/natural/bundle/cloth/roll/Initialize()
	. = ..()
	icon_state = "clothroll2"
	amount = 10
	grid_width = 64

/obj/structure/closet/crate/chest/inqcrate/supplies/medical/Initialize()
	. = ..()
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/natural/bundle/cloth/bandage/full(src)
	new /obj/item/natural/bundle/cloth/bandage/full(src)
	new /obj/item/natural/bundle/cloth/bandage/full(src)
	new /obj/item/natural/bundle/cloth/bandage/full(src)
	new /obj/item/natural/bundle/cloth/bandage/full(src)

/datum/inqports/supplies/lifeblood
	name = "3 Vials of Strong Lifeblood"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/sredvials
	maximum = 1
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/supplies/sredvials/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew(src)

/datum/inqports/supplies/manna
	name = "3 Bottles of Manna"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/manna
	maximum = 3
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/supplies/manna/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/manapot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/manapot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/manapot(src)

/datum/inqports/supplies/smokes
	name = "3 Smokebombs"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/smokes
	marquescost = 4

/obj/structure/closet/crate/chest/inqcrate/supplies/smokes/Initialize()
	. = ..()
	new /obj/item/bomb/smoke(src)
	new /obj/item/bomb/smoke(src)
	new /obj/item/bomb/smoke(src)

/datum/inqports/supplies/bottlebombs
	name = "3 Bottlebombs"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/bottlebombs
	marquescost = 6
	maximum = 3

/obj/structure/closet/crate/chest/inqcrate/supplies/bottlebombs/Initialize()
	. = ..()
	new /obj/item/bomb(src)
	new /obj/item/bomb(src)
	new /obj/item/bomb(src)

/datum/inqports/supplies/tnt
	name = "3 Blastpowder Sticks"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/tnt
	marquescost = 8
	maximum = 3

/obj/structure/closet/crate/chest/inqcrate/supplies/tnt/Initialize()
	. = ..()
	new /obj/item/tntstick(src)
	new /obj/item/tntstick(src)
	new /obj/item/tntstick(src)

/datum/inqports/supplies/tntsatchel
	name = "1 Blastpowder Satchel"
	item_type = /obj/item/satchel_bomb
	marquescost = 12
	maximum = 2

// ✤ ARTICLES ✤ RIGHT HERE! THAT'S RIGHT!

/datum/inqports/articles/crankbox
	name = "Relic - The Crankbox, Everwarding"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic/crankbox/
	marquescost = 16
	maximum = 1

/obj/structure/closet/crate/chest/inqreliquary/relic/crankbox/Initialize()
	. = ..()
	new /obj/item/psydonmusicbox(src)

/datum/inqports/articles/bmirror
	name = "Relic - The Mirrors, Everseeing"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic/bmirror/
	marquescost = 8
	maximum = 2

/obj/structure/closet/crate/chest/inqreliquary/relic/bmirror/Initialize()
	. = ..()
	new /obj/item/inqarticles/bmirror(src)

/datum/inqports/articles/superbow
	name = "Relic - The Ballista, Evercracking"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic/superbow/
	marquescost = 16
	maximum = 1

/obj/structure/closet/crate/chest/inqreliquary/relic/superbow/Initialize()
	. = ..()
	new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy(src)
	new /obj/item/quiver/bolt/heavy/standard(src)
	new /obj/item/ammo_casing/caseless/rogue/heavy_bolt/silver(src)

/datum/inqports/articles/stampstuff
	name = "1 Lump of Redtallow"
	item_type = /obj/item/reagent_containers/food/snacks/tallow/red
	marquescost = 2

/datum/inqports/articles/stamppot
	name = "1 Tallowpot"
	item_type = /obj/item/inqarticles/tallowpot
	marquescost = 4

/datum/inqports/articles/indexers
	name = "3 INDEXERs"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/indexers
	marquescost = 3

/obj/structure/closet/crate/chest/inqcrate/articles/indexers/Initialize()
	. = ..()
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)

/datum/inqports/articles/accusations
	name = "3 Writs of Accusation"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/accusations
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/articles/accusations/Initialize()
	. = ..()
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)

/datum/inqports/articles/confessions
	name = "3 Writs of Confession"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/confessions
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/articles/confessions/Initialize()
	. = ..()
	new /obj/item/paper/inqslip/confession(src)
	new /obj/item/paper/inqslip/confession(src)
	new /obj/item/paper/inqslip/confession(src)

/datum/inqports/articles/indexaccused
	name = "3 INDEXERs and Writs of Accusation"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/indexaccused
	marquescost = 6
	maximum = 1

/obj/structure/closet/crate/chest/inqcrate/articles/indexaccused/Initialize()
	. = ..()
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)

// ✤ EQUIPMENT ✤ BELONGS HERE! JUST BELOW!

/datum/inqports/equipment/silvarrow
	name = "1 Silver Arrow"
	item_type = /obj/item/ammo_casing/caseless/rogue/arrow/silver
	maximum = 3
	marquescost = 6

/datum/inqports/equipment/silvbolt
	name = "1 Silver Bolt"
	item_type = /obj/item/ammo_casing/caseless/rogue/bolt/silver
	maximum = 3
	marquescost = 6

/datum/inqports/equipment/silvheavybolt
	name = "1 Silver Heavy Bolt"
	item_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt/silver
	maximum = 3
	marquescost = 8

/datum/inqports/equipment/silverstake
	name = "1 Silver-Tipped Stake"
	item_type = /obj/item/rogueweapon/huntingknife/idagger/silver/stake/psy
	maximum = 5
	marquescost = 8

/datum/inqports/supplies/blessedbolts
	name = "1 Quiver of Sunderbolts"
	item_type = /obj/item/quiver/holybolts
	marquescost = 6

/datum/inqports/equipment/nocshades
	name = "1 Pair of Nocshade-Lenses"
	item_type = /obj/item/clothing/mask/rogue/spectacles/inq
	marquescost = 10

/datum/inqports/equipment/climbinggear
	name = "1 Set of Climbing Gear"
	item_type = /obj/item/clothing/climbing_gear
	marquescost = 6

/datum/inqports/equipment/garrote
	name = "1 Seizing Garrote"
	item_type = /obj/item/inqarticles/garrote
	marquescost = 4

/datum/inqports/equipment/listener
	name = "1 Listening Device"
	item_type = /obj/item/listeningdevice
	marquescost = 2

/datum/inqports/equipment/whisperer
	name = "1 Secret Whisperer"
	item_type = /obj/item/speakerinq
	marquescost = 2

/datum/inqports/equipment/inqcordage
	name = "3 Spools of Inquiry Cordage"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment/inqcordage
	marquescost = 3

/obj/structure/closet/crate/chest/inqcrate/equipment/inqcordage/Initialize()
	. = ..()
	new /obj/item/rope/inqarticles/inquirycord(src)
	new /obj/item/rope/inqarticles/inquirycord(src)
	new /obj/item/rope/inqarticles/inquirycord(src)

/datum/inqports/equipment/chains
	name = "3 Lengths of Chain"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/chains
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/supplies/chains/Initialize()
	. = ..()
	new /obj/item/rope/chain(src)
	new /obj/item/rope/chain(src)
	new /obj/item/rope/chain(src)

/datum/inqports/equipment/blackbags
	name = "3 Black Bags"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment/blackbags
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/equipment/blackbags/Initialize()
	. = ..()
	new /obj/item/clothing/head/inqarticles/blackbag(src)
	new /obj/item/clothing/head/inqarticles/blackbag(src)
	new /obj/item/clothing/head/inqarticles/blackbag(src)

/datum/inqports/equipment/psybles
	name = "3 Tomes of Psydonic Scripture"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/psybles
	marquescost = 3

/obj/structure/closet/crate/chest/inqcrate/articles/psybles/Initialize()
	. = ..()
	new /obj/item/book/rogue/bibble/psy(src)
	new /obj/item/book/rogue/bibble/psy(src)
	new /obj/item/book/rogue/bibble/psy(src)

// ✤ WARDROBE ✤ STARTS HERE! YEP!

/obj/item/clothing/neck/roguetown/fencerguard/inq
	color = "#8b1414"
	detail_color = "#99b2b1"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq
	color = "#8b1414"
	detail_color = "#99b2b1"

/datum/inqports/wardrobe/psycross
	name = "1 Psycross"
	item_type = /obj/item/clothing/neck/roguetown/psicross
	marquescost = 2

/datum/inqports/wardrobe/psycrosssilver
	name = "1 Silver Psycross"
	item_type = /obj/item/clothing/neck/roguetown/psicross/silver
	maximum = 3
	marquescost = 12

/datum/inqports/wardrobe/otavansatchel
	name = "1 Satchel, Otavan Leather"
	item_type = /obj/item/storage/backpack/rogue/satchel/otavan
	marquescost = 3

/datum/inqports/wardrobe/satchelbelted
	name = "1 Satchel, Belted"
	item_type = /obj/item/storage/backpack/rogue/satchel/beltpack
	marquescost = 6

/datum/inqports/wardrobe/psysack
	name = "1 Psydonian Facemask"
	item_type = /obj/item/clothing/mask/rogue/sack/psy
	marquescost = 3

/datum/inqports/wardrobe/strangemask
	name = "1 Confessor's Strange Mask"
	item_type = /obj/item/clothing/mask/rogue/facemask/steel/confessor
	marquescost = 6

/datum/inqports/wardrobe/psydonthorns
	name = "1 Psydonian Crown of Thorns"
	item_type = /obj/item/clothing/wrists/roguetown/bracers/psythorns
	marquescost = 12

/datum/inqports/wardrobe/psydonhelms
	name = "The 'Greathelms of Psydon' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment/psydonhelms
	marquescost = 12
	maximum = 1

/obj/structure/closet/crate/chest/inqcrate/equipment/psydonhelms/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute(src)
	new /obj/item/clothing/head/roguetown/helmet/heavy/psysallet(src)
	new /obj/item/clothing/head/roguetown/helmet/heavy/psybucket(src)
	new /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm(src)
	new /obj/item/clothing/head/roguetown/helmet/heavy/absolver(src)

/datum/inqports/wardrobe/fencerset
	name = "The 'Otavan Fencer's Padded Wardrobe' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/fencerset
	marquescost = 12

/obj/structure/closet/crate/chest/inqcrate/wardrobe/fencerset/Initialize()
	. = ..()
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq(src)
	new /obj/item/clothing/neck/roguetown/fencerguard/inq(src)
	new /obj/item/clothing/gloves/roguetown/otavan(src)
	new /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan(src)
	new /obj/item/clothing/shoes/roguetown/boots/otavan(src)

/datum/inqports/wardrobe/fencersthree
	name = "The 'Otavan Fencer's Triple Gambeson' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/fencersthree
	marquescost = 12

/obj/structure/closet/crate/chest/inqcrate/wardrobe/fencersthree/Initialize()
	. = ..()
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq(src)

/datum/inqports/wardrobe/confessionalcombo
	name = "The 'Confessional Combination' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/confessionalcombo
	marquescost = 10

/obj/structure/closet/crate/chest/inqcrate/wardrobe/confessionalcombo/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/roguehood/psydon/confessor(src)
	new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor(src)

/datum/inqports/wardrobe/inspectorcoat
	name = "The 'Inquisitior's Spare Laundry' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/inspectorcoats
	marquescost = 10

/obj/structure/closet/crate/chest/inqcrate/wardrobe/inspectorcoats/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/inqhat(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat(src)
	new /obj/item/clothing/head/roguetown/inqhat(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat(src)

/datum/inqports/wardrobe/inspector
	name = "The 'Inquisitor's Personal Wardrobe' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/inspector
	marquescost = 10

/obj/structure/closet/crate/chest/inqcrate/wardrobe/inspector/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/inqhat(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat(src)
	new /obj/item/clothing/gloves/roguetown/otavan/inqgloves(src)
	new /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots(src)

/datum/inqports/wardrobe/psydonianstandard
	name = "The 'Inquisitorial Standard' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/psydonian
	marquescost = 10

/obj/structure/closet/crate/chest/inqcrate/wardrobe/psydonian/Initialize()
	. = ..()
	new /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq(src)
	new /obj/item/clothing/gloves/roguetown/otavan/psygloves(src)
	new /obj/item/clothing/shoes/roguetown/boots/psydonboots(src)

/datum/inqports/wardrobe/nobledressup
	name = "The 'Cost Of Nobility' Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/nobledressup
	marquescost = 20

/obj/structure/closet/crate/chest/inqcrate/wardrobe/nobledressup/Initialize()
	. = ..()
	new /obj/item/clothing/cloak/lordcloak/ladycloak(src)
	new /obj/item/clothing/cloak/lordcloak(src)
	new /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat(src)
	new /obj/item/clothing/suit/roguetown/shirt/dress/royal(src)
	new /obj/item/clothing/wrists/roguetown/royalsleeves(src)
	new /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince(src)
	new /obj/item/clothing/neck/roguetown/psicross/g(src)
	new /obj/item/clothing/neck/roguetown/psicross/g(src)
