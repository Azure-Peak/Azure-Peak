/obj/item/clothing/legwears
	name = "stockings"
	desc = "A legwear made just for the pure aesthetics. Popular in courts and brothels alike."
	icon = 'icons/obj/items/clothes/stockings.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/stockings.dmi'
	icon_state = "stockings"
	item_state = "stockings"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CAN_BE_HIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = ARMOR_INTEG_FAILURE
	throw_speed = 0.5
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	var/covers_breasts = FALSE
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	slot_flags = ITEM_SLOT_MOUTH | ITEM_SLOT_SOCKS
	muteinmouth = TRUE

/obj/item/clothing/legwears/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(NO_UNDERWEAR in H.dna.species.species_traits)
			return
		if(!H.legwear_socks)
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_L_FOOT))
				return
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_R_FOOT))
				return
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, needhand = 1, target = H))
				H.equip_to_slot_if_possible(src, ITEM_SLOT_SOCKS, disable_warning = TRUE)

/obj/item/clothing/legwears/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/clothing/legwears/white
	color = "#e6e5e5"

/obj/item/clothing/legwears/black
	color = CLOTHING_BLACK

/obj/item/clothing/legwears/blue
	color = CLOTHING_BLUE

/obj/item/clothing/legwears/red
	color = "#6F0000"

/obj/item/clothing/legwears/purple
	color = "#664357"

//Silk variants

/obj/item/clothing/legwears/silk
	name = "silk stockings"
	desc = "A legwear made just for the pure aesthetics. Made out of thin silk. Popular among nobles."
	icon_state = "silk"
	item_state = "silk"

/obj/item/clothing/legwears/silk/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/clothing/legwears/silk/white
	color = "#e6e5e5"

/obj/item/clothing/legwears/silk/black
	color = CLOTHING_BLACK

/obj/item/clothing/legwears/silk/blue
	color = CLOTHING_BLUE

/obj/item/clothing/legwears/silk/red
	color = "#6F0000"

/obj/item/clothing/legwears/silk/purple
	color = "#664357"

//Fishnets

/obj/item/clothing/legwears/fishnet
	name = "fishnet stockings"
	desc = "A legwear popular among wenches."
	icon_state = "fishnet"
	item_state = "fishnet"

/obj/item/clothing/legwears/fishnet/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/clothing/legwears/fishnet/white
	color = "#e6e5e5"

/obj/item/clothing/legwears/fishnet/black
	color = CLOTHING_BLACK

/obj/item/clothing/legwears/fishnet/blue
	color = CLOTHING_BLUE

/obj/item/clothing/legwears/fishnet/red
	color = "#6F0000"

/obj/item/clothing/legwears/fishnet/purple
	color = "#664357"

//Thigh-high

/obj/item/clothing/legwears/thigh_high
	name = "thigh-high stockings"
	desc = "A legwear popular among those who plan to venture into colder climates."
	icon_state = "thigh"
	item_state = "thigh"

/obj/item/clothing/legwears/thigh_high/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/clothing/legwears/thigh_high/white
	color = "#e6e5e5"

//Thigh-high - Silk
/obj/item/clothing/legwears/thigh_high_silk
	name = "silk thigh-high stockings"
	desc = "A legwear popular amongst the aristocracy and wealth burghers. Goes well with any dress!"
	icon_state = "thigh_silk"
	item_state = "thigh_silk"

/obj/item/clothing/legwears/thigh_high_silk/white
	color = "#e6e5e5"

//Knee-high
/obj/item/clothing/legwears/knee_high
	name = "knee-high stockings"
	desc = "A legwear popular among those who enjoy taller boots."
	icon_state = "knee"
	item_state = "knee"

/obj/item/clothing/legwears/knee_high/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/clothing/legwears/knee_high/white
	color = "#e6e5e5"

//Knee-high
/obj/item/clothing/legwears/knee_high_silk
	name = "knee-high stockings"
	desc = "A legwear popular amongst wealthy courtesans and people with sense of style."
	icon_state = "knee_silk"
	item_state = "knee_silk"

/obj/item/clothing/legwears/knee_high_silk/white
	color = "#e6e5e5"

//Sleeves - Knee-high
/obj/item/clothing/legwears/sleeve_knee_silk
	name = "silk knee-high sleeves"
	desc = "A legwear for those who happen to possess sharp claws."
	icon_state = "sleeve_k_silk"
	item_state = "sleeve_k_silk"

/obj/item/clothing/legwears/sleeve_knee_silk/white
	color = "#e6e5e5"

//Sleeves - Knee-high
/obj/item/clothing/legwears/sleeve_stir_knee_silk
	name = "silk knee-high sleeves (stirrup)"
	desc = "A legwear for those who happen to possess sharp claws."
	icon_state = "sleeve_k_silk"
	item_state = "sleeve_k_silk"

/obj/item/clothing/legwears/sleeve_stir_knee_silk/white
	color = "#e6e5e5"

//Sleeves - Thigh-high
/obj/item/clothing/legwears/sleeve_stir_thigh_silk
	name = "silk knee-high sleeves (stirrup)"
	desc = "A legwear for those who happen to possess sharp claws. For the modest types."
	icon_state = "sleeve_ts_silk"
	item_state = "sleeve_ts_silk"

/obj/item/clothing/legwears/sleeve_stir_thigh_silk/white
	color = "#e6e5e5"

//Sleeves - Ankle-high
/obj/item/clothing/legwears/sleeve_stir_ankle_silk
	name = "silk knee-high sleeves (stirrup)"
	desc = "A legwear for those who happen to possess sharp claws. Are you even trying at this point?"
	icon_state = "sleeve_as_silk"
	item_state = "sleeve_as_silk"

