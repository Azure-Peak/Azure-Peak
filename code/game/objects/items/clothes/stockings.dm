/obj/item/legwears
	name = "stockings(under)"
	desc = "A legwear made just for the pure aesthetics. Popular in courts and brothels alike."
	icon = 'icons/obj/items/clothes/stockings.dmi'
	icon_state = "stockings"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CAN_BE_HIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	throw_speed = 0.5
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	var/gendered
	var/race
	var/datum/bodypart_feature/legwear/legwears_feature
	var/covers_breasts = FALSE
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	var/sprite_acc = /datum/sprite_accessory/legwear/stockings

/obj/item/legwears/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.legwear_socks)
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_L_FOOT))
				return
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_R_FOOT))
				return
			if(!legwears_feature)
				var/datum/bodypart_feature/legwear/legwear_new = new /datum/bodypart_feature/legwear()
				legwear_new.set_accessory_type(sprite_acc, color, H)
				legwears_feature = legwear_new
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, needhand = 1, target = H))
				var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
				chest.add_bodypart_feature(legwears_feature)
				user.dropItemToGround(src)
				forceMove(H)
				H.legwear_socks = src
				legwears_feature.accessory_colors = color

/obj/item/legwears/Destroy()
	legwears_feature = null
	return ..()

/obj/item/legwears/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/legwears/white
	color = "#e6e5e5"

/obj/item/legwears/black
	color = CLOTHING_BLACK

/obj/item/legwears/blue
	color = CLOTHING_BLUE

/obj/item/legwears/red
	color = "#6F0000"

/obj/item/legwears/purple
	color = "#664357"

//Silk variants

/obj/item/legwears/silk
	name = "silk stockings"
	desc = "A legwear made just for the pure aesthetics. Made out of thin silk. Popular among nobles."
	icon_state = "silk"

/obj/item/legwears/silk/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/legwears/silk/white
	color = "#e6e5e5"

/obj/item/legwears/silk/black
	color = CLOTHING_BLACK

/obj/item/legwears/silk/blue
	color = CLOTHING_BLUE

/obj/item/legwears/silk/red
	color = "#6F0000"

/obj/item/legwears/silk/purple
	color = "#664357"

//Fishnets

/obj/item/legwears/fishnet
	name = "fishnet stockings"
	desc = "A legwear popular among wenches."
	icon_state = "fishnet"

/obj/item/legwears/fishnet/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/legwears/fishnet/white
	color = "#e6e5e5"

/obj/item/legwears/fishnet/black
	color = CLOTHING_BLACK

/obj/item/legwears/fishnet/blue
	color = CLOTHING_BLUE

/obj/item/legwears/fishnet/red
	color = "#6F0000"

/obj/item/legwears/fishnet/purple
	color = "#664357"

/obj/item/legwears/thigh_high
	name = "thigh-high stockings"
	desc = "A legwear popular among those who plan to venture into colder climates."
	icon_state = "thigh"

/obj/item/legwears/thigh_high/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/legwears/thigh_high/white
	color = "#e6e5e5"

/obj/item/legwears/knee_high
	name = "knee-high stockings"
	desc = "A legwear popular among those who enjoy taller boots."
	icon_state = "knee"

/obj/item/legwears/knee_high/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/legwears/knee_high/white
	color = "#e6e5e5"

// Supply

/datum/supply_pack/rogue/wardrobe/suits/stockings_white
	name = "White Stockings"
	cost = 10
	contains = list(
					/obj/item/legwears/white,
					/obj/item/legwears/white,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_black
	name = "Black Stockings"
	cost = 10
	contains = list(
					/obj/item/legwears/black,
					/obj/item/legwears/black,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_blue
	name = "Blue Stockings"
	cost = 10
	contains = list(
					/obj/item/legwears/blue,
					/obj/item/legwears/blue,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_red
	name = "Red Stockings"
	cost = 10
	contains = list(
					/obj/item/legwears/red,
					/obj/item/legwears/red,
				)
/datum/supply_pack/rogue/wardrobe/suits/stockings_purple
	name = "Purple Stockings"
	cost = 10
	contains = list(
					/obj/item/legwears/purple,
					/obj/item/legwears/purple,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_thigh_white
	name = "White Thigh-High Stockings"
	cost = 10
	contains = list(
					/obj/item/legwears/thigh_high/white,
					/obj/item/legwears/thigh_high/white,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_knee_white
	name = "White Knee-High Stockings"
	cost = 10
	contains = list(
					/obj/item/legwears/knee_high/white,
					/obj/item/legwears/knee_high/white,
				)

//Silk

/datum/supply_pack/rogue/wardrobe/suits/stockings_white_silk
	name = "White Silk Stockings"
	cost = 30
	contains = list(
					/obj/item/legwears/silk/white,
					/obj/item/legwears/silk/white,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_black_silk
	name = "Black Silk Stockings"
	cost = 30
	contains = list(
					/obj/item/legwears/silk/black,
					/obj/item/legwears/silk/black,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_blue_silk
	name = "Blue Silk Stockings"
	cost = 30
	contains = list(
					/obj/item/legwears/silk/blue,
					/obj/item/legwears/silk/blue,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_red_silk
	name = "Red Silk Stockings"
	cost = 30
	contains = list(
					/obj/item/legwears/silk/red,
					/obj/item/legwears/silk/red,
				)
/datum/supply_pack/rogue/wardrobe/suits/stockings_purple_silk
	name = "Purple Silk Stockings"
	cost = 30
	contains = list(
					/obj/item/legwears/silk/purple,
					/obj/item/legwears/silk/purple,
				)

//Fishnets

/datum/supply_pack/rogue/wardrobe/suits/stockings_white_fishnet
	name = "White Fishnet Stockings"
	cost = 5
	contains = list(
					/obj/item/legwears/fishnet/white,
					/obj/item/legwears/fishnet/white,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_black_fishnet
	name = "Black Fishnet Stockings"
	cost = 5
	contains = list(
					/obj/item/legwears/fishnet/black,
					/obj/item/legwears/fishnet/black,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_blue_fishnet
	name = "Blue Fishnet Stockings"
	cost = 5
	contains = list(
					/obj/item/legwears/fishnet/blue,
					/obj/item/legwears/fishnet/blue,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_red_fishnet
	name = "Red Fishnet Stockings"
	cost = 5
	contains = list(
					/obj/item/legwears/fishnet/red,
					/obj/item/legwears/fishnet/red,
				)
/datum/supply_pack/rogue/wardrobe/suits/stockings_purple_fishnet
	name = "Purple Fishnet Stockings"
	cost = 5
	contains = list(
					/obj/item/legwears/fishnet/purple,
					/obj/item/legwears/fishnet/purple,
				)

// Craft

/datum/crafting_recipe/roguetown/sewing/stockings_white
	name = "stockings"
	result = list(/obj/item/legwears/white)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stockings_thigh_white
	name = "stockings - thigh"
	result = list(/obj/item/legwears/thigh_high/white)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stockings_knee_white
	name = "stockings - knee"
	result = list(/obj/item/legwears/knee_high)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stockings_white_silk
	name = "silk stockings"
	result = list(/obj/item/legwears/silk/white)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/stockings_white_fishnet
	name = "fishnet stockings"
	result = list(/obj/item/legwears/fishnet/white)
	reqs = list(/obj/item/natural/fibers = 2)
	craftdiff = 3
