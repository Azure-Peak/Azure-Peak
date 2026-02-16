
/obj/item/clothing/under/roguetown/skirt
	name = "skirt"
	desc = "Long, flowing, and modest."
	icon_state = "skirt"
	item_state = "skirt"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	sleevetype = "skirt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	alternate_worn_layer = (SHIRT_LAYER)
	salvage_amount = 1

/obj/item/clothing/under/roguetown/skirt/random
	name = "skirt"

/obj/item/clothing/under/roguetown/skirt/random/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f", CLOTHING_BLUE)
	..()

/obj/item/clothing/under/roguetown/skirt/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Shift-right click while targeting either leg to tear a sleeve off, which can be used to bandage wounds in an emergency.")
	. += span_info("The chance to successfully tear a sleeve off scales with your character's Strength.")

/obj/item/clothing/under/roguetown/skirt/blue
	color = CLOTHING_BLUE

/obj/item/clothing/under/roguetown/skirt/green
	color = CLOTHING_GREEN

/obj/item/clothing/under/roguetown/skirt/red
	color = CLOTHING_RED

/obj/item/clothing/under/roguetown/skirt/brown
	color = CLOTHING_BROWN

/obj/item/clothing/under/roguetown/skirt/black
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/skirt/desert
	name = "desert skirt"
	desc = "At least it cools me off, but what of the modesty?"
	icon_state = "desertskirt"
	item_state = "desertskirt"

/obj/item/clothing/under/roguetown/skirt/courtphysician
	name = "sanguine skirt"
	desc = "An elegant velvet skirt that does you no good when running to someones aid."
	icon_state = "docskirt"
	item_state = "docskirt"
	icon = 'icons/roguetown/clothing/special/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/courtphys.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_RED
	alternate_worn_layer = (SHIRT_LAYER)
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/under/roguetown/skirt/courtphysician/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/under/roguetown/skirt/courtphysician/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
