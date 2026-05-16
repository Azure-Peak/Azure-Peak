GLOBAL_LIST_EMPTY(outlawed_players)
GLOBAL_LIST_EMPTY(lord_decrees)
GLOBAL_LIST_EMPTY(court_agents)
GLOBAL_LIST_EMPTY(court_spymaster)
GLOBAL_LIST_INIT(laws_of_the_land, initialize_laws_of_the_land())
GLOBAL_VAR_INIT(last_crown_announcement_time, -1000)

/proc/initialize_laws_of_the_land()
	var/list/laws = strings("laws_of_the_land.json", "lawsets")
	var/list/lawsets_weighted = list()
	for(var/lawset_name as anything in laws)
		var/list/lawset = laws[lawset_name]
		lawsets_weighted[lawset_name] = lawset["weight"]
	var/chosen_lawset = pickweight(lawsets_weighted)
	return laws[chosen_lawset]["laws"]

/obj/structure/roguemachine/titan
	name = "throat"
	desc = "He who wears the crown holds the key to this strange thing. If all else fails, demand the \"secrets of the throat!\""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.5
	max_integrity = 0
	anchored = TRUE
	var/mode = 0
	var/list/rite_selection_data
	var/mob/living/carbon/human/rite_selector

/obj/structure/roguemachine/titan/obj_break(damage_flag)
	..()
	cut_overlays()
//	icon_state = "[icon_state]-br"
	set_light(0)
	return

/obj/structure/roguemachine/titan/Destroy()
	lose_hearing_sensitivity()
	set_light(0)
	if(GLOB.ducal_court_throat == src)
		GLOB.ducal_court_throat = null
	return ..()

/obj/structure/roguemachine/titan/Initialize()
	. = ..()
	icon_state = null
	if(!GLOB.ducal_court_throat)
		GLOB.ducal_court_throat = src
	become_hearing_sensitive()
//	var/mutable_appearance/eye_lights = mutable_appearance(icon, "titan-eyes")
//	eye_lights.plane = ABOVE_LIGHTING_PLANE //glowy eyes
//	eye_lights.layer = ABOVE_LIGHTING_LAYER
//	add_overlay(eye_lights)
	set_light(5)

