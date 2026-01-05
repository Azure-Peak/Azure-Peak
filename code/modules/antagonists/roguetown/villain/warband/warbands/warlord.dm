/datum/job/roguetown/warlord
	title = "Warlord"
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null
	max_pq = null
	announce_latejoin = FALSE



	show_in_credits = FALSE
	give_bank_account = FALSE
	hidden_job = TRUE


/datum/antagonist/warlord
	name = "Warlord"
	roundend_category = "Warlord"
	antagpanel_category = "Warlord"
	job_rank = ROLE_WARLORD
	confess_lines = list(
		"A WAR IN MY NAME!",
		"THESE LANDS ARE MINE!",
		"I AM OWED!",
	)
	rogue_enabled = TRUE


//////////////////////////////////////////////////////
/////////////////////////////////// CANCEL CLASS MENUS
/*
	if the warlord spawns as a class w/subclasses at roundstart, this ends that process before we begin

	FIXNOTE: this still runtimes w/ roundstart classes that have a weapon input window that isn't behind a class select option (i.e: classes that autoselect like knight captain)
	How The Fuck Do I Close That.

*/

/datum/antagonist/warlord/proc/cancel_class_menus(mob/living/carbon/human/owner)
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
/*
	wipes the warlord's first character from the town's memories at roundstart
*/
/datum/antagonist/warlord/proc/mindwipe(var/datum/mind/owner)
	for(var/datum/mind/found_mind in get_minds())
		owner.become_unknown_to(found_mind)


////////////////////////////////////////////
/////////////////////////////////// BANKWIPE
/*
	wipes the warlord's first character from the town's bank
*/
/datum/antagonist/warlord/proc/bankwipe(var/mob/owner)
	if(owner in SStreasury.bank_accounts)
		SStreasury.bank_accounts.Remove(owner)

	
///////////////////////////////////////////////
/////////////////////////////////// REPLACE MOB
/*
	replaces the initial mob that the warlord spawned with
	we've got a Blank Slate: no stats, no skills, no traits
*/
/datum/antagonist/warlord/proc/replace_mob(mob/living/new_warlord)
	var/mob/living/carbon/human/species/human/northern/replacement_mob = new /mob/living/carbon/human/species/human/northern(new_warlord.loc)
	replacement_mob.key = new_warlord.key
	GLOB.chosen_names -= new_warlord.real_name
	qdel(new_warlord)
	return replacement_mob

//////////////////////////////////////////////////////////
/////////////////////////////////// CREATE WARBAND MANAGER
/*
	creates a warband manager
	syncs its ID with the warlord's ID
	creates a hud instance of said manager
*/
/datum/antagonist/warlord/proc/create_warband_manager(mob/living/new_warlord, datum/mind/owner)
	var/atom/movable/screen/warband/manager/pregame_manager
	for(var/obj/effect/landmark/start/warlord/warlord_spawn in GLOB.landmarks_list)
		new_warlord.loc = warlord_spawn.loc
		break

	if(!SSwarbands.roundstart_manager_claimed && SSwarbands.roundstart_manager)
		pregame_manager = SSwarbands.roundstart_manager
		SSwarbands.roundstart_manager_claimed = TRUE
		owner.warband_ID = pregame_manager.warband_ID
	else
		pregame_manager = new /atom/movable/screen/warband/manager()
		pregame_manager.warband_ID = SSwarbands.warband_managers.len + 1
		SSwarbands.warband_managers += pregame_manager
		owner.warband_ID = pregame_manager.warband_ID

	pregame_manager.lobby_members += owner.current
	owner.warband_manager = pregame_manager
	pregame_manager.create_HUD_instance(new_warlord)

// staggers the process, otherwise we crash pretty often if we're doing this at roundstart on dun_world (it's probably just my pc)
/datum/antagonist/warlord/on_gain()
	cancel_class_menus(owner.current)
	addtimer(CALLBACK(src, PROC_REF(initialstage)), 1 SECONDS)
	. = ..()
	return ..()

// clears out traces of the initial character from the city's banking system & memories
/datum/antagonist/warlord/proc/initialstage()
	var/stun_timer = 3 HOURS
	bankwipe(owner.current)
	mindwipe(owner)
	owner.current.unequip_everything()

	var/mob/living/newmob = replace_mob(owner.current)
	newmob.invisibility = INVISIBILITY_MAXIMUM
	newmob.set_blindness(stun_timer)
	newmob.Stun(stun_timer)
	newmob.mind = owner
	owner.current = newmob
	SSmapping.retainer.warlords |= newmob.mind
	newmob.mind.special_role = name
	newmob.mind.warband_ID = SSwarbands.warband_managers.len + 1
	newmob.faction |= list("warband_[newmob.mind.warband_ID]")
	newmob.mind.warbandsetup = TRUE
	addtimer(CALLBACK(src, PROC_REF(greet), newmob), 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(create_warband_manager), newmob, newmob.mind), 1 SECONDS)

/datum/antagonist/warlord/greet(mob/living/new_warlord)
	to_chat(new_warlord, span_danger("I bear great, terrible dreams. My legions shall make them a reality."))
	var/list/intro_sounds = list(
		'sound/misc/warband/selection_introc.ogg'
	)
	var/chosen_song = pick(intro_sounds)
	new_warlord.playsound_local(new_warlord, chosen_song, 100, FALSE, pressure_affected = FALSE)
	var/atom/movable/screen/introtext/intro_text = new /atom/movable/screen/introtext
	new_warlord.client.screen += intro_text
	animate(intro_text, alpha = 255, time = 50)
	forge_objectives()
	..()


/datum/antagonist/warlord/on_removal()
	to_chat(owner.current, span_userdanger("I have nothing planned for the AZURE PEAK. It's over."))
	return ..()

//////// Objectives
/datum/antagonist/warlord/proc/forge_objectives()
	var/datum/objective/warband/warlord/base_objective = new
	var/datum/objective/survive/warband/survive_objective = new
	objectives += base_objective
	objectives += survive_objective
	owner.announce_objectives()

/datum/objective/warband/warlord
	name = "Find Common Ground"
	explanation_text = "Sign a Treaty that benefits the Warband."


/datum/objective/survive/warband
	name = "Survive"
	explanation_text = "Live to reap the rewards."
