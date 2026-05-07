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
	reqs = list(/obj/item/herbseed/taraxacum = 1, /obj/item/herbseed/hypericum = 1, /obj/item/herbseed/salvia = 1)
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
	name = "revival potion"
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
	name = "revival potion"
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

/datum/crafting_recipe/roguetown/alchemy/f2gra
	name = "fiber to grain"
	category = "Transmutation"
	result = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)
	reqs = list(/obj/item/natural/fibers = 4)
	craftdiff = 3
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/skysugarbase
	name = "panacea of skysugar"
	category = "Transmutation"
	result = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry = 1, /obj/item/reagent_containers/lux_impure = 1, /obj/item/reagent_containers/powder/starsugar = 1)
	craftdiff = 5 //Better hope you've been practicing!
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/skysugar
	name = "skysugar slab to skysugar powder (x3)"
	category = "Transmutation"
	result = list(/obj/item/reagent_containers/powder/starsugar/skysugar,
					/obj/item/reagent_containers/powder/starsugar/skysugar,
					/obj/item/reagent_containers/powder/starsugar/skysugar)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/skysugarslab = 1)
	craftdiff = 1 //Hard part's done. Time to break it up!
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

/datum/crafting_recipe/roguetown/alchemy/bandage
	name = "bandages (alchemy)"
	result = list(/obj/item/natural/cloth/bandage)
	reqs = list(
		/obj/item/natural/cloth = 1,
		/obj/item/alch/bonemeal = 1,
		)
	craftdiff = 2
	subtype_reqs = FALSE //so you dont craft bandages from bandages

/datum/crafting_recipe/roguetown/alchemy/glut
	name = "glut (from gnoll flesh)"
	craftdiff = 4
	result = list(
		/obj/item/roguegem/blood_diamond
		)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll = 2,
		)
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/alchemy/gnoll_flesh
	name = "gnoll flesh (from glut)"
	craftdiff = 4
	result = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll
		)
	reqs = list(
		/obj/item/roguegem/blood_diamond = 2,
		)
	subtype_reqs = TRUE

// Flavorful Zigarets

/datum/crafting_recipe/roguetown/alchemy/menthazig
	name = "handmade mentha zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/mentha/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/alch/mentha = 1)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/blackberryzig
	name = "handmade blackberry zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/blackberry/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/applezig
	name = "handmade apple zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/apple/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/reagent_containers/food/snacks/grown/apple = 1)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/menthaapplezig
	name = "handmade mentha-apple zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/menthaapple/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/alch/mentha = 1, /obj/item/reagent_containers/food/snacks/grown/apple = 1)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/chocolatezig
	name = "handmade chocolate zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/chocolate/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/reagent_containers/food/snacks/chocolate = 1)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/strawberryzig
	name = "handmade strawberry zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/strawberry/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry = 1)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/carrotzig
	name = "handmade carrot zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/carrot/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/reagent_containers/food/snacks/grown/carrot = 1)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/limezig
	name = "handmade lime zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/lime/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/reagent_containers/food/snacks/grown/fruit/lime = 1)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/salviazig
	name = "handmade salvia zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/salvia/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/herbseed/salvia = 1)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/salviavalerianazig
	name = "handmade salvia-valeriana zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/salviavaleriana/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/herbseed/salvia = 1, /datum/reagent/drug/valeriana = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/calendulazig
	name = "handmade calendula zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/calendula)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/alch/calendula = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/jacksberries
	name = "handmade jacksberries zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/jacksberries/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/jacksberriespoison
	name = "handmade jacksberries zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/jacksberriespoison/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison = 2)
	craftdiff = 1
	
/datum/crafting_recipe/roguetown/alchemy/abyss
	name = "handmade abyss zig"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/abyss/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1, /datum/reagent/water/salty = 20, /obj/item/reagent_containers/food/snacks/fish = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/ziggara
	name = "handmade ziggara"
	category = "Table"
	result = list(/obj/item/clothing/mask/cigarette/rollie/ziggara/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/herbseed/hypericum  = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 3)
	craftdiff = 3
