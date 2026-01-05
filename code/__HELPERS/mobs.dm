/proc/random_blood_type()
	return pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

/proc/random_eye_color()
	switch(pick(20;"brown",20;"hazel",20;"grey",15;"blue",15;"green",1;"amber",1;"albino"))
		if("brown")
			return "630"
		if("hazel")
			return "542"
		if("grey")
			return pick("666","777","888","999","aaa","bbb","ccc")
		if("blue")
			return "36c"
		if("green")
			return "060"
		if("amber")
			return "fc0"
		if("albino")
			return pick("c","d","e","f") + pick("0","1","2","3","4","5","6","7","8","9") + pick("0","1","2","3","4","5","6","7","8","9")
		else
			return "000"

/proc/random_backpack()
	return pick(GLOB.backpacklist)

/proc/random_features()
	return MANDATORY_FEATURE_LIST

/proc/random_unique_name(gender, attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		if(gender==FEMALE)
			. = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			. = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

		if(!findname(.))
			break

/proc/random_unique_lizard_name(gender, attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(lizard_name(gender))

		if(!findname(.))
			break

/proc/random_unique_plasmaman_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(plasmaman_name())

		if(!findname(.))
			break

/proc/random_unique_ethereal_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(ethereal_name())

		if(!findname(.))
			break

/proc/random_unique_moth_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(pick(GLOB.moth_first)) + " " + capitalize(pick(GLOB.moth_last))

		if(!findname(.))
			break


GLOBAL_LIST_INIT(skin_tones, sortList(list(
	"skin1" = "ffe0d1",
	"skin2" = "fcccb3",
	"skin3" = "e8b59b"
	)))

/proc/random_skin_tone()
	return GLOB.skin_tones[pick(GLOB.skin_tones)]

GLOBAL_LIST_INIT(haircolor, sortList(list(
	"black" = "#0a0707",
	"brown" = "#362e25",
	"blonde" = "#dfc999",
	"red" = "#a34332"
	)))


/proc/random_haircolor()
	return GLOB.haircolor[pick(GLOB.haircolor)]

GLOBAL_LIST_INIT(oldhc, sortList(list(
	"decay" = "6a6a6a",
	"elderly" = "9e9e9e",
	"ancient" = "c9c9c9",
	"mythic" = "f4f4f4"
	)))

/proc/skintone2hex(skin_tone)
	. = 0
	switch(skin_tone)
		if("caucasian1")
			. = "ffe0d1"
		if("caucasian2")
			. = "fcccb3"
		if("caucasian3")
			. = "e8b59b"
		if("latino")
			. = "d9ae96"
		if("mediterranean")
			. = "c79b8b"
		if("asian1")
			. = "ffdeb3"
		if("asian2")
			. = "e3ba84"
		if("arab")
			. = "c4915e"
		if("indian")
			. = "b87840"
		if("african1")
			. = "754523"
		if("african2")
			. = "471c18"
		if("albino")
			. = "fff4e6"
		if("orange")
			. = "ffc905"
		if("skin1")
			. = "ffe0d1"
		if("skin2")
			. = "fcccb3"
		if("skin3")
			. = "e8b59b"

/proc/haircolor2hex(haircolor)
	. = 0
	switch(haircolor)
		if("cave black")
			. = "#0a0707"
		if("mud brown")
			. = "#362e25"
		if("pale blonde")
			. = "#dfc999"
		if("dusk red")
			. = "#a34332"
		if("decay grey")
			. = "#6a6a6a"


GLOBAL_LIST_EMPTY(species_list)

/proc/age2agedescription(age)
	switch(age)
		if(0 to 30)
			return "young adult"
		if(30 to 45)
			return "adult"
		if(45 to 60)
			return "middle-aged"
		if(60 to 70)
			return "aging"
		if(70 to INFINITY)
			return "elderly"
		else
			return "unknown"

/proc/do_mob(mob/user , mob/target, time = 30, uninterruptible = 0, progress = 1, datum/callback/extra_checks = null, double_progress = 0, can_move = TRUE)
	if(!user || !target)
		return 0

	if(user.doing)
		return 0
	user.doing = 1

	var/holding = user.get_active_held_item()
	var/datum/progressbar/progbar
	var/datum/progressbar/progbartarget
	if (progress)
		progbar = new(user, time, target)
	if (double_progress)
		progbartarget = new(target, time, user)

	var/endtime = world.time+time
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		stoplag(1)
		if (progress)
			progbar.update(world.time - starttime)
		if(double_progress)
			progbartarget.update(world.time - starttime)
		if(QDELETED(user) || QDELETED(target))
			. = 0
			break

		if(!user.doing)
			. = 0
			break

		if(uninterruptible)
			continue

		if(!can_move && (!user.Adjacent(target)))
			. = 0
			break
			
		if(user.get_active_held_item() != holding || user.incapacitated() || (extra_checks && !extra_checks.Invoke()))
			. = 0
			break
	user.doing = 0
	if (progress)
		qdel(progbar)
	if (double_progress)
		qdel(progbartarget)


//some additional checks as a callback for for do_afters that want to break on losing health or on the mob taking action
/mob/proc/break_do_after_checks(list/checked_health, check_clicks)
	if(check_clicks && next_move > world.time)
		return FALSE
	return TRUE

//pass a list in the format list("health" = mob's health var) to check health during this
/mob/living/break_do_after_checks(list/checked_health, check_clicks)
	if(islist(checked_health))
		if(health < checked_health["health"])
			return FALSE
		checked_health["health"] = health
	return ..()

/mob
	var/doing = FALSE
	var/pronouns = null // LETHALSTONE ADDITION: this is cheap so i'm doing it. preferences in human will set this appropriately
	var/obscured_flags = NONE

/**
 * Timed action involving one mob user. Target is optional.
 *
 * mob/user - The mob performing the action.
 *
 * delay = the time in deciseconds. Use time defines (SECONDS, MINUTES) for readability.
 * 
 * needhand - check for an empty hand
 * 
 * target - the target of the action
 *
 * progress - whether to display a progress bar
 * 
 * datum/callback/extra_checks - additional check callbacks to perform during do_after
 * 
 * same_direction - whether the mob performing the action may switch directions or not
 * 
 * interrupt - whether to interrupt a prior do_after or not
*/

/proc/do_after(mob/user, delay, needhand = TRUE, atom/target = null, progress = TRUE, datum/callback/extra_checks = null, same_direction = FALSE, no_interrupt = FALSE)
	if(!user)
		return FALSE

	if(user.doing)
		if(no_interrupt)
			return
		return FALSE

	user.doing = TRUE

	var/atom/Tloc = null
	if(target && !isturf(target))
		Tloc = target.loc

	var/atom/Uloc = user.loc
	var/original_dir = user.dir

	var/drifting = FALSE

	var/holding = user.get_active_held_item()

	var/holdingnull = TRUE //User's hand started out empty, check for an empty hand
	if(holding)
		holdingnull = FALSE //Users hand started holding something, check to see if it's still holding that

	delay *= user.do_after_coefficent()

	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, delay, user)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = TRUE
	while (world.time < endtime)
		stoplag(1)
		if (progress)
			progbar.update(world.time - starttime)

		if(QDELETED(user) || user.stat || (!drifting && user.loc != Uloc) || (extra_checks && !extra_checks.Invoke()) || (same_direction && user.dir != original_dir))
			. = FALSE
			break

		if(!user.doing)
			. = FALSE
			break

		if(isliving(user))
			var/mob/living/L = user
			if(L.IsStun() || L.IsParalyzed())
				. = FALSE
				break

		if(!QDELETED(Tloc) && (QDELETED(target) || Tloc != target.loc))
			if((Uloc != Tloc || Tloc != user) && !drifting)
				. = FALSE
				break

		if(needhand)
			//This might seem like an odd check, but you can still need a hand even when it's empty
			//i.e the hand is used to pull some item/tool out of the construction
			if(!holdingnull)
				if(!holding)
					. = FALSE
					break
			if(user.get_active_held_item() != holding)
				. = FALSE
				break
	user.doing = FALSE
	if (progress)
		qdel(progbar)

/// do_after copypasta but you can move
/proc/move_after(mob/user, delay, needhand = 1, atom/target = null, progress = 1, datum/callback/extra_checks = null, same_direction = FALSE)
	if(!user)
		return 0

	if(user.doing)
		return 0
	user.doing = 1

	var/atom/Tloc = null
	if(target && !isturf(target))
		Tloc = target.loc

	var/atom/Uloc = user.loc
	var/original_dir = user.dir

	var/drifting = 0

	var/holding = user.get_active_held_item()

	var/holdingnull = 1 //User's hand started out empty, check for an empty hand
	if(holding)
		holdingnull = 0 //Users hand started holding something, check to see if it's still holding that

	delay *= user.do_after_coefficent()

	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, delay, user)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		stoplag(1)
		if (progress)
			progbar.update(world.time - starttime)

		Uloc = user?.loc
		Tloc = target?.loc

		if(QDELETED(user) || user.stat || !Tloc?.Adjacent(Uloc) || (extra_checks && !extra_checks.Invoke()) || (same_direction && user.dir != original_dir))
			. = 0
			break

		if(!user.doing)
			. = 0
			break

		if(isliving(user))
			var/mob/living/L = user
			if(L.IsStun() || L.IsParalyzed())
				. = 0
				break

		if(!QDELETED(Tloc) && (QDELETED(target) || Tloc != target.loc))
			if((Uloc != Tloc || Tloc != user) && !drifting)
				. = 0
				break

		if(needhand)
			//This might seem like an odd check, but you can still need a hand even when it's empty
			//i.e the hand is used to pull some item/tool out of the construction
			if(!holdingnull)
				if(!holding)
					. = 0
					break
			if(user.get_active_held_item() != holding)
				. = 0
				break
	user.doing = 0
	if (progress)
		qdel(progbar)

