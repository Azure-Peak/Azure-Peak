/datum/ai_controller/generic/cat
	var/follow_timer

	planning_subtrees = list(
		/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee,
		/datum/ai_planning_subtree/being_a_minion,
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/eat_food/farm_animals,
		/datum/ai_planning_subtree/simple_self_recovery/genericanimal,
	)

/datum/ai_controller/generic/cat/TryPossessPawn(atom/new_pawn)
	RegisterSignal(new_pawn, COMSIG_MOVABLE_HEAR, PROC_REF(on_hear))
	return ..()

/datum/ai_controller/generic/cat/UnpossessPawn(destroy)
	UnregisterSignal(pawn, COMSIG_MOVABLE_HEAR)
	if(follow_timer)
		deltimer(follow_timer)
		follow_timer = null
		clear_blackboard_key(BB_FOLLOW_TARGET)
	return ..()

/datum/ai_controller/generic/cat/proc/on_hear(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	var/raw_message = hearing_args[4]
	if(hearing_args[5] || !istext(raw_message) || !findtext(raw_message, "pspsps"))
		return
	INVOKE_ASYNC(src, PROC_REF(respond_to_speech), hearing_args[2])

/datum/ai_controller/generic/cat/proc/respond_to_speech(mob/living/speaker)
	var/mob/living/simple_animal/cat = pawn
	if(QDELETED(cat) || cat.client || cat.stat || !cat.can_hear() || !istype(speaker) || QDELETED(speaker) || speaker == cat || speaker.stat == DEAD)
		return
	if(cat.z != speaker.z || get_dist(cat, speaker) > 7)
		return

	var/starting_follow = blackboard[BB_FOLLOW_TARGET] != speaker
	if(starting_follow)
		set_blackboard_key(BB_FOLLOW_TARGET, speaker)
		if(movement_target_source == /datum/ai_behavior/follow_friend)
			set_movement_target(/datum/ai_behavior/follow_friend, speaker)
	if(follow_timer)
		deltimer(follow_timer)
	follow_timer = addtimer(CALLBACK(src, PROC_REF(stop_following), speaker), rand(10 SECONDS, 20 SECONDS), TIMER_STOPPABLE)

	if(cat.resting)
		cat.set_resting(FALSE)
		if(!QDELETED(cat) && !cat.client && cat.stat != DEAD && !cat.resting)
			cat.icon_state = cat.icon_living
	if(starting_follow && !QDELETED(cat) && !cat.client && !cat.stat && blackboard[BB_FOLLOW_TARGET] == speaker)
		playsound(cat, pick('sound/vo/mobs/cat/cat_meow1.ogg', 'sound/vo/mobs/cat/cat_meow2.ogg', 'sound/vo/mobs/cat/cat_meow3.ogg'), 100, TRUE, animal_pref = TRUE)
		cat.visible_message("<b>[cat]</b> meows!", runechat_message = "meows!", log_seen = SEEN_LOG_EMOTE)

/datum/ai_controller/generic/cat/proc/stop_following(mob/living/speaker)
	follow_timer = null
	if(blackboard[BB_FOLLOW_TARGET] == speaker)
		clear_blackboard_key(BB_FOLLOW_TARGET)
