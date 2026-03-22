#define STEW_COOKING_TIME 60 SECONDS // Default time to cook in seconds

/datum/stew_recipe
	var/list/obj/inputs = null // The valid inputs for the recipe
	var/datum/reagent/output = null // The reagent to be used as output for the recipe
	var/cooktime = STEW_COOKING_TIME // The time to cook the recipe

// DO NOT SORT the list unless you know what you're doing (refactor it) - I ordered specific recipe before generic one for a reason!!

/datum/stew_recipe/porridge
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/wheat, /obj/item/reagent_containers/powder/flour, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs, /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw, /obj/item/reagent_containers/food/snacks/rogue/breadslice, /obj/item/reagent_containers/food/snacks/rogue/bun, /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast)
	output = /datum/reagent/consumable/soup/porridge
	cooktime = STEW_COOKING_TIME / 2

/datum/stew_recipe/thickporridge
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/bread, /obj/item/reagent_containers/food/snacks/rogue/bookbread, /obj/item/reagent_containers/food/snacks/rogue/bookbread_slice)
	output = /datum/reagent/consumable/soup/porridge/thick
	cooktime = STEW_COOKING_TIME

/datum/stew_recipe/allspice
	inputs = list(/obj/item/reagent_containers/food/snacks/allspice)
	output = /datum/reagent/allspice
	cooktime = STEW_COOKING_TIME * 3 //Simmers the longest, so that you have enough time to plop everything else in. Cooking-wise? Well, it's common sense to let spices stew for a long while to draw the flavor out!

/datum/stew_recipe/breadpudding
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/rbread_half, /obj/item/reagent_containers/food/snacks/rogue/abread_half, /obj/item/reagent_containers/food/snacks/rogue/applebreadslice, /obj/item/reagent_containers/food/snacks/rogue/raisinbreadslice, /obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinloaf_raw, /obj/item/reagent_containers/food/snacks/rogue/pumpkinloafslice, /obj/item/reagent_containers/food/snacks/rogue/pumpkinball, /obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinball_raw)
	output = /datum/reagent/consumable/soup/porridge/pudding
	cooktime = STEW_COOKING_TIME

/datum/stew_recipe/thickbreadpudding
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/rbreaduncooked, /obj/item/reagent_containers/food/snacks/rogue/raisinbread, /obj/item/reagent_containers/food/snacks/rogue/abreaduncooked, /obj/item/reagent_containers/food/snacks/rogue/applebread, /obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf)
	output = /datum/reagent/consumable/soup/porridge/thickpudding
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/frostedpudding
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/pearbread_uncooked, /obj/item/reagent_containers/food/snacks/rogue/plumbread_uncooked, /obj/item/reagent_containers/food/snacks/rogue/lemonbread_uncooked, /obj/item/reagent_containers/food/snacks/rogue/tangerinebread_uncooked, /obj/item/reagent_containers/food/snacks/rogue/blackberrybread_uncooked, /obj/item/reagent_containers/food/snacks/rogue/raspberrybread_uncooked, /obj/item/reagent_containers/food/snacks/rogue/jackberrybread_uncooked, /obj/item/reagent_containers/food/snacks/rogue/pearbookbread_slice, /obj/item/reagent_containers/food/snacks/rogue/plumbookbread_slice, /obj/item/reagent_containers/food/snacks/rogue/lemonbookbread_slice, /obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread_slice, /obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread_slice, /obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread_slice, /obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread_slice)
	output = /datum/reagent/consumable/soup/porridge/frostedpudding
	cooktime = STEW_COOKING_TIME

/datum/stew_recipe/thickfrostedpudding
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/pearbookbread, /obj/item/reagent_containers/food/snacks/rogue/plumbookbread, /obj/item/reagent_containers/food/snacks/rogue/lemonbookbread, /obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread, /obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread, /obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread, /obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread)
	output = /datum/reagent/consumable/soup/porridge/thickfrostedpudding
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/chocolatepudding
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread_slice, /obj/item/reagent_containers/food/snacks/rogue/chocolatebread_uncooked, /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookie_raw, /obj/item/reagent_containers/food/snacks/rogue/foodbase/cookie_raw, /obj/item/reagent_containers/food/snacks/rogue/cookieslice)
	output = /datum/reagent/consumable/soup/porridge/fudgepudding
	cooktime = STEW_COOKING_TIME

