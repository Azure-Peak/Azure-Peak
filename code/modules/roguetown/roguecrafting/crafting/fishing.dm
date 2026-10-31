/datum/crafting_recipe/roguetown/survival/fishing
	abstract_type = /datum/crafting_recipe/roguetown/survival/fishing
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	category = "Tools"
	skillcraft = /datum/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/fishing/reel_twine
	name = "twine fishing line"
	result = /obj/item/fishing/reel/twine
	reqs = list(
		/obj/item/natural/fibers = 2,
		)

/datum/crafting_recipe/roguetown/survival/fishing/reel_leather
	name = "leather fishing line"
	result = /obj/item/fishing/reel/leather
	reqs = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/fishing/reel_silk
	name = "silk fishing line"
	result = /obj/item/fishing/reel/silk
	reqs = list(
		/obj/item/natural/silk = 2,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/fishing/creel
	name = "fisherman's creel"
	result = /obj/item/storage/meatbag/creel
	reqs = list(
		/obj/item/grown/log/tree/stick = 3,
		/obj/item/natural/fibers = 2,
		)
	verbage_simple = "weave"
	verbage = "weaves"

/datum/crafting_recipe/roguetown/survival/fishing/bobber
	name = "wooden bobber"
	result = /obj/item/fishing/line/bobber
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/fibers = 2,
		)

/datum/crafting_recipe/roguetown/survival/fishing/sinker
	name = "stone sinker"
	result = /obj/item/fishing/line/sinker
	reqs = list(
		/obj/item/natural/stone = 1,
		/obj/item/natural/fibers = 2,
		)

/datum/crafting_recipe/roguetown/survival/fishing/hook_wooden
	name = "wooden gorge fishing hook"
	result = /obj/item/fishing/hook/wooden
	reqs = list(
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/fishing/hook_thorn
	name = "thorn fishing hook"
	result = /obj/item/fishing/hook/thorn
	reqs = list(
		/obj/item/natural/thorn = 2,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/fishing/bait_red
	name = "red bait (x6)"
	result = list(
		/obj/item/fishing/bait/meat,
		/obj/item/fishing/bait/meat,
		/obj/item/fishing/bait/meat,
		/obj/item/fishing/bait/meat,
		/obj/item/fishing/bait/meat,
		/obj/item/fishing/bait/meat,
		)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 2,
		)

/datum/crafting_recipe/roguetown/survival/fishing/bait_dough
	name = "doughy bait (x6)"
	result = list(
		/obj/item/fishing/bait/dough,
		/obj/item/fishing/bait/dough,
		/obj/item/fishing/bait/dough,
		/obj/item/fishing/bait/dough,
		/obj/item/fishing/bait/dough,
		/obj/item/fishing/bait/dough,
		)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/dough = 1,
		)

/datum/crafting_recipe/roguetown/survival/fishing/bait_gray
	name = "gray bait (x6)"
	result = list(
		/obj/item/fishing/bait/gray,
		/obj/item/fishing/bait/gray,
		/obj/item/fishing/bait/gray,
		/obj/item/fishing/bait/gray,
		/obj/item/fishing/bait/gray,
		/obj/item/fishing/bait/gray,
		)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 1,
		/obj/item/reagent_containers/food/snacks/rogue/doughslice = 1,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/fishing/bait_speckled
	name = "speckled bait (x6)"
	result = list(
		/obj/item/fishing/bait/speckled,
		/obj/item/fishing/bait/speckled,
		/obj/item/fishing/bait/speckled,
		/obj/item/fishing/bait/speckled,
		/obj/item/fishing/bait/speckled,
		/obj/item/fishing/bait/speckled,
		)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 1,
		/obj/item/reagent_containers/food/snacks/rogue/doughslice = 1,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/fishing/bait_shell
	name = "shell bait (x6)"
	result = list(
		/obj/item/fishing/bait/shell,
		/obj/item/fishing/bait/shell,
		/obj/item/fishing/bait/shell,
		/obj/item/fishing/bait/shell,
		/obj/item/fishing/bait/shell,
		/obj/item/fishing/bait/shell,
		)
	reqs = list(
		/obj/item/oystershell = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 1,
		)

