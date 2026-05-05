/obj/machinery/anvil
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "iron anvil"
	desc = "Its surface is marred by countless hammer strikes."
	icon_state = "anvil"
	var/hott = null
	var/obj/item/ingot/hingot
	max_integrity = 500
	density = TRUE
	damage_deflection = 25
	climbable = TRUE
	pass_flags_self = LETPASSTHROW
	var/previous_material_quality = 0
	var/advance_multiplier = 1 //Lower for auto-striking

/obj/machinery/anvil/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Ingots, when held in a pair of tongs and heated at a forge, can be placed onto the anvil via left-clicking.")
	. += span_info("Once on the anvil, left-clicking the ingot with a hammer allows for you to start pounding it into a recipe of your choice.")
	. += span_info("Smithing armor uses the Armorsmithing skill, smithing weapons uses the Weaponsmithing skill, and smithing everything else - valuables, cutlery, tools - uses the Blacksmithing skill.")
	. += span_info("If you attempt to smith a recipe that excedes your current skill's level, you'll run the risk of damaging and destroying the ingot-in-question.")
	. += span_info("Once the recipe has been smithed to completion, pick the finished ingot back up and reheat it before quenching it in a water-filled washbin. This transforms the ingot into the smithed item.")
	. += span_info("Armor, weapons, and other repairable items can be placed onto the anvil via left-clicking. Repairing items on an anvil is quicker and safer than repairing them on a table.")

/obj/machinery/anvil/crafted
	icon_state = "caveanvil"

/obj/machinery/anvil/examine(mob/user)
	. = ..()
	if(hingot && hott)
		. += span_warning("[hingot] is too hot to touch.")

/obj/machinery/anvil/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/rogueweapon/tongs))
		var/obj/item/rogueweapon/tongs/T = W
		if(hingot)
			if(T.hingot)
				if(hingot.currecipe && hingot.currecipe.needed_item && istype(T.hingot, hingot.currecipe.needed_item))
					hingot.currecipe.item_added(user)
					if(istype(T.hingot, /obj/item/ingot))
						var/obj/item/ingot/I = T.hingot
						hingot.currecipe.material_quality += I.quality
						previous_material_quality = I.quality
					else
						hingot.currecipe.material_quality += previous_material_quality
					hingot.currecipe.num_of_materials += 1
					qdel(T.hingot)
					T.hingot = null
					T.update_icon()
					update_icon()
					return
				return
			else
				if(T.hingot)
					to_chat(user, span_warning("You're already holding something with your tongs!"))
					return
				hingot.forceMove(T)
				T.hingot = hingot
				hingot = null
				T.update_icon()
				update_icon()
				return
		else
			if(T.hingot && istype(T.hingot, /obj/item/ingot))
				// if the held ingot was deleted/qdeling somehow, just clear state
				if(QDELETED(T.hingot) || QDELING(T.hingot))
					T.hingot = null
					T.hott = null
					T.update_icon()
					return

				T.hingot.forceMove(src)
				hingot = T.hingot
				T.hingot = null
				hott = T.hott
				if(hott)
					START_PROCESSING(SSmachines, src)
				T.update_icon()
				update_icon()
				return

	if(istype(W, /obj/item/ingot))
		if(!hingot)
			W.forceMove(src)
			hingot = W
			hott = null
			update_icon()
			return

	if(istype(W, /obj/item/rogueweapon/hammer))
		user.changeNext_move(CLICK_CD_FAST)
		var/obj/item/rogueweapon/hammer/hammer = W
		if(!hingot)
			return
		if(!hingot.currecipe)
			ui_interact(user)
			return
		advance_multiplier = 1
		user.doing = FALSE
		spawn(1)
			while(hingot)
				if(!hott)
					to_chat(user, span_warning("It's too cold."))
					return
				if(!hingot.currecipe)
					return
				var/used_str = user.STASTR
				if(iscarbon(user))
					var/mob/living/carbon/carbon_user = user
					if(carbon_user.domhand)
						used_str = carbon_user.get_str_arms(carbon_user.used_hand)
					if(HAS_TRAIT(carbon_user, TRAIT_FORGEBLESSED))
						carbon_user.stamina_add(max(21 - (used_str * 3), 0)*advance_multiplier)
					else
						carbon_user.stamina_add(max(40 - (used_str * 3), 0)*advance_multiplier)
				var/total_chance = 7 * user.get_skill_level(hingot.currecipe.appro_skill) * user.STAPER/10 * hammer.quality
				var/breakthrough = 0
				if(prob((1 + total_chance)*advance_multiplier))
					user.flash_fullscreen("whiteflash")
					var/datum/effect_system/spark_spread/S = new()
					var/turf/front = get_turf(src)
					S.set_up(1, 1, front)
					S.start()
					breakthrough = 1
					hingot.currecipe.numberofbreakthroughs++

				if(!hingot.currecipe.advance(user, breakthrough, advance_multiplier, src))
					shake_camera(user, 1, 1)
					playsound(src,'sound/items/bsmithfail.ogg', 100, FALSE)
					break
				playsound(src,pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)
				if(do_after(user, 20, target = src))
					advance_multiplier = 0.50
				else
					break
		return

	if(hingot && hingot.currecipe && hingot.currecipe.needed_item && istype(W, hingot.currecipe.needed_item))
		hingot.currecipe.item_added(user)
		if(istype(W, /obj/item/ingot))
			var/obj/item/ingot/I = W
			hingot.currecipe.material_quality += I.quality
			previous_material_quality = I.quality
		else
			hingot.currecipe.material_quality += previous_material_quality
		hingot.currecipe.num_of_materials += 1
		qdel(W)
		return

	if(W.anvilrepair)
		user.visible_message(span_info("[user] places [W] on the anvil."))
		W.forceMove(src.loc)
		return

	if(!user.cmode)
		W.forceMove(src.loc)
		return

	..()

