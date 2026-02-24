/datum/component/personal_crafting/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/L = parent
	L.craftingthing = src
//	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(create_mob_button))
/*
/datum/component/personal_crafting/proc/create_mob_button(mob/user, client/CL)
	var/datum/hud/H = user.hud_used
	var/atom/movable/screen/craft/C = new()
	C.icon = H.ui_style
	H.static_inventory += C
	CL.screen += C
	RegisterSignal(C, COMSIG_CLICK, PROC_REF(roguecraft))
*/
/datum/component/personal_crafting
	var/busy
	var/viewing_category = 1 //typical powergamer starting on the Weapons tab
	var/viewing_subcategory = 1
	var/list/categories = list(
				CAT_NONE = CAT_NONE,
			)

	var/cur_category = CAT_NONE
	var/cur_subcategory = CAT_NONE
	var/datum/action/innate/crafting/button
	var/display_craftable_only = TRUE
	var/display_compact = TRUE
	var/showonlycraftable = TRUE



/*	This is what procs do:
	get_environment - gets a list of things accessable for crafting by user
	get_surroundings - takes a list of things and makes a list of key-types to values-amounts of said type in the list
	check_contents - takes a recipe and a key-type list and checks if said recipe can be done with available stuff
	check_tools - takes recipe, a key-type list, and a user and checks if there are enough tools to do the stuff, checks bugs one level deep
	construct_item - takes a recipe and a user, call all the checking procs, calls do_after,
	checks all the things again, calls del_reqs, creates result,
	calls CheckParts of said result with argument being list returned by del_reqs
	del_reqs - takes recipe and a user, loops over the recipes reqs var and tries to find everything in the list make by get_environment and delete it/add to parts list, then returns the said list
*/




/datum/component/personal_crafting/proc/check_contents(datum/crafting_recipe/R, list/contents)
	contents = contents["other"]
	main_loop:
		for(var/A in R.reqs)
			var/needed_amount = R.reqs[A]
			for(var/B in contents)
				if(ispath(B, A))
					if(!R.subtype_reqs && (B in subtypesof(A)))
						continue
					if (R.blacklist.Find(B))

						continue
					if(contents[B] >= R.reqs[A])
						continue main_loop
					else

						needed_amount -= contents[B]
						if(needed_amount <= 0)
							continue main_loop
						else
							continue
			return FALSE
	for(var/A in R.chem_catalysts)
		if(contents[A] < R.chem_catalysts[A])
			return FALSE
	return TRUE

/datum/component/personal_crafting/proc/get_environment(mob/user)
	. = list()
	for(var/obj/item/I in user.held_items)
		. += I
	if(!isturf(user.loc))
		return
	var/list/L = block(get_step(user, SOUTHWEST), get_step(user, NORTHEAST))
	for(var/A in L)
		var/turf/T = A
		if(T.Adjacent(user))
			for(var/B in T)
				var/atom/movable/AM = B
				if(AM.flags_1 & HOLOGRAM_1)
					continue
				. += AM
				var/list/crafting_items = AM.get_crafting_contents()
				if(crafting_items)
					for(var/atom/movable/crafting_item as anything in crafting_items)
						. += crafting_item
	for(var/slot in list(SLOT_R_STORE, SLOT_L_STORE))
		. += user.get_item_by_slot(slot)

/obj/item/proc/can_craft_with()
	if(craft_blocked)
		return FALSE
	if(istype(src, /obj/item/storage/roguebag) && src.contents.len > 0) //for bait bags
		return FALSE
	return TRUE

