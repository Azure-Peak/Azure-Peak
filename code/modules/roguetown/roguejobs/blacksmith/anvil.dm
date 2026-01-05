
/obj/machinery/anvil
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "iron anvil"
	desc = "It's surface is marred by countless hammer strikes."
	icon_state = "anvil"
	var/hott = null
	var/obj/item/current_workpiece
	max_integrity = 500
	density = TRUE
	damage_deflection = 25
	climbable = TRUE
	//interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	var/previous_material_quality = 0
	var/advance_multiplier = 1 // Lower for auto striking

/obj/machinery/anvil/crafted
	icon_state = "caveanvil"

/obj/machinery/anvil/examine(mob/user)
	. = ..()
	if(current_workpiece && hott)
		. += span_warning("[current_workpiece] is too hot to touch.")

/obj/machinery/anvil/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/rogueweapon/tongs))
		var/obj/item/rogueweapon/tongs/T = W
		if(current_workpiece)
			// Handle adding items to forging with tongs
			var/datum/component/forging/forging_comp = current_workpiece.GetComponent(/datum/component/forging)
			if(forging_comp?.needed_item && T.hingot && istype(T.hingot, forging_comp.needed_item))
				var/obj/item/consumed = T.hingot
				SEND_SIGNAL(current_workpiece, COMSIG_ITEM_ADDED_TO_FORGING, consumed, user)
				if(istype(consumed, /obj/item/ingot))
					var/obj/item/ingot/I = consumed
					forging_comp.material_quality += I.quality
					previous_material_quality = I.quality
				else
					forging_comp.material_quality += previous_material_quality
				forging_comp.current_recipe.num_of_materials += 1
				T.hingot = null
				qdel(consumed)
				T.update_icon()
				update_icon()
				return

			// Pick up ingot with tongs
			if(istype(current_workpiece, /obj/item/ingot))
				if(T.hingot)
					to_chat(user, span_warning("You're already holding something with your tongs!"))
					return
				current_workpiece.forceMove(T)
				T.hingot = current_workpiece
				T.hott = hott // Transfer heat state
				SEND_SIGNAL(current_workpiece, COMSIG_ITEM_REMOVED_FROM_ANVIL, src)
				current_workpiece = null
				hott = null
				T.update_icon()
				update_icon()
				return
		else
			// Place ingot from tongs onto anvil
			if(T.hingot && istype(T.hingot, /obj/item/ingot))
				T.hingot.forceMove(src)
				current_workpiece = T.hingot
				hott = T.hott
				SEND_SIGNAL(current_workpiece, COMSIG_ITEM_PLACED_ON_ANVIL, src)
				T.hingot = null
				T.hott = null
				if(hott)
					START_PROCESSING(SSmachines, src)
				T.update_icon()
				update_icon()
				return

	// Allow both ingots and blades to be placed on the anvil by hand
	if(istype(W, /obj/item/ingot) || istype(W, /obj/item/blade))
		if(!current_workpiece)
			W.forceMove(src)
			current_workpiece = W
			SEND_SIGNAL(current_workpiece, COMSIG_ITEM_PLACED_ON_ANVIL, src)
			// Only ingots can be hot, blades are always cold
			if(istype(W, /obj/item/ingot))
				hott = null
			else
				hott = null
			update_icon()
			return

	if(istype(W, /obj/item/rogueweapon/hammer))
		user.changeNext_move(CLICK_CD_FAST)
		var/obj/item/rogueweapon/hammer/hammer = W
		if(!current_workpiece)
			return

		var/datum/component/forging/forging_comp = current_workpiece.GetComponent(/datum/component/forging)
		if(!forging_comp)
			ui_interact(user)
			return

		advance_multiplier = 1
		user.doing = FALSE
		spawn(1)
			while(current_workpiece && forging_comp?.forging_stage == FORGING_STAGE_ACTIVE)
				// Blades don't need to be hot, only check for ingots
				if(!hott && istype(current_workpiece, /obj/item/ingot))
					to_chat(user, span_warning("It's too cold."))
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

				var/total_chance = 7 * user.get_skill_level(forging_comp.current_recipe.appro_skill) * user.STAPER/10 * hammer.quality
				var/breakthrough = 0
				if(prob((1 + total_chance)*advance_multiplier))
					user.flash_fullscreen("whiteflash")
					var/datum/effect_system/spark_spread/S = new()
					var/turf/front = get_turf(src)
					S.set_up(1, 1, front)
					S.start()
					breakthrough = 1
					forging_comp.numberofbreakthroughs++

				// Send hammer signal to the workpiece
				SEND_SIGNAL(current_workpiece, COMSIG_ITEM_HAMMERED_ON_ANVIL, src, user, hammer, breakthrough)

				playsound(src,pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)
				if(do_after(user, 20, target = src))
					advance_multiplier = 0.50
				else
					break
		return

	// Handle adding materials to current forging
	if(current_workpiece)
		var/datum/component/forging/forging_comp = current_workpiece.GetComponent(/datum/component/forging)
		if(forging_comp?.needed_item && istype(W, forging_comp.needed_item))
			SEND_SIGNAL(current_workpiece, COMSIG_ITEM_ADDED_TO_FORGING, W, user)
			if(istype(W, /obj/item/ingot))
				var/obj/item/ingot/I = W
				forging_comp.material_quality += I.quality
				previous_material_quality = I.quality
			else
				forging_comp.material_quality += previous_material_quality
			forging_comp.current_recipe.num_of_materials += 1
			if(user?.is_holding(W))
				user.temporarilyRemoveItemFromInventory(W, TRUE)
			qdel(W)
			return

	if(W.anvilrepair)
		user.visible_message(span_info("[user] places [W] on the anvil."))
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
	data["hingot_type"] = current_workpiece?.type
	return data

