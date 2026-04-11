/datum/antagonist/warlord_lieutenant
	var/aspirant = FALSE
	name = "Lieutenant"
	roundend_category = "Warlord"
	antagpanel_category = "Warlord"
	job_rank = ROLE_WARLORD_LIEUTENANT
	confess_lines = list(
		"A WAR IN THEIR NAME!",
		"I HAVE SERVED FAITHFULLY!",
		"IT WAS MY DUTY!",
	)
	rogue_enabled = TRUE


/datum/antagonist/warlord_grunt
	name = "Grunt"
	roundend_category = "Warlord"
	antagpanel_category = "Warlord"
	job_rank = ROLE_WARLORD_GRUNT
	confess_lines = list(
		"THIS LAND MUST BURN!",
		"IT IS NOT MY WILL!",
		"M'LOOOOOOOOOOOOOOOOOOOOOOOOORD!!", // why are you torturing a grunt, bro. Wtf
	)
	rogue_enabled = TRUE

/datum/antagonist/warlord_lieutenant/proc/aspirant_roll()
	var/final_aspirant_chance = 50
	if(owner.warband_manager)
		var/atom/movable/screen/warband/manager/source_warband_manager = owner.warband_manager	
		final_aspirant_chance = source_warband_manager.aspirant_chance
	if(prob(final_aspirant_chance))
		src.aspirant = TRUE
	return

/datum/antagonist/warlord_lieutenant/on_gain()
	cancel_class_menus(owner.current)
	addtimer(CALLBACK(src, PROC_REF(initialstage)), 1 SECONDS)
	return ..()

/datum/antagonist/warlord_grunt/on_gain()
	cancel_class_menus(owner.current)
	addtimer(CALLBACK(src, PROC_REF(initialstage)), 1 SECONDS)
	return ..()

//////////////////////////////////////////////////////
/////////////////////////////////// CANCEL CLASS MENUS
/datum/antagonist/warlord_lieutenant/proc/cancel_class_menus(mob/living/carbon/human/owner)
	owner.advsetup = FALSE
	SStgui.close_user_uis(owner)
	if(owner.client)
		SSrole_class_handler.special_session_queue -= owner.ckey
	var/datum/class_select_handler/related_handler = SSrole_class_handler.class_select_handlers[owner.ckey]

	if(related_handler)
		related_handler.ForceCloseMenus()
		SSrole_class_handler.class_select_handlers.Remove(owner.ckey)
		qdel(related_handler)
	else
		if(owner.client)
			owner.client << browse(null, "window=latechoices")
			owner.client << browse(null, "window=class_handler_main")
			owner.client << browse(null, "window=class_select_yea")
			owner.client << browse(null, "window=input")

	for(var/atom/movable/screen/advsetup/subclass_hud in owner.hud_used.static_inventory)
		qdel(subclass_hud)

/datum/antagonist/warlord_grunt/proc/cancel_class_menus(mob/living/carbon/human/owner)
	owner.advsetup = FALSE
	SStgui.close_user_uis(owner)
	if(owner.client)
		SSrole_class_handler.special_session_queue -= owner.ckey
	var/datum/class_select_handler/related_handler = SSrole_class_handler.class_select_handlers[owner.ckey]

	if(related_handler)
		related_handler.ForceCloseMenus()
		SSrole_class_handler.class_select_handlers.Remove(owner.ckey)
		qdel(related_handler)
	else
		if(owner.client)
			owner.client << browse(null, "window=latechoices")
			owner.client << browse(null, "window=class_handler_main")
			owner.client << browse(null, "window=class_select_yea")
			owner.client << browse(null, "window=input")

	for(var/atom/movable/screen/advsetup/subclass_hud in owner.hud_used.static_inventory)
		qdel(subclass_hud)

////////////////////////////////////////////
/////////////////////////////////// MINDWIPE
/datum/antagonist/warlord_lieutenant/proc/mindwipe(var/datum/mind/owner)
	for(var/datum/mind/found_mind in get_minds())
		owner.become_unknown_to(found_mind)

