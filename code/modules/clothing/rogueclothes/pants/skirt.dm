
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