/datum/component/personal_crafting/proc/get_surroundings(mob/user)
	. = list()
	.["tool_behaviour"] = list()
	.["other"] = list()
	for(var/obj/item/I in get_environment(user))
		if(!I.can_craft_with())
			continue
		if(I.flags_1 & HOLOGRAM_1)
			continue
		else if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			.["other"][B.stacktype] += B.amount
		else if(istype(I, /obj/item/construction/bundle))
			var/obj/item/construction/bundle/B = I
			.["other"][B.stacktype] += B.amount
		else if(I.tool_behaviour)
			.["tool_behaviour"] += I.tool_behaviour
			.["other"][I.type] += 1
		else
			if(istype(I, /obj/item/reagent_containers))
				var/obj/item/reagent_containers/RC = I
				if(RC.is_drainable())
					for(var/datum/reagent/A in RC.reagents.reagent_list)
						.["other"][A.type] += A.volume
				if(istype(RC, /obj/item/reagent_containers/glass)) // Only count glass bottles themselves as a valid crafting item if it's empty
					if(RC.reagents.total_volume == 0)
						.["other"][I.type] += 1
				else
					.["other"][I.type] += 1
			else
				.["other"][I.type] += 1

/datum/component/personal_crafting/proc/check_tools(mob/user, datum/crafting_recipe/R, list/contents)
	if(!R.tools.len)
		return TRUE
	var/list/possible_tools = list()
	var/list/present_qualities = list()
	present_qualities |= contents["tool_behaviour"]
	for(var/obj/item/I in user.contents)
		if(istype(I, /obj/item/storage))
			for(var/obj/item/SI in I.contents)
				possible_tools += SI.type
				if(SI.tool_behaviour)
					present_qualities.Add(SI.tool_behaviour)

		possible_tools += I.type

		if(I.tool_behaviour)
			present_qualities.Add(I.tool_behaviour)

	possible_tools |= contents["other"]

	main_loop:
		for(var/A in R.tools)
			if(A in present_qualities)
				continue
			else
				for(var/I in possible_tools)
					if(ispath(I, A))
						continue main_loop
			return FALSE
	return TRUE

/atom/proc/OnCrafted(dirin, mob/user)
	SEND_SIGNAL(user, COMSIG_ITEM_CRAFTED, user, type)
	dir = dirin
	record_featured_stat(FEATURED_STATS_CRAFTERS, user)
	record_round_statistic(STATS_CRAFTED_ITEMS)
	record_featured_object_stat(FEATURED_STATS_CRAFTED_ITEMS, name)
	if(istype(src, /obj/item/rogueore/gold))
		record_round_statistic(STATS_GOLD_TRANSMUTED)
	return

/obj/item/OnCrafted(dirin)
	. = ..()

/turf/open/OnCrafted(dirin)
	. = ..()
	START_PROCESSING(SSweather,src)
	var/turf/belo = get_step_multiz(src, DOWN)
	for(var/x in 1 to 5)
		if(belo)
			START_PROCESSING(SSweather,belo)
			belo = get_step_multiz(belo, DOWN)
		else
			break

/datum/crafting_recipe/proc/TurfCheck(mob/user, turf/T)
	return TRUE

/atom/proc/SelectDiagDirection()
	var/list/options = list("NORTHWEST", "SOUTHWEST", "SOUTHEAST", "NORTHEAST")
	var/select = input(usr, "Please select a direction.", "", null) in options
	if(!select)
		return FALSE
	switch(select)
		if("NORTHWEST")
			return NORTHWEST
		if("SOUTHWEST")
			return SOUTHWEST
		if("SOUTHEAST")
			return SOUTHEAST
		if("NORTHEAST")
			return NORTHEAST
	return FALSE

/datum/component/personal_crafting/proc/construct_item_repeatable(mob/user, datum/crafting_recipe/R, amount = 1, auto)
	while(amount > 0 || auto)
		amount--
		var/result = construct_item(user, R)
		if(!result)
			break

/datum/component/personal_crafting/proc/construct_item(mob/user, datum/crafting_recipe/R)
	if (HAS_TRAIT(user, TRAIT_CURSE_MALUM))
		to_chat(user, span_warning("Your cursed hands tremble and fail to craft... Malum forbids it."))
		return
	if(user.doing)
		return
	var/list/contents = get_surroundings(user)
