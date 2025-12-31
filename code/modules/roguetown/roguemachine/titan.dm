GLOBAL_LIST_EMPTY(outlawed_players)
GLOBAL_LIST_EMPTY(lord_decrees)
GLOBAL_LIST_EMPTY(court_agents)
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

/obj/structure/roguemachine/titan/obj_break(damage_flag)
	..()
	cut_overlays()
//	icon_state = "[icon_state]-br"
	set_light(0)
	return

/obj/structure/roguemachine/titan/Destroy()
	lose_hearing_sensitivity()
	set_light(0)
	return ..()

/obj/structure/roguemachine/titan/Initialize()
	. = ..()
	icon_state = null
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
		var/obj/item/clothing/head/roguetown/crown/serpcrown/I = SSroguemachine.crown
		
		// If no crown exists
		if(!I)
			I = summon_crown()
			return

		var/mob/M = get_containing_mob(I)

		// Not contained by anyone => summonable (vault exception)
		if(!M)
			var/area/crown_area = get_area(I)
			if(crown_area && istype(crown_area, /area/rogue/indoors/town/vault) && notlord)
				say("The crown is within the vault.")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				return
			I = summon_crown()
			return

		if(ishuman(M))
			var/mob/living/carbon/human/HC = M

			// Dead holders can't block
			if(HC.stat == DEAD)
				HC.dropItemToGround(I, TRUE)
				I = summon_crown()
				return

			// Ruler/regent blocks even if stowed/held
			if(SSticker.rulermob == HC || SSticker.regentmob == HC)
				if(I in HC.held_items)
					say("Master [HC.real_name] holds the crown!")
				else if(HC.head == I)
					say("Master [HC.real_name] wears the crown!")
				else
					say("Master [HC.real_name] has the crown stowed away!")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				return

			// Non-lords block ONLY if worn
			if(HC.head == I)
				say("[HC.real_name] wears the crown!")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				return

		I = summon_crown()
		return

	if(findtext(message, "summon key"))
		if(nocrown)
			say("You need the crown.")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		if(!SSroguemachine.key)
			new /obj/item/roguekey/lord(src.loc)
			say("The key is summoned!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
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
				return
			if(ishuman(I.loc))
				var/mob/living/carbon/human/HC = I.loc
				if(HC.stat != DEAD)
					say("[HC.real_name] holds the key!")
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					return
				else
					HC.dropItemToGround(I, TRUE) //If you're dead, forcedrop it, then move it.
			I.forceMove(src.loc)
			say("The key is summoned!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	switch(mode)
		if(0)
			if(findtext(message, "secrets of the throat"))
				say("My commands are: Make Decree, Make Announcement, Set Taxes, Declare Outlaw, Summon Crown, Summon Key, Make Law, Remove Law, Purge Laws, Purge Decrees, Become Regent, Nevermind")
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
			if(findtext(message, "remove law"))
				if(!SScommunications.can_announce(H))
					say("I must gather my strength!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("You are not my master!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				var/message_clean = replacetext(message, "remove law", "")
				var/law_index = text2num(message_clean) || 0
				if(!law_index || !GLOB.laws_of_the_land[law_index])
					say("That law doesn't exist!")
					return
				say("That law shall be gone!")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				remove_law(law_index)
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
				if(SSticker.rulermob != null)
					say("The true lord is already present in the realm.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(!(HAS_TRAIT(H, TRAIT_NOBLE)))
					say("You have not the noble blood to be regent.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(!(H.job in GLOB.noble_positions))
					say("You are too estranged from this realm to be regent.")
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

		if(1)
			make_announcement(H, raw_message)
			mode = 0
		if(2)
			make_decree(H, raw_message)
			mode = 0
		if(3)
			declare_outlaw(H, message)
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

/obj/structure/roguemachine/titan/proc/give_tax_popup(mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	var/datum/taxsetter/taxsetter = new("The Generous Lord Decrees")
	taxsetter.ui_interact(user)

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
	var/mob/living/carbon/human/found_human
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.real_name == raw_message)
			found_human = H
	if(raw_message in GLOB.outlawed_players)
		GLOB.outlawed_players -= raw_message
		priority_announce("[raw_message] is no longer an outlaw in [SSticker.realm_name].", "The [SSticker.rulertype] Decrees", 'sound/misc/royal_decree.ogg', "Captain")
		if(istype(found_human) && HAS_TRAIT(found_human, TRAIT_GUARDSMAN_DISGRACED))
			REMOVE_TRAIT(found_human, TRAIT_GUARDSMAN_DISGRACED, TRAIT_GENERIC)
			ADD_TRAIT(found_human, TRAIT_GUARDSMAN, JOB_TRAIT)
			found_human.remove_status_effect(/datum/status_effect/debuff/disgracedguardsman)
		return FALSE
	if(!found_human)
		return FALSE
	GLOB.outlawed_players += raw_message
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
