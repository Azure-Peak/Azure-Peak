/datum/crafting_recipe/roguetown/alchemy
	abstract_type = /datum/crafting_recipe/roguetown/alchemy
	req_table = FALSE
	verbage_simple = "mix"
	skillcraft = /datum/skill/craft/alchemy
	subtype_reqs = TRUE
	structurecraft = /obj/structure/fluff/alch

/datum/crafting_recipe/roguetown/alchemy/mortar
	name = "alchemical mortar"
	result = /obj/item/reagent_containers/glass/mortar
	reqs = list(/obj/item/natural/stone = 1)
	craftdiff = 2
	structurecraft = null
	verbage_simple = "create"

/datum/crafting_recipe/roguetown/alchemy/pestle
	name = "stone pestle"
	result = /obj/item/pestle
	reqs = list(/obj/item/natural/stone = 1)
	craftdiff = 2
	structurecraft = null
	verbage_simple = "create"

/datum/crafting_recipe/roguetown/alchemy/bbomb
	name = "bottle bomb"
	category = "Table"
	result = list(/obj/item/bomb)
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /obj/item/ash = 2, /obj/item/rogueore/coal = 1, /obj/item/natural/cloth = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/viscera
	name = "viscera"
	category = "Table"
	result = list(/obj/item/alch/viscera)
	reqs = list(/obj/item/ash = 1, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/viscera_3x
	name = "viscera (x3)"
	category = "Table"
	result = list(/obj/item/alch/viscera,
					/obj/item/alch/viscera,
					/obj/item/alch/viscera)
	reqs = list(/obj/item/ash = 2, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef = 6)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/ozium
	name = "ozium"
	category = "Table"
	result = list(/obj/item/reagent_containers/powder/ozium)
	reqs = list(/obj/item/ash = 2, /datum/reagent/berrypoison = 2, /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/ozium_3x
	name = "ozium (x3)"
	category = "Table"
	result = list(/obj/item/reagent_containers/powder/ozium,
					/obj/item/reagent_containers/powder/ozium,
					/obj/item/reagent_containers/powder/ozium)
	reqs = list(/obj/item/ash = 3, /datum/reagent/berrypoison = 3, /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/moon
	name = "moondust"
	category = "Table"
	result = list(/obj/item/reagent_containers/powder/moondust)
	reqs = list(/obj/item/ash = 2, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /datum/reagent/berrypoison = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/moon_3x
	name = "moondust (x3)"
	category = "Table"
	result = list(/obj/item/reagent_containers/powder/moondust,
					/obj/item/reagent_containers/powder/moondust,
					/obj/item/reagent_containers/powder/moondust
				)
	reqs = list(/obj/item/ash = 3, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 2, /datum/reagent/berrypoison = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/salt
	name = "salt pile (fat)"
	category = "Table"
	result = list(/obj/item/reagent_containers/powder/salt)
	reqs = list(/obj/item/ash = 1, /datum/reagent/water = 10, /obj/item/reagent_containers/food/snacks/fat = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/alchemy/salt_2
	name = "salt pile (mince)"
	category = "Table"
	result = list(/obj/item/reagent_containers/powder/salt)
	reqs = list(/obj/item/ash = 1, /datum/reagent/water = 10, /obj/item/reagent_containers/food/snacks/rogue/meat/mince = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/alchemy/quicksilver
	name = "quicksilver"
	category = "Table"
	result = list(/obj/item/quicksilver = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied = 1, /datum/reagent/water/blessed = 45, /obj/item/natural/cloth = 1, /obj/item/alch/silverdust = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/alchemy/qsabsolution
	name = "absolving silver"
	category = "Transmutation"
	req_table = FALSE
	result = list(/obj/item/quicksilver/luxinfused = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied = 1, /datum/reagent/water/blessed = 45, /obj/item/natural/cloth = 1, /obj/item/alch/silverdust = 1)
	craftdiff = 0
	verbage_simple = "transmute"
	structurecraft = null

/datum/crafting_recipe/roguetown/alchemy/transisdust
	name = "sui dust"
	category = "Table"
	result = list(/obj/item/alch/transisdust)
	reqs = list(/obj/item/herbseed/taraxacum = 1, /obj/item/herbseed/euphrasia = 1, /obj/item/herbseed/hypericum = 1, /obj/item/herbseed/salvia = 1)
	craftdiff = 3

//Hard to craft but feasable, will give ONE vial but that has 10 units so, enough to cure 2 people if they ration it.
/datum/crafting_recipe/roguetown/alchemy/curerot
	name = "rot cure potion"
	category = "Table"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle/alchemical = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1, /obj/item/alch/golddust = 1, /obj/item/alch/viscera = 2)
	craftdiff = 5	//Master-level

/datum/crafting_recipe/roguetown/alchemy/paralytic_venom
	name = "paralytic venom activation"
	category = "Table"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/spidervenom_paralytic = 1)
	reqs = list(/obj/item/reagent_containers/spidervenom_inert = 2, /obj/item/reagent_containers/powder/moondust = 1, /obj/item/reagent_containers/glass/bottle/alchemical = 1)
	craftdiff = 5
	verbage_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/revival_potion
	name = "Revival potion"
	category = "Table"
	result = list(/obj/item/reagent_containers/glass/bottle/revival = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/eoran_aril/auric = 1,
	 			/obj/item/alch/viscera = 2,
				/obj/item/reagent_containers/glass/bottle/alchemical,
				/obj/item/reagent_containers/spidervenom_inert = 1,
				/obj/item/alch/horn = 1)
	craftdiff = 5
	verbage_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/revival_potion_spider
	name = "Revival potion"
	category = "Table"
	result = list(/obj/item/reagent_containers/glass/bottle/revival = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/eoran_aril/auric = 1,
	 			/obj/item/alch/viscera = 2,
				/obj/item/reagent_containers/glass/bottle/alchemical,
				/obj/item/reagent_containers/spidervenom_inert = 3)
	craftdiff = 5
	verbage_simple = "mix"

/// bottle craft

/datum/crafting_recipe/roguetown/alchemy/glassbottles
	name = "alchemy bottles"
	category = "Containers"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical)
	reqs = list(/obj/item/natural/stone = 1, /obj/item/natural/dirtclod = 1)
	craftdiff = 1
	verbage_simple = "forge"

/datum/crafting_recipe/roguetown/alchemy/glassbottles2
	name = "glass bottles"
	category = "Containers"
	result = list(/obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/bottle)
	reqs = list(/obj/item/natural/stone = 1, /obj/item/natural/dirtclod = 1)
	craftdiff = 1
	verbage_simple = "forge"

/// transmutation

/datum/crafting_recipe/roguetown/alchemy/distill
	name = "distill water"
	category = "Transmutation"
	result = list(/obj/item/reagent_containers/glass/bottle/rogue/water = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /datum/reagent/water/gross = 48)
	craftdiff = 1

/datum/crafting_recipe/roguetown/alchemy/w2w
	name = "water to wine"
	category = "Transmutation"
	result = list(/obj/item/reagent_containers/glass/bottle/rogue/wine = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /datum/reagent/water = 48)
	craftdiff = 3 //WHO THE FUCK THOUGHT SETTING THIS AT 2 WAS A GOOD IDEA? MAKE IT MAKE SENSE.
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/g2wes
	name = "grain to westleach"
	category = "Transmutation"
	result = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 2)
	craftdiff = 3
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/w2swa
	name = "westleach to swampweed"
	category = "Transmutation"
	result = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 2)
	craftdiff = 3
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/f2gra
	name = "fiber to grain"
	category = "Transmutation"
	result = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)
	reqs = list(/obj/item/natural/fibers = 4)
	craftdiff = 3
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/b2app
	name = "berry to apple"
	category = "Transmutation"
	result = list(/obj/item/reagent_containers/food/snacks/grown/apple = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2)
	craftdiff = 3
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/d2cla
	name = "dirt to clay"
	category = "Transmutation"
	result = list(/obj/item/natural/clay = 1)
	reqs = list(/obj/item/natural/dirtclod = 2)
	craftdiff = 3
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/c2sto
	name = "clay to stone"
	category = "Transmutation"
	result = list(/obj/item/natural/stone = 1)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 2
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/s2coa
	name = "stone to coal"
	category = "Transmutation"
	result = list(/obj/item/rogueore/coal = 1)
	reqs = list(/obj/item/natural/stone = 4)
	craftdiff = 2
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/c2irn
	name = "coal to iron"
	category = "Transmutation"
	result = list(/obj/item/rogueore/iron = 1)
	reqs = list(/obj/item/rogueore/coal = 2)
	craftdiff = 3
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/i2gol
	name = "iron to gold"
	category = "Transmutation"
	result = list(/obj/item/rogueore/gold = 1)
	reqs = list(/obj/item/rogueore/iron = 4)
	craftdiff = 4
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/g2top
	name = "gold to toper"
	category = "Transmutation"
	result = list(/obj/item/roguegem/yellow = 1)
	reqs = list(/obj/item/rogueore/gold = 2, /obj/item/natural/stone = 1)
	craftdiff = 4
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/t2gem
	name = "toper to gemerald"
	category = "Transmutation"
	result = list(/obj/item/roguegem/green = 1)
	reqs = list(/obj/item/roguegem/yellow = 1, /obj/item/rogueore/gold = 2)
	craftdiff = 4
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/g2saf
	name = "gemerald to saffira"
	category = "Transmutation"
	result = list(/obj/item/roguegem/violet = 1)
	reqs = list(/obj/item/roguegem/green = 1, /obj/item/rogueore/gold = 2)
	craftdiff = 4
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/s2blo
	name = "saffira to blortz"
	category = "Transmutation"
	result = list(/obj/item/roguegem/blue = 1)
	reqs = list(/obj/item/roguegem/violet = 1, /obj/item/rogueore/gold = 2)
	craftdiff = 4
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/r2dia
	name = "blortz to diamond"
	category = "Transmutation"
	result = list(/obj/item/roguegem/diamond = 1)
	reqs = list(/obj/item/roguegem/blue = 2, /obj/item/rogueore/gold = 2)
	craftdiff = 5
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/d2ros
	name = "diamond to riddle of steel" /// holy grail requires legendary. (sell price on average is 350. rontz and diamond worth 100 each. you get to legndary you deserve 150-200 profit)
	category = "Transmutation"
	result = list(/obj/item/riddleofsteel = 1)
	reqs = list(/obj/item/roguegem/diamond = 2, /obj/item/rogueore/iron = 1, /obj/item/rogueore/coal = 1)
	craftdiff = 6
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/cd2coa
	name = "coal dust to coal"
	category = "Transmutation"
	result = list(/obj/item/rogueore/coal = 1)
	reqs = list(/obj/item/alch/coaldust = 3)
	craftdiff = 2
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/id2irn
	name = "iron dust to iron"
	category = "Transmutation"
	result = list(/obj/item/rogueore/iron = 1)
	reqs = list(/obj/item/alch/irondust = 3)
	craftdiff = 3
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/gd2gol
	name = "gold dust to gold"
	category = "Transmutation"
	result = list(/obj/item/rogueore/gold = 1)
	reqs = list(/obj/item/alch/golddust = 3)
	craftdiff = 4
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/frankenbrew
	name = "reanimation elixir"
	category = "Table"
	result = list(
		/obj/item/reagent_containers/glass/bottle/frankenbrew,
		/obj/item/reagent_containers/glass/bottle/frankenbrew
	)
	reqs = list(
		/obj/item/reagent_containers/glass/bottle = 2,
		/obj/item/reagent_containers/food/snacks/grown/manabloom = 1,
		/obj/item/reagent_containers/lux = 1,
		/obj/item/alch/calendula = 1,
		/datum/reagent/water = 98
	)
	craftdiff = 4
	verbage_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/frankenbrew_small
	name = "reanimation elixir (impure lux)"
	category = "Table"
	result = list(
		/obj/item/reagent_containers/glass/bottle/frankenbrew/third
	)
	reqs = list(
		/obj/item/reagent_containers/glass/bottle = 1,
		/obj/item/reagent_containers/food/snacks/grown/manabloom = 1,
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/alch/calendula = 1,
		/datum/reagent/water = 49
	)
	craftdiff = 4
	verbage_simple = "mix"
	required_tech_node = "LUX_FILTRATION"
	tech_unlocked = FALSE
