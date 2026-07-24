/datum/crafting_recipe/roguetown/alchemy
	abstract_type = /datum/crafting_recipe/roguetown/alchemy
	req_table = FALSE
	verbage_simple = "mix"
	skillcraft = /datum/skill/craft/alchemy
	subtype_reqs = TRUE
	structurecraft = /obj/structure/fluff/alch

/datum/crafting_recipe/roguetown/alchemy/bbomb
	name = "bottle bomb"
	category = "Table"
	result = list(/obj/item/bomb)
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /obj/item/ash = 2, /obj/item/rogueore/coal = 1, /obj/item/natural/cloth = 1)
	craftdiff = 2

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

/datum/crafting_recipe/roguetown/alchemy/quicksilver
	name = "quicksilver"
	category = "Table"
	result = list(/obj/item/quicksilver = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied = 1, /datum/reagent/water/blessed = 45, /obj/item/natural/cloth = 1, /obj/item/alch/silverdust = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/alchemy/qsabsolution
	name = "absolving silver"
	category = "Basic Transmutation"
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
	reqs = list(/obj/item/reagent_containers/glass/bottle/alchemical = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1, /obj/item/heart_blood_vial/filled = 2, /obj/item/alch/viscera = 2)
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

/obj/item/trans_table_upgrade
	name = "Transmutation Equipment Kit"
	desc = "An expensive and difficult endeavor to forge: a complete set of equipment that can be used to upgrade a mundane alchemy station into a transmutative laboratory."
	icon = 'icons/roguetown/misc/gadgets.dmi'
	icon_state = "atinkerkit"

/obj/item/trans_table_upgrade/attack_obj(obj/O, mob/living/user)
	. = ..()
	if(istype(O, /obj/structure/fluff/alch) && !istype(O, /obj/structure/fluff/alch/trans))
		var/newloc = get_turf(O)
		user.visible_message(span_notice("[user] tinkers with [O], setting up an advanced alchemical workspace!"), span_notice("I set out my tools and upgrade [O]."))
		qdel(O)
		new /obj/structure/fluff/alch/trans(newloc)

/datum/crafting_recipe/roguetown/alchemy/transmutation_equipment
	name = "transmutation equipment"
	category = "Table"
	result = list(/obj/item/trans_table_upgrade)
	reqs = list(/obj/item/ingot/purifiedaalloy = 2)
	craftdiff = 1
	verbage_simple = "forge"

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

/datum/crafting_recipe/roguetown/alchemy/distill
	name = "distill water"
	category = "Basic Transmutation"
	result = list(/obj/item/reagent_containers/glass/bottle/rogue/water = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /datum/reagent/water/gross = 48)
	craftdiff = 1

/datum/crafting_recipe/roguetown/alchemy/w2w
	name = "water to wine"
	category = "Basic Transmutation"
	result = list(/obj/item/reagent_containers/glass/bottle/rogue/wine = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /datum/reagent/water = 50)
	craftdiff = 3 //WHO THE FUCK THOUGHT SETTING THIS AT 2 WAS A GOOD IDEA? MAKE IT MAKE SENSE.
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/skysugarbase
	name = "panacea of skysugar"
	category = "Basic Transmutation"
	result = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry = 1, /obj/item/reagent_containers/lux_impure = 1, /obj/item/reagent_containers/powder/starsugar = 1)
	craftdiff = 5 //Better hope you've been practicing!
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/skysugar
	name = "skysugar slab to skysugar powder (x3)"
	category = "Basic Transmutation"
	result = list(/obj/item/reagent_containers/powder/starsugar/skysugar,
					/obj/item/reagent_containers/powder/starsugar/skysugar,
					/obj/item/reagent_containers/powder/starsugar/skysugar)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/skysugarslab = 1)
	craftdiff = 1 //Hard part's done. Time to break it up!
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

/datum/crafting_recipe/roguetown/alchemy/begin_magnum_opus
	name = "basic catalyst precursor (raw materia)" // this is solely so it's near the top of the list so people can actually find it lmao
	category = "Magnum Opus"
	craftdiff = SKILL_LEVEL_MASTER // you need expert to make catalysts, but mages have positive int = they can craft 1 level above their tier, also this should be difficult ic
	result = list(
		/obj/item/alch/nigredo_precursor,
		/obj/item/alch/nigredo_precursor // one for a catalyst, one to take with you up the chain
	)
	reqs = list(
		/obj/item/rogueore/cinnabar = 1,
		/obj/item/ash = 3
	)

/datum/crafting_recipe/roguetown/alchemy/catalyzation_reagent_pacifist
	name = "catalyzing reagent (cinnabar)" // expensive alternative to planar materials
	category = "Basic Transmutation"
	craftdiff = SKILL_LEVEL_EXPERT
	result = list(
		/obj/item/storage/roguebag/trans
	)
	reqs = list(
		/obj/item/rogueore/cinnabar = 1,
		/obj/item/ash = 3,
		/obj/item/storage/roguebag = 1
	)

/datum/crafting_recipe/roguetown/alchemy/catalyzation_reagent
	name = "catalyzing reagent (iridescent scale)"
	category = "Basic Transmutation"
	craftdiff = SKILL_LEVEL_EXPERT
	result = list(
		/obj/item/storage/roguebag/trans
	)
	reqs = list(
		/obj/item/magic/fae/iridescentscale = 1,
		/obj/item/ash = 3,
		/obj/item/storage/roguebag = 1
	)
