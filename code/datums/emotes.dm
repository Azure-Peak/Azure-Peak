/datum/emote
	var/key = "" //What calls the emote
	var/key_third_person = "" //This will also call the emote
	var/message = "" //Message displayed when emote is used
	var/message_mime = "" //Message displayed if the user is a mime
	var/message_monkey = "" //Message displayed if the user is a monkey
	var/message_simple = "" //Message to display if the user is a simple_animal
	var/message_param = "" //Message to display if a param was given
	var/message_muffled = null //Message to display if the user is muffled
	var/emote_type = EMOTE_VISIBLE //Whether the emote is visible or audible
	var/restraint_check = FALSE //Checks if the mob is restrained before performing the emote
	var/muzzle_ignore = FALSE //Will only work if the emote is EMOTE_AUDIBLE
	var/list/mob_type_allowed_typecache = /mob //Types that are allowed to use that emote
	var/list/mob_type_blacklist_typecache //Types that are NOT allowed to use that emote
	var/list/mob_type_ignore_stat_typecache
	var/stat_allowed = CONSCIOUS
	var/sound //Sound to play when emote is called
	var/vary = FALSE	//used for the honk borg emote
	var/only_forced_audio = FALSE //can only code call this event instead of the player.
	var/nomsg = FALSE
	var/soundping = TRUE
	var/ignore_silent = FALSE
	var/snd_vol = 100
	var/snd_range = -1
	var/mute_time = 30//time after where someone can't do another emote
	// Whether this should show on runechat
	var/show_runechat = TRUE
	// Explicitly defined runechat message, if it's not defined and `show_runechat` is TRUE then it will use `message` instaed
	var/runechat_msg = null
	// If this is true, we skip setting the base runechat message and instead use whatever our at-emote-runtime message is. Useful for things like kiss/lick which change message based on conditions.
	var/use_params_for_runechat = FALSE
	var/is_animal = FALSE

/datum/emote/New()
	if(!runechat_msg && !use_params_for_runechat)
		//strip punctuation
		var/static/regex/regex = regex(@"[,.!?]", "g")
		runechat_msg = regex.Replace(message, "")
		runechat_msg = trim(runechat_msg, MAX_MESSAGE_LEN)

	if (ispath(mob_type_allowed_typecache))
		switch (mob_type_allowed_typecache)
			if (/mob)
				mob_type_allowed_typecache = GLOB.typecache_mob
			if (/mob/living)
				mob_type_allowed_typecache = GLOB.typecache_living
			else
				mob_type_allowed_typecache = typecacheof(mob_type_allowed_typecache)
	else
		mob_type_allowed_typecache = typecacheof(mob_type_allowed_typecache)
	mob_type_blacklist_typecache = typecacheof(mob_type_blacklist_typecache)
	mob_type_ignore_stat_typecache = typecacheof(mob_type_ignore_stat_typecache)

/datum/emote/proc/adjacentaction(mob/user, mob/target)
	return