/datum/stew_recipe/thickchocolatepudding
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/cookie, /obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread)
	output = /datum/reagent/consumable/soup/porridge/thickfudgepudding
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/oatmeal
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/oat)
	output = /datum/reagent/consumable/soup/porridge/oatmeal
	cooktime = STEW_COOKING_TIME / 2

/datum/stew_recipe/hardtackstew
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/crackerscooked)
	output = /datum/reagent/consumable/soup/stew/hardtack
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/thickbalefirestew
	inputs = list(/obj/item/reagent_containers/food/snacks/balefire)
	output = /datum/reagent/consumable/soup/stew/thickhardtacksalo
	cooktime = STEW_COOKING_TIME * 3

/datum/stew_recipe/balefirestew
	inputs = list(/obj/item/reagent_containers/food/snacks/balefire/slice)
	output = /datum/reagent/consumable/soup/stew/hardtacksalo
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/congee
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/rice)
	output = /datum/reagent/consumable/soup/porridge/congee
	cooktime = STEW_COOKING_TIME / 2 

/datum/stew_recipe/frycongee
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked)
	output = /datum/reagent/consumable/soup/porridge/frycongee
	cooktime = STEW_COOKING_TIME / 2 

/datum/stew_recipe/purebutter
	inputs = list(/obj/item/reagent_containers/food/snacks/squiresdelight)
	output = /datum/reagent/consumable/soup/purebutter
	cooktime = STEW_COOKING_TIME / 3 

/datum/stew_recipe/potato
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced)
	output = /datum/reagent/consumable/soup/veggie/potato

/datum/stew_recipe/thickpotato
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/potato/rogue)
	output = /datum/reagent/consumable/soup/veggie/thickpotato
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/thickfrypotato
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked, /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried)
	output = /datum/reagent/consumable/soup/veggie/thickfrypotato
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/onion
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced)
	output = /datum/reagent/consumable/soup/veggie/onion

/datum/stew_recipe/thickonion
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/onion/rogue)
	output = /datum/reagent/consumable/soup/veggie/thickonion
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/thickfryonion
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried)
	output = /datum/reagent/consumable/soup/veggie/thickfryonion
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/cabbage
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced)
	output = /datum/reagent/consumable/soup/veggie/cabbage

/datum/stew_recipe/thickcabbage
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue)
	output = /datum/reagent/consumable/soup/veggie/thickcabbage
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/thickfrycabbage
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried)
	output = /datum/reagent/consumable/soup/veggie/thickcabbage
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/thickturnip
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/vegetable/turnip)
	output = /datum/reagent/consumable/soup/veggie/thickturnip
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/turnip
	inputs = list(/obj/item/reagent_containers/food/snacks/veg/turnip_sliced)
	output = /datum/reagent/consumable/soup/veggie/turnip

/datum/stew_recipe/veggiefryfish
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/garlickbass, /obj/item/reagent_containers/food/snacks/rogue/onionplaice)
	output = /datum/reagent/consumable/soup/stew/veggiefryfish

/datum/stew_recipe/evilfryfish
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/fryfish/zizo_abberation)
	output = /datum/reagent/consumable/soup/stew/evilfryfish

/datum/stew_recipe/pepperfryfish
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/pepperfish)
	output = /datum/reagent/consumable/soup/stew/pepperfryfish

/datum/stew_recipe/lavishfryfish
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/buttersole, /obj/item/reagent_containers/food/snacks/rogue/jelliedeel, /obj/item/reagent_containers/food/snacks/rogue/berrysalmon, /obj/item/reagent_containers/food/snacks/rogue/dendorsalmon, /obj/item/reagent_containers/food/snacks/rogue/alecod)
	output = /datum/reagent/consumable/soup/stew/lavishfryfish

/datum/stew_recipe/fryfish
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/fryfish, /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried)
	output = /datum/reagent/consumable/soup/stew/fryfish

/datum/stew_recipe/fish
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish, /obj/item/reagent_containers/food/snacks/rogue/meat/fish)
	output = /datum/reagent/consumable/soup/stew/fish

/datum/stew_recipe/veggiefryrabbit
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick/cucumber, /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick)
	output = /datum/reagent/consumable/soup/stew/veggiefryrabbit

/datum/stew_recipe/fryrabbit
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried)
	output = /datum/reagent/consumable/soup/stew/fryrabbit

/datum/stew_recipe/rabbit
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit)
	output = /datum/reagent/consumable/soup/stew/rabbit

/datum/stew_recipe/kingvolf
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick/cucumber)
	output = /datum/reagent/consumable/soup/stew/kingvolf