//	var/send_feedback = 1
	var/turf/T = get_step(user, user.dir)
	if(isopenturf(T) && R.wallcraft)
		to_chat(user, span_warning("Need to craft this on a wall."))
		return
	if(!isopenturf(T) || R.ontile)
		T = get_turf(user.loc)
	if(!R.TurfCheck(user, T))
		to_chat(user, span_warning("I can't craft here."))
		return
	if(isturf(R.result))
		for(var/obj/structure/fluff/traveltile/TT in range(7, user))
			to_chat(user, span_warning("I can't craft here."))
			return
	if(ispath(R.result, /obj/structure) || ispath(R.result, /obj/machinery))
		for(var/obj/structure/fluff/traveltile/TT in range(7, user))
			to_chat(user, span_warning("I can't craft here."))
			return
		for(var/obj/structure/S in T)
			if(R.buildsame && istype(S, R.result))
				if(user.dir == S.dir)
					to_chat(user, span_warning("Something is in the way."))
					return
				continue
			if(R.structurecraft && istype(S, R.structurecraft))
				continue
			if(S.density && !(R.ignoredensity))
				to_chat(user, span_warning("Something is in the way."))
				return
		for(var/obj/machinery/M in T)
			if(M.density && !(R.ignoredensity))
				to_chat(user, span_warning("Something is in the way."))
				return
	if(R.req_table)
		if(!(locate(/obj/structure/table) in T))
			to_chat(user, span_warning("I need to make this on a table."))
			return
	if(R.structurecraft)
		if(!(locate(R.structurecraft) in T))
			var/str
			if(ispath(R.structurecraft, /obj/))
				var/obj/O = R.structurecraft
				str = initial(O.name)
			to_chat(user, span_warning("I'm missing a structure I need: \the <b>[str]</b>"))
			return
	if(check_contents(R, contents))
		if(check_tools(user, R, contents))
			if(R.craftsound)
				playsound(T, R.craftsound, 100, TRUE)
			var/time2use = 10
			for(var/i = 1 to 100)
				if(do_after(user, time2use, target = user))
					contents = get_surroundings(user)
					if(!check_contents(R, contents))
						return FALSE
					if(!check_tools(user, R, contents))
						return FALSE
					var/prob2craft = 25
					if(R.craftdiff)
						prob2craft -= (25*R.craftdiff)
					if(R.skillcraft)
						if(user.mind)
							prob2craft += (user.get_skill_level(R.skillcraft) * 25)
					else
						prob2craft = 100
					if(isliving(user))
						var/mob/living/L = user
						if(L.STAINT > 10)
							prob2craft += ((10-L.STAINT)*-1)*2
					prob2craft = CLAMP(prob2craft, 0, 99)
					if(!prob(prob2craft))
						if(user.client?.prefs.showrolls)
							to_chat(user, span_danger("I've failed to craft \the [R.name]... [prob2craft]%"))
							continue
						to_chat(user, span_danger("I've failed to craft \the [R.name]."))
						continue
					var/list/parts = del_reqs(R, user)
					if(islist(R.result))
						var/list/L = R.result
						for(var/IT in L)
							var/atom/movable/I = new IT(T)
							I.CheckParts(parts, R)
							I.OnCrafted(user.dir, user)
							I.add_fingerprint(user)
					else
						if(ispath(R.result, /turf))
							var/turf/X = T.PlaceOnTop(R.result)
							if(X)
								X.OnCrafted(user.dir, user)
								X.add_fingerprint(user)
								if(R.loud)
									X.loud_message("Construction sounds can be heard")
						else
							var/atom/movable/I = new R.result (T)
							I.CheckParts(parts, R)
							if(R.diagonal)
								I.OnCrafted(I.SelectDiagDirection(), user)
							else
								I.OnCrafted(user.dir, user)
							I.add_fingerprint(user)
					user.visible_message(span_notice("[user] [R.verbage] \a [R.name]!"), \
										span_notice("I [R.verbage_simple] \a [R.name]!"))
					if(user.mind && R.skillcraft)
						if(isliving(user))
							var/mob/living/L = user
							var/amt2raise = L.STAINT * 2// its different over here
							if(R.craftdiff > 0) //difficult recipe
								amt2raise += (R.craftdiff * 10) // also gets more
							if(amt2raise > 0)
								user.mind.add_sleep_experience(R.skillcraft, amt2raise, FALSE)
					return TRUE
				return FALSE
			return FALSE
		var/str
		var/toollen = R.tools.len
		if(toollen)
			if(toollen > 1)
				for(var/i = 1, i<=toollen, i++)
					if(ispath(R.tools[i], /obj/))
						var/obj/O = R.tools[i]
						str += "[initial(O.name)][(i != toollen) ? ", " : ""]"
			else
				for(var/obj/O as anything in R.tools)
					str += "[initial(O.name)]"
		to_chat(usr, span_warning("I'm missing a tool. I need: <b>[str]</b>"))
		return FALSE
	return FALSE


