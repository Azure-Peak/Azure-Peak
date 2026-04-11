
/obj/structure/fluff/testportal
	name = "portal"
	icon_state = "shitportal"
	icon = 'icons/roguetown/misc/structure.dmi'
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	max_integrity = 0
	var/aportalloc = "a"

/obj/structure/fluff/testportal/Initialize()
	name = aportalloc
	..()

/obj/structure/fluff/testportal/attack_hand(mob/user)
	var/fou
	for(var/obj/structure/fluff/testportal/T in shuffle(GLOB.testportals))
		if(T.aportalloc == aportalloc)
			if(T == src)
				continue
			to_chat(user, "<b>I teleport to [T].</b>")
			playsound(src, 'sound/misc/portal_enter.ogg', 100, TRUE)
			user.forceMove(T.loc)
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>There is no portal connected to this. Report it as a bugs.</b>")
	. = ..()


/obj/structure/fluff/traveltile
	name = "travel"
	icon_state = "travel"
	icon = 'icons/turf/roguefloor.dmi'
	density = FALSE
	anchored = TRUE
	layer = ABOVE_OPEN_TURF_LAYER
	max_integrity = 0
	var/aportalid = "REPLACETHIS"
	var/aportalgoesto = "REPLACETHIS"
	var/aallmig
	var/required_trait = null

/obj/structure/fluff/traveltile/Initialize()
	GLOB.traveltiles += src
	. = ..()

/obj/structure/fluff/traveltile/Destroy()
	GLOB.traveltiles -= src
	. = ..()

/obj/structure/fluff/traveltile/proc/return_connected_turfs()
	if(!aportalgoesto)
		return list()

	var/list/travels = list()
	for(var/obj/structure/fluff/traveltile/travel in shuffle(GLOB.traveltiles))
		if(travel == src)
			continue
		if(travel.aportalid != aportalgoesto)
			continue
		travels |= get_turf(travel)
	return travels

/obj/structure/fluff/traveltile/attack_ghost(mob/dead/observer/user)
	if(!aportalgoesto)
		return
	var/fou
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			user.forceMove(T.loc)
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>It is a dead end.</b>")

/atom/movable
	var/recent_travel = 0
//  var/last_client_interact = 0  // See mob_defines.dm.

/obj/structure/fluff/traveltile/attack_hand(mob/user)
	var/fou
	if(!aportalgoesto)
		return
	if(!isliving(user))
		return
	var/mob/living/L = user
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			if(!try_living_travel(T, L))
				return
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>It is a dead end.</b>")
	. = ..()

/obj/structure/fluff/traveltile/Crossed(atom/movable/AM)
	. = ..()
	var/fou
	if(!aportalgoesto)
		return
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			if(!try_living_travel(T, L))
				return
			fou = TRUE
			break
	if(!fou)
		to_chat(AM, "<b>It is a dead end.</b>")

/obj/structure/fluff/traveltile/proc/try_living_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	if(istype(L, /mob/living/carbon/human/species/human/northern/goon))
		return FALSE
	if(!can_go(L))
		return FALSE
	if(L.pulledby)
		return FALSE
	to_chat(L, "<b>I begin to travel...</b>")
	if(do_after(L, 50, needhand = FALSE, target = src))
		if(L.pulledby)
			to_chat(L, span_warning("I can't go, something's holding onto me."))
			return FALSE
		perform_travel(T, L)
		return TRUE
	return FALSE

