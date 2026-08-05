/obj/item/kitchen/fork
	name = "wooden fork"	
	icon = 'modular/Neu_Food/icons/cookware/fork.dmi'
	icon_state = "fork_wooden"
	flags_1 = CONDUCT_1
	hitsound = 'sound/blank.ogg'
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_TINY
	max_blade_int = 40
	max_integrity = 40
	wbalance = WBALANCE_SWIFT
	thrown_bclass = BCLASS_STAB
	possible_item_intents = list(/datum/intent/use, /datum/intent/dagger/thrust/fork)
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')

/obj/item/kitchen/fork/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking most foodstuffs with the fork allows you to take a bite from it.")
	. += span_info("Nobler appetites prefer utensils over simply eating and drinking with one's bare hands.")

/datum/intent/dagger/thrust/fork
	penfactor = PEN_LIGHT

/obj/item/kitchen/fork/aalloy
	name = "decrepit fork"
	icon_state = "afork"
	color = "#bb9696"

/obj/item/kitchen/fork/iron
	name = "iron fork"
	icon_state = "fork_iron"

/obj/item/kitchen/fork/bronze
	name = "bronze fork"
	icon_state = "fork_bronze"

/obj/item/kitchen/fork/tin
	name = "pewter fork"
	icon_state = "fork_iron"

/obj/item/kitchen/fork/gold
	name = "gold fork"
	icon_state = "fork_gold"

/obj/item/kitchen/fork/silver
	name = "silver fork"
	icon_state = "fork_silver"
	is_silver = TRUE
	is_lesser_silver = TRUE

/obj/item/kitchen/fork/carved
	name = "carved fork"
	icon_state = "afork"
	has_item_quality = TRUE

/obj/item/kitchen/fork/carved/shell
	name = "shell fork"
	icon_state = "fork_shell"
	
/obj/item/kitchen/fork/carved/rose
	name = "rosestone fork"
	icon_state = "fork_rose"

/obj/item/kitchen/fork/carved/jade
	name = "jade fork"
	icon_state = "fork_jade"

/obj/item/kitchen/fork/carved/onyxa
	name = "onyxa fork"
	icon_state = "fork_onyxa"

/obj/item/kitchen/fork/carved/turq
	name = "cerulite fork"
	icon_state = "fork_turq"

/obj/item/kitchen/fork/carved/coral
	name = "heartstone fork"
	icon_state = "fork_coral"

/obj/item/kitchen/fork/carved/amber
	name = "amber fork"
	icon_state = "fork_amber"

/obj/item/kitchen/fork/carved/opal
	name = "opal fork"
	icon_state = "fork_opal"

/obj/item/kitchen/fork/carved/porcelain
	name = "porcelain fork"
	icon_state = "fork_porcelain"
	sellprice = 10
