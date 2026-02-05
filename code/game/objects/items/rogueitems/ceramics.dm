/* Tools for using with Pottery */

/* Items made from Pottery */

// Uncooked items -- Still need to be brought to a kiln
// Those are all children of natural/clay so that they can inherit the Glaze method.

//Bottle - subtype of glass bottle
/obj/item/natural/clay/claybottle
	name = "unglazed clay bottle"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottleraw"
	desc = "A bottle fashioned from clay. Still needs to be glazed to be useful."
	cooked_type = /obj/item/reagent_containers/glass/bottle/claybottle

/obj/item/reagent_containers/glass/bottle/claybottle
	name = "clay vessel"
	desc = "A ceramic bottle." //The sprite was anything but small
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottlecook"
	volume = 75 // Larger than glass bottle
	sellprice = 6
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

//Vase - bigger bottle
/obj/item/natural/clay/clayvase
	name = "unglazed clay vase"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvaseraw"
	desc = "A vase fashioned from clay. Still needs to be glazed to be useful."
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayvase

/obj/item/reagent_containers/glass/bottle/clayvase
	name = "ceramic vase"
	desc = "A large sized ceramic vase."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvasecook"
	volume = 65 // Larger than glass bottle
	sellprice = 9
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

//Fancy vase - bigger bottle + fancy
/obj/item/natural/clay/clayfancyvase
	name = "unglazed fancy clay vase"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvaseraw"
	desc = "A fancy vase fashioned from clay. Still needs to be glazed to be useful."
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayfancyvase

/obj/item/reagent_containers/glass/bottle/clayfancyvase
	name = "fancy ceramic vase"
	desc = "A large sized fancy ceramic vase."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvasecook"
	volume = 65 // Larger than glass bottle
	sellprice = 14
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

//Flask (was a cup) - subtype of regular cup but can shatter.
/obj/item/natural/clay/claycup
	name = "unglazed clay flask"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupraw"
	desc = "A small flask fashioned from clay. Still needs to be glazed to be useful."
	cooked_type = /obj/item/reagent_containers/glass/cup/claycup

/obj/item/reagent_containers/glass/cup/claycup
	name = "clay flask"
	desc = "A small ceramic flask."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupcook"
	sellprice = 3
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

// Raw teapot
/obj/item/natural/clay/rawteapot
	name = "raw teapot"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_raw"
	desc = "A teapot fashioned from clay. Still needs to be baked to be useful."
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/teapot

// Raw teacup
/obj/item/natural/clay/rawteacup
	name = "raw teacup"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "teacup_raw"
	desc = "A teacup fashioned from clay. Still needs to be baked to be useful."
	cooked_type = /obj/item/reagent_containers/glass/cup/ceramic

//Bricks - Makes bricks which are used for building. (Need brick-wall sprites for this.. augh..)
/obj/item/natural/clay/claybrick
	name = "uncooked clay brick"
	desc = "An uncooked clay brick. It still needs to be cooked in a kiln."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybrickraw"
	cooked_type = /obj/item/natural/brick

//Statues - Basically cheapest version of the metal-made statues, but way easier to make given no rare material usage. Just skill. Plus, dyeable.
/obj/item/natural/clay/claystatue
	name = "uncooked clay statue"
	desc = "An uncooked clay statue. It still needs to be cooked in a kiln."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claystatueraw"
	cooked_type = /obj/item/roguestatue/clay

/obj/item/roguestatue/clay
	name = "ceramic statue"
	desc = "A ceramic statue, shining in its elegance!"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claystatuecooked1"
	smeltresult = null	//No resource return
	sellprice = 15		//Iron is worth 20, so these gotta be a little cheaper

/obj/item/roguestatue/clay/Initialize()
	. = ..()
	icon_state = "claystatuecooked[pick(1,2)]"

/obj/item/roguestatue/glass
	name = "glass statue"
	desc = "A statue made of fine glass. An incredible amount of skill must have went into this fragile masterpiece!"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "statueglass1"
	smeltresult = null	//No resource return
	sellprice = 70		//Silver is roughly 90 mammon, steel is 40. This sits roughly between. It's high skill to make and a bit of a grind so - worth it since resources to make aren't rare..

/obj/item/roguestatue/glass/Initialize()
	. = ..()
	icon_state = "statueglass[pick(1,2)]"