/obj/structure/fluff/traveltile/proc/perform_travel(obj/structure/fluff/traveltile/T, mob/living/carbon/human/L)
	if(!L.restrained(ignore_grab = TRUE)) // heavy-handedly prevents using prisoners to metagame camp locations. pulledby would stop this but prisoners can also be kicked/thrown into the tile repeatedly
		for(var/mob/living/carbon/human/H in hearers(6,src))
			if(!H.IsUnconscious() && H.stat == CONSCIOUS && !HAS_TRAIT(H, TRAIT_PARALYSIS) && !HAS_TRAIT(H, required_trait) && !HAS_TRAIT(H, TRAIT_BLIND))
				to_chat(H, "<b>I watch [L.name? L : "someone"] go through a well-hidden entrance.</b>")
				if(!(H.m_intent == MOVE_INTENT_SNEAK))
					to_chat(L, "<b>[H.name ? H : "Someone"] watches me pass through the entrance.</b>")
				ADD_TRAIT(H, required_trait, TRAIT_GENERIC)

	var/datum/component/squad_controller/squad = L.GetComponent(/datum/component/squad_controller)
	var/list/qualified_squad = list()
	if(squad)
		qualified_squad = squad.get_qualified_members(max_range = 5)

	var/atom/movable/pullingg = L.pulling

	L.recent_travel = world.time
	if(pullingg)
		pullingg.recent_travel = world.time
		pullingg.forceMove(T.loc)

	L.forceMove(T.loc)

	if(pullingg)
		L.start_pulling(pullingg, supress_message = TRUE)

	// teleport qualified squad members
	if(squad && qualified_squad.len)
		for(var/mob/living/carbon/human/species/human/northern/goon/goon in qualified_squad)
			goon.forceMove(T.loc)
			goon.recent_travel = world.time
		
		for(var/mob/living/carbon/human/species/human/northern/goon/goon in squad.followers)
			if(!(goon in qualified_squad))
				squad.remove_member(goon)
	
	for(var/mob/npc in L.friends)
		if(npc.stat == CONSCIOUS && !istype(npc, /mob/living/carbon/human/species/human/northern/goon))
			npc.forceMove(T.loc)

	return

/obj/structure/fluff/traveltile/proc/can_go(atom/movable/AM)
	. = TRUE
	var/cooldown_limit = 15 SECONDS
	if(istype(src, /obj/structure/fluff/traveltile/warband))
		cooldown_limit = 3 SECONDS // reduced cooldown for warband tiles, since they're so close together
		
	if(world.time < AM.recent_travel + cooldown_limit)
		. = FALSE
	if(. && required_trait && isliving(AM))
		var/mob/living/L = AM
		if(HAS_TRAIT(L, required_trait))
			if(world.time > L.last_client_interact + 0.3 SECONDS)
				return FALSE // we will only be travelling of our own volition (anti-afk-abuse)
			return TRUE
		else
			to_chat(L, "<b>It is a dead end.</b>")
			return FALSE

/obj/structure/fluff/traveltile/bandit
	required_trait = TRAIT_BANDITCAMP
/obj/structure/fluff/traveltile/vampire
	required_trait = TRAIT_VAMPMANSION
/obj/structure/fluff/traveltile/wretch
	required_trait = TRAIT_ZURCH //I'd tie this to trait_outlaw but unfortunately the heresiarch virtue exists so we're making a new trait instead.
/obj/structure/fluff/traveltile/drow
	required_trait = TRAIT_CAVEDWELLER	
/obj/structure/fluff/traveltile/dungeon
	name = "gate"
	desc = "This gate's enveloping darkness is so opressive you dread to step through it."
	icon = 'icons/roguetown/misc/portal.dmi'
	icon_state = "portal"
	density = FALSE
	anchored = TRUE
	max_integrity = 0
	bound_width = 96
	appearance_flags = NONE
	opacity = FALSE

/obj/structure/fluff/traveltile/eventarea

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
/////////////////////////////////// WARBAND TRAVEL TILES
/obj/structure/fluff/traveltile/warband
	name = "travel"
	var/warband_ID = 0
	var/atom/movable/screen/warband/manager/linked_warband

/obj/structure/fluff/traveltile/warband/Destroy()
	linked_warband = null
	SSwarbands.warband_machines -= src
	return ..()

/obj/structure/fluff/traveltile/warband/azure_to_intermission


/obj/structure/fluff/traveltile/warband/intermission_to_azure
	color = "#a32121"

