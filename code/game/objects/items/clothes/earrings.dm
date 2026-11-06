/obj/item/earrings
	name = "gold earrings"
	gender = PLURAL
	desc = "A pair of stylish ear ornaments."
	icon = 'icons/obj/items/clothes/earrings.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/earrings.dmi'
	icon_state = "gold"
	item_state = "gold"
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CAN_BE_HIT
	max_integrity = 200
	integrity_failure = 0
	slot_flags = NONE
	extra_slot_flags = EXTRA_SLOT_EARRINGS
	gendered = FALSE
	// Render above hair, while retaining the dedicated integer overlay cache index.
	alternate_worn_layer = CUSTOM_HAIR_ABOVE_SNOUT_LAYER - 0.1

/obj/item/earrings/silver
	name = "silver earrings"
	icon_state = "silver"
	item_state = "silver"

/obj/item/earrings/hoop
	name = "gold hoop earrings"
	icon_state = "hoop_gold"
	item_state = "hoop_gold"

/obj/item/earrings/hoop/silver
	name = "silver hoop earrings"
	icon_state = "hoop_silver"
	item_state = "hoop_silver"

/obj/item/earrings/stud
	name = "stud earrings"
	icon_state = "stud"
	item_state = "stud"

/obj/item/earrings/dangle
	name = "dangling earrings"
	icon_state = "dangle"
	item_state = "dangle"

/obj/item/earrings/attack(mob/M, mob/user, def_zone)
	if(!ishuman(M))
		return ..()
	var/mob/living/carbon/human/wearer = M
	if(wearer.earrings || wearer.is_inventory_slot_obscured(SLOT_EARRINGS))
		return
	user.visible_message(span_notice("[user] tries to put [src] on [wearer]..."))
	if(do_after(user, equip_delay_other, target = wearer))
		equip_from_hands(user, wearer, SLOT_EARRINGS)

/// Return TRUE when this click targets earrings, including when access is blocked.
/mob/living/carbon/human/proc/try_remove_earrings(mob/user)
	if(!isliving(user) || !earrings || user.get_active_held_item() || !(user.zone_selected in list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_EARS)))
		return FALSE
	if(!user.Adjacent(src) || user.incapacitated() || user.restrained() || !user.has_active_hand() || is_inventory_slot_obscured(SLOT_EARRINGS))
		return TRUE
	if(user != src)
		user.stripPanelUnequip(earrings, src, SLOT_EARRINGS)
		return TRUE
	var/obj/item/ornament = earrings
	if(ornament.canStrip(user, src) && do_after(user, ornament.strip_delay, needhand = TRUE, target = src))
		if(ornament && earrings == ornament && !is_inventory_slot_obscured(SLOT_EARRINGS) && dropItemToGround(ornament))
			put_in_hands(ornament)
	return TRUE
