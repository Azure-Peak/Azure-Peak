/obj/item/reagent_containers/peppermill // new with some animated art
	name = "pepper mill"
	desc = "Let the lord have his snack; twist the head until it cracks."
	icon = 'modular/Neu_Food/icons/cookware/peppermill.dmi'
	icon_state = "peppermill"
	layer = CLOSED_BLASTDOOR_LAYER // obj layer + a little, small obj layering above convenient
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	list_reagents = list(/datum/reagent/consumable/blackpepper = 5)
	reagent_flags = TRANSPARENT

/obj/item/reagent_containers/peppermill/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking some cooked meats, such as frysteaks and frybirds, will season them into higher-classed meals.")
