/obj/item/natural/shellplant
	name = "shellplant"
	desc = "You shouldn't be seeing this."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = ""
	grid_height = 32
	grid_width = 32
	var/foodamt = 1 //how much food can be extracted
	var/foodextracted = null //the food item to extract from the plant
	var/seed = null
	var/shell = null

// ======== PUMPKINS ========
/obj/item/natural/shellplant/pumpkin
	name = "pumpkin"
	desc = "The thick pumpkin rind shields a surprisingly dense fleshy interior."
	icon_state = "pumpkin"
	grid_width = 64
	grid_height = 32
	w_class = WEIGHT_CLASS_NORMAL
	foodamt = 6
	foodextracted = /obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced
	seed = /obj/item/seeds/pumpkin
	shell = /obj/item/pumpkinshell
	var/open = FALSE

/obj/item/natural/shellplant/pumpkin/examine(mob/user)
	. = ..()
	
	if(open)
		. += span_smallnotice("It is open and I could use a spoon to extract its flesh.")
		. += span_smallnotice("It has [foodamt] chunks remaining.")
	else
		. += span_smallnotice("I could cut it open to reach inside, chop it into slices or squash it for seeds.")

/obj/item/natural/shellplant/pumpkin/attackby(obj/item/I, mob/living/user, params)
	if((user.used_intent.blade_class == BCLASS_CUT) && (I.wlength == WLENGTH_SHORT) && (!user.used_intent.noaa))
		if(!open)
			if(do_after(user, 0.5 SECONDS))
				playsound(get_turf(user), 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1)
				icon_state = "pumpkin-open"
				open = TRUE
				return
		return
	if((user.used_intent.blade_class == BCLASS_CHOP) && (!user.used_intent.noaa))
		if(do_after(user, 0.5 SECONDS))
			playsound(get_turf(user), 'modular/Neu_Food/sound/chopping_block.ogg', 60, TRUE, -1)
			while(foodamt-- > 0)
				new foodextracted(get_turf(loc))
			qdel(src)
			return
	if((user.used_intent.blade_class == BCLASS_BLUNT) && (!user.used_intent.noaa))
		if(seed)
			playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			if(prob(5))
				user.visible_message(span_warning("[user] fails to extract the seeds."))
			else
				new seed(get_turf(loc))
				if(prob(90))
					new seed(get_turf(loc))
				if(prob(23))
					new seed(get_turf(loc))
				if(prob(6))
					new seed(get_turf(loc))
		qdel(src)
		return
	if(istype(I, /obj/item/kitchen/spoon) && open)
		if(do_after(user, 0.5 SECONDS))
			if(foodextracted)
				new foodextracted(get_turf(loc))
				foodamt--
				user.visible_message(span_notice("[user] carves out the [src]'s plant flesh."), \
							span_notice("I carve out the [src]'s flesh."))
			if(foodamt <= 0)
				if(shell)
					new shell(get_turf(loc))
				if(seed)
					playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
					if(prob(5))
						user.visible_message(span_warning("[user] fails to extract the seeds."))
					else
						new seed(get_turf(loc))
						if(prob(90))
							new seed(get_turf(loc))
						if(prob(23))
							new seed(get_turf(loc))
						if(prob(6))
							new seed(get_turf(loc))
				qdel(src)
		return
	return

/obj/item/pumpkinshell
	name = "pumpkin shell"
	desc = "The emptied shell of a pumpkin, without its flesh and seeds."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "pumpkinshell"
	grid_width = 64
	grid_height = 32
	w_class = WEIGHT_CLASS_SMALL

/obj/item/pumpkinshell/examine(mob/user)
	. = ..()
	. += span_smallnotice("Using a small blade, I could stab or cut it into a variety of decorations.")

/obj/item/pumpkinshell/attackby(obj/item/I, mob/living/user, params)
	if((user.used_intent.blade_class == BCLASS_CUT || user.used_intent.blade_class == BCLASS_STAB) && (I.wlength == WLENGTH_SHORT) && (!user.used_intent.noaa))
		ui_interact(user)
		return

// -------- TGUI implementation! --------
/obj/item/pumpkinshell/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Carving", "Carving")
		ui.open()

/obj/item/pumpkinshell/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/pumpkin_carvings)
	)

/obj/item/pumpkinshell/ui_static_data(mob/user)
	var/list/data = ..()

	var/list/carvings = list()
	var/datum/asset/spritesheet/spritesheet = get_asset_datum(/datum/asset/spritesheet/pumpkin_carvings)

	for(var/obj/item/flashlight/flare/torch/lantern/pumpkin/P as anything in typesof(/obj/item/flashlight/flare/torch/lantern/pumpkin))
		UNTYPED_LIST_ADD(carvings, list(
			"name" = P.name,
			"ref" = REF(P),
			"icon" = spritesheet.icon_class_name(sanitize_css_class_name("carving_[REF(P)]"))
		))
	data["carvings"] = carvings
	return data

/obj/item/pumpkinshell/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("choose_carving")
			var/obj/item/flashlight/flare/torch/lantern/pumpkin/P = locate(params["ref"])
			var/mob/user = ui.user
			if(!P)
				return TRUE

			user.visible_message(span_notice("[user] begins to carve a [P.name]."), \
							span_notice("I begin carving a [P.name]."))
			if(do_after(user, 2 SECONDS))
				playsound(get_turf(user), 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1)
				new P(get_turf(loc))

			ui.close()
			qdel(src)
			return TRUE