/obj/machinery/anvil/ui_static_data(mob/user)
	var/list/data = ..()
	var/list/recipes = list()
	var/datum/asset/spritesheet/spritesheet = get_asset_datum(/datum/asset/spritesheet/anvil_recipes)

	for(var/datum/anvil_recipe/R in GLOB.anvil_recipes)
		var/valid_recipe = FALSE

		if(current_workpiece)
			if((R.req_bar && istype(current_workpiece, R.req_bar)) || (R.req_blade && istype(current_workpiece, R.req_blade)))
				valid_recipe = TRUE
		if(!current_workpiece || valid_recipe || (!R.req_bar && !R.req_blade))
			UNTYPED_LIST_ADD(recipes, list(
				"name" = R.name,
				"category" = R.i_type,
				"req_bar" = R.req_bar,
				"req_blade" = R.req_blade,
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
			var/has_required_item = FALSE

			// Check both bar and blade requirements
			if(recipe.req_bar && istype(current_workpiece, recipe.req_bar))
				has_required_item = TRUE
			if(recipe.req_blade && istype(current_workpiece, recipe.req_blade))
				has_required_item = TRUE

			if(!has_required_item)
				return TRUE

			var/smith_exp = user.get_skill_level(recipe.appro_skill)
			if(smith_exp < recipe.craftdiff)
				if(alert(user, "This recipe needs [SSskills.level_names_plain[recipe.craftdiff]] skill.","IT'S TOO DIFFICULT!","CONFIRM","CANCEL") != "CONFIRM")
					return TRUE

			// Half to check this again because we alert()ed
			if(!has_required_item)
				return TRUE

			// Add forging component to the workpiece
			var/datum/component/forging/existing_forging = current_workpiece.GetComponent(/datum/component/forging)
			var/recipe_reset = FALSE
			if(existing_forging)
				if(alert(user, "This item already has an active recipe ([existing_forging.current_recipe.name]). Change to [recipe.name]?","CHANGE RECIPE?","CONFIRM","CANCEL") != "CONFIRM")
					return TRUE

				// Remove existing forging component and any quenchable components
				qdel(existing_forging)
				var/datum/component/anvil_quenchable/existing_quench = current_workpiece.GetComponent(/datum/component/anvil_quenchable)
				if(existing_quench)
					qdel(existing_quench)
				recipe_reset = TRUE

			// Add forging component to the workpiece
			if(!existing_forging || recipe_reset)
				var/datum/component/forging/forging_comp = current_workpiece.AddComponent(/datum/component/forging, recipe.type)

				var/quality_value = 1
				if(istype(current_workpiece, /obj/item/ingot))
					var/obj/item/ingot/ingot_ref = current_workpiece
					quality_value = ingot_ref.quality
				else if(istype(current_workpiece, /obj/item/blade))
					var/obj/item/blade/blade_ref = current_workpiece
					quality_value = blade_ref.quality

				forging_comp.bar_health = 50 * (quality_value + 1)
				forging_comp.material_quality += quality_value
				previous_material_quality = quality_value

			ui.close()

			// if we have a hammer in our hand, start working immediately
			var/obj/item/rogueweapon/hammer/hammer = usr.get_active_held_item()
			if(istype(hammer))
				attackby(hammer, user)

			return TRUE

/obj/machinery/anvil/attack_hand(mob/user, params)
	if(current_workpiece)
		// Blades are never hot, so only check hott for ingots
		if(hott && istype(current_workpiece, /obj/item/ingot))
			to_chat(user, span_warning("It's too hot."))
			return
		else
			var/obj/item/I = current_workpiece
			SEND_SIGNAL(current_workpiece, COMSIG_ITEM_REMOVED_FROM_ANVIL, src)
			current_workpiece = null
			hott = null
			I.forceMove(user.loc)
			user.put_in_active_hand(I)
			update_icon()

/obj/machinery/anvil/MiddleClick(mob/user, params)
	. = ..()
	//currecipe = null

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
	if(current_workpiece)
		var/obj/item/I = current_workpiece
		I.pixel_x = 0
		I.pixel_y = 0
		var/mutable_appearance/M = new /mutable_appearance(I)
		if(hott)
			M.filters += filter(type="color", color = list(3,0,0,1, 0,2.7,0,0.4, 0,0,1,0, 0,0,0,1))
		M.transform *= 0.5
		M.pixel_y = 5
		M.pixel_x = 3
		add_overlay(M)