/mob/proc/do_after_coefficent() // This gets added to the delay on a do_after, default 1
	. = 1
	return

/proc/do_after_mob(mob/user, list/targets, time = 30, uninterruptible = 0, progress = 1, datum/callback/extra_checks, required_mobility_flags = MOBILITY_STAND)
	if(!user || !targets)
		return 0

	if(user.doing)
		return 0
	user.doing = 1

	if(!islist(targets))
		targets = list(targets)
	var/user_loc = user.loc

	var/drifting = 0

	var/list/originalloc = list()
	for(var/atom/target in targets)
		originalloc[target] = target.loc

	var/holding = user.get_active_held_item()
	var/datum/progressbar/progbar
	if(progress)
		progbar = new(user, time, targets[1])

	var/endtime = world.time + time
	var/starttime = world.time
	var/mob/living/L
	if(isliving(user))
		L = user
	. = 1
	mainloop:
		while(world.time < endtime)
			stoplag(1)
			if(progress)
				progbar.update(world.time - starttime)
			if(QDELETED(user) || !targets)
				. = 0
				break
			if(!user.doing)
				. = 0
				break

			if(uninterruptible)
				continue

			if(L && !CHECK_MULTIPLE_BITFIELDS(L.mobility_flags, required_mobility_flags))
				. = 0
				break

			for(var/atom/target in targets)
				if((!drifting && user_loc != user.loc) || QDELETED(target) || originalloc[target] != target.loc || user.get_active_held_item() != holding || user.incapacitated() || (extra_checks && !extra_checks.Invoke()))
					. = 0
					break mainloop
	user.doing = 0
	if(progbar)
		qdel(progbar)