/datum/antagonist/warlord_grunt/proc/mindwipe(var/datum/mind/owner)
	for(var/datum/mind/found_mind in get_minds())
		owner.become_unknown_to(found_mind)

////////////////////////////////////////////
/////////////////////////////////// BANKWIPE
/datum/antagonist/warlord_lieutenant/proc/bankwipe(var/mob/owner)
	if(owner in SStreasury.bank_accounts)
		SStreasury.bank_accounts.Remove(owner)

/datum/antagonist/warlord_grunt/proc/bankwipe(var/mob/owner)
	if(owner in SStreasury.bank_accounts)
		SStreasury.bank_accounts.Remove(owner)

///////////////////////////////////////////////
/////////////////////////////////// REPLACE MOB
/datum/antagonist/warlord_lieutenant/proc/replace_mob(mob/living/new_character)
	var/mob/living/replacement_mob = SSwarbands.get_lobby_mob()
	replacement_mob.key = new_character.key
	replacement_mob.sync_mind()
	GLOB.chosen_names -= new_character.real_name
	replacement_mob.real_name = unique_number ? "Lieutenant #[unique_number]" : "Lieutenant"
	GLOB.mob_living_list -= new_character
	new_character.alpha = 0
	new_character.moveToNullspace()
	return replacement_mob

/datum/antagonist/warlord_grunt/proc/replace_mob(mob/living/new_character)
	var/mob/living/replacement_mob = SSwarbands.get_lobby_mob()
	replacement_mob.key = new_character.key
	replacement_mob.sync_mind()
	GLOB.chosen_names -= new_character.real_name
	replacement_mob.real_name = unique_number ? "Grunt #[unique_number]" : "Grunt"
	GLOB.mob_living_list -= new_character
	new_character.moveToNullspace()
	new_character.alpha = 0
	return replacement_mob

///////////////////////////////////////////////
/////////////////////////////////// INITIAL STAGE
/datum/antagonist/warlord_lieutenant/proc/initialstage()
	var/stun_timer = 3 HOURS
	bankwipe(owner.current)
	mindwipe(owner)
	if(!owner.warband_latespawn)
		owner.current.unequip_everything()
		var/mob/living/newmob = replace_mob(owner.current)
		newmob.invisibility = INVISIBILITY_MAXIMUM
		newmob.set_blindness(stun_timer)
		newmob.Stun(stun_timer)
		newmob.mind = owner
		owner.current = newmob
	else
		owner.current.set_blindness(stun_timer)
		owner.current.Stun(stun_timer)
	owner.current.mind.warbandsetup = TRUE
	aspirant_roll()
	addtimer(CALLBACK(src, PROC_REF(setup_warband_manager)), 1 SECONDS)
	greet()

/datum/antagonist/warlord_grunt/proc/initialstage()
	var/stun_timer = 3 HOURS
	bankwipe(owner.current)
	mindwipe(owner)
	if(!owner.warband_latespawn)
		owner.current.unequip_everything()
		var/mob/living/newmob = replace_mob(owner.current)
		newmob.invisibility = INVISIBILITY_MAXIMUM
		newmob.set_blindness(stun_timer)
		newmob.Stun(stun_timer)
		newmob.mind = owner
		owner.current = newmob
	else
		owner.current.set_blindness(stun_timer)
		owner.current.Stun(stun_timer)
	owner.current.mind.warbandsetup = TRUE
	addtimer(CALLBACK(src, PROC_REF(setup_warband_manager)), 1 SECONDS)
	greet()


/datum/antagonist/warlord_lieutenant/proc/setup_warband_manager()
	if(!owner || !owner.current)
		return

	if(!owner.warband_ID)
		for(var/datum/mind/potential_warlord in get_minds())
			if(potential_warlord.special_role == "Warlord" && potential_warlord.warband_ID)
				if(potential_warlord.warband_manager)
					owner.warband_ID = potential_warlord.warband_ID
					break

	if(!owner.warband_ID)
		to_chat(owner.current, span_warning("Failed to find a Warlord. Setup cancelled."))
		qdel(owner.current) // It's over. Go Home.
		return
	
	for(var/atom/movable/screen/warband/manager/listed_manager in SSwarbands.warband_managers)
		if(listed_manager.warband_ID == owner.warband_ID)
			owner.warband_manager = listed_manager
			listed_manager.lobby_members += owner.current
			listed_manager.spawned_lieutenants++
			listed_manager.create_HUD_instance(owner.current)
			return