/obj/structure/fluff/traveltile/warband/azure_to_intermission/perform_travel(obj/structure/fluff/traveltile/T, mob/living/carbon/human/L)
	..()
	var/is_friendly = (L.mind && (L.mind.warband_ID == src.warband_ID)) || (L in linked_warband.allies)
	
	if(is_friendly)
		return // members and allies don't get tracked
	
	if(!(L in linked_warband.incoming_mobs))
		linked_warband.incoming_mobs += L
		to_chat(L, span_warning("I feel eyes upon me. I've entered hostile territory."))
		for(var/mob/officer in src.linked_warband.members)
			if(!officer || !officer.mind)
				continue
			if(officer.mind.special_role == "Warlord" || officer.mind.special_role == "Lieutenant" || officer.mind.special_role == "Aspirant Lieutenant")
				to_chat(officer, span_warning("Our scouts report lurkers in our camp's outskirts. They've spotted [linked_warband.incoming_mobs.len] potential foe(s)."))
		if(linked_warband.combatmusic && linked_warband.combatmusic.len)
			if(L.cmode_music_override != linked_warband.combatmusic)
				if(!L.cmode_music_override || L.cmode_music_override.len <= 0)
					L.originalcmode = L.cmode_music
				else
					L.originalcmode = L.cmode_music_override
				L.cmode_music_override = linked_warband.combatmusic


/obj/structure/fluff/traveltile/warband/intermission_to_azure/perform_travel(obj/structure/fluff/traveltile/T, mob/living/carbon/human/L)
	..()
	linked_warband.incoming_mobs -= L
	linked_warband.besieging_mobs -= L
	if(L.originalcmode)
		L.restore_original_cmode_music()




/obj/structure/fluff/traveltile/warband/Initialize()
	..()
	SSwarbands.warband_machines += src
	src.color = null	// different colors in the editor for visual clarity, but they should appear normal in game


/obj/structure/fluff/traveltile/warband/intermission_to_outskirts
	color = "#ff8b2c"

/obj/structure/fluff/traveltile/warband/intermission_to_outskirts/perform_travel(obj/structure/fluff/traveltile/T, mob/living/carbon/human/L)
	..()
	var/is_friendly = (L.mind && (L.mind.warband_ID == src.warband_ID)) || (L in linked_warband.allies)
	if(is_friendly)
		return

	linked_warband.besieging_mobs |= L

/obj/structure/fluff/traveltile/warband/intermission_to_outskirts/try_living_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	if(!L.mind)
		return FALSE
		
	var/is_friendly = (L.mind && (L.mind.warband_ID == src.warband_ID)) || (L in linked_warband.allies)
	if(is_friendly)
		return ..()
	
	if(linked_warband.encounter_manager.attacker_rout_active)
		to_chat(L, span_warning("It's too soon for another assault."))
		return FALSE

	// there's a 90 second window for attackers to enter an outskirts encounter
	if(linked_warband.encounter_manager.encounter_active && linked_warband.encounter_manager.encounter_start_time > 0)
		var/time_elapsed = world.time - linked_warband.encounter_manager.encounter_start_time
		if(time_elapsed >= 90 SECONDS)
			to_chat(L, span_warning("It's too late to enter the fray."))
			return FALSE

	if(!linked_warband.encounter_manager.outskirts_locked)
		return ..()

	if(linked_warband.encounter_manager.prep_started)
		var/time_left = max(0, (linked_warband.outskirts_prep_timer - world.time) / 10)
		to_chat(L, span_warning("The march has already begun. We are [round(time_left)] seconds away."))
		return FALSE

	if(linked_warband.encounter_manager.encounter_disabled)
		to_chat(L, span_warning("It's too soon for another assault."))
		return FALSE

	if(linked_warband.encounter_manager.encounter_active)
		to_chat(L, span_warning("Battle rages ahead!"))
		return ..()

	if(HAS_TRAIT(L, TRAIT_ZOMBIE_SPEECH))
		return FALSE

	var/confirm = alert(L, "Begin the march to the enemy warcamp? We would arrive in around 3 minutes.", "Initiate Battle", "Yes", "No")
	if(confirm != "Yes")
		return FALSE
	if(linked_warband.encounter_manager.prep_started)
		var/time_left = max(0, (linked_warband.outskirts_prep_timer - world.time) / 10)
		to_chat(L, span_warning("The march has already begun. We are [round(time_left)] seconds away."))
		return FALSE // in case someone hit yes while someone else was mid-prompt
	if(!linked_warband.encounter_manager.outskirts_locked)
		to_chat(L, span_warning("Surprisingly enough, the path seems clear."))
		return FALSE // in case the defenses are lowered mid-prompt
	visible_message(span_boldwarning("[L] begins the long march to the enemy's line. We will arrive in three minutes."))
	linked_warband.outskirts_prep_timer = world.time + 3 MINUTES
	linked_warband.encounter_manager.begin_march()	
	return FALSE