/*Del reqs works like this:

	Loop over reqs var of the recipe
	Set var amt to the value current cycle req is pointing to, its amount of type we need to delete
	Get var/surroundings list of things accessable to crafting by get_environment()
	Check the type of the current cycle req
		If its reagent then do a while loop, inside it try to locate() reagent containers, inside such containers try to locate needed reagent, if there isnt remove thing from surroundings
			If there is enough reagent in the search result then delete the needed amount, create the same type of reagent with the same data var and put it into deletion list
			If there isnt enough take all of that reagent from the container, put into deletion list, substract the amt var by the volume of reagent, remove the container from surroundings list and keep searching
			While doing above stuff check deletion list if it already has such reagnet, if yes merge instead of adding second one
		If its stack check if it has enough amount
			If yes create new stack with the needed amount and put in into deletion list, substract taken amount from the stack
			If no put all of the stack in the deletion list, substract its amount from amt and keep searching
			While doing above stuff check deletion list if it already has such stack type, if yes try to merge them instead of adding new one
		If its anything else just locate() in in the list in a while loop, each find --s the amt var and puts the found stuff in deletion loop

	Then do a loop over parts var of the recipe
		Do similar stuff to what we have done above, but now in deletion list, until the parts conditions are satisfied keep taking from the deletion list and putting it into parts list for return

	After its done loop over deletion list and delete all the shit that wasnt taken by parts loop

	del_reqs return the list of parts resulting object will receive as argument of CheckParts proc, on the atom level it will add them all to the contents, on all other levels it calls ..() and does whatever is needed afterwards but from contents list already
*/

/datum/component/personal_crafting/proc/del_reqs(datum/crafting_recipe/R, mob/user)
	var/list/surroundings
	var/list/Deletion = list()
	. = list()
	var/data
	var/amt
	main_loop:
		for(var/A in R.reqs)
			amt = R.reqs[A]
			surroundings = get_environment(user)
			for(var/obj/item/I in surroundings)
				if(!I.can_craft_with())
					surroundings -= I
			for(var/atom/movable/IS in surroundings)
				if(!R.subtype_reqs && (IS.type in subtypesof(A)))
					surroundings.Remove(IS)
			surroundings -= Deletion
			if(ispath(A, /datum/reagent))
				var/datum/reagent/RG = new A
				var/datum/reagent/RGNT
				while(amt > 0)
					var/obj/item/reagent_containers/RC = locate() in surroundings
					if(!RC)
						break
					if(!RC.reagents)
						surroundings -= RC
						continue
					RG = RC.reagents.get_reagent(A)
					if(RG)
						if(!locate(RG.type) in Deletion)
							Deletion += new RG.type()
						if(RG.volume > amt)
							RG.volume -= amt
							data = RG.data
							RC.reagents.conditional_update(RC)
							RG = locate(RG.type) in Deletion
							RG.volume = amt
							RG.data += data
							continue main_loop
						else
							surroundings -= RC
							amt -= RG.volume
							RC.reagents.reagent_list -= RG
							RC.reagents.conditional_update(RC)
							RGNT = locate(RG.type) in Deletion
							RGNT.volume += RG.volume
							RGNT.data += RG.data
							qdel(RG)
						RC.on_reagent_change()
					else
						surroundings -= RC
			else if(ispath(A, /obj/item/natural) || A == /obj/item/grown/log/tree/stick)
				while(amt > 0)
					for(var/obj/item/natural/bundle/B in get_environment(user))
						if(B.stacktype == A)
							if(B.amount > amt)
								B.amount -= amt
								B.update_bundle()
								switch(B.amount)
									if(1)
										var/mob/living/carbon/old_loc = B.loc
										qdel(B)
										var/new_item = new B.stacktype(old_loc)
										// Put in the person's hands if there were holding it.
										if(ishuman(old_loc))
											old_loc.put_in_hands(new_item)
									if(0)
										qdel(B)
								amt = 0
								continue main_loop
							else
								qdel(B)
								amt -= B.amount
						else
							continue
					var/atom/movable/I
					while(amt > 0)
						I = locate(A) in surroundings
						Deletion += I
						surroundings -= I
						amt--
			else if(ispath(A, /obj/item/reagent_containers/glass)) //Don't eat bottles with reagents in them
				var/atom/movable/I
				while(amt > 0)
					I = locate(A) in surroundings
					var/obj/item/reagent_containers/glass/RC = I
					if(RC.reagents?.total_volume > 0)
						surroundings -= I
						continue
					Deletion += I
					surroundings -= I
					amt--
			else
				var/atom/movable/I
				while(amt > 0)
					I = locate(A) in surroundings
					Deletion += I
					surroundings -= I
					amt--
	var/list/partlist = list(R.parts.len)
	for(var/M in R.parts)
		partlist[M] = R.parts[M]
	for(var/A in R.parts)
		if(istype(A, /datum/reagent))
			var/datum/reagent/RG = locate(A) in Deletion
			if(RG.volume > partlist[A])
				RG.volume = partlist[A]
			. += RG
			Deletion -= RG
			continue
		else
			while(partlist[A] > 0)
				var/atom/movable/AM = locate(A) in Deletion
				. += AM
				Deletion -= AM
				partlist[A] -= 1
	while(Deletion.len)
		var/DL = Deletion[Deletion.len]
		Deletion.Cut(Deletion.len)
		if(DL)
			var/atom/movable/A = DL
			if(R.blacklist.Find(A.type))
				continue
		qdel(DL)

