/obj/structure/roguemachine/chimeric_slab
	name = "Chimeric Echo Slab"
	desc = "A specialized device for accessing fundamental chimeric knowledge."
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
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("unlock_node")
			if(!isliving(user))
				return FALSE
			var/string_id = params["path"]
			var/result = SSchimeric_tech.unlock_node(string_id, null, 2)
			to_chat(user, result)
			return TRUE

/obj/effect/landmark/chimeric_calyx_spawner
	name = "Chimeric Calyx Spawner"
	var/calyx_spawn_chance = 60

/obj/effect/landmark/chimeric_calyx_spawner/thirty
	calyx_spawn_chance = 30

/obj/effect/landmark/chimeric_calyx_spawner/fifteen
	calyx_spawn_chance = 15

/obj/effect/landmark/chimeric_calyx_spawner/Initialize(mapload)
	. = ..()
	if(SSticker && SSticker.setup_done)
		return INITIALIZE_HINT_QDEL
	if(prob(calyx_spawn_chance))
		new /obj/structure/roguemachine/chimeric_calyx(loc)
	return INITIALIZE_HINT_QDEL

/obj/structure/roguemachine/chimeric_calyx
	name = "Heartbeast Calyx"
	desc = "A pulsating bowl held aloft by twitching, vein-filled tendrils. The tendrils seem to have burst out of the ground long ago. It seems to hunger for interaction."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "calyx"
	density = TRUE
	anchored = TRUE
	var/list/contributing_names = list()
	var/calyx_uses = 0
	blade_dulling = DULLING_CUT
	max_integrity = 300

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
	var/holy_skill = H.get_skill_level(/datum/skill/magic/holy)
	var/is_pestra = istype(H.patron, /datum/patron/divine/pestra)

	// Base is medicine (0-6). If Pestra, they get a +2 bonus.
	var/effectiveness = max(holy_skill, medical_skill)
	if(is_pestra)
		effectiveness += 2

	// Grant Vials: 1 by default, 2 if they are highly skilled/Pestra (4+ combined)
	var/vial_count = (effectiveness >= 4) ? 2 : 1
	for(var/i in 1 to vial_count)
		new /obj/item/heart_blood_vial/filled(H.loc)
	new /obj/item/roguecoin/copper(H.loc, effectiveness)

	// Grant Echo Points: Clamp between 1 and 6 based on effectiveness
	var/points_granted = clamp(effectiveness, 1, 6)
	SSchimeric_tech.echo_points += points_granted
	calyx_uses++
	// One sippy per person
	contributing_names += H.real_name
	var/healing = 5
	H.visible_message(span_info("Skittering ghostly bugs envelop [H]!"), span_notice("Ethereal bugs knit my flesh back together with their mandibles!"))
	H.apply_status_effect(/datum/status_effect/buff/healing, healing)
	// 225 healing but slowly released across 10 minutes, can't be refreshed.
	H.apply_status_effect(/datum/status_effect/buff/pestra_care)

	if(H.has_status_effect(/datum/status_effect/black_rot))
		var/datum/status_effect/black_rot/rot = H.has_status_effect(/datum/status_effect/black_rot)
		rot.remove_stack(2)
		to_chat(H, span_good("The calyx's purifying blood flows through you, cleansing the black rot!"))

	to_chat(H, span_boldnotice("The calyx shudders as tendrils extend to feel up your arms, affectionately carressing your head. You have contributed [points_granted] Echoes."))
	if(vial_count > 1)
		to_chat(H, span_notice("Your affinity allows you to coax the creature into giving you an extra vial of blood."))
	else
		to_chat(H, span_notice("The calyx cautiously places a vial of blood on the ground with one tendril."))
	playsound(src, 'sound/misc/machineyes.ogg', 50, 1)

/obj/structure/roguemachine/chimeric_calyx/obj_destruction(damage_flag)
	var/anger_chance = max(0, 75 - (calyx_uses * 25))
	if(calyx_uses == 0 || prob(anger_chance))
		playsound(src, 'sound/mobs/abyssal/abyssal_pain.ogg', 100, 1)
		visible_message(span_userdanger("The calyx, its curiosity unsatisfied, turns its attention towards its assailants one last time before it disappears underground."))
		spawn(10)
			visible_message(span_userdanger("Stange vibrations rock through the earth! Something is coming!"))
		var/list/possible_targets = get_adjacent_ambush_turfs(loc)
		if(possible_targets.len)
			playsound(src, 'sound/misc/jumpscare (4).ogg', 100, 1)
			visible_message(span_userdanger("The earth bursts as underdweller creatures are coaxed out of the ground!"))
			var/list/vengeance_mobs = list(
				/mob/living/simple_animal/hostile/rogue/mirespider_paralytic = 2,
				/mob/living/simple_animal/hostile/retaliate/rogue/mirespider = 5,
				/mob/living/simple_animal/hostile/rogue/mirespider_lurker = 5,
				/mob/living/simple_animal/hostile/rogue/mirespider_lurker/mushroom = 2
			)
			for(var/i in 1 to 3)
				var/spawnloc = pick(possible_targets)
				if(spawnloc)
					var/random_delay = rand(1, 5)
					spawn(random_delay SECONDS)
						var/mob_type = pickweight(vengeance_mobs)
						var/mob/living/simple_animal/hostile/vengeance_mob = new mob_type(spawnloc)
						vengeance_mob.attack_same = FALSE
						vengeance_mob.del_on_deaggro = 45 SECONDS
						vengeance_mob.faction += "ambush"
						playsound(spawnloc, 'sound/mobs/abyssal/abyssal_pain.ogg', 50, 1)
		var/random_curiosity_reward = rand(2,max(3, 6 - calyx_uses))
		SSchimeric_tech.echo_points += random_curiosity_reward
	else
		visible_message(span_info("The calyx harmlessly retreats underground after suffering some abuse."))
	. = ..()
