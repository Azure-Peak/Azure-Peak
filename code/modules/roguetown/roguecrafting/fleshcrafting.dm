/datum/crafting_recipe/roguetown/fleshcrafting
	abstract_type = /datum/crafting_recipe/roguetown/fleshcrafting
	req_table = FALSE
	verbage_simple = "assembles"
	skillcraft = /datum/skill/labor/butchering
	subtype_reqs = TRUE
	structurecraft = /obj/structure/roguemachine/chimeric_heart_beast

/datum/crafting_recipe/roguetown/fleshcrafting/decoy
	name = "flesh decoy (2x fresh meat)"
	category = "Flesh"
	result = list(/obj/item/flesh_decoy)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat = 2)
	structurecraft = null
	craftdiff = 2
	required_tech_node = "FLESH_DECOYS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/decoy_alt
	name = "flesh decoy (2x viscera)"
	category = "Flesh"
	result = list(/obj/item/flesh_decoy)
	reqs = list(/obj/item/alch/viscera = 2)
	structurecraft = null
	craftdiff = 2
	required_tech_node = "VISCERA_DECOYS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/flesh_node
	name = "flesh node (1x rotten meat)"
	category = "Flesh"
	result = list(/obj/item/flesh_node)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/fleshcrafting/lungs
	name = "Lungs"
	category = "Flesh"
	result = list(/obj/item/organ/lungs)
	reqs = list(/obj/item/flesh_node = 2,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/heart
	name = "Heart"
	category = "Flesh"
	result = list(/obj/item/organ/heart)
	reqs = list(/obj/item/flesh_node = 2,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/liver
	name = "Liver"
	category = "Flesh"
	result = list(/obj/item/organ/liver)
	reqs = list(/obj/item/flesh_node = 2,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE


/datum/crafting_recipe/roguetown/fleshcrafting/eyes
	name = "Eyes"
	category = "Flesh"
	result = list(/obj/item/organ/eyes)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/tongue
	name = "Tongue"
	category = "Flesh"
	result = list(/obj/item/organ/tongue)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/black_rose
	name = "Black Rose"
	category = "Flesh"
	result = list(/obj/item/black_rose)
	reqs = list(/obj/item/heart_blood_canister/filled = 5,
				/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 15)
	craftdiff = 5
	required_tech_node = "BLACK_ROSE"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/leechbait
	name = "leechbait (from bag)"
	craftdiff = 1
	result = list(
		/obj/item/bait/leech,
		/obj/item/bait/leech,
		/obj/item/bait/leech,
		)
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/lux_impure = 1,
		)
	subtype_reqs = TRUE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/leechbaitcloth
	name = "leechbait (from cloth)"
	craftdiff = 1
	result = list(
		/obj/item/bait/leech,
		/obj/item/bait/leech,
		/obj/item/bait/leech,
		)
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/reagent_containers/lux_impure = 1,
		)
	subtype_reqs = TRUE
	structurecraft = null
