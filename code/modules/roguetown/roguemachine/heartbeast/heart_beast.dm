/obj/structure/roguemachine/chimeric_heart_beast
	desc = "Half-flesh, half-stone; a cancerous tumour given mind and will and appetite, hauled by chains and made to \
	be useful. An inheritance of divinity, and a truly horrible thing to look at."
	var/datum/flesh_archetype/archetype
	var/list/datum/flesh_trait/traits = list()
	var/list/datum/flesh_quirk/quirks = list()
	var/list/identified_traits = list() // Traits players have figured out
	var/list/identified_quirks = list() // Quirks players have figured out
	var/list/dense_turfs = list()
	var/royal_title = "" // For royal quirk
	var/discharge_color = "#ffffff" // Current discharge color
	var/understanding_bonus = 0 // Bonus from correctly identifying traits/quirks
	var/being_fed = FALSE
	var/recently_fed = FALSE
	resistance_flags = INDESTRUCTIBLE
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	icon = 'icons/obj/structures/heart_beast.dmi'
	icon_state = "heart_beast"
	flags_1 = HEAR_1
	pixel_x = -32

/obj/structure/roguemachine/chimeric_heart_beast/examine(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/c = user
		if(c.patron.type == /datum/patron/divine/pestra)
			. += span_info("The divine beast of Pestra. For untold ages, these beasts remained behind locked doors, allowing the sect of Pestra to lengthen their lifespan.")
			. += span_infection("Yet the others grew restless, desiring pure lux for their own...")
			. += span_info("Now, they are employed in most regions of the world where the light of the ten shines. Decreasing suffering.")
			. += span_infection("For the great beast of Pestra, made through the ingenuity of humenkind influences all divine magic within a region.")

/obj/structure/roguemachine/chimeric_heart_beast/proc/initialize_personality()
	// Pick random archetype
	var/archetype_types = list(
		/datum/flesh_archetype/fearful,
		/datum/flesh_archetype/authoritarian, 
		/datum/flesh_archetype/aggressive,
		/datum/flesh_archetype/arbitrary,
		/datum/flesh_archetype/inquisitive,
		/datum/flesh_archetype/split_personality
	)
	var/archetype_type = pick(archetype_types)
	archetype = new archetype_type()

	// Pick 2 non-conflicting traits
	var/list/available_traits = archetype.possible_traits.Copy()
	while(traits.len < 2 && available_traits.len)
		var/trait_type = pick(available_traits)
		available_traits -= trait_type

		var/datum/flesh_trait/candidate = new trait_type()
		var/valid = TRUE

		// Check for conflicts with existing traits
		for(var/datum/flesh_trait/existing in traits)
			if(trait_type in existing.conflicting_traits)
				valid = FALSE
				break
			if(existing.type in candidate.conflicting_traits)
				valid = FALSE
				break

		if(valid)
			traits += candidate

	// Pick 3 non-conflicting quirks with rarity consideration
	var/list/available_quirks = archetype.possible_quirks.Copy()
	var/attempts = 0
	while(quirks.len < 3 && available_quirks.len && attempts < 10)
		attempts++

		// Weight by rarity (lower rarity = more common)
		var/list/weighted_quirks = list()
		for(var/quirk_type in available_quirks)
			var/datum/flesh_quirk/temp = new quirk_type()
			weighted_quirks[quirk_type] = temp.rarity
			qdel(temp)

		var/quirk_type = pickweight(weighted_quirks)
		available_quirks -= quirk_type

		var/datum/flesh_quirk/candidate = new quirk_type()
		var/valid = TRUE

		// Check for conflicts
		for(var/datum/flesh_quirk/existing in quirks)
			if(quirk_type in existing.conflicting_quirks)
				valid = FALSE
				break
			if(existing.type in candidate.conflicting_quirks)
				valid = FALSE
				break

		if(valid)
			quirks += candidate

	// Set discharge color if applicable
	if(locate(/datum/flesh_quirk/discharge) in quirks)
		discharge_color = pick(archetype.discharge_colors)

	// Set royal title if applicable
	if(locate(/datum/flesh_quirk/royal) in quirks)
		royal_title = pick("Majesty", "Great One", "Master", "Overlord", "Eminence")

	// TURN THIS INTO A ROUND END MESSAGE LATER BECAUSE IT IS NICE TO KNOW WHAT QUIRKS THE BEAST HAD..

	// var/list/debug_info = list()
	// debug_info += "Archetype: [archetype.name]"
	// debug_info += "Traits:"
	// for(var/datum/flesh_trait/trait in traits)
	// 	debug_info += "  - [trait.name]"
	// debug_info += "Quirks:"
	// for(var/datum/flesh_quirk/quirk in quirks)
	// 	debug_info += "  - [quirk.name]"
	// debug_info += "Discharge Color: [discharge_color]"
	// if(royal_title)
	// 	debug_info += "Royal Title: [royal_title]"

	// to_chat(world, span_userdanger("[debug_info.Join("\n")]"))

/obj/structure/roguemachine/chimeric_heart_beast/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	// . = ..()

	if(get_dist(src, speaker) > 7)
		return
	if(speaker == src)
		return
	if(!ishuman(speaker))
		return
	SEND_SIGNAL(src, COMSIG_HEART_BEAST_HEAR, speaker, raw_message)

/obj/structure/roguemachine/chimeric_heart_beast/Initialize()
	. = ..()
	initialize_personality()
	AddComponent(/datum/component/chimeric_heart_beast)
	become_hearing_sensitive()

/obj/structure/roguemachine/chimeric_heart_beast/Destroy()
	lose_hearing_sensitivity()

	for(var/turf/T in dense_turfs)
		if(T)
			T.density = initial(T.density)
			T.opacity = initial(T.opacity)
	return ..()

/obj/structure/roguemachine/chimeric_heart_beast/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat))
		if(!(I.item_flags & FRESH_FOOD_ITEM))
			to_chat(user, span_warning("The beast doesn't seem to like this dusty piece of meat..."))
			return ..()
		if(being_fed)
			to_chat(user, span_warning("Someone is already feeding [src]!"))
			return TRUE

		var/datum/component/chimeric_heart_beast/heart_component = GetComponent(/datum/component/chimeric_heart_beast)
		if(heart_component && heart_component.happiness >= heart_component.max_happiness * 0.9)
			to_chat(user, span_warning("[src] seems content and uninterested in food."))
			return TRUE

		being_fed = TRUE
		user.visible_message(span_notice("[user] starts feeding [I] to [src]."), span_notice("You start feeding [I] to [src]."))
		if(!do_after(user, 3 SECONDS, target = src))
			being_fed = FALSE
			return TRUE

		feed_heartbeast(I, user, heart_component)
		return TRUE
	return ..()

