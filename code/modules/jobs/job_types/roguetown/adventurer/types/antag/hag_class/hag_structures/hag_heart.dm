/obj/structure/roguemachine/hag_heart
	name = "Hag Heart"
	desc = "A series of overgrown skulls and roots with a terrifying mossy visage at the center. This is it, the root of evyl."
	icon = 'icons/roguetown/items/hag/hag_heart.dmi'
	icon_state = "heart"
	density = TRUE
	blade_dulling = DULLING_CUT
	max_integrity = 2000
	obj_integrity = 2000
	pixel_x = -8
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/current_stage = 1
	var/max_stages = 3
	var/timer_id
	var/datum/hag_rite/chosen_rite
	var/static/alist/rite_requirements = alist(
		1 = list(/obj/item/reagent_containers/lux = 2, /obj/item/reagent_containers/food/snacks/fish/creepy_squid = 1, /obj/item/reagent_containers/glass/bottle/rogue/elfblue = 1),
		2 = list(/obj/item/rogueweapon/sword/rapier/lord = 1, /obj/item/magic/voidstone = 1, /obj/item/blueprint/mace_mushroom = 1),
		3 = list(/obj/item/rogueore/lithmyc = 1, /obj/item/roguegem/blood_diamond = 1, /obj/item/reagent_containers/food/snacks/eoran_aril/ashen = 1, /obj/item/ingot/lithmyc = 1, /obj/item/rogueweapon/mace/mushroom = 1, /obj/item/rogueweapon/spear/dreamscape_trident = 1),
	)
	var/list/delivered_items = list()
	var/rite_started = FALSE
	var/rite_completed = FALSE
	var/tutorial_started = FALSE
	var/static/list/hag_tutorial_lines = list(
		"Awaken, daughter of the mud... the roots have pulled you back from the long sleep.",
		"The mortals have forgotten the taste of swamp water. You must remind them. Find them, bind them... give them 'boons' to fuel our return.",
		"Regain your spite! Turn their simple gifts into heavy curses. The more they suffer, the more the Mossmother's power flows through you.",
		"Work the old ways at the bench. Varnish and synth base... weave them into items or boons that glitter with our magic.",
		"Here, take some of my mosses. If they glow, absorb them to manifest their magic as a boon later. Or enchant them yourself.",
		"But remember! The pact must be accepted! Offer your enchanted gifts with a Right-Click! they must take the hook willingly.",
		"Feed the Heartroot trees with Lux. Let them drink deep so they may sprout the mosses we need for our components.",
		"And if the hunger for true revenge bites... bring me the tithes listed here. We shall perform the Grand Rite together.",
		"Be wary! Cursed mortals and the Rite itself will draw them to your hut. They will try to smash my wards in the bog to find you.",
		"I am your anchor. I will bring you back from death's door again and again... unless they shatter me, as they did in the yils before.",
		"Should you find yourself captured or trapped, remember you can hold your breath...",
		"Go now. Curse them. Bind them. Or burn the world with the Rite. The bog remembers... and so do I."
	)

/obj/structure/roguemachine/hag_heart/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armor_penetration = 0, object_damage_multiplier = 1)
	if(GLOB.hag_wards.len > 0)
		if(sound_effect)
			src.visible_message(span_notice("Magical energy still seems to safeguard the heart for now."))
			playsound(src, 'sound/magic/magic_nulled.ogg', 50, TRUE)
		return FALSE
	return ..()

/obj/structure/roguemachine/hag_heart/proc/begin_tutorial()
	var/delay = 0
	for(var/line in hag_tutorial_lines)
		addtimer(CALLBACK(src, PROC_REF(speak_tutorial_line), line), delay)
		delay += 6 SECONDS

/obj/structure/roguemachine/hag_heart/proc/speak_tutorial_line(line)
	if(QDELETED(src))
		return
	playsound(src, 'sound/hag/hag_cackles_short.ogg', 100, TRUE)
	src.say(line)

/obj/structure/roguemachine/hag_heart/Initialize(mapload)
	. = ..()
	GLOB.hag_hearts += src

/obj/structure/roguemachine/hag_heart/Destroy()
	GLOB.hag_hearts -= src
	for(var/mob/living/H in GLOB.active_hags)
		to_chat(H, span_userdanger("My heart is gone. If I die now, I won't return for until many yils have passed."))
	if(timer_id)
		deltimer(timer_id)
		priority_announce("The Grand Rite has been thwarted! The cackling fades into a pathetic whimper.", "Rite Severed")
	return ..()

/obj/structure/roguemachine/hag_heart/examine(mob/user)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_ANCIENT_HAG))
		return
	if(!tutorial_started)
		tutorial_started = TRUE
		begin_tutorial()

	if(timer_id)
		var/time_left = timeleft(timer_id)
		if(time_left > 0)
			. += span_boldnotice("The Grand Rite of [chosen_rite.name] is in progress! [DisplayTimeText(time_left)] remain.")
		else
			. += span_boldnotice("The Grand Rite is reaching its crescendo...")
		return

	if(current_stage > max_stages)
		. += span_boldnotice("The tithes are complete. <b>Interact</b> with the heart to choose your Grand Rite.")
		return

	. += span_notice("The heart demands Stage [current_stage] tithes. Offer one of the following:")
	var/list/options = rite_requirements[current_stage]
	for(var/path in options)
		. += span_info("- [options[path]]x [initial(path:name)]")

