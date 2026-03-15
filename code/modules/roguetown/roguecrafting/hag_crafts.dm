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
	reqs = list(/obj/item/alch/hag_moss/pride = 1, /obj/item/rogueore/iron = 1, /obj/item/rogueore/coal)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/synth_base
	name = "strange cataltyst"
	category = "Hag"
	result = list(/obj/item/hag_catalyst/synth_base = 1)
	reqs = list(/obj/item/alch/hag_moss/mercy = 1, /obj/item/rogueore/iron = 1, /obj/item/rogueore/coal)
	craftdiff = 6