/datum/stew_recipe/veggiefryvolf
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick)
	output = /datum/reagent/consumable/soup/stew/veggiefryvolf

/datum/stew_recipe/fryvolf
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried)
	output = /datum/reagent/consumable/soup/stew/fryvolf

/datum/stew_recipe/volf
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf)
	output = /datum/reagent/consumable/soup/stew/volf

/datum/stew_recipe/fryspider
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried)
	output = /datum/reagent/consumable/soup/stew/fryyucky

/datum/stew_recipe/spider
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider)
	output = /datum/reagent/consumable/soup/stew/yucky

/datum/stew_recipe/slop
	inputs = list(/obj/item/reagent_containers/food/snacks/badrecipe)
	output = /datum/reagent/consumable/soup/stew/slop

/datum/stew_recipe/veggiefrybird
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/frybirdtato)
	output = /datum/reagent/consumable/soup/stew/veggiethickchicken
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/lavishfrybird
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal, /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked, /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter)
	output = /datum/reagent/consumable/soup/stew/lavishchicken
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/pepperfrybird
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced)
	output = /datum/reagent/consumable/soup/stew/pepperchicken
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/thickfrybird
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked, /obj/item/reagent_containers/food/snacks/rogue/meat/chickentender)
	output = /datum/reagent/consumable/soup/stew/bakedthickchicken
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/frybird
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried)
	output = /datum/reagent/consumable/soup/stew/bakedchicken

/datum/stew_recipe/chicken
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry)
	output = /datum/reagent/consumable/soup/stew/chicken
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/frymeat
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried)
	output = /datum/reagent/consumable/soup/stew/frymeat

/datum/stew_recipe/veggiefrymeat
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/onionsteak, /obj/item/reagent_containers/food/snacks/rogue/carrotsteak, /obj/item/reagent_containers/food/snacks/rogue/wienercabbage, /obj/item/reagent_containers/food/snacks/rogue/wienerpotato, /obj/item/reagent_containers/food/snacks/rogue/wieneronions, /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions)
	output = /datum/reagent/consumable/soup/stew/veggiefrymeat

/datum/stew_recipe/pepperfrymeat
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/peppersteak)
	output = /datum/reagent/consumable/soup/stew/pepperfrymeat

/datum/stew_recipe/thickpork
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/fatty)
	output = /datum/reagent/consumable/soup/stew/thickpork
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/frypork
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried, /obj/item/reagent_containers/food/snacks/fat/salo)
	output = /datum/reagent/consumable/soup/stew/frypork

/datum/stew_recipe/pork
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/bacon, /obj/item/reagent_containers/food/snacks/fat/salo/slice)
	output = /datum/reagent/consumable/soup/stew/pork

/datum/stew_recipe/thickfrypork
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast, /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel, /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel, /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/wiener)
	output = /datum/reagent/consumable/soup/stew/thickfrypork
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/frybisque
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried, /obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried, /obj/item/reagent_containers/food/snacks/rogue/fryfish/crab, /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster, /obj/item/reagent_containers/food/snacks/rogue/crabcake)
	output = /datum/reagent/consumable/soup/stew/frybisque

/datum/stew_recipe/lavishfrybisque
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal, /obj/item/reagent_containers/food/snacks/rogue/pepperlobsta, /obj/item/reagent_containers/food/snacks/rogue/crabcake)
	output = /datum/reagent/consumable/soup/stew/lavishfrybisque

/datum/stew_recipe/seafoodbroil
	inputs = list(/obj/item/reagent_containers/food/snacks/fish/oyster, /obj/item/reagent_containers/food/snacks/fish/clam, /obj/item/reagent_containers/food/snacks/fish/shrimp)
	output = /datum/reagent/consumable/soup/stew/seafoodbroil

/datum/stew_recipe/fryseafoodbroil
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp, /obj/item/reagent_containers/food/snacks/rogue/fryfish/clam)
	output = /datum/reagent/consumable/soup/stew/fryseafoodbroil

/datum/stew_recipe/lavishfryseafoodbroil
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/milkclam)
	output = /datum/reagent/consumable/soup/stew/lavishfryseafoodbroil

/datum/stew_recipe/bisque
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab, /obj/item/reagent_containers/food/snacks/fish/lobster, /obj/item/reagent_containers/food/snacks/fish/crab, /obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw)
	output = /datum/reagent/consumable/soup/stew/bisque

