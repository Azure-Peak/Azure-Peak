/obj/item/undies
	name = "briefs"
	desc = "An absolute necessity."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "briefs"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	throw_speed = 0.5
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	var/gendered
	var/race
	var/datum/bodypart_feature/underwear/undies_feature
	var/covers_breasts = FALSE
	sewrepair = TRUE
	grid_height = 32
	grid_width = 32
	var/sprite_acc = /datum/sprite_accessory/underwear/briefs

/obj/item/undies/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.underwear)
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
				return
			if(!undies_feature)
				var/datum/bodypart_feature/underwear/undies_new = new /datum/bodypart_feature/underwear()
				undies_new.set_accessory_type(sprite_acc, color, H)
				undies_feature = undies_new
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, needhand = 1, target = H))
				var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
				chest.add_bodypart_feature(undies_feature)
				user.dropItemToGround(src)
				forceMove(H)
				H.underwear = src
				undies_feature.accessory_colors = color

/obj/item/undies/Destroy()
	undies_feature = null
	return ..()

/obj/item/undies/bikini
	name = "bikini"
	icon_state = "bikini"
	covers_breasts = TRUE
	sprite_acc = /datum/sprite_accessory/underwear/bikini

/obj/item/undies/panties
	name = "panties"
	icon_state = "panties"
	sprite_acc = /datum/sprite_accessory/underwear/panties

/obj/item/undies/leotard
	name = "leotard"
	icon_state = "leotard"
	covers_breasts = TRUE
	sprite_acc = /datum/sprite_accessory/underwear/leotard

/obj/item/undies/athletic_leotard
	name = "athletic leotard"
	icon_state = "athletic_leotard"
	covers_breasts = TRUE
	sprite_acc = /datum/sprite_accessory/underwear/athletic_leotard

/obj/item/undies/braies
	name = "braies"
	desc = "A pair of linen underpants; Psydonia's most common."
	icon_state = "braies"
	sprite_acc = /datum/sprite_accessory/underwear/braies

// Craft

/datum/crafting_recipe/roguetown/sewing/undies
	name = "briefs"
	result = list(/obj/item/undies)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bikini
	name = "bikini"
	result = list(/obj/item/undies/bikini)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/panties
	name = "panties"
	result = list(/obj/item/undies/panties)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/leotard
	name = "leotard"
	result = list(/obj/item/undies/leotard)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/athletic_leotard
	name = "athletic leotard"
	result = list(/obj/item/undies/athletic_leotard)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/braies
	name = "braies"
	result = list(/obj/item/undies/braies)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2
