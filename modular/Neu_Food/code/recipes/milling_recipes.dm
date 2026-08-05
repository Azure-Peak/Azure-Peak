/*	........   Milling recipes   ................ */
/datum/crafting_recipe/roguetown/cooking/wheat_flour
	name = "wheat flour"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)
	result = /obj/item/reagent_containers/powder/flour
	always_availible = TRUE
	structurecraft = /obj/item/millstone
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	craftsound = 'modular/Neu_Food/sound/milling.ogg'

/datum/crafting_recipe/roguetown/cooking/oat_flour
	name = "oat flour"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/oat = 1)
	result = /obj/item/reagent_containers/powder/flour
	always_availible = TRUE
	structurecraft = /obj/item/millstone
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	craftsound = 'modular/Neu_Food/sound/milling.ogg'

/datum/crafting_recipe/roguetown/cooking/rice_flour
	name = "rice flour"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rice = 1)
	result = /obj/item/reagent_containers/powder/flour
	always_availible = TRUE
	structurecraft = /obj/item/millstone
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	craftsound = 'modular/Neu_Food/sound/milling.ogg'

/datum/crafting_recipe/roguetown/cooking/corn_flour
	name = "cornmeal"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/maize = 1)
	result = /obj/item/reagent_containers/powder/flour/cornmeal
	always_availible = TRUE
	structurecraft = /obj/item/millstone
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	craftsound = 'modular/Neu_Food/sound/milling.ogg'
