/datum/crafting_recipe/roguetown/leather/footwear
	abstract_type = /datum/crafting_recipe/roguetown/leather/footwear
	category = "Footwear"
	reqs = list(/obj/item/natural/hide/cured = 1, 
				/obj/item/natural/fibers = 1) //basic footwear all have the same recipe

/datum/crafting_recipe/roguetown/leather/footwear/shoes 
	name = "shoes"
	result = /obj/item/clothing/shoes/roguetown/simpleshoes

/datum/crafting_recipe/roguetown/leather/footwear/boots
	name = "leather boots"
	result = /obj/item/clothing/shoes/roguetown/boots/leather

/datum/crafting_recipe/roguetown/leather/footwear/boots_heavy
	name = "heavy leather boots"
	result = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fur = 1)
	craftdiff = 3	//Same as the heavy leather gloves.

/datum/crafting_recipe/roguetown/leather/footwear/boots_heavy_b
	name = "dress boots"
	result = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fur = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/footwear/boots/furlinedboots
	name = "fur-lined boots"
	result = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fur = 1)

/datum/crafting_recipe/roguetown/leather/footwear/boots/short
	name = "shortboots"
	result = /obj/item/clothing/shoes/roguetown/shortboots

/datum/crafting_recipe/roguetown/leather/footwear/boots/dark
	name = "dark boots"
	result = /obj/item/clothing/shoes/roguetown/boots

/datum/crafting_recipe/roguetown/leather/footwear/boots/noble
	name = "noble boots"
	result = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	reqs = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fur = 1)