/obj/structure/roguemachine/titan/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, message)
//	. = ..()
	if(speaker == src)
		return
	if(speaker.loc != loc)
		return
	if(obj_broken)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	var/nocrown
	if(!istype(H.head, /obj/item/clothing/head/roguetown/crown/serpcrown))
		nocrown = TRUE
	var/notlord = TRUE
	if(SSticker.rulermob == H || SSticker.regentmob == H)
		notlord = FALSE

	if(mode)
		if(findtext(message, "nevermind"))
			mode = 0
			return
	
	if(findtext(message, "summon crown")) //This must never fail, thus place it before all other modestuffs.
		try_summon_crown(H)
		return

	if(findtext(message, "summon key"))
		try_summon_key(H)
		return

	if(findtext(message, "i ascend"))
		start_ascension(H)
		return

	switch(mode)
		if(0)
			if(findtext(message, "secrets of the throat"))
				say("My commands are: Make Decree, Make Announcement, Set Taxes, Revise Charter, Declare Outlaw, Summon Crown, Summon Key, Set Laws, Make Law, Remove Law, Purge Laws, Purge Decrees, Become Regent, Change Colors, I Ascend, Nevermind")
				playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)
			if(findtext(message, "make announcement"))
				if(nocrown)
					say("You need the crown.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if (world.time < GLOB.last_crown_announcement_time + 2 MINUTES)
					say(("Tis not yet time for another announcement my liege."))
					return
				if(!SScommunications.can_announce(H))
					say("I must gather my strength!")
					return
				say("Speak and they will listen.")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 1
				return
			if(findtext(message, "make decree"))
				if(!SScommunications.can_announce(H))
					say("I must gather my strength!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("You are not my master!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Speak and they will obey.")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 2
				return
			if(findtext(message, "purge decrees"))
				if(!SScommunications.can_announce(H))
					say("I must gather my strength!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("You are not my master!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("All decrees shall be purged!")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				purge_decrees()
				return
			if(findtext(message, "make law"))
				if(!SScommunications.can_announce(H))
					say("I must gather my strength!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("You are not my master!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Speak and they will obey.")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 4
				return
			if(findtext(message, "set laws"))
				if(!SScommunications.can_announce(H))
					say("I must gather my strength!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("You are not my master!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("The new laws shall be as such...")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				give_law_popup(H)
				return
			if(findtext(message, "purge laws"))
				if(!SScommunications.can_announce(H))
					say("I must gather my strength!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("You are not my master!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("All laws shall be purged!")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				purge_laws()
				return
			if(findtext(message, "declare outlaw"))
				if(notlord || nocrown)
					say("You are not my master!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Who should be outlawed?")
				playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
				mode = 3
				return
			if(findtext(message, "set taxes"))
				if(notlord || nocrown)
					say("You are not my master!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("The new tax percent shall be...")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				give_tax_popup(H)
				return
			if(findtext(message, "revise charter"))
				if(notlord || nocrown)
					say("You are not my master!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("The charters of the realm lay before thee...")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				give_decree_popup(H)
				return
			if(findtext(message, "become regent"))
				if(nocrown)
					say("You need the crown.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(SSticker.rulermob && SSticker.rulermob == H) //failsafe for edge cases
					say("No others share the throne with you, master.")
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					SSticker.regentmob = null
					return
				var/mob/living/current_lord = SSticker.rulermob
				if(current_lord && !QDELETED(current_lord) && current_lord.stat != DEAD)
					say("The true lord is already present in the realm.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(!(HAS_TRAIT(H, TRAIT_NOBLE)))
					say("You have not the noble blood to be regent.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(!(H.job in GLOB.regency_positions))
					say("You are not worthy of bearing the Crown.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(SSticker.regentday == GLOB.dayspassed)
					say("A regent has already been declared this dae!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(SSticker.regentmob == H)
					say("You are already the regent!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				become_regent(H)
				return
			if(findtext(message, "change colors"))
				if(notlord || nocrown)
					say("You are not my master!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Choose the colors of your realm, my liege.")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				H.lord_color_choice()
				return

		if(1)
			make_announcement(H, raw_message)
			mode = 0
		if(2)
			make_decree(H, raw_message)
			mode = 0
		if(3)
			declare_outlaw(H, raw_message)
			mode = 0
		if(4)
			if(!SScommunications.can_announce(speaker))
				return
			make_law(raw_message)
			mode = 0

/obj/structure/roguemachine/titan/proc/summon_crown()
	var/obj/item/clothing/head/roguetown/crown/serpcrown/I = SSroguemachine.crown

	if(I)
		I.anti_stall()
	
	I = new /obj/item/clothing/head/roguetown/crown/serpcrown(src.loc)
	SSroguemachine.crown = I

	say("The crown is summoned!")
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)

	return I

/obj/structure/roguemachine/titan/proc/try_summon_crown(mob/living/carbon/human/user)
	var/notlord = !(SSticker.rulermob == user || SSticker.regentmob == user)
	var/obj/item/clothing/head/roguetown/crown/serpcrown/I = SSroguemachine.crown

	// If no crown exists.
	if(!I)
		summon_crown()
		return TRUE

	var/mob/M = get_containing_mob(I)

	// Not contained by anyone => summonable, except for the vault protection.
	if(!M)
		var/area/crown_area = get_area(I)
		if(crown_area && istype(crown_area, /area/rogue/indoors/town/vault) && notlord)
			say("The crown is within the vault.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return FALSE
		summon_crown()
		return TRUE

	if(ishuman(M))
		var/mob/living/carbon/human/HC = M

		// Dead holders cannot block retrieval.
		if(HC.stat == DEAD)
			HC.dropItemToGround(I, TRUE)
			summon_crown()
			return TRUE

		// Ruler/regent blocks even if stowed/held.
		if(SSticker.rulermob == HC || SSticker.regentmob == HC)
			if(I in HC.held_items)
				say("Master [HC.real_name] holds the crown!")
			else if(HC.head == I)
				say("Master [HC.real_name] wears the crown!")
			else
				say("Master [HC.real_name] has the crown stowed away!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return FALSE

		// Non-lords block only if worn.
		if(HC.head == I)
			say("[HC.real_name] wears the crown!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return FALSE

	summon_crown()
	return TRUE

/obj/structure/roguemachine/titan/proc/try_summon_key(mob/living/carbon/human/user)
	if(!istype(user.head, /obj/item/clothing/head/roguetown/crown/serpcrown))
		say("You need the crown.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return FALSE
	if(!SSroguemachine.key)
		new /obj/item/roguekey/lord(src.loc)
		say("The key is summoned!")
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return TRUE
	if(SSroguemachine.key)
		var/obj/item/roguekey/lord/I = SSroguemachine.key
		if(!I)
			I = new /obj/item/roguekey/lord(src.loc)
		if(I && !ismob(I.loc))
			I.anti_stall()
			I = new /obj/item/roguekey/lord(src.loc)
			say("The key is summoned!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			return TRUE
		if(ishuman(I.loc))
			var/mob/living/carbon/human/HC = I.loc
			if(HC.stat != DEAD)
				say("[HC.real_name] holds the key!")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				return FALSE
			else
				HC.dropItemToGround(I, TRUE) // If you're dead, forcedrop it, then move it.
		I.forceMove(src.loc)
		say("The key is summoned!")
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return TRUE
	return FALSE

/obj/structure/roguemachine/titan/proc/give_tax_popup(mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	var/datum/taxsetter/taxsetter = new("The Generous Lord Decrees")
	taxsetter.ui_interact(user)

/obj/structure/roguemachine/titan/proc/give_law_popup(mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	var/datum/laws_menu/lawmenu = new
	lawmenu.ui_interact(user)

/obj/structure/roguemachine/titan/proc/give_decree_popup(mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	var/datum/decree_setter/panel = new
	panel.ui_interact(user)

/obj/structure/roguemachine/titan/proc/make_announcement(mob/living/user, raw_message)
	if(!SScommunications.can_announce(user))
		return
	try_make_rebel_decree(user)

	SScommunications.make_announcement(user, FALSE, raw_message)
	GLOB.last_crown_announcement_time = world.time 

/obj/structure/roguemachine/titan/proc/try_make_rebel_decree(mob/living/user)
	if(!SScommunications.can_announce(user))
		return
	var/datum/antagonist/prebel/P = user.mind?.has_antag_datum(/datum/antagonist/prebel)
	if(P)
		if(P.rev_team)
			if(P.rev_team.members.len < 3)
				to_chat(user, "<span class='warning'>I need more folk on my side to declare victory.</span>")
			else
				for(var/datum/objective/prebel/obj in user.mind.get_all_objectives())
					obj.completed = TRUE
				if(!SSmapping.retainer.head_rebel_decree)
					user.mind.adjust_triumphs(1)
				SSmapping.retainer.head_rebel_decree = TRUE

/obj/structure/roguemachine/titan/proc/make_decree(mob/living/user, raw_message)
	var/datum/antagonist/prebel/rebel_datum = user.mind?.has_antag_datum(/datum/antagonist/prebel)
	if(rebel_datum)
		if(rebel_datum.rev_team?.members.len < 3)
			to_chat(user, "<span class='warning'>I need more folk on my side to declare victory.</span>")
		else
			for(var/datum/objective/prebel/obj in user.mind.get_all_objectives())
				obj.completed = TRUE
			if(!SSmapping.retainer.head_rebel_decree)
				user.mind.adjust_triumphs(1)
			SSmapping.retainer.head_rebel_decree = TRUE
	record_round_statistic(STATS_LAWS_AND_DECREES_MADE)
	SScommunications.make_announcement(user, TRUE, raw_message)

/obj/structure/roguemachine/titan/proc/declare_outlaw(mob/living/user, raw_message)
	if(!SScommunications.can_announce(user))
		return
	if(user.job)
		if(!istype(SSjob.GetJob(user.job), /datum/job/roguetown/lord))
			return
	else
		return
	return make_outlaw(raw_message)

/proc/get_containing_mob(atom/A) // Returns the mob that ultimately contains A (A in bag in clothing in mob, etc.), or null.
	var/atom/current = A
	var/safety = 0
	while(current && safety++ < 30)
		if(ismob(current))
			return current
		current = current.loc
	return null

/proc/make_outlaw(raw_message)
	// Strip trailing punctuation/whitespace from typed input ("Eduard." -> "Eduard")
	raw_message = trim(raw_message)
	while(length(raw_message))
		var/last_char = copytext(raw_message, length(raw_message))
		if(!(last_char in list(".", ",", "!", "?", ";", ":")))
			break
		raw_message = copytext(raw_message, 1, length(raw_message))
	var/mob/living/carbon/human/found_human
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.real_name == raw_message)
			found_human = H
			break
	if(raw_message in GLOB.outlawed_players)
		GLOB.outlawed_players -= raw_message
		priority_announce("[raw_message] is no longer an outlaw in [SSticker.realm_name].", "The [SSticker.rulertype] Decrees", 'sound/misc/royal_decree.ogg', "Captain")
		if(istype(found_human))
			REMOVE_TRAIT(found_human, TRAIT_OUTLAW, TRAIT_GENERIC)
			if(HAS_TRAIT(found_human, TRAIT_GUARDSMAN_DISGRACED))
				REMOVE_TRAIT(found_human, TRAIT_GUARDSMAN_DISGRACED, TRAIT_GENERIC)
				ADD_TRAIT(found_human, TRAIT_GUARDSMAN, JOB_TRAIT)
				found_human.remove_status_effect(/datum/status_effect/debuff/disgracedguardsman)
		return FALSE
	if(!found_human)
		return FALSE
	GLOB.outlawed_players += raw_message
	ADD_TRAIT(found_human, TRAIT_OUTLAW, TRAIT_GENERIC)
	priority_announce("[raw_message] has been declared an outlaw and must be captured or slain.", "The [SSticker.rulertype] Decrees", 'sound/misc/royal_decree2.ogg', "Captain")
	if(HAS_TRAIT(found_human, TRAIT_GUARDSMAN))
		REMOVE_TRAIT(found_human, TRAIT_GUARDSMAN, JOB_TRAIT)
		ADD_TRAIT(found_human, TRAIT_GUARDSMAN_DISGRACED, TRAIT_GENERIC)
		found_human.apply_status_effect(/datum/status_effect/debuff/disgracedguardsman)
	return TRUE

/proc/make_law(raw_message)
	GLOB.laws_of_the_land += raw_message
	priority_announce("[length(GLOB.laws_of_the_land)]. [raw_message]", "A LAW IS DECLARED", pick('sound/misc/new_law.ogg', 'sound/misc/new_law2.ogg'), "Captain")
	record_round_statistic(STATS_LAWS_AND_DECREES_MADE)

/proc/remove_law(law_index)
	if(!GLOB.laws_of_the_land[law_index])
		return
	var/law_text = GLOB.laws_of_the_land[law_index]
	GLOB.laws_of_the_land -= law_text
	priority_announce("[law_index]. [law_text]", "A LAW IS ABOLISHED", pick('sound/misc/new_law.ogg', 'sound/misc/new_law2.ogg'), "Captain")
	record_round_statistic(STATS_LAWS_AND_DECREES_MADE, -1)

/proc/purge_laws()
	GLOB.laws_of_the_land = list()
	priority_announce("All laws of the land have been purged!", "LAWS PURGED", 'sound/misc/lawspurged.ogg', "Captain")

/proc/purge_decrees()
	GLOB.lord_decrees = list()
	priority_announce("All of the land's prior decrees have been purged!", "DECREES PURGED", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain")

/proc/become_regent(mob/living/carbon/human/H)
	priority_announce("[H.name], the [H.get_role_title()], sits as the regent of the realm.", "A New Regent Resides", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain")
	SSticker.regentmob = H
	SSticker.regentday = GLOB.dayspassed

/obj/structure/roguemachine/titan/proc/start_ascension(mob/living/carbon/human/user)
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	if(!throne)
		say("There is no throne to claim.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(throne.active_rite)
		say("A rite of succession is already underway.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!SSticker.had_ruler)
		say("There is no ruler to usurp.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(SSticker.rulermob == user)
		say("You already hold the throne.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(SSgamemode.roundvoteend)
		say("The realm's fate is already sealed. It is too late for a change of power.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	// TESTING: Disabled chain coup cooldown
	// if(SSticker.usurpation_day == GLOB.dayspassed)
	// 	say("The realm has already seen a change of power this dae. Let the dust settle.")
	// 	playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
	// 	return

	var/list/all_rites = list()
	var/any_eligible = FALSE
	for(var/rite_type in get_usurpation_rite_types())
		var/datum/usurpation_rite/temp = new rite_type()
		var/can_use = temp.can_invoke(user)
		if(can_use)
			any_eligible = TRUE
		all_rites += list(list(
			"name" = temp.name,
			"desc" = temp.desc,
			"explanation" = temp.explanation,
			"type_path" = "[rite_type]",
			"eligible" = can_use,
		))
		qdel(temp)

	if(!any_eligible)
		say("No rites of succession are available to you.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	rite_selection_data = all_rites
	rite_selector = user
	ui_interact(user)

/obj/structure/roguemachine/titan/proc/on_rite_chosen(mob/living/carbon/human/user, rite_type_path)
	rite_selection_data = null
	rite_selector = null

	if(QDELETED(user) || user.stat != CONSCIOUS)
		return
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	if(!throne)
		return
	if(throne.active_rite)
		say("A rite has already begun.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	var/datum/usurpation_rite/new_rite = new rite_type_path()
	throne.active_rite = new_rite
	new_rite.begin(user)
	say("So it begins.")
	playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/titan/proc/get_usurpation_rite_types()
	var/static/list/available_rites = list(
		/datum/usurpation_rite/solar_succession,
		/datum/usurpation_rite/lunar_ascension,
		/datum/usurpation_rite/martial_supercession,
		/datum/usurpation_rite/golden_accord,
		/datum/usurpation_rite/sacred_supercession,
		/datum/usurpation_rite/progressive_dominion,
		/datum/usurpation_rite/popular_acclaim,
		/datum/usurpation_rite/psydonian_tribunal,
	)
	return available_rites

/obj/structure/roguemachine/titan/proc/has_available_usurpation_rite(mob/living/carbon/human/user)
	for(var/rite_type in get_usurpation_rite_types())
		var/datum/usurpation_rite/temp = new rite_type()
		var/can_use = temp.can_invoke(user)
		qdel(temp)
		if(can_use)
			return TRUE
	return FALSE

/obj/structure/roguemachine/titan/proc/ducal_court_texts()
	return list(
		"window_title" = "Ducal Court",
		"subtitle" = "Hold court from the throne of Azure Peak",
		"sections" = list(
			"status" = "Court Status",
			"map" = "Ducal Demesne Map",
			"main" = "Court Business",
			"tools" = "Ducal Tools",
			"succession" = "Succession and Usurpation",
			"desk" = "Court Scribe Desk",
		),
		"composer" = list(
			"placeholder" = "Draft an announcement, decree, or new law...",
			"publish_announcement" = "Publish Announcement",
			"publish_decree" = "Issue Decree",
			"publish_law" = "Add Law",
			"law_number" = "Law #",
			"remove_law" = "Remove Law",
			"clear_laws" = "Clear All Laws",
			"empty_text" = "Write text before publishing.",
		),
		"labels" = list(
			"ruler" = "Current Ruler",
			"regent" = "Regent",
			"claimant" = "Claimant",
			"contester" = "Contester",
			"supporters" = "Supporters",
			"time_remaining" = "Time Remaining",
			"rite_status" = "Rite Status",
			"no_regent" = "None",
			"none" = "None",
			"viewer" = "Your Standing",
			"requirements" = "Requirements",
		),
		"rite_steps" = list("Gathering", "Contesting", "Resolution"),
		"map_legend" = list(
			list("label" = "Crown seat", "class_name" = "crown"),
			list("label" = "Forest musters", "class_name" = "forest"),
			list("label" = "Sea and basin", "class_name" = "water"),
			list("label" = "Mountain roads", "class_name" = "mountain"),
		),
		"map_points" = list(
			list("id" = "azure_peak", "label" = "Azure Peak", "x" = 58, "y" = 62, "type" = "keep"),
			list("id" = "azure_enclave", "label" = "Azure Enclave", "x" = 29, "y" = 43, "type" = "forest"),
			list("id" = "azure_basin", "label" = "Azure Basin", "x" = 76, "y" = 70, "type" = "water"),
			list("id" = "plateaus", "label" = "Southern Plateaus", "x" = 52, "y" = 78, "type" = "mountain"),
			list("id" = "western_woods", "label" = "Western Woods", "x" = 19, "y" = 57, "type" = "forest"),
		),
	)

/obj/structure/roguemachine/titan/proc/format_ducal_court_time(seconds)
	seconds = max(round(seconds), 0)
	var/minutes = FLOOR(seconds / 60, 1)
	var/remaining_seconds = seconds % 60
	if(minutes > 0)
		return "[minutes]m [remaining_seconds]s"
	return "[remaining_seconds]s"

/obj/structure/roguemachine/titan/proc/user_has_crown(mob/living/carbon/human/user)
	return istype(user?.head, /obj/item/clothing/head/roguetown/crown/serpcrown)

/obj/structure/roguemachine/titan/proc/user_has_ducal_authority(mob/living/carbon/human/user)
	return SSticker.rulermob == user || SSticker.regentmob == user

/obj/structure/roguemachine/titan/proc/user_has_lord_job(mob/living/carbon/human/user)
	if(!user?.job)
		return FALSE
	return istype(SSjob.GetJob(user.job), /datum/job/roguetown/lord)

/obj/structure/roguemachine/titan/proc/user_near_throne(mob/living/carbon/human/user)
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	return throne && get_dist(user, throne) <= RITE_ASSENT_RANGE

/obj/structure/roguemachine/titan/proc/ducal_court_mob_name(mob/person, fallback = null)
	if(!person)
		return fallback
	return person.real_name || person.name || fallback

/obj/structure/roguemachine/titan/proc/get_ducal_court_colors()
	return list(
		"primary" = GLOB.lordprimary || "#007fff",
		"secondary" = GLOB.lordsecondary || "#ffffff",
		"fallback" = !(GLOB.lordprimary && GLOB.lordsecondary),
	)

/obj/structure/roguemachine/titan/proc/ducal_court_action_blocker(mob/living/carbon/human/user, action)
	if(!istype(user))
		return "Only a living subject may use the ducal court."

	var/has_crown = user_has_crown(user)
	var/has_authority = user_has_ducal_authority(user)
	var/can_announce = SScommunications.can_announce(user)
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	var/datum/usurpation_rite/rite = throne?.active_rite

	switch(action)
		if("summon_crown")
			return null
		if("summon_key")
			if(!has_crown)
				return "Requires the crown."
			return null
		if("make_announcement")
			if(!has_crown)
				return "Requires the crown."
			if(world.time < GLOB.last_crown_announcement_time + 2 MINUTES)
				return "Another ducal announcement is not ready yet."
			if(!can_announce)
				return "The Throat is still gathering strength."
			return null
		if("revise_charter", "restore_charter", "set_taxes", "change_colors")
			if(!has_crown)
				return "Requires the crown."
			if(!has_authority)
				return "Ruler or regent only."
			return null
		if("issue_decree", "set_laws", "make_law", "purge_laws", "purge_decrees")
			if(!has_crown)
				return "Requires the crown."
			if(!has_authority)
				return "Ruler or regent only."
			if(!can_announce)
				return "The Throat is still gathering strength."
			return null
		if("declare_outlaw")
			if(!has_crown)
				return "Requires the crown."
			if(!has_authority)
				return "Ruler or regent only."
			if(!user_has_lord_job(user))
				return "Declaring an outlaw currently requires the ruling office."
			if(!can_announce)
				return "The Throat is still gathering strength."
			return null
		if("ascend")
			if(!throne)
				return "There is no throne to claim."
			if(rite)
				return "A rite of succession is already underway."
			if(!SSticker.had_ruler)
				return "There is no ruler to usurp."
			if(SSticker.rulermob == user)
				return "You already hold the throne."
			if(SSgamemode.roundvoteend)
				return "The realm's fate is already sealed."
			if(!has_available_usurpation_rite(user))
				return "No rites of succession are available to you."
			return null
		if("assent")
			if(!rite)
				return "No active succession needs assent."
			if(rite.stage != RITE_STAGE_GATHERING)
				return "Assent is only accepted during gathering."
			if(!user_near_throne(user))
				return "Stand near the throne to assent."
			return null
		if("abdicate")
			if(!rite)
				return "No active claim can receive abdication."
			if(rite.stage >= RITE_STAGE_CONTESTING)
				return "The rite is already being contested."
			if(!has_authority)
				return "Only the ruler or regent may abdicate."
			if(!user_near_throne(user))
				return "Stand near the throne to abdicate."
			return null
		if("stop_ascent")
			if(!rite)
				return "No active ascent can be halted."
			if(rite.stage != RITE_STAGE_CONTESTING)
				return "Stop Ascent is used during contesting."
			if(rite.contester)
				return "Someone is already contesting from the throne."
			if(!throne || !(user in throne.buckled_mobs))
				return "Sit on the throne to halt succession."
			return null
		if("become_regent")
			if(!has_crown)
				return "Requires the crown."
			if(SSticker.rulermob == user)
				return "You already hold the throne."
			var/mob/living/current_lord = SSticker.rulermob
			if(current_lord && !QDELETED(current_lord) && current_lord.stat != DEAD)
				return "The true lord is already present in the realm."
			if(!HAS_TRAIT(user, TRAIT_NOBLE))
				return "Requires noble blood."
			if(!(user.job in GLOB.regency_positions))
				return "Your office cannot bear the Crown as regent."
			if(SSticker.regentday == GLOB.dayspassed)
				return "A regent has already been declared today."
			if(SSticker.regentmob == user)
				return "You are already the regent."
			return null
	return "Unknown ducal court action."

/obj/structure/roguemachine/titan/proc/reject_ducal_court_action(mob/living/carbon/human/user, action)
	var/reason = ducal_court_action_blocker(user, action)
	if(!reason)
		return FALSE
	to_chat(user, span_warning(reason))
	playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
	return TRUE

/obj/structure/roguemachine/titan/proc/ducal_court_action_data(mob/living/carbon/human/user, id, label, desc, list/requirements)
	var/blocker = ducal_court_action_blocker(user, id)
	return list(
		"id" = id,
		"label" = label,
		"desc" = desc,
		"requirements" = requirements || list(),
		"enabled" = !blocker,
		"disabled_reason" = blocker,
	)

/obj/structure/roguemachine/titan/proc/get_ducal_court_text_param(list/params, key = "text", max_len = MAX_MESSAGE_LEN)
	var/text = params[key]
	if(!istext(text))
		return null
	text = trim(text)
	if(!length(text))
		return null
	return copytext(text, 1, max_len + 1)

/obj/structure/roguemachine/titan/proc/get_ducal_court_prompt_text(mob/living/carbon/human/user, message, title)
	var/text = tgui_input_text(user, message, title, max_length = MAX_MESSAGE_LEN, multiline = TRUE, bigmodal = TRUE)
	if(!text)
		return null
	text = trim(text)
	if(!length(text))
		return null
	return copytext(text, 1, MAX_MESSAGE_LEN + 1)

/obj/structure/roguemachine/titan/proc/get_throne_rite_data()
	var/list/rite_data = list(
		"active" = FALSE,
		"name" = "None",
		"stage" = "none",
		"stage_label" = "None",
		"status" = "No active succession.",
		"claimant" = null,
		"contester" = null,
		"supporters" = 0,
		"time_remaining" = null,
	)
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	var/datum/usurpation_rite/rite = throne?.active_rite
	if(!rite)
		return rite_data

	var/stage = "none"
	var/stage_label = "None"
	var/time_remaining
	switch(rite.stage)
		if(RITE_STAGE_GATHERING)
			stage = "gathering"
			stage_label = "Gathering"
			time_remaining = format_ducal_court_time(max(round((RITE_GATHERING_DURATION - (world.time - rite.started_at)) / (1 SECONDS)), 0))
		if(RITE_STAGE_CONTESTING)
			stage = "contesting"
			stage_label = rite.contester ? "Contesting - Paused" : "Contesting"
			if(rite.contester)
				time_remaining = format_ducal_court_time(round(rite.contest_time_remaining / (1 SECONDS)))
			else
				var/elapsed = world.time - rite.contest_started_at
				time_remaining = format_ducal_court_time(max(round((rite.contest_time_remaining - elapsed) / (1 SECONDS)), 0))
		if(RITE_STAGE_COMPLETE)
			stage = "resolution"
			stage_label = "Resolution"

	rite_data["active"] = TRUE
	rite_data["name"] = rite.name
	rite_data["stage"] = stage
	rite_data["stage_label"] = stage_label
	rite_data["status"] = rite.get_status_text() || "A claim is active."
	rite_data["claimant"] = rite.invoker?.real_name
	rite_data["contester"] = rite.contester?.real_name
	rite_data["supporters"] = length(rite.assenters)
	rite_data["time_remaining"] = time_remaining
	return rite_data

/obj/structure/roguemachine/titan/proc/get_ducal_court_status_cards(mob/living/carbon/human/user)
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	var/occupied = length(throne?.buckled_mobs)
	var/mob/occupant = occupied ? throne.buckled_mobs[1] : null
	var/mob/ruler = SSticker.rulermob
	var/mob/regent = SSticker.regentmob
	var/list/rite_data = get_throne_rite_data()
	var/rebel_progress = throne ? clamp(round((throne.rebel_leader_sit_time / REBEL_THRONE_TIME) * 100), 0, 100) : 0
	var/stability = "Stable"
	if(rite_data["stage"] == "gathering")
		stability = "Claim Gathering"
	else if(rite_data["stage"] == "contesting")
		stability = "Contested"
	else if(rebel_progress >= 100)
		stability = "Rebel Victory Ready"
	else if(rebel_progress > 0)
		stability = "Rebel Pressure"

	return list(
		list(
			"id" = "throne_status",
			"label" = "Throne Status",
			"value" = occupied ? "Occupied" : "Empty",
			"detail" = occupied ? ducal_court_mob_name(occupant, "Unknown occupant") : "No one is seated.",
			"tone" = occupied ? "good" : "neutral",
		),
		list(
			"id" = "crown_required",
			"label" = "Crown Authority",
			"value" = user_has_crown(user) ? "Crown Worn" : "Crown Missing",
			"detail" = user_has_crown(user) ? "Ducal commands are unlocked by the crown." : "Most commands require the crown.",
			"tone" = user_has_crown(user) ? "good" : "bad",
		),
		list(
			"id" = "active_rite",
			"label" = "Active Rite",
			"value" = rite_data["stage_label"],
			"detail" = rite_data["name"],
			"tone" = rite_data["active"] ? "warning" : "good",
		),
		list(
			"id" = "realm_stability",
			"label" = "Realm Stability",
			"value" = stability,
			"detail" = "Rebel pressure: [rebel_progress]%",
			"tone" = (rite_data["active"] || rebel_progress >= 60) ? "warning" : "good",
		),
		list(
			"id" = "current_ruler",
			"label" = "Current Ruler",
			"value" = ducal_court_mob_name(ruler, "None"),
			"detail" = regent ? "Regent: [ducal_court_mob_name(regent)]" : "No active regent.",
			"tone" = ruler ? "good" : "warning",
		),
	)

/obj/structure/roguemachine/titan/proc/get_ducal_court_callouts(mob/living/carbon/human/user)
	var/list/rite_data = get_throne_rite_data()
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	var/rebel_progress = throne ? clamp(round((throne.rebel_leader_sit_time / REBEL_THRONE_TIME) * 100), 0, 100) : 0
	var/list/callouts = list()
	callouts += list(list(
		"text" = user_has_ducal_authority(user) ? "You hold ducal authority." : "You do not hold ducal authority.",
		"tone" = user_has_ducal_authority(user) ? "good" : "neutral",
	))
	callouts += list(list(
		"text" = rite_data["active"] ? rite_data["status"] : "No active succession.",
		"tone" = rite_data["active"] ? "warning" : "good",
	))
	callouts += list(list(
		"text" = rebel_progress > 0 ? "Rebel pressure is visible at the throne." : "No rebel pressure at the throne.",
		"tone" = rebel_progress > 0 ? "warning" : "good",
	))
	return callouts

/obj/structure/roguemachine/titan/proc/get_ducal_court_actions(mob/living/carbon/human/user)
	return list(
		"main" = list(
			ducal_court_action_data(user, "make_announcement", "Make Announcement", "Broadcast a realm-wide message.", list("Crown", "Broadcast Ready")),
			ducal_court_action_data(user, "revise_charter", "Revise Charter", "Open the charter ledger.", list("Crown", "Ruler/Regent")),
			ducal_court_action_data(user, "issue_decree", "Issue Decree", "Proclaim a ducal decree.", list("Crown", "Ruler/Regent", "Broadcast Ready")),
			ducal_court_action_data(user, "set_laws", "Set Laws", "Rewrite the laws of the land.", list("Crown", "Ruler/Regent", "Broadcast Ready")),
			ducal_court_action_data(user, "set_taxes", "Set Taxes", "Adjust levies and poll taxes.", list("Crown", "Ruler/Regent")),
			ducal_court_action_data(user, "declare_outlaw", "Declare Outlaw", "Outlaw or pardon a named subject.", list("Crown", "Ruling Office", "Broadcast Ready")),
		),
		"tools" = list(
			ducal_court_action_data(user, "change_colors", "Change Colors", "Change the ducal colors.", list("Crown", "Ruler/Regent")),
			ducal_court_action_data(user, "summon_crown", "Summon Crown", "Retrieve the crown if law permits.", list("Throat")),
			ducal_court_action_data(user, "summon_key", "Summon Key", "Retrieve the ducal key.", list("Crown")),
			ducal_court_action_data(user, "restore_charter", "Restore Charter", "Open charters to restore suspended writs.", list("Crown", "Ruler/Regent")),
			ducal_court_action_data(user, "purge_laws", "Purge Laws", "Remove every current law.", list("Crown", "Ruler/Regent", "Broadcast Ready")),
			ducal_court_action_data(user, "purge_decrees", "Purge Decrees", "Remove every decree.", list("Crown", "Ruler/Regent", "Broadcast Ready")),
			ducal_court_action_data(user, "become_regent", "Become Regent", "Claim regency when the ruler is absent.", list("Crown", "Noble Blood", "Regency Office")),
		),
		"rites" = list(
			ducal_court_action_data(user, "ascend", "I Ascend", "Invoke a rite of succession.", list("Eligible Rite")),
			ducal_court_action_data(user, "assent", "I Assent", "Support an active claim near the throne.", list("Active Gathering", "Near Throne")),
			ducal_court_action_data(user, "abdicate", "I Abdicate", "Yield the throne and skip to contestation.", list("Ruler/Regent", "Near Throne")),
			ducal_court_action_data(user, "stop_ascent", "Stop Ascent", "Sit on the throne to halt succession.", list("Contesting", "Seated")),
		),
	)

/obj/structure/roguemachine/titan/ui_interact(mob/user, datum/tgui/ui)
	var/show_rite_selection = rite_selection_data && (!rite_selector || rite_selector == user)
	var/interface = show_rite_selection ? "RiteSelection" : "DucalCourt"
	var/title = show_rite_selection ? "Rites of Succession" : "Ducal Court"
	if(!ui)
		ui = SStgui.get_open_ui(user, src)
	if(ui && ui.interface != interface)
		ui.close()
		ui = null
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface, title)
		ui.open()

/obj/structure/roguemachine/titan/ui_static_data(mob/user)
	var/list/data = ..()
	data["texts"] = ducal_court_texts()
	return data

/obj/structure/roguemachine/titan/ui_data(mob/user)
	var/list/data = ..()
	data["rites"] = rite_selection_data
	var/list/rite_data = get_throne_rite_data()
	data["realm_name"] = SSticker.realm_name || "Azure Peak"
	data["realm_type"] = SSticker.realm_type || "Realm"
	var/mob/ruler = SSticker.rulermob
	var/mob/regent = SSticker.regentmob
	data["ruler"] = ducal_court_mob_name(ruler)
	data["regent"] = ducal_court_mob_name(regent)
	data["realm_colors"] = get_ducal_court_colors()
	data["rite"] = rite_data
	data["law_count"] = length(GLOB.laws_of_the_land)
	data["decree_count"] = length(GLOB.lord_decrees)
	if(!ishuman(user))
		data["viewer_status"] = "Observer"
		data["status_cards"] = list()
		data["callouts"] = list()
		data["main_actions"] = list()
		data["tool_actions"] = list()
		data["rite_actions"] = list()
		return data
	var/mob/living/carbon/human/H = user
	var/list/actions = get_ducal_court_actions(H)
	data["viewer_status"] = user_has_ducal_authority(H) ? "Ducal Authority" : (user_has_crown(H) ? "Crown Bearer" : "Subject")
	data["status_cards"] = get_ducal_court_status_cards(H)
	data["callouts"] = get_ducal_court_callouts(H)
	data["main_actions"] = actions["main"]
	data["tool_actions"] = actions["tools"]
	data["rite_actions"] = actions["rites"]
	return data

/obj/structure/roguemachine/titan/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	if(!ishuman(ui.user))
		return FALSE
	var/mob/living/carbon/human/user = ui.user
	switch(action)
		if("choose_rite")
			if(rite_selector && rite_selector != user)
				return TRUE
			var/type_path = text2path(params["type_path"])
			if(!type_path)
				return TRUE
			ui.close()
			on_rite_chosen(user, type_path)
			return TRUE
		if("make_announcement")
			if(reject_ducal_court_action(user, "make_announcement"))
				return TRUE
			var/text = get_ducal_court_prompt_text(user, "What shall be announced to the realm?", "Make Announcement")
			if(text && !reject_ducal_court_action(user, "make_announcement"))
				make_announcement(user, text)
			return TRUE
		if("publish_announcement")
			if(reject_ducal_court_action(user, "make_announcement"))
				return TRUE
			var/text = get_ducal_court_text_param(params)
			if(text)
				make_announcement(user, text)
			return TRUE
		if("issue_decree")
			if(reject_ducal_court_action(user, "issue_decree"))
				return TRUE
			var/text = get_ducal_court_prompt_text(user, "What decree shall be issued?", "Issue Decree")
			if(text && !reject_ducal_court_action(user, "issue_decree"))
				make_decree(user, text)
			return TRUE
		if("publish_decree")
			if(reject_ducal_court_action(user, "issue_decree"))
				return TRUE
			var/text = get_ducal_court_text_param(params)
			if(text)
				make_decree(user, text)
			return TRUE
		if("make_law")
			if(reject_ducal_court_action(user, "make_law"))
				return TRUE
			var/text = get_ducal_court_prompt_text(user, "What law shall be added?", "Make Law")
			if(text && !reject_ducal_court_action(user, "make_law"))
				make_law(text)
			return TRUE
		if("publish_law")
			if(reject_ducal_court_action(user, "make_law"))
				return TRUE
			var/text = get_ducal_court_text_param(params, "text", 500)
			if(text)
				make_law(text)
			return TRUE
		if("remove_law")
			if(reject_ducal_court_action(user, "make_law"))
				return TRUE
			var/law_number = params["law_number"]
			if(!isnum(law_number))
				law_number = text2num("[law_number]")
			law_number = round(law_number)
			if(law_number < 1 || law_number > length(GLOB.laws_of_the_land))
				to_chat(user, span_warning("No law exists at that number."))
				return TRUE
			remove_law(law_number)
			return TRUE
		if("revise_charter", "restore_charter")
			if(reject_ducal_court_action(user, action))
				return TRUE
			give_decree_popup(user)
			return TRUE
		if("set_laws")
			if(reject_ducal_court_action(user, "set_laws"))
				return TRUE
			give_law_popup(user)
			return TRUE
		if("set_taxes")
			if(reject_ducal_court_action(user, "set_taxes"))
				return TRUE
			give_tax_popup(user)
			return TRUE
		if("declare_outlaw")
			if(reject_ducal_court_action(user, "declare_outlaw"))
				return TRUE
			var/text = get_ducal_court_prompt_text(user, "Who should be outlawed or pardoned?", "Declare Outlaw")
			if(text && !reject_ducal_court_action(user, "declare_outlaw"))
				declare_outlaw(user, text)
			return TRUE
		if("change_colors")
			if(reject_ducal_court_action(user, "change_colors"))
				return TRUE
			user.lord_color_choice()
			return TRUE
		if("summon_crown")
			try_summon_crown(user)
			return TRUE
		if("summon_key")
			if(reject_ducal_court_action(user, "summon_key"))
				return TRUE
			try_summon_key(user)
			return TRUE
		if("purge_laws")
			if(reject_ducal_court_action(user, "purge_laws"))
				return TRUE
			var/confirm = tgui_alert(user, "Purge every law of the land?", "Purge Laws", list("Purge", "Cancel"))
			if(confirm == "Purge" && !reject_ducal_court_action(user, "purge_laws"))
				purge_laws()
			return TRUE
		if("purge_decrees")
			if(reject_ducal_court_action(user, "purge_decrees"))
				return TRUE
			var/confirm = tgui_alert(user, "Purge every decree of the realm?", "Purge Decrees", list("Purge", "Cancel"))
			if(confirm == "Purge" && !reject_ducal_court_action(user, "purge_decrees"))
				purge_decrees()
			return TRUE
		if("ascend")
			if(reject_ducal_court_action(user, "ascend"))
				return TRUE
			start_ascension(user)
			return TRUE
		if("assent")
			if(reject_ducal_court_action(user, "assent"))
				return TRUE
			var/obj/structure/roguethrone/assent_throne = GLOB.king_throne
			var/datum/usurpation_rite/assent_rite = assent_throne ? assent_throne.active_rite : null
			if(assent_rite)
				assent_rite.try_assent(user)
			return TRUE
		if("abdicate")
			if(reject_ducal_court_action(user, "abdicate"))
				return TRUE
			var/obj/structure/roguethrone/abdicate_throne = GLOB.king_throne
			var/datum/usurpation_rite/abdicate_rite = abdicate_throne ? abdicate_throne.active_rite : null
			if(abdicate_rite)
				abdicate_rite.try_abdication(user)
			return TRUE
		if("stop_ascent")
			if(reject_ducal_court_action(user, "stop_ascent"))
				return TRUE
			var/obj/structure/roguethrone/stop_throne = GLOB.king_throne
			var/datum/usurpation_rite/stop_rite = stop_throne ? stop_throne.active_rite : null
			if(stop_rite)
				stop_rite.start_counter_claim(user)
			return TRUE
		if("become_regent")
			if(reject_ducal_court_action(user, "become_regent"))
				return TRUE
			become_regent(user)
			return TRUE
