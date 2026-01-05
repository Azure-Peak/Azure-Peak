/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|GROIN
	icon = 'icons/obj/items/clothes/dress.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/dress.dmi'
	name = "strapless dress"
	desc = "It barely covers anything at all!"
	flags_inv = HIDEBOOB|HIDECROTCH
	icon_state = "strapless"
	sleevetype = null
	sleeved = null

//COLORS

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/blue
	color = CLOTHING_BLUE

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/purple
	color = "#664357"

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/red
	color = "#6F0000"

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/random/Initialize()
	color = pick(CLOTHING_BLACK, CLOTHING_BLUE, "#664357", "#6F0000")
	..()

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/dress.dmi'
	name = "strapless dress"
	desc = "It barely covers anything at all!"
	flags_inv = HIDEBOOB|HIDECROTCH
	icon_state = "strapless2"
	icon = 'icons/obj/items/clothes/dress.dmi'
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1


//SUPPLY

/datum/supply_pack/rogue/wardrobe/suits/strapless_dress_black
	name = "Black Strapless Dresses"
	cost = 10
	contains = list(
					/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/black,
					/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/black,
				)

/datum/supply_pack/rogue/wardrobe/suits/strapless_dress_blue
	name = "Blue Strapless Dresses"
	cost = 10
	contains = list(
					/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/blue,
					/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/blue,
				)

/datum/supply_pack/rogue/wardrobe/suits/strapless_dress_red
	name = "Red Strapless Dresses"
	cost = 10
	contains = list(
					/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/red,
					/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/red,
				)

/datum/supply_pack/rogue/wardrobe/suits/strapless_dress_purple
	name = "Purple Strapless Dresses"
	cost = 10
	contains = list(
					/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/purple,
					/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/purple,
				)