/obj/structure/roguemachine/hag_heart/attackby(obj/item/I, mob/living/user)
	if(current_stage > max_stages || timer_id)
		return ..()

	var/list/current_reqs = rite_requirements[current_stage]
	var/path_to_check = I.type
	
	// Check if the item matches any requirement for this stage
	var/is_valid_contribution = FALSE
	for(var/req_path in current_reqs)
		if(istype(I, req_path))
			path_to_check = req_path // Use the requirement path for consistent indexing
			is_valid_contribution = TRUE
			break

	if(!is_valid_contribution)
		return ..()

	var/total_needed = current_reqs[path_to_check]
	var/already_delivered = delivered_items[path_to_check] || 0

	// Consume the item
	user.transferItemToLoc(I, src, TRUE) // Move to null/src before deletion for safety
	qdel(I)

	already_delivered++
	delivered_items[path_to_check] = already_delivered

	to_chat(user, span_notice("The heart pulses greedily as it consumes the [initial(path_to_check:name)]. ([already_delivered]/[total_needed])"))
	playsound(src, 'sound/magic/heartbeat.ogg', 100, TRUE)

	// Check if THIS specific requirement path is satisfied
	if(already_delivered >= total_needed)
		to_chat(user, span_boldnotice("The heart has been satiated with [initial(path_to_check:name)] for this stage!"))
		current_stage++
		delivered_items.Cut() // Clear for the next stage
		
		if(current_stage > max_stages)
			to_chat(user, span_boldnotice("The tithes are complete! The heart is ready to channel your spite."))
	
	return TRUE

/obj/structure/roguemachine/hag_heart/attack_hand(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_ANCIENT_HAG))
		return
	if(current_stage > max_stages && !timer_id && !rite_started)
		select_rite(user)
		return
	..()

/obj/structure/roguemachine/hag_heart/proc/select_rite(mob/living/user)
	// We check for the component locally just to ensure a Hag is the one starting it
	if(!user.GetComponent(/datum/component/hag_curio_tracker))
		to_chat(user, span_warning("Your soul is not twisted enough to conduct this rite."))
		return

	var/list/rites = list()
	for(var/path in subtypesof(/datum/hag_rite))
		var/datum/hag_rite/R = new path()
		rites[R.name] = R

	var/selection = tgui_input_list(user, "Choose the Grand Rite", "The Final Cackle", rites)
	if(!selection || timer_id)
		return

	chosen_rite = rites[selection]
	
	priority_announce("A terrible, ancient cackle echoes across the land. The Grand Rite of [chosen_rite.name] has begun!", "The Mossmother Stirs")
	for(var/mob/M in GLOB.player_list)
		M.playsound_local(M, 'sound/hag/hag_cackles.ogg', 100, FALSE)

	rite_started = TRUE
	GLOB.hag_rite_active = TRUE
	timer_id = addtimer(CALLBACK(src, PROC_REF(finish_rite)), 20 MINUTES, TIMER_STOPPABLE)

/obj/structure/roguemachine/hag_heart/proc/finish_rite()
	if(!chosen_rite)
		return

	// Find any living, active Hag to process the curses
	// Should there be more than one hag, that means the curse still lands! spooky!
	var/datum/component/hag_curio_tracker/HCT
	for(var/mob/living/H in GLOB.active_hags)
		if(H.stat != DEAD)
			HCT = H.GetComponent(/datum/component/hag_curio_tracker)
			if(HCT)
				break

	if(!HCT)
		priority_announce("The Grand Rite fizzles away... the Mossmother has no tether left in this realm.", "Rite Failed")
		return

	priority_announce("The Grand Rite is complete. [chosen_rite.name] has fallen upon the world! Ancient grievances are at last settled.", "The Mossmother Ascends")
	rite_completed = TRUE

	// Distribute the spite
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat == DEAD || !H.mind || HAS_TRAIT(H, TRAIT_ANCIENT_HAG))
			continue
		// People who are enjoying only boons are technically allies.
		if(HCT.boon_registry[H.real_name])
			if(!HCT.find_boon_by_type(H.real_name, /datum/hag_boon/curse_scar))
				continue
		HCT.grant_boon(H.real_name, chosen_rite.curse_path, 100)
		to_chat(H, span_userdanger("The world screams in agony. You are now afflicted by [chosen_rite.name]!"))

/datum/hag_rite
	var/name = "Generic Rite"
	var/desc = "A dark ritual."
	var/curse_path = /datum/hag_boon/trait/curse/ugly

/datum/hag_rite/ugly
	name = "The Rite of relative beauty"
	desc = "Forces all mortals to be ugly."
	curse_path = /datum/hag_boon/trait/curse/ugly