/obj/structure/fluff/traveltile/warband/intermission_to_outskirts/attack_hand(mob/user)
	if(!istype(user, /mob/living/carbon/human))
		return
	
	var/mob/living/carbon/human/H = user

	// check if there's an active prep phase that can be cancelled
	if(linked_warband.encounter_manager.prep_started && !linked_warband.encounter_manager.encounter_active)
		var/choice = alert(H, "Call off the march to the outskirts?", "Cancel March", "Yes", "No")
		if(choice == "Yes")
			if(src.linked_warband.encounter_manager.cancel_march())
				visible_message(span_notice("[H] calls off the march to the outskirts."))
				return
		else
			return

	. = ..()


/obj/structure/fluff/traveltile/warband/outskirts_to_intermission
	color = "#28d2d8"

/obj/structure/fluff/traveltile/warband/outskirts_to_intermission/perform_travel(obj/structure/fluff/traveltile/T, mob/living/carbon/human/L)
	..()
	linked_warband.besieging_mobs -= L

/obj/structure/fluff/traveltile/warband/outskirts_to_intermission/try_living_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	var/is_friendly = (L.mind && (L.mind.warband_ID == src.warband_ID)) || (L in linked_warband.allies)
	if(is_friendly)
		return ..()

	if(HAS_TRAIT(L, TRAIT_ZOMBIE_SPEECH))
		return ..() // always let zombies leave

	if(linked_warband.encounter_manager.attacker_rout_active && (L in linked_warband.besieging_mobs) && linked_warband.encounter_manager.rout_start_time > 0)
		var/time_since_rout = world.time - linked_warband.encounter_manager.rout_start_time
		if(time_since_rout >= 80 SECONDS)
			if(!L || !L.mind)
				return FALSE
			to_chat(L, span_userdanger("They've cut off my escape route! I must bide my time for an opportunity!"))
			if(do_after(L, 20 SECONDS, needhand = FALSE, target = src))
				to_chat(L, span_warning("I've found a gap in the encirclement!"))
				perform_travel(T, L)
				return TRUE
			else
				to_chat(L, span_warning("I halt my escape attempt."))
				return FALSE

	return ..()

/obj/structure/fluff/traveltile/warband/outskirts_to_camp
	color = "#6135ff"


/obj/structure/fluff/traveltile/warband/outskirts_to_camp/try_living_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	var/is_friendly = (L.mind && (L.mind.warband_ID == src.warband_ID)) || (L in linked_warband.allies)
	if(is_friendly)
		return ..()

	if(linked_warband.encounter_manager.outskirts_locked || linked_warband.encounter_manager.encounter_active)
		if(!L || !L.mind)
			return FALSE
		to_chat(L, span_warning("The camp's defenses hold strong. I can't slip by."))
		return FALSE

	if(!linked_warband.encounter_manager.encounter_active || linked_warband.encounter_manager.encounter_disabled)
		linked_warband.besieging_mobs -= L
		return ..()
	
/obj/structure/fluff/traveltile/warband/camp_to_outskirts
	color = "#ff35f5"
	var/obj/effect/landmark/chosen_landmark

/obj/structure/fluff/traveltile/warband/camp_to_outskirts/Destroy()
	chosen_landmark = null
	return ..()