/proc/is_species(A, species_datum)
	. = FALSE
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.dna && istype(H.dna.species, species_datum))
			. = TRUE

/proc/spawn_atom_to_turf(spawn_type, target, amount, admin_spawn=FALSE, list/extra_args)
	var/turf/T = get_turf(target)
	if(!T)
		CRASH("attempt to spawn atom type: [spawn_type] in nullspace")

	var/list/new_args = list(T)
	if(extra_args)
		new_args += extra_args
	var/atom/X
	for(var/j in 1 to amount)
		X = new spawn_type(arglist(new_args))
		if (admin_spawn)
			X.flags_1 |= ADMIN_SPAWNED_1
	return X //return the last mob spawned

/proc/spawn_and_random_walk(spawn_type, target, amount, walk_chance=100, max_walk=3, always_max_walk=FALSE, admin_spawn=FALSE)
	var/turf/T = get_turf(target)
	var/step_count = 0
	if(!T)
		CRASH("attempt to spawn atom type: [spawn_type] in nullspace")

	var/list/spawned_mobs = new(amount)

	for(var/j in 1 to amount)
		var/atom/movable/X

		if (istype(spawn_type, /list))
			var/mob_type = pick(spawn_type)
			X = new mob_type(T)
		else
			X = new spawn_type(T)

		if (admin_spawn)
			X.flags_1 |= ADMIN_SPAWNED_1

		spawned_mobs[j] = X

		if(always_max_walk || prob(walk_chance))
			if(always_max_walk)
				step_count = max_walk
			else
				step_count = rand(1, max_walk)

			for(var/i in 1 to step_count)
				step(X, pick(NORTH, SOUTH, EAST, WEST))

	return spawned_mobs

// Displays a message in deadchat, sent by source. Source is not linkified, message is, to avoid stuff like character names to be linkified.
// Automatically gives the class deadsay to the whole message (message + source)
/proc/deadchat_broadcast(message, source=null, mob/follow_target=null, turf/turf_target=null, speaker_key=null, message_type=DEADCHAT_REGULAR)
	message = span_deadsay("[source]<span class='linkify'>[message]</span>")
	for(var/mob/M in GLOB.player_list)
		var/datum/preferences/prefs
		if(M.client.prefs)
			prefs = M.client.prefs
		else
			prefs = new

		var/override = FALSE
		if(M.client.holder && (prefs.chat_toggles & CHAT_DSAY))
			override = TRUE
		if(HAS_TRAIT(M, TRAIT_SIXTHSENSE))
			override = TRUE
		if(isnewplayer(M) && !override)
			continue
		if(M.stat != DEAD && !override)
			continue
		if(speaker_key && (speaker_key in prefs.ignoring))
			continue

		switch(message_type)
			if(DEADCHAT_DEATHRATTLE)
				if(prefs.toggles & DISABLE_DEATHRATTLE)
					continue
			if(DEADCHAT_ARRIVALRATTLE)
				if(prefs.toggles & DISABLE_ARRIVALRATTLE)
					continue

		if(isobserver(M))
			var/rendered_message = message

			if(follow_target)