/datum/stew_recipe/meatrice
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/ricebird, /obj/item/reagent_containers/food/snacks/rogue/ricebeef, /obj/item/reagent_containers/food/snacks/rogue/ricepork)
	output = /datum/reagent/consumable/soup/stew/meatrice
	cooktime = STEW_COOKING_TIME / 2

/datum/stew_recipe/eggrice
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/riceegg)
	output = /datum/reagent/consumable/soup/stew/eggrice
	cooktime = STEW_COOKING_TIME / 2

/datum/stew_recipe/shrimprice
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/riceshrimp)
	output = /datum/reagent/consumable/soup/stew/shrimprice
	cooktime = STEW_COOKING_TIME / 2

/datum/stew_recipe/cheeserice
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/ricecheese)
	output = /datum/reagent/consumable/soup/stew/cheeserice
	cooktime = STEW_COOKING_TIME / 2

/datum/stew_recipe/lavishfryrice
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/riceeggcheese, /obj/item/reagent_containers/food/snacks/rogue/ricebirdcar, /obj/item/reagent_containers/food/snacks/rogue/ricebeefcar, /obj/item/reagent_containers/food/snacks/rogue/riceporkcuc, /obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar)
	output = /datum/reagent/consumable/soup/stew/lavishfryrice
	cooktime = STEW_COOKING_TIME

/datum/stew_recipe/bone
	inputs = list(/obj/item/natural/bone, /obj/item/alch/bone)
	output = /datum/reagent/consumable/soup/bone_broth
	cooktime = STEW_COOKING_TIME * 2 //A little longer to break down all of the deliciousness.

/datum/stew_recipe/viscera
	inputs = list(/obj/item/organ/appendix, /obj/item/organ/lungs, /obj/item/organ/liver, /obj/item/organ/stomach, /obj/item/organ/ears, /obj/item/organ/eyes, /obj/item/alch/viscera, /obj/item/alch/sinew)
	output = /datum/reagent/consumable/soup/stew/viscera_broth
	cooktime = STEW_COOKING_TIME * 2 //Ditto. No hearts or brains, in order to avoid potentially permakilling someone. Could find a way to handle this, otherwise.

/datum/stew_recipe/brothbrique
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/slice)
	output = /datum/reagent/consumable/soup/stew/survival_broth

/datum/stew_recipe/thickbrothbrique
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique)
	output = /datum/reagent/consumable/soup/stew/thicksurvival_broth

/datum/stew_recipe/saltmeat
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/salami, /obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice, /obj/item/reagent_containers/food/snacks/rogue/meat/coppiette, /obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet)
	output = /datum/reagent/consumable/soup/stew/saltmeat_stew

// Don't alphabetically sort this list this is meant to be reached last. (You are free to change when you find a better way to do a fallback recipe)
/datum/stew_recipe/meat
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/meat)
	output = /datum/reagent/consumable/soup/stew/meat

// Yet another order issue - specific berries must go before generic. Sigh.
/datum/stew_recipe/berry_poisoned
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison)
	output = /datum/reagent/consumable/soup/stew/berry_poisoned

/datum/stew_recipe/berry
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue, /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry, /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry)
	output = /datum/reagent/consumable/soup/stew/berry

/datum/stew_recipe/lemon
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon, /obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette)
	output = /datum/reagent/consumable/soup/lemon

/datum/stew_recipe/lime
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lime)
	output = /datum/reagent/consumable/soup/lime

/datum/stew_recipe/pear
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear)
	output = /datum/reagent/consumable/soup/pear

/datum/stew_recipe/apple
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/apple, /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced)
	output = /datum/reagent/consumable/soup/apple

/datum/stew_recipe/parmesan
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged, /obj/item/reagent_containers/food/snacks/rogue/cheddarslice/aged)
	output = /datum/reagent/consumable/soup/stew/parmesan

/datum/stew_recipe/thickparmesan
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/cheddar/aged)
	output = /datum/reagent/consumable/soup/stew/thickparmesan
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/cheese
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge, /obj/item/reagent_containers/food/snacks/rogue/cheddarslice)
	output = /datum/reagent/consumable/soup/stew/cheese

/datum/stew_recipe/thickcheese
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/cheese)
	output = /datum/reagent/consumable/soup/stew/thickcheese
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/lavishfryegg
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian, /obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold)
	output = /datum/reagent/consumable/soup/stew/lavishfryegg

