/obj/item/storage/roguebag
	name = "sack"
	desc = "A sack of rough cloth meant for peasantry."
	icon_state = "cbag"
	item_state = "cbag"
	icon = 'icons/roguetown/items/misc.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = NONE
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	max_integrity = 300
	component_type = /datum/component/storage/concrete/roguetown/sack
	grid_width = 32
	grid_height = 64

/obj/item/storage/roguebag/examine(mob/user)
	. = ..()
	if(contents.len)
		. += span_notice("[contents.len] thing[contents.len > 1 ? "s" : ""] in the sack.")

/obj/item/storage/roguebag/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		user.become_blind("blindfold_[REF(src)]")

/obj/item/storage/roguebag/dropped(mob/living/carbon/human/user)
	..()
	user.cure_blind("blindfold_[REF(src)]")

/obj/item/storage/roguebag/mob_can_equip(mob/M, slot)
	if(!..())
		return FALSE
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		return FALSE
	else
		return TRUE


/obj/item/storage/roguebag/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)

	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)

		var/obj/item/I = pick(things)
		STR.remove_from_storage(I, get_turf(user))
		user.put_in_hands(I)

/obj/item/storage/roguebag/update_icon()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		icon_state = "fbag"
		w_class = WEIGHT_CLASS_BULKY
	else
		icon_state = "cbag"
		w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/roguebag/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
"sx" = -4,
"sy" = -7,
"nx" = 6,
"ny" = -6,
"wx" = -2,
"wy" = -7,
"ex" = -1,
"ey" = -7,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 0,
"sturn" = 0,
"wturn" = 0,
"eturn" = 0,
"nflip" = 8,
"sflip" = 0,
"wflip" = 0,
"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/storage/roguebag/food
	populate_contents = list(
	/obj/item/reagent_containers/food/snacks/rogue/bread,
	/obj/item/reagent_containers/food/snacks/grown/apple,
	/obj/item/reagent_containers/glass/bottle/waterskin/milk,
	/obj/item/fishingrod,
	/obj/item/natural/worms/grubs,
	/obj/item/natural/worms/grubs,
	/obj/item/natural/worms/grubs,
	/obj/item/natural/worms,
	/obj/item/natural/worms,
	/obj/item/natural/worms,
	/obj/item/natural/worms/leech,
	/obj/item/natural/worms/leech,
	/obj/item/natural/worms/leech,
	/obj/item/cooking/pan
	)

/obj/item/storage/roguebag/ash
	populate_contents = list(
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
	/obj/item/ash
	)
