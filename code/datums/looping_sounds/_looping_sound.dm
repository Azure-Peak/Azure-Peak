GLOBAL_LIST_EMPTY(created_sound_groups)
/datum/sound_group
	var/list/reserved_channels = list()
	var/channel_count = 1
	var/last_iter = 1

/datum/sound_group/New()
	. = ..()
	reserved_channels = list()
	for(var/channel = 1 to channel_count)
		reserved_channels += SSsounds.reserve_sound_channel(src)

/datum/sound_group/torches
	channel_count = 150

/datum/sound_group/fire_loop
	channel_count = 150

/datum/sound_group/instruments
	channel_count = 32 //probably more than enough

/*
	parent	(the source of the sound)			The source the sound comes from

	mid_sounds		(list or soundfile)		Since this can be either a list or a single soundfile you can have random sounds. May contain further lists but must contain a soundfile at the end.
	mid_length		(num)					The length to wait between playing mid_sounds

	start_sound		(soundfile)				Played before starting the mid_sounds loop
	start_length	(num)					How long to wait before starting the main loop after playing start_sound

	end_sound		(soundfile)				The sound played after the main loop has concluded

	chance			(num)					Chance per loop to play a mid_sound
	volume			(num)					Sound output volume
	max_loops		(num)					The max amount of loops to run for.
	direct			(bool)					If true plays directly to provided atoms instead of from them
*/
/datum/looping_sound
	var/datum/weakref/parent // weakref to the atom we belong to
	var/datum/weakref/movement_proxy
	var/mid_sounds
	var/mid_length = 1
	var/start_sound
	var/start_length
	var/end_sound = 'sound/blank.ogg'
	var/chance
	var/volume = 100
	var/vary = FALSE
	var/max_loops = 0
	var/cur_num_loops = 0
	var/direct
	var/extra_range = 0
	var/falloff
	var/frequency
	var/stopped = TRUE
	/// If the soundloop stays in the client's played_loops so that volume is updated even when out of range.
	var/persistent_loop = FALSE
	var/cursound
	// List of WEAKREFs listening in
	var/list/thingshearing = list()
	var/ignore_walls = TRUE
	/// Has the looping started yet?
	var/loop_started = FALSE
	/// Our sound channel
	var/channel
	var/datum/sound_group/sound_group
	// A world.time snapshot of when the loop was started.
	var/starttime
	/// Which bitflag pref we check for when playing this to listeners, if any. This will check for its ABSENCE, not its presence.
	var/filter_pref

/datum/looping_sound/New(_parent, start_immediately=FALSE, _direct=FALSE, _channel = 0)
	if(islist(_parent))
		WARNING("A looping sound datum was created using a list, this is no longer allowed please change to a parent")
		return

	var/datum/sound_group/group
	if(sound_group)
		for(var/datum/sound_group/listed in GLOB.created_sound_groups)
			if(listed.type != sound_group)
				continue
			group = listed
		if(!group)
			group = new sound_group
			GLOB.created_sound_groups |= group
		if(group.last_iter >= group.channel_count)
			group.last_iter = 1

		var/picked_channel = group.reserved_channels[group.last_iter]
		group.last_iter++
		channel = picked_channel

	parent = WEAKREF(_parent)
	direct = _direct

	if(_channel)
		channel = _channel
	if(!channel)
		channel = SSsounds.reserve_sound_channel(src)

	if(start_immediately)
		start()


/datum/looping_sound/Destroy()
	stop()
	// really seriously make sure we have like none of these references hanging...
	for (var/datum/weakref/listener_ref in thingshearing)
		var/mob/M = listener_ref.resolve()
		if (M?.client)
			M.client.played_loops -= src
	// explicitly free our channel, since we might have a ref left in SSsounds
	if (channel)
		SSsounds.free_datum_channels(src)
		channel = null
	parent = null
	movement_proxy = null
	thingshearing = null
	return ..()


/datum/looping_sound/proc/start(atom/on_behalf_of)
	stopped = FALSE
	if(on_behalf_of)
		set_parent(on_behalf_of)
	loop_started = TRUE
	on_start()


/datum/looping_sound/proc/stop(null_parent)
	stopped = TRUE
	if(null_parent)
		set_parent(null)
	on_stop()
	loop_started = FALSE


/datum/looping_sound/proc/sound_loop()
	if(!cursound)
		cursound = get_sound()

	if(max_loops && cur_num_loops >= max_loops)
		cur_num_loops = 0
		stop()
		return 1
	else if(max_loops)
		cur_num_loops++
	if(stopped)
		stop()
		return 1
	if(!chance || prob(chance))
		play(cursound)


