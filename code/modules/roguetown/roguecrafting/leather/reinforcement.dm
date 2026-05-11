/datum/crafting_recipe/roguetown/leather/reinforcement
	abstract_type = /datum/crafting_recipe/roguetown/leather/reinforcement
	category = "Reinforcement"

/datum/crafting_recipe/roguetown/leather/reinforcement/crafteast
	name = "decorated dobo robe"
	result = list(/obj/item/clothing/suit/roguetown/armor/basiceast/crafteast)
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 2,
		/obj/item/clothing/suit/roguetown/armor/basiceast = 1,
		)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/reinforcement/studded
	craftdiff = 4
	tools = list(/obj/item/needle, /obj/item/rogueweapon/hammer)

/datum/crafting_recipe/roguetown/leather/reinforcement/studded/hood
	name = "studded leather hood"
	result = list(/obj/item/clothing/head/roguetown/roguehood/studded)
	reqs = list(
		/obj/item/clothing/head/roguetown/roguehood = 1,
		/obj/item/scrap = 2,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)

/datum/crafting_recipe/roguetown/leather/reinforcement/studded/chestplate
	name = "studded leather chestplate"
	result = list(/obj/item/clothing/suit/roguetown/armor/leather/studded)
	reqs = list(
		/obj/item/clothing/suit/roguetown/armor/leather = 1,
		/obj/item/scrap = 3,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)

/datum/crafting_recipe/roguetown/leather/reinforcement/studded/cuirbouilli
	name = "studded leather cuirass, 'cuir-bouilli'-style"
	result = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli)
	reqs = list(
		/obj/item/clothing/suit/roguetown/armor/leather/cuirass = 1,
		/obj/item/scrap = 3,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)

/datum/crafting_recipe/roguetown/leather/reinforcement/studded/bikini
	name = "studded leather corslet"
	result = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini)
	reqs = list(
		/obj/item/clothing/suit/roguetown/armor/leather = 1,
		/obj/item/scrap = 2,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)

/datum/crafting_recipe/roguetown/leather/reinforcement/studded/forester
	name = "forester's brigandine"
	result = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded)
	reqs = list(
		/obj/item/clothing/suit/roguetown/armor/leather/studded/warden = 1,
		/obj/item/natural/cured/essence = 1,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)
