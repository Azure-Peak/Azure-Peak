/datum/crafting_recipe/roguetown/weaving
	structurecraft = /obj/machinery/loom
	skillcraft = /datum/skill/craft/sewing
	subtype_reqs = TRUE		//For subtypes of fur

/datum/crafting_recipe/roguetown/weaving/rags
	name = "webbed shirt"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/webs)
	reqs = list(/obj/item/natural/silk = 1)
	craftdiff = 1
	sellprice = 6

/datum/crafting_recipe/roguetown/weaving/webbing
	name = "webbed leggings"
	result = list(/obj/item/clothing/under/roguetown/webs)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 1
	sellprice = 9

/datum/crafting_recipe/roguetown/weaving/cloak
	name = "silk half cloak"
	result = list(/obj/item/clothing/cloak/half)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 19

/datum/crafting_recipe/roguetown/weaving/puritan

	name = "puritan's cape"
	result = list(/obj/item/clothing/cloak/cape/puritan)
	reqs = list(/obj/item/natural/silk = 4)
	craftdiff = 3
	sellprice = 35

/datum/crafting_recipe/roguetown/weaving/shirt
	name = "formal silks"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 3
	sellprice = 35

/datum/crafting_recipe/roguetown/weaving/shepardmask
	name = "half-mask"
	result = list(/obj/item/clothing/mask/rogue/shepherd)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 1
	sellprice = 30

/datum/crafting_recipe/roguetown/weaving/astratarobe
	name = "astrata robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/astrata)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/abyssorrobe
	name = "abyssor robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/abyssor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/abyssorhood
	name = "abyssor hood"
	result = list(/obj/item/clothing/head/roguetown/roguehood/abyssor)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/astratahood
	name = "solar hood"
	result = list(/obj/item/clothing/head/roguetown/roguehood/astrata)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/nocrobe
	name = "noc robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/noc)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/nochood
	name = "moon hood"
	result = list(/obj/item/clothing/head/roguetown/roguehood/nochood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/eorahood
	name = "eoran hood"
	result = list(/obj/item/clothing/head/roguetown/roguehood/eorahood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/dendorrobe
	name = "dendor robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/dendor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/necrarobe
	name = "necra robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/necra)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/weaving/necrahood
	name = "necra hood"
	result = list(/obj/item/clothing/head/roguetown/necrahood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/barkeep
	name = "bar dress"
	result = list (/obj/item/clothing/suit/roguetown/shirt/dress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 5
	sellprice = 27

/datum/crafting_recipe/roguetown/weaving/silkdress
	name = "chemise"
	result = list (/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/random)
	reqs = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/weaving/silkcoat
	name = "silk coat"
	result = list (/obj/item/clothing/suit/roguetown/armor/silkcoat)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 3,
				/obj/item/natural/fur = 2)
	craftdiff = 5
	sellprice = 60

//Eora content from Stonekeep
/datum/crafting_recipe/roguetown/weaving/eoramask
	name = "eora mask"
	result = list(/obj/item/clothing/head/roguetown/eoramask)
	reqs = list(/obj/item/ingot/silver,
				/obj/item/natural/silk = 4)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/weaving/eorarobes
	name = "eora robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/eora)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3
	sellprice = 20
