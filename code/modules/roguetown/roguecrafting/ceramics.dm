/datum/crafting_recipe/roguetown/ceramics
	abstract_type = /datum/crafting_recipe/roguetown/ceramics
	skillcraft = /datum/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/clay
	structurecraft = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/glass
	tools = list(/obj/item/rogueweapon/blowrod) // To shape it
	structurecraft = /obj/machinery/light/rogue/smelter // To heat it

/* 0 diff */
/datum/crafting_recipe/roguetown/ceramics/clay/claycup
	name = "clay cup"
	result = list(/obj/item/natural/clay/claycup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/claycup3
	name = "clay cup 3x"
	result = list(/obj/item/natural/clay/claycup, /obj/item/natural/clay/claycup, /obj/item/natural/clay/claycup)
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
	name = "clay bottle"
	result = list(/obj/item/natural/clay/claybottle)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 1

/* 2 diff */
/datum/crafting_recipe/roguetown/ceramics/clay/clayvase
	name = "clay vase"
	result = list(/obj/item/natural/clay/clayvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 2

/* 3 diff */
/datum/crafting_recipe/roguetown/ceramics/clay/clayfancyvase
	name = "fancy clay vase"
	result = list(/obj/item/natural/clay/clayfancyvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/ceramics/clay/teapot
	name = "teapot"
	result = list(/obj/item/natural/clay/rawteapot)
	reqs = list(/obj/item/natural/clay = 2)
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
		Flux is paramount to reduce the melting point of silica to something achievable in a kiln.
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
	name = "glass clay"			// This is not a clay, but I don't personally think 'batch' is fitting ICly.
	tools = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle)
	result = list(/obj/item/natural/clay/glassbatch)
	reqs = list(/obj/item/natural/clay = 2, /obj/item/ash = 2, /obj/item/natural/stone = 1)
	craftdiff = 4 // Knowing how to mix glass is not a trivial knowledge.

/datum/crafting_recipe/roguetown/ceramics/clay/claystatue
	name = "clay statue"
	result = list(/obj/item/natural/clay/claystatue)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 4

/* 5 diff */ // High-end glass containers. Should be a direct upgrade to clay in every possible way.

/datum/crafting_recipe/roguetown/ceramics/glass/statue 
	name = "glass statue"
	result = list(/obj/item/roguestatue/glass)
	reqs = list(/obj/item/natural/glass = 2)
	craftdiff = 5

