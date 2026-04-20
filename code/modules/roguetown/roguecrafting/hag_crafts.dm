/datum/crafting_recipe/roguetown/alchemy/hag
	always_availible = FALSE

/datum/crafting_recipe/roguetown/alchemy/hag/varnish
	name = "strange varnish"
	category = "Hag"
	result = list(/obj/item/hag_catalyst/varnish_base = 1)
	reqs = list(/obj/item/alch/hag_moss/sorrow = 1, /obj/item/natural/cloth = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/synth_shiny
	name = "strange golden varnish"
	category = "Hag"
	result = list(/obj/item/hag_catalyst/synth_base/gilded = 1)
	reqs = list(/obj/item/alch/hag_moss/pride = 1, /obj/item/rogueore/iron = 3, /obj/item/rogueore/coal = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/synth_base
	name = "strange cataltyst"
	category = "Hag"
	result = list(/obj/item/hag_catalyst/synth_base = 1)
	reqs = list(/obj/item/alch/hag_moss/mercy = 1, /obj/item/rogueore/iron = 3, /obj/item/rogueore/coal = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/faded_moss
	name = "moss faded"
	result = list(/obj/item/alch/hag_moss/enchanted/random/low = 1)
	reqs = list(/obj/item/alch/hag_moss/sorrow = 1, /obj/item/rogueore/tin = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/alchemy/hag/crawling_moss
	name = "moss crawling"
	result = list(/obj/item/alch/hag_moss/enchanted/crawling = 1)
	reqs = list(/obj/item/alch/hag_moss/sorrow = 1, /obj/item/natural/silk = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/alchemy/hag/stormy_moss
	name = "moss stormy"
	result = list(/obj/item/alch/hag_moss/enchanted/deathless = 1)
	reqs = list(/obj/item/alch/hag_moss/envy = 1, /obj/item/rogueore/copper = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/alchemy/hag/corrosive_moss
	name = "moss corrosive"
	result = list(/obj/item/alch/hag_moss/enchanted/corrosive = 1)
	reqs = list(/obj/item/alch/hag_moss/fury = 1, /obj/item/rogueore/iron = 1)
	craftdiff = 5

// Mid Rarity Recipes
/datum/crafting_recipe/roguetown/alchemy/hag/lustrous_moss
	name = "moss lustrous"
	result = list(/obj/item/alch/hag_moss/enchanted/random/mid = 1)
	reqs = list(/obj/item/alch/hag_moss/grief = 1, /obj/item/natural/silk = 2)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/caring_moss
	name = "moss caring"
	result = list(/obj/item/alch/hag_moss/enchanted/caring = 1)
	reqs = list(/obj/item/alch/hag_moss/mercy = 1, /obj/item/natural/cloth = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/rooted_moss
	name = "moss rooted"
	result = list(/obj/item/alch/hag_moss/enchanted/rooted = 1)
	reqs = list(/obj/item/alch/hag_moss/mercy = 1, /obj/item/natural/fibers = 3)
	craftdiff = 6


/datum/crafting_recipe/roguetown/alchemy/hag/creeping_moss
	name = "moss creeping"
	result = list(/obj/item/alch/hag_moss/enchanted/creeping = 1)
	reqs = list(/obj/item/alch/hag_moss/envy = 1, /obj/item/natural/silk = 1, /obj/item/natural/fibers = 1)
	craftdiff = 6

// High Rarity Recipes
/datum/crafting_recipe/roguetown/alchemy/hag/prismatic_moss
	name = "moss prismatic"
	result = list(/obj/item/alch/hag_moss/enchanted/random/high = 1)
	reqs = list(/obj/item/alch/hag_moss/pride = 1, /obj/item/rogueore/iron = 2)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/gilded_moss
	name = "moss gilded"
	result = list(/obj/item/alch/hag_moss/enchanted/gilded = 1)
	reqs = list(/obj/item/alch/hag_moss/pride = 1, /obj/item/rogueore/iron = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/drowned_moss
	name = "moss drowned"
	result = list(/obj/item/alch/hag_moss/enchanted/drowned = 1)
	reqs = list(/obj/item/alch/hag_moss/lullaby = 1, /obj/item/rogueore/tin = 1, /obj/item/rogueore/copper = 1)
	craftdiff = 6

// Items

/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_axe
	name = "wyrd axe"
	result = list(/obj/item/rogueweapon/greataxe/steel/hag = 1)
	reqs = list(/obj/item/alch/hag_moss/lullaby = 1, /obj/item/grown/log/tree/small = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_sword
	name = "wyrd sword"
	result = list(/obj/item/rogueweapon/sword/long/hag = 1)
	reqs = list(/obj/item/alch/hag_moss/lullaby = 1, /obj/item/grown/log/tree/small = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_spear
	name = "wyrd polearm"
	result = list(/obj/item/rogueweapon/halberd/hag = 1)
	reqs = list(/obj/item/alch/hag_moss/lullaby = 1, /obj/item/grown/log/tree/small = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_cross
	name = "wyrd cross"
	result = list(/obj/item/clothing/neck/roguetown/psicross/hag = 1)
	reqs = list(/obj/item/alch/hag_moss/grief = 1, /obj/item/grown/log/tree/small = 1, /obj/item/natural/cloth = 1)
	craftdiff = 6
