/datum/crafting_recipe/roguetown/ceramics
	abstract_type = /datum/crafting_recipe/roguetown/ceramics
	display_category = ITEM_CAT_POTTERY
	skillcraft = /datum/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/clay
	structurecraft = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/glass
	tools = list(/obj/item/rogueweapon/blowrod) // To shape it
	structurecraft = /obj/machinery/light/rogue/smelter // To heat it

/* 0 diff */
/datum/crafting_recipe/roguetown/ceramics/clay/claycup
	name = "clay flask, dyeable"
	result = list(/obj/item/natural/clay/claycup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/claybauble
	name = "clay bauble x3"
	result = list(/obj/item/natural/clay/rawbauble, /obj/item/natural/clay/rawbauble, /obj/item/natural/clay/rawbauble)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0 

/datum/crafting_recipe/roguetown/ceramics/claycameo
	name = "clay cameo"
	result = list(/obj/item/natural/clay/rawcameo)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0 

/datum/crafting_recipe/roguetown/ceramics/clay/claycup3
	name = "clay flask, dyeable (3x)"
	result = list(/obj/item/natural/clay/claycup, /obj/item/natural/clay/claycup, /obj/item/natural/clay/claycup)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/claycupclassic
	name = "clay flask, traditional"
	result = list(/obj/item/natural/clay/claycupclassic)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

	name = "clay cup"
	result = list(/obj/item/natural/clay/rawcup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/claycup3classic3
	name = "clay flask, traditional (3x)"
	result = list(/obj/item/natural/clay/claycupclassic, /obj/item/natural/clay/claycupclassic, /obj/item/natural/clay/claycupclassic)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/claybrick
	name = "clay brick"
	result = list(/obj/item/natural/clay/claybrick)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/claybrick3
	name = "clay brick 3x"
	result = list(/obj/item/natural/clay/claybrick, /obj/item/natural/clay/claybrick, /obj/item/natural/clay/claybrick)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0

/* 1 diff */
/datum/crafting_recipe/roguetown/ceramics/clay/claybottle
	name = "clay bottle, dyeable"
	result = list(/obj/item/natural/clay/claybottle)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/ceramics/clayfigurine
	name = "clay figurine"
	result = list(/obj/item/natural/clay/rawfigurine)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/ceramics/clayfish
	name = "clay fish figurine"
	result = list(/obj/item/natural/clay/rawfish)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/ceramics/clayring
	name = "clay ring"
	result = list(/obj/item/natural/clay/rawring)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/ceramics/clayduck
	name = "clay duck figurine"
	result = list(/obj/item/natural/clay/rawduck)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/ceramics/claydisplay
	name = "clay display stand"
	result = list(/obj/item/natural/clay/rawdisplay)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/ceramics/clayheart
	name = "clay heart"
	result = list(/obj/item/natural/clay/rawheart)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/ceramics/claybowl
	name = "clay bowl"
	result = list(/obj/item/natural/clay/rawbowl)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/ceramics/clayspoon
	name = "clay spoon"
	result = list(/obj/item/natural/clay/rawspoon)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/ceramics/clayfork
	name = "clay fork"
	result = list(/obj/item/natural/clay/rawfork)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/ceramics/clayplatter
	name = "clay platter"
	result = list(/obj/item/natural/clay/rawplatter)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/ceramics/clay/claybottleclassic
	name = "clay bottle, traditional"
	result = list(/obj/item/natural/clay/claybottleclassic)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/* 2 diff */
/datum/crafting_recipe/roguetown/ceramics/clay/clayvase
	name = "clay vase, dyeable"
	result = list(/obj/item/natural/clay/clayvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/ceramics/clay/clayvaseclassic
	name = "clay vase, traditional"
	result = list(/obj/item/natural/clay/clayvaseclassic)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/ceramics/claysun
	name = "clay sun"
	result = list(/obj/item/natural/clay/rawsun)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/ceramics/clayobelisk
	name = "clay obelisk"
	result = list(/obj/item/natural/clay/rawobelisk)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/ceramics/claycomb
	name = "clay comb"
	result = list(/obj/item/natural/clay/rawcomb)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/ceramics/claytablet
	name = "clay tablet"
	result = list(/obj/item/natural/clay/rawtablet)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/ceramics/clayamulet
	name = "clay amulet"
	result = list(/obj/item/natural/clay/rawamulet)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 2

/* 3 diff */
/datum/crafting_recipe/roguetown/ceramics/clay/clayfancyvase
	name = "fancy clay vase, dyeable"
	result = list(/obj/item/natural/clay/clayfancyvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/ceramics/clay/clayfancyvaseclassic
	name = "fancy clay vase, traditional"
	result = list(/obj/item/natural/clay/clayfancyvaseclassic)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/ceramics/clay/teapot
	name = "teapot"
	result = list(/obj/item/natural/clay/rawteapot)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/ceramics/claystatuette
	name = "clay statuette"
	result = list(/obj/item/natural/clay/rawstatuette)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/ceramics/claymoon
	name = "clay moon"
	result = list(/obj/item/natural/clay/rawmoon)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/ceramics/claycirclet
	name = "clay circlet"
	result = list(/obj/item/natural/clay/rawcirclet)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/ceramics/claygoblet
	name = "fancy clay goblet"
	result = list(/obj/item/natural/clay/rawcupfancy)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/ceramics/clay/teacup
	name = "teacup"
	result = list(/obj/item/natural/clay/rawteacup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 3

/* 4 diff */

	// '''Clay''' for making glass.
	// In reality, this isn't a clay, but rather, a batch of different materials.
	/*
	Traditionally, this 'batch' used to make glass panes requires three different types of materials to make:
	* A silica source, like sand, quartz or flint (This is the primary material. Silica has a melting point
		of about 1700C.)
	* flux, like soda ash (Na2CO3), potash(K2CO3) or Natron (sodium carbonate IIRC?), commonly used in ancient egyptian glassmaking.
		Flux is paramount to reduce the melting point of silica to something achievable in a kiln (or oven/furnace in the case of this game).
	* a Stablizer, like limestone, bone ash, or marble dust.
		Did you know 'pure' glass dissolves in water? The stablizer is what binds everything together and makes it strong.
	In reality, those different components will be abstracted in game, respectively to:
	*2x clay   (Assuming it is a base for acquiring Silica)
	*2x ash    (No abstraction needed. Plant/wood ash IS Na2CO3)
	*1x stone  (We'll just assume that regular stones have enough limestone in them) (We could use bones but those are too hard to get.)
	This should make glass neither trivial nor too challenging to make, especially given its a high-skill recipe.
	Smelting it into a pane is a fairly straightforward process with a mold.
	The goal should be to make it hard enough that only a dedicated potter can do it
	But not to the point of apothecary health potions where no one bothers with it.
	*/// -SunriseOYH

/datum/crafting_recipe/roguetown/ceramics/glassraw
	name = "glass batch (using limestone)"
	tools = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle)
	result = list(/obj/item/natural/glassbatch)
	reqs = list(/obj/item/natural/clay = 2, /obj/item/ash = 2, /obj/item/natural/stone = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/ceramics/glassraw_bone
	name = "glass batch (using bonemeal)"
	tools = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle)
	result = list(/obj/item/natural/glassbatch)
	reqs = list(/obj/item/natural/clay = 2, /obj/item/ash = 2, /obj/item/alch/bonemeal = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/ceramics/clay/claystatue
	name = "clay statue"
	result = list(/obj/item/natural/clay/claystatue)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 4

/datum/crafting_recipe/roguetown/ceramics/clayturtle
	name = "clay turtle statuette"
	result = list(/obj/item/natural/clay/rawturtle)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 4

/datum/crafting_recipe/roguetown/ceramics/clayurn
	name = "clay urn"
	result = list(/obj/item/natural/clay/rawurn)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 4

/datum/crafting_recipe/roguetown/ceramics/claybust
	name = "clay bust"
	result = list(/obj/item/natural/clay/rawbust)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 4


/* 5 diff */ // High-end glass containers. Should be a direct upgrade to clay in every possible way.

/datum/crafting_recipe/roguetown/ceramics/glass/statue
	name = "glass statue"
	result = list(/obj/item/roguestatue/glass)
	reqs = list(/obj/item/natural/glass = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/ceramics/glass/bottles
	name = "glass bottle (x2)"
	result = list(
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/glass/bottle
		)
	reqs = list(/obj/item/natural/glass = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/ceramics/glass/cups
	name = "glass goblet (x3)"
	result = list(
		/obj/item/reagent_containers/glass/cup/glass,
		/obj/item/reagent_containers/glass/cup/glass,
		/obj/item/reagent_containers/glass/cup/glass
		)
	reqs = list(/obj/item/natural/glass = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/ceramics/glass/cups
	name = "glass flute (x3)"
	result = list(
		/obj/item/reagent_containers/glass/cup/glass/flute,
		/obj/item/reagent_containers/glass/cup/glass/flute,
		/obj/item/reagent_containers/glass/cup/glass/flute
		)
	reqs = list(/obj/item/natural/glass = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/ceramics/glass/smallcups
	name = "glass cup (x3)"
	result = list(
		/obj/item/reagent_containers/glass/cup/glass/small,
		/obj/item/reagent_containers/glass/cup/glass/small,
		/obj/item/reagent_containers/glass/cup/glass/small
		)
	reqs = list(/obj/item/natural/glass = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/ceramics/glass/carafe
	name = "glass carafe"
	result = list(/obj/item/reagent_containers/glass/carafe/glass)
	reqs = list(/obj/item/natural/glass = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/ceramics/portable_hookah
	name = "portable hookah"
	result = list(/obj/item/portable_hookah)
	reqs = list(
	/obj/item/natural/hide/cured = 1,
	/obj/item/natural/clay = 2,
	/obj/item/candle = 1
	)
	subtype_reqs = TRUE
	craftdiff = 4