/obj/item/clothing/legwears/sleeve_stir_ankle_silk/white
	color = "#e6e5e5"

// Supply

/datum/supply_pack/rogue/wardrobe/suits/stockings_white
	name = "White Stockings"
	cost = 10
	contains = list(
					/obj/item/clothing/legwears/white,
					/obj/item/clothing/legwears/white,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_black
	name = "Black Stockings"
	cost = 10
	contains = list(
					/obj/item/clothing/legwears/black,
					/obj/item/clothing/legwears/black,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_blue
	name = "Blue Stockings"
	cost = 10
	contains = list(
					/obj/item/clothing/legwears/blue,
					/obj/item/clothing/legwears/blue,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_red
	name = "Red Stockings"
	cost = 10
	contains = list(
					/obj/item/clothing/legwears/red,
					/obj/item/clothing/legwears/red,
				)
/datum/supply_pack/rogue/wardrobe/suits/stockings_purple
	name = "Purple Stockings"
	cost = 10
	contains = list(
					/obj/item/clothing/legwears/purple,
					/obj/item/clothing/legwears/purple,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_thigh_white
	name = "White Thigh-High Stockings"
	cost = 10
	contains = list(
					/obj/item/clothing/legwears/thigh_high/white,
					/obj/item/clothing/legwears/thigh_high/white,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_knee_white
	name = "White Knee-High Stockings"
	cost = 10
	contains = list(
					/obj/item/clothing/legwears/knee_high/white,
					/obj/item/clothing/legwears/knee_high/white,
				)

//Silk

/datum/supply_pack/rogue/wardrobe/suits/stockings_white_silk
	name = "White Silk Stockings"
	cost = 30
	contains = list(
					/obj/item/clothing/legwears/silk/white,
					/obj/item/clothing/legwears/silk/white,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_black_silk
	name = "Black Silk Stockings"
	cost = 30
	contains = list(
					/obj/item/clothing/legwears/silk/black,
					/obj/item/clothing/legwears/silk/black,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_blue_silk
	name = "Blue Silk Stockings"
	cost = 30
	contains = list(
					/obj/item/clothing/legwears/silk/blue,
					/obj/item/clothing/legwears/silk/blue,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_red_silk
	name = "Red Silk Stockings"
	cost = 30
	contains = list(
					/obj/item/clothing/legwears/silk/red,
					/obj/item/clothing/legwears/silk/red,
				)
/datum/supply_pack/rogue/wardrobe/suits/stockings_purple_silk
	name = "Purple Silk Stockings"
	cost = 30
	contains = list(
					/obj/item/clothing/legwears/silk/purple,
					/obj/item/clothing/legwears/silk/purple,
				)

//Fishnets

/datum/supply_pack/rogue/wardrobe/suits/stockings_white_fishnet
	name = "White Fishnet Stockings"
	cost = 5
	contains = list(
					/obj/item/clothing/legwears/fishnet/white,
					/obj/item/clothing/legwears/fishnet/white,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_black_fishnet
	name = "Black Fishnet Stockings"
	cost = 5
	contains = list(
					/obj/item/clothing/legwears/fishnet/black,
					/obj/item/clothing/legwears/fishnet/black,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_blue_fishnet
	name = "Blue Fishnet Stockings"
	cost = 5
	contains = list(
					/obj/item/clothing/legwears/fishnet/blue,
					/obj/item/clothing/legwears/fishnet/blue,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_red_fishnet
	name = "Red Fishnet Stockings"
	cost = 5
	contains = list(
					/obj/item/clothing/legwears/fishnet/red,
					/obj/item/clothing/legwears/fishnet/red,
				)
/datum/supply_pack/rogue/wardrobe/suits/stockings_purple_fishnet
	name = "Purple Fishnet Stockings"
	cost = 5
	contains = list(
					/obj/item/clothing/legwears/fishnet/purple,
					/obj/item/clothing/legwears/fishnet/purple,
				)

// Craft

/datum/crafting_recipe/roguetown/sewing/stockings_white
	name = "stockings"
	result = list(/obj/item/clothing/legwears/white)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stockings_thigh_white
	name = "stockings - thigh"
	result = list(/obj/item/clothing/legwears/thigh_high/white)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stockings_knee_white
	name = "stockings - knee"
	result = list(/obj/item/clothing/legwears/knee_high)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stockings_white_silk
	name = "silk stockings"
	result = list(/obj/item/clothing/legwears/silk/white)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/stockings_thigh_silk_white
	name = "silk stockings - thigh"
	result = list(/obj/item/clothing/legwears/thigh_high_silk/white)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/stockings_knee_silk_white
	name = "silk stockings - knee"
	result = list(/obj/item/clothing/legwears/knee_high_silk/white)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/stockings_white_fishnet
	name = "fishnet stockings"
	result = list(/obj/item/clothing/legwears/fishnet/white)
	reqs = list(/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/sleeves_knee_silk_white
	name = "silk sleeves - knee"
	result = list(/obj/item/clothing/legwears/sleeve_knee_silk/white)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/sleeves_knee_silk_white
	name = "silk sleeves - knee (stirrup)"
	result = list(/obj/item/clothing/legwears/sleeve_stir_knee_silk/white)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/sleeves_thigh_silk_white
	name = "silk sleeves - thigh (stirrup)"
	result = list(/obj/item/clothing/legwears/sleeve_stir_thigh_silk/white)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/sleeves_ankle_silk_white
	name = "silk sleeves - ankle (stirrup)"
	result = list(/obj/item/clothing/legwears/sleeve_stir_ankle_silk/white)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5
