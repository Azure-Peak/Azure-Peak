/obj/structure/roguemachine/chimeric_slab
	name = "Chimeric Echo Slab"
	desc = "A specialized interface for accessing fundamental Tier 1 chimeric knowledge."
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "blackrot1"
	density = FALSE
	anchored = TRUE
	pixel_y = 32

/obj/structure/roguemachine/chimeric_slab/attack_hand(mob/user)
	ui_interact(user)

/obj/structure/roguemachine/chimeric_slab/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChimericTechWeb", "Echo Knowledge Base")
		ui.open()

/obj/structure/roguemachine/chimeric_slab/ui_data(mob/user)
	. = list()

	var/current_points = SSchimeric_tech.echo_points
	.["points"] = current_points
	.["tier"] = 1

	// Get ONLY echoes (Tier 1) from the subsystem
	var/list/echo_choices = SSchimeric_tech.get_available_choices(1, current_points, 3, 2)

	var/list/choices_data = list()
	for(var/datum/chimeric_tech_node/N in echo_choices)
		UNTYPED_LIST_ADD(choices_data, list(
			"name" = N.name,
			"desc" = N.description,
			"cost" = N.cost,
			"path" = N.string_id,
			"required_tier" = 1,
			"can_afford" = current_points >= N.cost,
		))

	.["choices"] = choices_data

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

/obj/structure/roguemachine/chimeric_slab/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return

	var/mob/user = ui.user

	switch(action)
		if("unlock_node")
			var/string_id = params["path"]
			var/datum/chimeric_tech_node/node = SSchimeric_tech.all_tech_nodes[string_id]
			if(!node) return

			// Check subsystem echo points instead of heartbeast
			if(SSchimeric_tech.echo_points < node.cost)
				to_chat(user, "Insufficient Echo Points.")
				return TRUE

			SSchimeric_tech.echo_points -= node.cost
			node.unlocked = TRUE

			SSchimeric_tech.clear_cached_choices(2)

			to_chat(user, "Successfully harmonized with [node.name].")
			return TRUE

/obj/effect/landmark/chimeric_calyx_spawner
	name = "Chimeric Calyx Spawner"
	var/calyx_spawn_chance = 60

/obj/effect/landmark/chimeric_calyx_spawner/thirty
	calyx_spawn_chance = 30

/obj/effect/landmark/chimeric_calyx_spawner/fifteen
	calyx_spawn_chance = 15

/obj/effect/landmark/chimeric_calyx_spawner/Initialize()
	. = ..()
	if(prob(calyx_spawn_chance))
		new /obj/structure/roguemachine/chimeric_calyx(loc)
	qdel(src)

/obj/structure/roguemachine/chimeric_calyx
	name = "Heartbeast Calyx"
	desc = "A pulsating bowl held aloft by twitching, vein-filled tendrils. The tendrils seem to have burst out of the ground long ago. It seems to hunger for interaction."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "calyx"
	density = TRUE
	anchored = TRUE
	var/list/contributing_names = list()

/obj/structure/roguemachine/chimeric_calyx/attack_hand(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(H.real_name in contributing_names)
		to_chat(H, span_warning("The calyx has already tasted your essence. It finds no more interest in you."))
		return

	to_chat(H, span_notice("You begin to offer your arms to the twitching tendrils..."))
	if(!do_after(H, 4 SECONDS, target = src))
		return

	var/medical_skill = H.get_skill_level(/datum/skill/misc/medicine)
	var/is_pestra = istype(H.patron, /datum/patron/divine/pestra)

	// Base is medicine (0-6). If Pestra, they get a +2 bonus.
	var/effectiveness = medical_skill
	if(is_pestra)
		effectiveness += 2

	// Grant Vials: 1 by default, 2 if they are highly skilled/Pestra (4+ combined)
	var/vial_count = (effectiveness >= 4) ? 2 : 1
	for(var/i in 1 to vial_count)
		new /obj/item/heart_blood_vial/filled(H.loc)

	// Grant Echo Points: Clamp between 1 and 6 based on effectiveness
	var/points_granted = clamp(effectiveness, 1, 6)
	SSchimeric_tech.echo_points += points_granted
	// One sippy per person
	contributing_names += H.real_name
	var/healing = 5
	H.visible_message(span_info("Skittering ghostly bugs envelop [target]!"), span_notice("Ethereal bugs knit my flesh back together with their mandibles!"))
	H.apply_status_effect(/datum/status_effect/buff/healing, healing)
	// 225 healing but slowly released across 10 minutes, can't be refreshed.
	H.apply_status_effect(/datum/status_effect/buff/pestra_care)

	to_chat(H, span_boldnotice("The calyx shudders as tendrils extend to feel up your arms, affectionately carressing your head. You have contributed [points_granted] Echoes."))
	if(vial_count > 1)
		to_chat(H, span_notice("Your affinity allows you to coax the creature into giving you an extra vial of blood."))
	else
		to_chat(H, span_notice("The calyx cautiously places a vial of blood on the ground with one tendril."))
	playsound(src, 'sound/misc/machineyes.ogg', 50, 1)