//				var/F
//				if(turf_target)
//					F = FOLLOW_OR_TURF_LINK(M, follow_target, turf_target)
//				else
//					F = FOLLOW_LINK(M, follow_target)
//				rendered_message = "[F] [message]"
				rendered_message = "[message]"
			else if(turf_target)
//				var/turf_link = TURF_LINK(M, turf_target)
//				rendered_message = "[turf_link] [message]"
				rendered_message = "[message]"

			to_chat(M, rendered_message)
		else
			to_chat(M, message)

//Used in chemical_mob_spawn. Generates a random mob based on a given gold_core_spawnable value.
/proc/create_random_mob(spawn_location, mob_class = HOSTILE_SPAWN)
	var/static/list/mob_spawn_meancritters = list() // list of possible hostile mobs
	var/static/list/mob_spawn_nicecritters = list() // and possible friendly mobs

	if(mob_spawn_meancritters.len <= 0 || mob_spawn_nicecritters.len <= 0)
		for(var/T in typesof(/mob/living/simple_animal))
			var/mob/living/simple_animal/SA = T
			switch(initial(SA.gold_core_spawnable))
				if(HOSTILE_SPAWN)
					mob_spawn_meancritters += T
				if(FRIENDLY_SPAWN)
					mob_spawn_nicecritters += T

	var/chosen
	if(mob_class == FRIENDLY_SPAWN)
		chosen = pick(mob_spawn_nicecritters)
	else
		chosen = pick(mob_spawn_meancritters)
	var/mob/living/simple_animal/C = new chosen(spawn_location)
	return C

/proc/passtable_on(target, source)
	var/mob/living/L = target
	if (!HAS_TRAIT(L, TRAIT_PASSTABLE) && L.pass_flags & PASSTABLE)
		ADD_TRAIT(L, TRAIT_PASSTABLE, INNATE_TRAIT)
	ADD_TRAIT(L, TRAIT_PASSTABLE, source)
	L.pass_flags |= PASSTABLE

/proc/passtable_off(target, source)
	var/mob/living/L = target
	REMOVE_TRAIT(L, TRAIT_PASSTABLE, source)
	if(!HAS_TRAIT(L, TRAIT_PASSTABLE))
		L.pass_flags &= ~PASSTABLE

/proc/dance_rotate(atom/movable/AM, datum/callback/callperrotate, set_original_dir=FALSE)
	set waitfor = FALSE
	var/originaldir = AM.dir
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		if(!AM)
			return
		AM.setDir(i)
		callperrotate?.Invoke()
		sleep(1)
	if(set_original_dir)
		AM.setDir(originaldir)

//When you cop out of the round
/mob/proc/make_me_an_observer(var/existing = FALSE)
	var/mob/dead/new_player/lobbyer

	if(!existing)
		lobbyer = src
		var/choice = alert(src,"Are you sure you wish to observe? Playing is a lot more fun.","VOYEUR","Yes","No")

		if(QDELETED(src) || !client || choice != "Yes")
			lobbyer.ready = PLAYER_NOT_READY
			src << browse(null, "window=playersetup") //closes the player setup window
			lobbyer.new_player_panel()
			return FALSE
	else
		var/choice = alert(src, "Are you sure you wish to let go and observe?", "LET GO", "Yes", "No")

		if(stat != DEAD || choice != "Yes")
			return FALSE

	var/mob/dead/observer/observer	// Transfer safety to observer spawning proc.
	if(check_rights(R_WATCH, FALSE))
		observer = new /mob/dead/observer/admin(src)
	else
		observer = new /mob/dead/observer/rogue/nodraw(src)
	if(!existing)
		lobbyer.spawning = TRUE

	observer.started_as_observer = TRUE
	if(!existing)
		lobbyer.close_spawn_windows()
		var/obj/effect/landmark/observer_start/O = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
		to_chat(src, span_notice("Now teleporting."))
		if (O)
			observer.forceMove(O.loc)
		else
			to_chat(src, span_notice("Teleporting failed. Ahelp an admin please"))
			stack_trace("There's no freaking observer landmark available on this map or you're making observers before the map is initialised")

	observer.key = key
	observer.client = client
	observer.set_ghost_appearance()
	if(observer.client)
		observer.client.update_ooc_verb_visibility()
	if(observer.client && observer.client.prefs)
		observer.real_name = observer.client.prefs.real_name
		observer.name = observer.real_name
	observer.update_icon()
	observer.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	if(!existing)
		qdel(mind)
		mind = null
		qdel(src)
	return TRUE