/obj/machinery/anvil/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Anvil", "Anvil")
		ui.open()

/obj/machinery/anvil/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/anvil_recipes)
	)

/obj/machinery/anvil/ui_data(mob/user)
	var/list/data = ..()

	data["hingot_type"] = hingot?.type

	return data

/obj/machinery/anvil/ui_static_data(mob/user)
	var/list/data = ..()

	var/list/recipes = list()

	var/datum/asset/spritesheet/spritesheet = get_asset_datum(/datum/asset/spritesheet/anvil_recipes)

	for(var/datum/anvil_recipe/R in GLOB.anvil_recipes)
		UNTYPED_LIST_ADD(recipes, list(
			"name" = R.name,
			"category" = R.i_type,
			"req_bar" = R.req_bar,
			"ref" = REF(R),
			"icon" = spritesheet.icon_class_name(sanitize_css_class_name("recipe_[REF(R)]"))
		))

	data["recipes"] = recipes

	return data

/obj/machinery/anvil/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("choose_recipe")
			var/datum/anvil_recipe/recipe = locate(params["ref"])
			if(!istype(recipe))
				return TRUE

			if(!istype(hingot, recipe.req_bar))
				return TRUE

			var/smith_exp = user.get_skill_level(recipe.appro_skill)
			if(smith_exp < recipe.craftdiff)
				if(alert(user, "This recipe needs [SSskills.level_names_plain[recipe.craftdiff]] skill.","IT'S TOO DIFFICULT!","CONFIRM","CANCEL") != "CONFIRM")
					return TRUE

			// Half to check this again because we alert()ed
			if(!istype(hingot, recipe.req_bar))
				return TRUE

			hingot.currecipe = new recipe.type(hingot)
			hingot.currecipe.bar_health = 50 * (hingot.quality+1)
			hingot.currecipe.max_progress = 100
			hingot.currecipe.material_quality += hingot.quality
			previous_material_quality = hingot.quality
			ui.close()
			var/obj/item/rogueweapon/hammer/hammer = user.get_active_held_item()
			if(istype(hammer))
				attackby(hammer, user)
			return TRUE

/obj/machinery/anvil/attack_hand(mob/user, params)
	if(hingot)
		if(hott)
			to_chat(user, span_warning("It's too hot."))
			return
		else
			var/obj/item/I = hingot
			hingot = null
			I.forceMove(user.loc)
			user.put_in_active_hand(I)
			update_icon()

/obj/machinery/anvil/process()
	if(hott)
		if(world.time > hott + 20 SECONDS)
			hott = null
			STOP_PROCESSING(SSmachines, src)
	else
		STOP_PROCESSING(SSmachines, src)
	update_icon()

/obj/machinery/anvil/update_icon()
	cut_overlays()
	if(hingot)
		var/obj/item/I = hingot
		I.pixel_x = 0
		I.pixel_y = 0
		var/mutable_appearance/M = new /mutable_appearance(I)
		if(hott)
			M.filters += filter(type="color", color = list(3,0,0,1, 0,2.7,0,0.4, 0,0,1,0, 0,0,0,1))
		M.transform *= 0.5
		M.pixel_y = 5
		M.pixel_x = 3
		add_overlay(M)

/obj/machinery/anvil/bronze
	name = "bronze anvil"
	desc = "Elevating humenity from its primordial stupor since the earliest daes of Psydonia."
	icon_state = "broanvil"
	max_integrity = 400
