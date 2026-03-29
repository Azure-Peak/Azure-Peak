//T1 Enchantments
/datum/magic_item/mundane/woodcut
	name = "woodcutting"
	description = "It is firm like an tree."
	glow_color = "#6B8E23"
	var/last_used

/datum/magic_item/mundane/woodcut/on_hit_structure(var/obj/item/i, var/obj/target, var/mob/living/user)
	if(istype(target, /obj/structure/flora))
		var/obj/structure/flora/tree = target
		tree.obj_integrity -= 70
	. = ..()

/datum/magic_item/mundane/mining
	name = "mining"
	description = "It is coated with rock."
	glow_color = "#708090"
	var/active_item = FALSE
	var/max_skill = FALSE

/datum/magic_item/mundane/mining/on_hit_structure(var/obj/item/i, var/obj/target, var/mob/living/user)
	if(istype(target, /obj/item/natural/rock))
		var/obj/item/natural/rock/rocktarget = target
		rocktarget.obj_integrity -= 500
	. = ..()

/datum/magic_item/mundane/mining/on_equip(var/obj/item/i, var/mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == ITEM_SLOT_HANDS)
		user.change_stat(STATKEY_WIL, 1)
		if(user.get_skill_level(/datum/skill/labor/mining)== 6)
			max_skill = TRUE
		else
			user.adjust_skillrank(/datum/skill/labor/mining, 1, TRUE)
		to_chat(user, span_notice("I feel ready to mine!"))
		active_item = TRUE
	else
		return

/datum/magic_item/mundane/mining/on_drop(var/obj/item/i, var/mob/living/user)
	. = ..()
	if(active_item)
		active_item = FALSE
		if (!max_skill)
			user.adjust_skillrank(/datum/skill/labor/mining, -1, TRUE)
		user.change_stat(STATKEY_WIL, -1)
		to_chat(user, span_notice("I feel mundane once more"))



/datum/magic_item/mundane/xylix
	name = "Xylix's boon"
	description = "It almost seems to give off the faint sound of laughter."
	glow_color = "#DAA520"
	var/active_item = FALSE

/datum/magic_item/mundane/xylix/on_equip(var/obj/item/i, var/mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		user.change_stat(STATKEY_LCK, 1, "xylix_enchant")
		to_chat(user, span_notice("I feel rather lucky"))
		active_item = TRUE

/datum/magic_item/mundane/xylix/on_drop(var/obj/item/i, var/mob/living/user)
	if(active_item)
		active_item = FALSE
		user.change_stat(STATKEY_LCK, 0, "xylix_enchant")
		to_chat(user, span_notice("I feel mundane once more"))

/datum/magic_item/mundane/revealinglight
	name = "revealing light"
	description = "It emits a shining light."
	glow_color = "#FFB347"
	var/active = FALSE

/datum/magic_item/mundane/revealinglight/on_use(var/obj/item/i, var/mob/living/user)
	if(!active)
		active = TRUE
		to_chat(user, span_notice("I grip [i] lightly, and it abruptly lights up with shining light"))
		if(i.light_system == MOVABLE_LIGHT)
			// set_light_range() has a signal ordering bug where the movable light
			// component reads light_outer_range before it is updated.
			// Workaround: set vars directly, then poke the component via signal.
			i.light_inner_range = 2
			i.light_outer_range = 6
			i.light_power = 2
			i.light_color = "#3FBAFD"
			SEND_SIGNAL(i, COMSIG_ATOM_SET_LIGHT_RANGE, 2, 6)
			SEND_SIGNAL(i, COMSIG_ATOM_SET_LIGHT_POWER, 2)
			SEND_SIGNAL(i, COMSIG_ATOM_SET_LIGHT_COLOR, "#3FBAFD")
			i.set_light_on(TRUE)
		else
			i.set_light(6, 2, 2, l_color = "#3FBAFD", l_on = TRUE)
		i.update_icon()
	. = ..()

/datum/magic_item/mundane/holding
	name = "storage"
	description = "It seems bigger on the inside."
	glow_color = "#9370DB"

/datum/magic_item/mundane/holding/on_apply(var/obj/item/i)
	.=..()
	var/obj/item/storage = i
	var/datum/component/storage/STR = storage.GetComponent(/datum/component/storage)
	if(STR.max_w_class == WEIGHT_CLASS_SMALL)
		STR.max_w_class++
	STR.screen_max_columns = STR.screen_max_columns + 2

/datum/magic_item/mundane/magnifiedlight
	name = "magnified light"
	description = "Its light is painfully bright."
	glow_color = "#FFB347"

/datum/magic_item/mundane/magnifiedlight/on_apply(var/obj/item/i)
	. = ..()
	var/new_range = max(i.light_outer_range * 2, i.light_outer_range + 3)
	var/new_inner = new_range / 4
	if(i.light_system == MOVABLE_LIGHT)
		i.light_inner_range = new_inner
		i.light_outer_range = new_range
		SEND_SIGNAL(i, COMSIG_ATOM_SET_LIGHT_RANGE, new_inner, new_range)
	else
		i.set_light(new_range)
	i.update_icon()
