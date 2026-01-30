/obj/item/reagent_containers/glass/bucket/pot
	force = 10
	name = "pot"
	desc = "A pot made out of iron. It can hold a lot of liquid."
	icon = 'modular/Neu_Food/icons/cookware/pot.dmi'
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	icon_state = "pote"
	sharpness = IS_BLUNT
	slot_flags = null
	item_state = "pot"
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'
	w_class = WEIGHT_CLASS_BULKY
	reagent_flags = OPENCONTAINER
	throwforce = 10
	dropshrink = 1 // Override for bucket
	volume = 240

/obj/item/reagent_containers/glass/bucket/pot/update_icon()
	cut_overlays()
	if(reagents.total_volume > 0)
		if(reagents.total_volume <= 50)
			var/mutable_appearance/filling = mutable_appearance(icon, "pote_half")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)

		if(reagents.total_volume > 50)
			var/mutable_appearance/filling = mutable_appearance(icon, "pote_full")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)


/obj/item/reagent_containers/glass/bucket/pot/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bowl))
		to_chat(user, "<span class='notice'>Filling the bowl...</span>")
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 70, FALSE)
		if(do_after(user,2 SECONDS, target = src))
			reagents.trans_to(I, reagents.total_volume)
	return TRUE

/obj/item/reagent_containers/glass/bucket/pot/aalloy
	name = "decrepit pot"
	desc = "A kettle of wrought bronze. One could only imagine what the stews of millenia prior must've tasted like; do you suppose they knew of seasonings-and-spices, too?"
	icon_state = "apote"
	volume = 120
	color = "#bb9696"
	sellprice = 25

/obj/item/reagent_containers/glass/bucket/pot/stone
	name = "stone pot"
	desc = "A pot made out of stone. It can hold less than a metal pot."
	volume = 120 // 99 is the max volume for a stone pot

/obj/item/reagent_containers/glass/bucket/pot/kettle
	name = "kettle"
	desc = "A kettle made out of iron. It is portable."
	icon_state = "kettle"
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 64
	volume = 120

/obj/item/reagent_containers/glass/bucket/pot/copper
	name = "copper pot"
	desc = "A pot made out of copper. It can hold a lot of liquid."
	icon_state = "pote_copper"

/obj/item/reagent_containers/glass/bucket/pot/bronze
	name = "bronze pot"
	desc = "A cauldron of bronze, aching to churn water and chopmealings into a champion's broth. It can hold a lot of liquid."
	icon_state = "bronzepot"

/obj/item/reagent_containers/glass/bucket/pot/teapot
	name = "teapot"
	desc = "A teapot made out of ceramic. Used to serve tea, it can hold a lot of liquid. It can still spill, however."
	dropshrink = 0.7
	icon_state = "teapot"
	volume = 120
	sellprice = 20

/obj/item/reagent_containers/glass/bucket/pot/teapot/examine()
	. = ..()
	. += span_info("It can be brushed with a dye brush to glaze it.")

/obj/item/reagent_containers/glass/bucket/pot/teapot/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		if(reagents.total_volume)
			to_chat(user, span_notice("I can't glaze the teapot while it has liquid in it."))
			return
		if(do_after(user, 3 SECONDS, target = src))
			to_chat(user, span_notice("I glaze the teapot with the dye brush."))
			new /obj/item/reagent_containers/glass/bucket/pot/teapot/fancy(get_turf(src))
			qdel(src)
		return
	. = ..()

/obj/item/reagent_containers/glass/bucket/pot/teapot/fancy
	icon_state = "teapot_fancy"
	sellprice = 24

/obj/item/reagent_containers/glass/bucket/pot/teapot/update_icon(dont_fill=FALSE)
	return FALSE // There's no filling for teapot