/datum/component/personal_crafting/proc/component_ui_interact(atom/movable/screen/craft/image, location, control, params, user)
	if(user == parent)
		ui_interact(user)

/datum/component/personal_crafting/ui_data(mob/user)
	var/list/data = list()
	data["busy"] = busy

	var/list/surroundings = get_surroundings(user)
	var/list/craftability = list()
	for(var/rec in GLOB.crafting_recipes)
		var/datum/crafting_recipe/R = rec

		if(!R.always_availible && !(R.type in user?.mind?.learned_recipes)) //User doesn't actually know how to make this.
			continue
		if(R.required_tech_node && !R.tech_unlocked)
			continue

		craftability[R.name] = check_contents(R, surroundings)

	data["craftability"] = craftability
	data["showonlycraftable"] = showonlycraftable
	return data

/datum/component/personal_crafting/ui_static_data(mob/user)
	var/list/data = list()

	var/list/crafting_recipes = list()
	for(var/rec in GLOB.crafting_recipes)
		var/datum/crafting_recipe/R = rec

		if(R.name == "") //This is one of the invalid parents that sneaks in
			continue

		if(!R.always_availible && !(R.type in user?.mind?.learned_recipes)) //User doesn't actually know how to make this.
			continue
		if(R.required_tech_node && !R.tech_unlocked)
			continue
		var/category
		if(R.skillcraft)
			var/datum/skill/S = R.skillcraft
			category = initial(S.name)
		else
			category = "Other"
		if(isnull(crafting_recipes[category]))
			crafting_recipes[category] = list()
		crafting_recipes[category] += list(build_recipe_data(R))

	data["crafting_recipes"] = crafting_recipes
	return data

/datum/component/personal_crafting/ui_interact(mob/user, datum/tgui/ui)
	var/area/A = get_area(user)
	if(!A.can_craft_here())
		to_chat(user, span_warning("You cannot craft here."))
		if(ui) ui.close()
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiaCraft", "Crafting Menu", 700, 800)
		ui.set_state(GLOB.not_incapacitated_turf_state)
		ui.open()

/datum/component/personal_crafting/ui_state(mob/user)
	var/area/A = get_area(user)
	if(!A.can_craft_here())
		return UI_CLOSE
	return ..()

