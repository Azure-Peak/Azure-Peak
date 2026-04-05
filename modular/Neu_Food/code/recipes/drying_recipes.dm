/*	........   Drying Rack recipes   ................ */
/datum/crafting_recipe/roguetown/cooking/salami
	name = "salumoi"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/salami
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 2

/datum/crafting_recipe/roguetown/cooking/coppiette
	name = "coppiette"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/coppiette
	craftdiff = 1
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/salo
	name = "salo"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/fat/salo
	craftdiff = 1
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/brothbrique
	name = "brothbrique"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/brothbriquealt
	name = "brothbrique, alternate"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/salotack
	name = "salotack"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/fat/salo = 1,
		/obj/item/reagent_containers/food/snacks/pepper = 1,
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked = 1)
	result = /obj/item/reagent_containers/food/snacks/balefire
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/raisins
	name = "raisins"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	parts = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/cooking/raisinsraspberry
	name = "raisins, raspberries"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinsblackberry
	name = "raisins, blackberries"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinsstrawberry
	name = "raisins, strawberry"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinsplum
	name = "raisins, plum"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/plum
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinspear
	name = "raisins, pear"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/pear
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinstangerine
	name = "raisins, tangerine"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinslemon
	name = "raisins, lemon"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/lemon
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinslime
	name = "raisins, lime"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lime = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/lime
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/trailmix
	name = "trail-mix"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced = 1,
		/obj/item/reagent_containers/food/snacks/roastseeds = 1,
		/obj/item/ration = 1
		)
	result = /obj/item/reagent_containers/food/snacks/rogue/trailmix
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 2

/datum/crafting_recipe/roguetown/cooking/fish
	name = "dried fish filet"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/frybirdbucket
	name = "frybird bucket"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried = 3,
		/obj/item/reagent_containers/glass/bucket = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/frybirdbucket
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/dryleaf
	name = "dry swampweed"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/drytea
	name = "dry tea leaves"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/tea = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/dryweed
	name = "dry westleach leaf"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/dryrosa
	name = "dry rosa petals"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/sigsweet/cheroot
	name = "cheroot - swampweed"
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		)
	time = 10 SECONDS
	verbage_simple = "roll"
	verbage = "rolls"

/datum/crafting_recipe/roguetown/cooking/sigdry/cheroot
	name = "cheroot - westleach"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1,
		)
	time = 10 SECONDS
	verbage_simple = "roll"
	verbage = "rolls"

/datum/crafting_recipe/roguetown/cooking/sigsweet
	name = "zig - swampweed"
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1,
		/obj/item/paper = 1,
		)
	time = 10 SECONDS
	verbage_simple = "roll"
	verbage = "rolls"

/datum/crafting_recipe/roguetown/cooking/sigdry
	name = "zig - westleach"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/paper = 1,
		)
	time = 10 SECONDS
	verbage_simple = "roll"
	verbage = "rolls"

/datum/crafting_recipe/roguetown/cooking/rocknutdry
	name = "zig - rocknut"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(
		/obj/item/reagent_containers/powder/rocknut = 1,
		/obj/item/paper = 1,
		)
	time = 10 SECONDS
	verbage_simple = "roll"
	verbage = "rolls"

/datum/crafting_recipe/roguetown/cooking/lemonystickets
	name = "lemony stickets"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1,
		/obj/item/ash = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/allspice
	name = "blend spices into allspice"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/pepper = 1,
		/obj/item/reagent_containers/powder/salt = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1,
		/obj/item/reagent_containers/powder/rocknut = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/allspice
	verbage_simple = "blend"
	verbage = "blends"
	req_table = TRUE
	structurecraft = /obj/structure/table
	craftdiff = 4 //A true chef never reveals his secrets!

/datum/crafting_recipe/roguetown/cooking/sugartangerine
	name = "smothered tangerines"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine_sugared
	structurecraft = /obj/structure/table
	req_table = TRUE
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/sugarblackberry
	name = "smothered blackberries"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry_sugared
	craftdiff = 3
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/sugarrocknut
	name = "smothered rocknuts"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/nut = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1,
		/obj/item/alch/calendula = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/nut_sugared
	craftdiff = 4 //A treat!
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/sugarrocknutalt
	name = "smothered rocknuts, alternate"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/nut = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1,
		/obj/item/alch/calendula = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/nut_sugared
	craftdiff = 5 //Slightly harder to make than a regular Cook, but allows well-trained physicians to give out the medieval equivalent of lollipops to well-behaved patients.
	skillcraft = /datum/skill/misc/medicine
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/spicechocolate
	name = "chocolate with pumpkin spice"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/chocolate/slice = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced
	structurecraft = /obj/structure/table
	req_table = TRUE
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/spicecoffee
	name = "roasted coffee beans with pumpkin spice"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/coffeebeans_spiced
	craftdiff = 3
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/spicetea
	name = "ground tea leaves with pumpkin spice"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_spiced
	craftdiff = 2
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/spicerosa
	name = "dried rosa petals with pumpkin spice"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_spiced
	craftdiff = 2
	structurecraft = /obj/structure/table
	req_table = TRUE

//SUGARCRAFTING!!!
/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkd
	name = "sugarshape, ducal mark"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/dmark
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkp
	name = "sugarshape, psydonic mark"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/pmark
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkz
	name = "sugarshape, zizonic mark"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/zmark
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarka
	name = "sugarshape, holy mark"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/amark
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarks
	name = "sugarshape, skull mark"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/smark
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkh
	name = "sugarshape, heart mark"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/hmark
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuek
	name = "sugarshape, knightly statue"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuek
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuer
	name = "sugarshape, ducal statue"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuer
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuey
	name = "sugarshape, yeomannic statue"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuey
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuel
	name = "sugarshape, lordly statue"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuel
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedarch
	name = "sugarshape, bridge"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/arch
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedarchway
	name = "sugarshape, archway"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/archway
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedtower
	name = "sugarshape, tower"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/tower
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedtowers
	name = "sugarshape, small tower"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/towers
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedcastle
	name = "sugarshape, castle"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/castle
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedflag
	name = "sugarshape, flag"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/flag
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedhouse
	name = "sugarshape, house"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/house
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedtree
	name = "sugarshape, tree"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/tree
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table
