/obj/item/storage/roguebasket
	name = "basket"
	desc = "A woven basket of sticks and fiber, good for carrying your apples."
	icon = 'icons/roguetown/items/Basket.dmi'
	icon_state = "Picnic basket"
	item_state = "Picnic basket"
	lefthand_file = 'icons/roguetown/items/Basket.dmi'
	righthand_file = 'icons/roguetown/items/Basket.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	dropshrink = 0.8
	component_type = /datum/component/storage/concrete/roguetown/basket
	grid_width = 32
	grid_height = 32

/obj/item/storage/roguebasket/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, female = FALSE, customi = null, sleeveindex, boobed_overlay = FALSE, icon/clip_mask = null)
	if(isinhands && !override_state && ismob(loc))
		var/mob/holder = loc
		var/hand_index = holder.get_held_index_of_item(src)
		if(hand_index)
			override_state = (hand_index % 2) ? "Human Male left hand" : "Human Male right hand"
	return ..(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, clip_mask)

/datum/crafting_recipe/roguetown/basket
	name = "basket"
	category = "Containers"
	result = /obj/item/storage/roguebasket
	reqs = list(/obj/item/grown/log/tree/stick = 2,
				/obj/item/natural/fibers = 3)
	verbage_simple = "weave"
	verbage = "weaves"
	craftdiff = 0
	skillcraft = null

/datum/crafting_recipe/roguetown/basket/build_display_cache()
	var/datum/skill/S = /datum/skill/craft/crafting
	..()
	cached_category = initial(S.name)