// a mirror of the envoy spawning logic for rally points, in case someone decides to leave the spawn room early
/obj/structure/fluff/traveltile/warband/camp_to_outskirts/attack_hand(mob/user)
	if(linked_warband.outskirts_established)
		if(user.mind && user.mind.warband_ID != src.warband_ID)
			linked_warband.besieging_mobs |= user
		return ..()
	
	if(user.mind.special_role == "Warlord's Envoy")
		var/readycheck = alert(user, "The road ahead could be dangerous. I won't be able to return immediately.", "VENTURE FORTH?", "I AM READY", "WAIT")
		if(readycheck == "I AM READY")
			if(chosen_landmark)
				to_chat(user, span_warning("The Rot prevented a simple walk down Azuria's main road. This is the safest route from my Warcamp."))
				to_chat(user, span_warning("Before I return, I'll need to SCOUT A PATH (Warband Verb Tab)."))
				user.forceMove(src.chosen_landmark.loc)
				user.visible_message(span_bold("[user] emerges from a hidden path!"))
				return
		return

	// if they don't match the warband ID, we assume they rebelled VERY early into the round (for whatever reason) and just let them leave
	if(user.mind.warband_ID != src.warband_ID || user.mind.special_role == "Grunt") // we'll let grunts leave too	
		if(chosen_landmark)
			user.forceMove(src.chosen_landmark.loc)
			return

	if(user.mind && (user.mind.special_role == "Warlord" || user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant"))
		if(user.mind.warband_ID == src.warband_ID)
			var/create_envoy = alert(user, "I can't leave yet. I need to send out an Envoy.", "BECOME ENVOY", "BECOME ENVOY", "No")

			if(create_envoy == "BECOME ENVOY")
				if(linked_warband.spawns <= 0)
					to_chat(user, span_warning("No reinforcements remain to serve as an Envoy. We haven't even left the camp. How the fuck did this happen?"))
					return
	
				var/list/depth_options = list("Simple Envoy", "Use a Character Slot")
				var/depth_choice = input(user, "How should the Envoy look?", "Envoy Creation") as anything in depth_options
				switch(depth_choice)
					if("Use a Character Slot")
						linked_warband.select_pref_slot(user)
						var/mob/living/envoy = src.summon_envoy_traveltile(user, null, depth_choice)
						linked_warband.load_appearance(user, envoy)
					if("Simple Envoy")
						var/list/races = list("Humen","Half-Elf","Dwarf","Elf","Aasimar")
						var/race_choice = input(user, "What species should they be?", "Envoy Creation") as anything in races
						src.summon_envoy_traveltile(user, race_choice, depth_choice)
				return
	to_chat(user, span_warning("I can't leave yet. I need to send out an ENVOY first."))
	return

/obj/structure/fluff/traveltile/warband/proc/get_random_recruit_point()
	var/list/recruit_points = list()
	for(var/obj/structure/fluff/warband/warband_recruit/point in SSwarbands.warband_machines)
		if(point.warband_ID == src.warband_ID)
			recruit_points += point

	if(recruit_points.len)
		return pick(recruit_points)
	return

/obj/structure/fluff/traveltile/warband/camp_to_outskirts/proc/summon_envoy_traveltile(mob/living/carbon/human/user, race_choice, depth_choice)
	var/mob/living/carbon/human/envoy
	var/turf/spawn_loc = get_turf(user)
	
	switch(depth_choice)
		if("Simple Envoy")
			switch(race_choice)
				if("Humen")
					envoy = new /mob/living/carbon/human/species/human/northern(spawn_loc)	
				if("Half-Elf")
					envoy = new /mob/living/carbon/human/species/human/halfelf(spawn_loc)
				if("Dwarf")
					envoy = new /mob/living/carbon/human/species/dwarf/mountain(spawn_loc)
				if("Elf")
					envoy = new /mob/living/carbon/human/species/elf/wood(spawn_loc)
				if("Aasimar")
					envoy = new /mob/living/carbon/human/species/aasimar(spawn_loc)
			envoy.real_name = pick(world.file2list("strings/rt/names/human/humsoulast.txt"))
			simple_appearance_traveltile(envoy)
		if("Use a Character Slot")
			envoy = new /mob/living/carbon/human/species/human/northern(spawn_loc)
	
	envoy.sync_mind()
	envoy.faction |= list("warband_[src.warband_ID]", "[user.real_name]_faction")			
	envoy.key = user.key
	envoy.mind.warband_ID = src.warband_ID
	envoy.mind.warband_manager = src.linked_warband
	envoy.mind.original_char = user
	envoy.mind.warband_manager.spawns--
	transfer_treaties_traveltile(user, envoy)	
	equip_envoy_traveltile(envoy)
	SSjob.AssignRole(envoy, "Warlord's Envoy")
	envoy.mind.special_role = "Warlord's Envoy"
	var/obj/structure/fluff/warband/warband_recruit/rally_point = get_random_recruit_point()
	if(rally_point)
		rally_point.contents += user
		user.mode = NPC_AI_SLEEP
	return envoy
	
/obj/structure/fluff/traveltile/warband/camp_to_outskirts/proc/equip_envoy_traveltile(mob/envoy, used_slot)
	var/datum/advclass/warband/envoy/envoy_class = new /datum/advclass/warband/envoy
	if(src.linked_warband)
		envoy.cmode_music = src.linked_warband.combatmusic
	envoy.job = envoy_class.name
	envoy_class.equipme(envoy, null, used_slot)

/obj/structure/fluff/traveltile/warband/camp_to_outskirts/proc/transfer_treaties_traveltile(mob/living/carbon/human/from_mob, mob/living/carbon/human/to_mob)
	for(var/obj/item/treaty/carried_treaty in from_mob.contents)
		carried_treaty.forceMove(to_mob.loc)
		to_mob.put_in_hands(carried_treaty)
	
	for(var/obj/item/storage/bag in from_mob.contents)
		for(var/obj/item/treaty/bag_treaty in bag.contents)
			bag_treaty.forceMove(to_mob.loc)
			to_mob.put_in_hands(bag_treaty)

/obj/structure/fluff/traveltile/warband/camp_to_outskirts/proc/simple_appearance_traveltile(mob/living/carbon/human/envoy)
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

/obj/structure/fluff/traveltile/warband/proc/summon_grunt_squad_at_tile(mob/living/carbon/human/user)
	var/atom/movable/screen/warband/manager/user_warband = user.mind.warband_manager	
	var/squad_deployed = FALSE
	for(var/mob/friend in user.friends)
		if(istype(friend, /mob/living/carbon/human/species/human/northern/goon))
			squad_deployed = TRUE
			break

	if(!COOLDOWN_FINISHED(user.mind, squad_spawn_cooldown))
		var/time_left = COOLDOWN_TIMELEFT(user.mind, squad_spawn_cooldown)
		to_chat(user, span_warning("I've recently summoned a squad. I should wait another [round(time_left / 10, 1)] seconds."))
		return FALSE

	if(user_warband.spawns <= 0)
		to_chat(user, span_userdanger("No reinforcements remain."))
		return FALSE

	if(squad_deployed)
		for(var/mob/living/carbon/human/species/human/northern/goon/abandoned_grunt in user.friends)
			if(!abandoned_grunt)
				user.friends -= abandoned_grunt
				continue
			abandoned_grunt.abandonevent()
			user.friends -= abandoned_grunt
		to_chat(user, span_warning("My previous squad has been abandoned."))

	for(var/grunts_spawned = 1, grunts_spawned <= user.mind.squad_size && user_warband.spawns > 0, grunts_spawned++)
		if(user_warband.spawns < 2)
			break
		var/mob/living/carbon/human/species/human/northern/goon/new_grunt = user_warband.get_cached_grunt(src.loc, user)
		new_grunt.patron = user.patron
		new_grunt.faction |= list("warband_[user_warband.warband_ID]", "[user.real_name]_faction")
		user.friends += new_grunt
		user_warband.spawns -= 2 // summoning via a travel tile costs twice as many spawns

	to_chat(user, span_warning("There are [user_warband.spawns] soldiers remaining. Summoning my men so far from the Camp has incurred additional attrition."))
	COOLDOWN_START(user.mind, squad_spawn_cooldown, 4 MINUTES) // cooldown for summoning via travel tile is a little longer
	return TRUE

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
