//Heretic Commune! Communicate with fellow believers!

/*GLOBAL_VAR_INIT(last_omen, 0)

/mob/living/carbon/human
	var/chanting = FALSE

/mob/living/carbon/human/verb/commune()
	set name = "Commune"
	set category = "Heretic"
	set desc = "Communicate with fellow believers"
	
	if(!mind)
		return
		
	// Check for puritan trait and remove heretic tab if found
	if(HAS_TRAIT(src, TRAIT_PURITAN))
		verbs -= /mob/living/carbon/human/verb/commune
		verbs -= /mob/living/carbon/human/verb/show_heretics
		verbs -= /mob/living/carbon/human/verb/bad_omen
		return
		
	if(!HAS_TRAIT(src, TRAIT_FREEMAN) && !HAS_TRAIT(src, TRAIT_CABAL) && !HAS_TRAIT(src, TRAIT_HORDE) && !HAS_TRAIT(src, TRAIT_DEPRAVED))
		to_chat(src, span_warning("You have no heretical allegiances to commune with!"))
		verbs -= /mob/living/carbon/human/verb/commune
		return
		
	var/echo_message
	var/span_class
	var/nickname = mind.heretic_nickname // Store nickname in the mind

	// Determine the speaker's heretic type and style
	if(HAS_TRAIT(src, TRAIT_FREEMAN))
		echo_message = "raises a fist and mutters revolutionary phrases"
		span_class = "bloody"
	else if(HAS_TRAIT(src, TRAIT_CABAL))
		echo_message = "whispers arcane words into the void"
		span_class = "revennotice"
	else if(HAS_TRAIT(src, TRAIT_HORDE))
		echo_message = "growls primal utterances to unseen forces"
		span_class = "danger"
	else if(HAS_TRAIT(src, TRAIT_DEPRAVED))
		echo_message = "speaks in sordid tongues to fellow deviants"
		span_class = "love"
	else
		to_chat(src, span_warning("You have no heretical allegiances to commune with!"))
		return

	// First time using commune - set nickname
	if(!nickname)
		nickname = stripped_input(src, "Choose a name to be known by to your fellow believers:", "Choose Nickname", real_name, MAX_NAME_LEN)
		if(!nickname)
			return
		mind.heretic_nickname = nickname

	var/msg = input(src, "What would you like to tell your fellow believers?", "Commune") as text|null
	if(!msg)
		return

	visible_message("<span class='notice'>[src] [echo_message].</span>")

	// Send message to ALL heretics, regardless of type
	for(var/mob/living/carbon/human/heretic in GLOB.player_list)
		if(!heretic.client || heretic == src)
			continue
		if(HAS_TRAIT(heretic, TRAIT_FREEMAN) || HAS_TRAIT(heretic, TRAIT_CABAL) || HAS_TRAIT(heretic, TRAIT_HORDE) || HAS_TRAIT(heretic, TRAIT_DEPRAVED))
			to_chat(heretic, "<span class='[span_class]'><b>\[Commune\]</b></span>")
			to_chat(heretic, "<span class='[span_class]' style='font-size: 125%;'><b>[nickname]:</b> [msg]</span>")

	to_chat(src, "<span class='[span_class]'><b>\[Commune\]</b></span>")
	to_chat(src, "<span class='[span_class]' style='font-size: 125%;'><i>You commune:</i> [msg]</span>")

	// Show to ghosts and puritans with real name
	for(var/mob/dead/observer/G in GLOB.dead_mob_list)
		to_chat(G, "[FOLLOW_LINK(G, src)] <span class='[span_class]'><b>\[Commune\]</b></span>")
		to_chat(G, "<span class='[span_class]' style='font-size: 125%;'><b>[real_name]:</b> [msg]</span>")

	// Chance for Puritan to hear the message anonymously
	for(var/mob/living/carbon/human/puritan in GLOB.player_list)
		if(!puritan.client || puritan == src)
			continue
		if(HAS_TRAIT(puritan, TRAIT_PURITAN) && prob(20))
			to_chat(puritan, "<span class='[span_class]'><b>\[Unknown Commune\]</b></span>")
			to_chat(puritan, "<span class='[span_class]' style='font-size: 125%;'><b>[nickname]:</b> [msg]</span>")

	log_directed_talk(src, msg, LOG_SAY, "heretic commune")

/mob/living/carbon/human/verb/show_heretics()
	set name = "Show Fellow Believers"
	set category = "Heretic"
	set desc = "View others of your faith"
	
	if(!mind)
		return
		
	// Check for puritan trait and remove heretic tab if found
	if(HAS_TRAIT(src, TRAIT_PURITAN))
		verbs -= /mob/living/carbon/human/verb/commune
		verbs -= /mob/living/carbon/human/verb/show_heretics
		verbs -= /mob/living/carbon/human/verb/bad_omen
		return
		
	var/my_trait
	
	// Determine the viewer's heretic type
	if(HAS_TRAIT(src, TRAIT_FREEMAN))
		my_trait = TRAIT_FREEMAN
	else if(HAS_TRAIT(src, TRAIT_CABAL))
		my_trait = TRAIT_CABAL
	else if(HAS_TRAIT(src, TRAIT_HORDE))
		my_trait = TRAIT_HORDE
	else if(HAS_TRAIT(src, TRAIT_DEPRAVED))
		my_trait = TRAIT_DEPRAVED
	else
		to_chat(src, span_warning("You have no heretical allegiances!"))
		return

	var/list/heretic_list = list()
	
	// Find all heretics of the same type
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.client || H == src)
			continue
		if(HAS_TRAIT(H, my_trait))
			var/nickname = H.mind?.heretic_nickname || H.real_name
			heretic_list += nickname

	if(!length(heretic_list))
		to_chat(src, span_notice("You sense no other believers of your faith."))
		return
		
	// Show the list to the user
	var/msg = "<span class='notice'><b>Your fellow believers:</b>\n"
	msg += heretic_list.Join("\n")
	msg += "</span>"
	
	to_chat(src, msg)

/mob/living/carbon/human/verb/bad_omen()
	set name = "Dark Chant"
	set category = "Heretic"
	set desc = "Begin a forbidden ritual chant"
	
	if(!mind)
		return
		
	// Check for puritan trait and remove heretic tab if found
	if(HAS_TRAIT(src, TRAIT_PURITAN))
		verbs -= /mob/living/carbon/human/verb/commune
		verbs -= /mob/living/carbon/human/verb/show_heretics
		verbs -= /mob/living/carbon/human/verb/bad_omen
		return

	if(!HAS_TRAIT(src, TRAIT_FREEMAN) && !HAS_TRAIT(src, TRAIT_CABAL) && !HAS_TRAIT(src, TRAIT_HORDE) && !HAS_TRAIT(src, TRAIT_DEPRAVED))
		to_chat(src, span_warning("You have no heretical knowledge of dark chants!"))
		verbs -= /mob/living/carbon/human/verb/bad_omen
		return

	if(GLOB.last_omen && (world.time - GLOB.last_omen) < 6000) // 10 minutes
		to_chat(src, span_warning("The veil is still too strong from the last omen..."))
		return
		
	if(chanting)
		to_chat(src, span_warning("You are already chanting!"))
		return
		
	visible_message("<span class='danger'>[src] begins muttering an unsettling chant...</span>")
	chanting = TRUE
	
	// Check for nearby chanters and trigger omen if found
	for(var/mob/living/carbon/human/H in view(3, src))
		if(H == src || !H.chanting)
			continue
		if(!H.mind || (!HAS_TRAIT(H, TRAIT_FREEMAN) && !HAS_TRAIT(H, TRAIT_CABAL) && !HAS_TRAIT(H, TRAIT_HORDE) && !HAS_TRAIT(H, TRAIT_DEPRAVED)))
			continue
			
		trigger_omen(src, H)
		return
		
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, .proc/interrupt_chant)

/mob/living/carbon/human/proc/interrupt_chant()
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	chanting = FALSE
	visible_message("<span class='notice'>[src]'s chanting falters and stops.</span>")

/mob/living/carbon/human/proc/trigger_omen(mob/living/carbon/human/first_chanter, mob/living/carbon/human/second_chanter)
	GLOB.last_omen = world.time
	first_chanter.chanting = FALSE
	second_chanter.chanting = FALSE
	
	UnregisterSignal(first_chanter, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(second_chanter, COMSIG_MOVABLE_MOVED)
	
	var/turf/T = get_turf(first_chanter)
	var/area/A = get_area(T)
	
	// Only use OMEN_SKELETONSIEGE for dark chant
	var/chosen_omen = OMEN_SKELETONSIEGE
	
	// Add the omen to global list
	addomen(chosen_omen)
	
	// Log the ritual in attack logs
	first_chanter.log_message("performed a dark chant ritual with [second_chanter] ([ADMIN_JMP(second_chanter)])", LOG_ATTACK)
	second_chanter.log_message("performed a dark chant ritual with [first_chanter] ([ADMIN_JMP(first_chanter)])", LOG_ATTACK)
	
	// Create and properly set up the skeleton siege event
	var/datum/round_event_control/rogue/skeleton_siege/S = new()
	// Force the event to be ready
	S.req_omen = FALSE  // Temporarily disable omen requirement since we're forcing it
	S.earliest_start = 0
	S.min_players = 0
	
	// Debug messages with follow links
	message_admins("[ADMIN_JMP(first_chanter)] [first_chanter] and [ADMIN_JMP(second_chanter)] [second_chanter] performed dark chant ritual...")
	message_admins("Dark chant ritual attempting to trigger skeleton siege...")
	
	if(S.canSpawnEvent())
		message_admins("Skeleton siege event conditions met, running event...")
		S.runEvent()
	else
		message_admins("WARNING: Skeleton siege event conditions not met!")
		// Fallback - force spawn a small wave
		var/datum/round_event/rogue/skeleton_siege/E = new(S)
		E.start()
	
	// Create generic event controller for the announcement
	var/datum/round_event_control/rogue/R = new()
	if(prob(30))
		R.badomen(chosen_omen)
		priority_announce("Heretics [first_chanter.real_name] and [second_chanter.real_name] have performed a dark ritual in [A]!", "Bad Omen", 'sound/misc/evilevent.ogg')
	else
		R.badomen(chosen_omen)
		priority_announce("A dark ritual has been performed in [A]!", "Bad Omen", 'sound/misc/evilevent.ogg')*/
