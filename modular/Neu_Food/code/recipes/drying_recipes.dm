/*	........   Drying Rack recipes   ................ */
/datum/crafting_recipe/roguetown/cooking/salami
	name = "salumoi"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/salami
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 2

/datum/crafting_recipe/roguetown/cooking/coppiette
	name = "coppiette"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/coppiette
	craftdiff = 1
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/salo
	name = "salo"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/fat/salo
	craftdiff = 1
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/brothbrique
	name = "brothbrique"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/brothbriquealt
	name = "brothbrique, alternate"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/salotack
	name = "salotack"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/fat/salo = 1,
		/obj/item/reagent_containers/food/snacks/pepper = 1,
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked = 1)
	result = /obj/item/reagent_containers/food/snacks/balefire
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/raisins
	name = "raisins"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	parts = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/cooking/raisinsraspberry
	name = "raisins, raspberries"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinsblackberry
	name = "raisins, blackberries"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinsstrawberry
	name = "raisins, strawberry"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinsplum
	name = "raisins, plum"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/plum
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinspear
	name = "raisins, pear"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/pear
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinstangerine
	name = "raisins, tangerine"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinslemon
	name = "raisins, lemon"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/lemon
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinslime
	name = "raisins, lime"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lime = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/lime
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/trailmix
	name = "trail-mix"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/frybirdbucket
	name = "frybird bucket"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried = 3,
		/obj/item/reagent_containers/glass/bucket = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/frybirdbucket
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/dryleaf
	name = "dry swampweed"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/drytea
	name = "dry tea leaves"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/tea = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/dryweed
	name = "dry westleach leaf"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/dryrosa
	name = "dry rosa petals"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/sigsweet/cheroot
	name = "cheroot - swampweed"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1,
		)
	time = 10 SECONDS
	verbage_simple = "roll"
	verbage = "rolls"

/datum/crafting_recipe/roguetown/cooking/sigdry/cheroot
	name = "cheroot - westleach"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(
		/obj/item/reagent_containers/powder/rocknut = 1,
		/obj/item/paper = 1,
		)
	time = 10 SECONDS
	verbage_simple = "roll"
	verbage = "rolls"

/datum/crafting_recipe/roguetown/cooking/menthadry
	name = "cheroot - mentha"
	result = /obj/item/clothing/mask/cigarette/rollie/mentha/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/alch/mentha = 1,
	)
	time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/blackberrydry
	name = "cheroot - blackberry"
	result = /obj/item/clothing/mask/cigarette/rollie/blackberry/cheroot
	reqs = list(
	/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1,
	)
	time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/appledry
	name = "cheroot - apple"
	result = /obj/item/clothing/mask/cigarette/rollie/apple/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/apple = 1,
	)
	time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/menthaappledry
    name = "cheroot - mentha-apple"
    result = /obj/item/clothing/mask/cigarette/rollie/menthaapple/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/alch/mentha = 1,
        /obj/item/reagent_containers/food/snacks/grown/apple = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/chocolatedry
    name = "cheroot - chocolate"
    result = /obj/item/clothing/mask/cigarette/rollie/chocolate/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/chocolate = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/strawberrydry
    name = "cheroot - strawberry"
    result = /obj/item/clothing/mask/cigarette/rollie/strawberry/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/carrotdry
    name = "cheroot - carrot"
    result = /obj/item/clothing/mask/cigarette/rollie/carrot/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/carrot = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/limedry
    name = "cheroot - lime"
    result = /obj/item/clothing/mask/cigarette/rollie/lime/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/fruit/lime = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/salviadry
    name = "cheroot - salvia"
    result = /obj/item/clothing/mask/cigarette/rollie/salvia/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/alch/salvia = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/salviavalerianadry
    name = "cheroot - salvia-valeriana"
    result = /obj/item/clothing/mask/cigarette/rollie/salviavaleriana/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/alch/salvia = 1,
        /obj/item/alch/valeriana = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/calenduladry
    name = "cheroot - calendula"
    result = /obj/item/clothing/mask/cigarette/rollie/calendula/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/alch/calendula = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/jacksberriesdry
    name = "cheroot - jacksberries"
    result = /obj/item/clothing/mask/cigarette/rollie/jacksberries/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/jacksberriespoisondry
    name = "cheroot - jacksberries poison"
    result = /obj/item/clothing/mask/cigarette/rollie/jacksberriespoison/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/abyssdry
    name = "cheroot - abyss"
    result = /obj/item/clothing/mask/cigarette/rollie/abyss/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1,
        /datum/reagent/water/salty = 25,
        /obj/item/reagent_containers/food/snacks/fish = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/zigardry
    name = "cheroot - zigar"
    result = /obj/item/clothing/mask/cigarette/rollie/zigar/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 2,
        /obj/item/alch/hypericum  = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/lemonystickets
	name = "lemony stickets"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1,
		/obj/item/ash = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/allspice
	name = "blend spices into allspice"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine_sugared
	structurecraft = /obj/structure/table
	req_table = TRUE
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/sugarblackberry
	name = "smothered blackberries"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry_sugared
	craftdiff = 3
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/sugarrocknut
	name = "smothered rocknuts"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/chocolate/slice = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced
	structurecraft = /obj/structure/table
	req_table = TRUE
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/spicecoffee
	name = "roasted coffee beans with pumpkin spice"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/coffeebeans_spiced
	craftdiff = 3
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/spicetea
	name = "ground tea leaves with pumpkin spice"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_spiced
	craftdiff = 2
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/spicerosa
	name = "dried rosa petals with pumpkin spice"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
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
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/tree
	craftdiff = 4
	verbage_simple = "sculpt"
	verbage = "sculpts"
	req_table = TRUE
	structurecraft = /obj/structure/table