/obj/structure/roguemachine/chimeric_heart_beast/proc/feed_heartbeast(obj/item/meat, mob/user, datum/component/chimeric_heart_beast/heart_component)
	if(!heart_component)
		heart_component = GetComponent(/datum/component/chimeric_heart_beast)
		if(!heart_component)
			being_fed = FALSE
			return

	heart_component.happiness = min(heart_component.happiness + (heart_component.max_happiness * 0.2), heart_component.max_happiness)

	visible_message(span_notice("[user] feeds [meat] to [src]. It seems pleased!"))
	playsound(src, 'sound/misc/eat.ogg', 100, TRUE)
	qdel(meat)
	heart_component.update_blood_output()
	recently_fed = TRUE
	being_fed = FALSE

/obj/structure/roguemachine/chimeric_heart_beast/MiddleClick(mob/user, params)
	. = ..()
	if(isliving(user))
		ui_interact(user)

/obj/structure/roguemachine/chimeric_heart_beast/ui_interact(mob/user, datum/tgui/ui)
	if(!isliving(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChimericTechWeb", "Chimeric Tech Web")
		ui.open()

// Probably don't need static data for this
/obj/structure/roguemachine/chimeric_heart_beast/ui_data(mob/user)
	. = ..()

	var/datum/component/chimeric_heart_beast/heart_component
	heart_component = GetComponent(/datum/component/chimeric_heart_beast)
	var/list/choices = SSchimeric_tech.get_available_choices(heart_component.language_tier, heart_component.tech_points)

	var/list/choices_data = list()
	for(var/datum/chimeric_tech_node/N in choices)
		UNTYPED_LIST_ADD(choices_data, list(
			"name" = N.name,
			"desc" = N.description,
			"cost" = N.cost,
			"path" = N.string_id, // Send the path back for the unlock proc
			"required_tier" = N.required_tier,
			"can_afford" = heart_component.tech_points >= N.cost,
		))

	.["choices"] = choices_data
	.["points"] = heart_component.tech_points
	.["tier"] = heart_component.language_tier

	var/list/unlocked_data = list()
	for(var/string_id in SSchimeric_tech.all_tech_nodes)
		var/datum/chimeric_tech_node/N = SSchimeric_tech.all_tech_nodes[string_id]
		if(N.unlocked)
			UNTYPED_LIST_ADD(unlocked_data, list(
				"name" = N.name,
				"desc" = N.description,
				"tier" = N.required_tier,
			))

 	.["unlocked"] = unlocked_data

	return .

/obj/structure/roguemachine/chimeric_heart_beast/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/datum/component/chimeric_heart_beast/heart_component
	heart_component = GetComponent(/datum/component/chimeric_heart_beast)

	switch(action)
		if("unlock_node")
			var/string_id = params["path"]
			var/result = SSchimeric_tech.unlock_node(string_id, heart_component)
			to_chat(user, result)
			SStgui.try_update_ui(user, src)
			return TRUE
