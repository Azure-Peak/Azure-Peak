/obj/item/reagent_containers/glass/bucket/pot
	force = 10
	name = "pot"
	desc = "A pot made out of iron. It can hold a lot of liquid."
	icon = 'modular/Neu_Food/icons/cookware/pot.dmi'
	//lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	//righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = TRUE
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

/obj/item/reagent_containers/glass/bucket/pot/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Pots can be placed atop a hearth by left-clicking it. If the hearth is lit, the placed pot will eventually come to a boil - so long as it's filled with water.")
	. += span_info("Right-clicking a hearthbound pot allows you to fan its flames, further reducing the time it'll take to start boiling.")
	. += span_info("Once boiling, left-clicking the hearthbound pot with an ingredient will drop it inside. The larger a pot is, the more ingredients can be dropped in at any given time.")
	. += span_info("After the first ingredient is placed in, the pot will begin turning it - and any other subsequent ingredients - into a brew, over the course of a minute.")
	. += span_info("Specific ingredients can create specific brews; dried rosa petals for a refreshing tea, coffee beans for a revitalizing drink, and more..")

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

/obj/item/reagent_containers/glass/bucket/pot/teapot/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -4,"wy" = -4,"ex" = 2,"ey" = -4,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/reagent_containers/glass/bucket/pot/carved
	name = "carved teapot"
	desc = "You shouldn't be seeing this."
	icon_state = "teapot"
	fill_icon_thresholds = null
	dropshrink = 1.0
	volume = 99
	sellprice = 0

/obj/item/reagent_containers/glass/bucket/pot/carved/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -4,"wy" = -4,"ex" = 2,"ey" = -4,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotjade
	name = "jade teapot"
	desc = "A dainty teapot carved out of jade."
	icon_state = "teapot_jade"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 60

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotamber
	name = "amber teapot"
	desc = "A dainty teapot carved out of amber."
	icon_state = "teapot_amber"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 60

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotshell
	name = "shell teapot"
	desc = "A dainty teapot carved out of shell."
	icon_state = "teapot_shell"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 20

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotrose
	name = "rosestone teapot"
	desc = "A dainty teapot carved out of rosestone."
	icon_state = "teapot_rose"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 25

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotopal
	name = "opal teapot"
	desc = "A dainty teapot carved out of opal."
	icon_state = "teapot_opal"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 90

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotonyxa
	name = "onyxa teapot"
	desc = "A dainty teapot carved out of onyxa."
	icon_state = "teapot_onyxa"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 40

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotcoral
	name = "heartstone teapot"
	desc = "A dainty teapot carved out of heartstone."
	icon_state = "teapot_coral"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 70

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotturq
	name = "cerulite teapot"
	desc = "A dainty teapot carved out of cerulite."
	icon_state = "teapot_turq"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 85

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

/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard
	name = "tankard"
	desc = "A heftsome, iron-bottomed mug. It can be set upon a hearth to brew traditional drinks, or - for the more alcoholically-inclined - used as a pitcher of liqour."
	icon = 'modular/Neu_Food/icons/cookware/unused.dmi'
	icon_state = "stein"
	volume = 50
	sellprice = 10
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/silver
	name = "silver tankard"
	desc = "A regal, silver-bottomed mug with gilded marginalia. Perfect for refilling mugs-a-plenty during the chaos of an innhouse's feast, or for drowning away the sorrows of a sorrid week. It can be set upon a hearth to brew traditional drinks."
	icon = 'modular/Neu_Food/icons/cookware/unused.dmi'
	icon_state = "silverstein"
	volume = 75
	sellprice = 40
	force = 15
	throwforce = 20

/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/blacksteel
	name = "blacksteel tankard"
	desc = "A mythical, blacksteel-bottomed mug with a mastercrafted handle. Fit for the bloodied knuckles of a dungeon-delving hero, or the nitestand of a drunkhearted king. It can be set upon a hearth to brew traditional drinks, or smelted within a furnace to birth an ingot of blacksteel."
	icon = 'modular/Neu_Food/icons/cookware/unused.dmi'
	icon_state = "blacksteelstein"
	volume = 100
	sellprice = 100
	force = 20
	throwforce = 25
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -4,"wy" = -4,"ex" = 2,"ey" = -4,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/update_icon(dont_fill=FALSE)
	return FALSE // Ditto.
