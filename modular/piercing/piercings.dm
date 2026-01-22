/obj/item/piercings
	name = "piercings"
	desc = "piercings."
	icon = 'modular/icons/mob/sprite_accessory/piercings/rings.dmi'
	icon_state = "rings"
	obj_flags = CAN_BE_HIT
	blade_dulling = DULLING_CUT
	max_integrity = 20
	w_class = WEIGHT_CLASS_NORMAL
	integrity_failure = 0.1
	var/datum/bodypart_feature/piercing/piercings_feature
	var/sprite_acc = /datum/sprite_accessory/piercing/rings

/obj/item/piercings/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.piercings_item)
			if(!get_location_accessible(H, BODY_ZONE_CHEST))
				return
			if(!piercings_feature)
				var/datum/bodypart_feature/piercing/piercings_new = new /datum/bodypart_feature/piercing()
				piercings_new.set_accessory_type(sprite_acc, color, H)
				piercings_feature = piercings_new
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, target = H))
				var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
				chest.add_bodypart_feature(piercings_feature)
				user.dropItemToGround(src)
				forceMove(H)
				H.piercings_item = src

/obj/item/piercings/beads
	name = "bead piercings"
	desc = "Same as the ear ones, but for your nipples. These are in a shape of beads."
	icon = 'modular/icons/mob/sprite_accessory/piercings/beads.dmi'
	icon_state = "beads"
	sprite_acc = /datum/sprite_accessory/piercing/beads

/obj/item/piercings/beads/gold
	name = "golden bead piercings"
	desc = "Same as the ear ones, but for your nipples. These are in a shape of beads, made of gold."
	icon = 'modular/icons/mob/sprite_accessory/piercings/beads.dmi'
	icon_state = "beads-g"
	sprite_acc = /datum/sprite_accessory/piercing/beads/gold

/obj/item/piercings/beads/silver
	name = "silver bead piercings"
	desc = "Same as the ear ones, but for your nipples. These are in a shape of beads, made of silver."
	icon = 'modular/icons/mob/sprite_accessory/piercings/beads.dmi'
	icon_state = "beads-s"
	sprite_acc = /datum/sprite_accessory/piercing/beads/silver

/obj/item/piercings/beads/emerald
	name = "emerald bead piercings"
	desc = "Same as the ear ones, but for your nipples. These are in a shape of beads, made of emerald."
	icon = 'modular/icons/mob/sprite_accessory/piercings/beads.dmi'
	icon_state = "beads-e"
	sprite_acc = /datum/sprite_accessory/piercing/beads/emerald

/obj/item/piercings/rings
	name = "ring piercings"
	desc = "Same as the ear ones, but for your nipples. These are in a shape of a ring."
	icon_state = "rings"
	sprite_acc = /datum/sprite_accessory/piercing/rings

/obj/item/piercings/rings/gold
	name = "golden ring piercings"
	desc = "Same as the ear ones, but for your nipples. These are in a shape of a ring, made of gold."
	icon_state = "rings-g"
	sprite_acc = /datum/sprite_accessory/piercing/rings/gold

/obj/item/piercings/rings/silver
	name = "silver ring piercings"
	desc = "Same as the ear ones, but for your nipples. These are in a shape of a ring, made of silver."
	icon_state = "rings-s"
	sprite_acc = /datum/sprite_accessory/piercing/rings/silver

/obj/item/piercings/rings/emerald
	name = "emerald ring piercings"
	desc = "Same as the ear ones, but for your nipples. These are in a shape of a ring, made of emerald."
	icon_state = "rings-e"
	sprite_acc = /datum/sprite_accessory/piercing/rings/emerald
