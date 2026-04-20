/datum/crafting_recipe/roguetown/leather/armor
	abstract_type = /datum/crafting_recipe/roguetown/leather/armor
	category = "Armor"

/datum/crafting_recipe/roguetown/leather/armor/lgorget
	name = "hardened leather gorget"
	result = /obj/item/clothing/neck/roguetown/leather
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/armor/heavybracers
	name = "hardened leather bracers"
	result = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/armor/bracers
	name = "leather bracers"
	result = /obj/item/clothing/wrists/roguetown/bracers/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 10

/datum/crafting_recipe/roguetown/leather/armor/pants
	name = "leather pants"
	result = /obj/item/clothing/under/roguetown/trou/leather
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 10

/datum/crafting_recipe/roguetown/leather/armor/volfhelm
	name = "volf helm"
	result = list(/obj/item/clothing/head/roguetown/helmet/leather/volfhelm)
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur/wolf = 1, /obj/item/natural/head/volf = 1)
	sellprice = 20

/datum/crafting_recipe/roguetown/leather/armor/volfmantle
	name = "volf mantle"
	result = /obj/item/clothing/cloak/volfmantle
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/head/volf = 1,
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/saigahelm
	name = "saiga skull helm"
	result = list(/obj/item/clothing/head/roguetown/helmet/leather/saiga)
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/hide = 2, /obj/item/natural/head/saiga = 1)
	sellprice = 20

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_pants
	name = "hardened leather pants"
	result = list(/obj/item/clothing/under/roguetown/heavy_leather_pants)
	reqs = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 20
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_pants/shorts
	name = "hardened leather shorts"
	result = list(/obj/item/clothing/under/roguetown/heavy_leather_pants/shorts)
	reqs = list(
		/obj/item/natural/hide/cured = 1, //they cover less, you see
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 20
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/armor/helmet/advanced
	name = "hardened leather helmet"
	result = /obj/item/clothing/head/roguetown/helmet/leather/advanced
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/reagent_containers/food/snacks/tallow = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/armor
	name = "leather armor"
	result = /obj/item/clothing/suit/roguetown/armor/leather
	reqs = list(/obj/item/natural/hide/cured = 2)

/datum/crafting_recipe/roguetown/leather/armor/cuirass
	name = "leather cuirass"
	result = /obj/item/clothing/suit/roguetown/armor/leather/cuirass
	reqs = list(/obj/item/natural/hide/cured = 2)

/datum/crafting_recipe/roguetown/leather/armor/hidearmor
	name = "hide armor"
	result = /obj/item/clothing/suit/roguetown/armor/leather/hide
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fur = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor
	name = "hardened leather armor"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/armor/freivest
	name = "fencing jacket"	//Expensive on purpose.
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
	reqs = list(
		/obj/item/natural/hide/cured = 4,
		/obj/item/reagent_containers/food/snacks/tallow = 2,
		/obj/item/natural/fibers = 4
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/coat
	name = "hardened leather coat"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	reqs = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/jacket
	name = "hardened leather jacket"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket
	reqs = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/helmet
	name = "leather helmet"
	result = /obj/item/clothing/head/roguetown/helmet/leather
	reqs = list(/obj/item/natural/hide/cured = 1)

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/coat/tailcoat
	name =  "tailcoat"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/tailcoat
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 3