/datum/emote/proc/run_emote(mob/user, params, type_override, intentional = FALSE, targetted = FALSE, animal = FALSE)
	. = TRUE
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	if(only_forced_audio && intentional)
		return FALSE
	if(targetted)
		var/list/mobsadjacent = list()
		var/mob/chosenmob
		for(var/mob/living/M in range(user, 2))
			if(M != user)
				mobsadjacent += M
		if(mobsadjacent.len)
			chosenmob = tgui_input_list(user, "[key] who?", "XYLIX", mobsadjacent)
		if(chosenmob)
			if(user.Adjacent(chosenmob))
				params = chosenmob.name
				adjacentaction(user, chosenmob)
	var/raw_msg = select_message_type(user, intentional)
	var/msg = raw_msg
	if(params && message_param)
		msg = select_param(user, params)

	msg = replace_pronoun(user, msg)

	if(!msg && nomsg == FALSE)
		return

	// A COMSIG here would be nice, in my attempts it sadly didn't work out well for the relay.
	var/atom/movable/emotelocation = user
	var/mob/living/carbon/human/human
	if(ishuman(user))
		human = user

	var/obj/item/organ/dullahan_vision/vision
	var/datum/species/dullahan/dullahan
	if(isdullahan(user))
		dullahan = human.dna.species
		vision = human.getorganslot(ORGAN_SLOT_HUD)
		if(dullahan.headless && vision.viewing_head)
			emotelocation = dullahan.my_head


	var/pitch = 1 //bespoke vary system so deep voice/high voiced humans
	if(isliving(user))
		var/mob/living/L = user
		pitch = L.get_emote_pitch()

	var/sound/tmp_sound = get_sound(user)
	if(!istype(tmp_sound))
		tmp_sound = sound(get_sfx(tmp_sound))
	tmp_sound.frequency = pitch
	if(tmp_sound && tmp_sound.file && (!only_forced_audio || !intentional))
		// Specifying what bodyparts are needed to run an emote is a desireable replacement.
		// Band-aid so emotes with sound aren't misplaced. You can still point with your head, for example.
		var/soundfile = tmp_sound.file
		if(dullahan && dullahan.headless)
			if(findtext("[soundfile]", @"sound/vo"))
				emotelocation = dullahan.my_head
			else// if(!vision.viewing_head)
				emotelocation = user

		playsound(emotelocation, tmp_sound, snd_vol, FALSE, snd_range, soundping = soundping, animal_pref = animal)
	if(!nomsg)
		user.log_message(msg, LOG_EMOTE)
		var/pre_color_msg = msg
		if (use_params_for_runechat) // apply puncutation stripping here where appropriate
			var/static/regex/regex = regex(@"[,.!?]", "g")
			pre_color_msg = regex.Replace(pre_color_msg, "")
			pre_color_msg = trim(pre_color_msg, MAX_MESSAGE_LEN)
		// Checks to see if we're emoting on the body while we have a head, or if we're emoting on the head.
		if(human && human.voice_color)
			msg = "<span style='color:#[human.voice_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[emotelocation]</b></span> " + msg
		else
			msg = "<b>[emotelocation]</b> " + msg
		for(var/mob/M in GLOB.dead_mob_list)
			if(!M.client || isnewplayer(M))
				continue
			var/T = get_turf(emotelocation)
			if(M.stat == DEAD && M.client && (M.client.prefs?.chat_toggles & CHAT_GHOSTSIGHT) && !(M in viewers(T, null)))
				M.show_message(msg)
		var/runechat_msg_to_use = null
		if(show_runechat)
			runechat_msg_to_use = runechat_msg ? runechat_msg : pre_color_msg
		if(emote_type == EMOTE_AUDIBLE)
			emotelocation.audible_message(msg, runechat_message = runechat_msg_to_use, log_seen = SEEN_LOG_EMOTE)
		else
			emotelocation.visible_message(msg, runechat_message = runechat_msg_to_use, log_seen = SEEN_LOG_EMOTE)

/mob/living/proc/get_emote_pitch()
	return clamp(voice_pitch, 0.5, 2)

/mob/living/carbon/human/get_emote_pitch()
	var/final_pitch = ..()
	var/pitch_modifier = 0
	if(STASTR > 10)
		pitch_modifier -= (STASTR - 10) * 0.03
	else if(STASTR < 10)
		pitch_modifier += (10 - STASTR) * 0.03
	return clamp(final_pitch + pitch_modifier, 0.5, 2)
/datum/emote/proc/get_env(mob/living/user)
	return




/datum/emote/living/get_env(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.head)
			var/obj/item/clothing/I = H.head
			if(I.emote_environment)
				return I.emote_environment

/datum/emote/proc/get_sound(mob/living/user)
	if(sound)
		return sound

/datum/emote/living/get_sound(mob/living/user)
	if(sound)
		return sound
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/used_sound
			var/possible_sounds
			var/modifier
			if(H.age == AGE_OLD)
				modifier = "old"
			if((!ignore_silent && (H.silent)) || (!ignore_silent && !is_emote_muffled(H)) || (!ignore_silent && HAS_TRAIT(H, TRAIT_MUTE)) ||  (!ignore_silent && HAS_TRAIT(H, TRAIT_BAGGED)))
				modifier = "silenced"
			if(user.gender == FEMALE && H.dna.species.soundpack_f)
				possible_sounds = H.dna.species.soundpack_f.get_sound(key,modifier)
			else if(H.dna.species.soundpack_m)
				possible_sounds = H.dna.species.soundpack_m.get_sound(key,modifier)
			 // LETHALSTONE ADDITION BEGIN: use preference-set voice types where possible
			if(H.voice_type)
				switch (H.voice_type)
					if (VOICE_TYPE_MASC)
						possible_sounds = H.dna.species.soundpack_m.get_sound(key, modifier)
					else
						if (H.dna.species.soundpack_f)
							possible_sounds = H.dna.species.soundpack_f.get_sound(key, modifier)
						else
							possible_sounds = H.dna.species.soundpack_m.get_sound(key, modifier)
			// LETHALSTONE ADDITION END
			if(possible_sounds)
				if(islist(possible_sounds))
					var/list/PS = possible_sounds
					if(PS.len > 1)
						used_sound = pick_n_take(possible_sounds)
						if(used_sound == H.last_sound)
							used_sound = pick(possible_sounds)
					else
						used_sound = pick(possible_sounds)
				else //direct file
					used_sound = possible_sounds
				H.last_sound = used_sound
				return used_sound
		else
			return user.get_sound(key)