/datum/stew_recipe/thickfryegg
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage, /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon, /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon)
	output = /datum/reagent/consumable/soup/stew/thickfryegg
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/fryegg
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried, /obj/item/reagent_containers/food/snacks/rogue/friedegg/two, /obj/item/reagent_containers/food/snacks/rogue/stuffedegg/cooked)
	output = /datum/reagent/consumable/soup/stew/fryegg

/datum/stew_recipe/egg
	inputs = list(/obj/item/reagent_containers/food/snacks/egg, /obj/item/reagent_containers/food/snacks/rogue/stuffedegg)
	output = /datum/reagent/consumable/soup/stew/egg

/datum/stew_recipe/garlick_soup
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/garlick/rogue, /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove)
	output = /datum/reagent/consumable/soup/stew/garlick_soup

/datum/stew_recipe/cucumber_soup
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced)
	output = /datum/reagent/consumable/soup/stew/cucumber_soup

/datum/stew_recipe/thickcucumber_soup
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/cucumber)
	output = /datum/reagent/consumable/soup/stew/thickcucumber_soup
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/eggplant_soup
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/eggplant, /obj/item/reagent_containers/food/snacks/rogue/eggplantcarved)
	output = /datum/reagent/consumable/soup/stew/eggplant_soup

/datum/stew_recipe/aubergine_soup
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/eggplantmeat, /obj/item/reagent_containers/food/snacks/rogue/eggplantstuffedraw, /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed)
	output = /datum/reagent/consumable/soup/stew/aubergine_soup
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/lavishaubergine_soup
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffedcheese)
	output = /datum/reagent/consumable/soup/stew/lavishaubergine_soup
	cooktime = STEW_COOKING_TIME * 2

/datum/stew_recipe/carrot_stew
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/carrot)
	output = /datum/reagent/consumable/soup/stew/carrot_stew

/datum/stew_recipe/roastcarrot_stew
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked)
	output = /datum/reagent/consumable/soup/stew/thickcarrot_stew

/datum/stew_recipe/nutty_stew
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/nut)
	output = /datum/reagent/consumable/soup/stew/nutty_stew

/datum/stew_recipe/tomato_soup
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tomato, /obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sliced)
	output = /datum/reagent/consumable/soup/stew/tomato_soup

/datum/stew_recipe/plum_soup
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum)
	output = /datum/reagent/consumable/soup/stew/plum_soup

/datum/stew_recipe/tangerine_marmalade
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine)
	output = /datum/reagent/consumable/soup/tangerine_marmalade

/datum/stew_recipe/squash_soup
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced, /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed)
	output = /datum/reagent/consumable/soup/stew/squash_soup

/datum/stew_recipe/frysquash_soup
	inputs = list(/obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed)
	output = /datum/reagent/consumable/soup/stew/frysquash_soup

// DRINKS
/datum/stew_recipe/rose_tea
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried)
	output = /datum/reagent/water/rosewater
	cooktime = STEW_COOKING_TIME / 4 // Ultra fast

/datum/stew_recipe/rose_tea_spiced
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_spiced)
	output = /datum/reagent/water/rosewater_spiced
	cooktime = STEW_COOKING_TIME / 3

/datum/stew_recipe/coffee
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted)
	output = /datum/reagent/consumable/caffeine/coffee
	cooktime = STEW_COOKING_TIME / 4

/datum/stew_recipe/coffee_spiced
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/coffeebeans_spiced)
	output = /datum/reagent/consumable/caffeine/coffee_spiced
	cooktime = STEW_COOKING_TIME / 3

/datum/stew_recipe/tea
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground)
	output = /datum/reagent/consumable/caffeine/tea
	cooktime = STEW_COOKING_TIME / 4

/datum/stew_recipe/tea_spiced
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_spiced)
	output = /datum/reagent/consumable/caffeine/tea_spiced
	cooktime = STEW_COOKING_TIME / 3

/datum/stew_recipe/chocolate_spiced
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced)
	output = /datum/reagent/consumable/spiced_chocolate
	cooktime = STEW_COOKING_TIME //longer than the other drinks

/datum/stew_recipe/chocolate
	inputs = list(/obj/item/reagent_containers/food/snacks/chocolate/slice, /obj/item/reagent_containers/food/snacks/chocolate)
	output = /datum/reagent/consumable/chocolate
	cooktime = STEW_COOKING_TIME / 2

/datum/stew_recipe/poppy_milk
	inputs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/poppy)
	output = /datum/reagent/consumable/poppy_milk
	cooktime = STEW_COOKING_TIME //longer than the other drinks

#undef STEW_COOKING_TIME
