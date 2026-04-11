/obj/structure/fluff/warband
	var/warband_ID = 0
	var/atom/movable/screen/warband/manager/linked_warband
	max_integrity = 0

/obj/structure/fluff/warband/Initialize()
	..()
	SSwarbands.warband_machines += src

/obj/structure/fluff/warband/Destroy()
	SSwarbands.warband_machines -= src
	linked_warband = null
	return ..()

/obj/structure/fluff/warband/campaign_planner
	name = "campaign planner"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scrollwrite"

/obj/structure/fluff/warband/campaign_planner/attack_hand(mob/user)
	. = ..()
	if(user.mind.special_role == "Warlord" || user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant" || user.mind.special_role == "Grunt" || user.mind.special_role == "Warlord's Envoy")
		if(user.mind.warband_ID == src.warband_ID)
			var/list/campaign_options = list()		
			campaign_options += "HELP"		
			campaign_options += "View Troops"
			campaign_options += "View Allies"
			campaign_options += "View Morale"		
			if(user.mind.special_role == "Warlord" || user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant" || user.mind.special_role == "Warlord's Envoy")
				campaign_options += "Prepare Treaty"
				campaign_options += "Estate Import"
			if(user.mind.special_role == "Warlord")
				campaign_options += "Exile Member"
				if(src.linked_warband.encounter_manager.outskirts_locked)
					campaign_options += "Stand Down Outskirts Defenses"
				else if(!src.linked_warband.encounter_manager.encounter_disabled)
					campaign_options += "Raise Outskirts Defenses"

			var/campaign_choice = input(user, "What shall I do?", "Warband Recruitment") as null|anything in campaign_options

			switch(campaign_choice)
				if("HELP")
					return
				if("Prepare Treaty")
					if(!COOLDOWN_FINISHED(user.mind, treaty_cooldown))
						var/time_left = COOLDOWN_TIMELEFT(user.mind, treaty_cooldown)
						to_chat(user, span_warning("I've recently prepared a treaty. I should wait another [round(time_left / 10, 1)] seconds."))
						return
					var/obj/item/treaty/spawned_treaty = new /obj/item/treaty(src.loc)
					new /obj/item/natural/feather(src.loc)
					spawned_treaty.firstparty = linked_warband.linked_faction.name
					if(src.linked_warband) // gives the treaty any unique terms the associated warband might have
						if(src.linked_warband.selected_warband)
							spawned_treaty.warband_sources += linked_warband.selected_warband.name
						if(src.linked_warband.selected_subtype)
							spawned_treaty.warband_sources += linked_warband.selected_subtype.name
						if(src.linked_warband.selected_aspects)
							for(var/datum/warbands/aspects/aspect in src.linked_warband.selected_aspects)
								spawned_treaty.warband_sources += aspect.name
					spawned_treaty.add_unique_terms()
					COOLDOWN_START(user.mind, treaty_cooldown, 60 SECONDS)
					return
				if("View Troops")
					to_chat(user, span_warning("[src.linked_warband.spawns] soldiers remain at our disposal. Our finest are..."))
					for(var/mob/living/member in src.linked_warband.members)
						to_chat(user, span_warning("- [member.real_name], the [member.job]."))
					return
				if("Estate Import")
					import(user)
					return
				if("Exile Member")
					var/list/viable_member_list = list()
					for(var/mob/living/member in src.linked_warband.members)
						if(member.real_name != user.real_name)
							viable_member_list += member.real_name
					if(!viable_member_list.len)
						to_chat(user, span_warning("There are no other members to exile."))
						return
					var/mob/living/exile_choice = input(user, "Who must go?", "EXILE") as null|anything in viable_member_list
					if(exile_choice)
						src.linked_warband.exile(null, user, exile_choice)
						return
					else
						to_chat(user, span_warning("I've changed my mind."))
						return
				if("View Morale")
					if(src.linked_warband.disorder <= 1)
						to_chat(user, span_green("The men are calm and our work continues."))
						return
					if(src.linked_warband.disorder <= 2)
						to_chat(user, span_warning("There's some strain weighing upon our legion's spirit, but we're holding out well enough."))
						return
					if(src.linked_warband.disorder <= 3)
						to_chat(user, span_warning("More than a few instances of insubordination have been reported."))
						return
					if(src.linked_warband.disorder <= 4)
						to_chat(user, span_warning("If discipline isn't restored, we shall be found in dire straits."))
						return
					if(src.linked_warband.disorder <= 8)
						to_chat(user, span_warning("Unrest is rampant in our ranks. We won't hold together for much longer."))
						return
					if(src.linked_warband.disorder <= 10)
						to_chat(user, span_warning("Order has completely broken down. We are akin to bandits."))

				if("View Allies")
					if(!src.linked_warband.allies.len)
						to_chat(user, span_warning("We are without allies."))
						return
					for(var/mob/living/ally in src.linked_warband.allies)
						to_chat(user, span_warning("There is [ally.real_name], the [ally.job]. They were joined with us by decree of [ally.mind.warband_recruiter_name]"))

					return
				if("Stand Down Outskirts Defenses")
					if(!src.linked_warband.outskirts_established)
						to_chat(user, span_warning("We haven't established our outskirts yet."))
						return
					if(src.linked_warband.encounter_manager.encounter_active)
						to_chat(user, span_warning("There's still a battle happening in the outskirts. I cannot lower our defenses."))
						return
					if(src.linked_warband.encounter_manager.attacker_rout_active)
						to_chat(user, span_warning("Our foe is currently being routed from the field. I can't stand down our defenses just yet."))
						return
				
					var/confirm = alert(user, "Stand down the outskirts defenses? This will allow anyone to enter the warcamp.", "Stand Down Outskirts", "Yes", "No")
					if(confirm != "Yes")
						return
					src.linked_warband.encounter_manager.cancel_march()
					src.linked_warband.encounter_manager.outskirts_locked = FALSE
					to_chat(user, span_notice("The troops on our outskirts have stood down. Anyone may enter the warcamp."))
					return
				if("Raise Outskirts Defenses")
					if(src.linked_warband.encounter_manager.encounter_disabled)
						to_chat(user, span_warning("Our defensive line is shattered. We cannot reform our ranks."))
						return
					
					var/confirm = alert(user, "Raise the outskirts defenses? This will lock the warcamp from intruders.", "Raise Outskirts Defenses", "Yes", "No")
					if(confirm != "Yes")
						return
					if(!src.linked_warband.encounter_manager.encounter_disabled)
						src.linked_warband.encounter_manager.outskirts_locked = TRUE
						to_chat(user, span_notice("The outskirts defenses have been raised. The warcamp is now secured."))
						return
			return
	return


//////SPAWNER
/obj/structure/fluff/warband/warband_recruit
	name = "rally point"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "travel"
	color = "#b61111"
	var/disabled = FALSE
	var/destruction_doafter = "prepares to clear out the rally point."
	var/destruction_msg = "The rally point is no more. The Warband's tide of reinforcements is stemmed."

/obj/structure/fluff/warband/foreguard

/obj/structure/fluff/warband/rearguard

/obj/structure/fluff/warband/shortcut
	name = "shortcut"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "travel"
	var/disabled = FALSE


/obj/structure/fluff/warband/shortcut/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(user.mind.warband_ID == src.warband_ID)
		if(src.disabled)
			if(do_after(user, 90, target = src))
				src.disabled = FALSE
				src.alpha = 255
				to_chat(user, span_userdanger("I've restored the Shortcut!"))
				return
		else
			to_chat(user, span_bold("This is a one-way path. If I want to leave, I'll need to leave through the front."))


	else if(!src.disabled)
		user.visible_message(span_info("[user] prepares to clear out [src]."))
		if(do_after(user, 90, target = src))
			src.disabled = TRUE
			src.alpha = 50
			to_chat(user, span_userdanger("I've driven off the sentries defending the Shortcut."))
			return

/obj/structure/fluff/warband/warband_recruit/proc/summon_lieutenant(mob/user)
	var/given_warband_ID = user.mind.warband_ID
	if(src.linked_warband.spawns <= 0)
		to_chat(user, span_warning("We've been completely decimated. No one remains to heed my call."))
		return FALSE 
	if(src.linked_warband.busy_summoning == TRUE)
		to_chat(user, span_warning("There's already been a call for our men to rally. I'll need to wait for a moment."))
		return FALSE
	if(src.linked_warband.lobby_members.len)
		to_chat(user, span_warning("I need to be patient. My men are still preparing themselves."))
	if(src.linked_warband.spawned_lieutenants >= 4)
		to_chat(user, span_warning("There are no more capable Lieutenants left."))
		return FALSE 
	to_chat(user, span_green("The summons are sent."))
	src.linked_warband.busy_summoning = TRUE
	sleep(60)	//FIXNOTE: don't leave this in
	var/turf/spawnpoint = get_turf(src)
	var/list/candidates = pollGhostCandidates("Do you want to play as one of the [user.advjob]'s Lieutenants?", ROLE_WARLORD_LIEUTENANT, null, null, 10 SECONDS, POLL_IGNORE_WARBAND_LIEUTENANT)
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("The summons go unanswered."))
		src.linked_warband.busy_summoning = FALSE
		return TRUE

	var/mob/candidate = pick(candidates)
	if(!candidate || !istype(candidate, /mob/dead))
		return FALSE

	if(istype(candidate, /mob/dead/new_player))
		var/mob/dead/new_player/N = candidate
		N.close_spawn_windows()

	to_chat(user, span_green("My summons are answered. I must simply spare them a moment to arm themselves."))
	var/mob/living/carbon/human/target = SSwarbands.get_lobby_mob()
	// GLOB.mob_living_list |= target
	target.forceMove(spawnpoint)
	target.invisibility = INVISIBILITY_MAXIMUM
	target.set_blindness(3 HOURS)
	target.sync_mind()
	target.mind.warband_ID = given_warband_ID
	target.mind.warband_latespawn = TRUE
	target.mind.warband_manager = src.linked_warband
	target.mind.warbandsetup = TRUE
	target.key = candidate.key
	SSjob.AssignRole(target, "Warlord's Lieutenant")
	target.mind.add_antag_datum(/datum/antagonist/warlord_lieutenant)
	src.linked_warband.spawned_lieutenants++
	src.linked_warband.spawns--
	src.linked_warband.busy_summoning = FALSE
	return TRUE


//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// SUMMON ENVOY
/*
	alternates depending on if we're spawning a simple envoy or using a character slot

	simple envoys choose a race from a tiny selection, then get an option to choose a name after they're equipped later on
	custom envoys just spawn as a human, which is then modified via the user's active preferences

	then it assigns the following to the envoy:
		warband & personal faction
		warband ID
		warband manager
		envoy job & special role

	the envoy and the person who summoned it are rotated out
		summoner's ckey is put into the spawned envoy
		summoner's body is stored in the recruitment point
*/

/obj/structure/fluff/warband/warband_recruit/proc/summon_envoy(mob/living/carbon/human/user, race_choice, depth_choice)
	var/mob/living/carbon/human/envoy
	switch(depth_choice)
		if("Simple Envoy")
			switch(race_choice)
				if("Humen")
					envoy = new /mob/living/carbon/human/species/human/northern(src.loc)	
				if("Half-Elf")
					envoy = new /mob/living/carbon/human/species/human/halfelf(src.loc)
				if("Dwarf")
					envoy = new /mob/living/carbon/human/species/dwarf/mountain(src.loc)
				if("Elf")
					envoy = new /mob/living/carbon/human/species/elf/wood(src.loc)
				if("Aasimar")
					envoy = new /mob/living/carbon/human/species/aasimar(src.loc)
			envoy.real_name = pick(world.file2list("strings/rt/names/human/humsoulast.txt"))
			src.simpleappearance(envoy)
		if("Use a Character Slot")
			envoy = new /mob/living/carbon/human/species/human/northern(src.loc)
	envoy.sync_mind()
	envoy.faction |= list("warband_[src.warband_ID]", "[user.real_name]_faction")			
	envoy.key = user.key
	envoy.mind.warband_ID = src.warband_ID
	envoy.mind.warband_manager = src.linked_warband
	envoy.mind.original_char = user
	envoy.mind.warband_manager.spawns--
	transfer_treaties(user, envoy)
	equip_envoy(envoy)
	SSjob.AssignRole(envoy, "Warlord's Envoy")
	envoy.mind.special_role = "Warlord's Envoy"
	src.contents += user
	user.mode = NPC_AI_SLEEP
	return envoy

/obj/structure/fluff/warband/warband_recruit/proc/transfer_treaties(mob/living/carbon/human/from_mob, mob/living/carbon/human/to_mob)
	for(var/obj/item/treaty/carried_treaty in from_mob.contents)
		if(from_mob.transferItemToLoc(carried_treaty, to_mob.loc))
			to_mob.put_in_hands(carried_treaty)
	
	for(var/obj/item/storage/bag in from_mob.contents)
		for(var/obj/item/treaty/bag_treaty in bag.contents)
			bag_treaty.remove_item_from_storage(from_mob)
			bag_treaty.forceMove(to_mob.loc)
			to_mob.put_in_hands(bag_treaty)


////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////

/obj/structure/fluff/warband/warband_recruit/proc/simpleappearance(mob/living/carbon/human/envoy)
	var/obj/item/bodypart/head/head = envoy.get_bodypart(BODY_ZONE_HEAD)
	var/hair_choice = /datum/sprite_accessory/hair/head/troubadour

	var/datum/bodypart_feature/hair/head/new_hair = new()

	new_hair.set_accessory_type(hair_choice, null, envoy)

	if(prob(50))
		new_hair.accessory_colors = "#96403d"
		new_hair.hair_color = "#96403d"
	else
		new_hair.accessory_colors = "#160d02"
		new_hair.hair_color = "#160d02"

	head.add_bodypart_feature(new_hair)

	envoy.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	envoy.dna.species.handle_body(envoy)


	var/obj/item/organ/eyes/organ_eyes = envoy.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		var/picked_eye_color = pick("#365334", "#395c70", "#30261e")
		organ_eyes.eye_color = picked_eye_color
		organ_eyes.accessory_colors = picked_eye_color + picked_eye_color

/////////////////////////////////////////////////////////////
///////////////////////////////////////////////// EQUIP ENVOY
/*
	equips an envoy
*/
/obj/structure/fluff/warband/warband_recruit/proc/equip_envoy(mob/envoy, used_slot)
	var/datum/advclass/warband/envoy/envoy_class = new /datum/advclass/warband/envoy
	if(src.linked_warband)
		envoy.cmode_music = src.linked_warband.combatmusic
	envoy.job = envoy_class.name
	envoy_class.equipme(envoy, null, used_slot)


///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// EQUIP VETERAN
/*
	spawns & equips a veteran
*/
/obj/structure/fluff/warband/warband_recruit/proc/summon_veteran(mob/user)
	var/given_warband_ID = user.mind.warband_ID
	if(src.linked_warband.spawns <= 0)
		to_chat(user, span_warning("We've been completely decimated. No one remains to heed my call."))
		return FALSE 
	if(src.linked_warband.lobby_members.len)
		to_chat(user, span_warning("I need to be patient. My men are still preparing themselves."))
		return FALSE
	if(length(user.mind.subordinates) >= 2)
		to_chat(user, span_warning("I have no Veterans left to call."))
		return FALSE
	if(src.linked_warband.busy_summoning == TRUE)
		to_chat(user, span_warning("There's already been a call for our men to rally. I'll need to wait for a moment."))
		return FALSE
	src.linked_warband.busy_summoning = TRUE
	to_chat(user, span_green("The summons are sent."))	
	sleep(60)	//FIXNOTE: don't leave this in
	var/turf/spawnpoint = get_turf(src)
	var/list/candidates = pollGhostCandidates("Do you want to play as one of the [user.advjob]'s Veteran Soldiers?", ROLE_WARLORD_GRUNT, null, null, 10 SECONDS, POLL_IGNORE_WARBAND_VETERAN)
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("The summons go unanswered."))
		src.linked_warband.busy_summoning = FALSE
		return FALSE

	var/mob/candidate = pick(candidates)
	if(!candidate || !istype(candidate, /mob/dead))
		return FALSE

	if(istype(candidate, /mob/dead/new_player))
		var/mob/dead/new_player/N = candidate
		N.close_spawn_windows()

	to_chat(user, span_green("My summons are answered. I must simply spare them a moment to arm themselves."))
	var/mob/living/carbon/human/target = SSwarbands.get_lobby_mob()
	target.forceMove(spawnpoint)
	target.invisibility = INVISIBILITY_MAXIMUM
	target.set_blindness(3 HOURS)
	target.sync_mind()
	target.mind.warband_ID = given_warband_ID
	target.mind.warband_latespawn = TRUE
	target.mind.warband_manager = src.linked_warband
	target.mind.warbandsetup = TRUE
	target.key = candidate.key

	SSjob.AssignRole(target, "Grunt")
	target.mind.add_antag_datum(/datum/antagonist/warlord_grunt)
	if(user && user.mind)
		user.mind.subordinates += target
		target.mind.warband_recruiter_name = user.real_name
		target.faction |= "[user.real_name]_faction" // included in their lieutenant's personal faction
	src.linked_warband.spawns--
	src.linked_warband.busy_summoning = FALSE
	return TRUE


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// RECRUITMENT POINT INTERACTION
/*
	ALLIED WARLORDS & LIEUTENANTS: recruitment prompts, unless the rally point is disabled
	ENEMY WARLORDS: convert the rally point
	ANYONE ELSE: disable the rally point
*/
/obj/structure/fluff/warband/warband_recruit/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(src.disabled && user.mind.warband_ID == src.warband_ID)
		if(do_after(user, 90, target = src))
			src.disabled = FALSE
			src.alpha = 255
			to_chat(user, span_nicegreen("I've restored the rally point!"))
			return
	if(user.mind.special_role == "Warlord" || user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant" || user.mind.special_role == "Grunt" || user.mind.special_role == "Warlord's Envoy")
		if(user.mind.warband_ID == src.warband_ID)
			var/list/summon_options = list()
			if(user.mind.special_role == "Warlord")
				summon_options += "Summon LIEUTENANT"
			if(user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant")
				summon_options += "Summon VETERAN SOLDIER"
			if(user.mind.special_role == "Warlord" || user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant")
				summon_options += "Summon GOONS (NPCs)"
			if(user.mind.special_role == "Warlord's Envoy")
				summon_options += "Stow Envoy"
			if(user.mind.special_role == "Warlord" || user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant")
				summon_options += "Summon ENVOY"
			var/summon_choice = input(user, "Who should be summoned?", "Warband Recruitment") as null|anything in summon_options

			switch(summon_choice)
				if("Summon LIEUTENANT")
					summon_lieutenant(user)
				if("Summon VETERAN SOLDIER")
					summon_veteran(user)
					return
				if("Summon ENVOY")
					if(src.linked_warband.spawns > 0)
						var/list/depth_options = list("Simple Envoy","Use a Character Slot")
						var/depth_choice = input(user, "How should they look?", "Warband Recruitment") as anything in depth_options
						switch(depth_choice)
							if("Use a Character Slot")
								src.linked_warband.select_pref_slot(user)
								var/mob/living/envoy = summon_envoy(user, null, depth_choice)
								src.linked_warband.load_appearance(user, envoy)
								src.linked_warband.spawns--
							if("Simple Envoy")
								var/list/races = list("Humen","Half-Elf","Dwarf","Elf","Aasimar")
								var/race_choice = input(user, "What species should they be?", "Warband Recruitment") as anything in races
								summon_envoy(user, race_choice, depth_choice)
								src.linked_warband.spawns--
					else
						to_chat(user, span_userdanger("No reinforcements remain."))					
				if("Summon GOONS (NPCs)")
					if(!user.mind.warband_manager.outskirts_established)
						to_chat(user, span_warning("It's far too soon to prepare the soldiery. We should allow time for our envoys to scout a path, first."))
						return
					
					var/squad_deployed
					for(var/mob/friend in user.friends)
						if(istype(friend, /mob/living/carbon/human/species/human/northern/goon))
							squad_deployed = TRUE
							break
					
					if(!COOLDOWN_FINISHED(user.mind, squad_spawn_cooldown))
						var/time_left = COOLDOWN_TIMELEFT(user.mind, squad_spawn_cooldown)
						to_chat(user, span_warning("I've recently summoned a squad. I should wait another [round(time_left / 10, 1)] seconds."))
						return
					
					if(squad_deployed)
						var/list/choices = list("ABANDON OLD SQUAD","CANCEL")
						var/abandon_choice = input(user, "You've already deployed a squad. Abandon them?", "Warband Recruitment") as anything in choices
						switch(abandon_choice)
							if("ABANDON OLD SQUAD")
								for(var/mob/living/carbon/human/species/human/northern/goon/abandoned_grunt in user.friends)
									if(!abandoned_grunt)
										user.friends -= abandoned_grunt
										continue
									abandoned_grunt.abandonevent()
									user.friends -= abandoned_grunt
							if("CANCEL")
								return
						return
					else if(src.linked_warband.spawns > 0)
						if(!user.GetComponent(/datum/component/squad_controller))
							user.AddComponent(/datum/component/squad_controller, user)
						
						for(var/grunts_spawned = 1, grunts_spawned <= user.mind.squad_size && src.linked_warband.spawns > 0, grunts_spawned++)
							var/mob/living/carbon/human/species/human/northern/goon/new_grunt = src.linked_warband.get_cached_grunt(src.loc, user)
							new_grunt.patron = user.patron
							new_grunt.faction |= list("warband_[src.warband_ID]", "[user.real_name]_faction")
							new_grunt.warband_ID = user.mind.warband_ID
							user.friends += new_grunt
							new_grunt.friends += user
							src.linked_warband.spawns--
						to_chat(user, span_userdanger("There are [src.linked_warband.spawns] soldiers remaining."))
						COOLDOWN_START(user.mind, squad_spawn_cooldown, 2 MINUTES)
					else
						to_chat(user, span_userdanger("No reinforcements remain."))
				if("Stow Envoy")
					for(var/obj/item/treaty/carried_treaty in user.contents)
						to_chat(user, span_userdanger("I'm carrying a Treaty. I should set it down somewhere before I return."))
						return
					for(var/obj/item/storage/bag in user.contents)
						for(var/obj/item/treaty/bag_treaty in bag.contents)
							to_chat(user, span_userdanger("I'm carrying a Treaty. I should set it down somewhere before I return."))
							return
					src.linked_warband.return_envoy(user)						
					return
				else
					return
			return

		if(user.mind.warband_ID)
			if(do_after(user, 90, target = src))
				src.warband_ID = user.mind.warband_ID
				src.linked_warband = user.mind.warband_manager
				to_chat(user, span_userdanger("You have claimed this recruitment point for your Warband."))
				return
	else if(src.disabled)
		return
	// if we're not a part of the warband, we disable the rally point
	// when a rally point is disabled we also attempt to pull out any characters stored inside w/return_envoy
	user.visible_message(span_info("[user] [src.destruction_doafter]"))
	if(do_after(user, 90, target = src))
		if(src.contents.len)
			for(var/mob/living/stored_character in src.contents)
				src.linked_warband.return_envoy(null, TRUE, stored_character, src)
				to_chat(user, span_nicegreen("[stored_character] is pulled out!"))
		src.disabled = TRUE
		src.alpha = 50
		to_chat(user, span_nicegreen("[destruction_msg]"))


///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// WARBAND ESTATE IMPORT
/*

*/
/obj/structure/fluff/warband/campaign_planner/proc/import(mob/user)
	var/datum/territory_faction/user_faction

	if(user.mind.special_role == "Warlord")
		user_faction = src.linked_warband.linked_faction
	else if(user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant")
		for(var/datum/territory_faction/faction in user.mind.associated_factions)
			if(faction.owner == user.real_name)
				user_faction = faction
				break
	if(!user_faction)
		to_chat(user, span_warning("I have no faction to import from."))
		return
	if(!user_faction.territories.len)
		to_chat(user, span_warning("I have no territories to demand imports from. Woe."))
		return
	
	var/list/territory_choices = list()
	for(var/datum/territory/territory in user_faction.territories)
		territory_choices[territory.name] = territory
	var/chosen_territory_name = input(user, "Select a territory to import from:", "Estate Import") as null|anything in territory_choices
	if(!chosen_territory_name)
		return
	
	var/datum/territory/target_territory = territory_choices[chosen_territory_name]
	var/datum/goods/prized_good = target_territory.prized_good
	var/good_name = initial(prized_good.name)
	to_chat(user, span_notice("[target_territory.name] - Prized Good: [good_name]"))
	to_chat(user, span_notice("Distance: [target_territory.distance] | Faction Vault: [user_faction.vault] mammon"))
	var/amount = input(user, "How much coin should be spent on the import?", "Estate Import") as null|num
	if(!amount || amount <= 0)
		return
	amount = round(amount)

	var/location = alert(user, "Delivery Location", "Estate Import", "Warcamp (No Toll)", "City Docks (High Toll)", "Groveside (No Toll)")
	if(!location)
		return
	var/location_name = location

	var/expected_value = validate_territory_import(target_territory, location_name, amount)
	if(expected_value <= 25)
		to_chat(user, span_warning("This import's final value would be too low to yield goods after accounting for costs. Try a larger amount."))
		return

	if(user_faction.vault < amount)
		to_chat(user, span_warning("Insufficient funds in the faction vault. Need [amount]m, have [user_faction.vault]m."))
		return

	user_faction.vault -= amount
	if(execute_territory_import(target_territory, location_name, amount, user))
		if(location == "Warcamp (No Toll)")
			to_chat(user, span_warning("I withdraw goods from my warchest."))
		else if(location == "City Docks (High Toll)")
			to_chat(user, span_notice("Import affirmed. It will arrive on the docks in twelve minutes."))
		else
			to_chat(user, span_notice("Import affirmed. It shall arrive on the Groveside dock in twelve minutes."))
	else
		user_faction.vault += amount
		to_chat(user, span_warning("Import failed. Funds have been returned to the vault."))



///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// SPAWN BARRIER
/*
	a spawn barrier for warbands
	prevents warlords and lieutenants from leaving until they've sent an envoy
	can easily be bypassed if they absolutely need to go somewhere in their camp first
	it's essentially a guard rail for noobs
*/

/obj/effect/solid_invisible_barrier/warband_spawnbarrier
	var/warband_ID = 0
	var/atom/movable/screen/warband/manager/linked_warband

/obj/effect/solid_invisible_barrier/warband_spawnbarrier/Initialize()
	. = ..()
	SSwarbands.warband_machines += src

/obj/effect/solid_invisible_barrier/warband_spawnbarrier/CanPass(atom/movable/mover, turf/target)
	if(linked_warband.outskirts_established)
		return TRUE // once the outskirts are established, anyone can pass through

	if(!isliving(mover))
		return TRUE
	
	var/mob/living/carbon/human/user = mover
	
	if(!istype(user))
		return TRUE

	if(user.fixedeye)
		return TRUE
	
	if(!user.mind || !user.mind.special_role)
		return TRUE

	if(user.mind.warband_ID != src.warband_ID)
		return TRUE // if they don't match warband IDs, we let them through (as they likely deserted)
	
	var/user_role = user.mind.special_role
	
	// envoys and grunts can pass freely
	if(user_role == "Warlord's Envoy" || user_role == "Grunt")
		return TRUE

	return FALSE

/obj/effect/solid_invisible_barrier/warband_spawnbarrier/Bumped(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		var/mob/living/carbon/human/user = AM
		if(istype(user) && user.mind)
			var/user_role = user.mind.special_role
			if((user_role == "Warlord" || user_role == "Lieutenant" || user_role == "Aspirant Lieutenant") && user.mind.warband_ID == src.warband_ID)
				if(!user.fixedeye)
					to_chat(user, span_notice("I shouldn't leave so soon. I should allow our veterans and envoys to scout a path, first. \n \
											<span style='color:#a4a4a4'>(Directly control an Envoy by interacting with a Rally Point)</span> \n \
											<span style='color:#a4a4a4'>(You may temporarily bypass this barrier by approaching it in Fixed Eye Mode)</span>"))