/datum/component/personal_crafting/ui_act(action, params)
	. = ..()
	switch(action)
		if("craft")
			var/path = text2path(params["item"])
			var/amount = params["amount"] || 1
			var/auto = params["auto"]
			var/recipe = new path
			construct_item_repeatable(usr, recipe, amount, auto)
			usr.mind.lastrecipe = recipe
		if("checkboxonlycraftable")
			showonlycraftable = params["state"]



/datum/component/personal_crafting/proc/build_recipe_data(datum/crafting_recipe/R)
	var/list/data = list()
	data["name"] = R.name
	data["ref"] = "[REF(R)]"
	data["path"] = R.type
	data["sellprice"] = R.sellprice
	var/req_text = ""
	var/tool_text = ""
	var/catalyst_text = ""

	for(var/a in R.reqs)
		//We just need the name, so cheat-typecast to /atom for speed (even tho Reagents are /datum they DO have a "name" var)
		//Also these are typepaths so sadly we can't just do "[a]"
		var/atom/A = a
		req_text += " [R.reqs[A]] [initial(A.name)],"
	req_text = replacetext(req_text,",","",-1)
	data["req_text"] = req_text

	for(var/a in R.chem_catalysts)
		var/atom/A = a //cheat-typecast
		catalyst_text += " [R.chem_catalysts[A]] [initial(A.name)],"
	catalyst_text = replacetext(catalyst_text,",","",-1)
	data["catalyst_text"] = catalyst_text

	for(var/a in R.tools)
		if(ispath(a, /obj/item))
			var/obj/item/b = a
			tool_text += " [initial(b.name)],"
		else
			tool_text += " [a],"
	tool_text = replacetext(tool_text,",","",-1)
	data["tool_text"] = tool_text

	data["craftingdifficulty"] = skill_to_string(R.craftdiff)


	return data

//Mind helpers

/datum/mind/proc/teach_crafting_recipe(R)
	if(!learned_recipes)
		learned_recipes = list()
	learned_recipes |= R

/datum/mind/proc/forget_crafting_recipe(R)
	if(!learned_recipes)
		return
	learned_recipes -= R

// new crafting button interaction

/datum/component/personal_crafting/proc/roguecraft(location, control, params, mob/user)

	if(user.doing)
		return
	var/area/A = get_area(user)
	if(!A.can_craft_here())
		to_chat(user, span_warning("I can't craft here."))
		return

	var/list/data = list()
	var/list/catty = list()
	var/list/surroundings = get_surroundings(user)
	for(var/rec in GLOB.crafting_recipes)
		var/datum/crafting_recipe/R = rec
		if(!R.always_availible && !(R.type in user?.mind?.learned_recipes)) //User doesn't actually know how to make this.
			continue
		if(R.required_tech_node && !R.tech_unlocked)
			continue

		if(check_contents(R, surroundings))
			if(R.name)
				data += R
				if(R.skillcraft)
					var/datum/skill/S = new R.skillcraft()
					catty |= S.name
				else
					catty |= "Other"
	if(!data.len)
		to_chat(user, span_warning("There is nothing I can craft."))
		return
	if(!catty.len)
		return
	var/t
	if(catty.len > 1)
		t=input(user, "CHOOSE SKILL") as null|anything in catty
	else
		t=pick(catty)
	if(t)
		var/list/realdata = list()
		for(var/datum/crafting_recipe/X in data)
			if(X.skillcraft)
				var/datum/skill/S = new X.skillcraft()
				if(t == S.name)
					realdata += X
			else
				if(t == "Other")
					realdata += X
		if(realdata.len)
			realdata = sortNames(realdata)
			var/r = input(user, "What should I craft?") as null|anything in realdata
			if(r)
				construct_item_repeatable(user, r)
				user.mind.lastrecipe = r




/client/verb/toggle_legacycraft()
	set name = "Toggle legacy craft"
	set category = "Options"
	set desc = "Toggles between legacy and miacraft"
	usr.client.legacycraft = !legacycraft

/client
	var/legacycraft = FALSE