/mob/living/proc/get_sound(input)
	return

/datum/emote/proc/replace_pronoun(mob/user, msg)
	if(findtext(msg, "their"))
		msg = replacetext(msg, "their", user.p_their())
	if(findtext(msg, "them"))
		msg = replacetext(msg, "them", user.p_them())
	if(findtext(msg, "%s"))
		msg = replacetext(msg, "%s", user.p_s())
	return msg

/datum/emote/proc/select_message_type(mob/user, intentional)
	. = message
	if(message_muffled && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent)
			. = message_muffled
		if(!muzzle_ignore && HAS_TRAIT(C, TRAIT_MUTE) && emote_type == EMOTE_AUDIBLE)
			. = message_muffled
		if(!muzzle_ignore && C.mouth?.muteinmouth && emote_type == EMOTE_AUDIBLE)
			. = message_muffled
		if(!muzzle_ignore && emote_type == EMOTE_AUDIBLE && HAS_TRAIT(C, TRAIT_BAGGED))
			. = message_muffled
	if(user.mind && user.mind.miming && message_mime)
		. = message_mime
	else if(ismonkey(user) && message_monkey)
		. = message_monkey
	else if(isanimal(user) && message_simple)
		. = message_simple

/datum/emote/proc/select_param(mob/user, params)
	return replacetext(message_param, "%t", params)

/datum/emote/proc/can_run_emote(mob/user, status_check = TRUE, intentional = FALSE)
	. = TRUE
	if(!is_type_in_typecache(user, mob_type_allowed_typecache))
		return FALSE
	if(is_type_in_typecache(user, mob_type_blacklist_typecache))
		return FALSE
	if(status_check && !is_type_in_typecache(user, mob_type_ignore_stat_typecache))
		if(user.stat > stat_allowed)
			if(!intentional)
				return FALSE
/*			switch(user.stat)
				if(SOFT_CRIT)
					to_chat(user, span_warning("I cannot [key] while dying!"))
				if(UNCONSCIOUS)
					to_chat(user, span_warning("I cannot [key] while unconscious!"))
				if(DEAD)
					to_chat(user, span_warning("I cannot [key] while dead!"))*/
			return FALSE
		if(restraint_check)
			if(isliving(user))
				var/mob/living/L = user
				if(L.IsParalyzed() || L.IsStun())
					if(!intentional)
						return FALSE
//					to_chat(user, span_warning("I cannot [key] while stunned!"))
					return FALSE
		if(restraint_check && user.restrained())
			if(!intentional)
				return FALSE
//			to_chat(user, span_warning("I cannot [key] while restrained!"))
			return FALSE

	if(intentional && HAS_TRAIT(user, TRAIT_EMOTEMUTE))
		return FALSE

/datum/emote/proc/get_target(mob/user, list/params)
	if(!params.len)
		return null

	var/target_name = params[1]
	var/mob/target = null

	for(var/mob/M in view(user))
		if(M.name == target_name)
			target = M
			break
	return target

/datum/emote/proc/is_emote_muffled(mob/living/carbon/H) //ONLY for audible emote use
	if(H.mouth?.muteinmouth)
		return FALSE
	for(var/obj/item/grabbing/grab in H.grabbedby)
		if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_MOUTH)
			return FALSE
	if(istype(H.loc, /turf/open/water) && !(H.mobility_flags & MOBILITY_STAND))
		return FALSE
	return TRUE