/datum/antagonist/warlord_grunt/proc/setup_warband_manager()
	if(!owner || !owner.current)
		return
	
	if(!owner.warband_ID)
		for(var/datum/mind/potential_warlord in get_minds())
			if(potential_warlord.special_role == "Warlord" && potential_warlord.warband_ID)
				if(potential_warlord.warband_manager)
					owner.warband_ID = potential_warlord.warband_ID
					break
	if(!owner.warband_ID)
		to_chat(owner.current, span_warning("Failed to find a Warlord. Setup cancelled."))
		qdel(owner.current) // It's over. Go Home.
		return
	for(var/atom/movable/screen/warband/manager/listed_manager in SSwarbands.warband_managers)
		if(listed_manager.warband_ID == owner.warband_ID)
			owner.warband_manager = listed_manager
			listed_manager.lobby_members += owner.current
			listed_manager.create_HUD_instance(owner.current)
			return

///////////////
///////////////
///////////////
/datum/antagonist/warlord_lieutenant/greet()
	ADD_TRAIT(owner.current, TRAIT_FORCED_LOOC, TRAIT_GENERIC)
	SEND_SOUND(owner.current, sound(null))
	if(src.aspirant)
		owner.special_role = "Aspirant Lieutenant"	
		to_chat(owner.current, span_userdanger("I mustn't forget myself. My service is simply a means to an end."))	
		var/atom/movable/screen/introtext/aspirant/intro_text = new /atom/movable/screen/introtext/aspirant
		var/list/intro_sounds = list(
			'sound/misc/warband/selection_introc.ogg'
		)
		var/chosen_song = pick(intro_sounds)
		var/sound/S = sound(chosen_song, repeat = 0, wait = 0, channel = 0, volume = 90)
		SEND_SOUND(owner.current, S)
		owner.current.playsound_local(owner.current, chosen_song, 100, FALSE, pressure_affected = FALSE)
		owner.current.client.screen += intro_text
		animate(intro_text, alpha = 255, time = 50)
		forge_objectives()
		return
	owner.special_role = name
	to_chat(owner.current, span_userdanger("My Warlord calls upon my service."))

	var/list/intro_sounds = list(
		'sound/misc/warband/selection_introc.ogg'
	)
	var/chosen_song = pick(intro_sounds)
	var/sound/S = sound(chosen_song, repeat = 0, wait = 0, channel = 0, volume = 60)
	SEND_SOUND(owner.current, S)
	var/atom/movable/screen/introtext/lieutenant/intro_text = new /atom/movable/screen/introtext/lieutenant
	owner.current.client.screen += intro_text
	animate(intro_text, alpha = 255, time = 50)
	forge_objectives()
	..()

/datum/antagonist/warlord_grunt/greet()
	ADD_TRAIT(owner.current, TRAIT_FORCED_LOOC, TRAIT_GENERIC)
	SEND_SOUND(owner.current, sound(null))
	owner.special_role = name
	to_chat(owner.current, span_userdanger("My Lieutenant calls upon my service."))

	var/list/intro_sounds = list(
		'sound/misc/warband/selection_introc.ogg'
	)
	var/chosen_song = pick(intro_sounds)
	var/sound/S = sound(chosen_song, repeat = 0, wait = 0, channel = 0, volume = 60)
	SEND_SOUND(owner.current, S)
	var/atom/movable/screen/introtext/veteran/intro_text = new /atom/movable/screen/introtext/veteran
	owner.current.client.screen += intro_text
	animate(intro_text, alpha = 255, time = 50)
	..()