/datum/looping_sound/proc/play(soundfile)
	var/sound/S = soundfile
	if(!istype(S))
		S = sound(soundfile)
	if(direct)
		S.channel = channel
		S.volume = volume
	var/atom/thing = parent.resolve()
	if (!thing)
		return

	starttime = world.time

	if(direct)
		if(ismob(thing))
			var/mob/mob = thing
			if(filter_pref && mob.client)
				if(!(mob.client.prefs.toggles & filter_pref))
					return
			mob.playsound_local(mob, S, volume, vary, frequency, falloff, repeat = src, channel = channel)
	else
		var/list/R = playsound(thing, S, volume, vary, extra_range, falloff, frequency, channel, ignore_walls = ignore_walls, repeat = src, pref_toggle = (filter_pref ? filter_pref : null))
		if(!R || !R.len)
			R = list()
		for(var/datum/weakref/listener_ref in thingshearing)
			var/mob/M = listener_ref.resolve()
			if(!M || !M.client)
				thingshearing -= listener_ref
				continue
			if(!(M in R) || M.IsSleeping())// they are out of range
				var/list/L = M.client.played_loops[src]
				if(L)
					var/sound/SD = L["SOUND"]
					if(SD)
						if(persistent_loop)
							L["MUTESTATUS"] = TRUE
							L["VOL"] = 0
							M.mute_sound(SD)
							//M.play_ambience()
						else
							M.client.played_loops -= src
							thingshearing -= listener_ref
							M.stop_sound_channel(SD.channel)
			else
				on_hear_sound(M)


/datum/looping_sound/proc/on_hear_sound(mob/M)
	if(!persistent_loop || !M?.client)
		return

	var/list/L = M.client.played_loops[src]
	if(!L)
		return

	L["MUTESTATUS"] = FALSE
	L["VOL"] = volume

	var/sound/SD = L["SOUND"]
	if(SD)
		M.unmute_sound(SD)


/datum/looping_sound/proc/get_sound(_mid_sounds)
	. = _mid_sounds || mid_sounds
	while(!isfile(.) && !isnull(.))
		. = pickweight(.)


/datum/looping_sound/proc/on_start()
	var/start_wait = 0
	if(start_sound) //does ANYTHING even use start_sound
		play(start_sound)
		start_wait = start_length
	if(persistent_loop && !cursound)
		cursound = get_sound(mid_sounds)
	addtimer(CALLBACK(src, PROC_REF(begin_loop)), start_wait, TIMER_CLIENT_TIME)
	if(persistent_loop && !(src in GLOB.persistent_sound_loops))
		GLOB.persistent_sound_loops += src

/datum/looping_sound/proc/begin_loop()
	sound_loop()
	if(persistent_loop)
		SSsoundloopers.mark_loop_dirty(src)
	START_PROCESSING(SSsoundloopers, src)


/datum/looping_sound/proc/on_stop()
//	play(end_sound)
	STOP_PROCESSING(SSsoundloopers, src)
	if(persistent_loop)
		GLOB.persistent_sound_loops -= src
	if(!direct)
		for(var/datum/weakref/listener_ref in thingshearing)
			var/mob/M = listener_ref.resolve()
			if (!M)
				continue
			if(M.client)
				var/list/L = M.client.played_loops[src]
				if(L)
					var/sound/SD = L["SOUND"]
					if(SD)
						M.stop_sound_channel(SD.channel)
					M.client.played_loops -= src
					thingshearing -= listener_ref
	else
		var/mob/P = parent.resolve()
		if(P && P.client)
			P.stop_sound_channel(channel) //This is mostly used for weather


// handling movement of sound source
/datum/looping_sound/proc/handle_move(atom/new_parent)
	var/atom/movable/old_proxy = movement_proxy?.resolve()
	if(old_proxy)
		UnregisterSignal(old_proxy, COMSIG_MOVABLE_MOVED)
	movement_proxy = null

	if(!persistent_loop || !ismovableatom(new_parent))
		return

	var/atom/movable/proxy = get_atom_on_turf(new_parent)
	if(!ismovableatom(proxy))
		return

	if(proxy == new_parent)
		return

	movement_proxy = WEAKREF(proxy)
	RegisterSignal(proxy, COMSIG_MOVABLE_MOVED, PROC_REF(handle_parent_move))


/datum/looping_sound/proc/set_parent(new_parent)
	var/atom/real_parent = parent.resolve()

	if(real_parent)
		UnregisterSignal(real_parent, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
	handle_move()
	if(new_parent)
		if(istype(new_parent, /datum/weakref)) // probably shouldn't happen but it does, so?
			var/datum/weakref/passed_weakref = new_parent
			new_parent = passed_weakref.resolve()
		parent = WEAKREF(new_parent)
		RegisterSignal(new_parent, COMSIG_PARENT_QDELETING, PROC_REF(handle_parent_del))
		if(persistent_loop)
			RegisterSignal(new_parent, COMSIG_MOVABLE_MOVED, PROC_REF(handle_parent_move))
		handle_move(new_parent)


/datum/looping_sound/proc/handle_parent_del(datum/source)
	SIGNAL_HANDLER
	set_parent(null)


/datum/looping_sound/proc/handle_parent_move(datum/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	if(loop_started)
		SSsoundloopers.mark_loop_dirty(src)
