/obj/item/reagent_containers/glass/bowl
	name = "wooden bowl"
	desc = "It is the empty space that makes the bowl useful."
	icon = 'modular/Neu_Food/icons/cookware/bowl.dmi'
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	icon_state = "bowl"
	force = 5
	throwforce = 5
	reagent_flags = OPENCONTAINER
	amount_per_transfer_from_this = 7
	possible_transfer_amounts = list(7)
	dropshrink = 1
	w_class = WEIGHT_CLASS_NORMAL
	volume = 30
	obj_flags = CAN_BE_HIT
	sellprice = 1
	drinksounds = list('sound/items/drink_cup (1).ogg','sound/items/drink_cup (2).ogg','sound/items/drink_cup (3).ogg','sound/items/drink_cup (4).ogg','sound/items/drink_cup (5).ogg')
	fillsounds = list('sound/items/fillcup.ogg')

/obj/item/reagent_containers/glass/bowl/aalloy
	name = "decrepit bowl"
	icon_state = "abowl"
	sellprice = 15

/obj/item/reagent_containers/glass/bowl/iron
	name = "iron bowl"
	icon_state = "bowl_iron"

/obj/item/reagent_containers/glass/bowl/bronze
	name = "bronze bowl"
	icon_state = "bowl_bronze"

/obj/item/reagent_containers/glass/bowl/gold
	name = "gold bowl"
	icon_state = "bowl_gold"
	sellprice = 40

/obj/item/reagent_containers/glass/bowl/silver
	name = "silver bowl"
	icon_state = "bowl_silver"
	sellprice = 60
	is_silver = FALSE //temporary measure to prevent people from easily metachecking vampyres. Replace with a more sophisticated alternative if-or-when available.

/obj/item/reagent_containers/glass/bowl/carved
	name = "carved bowl"
	desc = "You shouldn't be seeing this."
	icon_state = "abowl"
	sellprice = 0

/obj/item/reagent_containers/glass/bowl/carved/jade
	name = "jade bowl"
	desc = "A bowl carved out of jade."
	icon_state = "bowl_jade"
	sellprice = 55

/obj/item/reagent_containers/glass/bowl/carved/onyxa
	name = "onyxa bowl"
	desc = "A bowl carved out of onyxa."
	icon_state = "bowl_onyxa"
	sellprice = 35

/obj/item/reagent_containers/glass/bowl/carved/rose
	name = "rosestone bowl"
	desc = "A bowl carved out of rosestone."
	icon_state = "bowl_rose"
	sellprice = 20

/obj/item/reagent_containers/glass/bowl/carved/amber
	name = "amber bowl"
	desc = "A bowl carved out of amber."
	icon_state = "bowl_amber"
	sellprice = 55

/obj/item/reagent_containers/glass/bowl/carved/turq
	name = "cerulite bowl"
	desc = "A bowl carved out of cerulite."
	icon_state = "bowl_turq"
	sellprice = 80

/obj/item/reagent_containers/glass/bowl/carved/shell
	name = "shell bowl"
	desc = "A bowl carved out of shell."
	icon_state = "bowl_shell"
	sellprice = 15


/obj/item/reagent_containers/glass/bowl/carved/coral
	name = "heartstone bowl"
	desc = "A bowl carved out of heartstone."
	icon_state = "bowl_coral"
	sellprice = 65

/obj/item/reagent_containers/glass/bowl/carved/opal
	name = "opal bowl"
	desc = "A bowl carved out of opal."
	icon_state = "bowl_opal"
	sellprice = 85

/obj/item/reagent_containers/glass/bowl/update_icon()
	cut_overlays()
	if(reagents)
		if(reagents.total_volume > 0)
			if(reagents.total_volume <= 11)
				var/mutable_appearance/filling = mutable_appearance(icon, "bowl_low")
				filling.color = mix_color_from_reagents(reagents.reagent_list)
				add_overlay(filling)
		if(reagents.total_volume > 11)
			if(reagents.total_volume <= 22)
				var/mutable_appearance/filling = mutable_appearance(icon, "bowl_half")
				filling.color = mix_color_from_reagents(reagents.reagent_list)
				add_overlay(filling)
		if(reagents.total_volume > 22)
			if(reagents.has_reagent(/datum/reagent/consumable/soup/porridge/oatmeal, 10))
				var/mutable_appearance/filling = mutable_appearance(icon, "bowl_oatmeal")
				filling.color = mix_color_from_reagents(reagents.reagent_list)
				add_overlay(filling)
			if(reagents.has_reagent(/datum/reagent/consumable/soup/stew/chicken, 17) || reagents.has_reagent(/datum/reagent/consumable/soup/stew/meat, 17) || reagents.has_reagent(/datum/reagent/consumable/soup/stew/fish, 17 || reagents.has_reagent(/datum/reagent/consumable/soup/stew/rabbit, 17)))
				var/mutable_appearance/filling = mutable_appearance(icon, "bowl_stew")
				filling.color = mix_color_from_reagents(reagents.reagent_list)
				add_overlay(filling)
			else
				var/mutable_appearance/filling = mutable_appearance(icon, "bowl_full")
				filling.color = mix_color_from_reagents(reagents.reagent_list)
				add_overlay(filling)
	else
		icon_state = "bowl"

/obj/item/reagent_containers/glass/bowl/on_reagent_change(changetype)
	..()
	update_icon()

/obj/item/reagent_containers/glass/bowl/attackby(obj/item/I, mob/user, params) // lets you eat with a spoon from a bowl
	. = ..()
	if(istype(I, /obj/item/kitchen/spoon))
		if(reagents.total_volume > 0)
			if(do_after(user, 1 SECONDS, target = src))
				playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
				visible_message(span_info("[user] eats from [src]."))
				addtimer(CALLBACK(reagents, TYPE_PROC_REF(/datum/reagents, trans_to), user, min(amount_per_transfer_from_this,5), TRUE, TRUE, FALSE, user, FALSE, INGEST), 5)
		return TRUE