///////////////
///////////////
///////////////
/datum/antagonist/warlord_lieutenant/proc/forge_objectives()
	var/datum/objective/warband/aspirant/greatergood/base_objective = new
	base_objective.owner = owner
	objectives += base_objective
	if(src.aspirant)
		var/list/aspirant_objectives = list(
			/datum/objective/warband/aspirant/wormtongue,
			/datum/objective/warband/aspirant/disorder,
			/datum/objective/warband/aspirant/order,
			/datum/objective/warband/aspirant/standard,
			/datum/objective/warband/aspirant/coin
		)
		var/chosen_type = pick(aspirant_objectives)
		var/datum/objective/warband/aspirant/aspirant_objective = new chosen_type
		aspirant_objective.owner = owner
		objectives += aspirant_objective
	owner.announce_objectives()


/datum/objective/warband/aspirant/greatergood
	name = "Greater Good"
	explanation_text = "The Warlord must prevail in his main objective."

/datum/objective/warband/aspirant/standard
	name = "Term"
	explanation_text = "A single treaty term of my design must be fulfilled."

/datum/objective/warband/aspirant/disorder
	name = "Pragmatism"
	explanation_text = "We must prevail by any means necessary. My Warband must recruit 4 or more allies."

/datum/objective/warband/aspirant/order
	name = "Order"
	explanation_text = "If we are to succeed, order must be maintained. My Warband cannot have 3 or more foreigners in its ranks."

/datum/objective/warband/aspirant/wormtongue
	name = "Dead Weight"
	explanation_text = "The other Lieutenants cannot be trusted. By the end of the week, I must be the last remaining Lieutenant in the Warband."

/datum/objective/warband/aspirant/coin
	name = "Mammon"
	explanation_text = "I'm in desperate need of coin, and I've been long denied it. By the week's end, I need a total of 2000 mammon on my person."


// base objective for both aspirants & regular lieutenants
// succeed if the warlord's "find common ground" objective is complete
// the warlord's actual survival is irrelevant
/datum/objective/warband/aspirant/greatergood/check_completion()
	if(!owner || !owner.warband_manager)
		return FALSE
	var/atom/movable/screen/warband/manager/warband = owner.warband_manager
	for(var/mob/living/carbon/human/member in warband.members)
		if(!member.mind)
			continue
		if(member.mind.special_role == "Warlord")
			for(var/datum/objective/obj in member.mind.get_all_objectives())
				if(istype(obj, /datum/objective/warband/warlord))
					return obj.check_completion()
	return FALSE

// disorder
// succeed if the warband stays above 4 or more disorder
/datum/objective/warband/aspirant/disorder/check_completion()
	if(!owner || !owner.warband_manager)
		return FALSE
	
	var/atom/movable/screen/warband/manager/warband = owner.warband_manager
	return warband.disorder >= 4

// order
// succeed if disorder stays below 3
/datum/objective/warband/aspirant/order/check_completion()
	if(!owner || !owner.warband_manager)
		return TRUE
	var/atom/movable/screen/warband/manager/warband = owner.warband_manager
	return warband.disorder < 3

// wormtongue
// succeed if we're the only living lieutenant
/datum/objective/warband/aspirant/wormtongue/check_completion()
	if(!owner || !owner.warband_manager)
		return FALSE
	var/atom/movable/screen/warband/manager/warband = owner.warband_manager
	var/living_lieutenants = 0
	for(var/mob/living/carbon/human/member in warband.members)
		if(!member.mind)
			continue
		if(member.mind == owner)
			continue
		if(member.mind.special_role == "Lieutenant" || member.mind.special_role == "Aspirant Lieutenant")
			if(member.stat != DEAD)
				living_lieutenants++
	return living_lieutenants == 0

// coin
// succeed if they're carrying 2000 or more mammons
/datum/objective/warband/aspirant/coin/check_completion()
	if(!owner || !owner.current)
		return FALSE
	
	var/mammons = get_mammons_in_atom(owner.current)
	return mammons >= 2000

// standard
// succeed when a term you wrote is in a submitted treaty
// or if a faction you own is given territory
// handled in treaty.dm
/datum/objective/warband/aspirant/standard/check_completion()
	return completed
