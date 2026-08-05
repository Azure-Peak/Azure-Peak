/datum/crafting_recipe/roguetown/survival/cheele
	name = "cheele"
	display_category = ITEM_CAT_POTION
	result = list(
		/obj/item/natural/worms/leech/cheele
		)
	reqs = list(
		/obj/item/reagent_containers/lux = 1,
		/obj/item/natural/worms/leech = 1,
		)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = SKILL_LEVEL_EXPERT

/datum/crafting_recipe/roguetown/survival/purify_lux
	name = "purify lux"
	display_category = ITEM_CAT_POTION
	result = list(
		/obj/item/heart_blood_canister,
		/obj/item/reagent_containers/lux,
		)
	reqs = list(
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/heart_blood_canister/filled = 1,
		)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/purify_lux_vials
	name = "purify lux (vials)"
	display_category = ITEM_CAT_POTION
	result = list(
		/obj/item/reagent_containers/lux,
		/obj/item/heart_blood_vial,
		/obj/item/heart_blood_vial,
		/obj/item/heart_blood_vial,
		)
	reqs = list(
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/heart_blood_vial/filled = 3,
		)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/bandage
	name = "bandages (medicine)"
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	result = list(
		/obj/item/natural/cloth/bandage
	)
	reqs = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/silk = 1,
		/obj/item/ash = 1)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 2

/datum/crafting_recipe/roguetown/fleshcrafting/leechbait_leech_perfect
	name = "perfect leechbait (from cloth - with tick)"
	craftdiff = 1
	result = list(
		/obj/item/bait/leech/perfect,
		/obj/item/bait/leech/perfect,
		/obj/item/bait/leech/perfect,
		)
	reqs = list(
		/obj/item/natural/cloth = 1,
		/obj/item/leechtick_bloated = 1,
		)
	subtype_reqs = TRUE
	structurecraft = null
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 5

/datum/crafting_recipe/roguetown/fleshcrafting/leechbaitcloth_perfect
	name = "perfect leechbait (from cloth)"
	craftdiff = 1
	result = list(
		/obj/item/bait/leech/perfect,
		/obj/item/bait/leech/perfect,
		/obj/item/bait/leech/perfect,
		)
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/reagent_containers/lux_impure = 1,
		)
	subtype_reqs = TRUE
	structurecraft = null
