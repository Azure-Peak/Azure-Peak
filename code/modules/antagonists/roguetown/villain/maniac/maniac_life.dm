

/datum/antagonist/maniac/process()
	if(!owner.current || triumphed)
		STOP_PROCESSING(SSobj, src)
		return
	handle_visions(owner.current)
	if(waking_up)
		handle_waking_up(owner.current)
	handle_floors(owner.current)
	handle_walls(owner.current)

/datum/antagonist/maniac/proc/handle_visions(mob/living/dreamer)
	//Random laughter
	if(prob(1))
		var/static/list/funnies = list(
			'sound/villain/comic1.ogg',
			'sound/villain/comic2.ogg',
			'sound/villain/comic3.ogg',
			'sound/villain/comic4.ogg',
		)
		dreamer.playsound_local(dreamer, pick(funnies), vol = 100, vary = FALSE)

/datum/antagonist/maniac/proc/handle_hallucinations(mob/living/dreamer)
	//Chasing mob
	if(prob(1))
		INVOKE_ASYNC(src, PROC_REF(handle_mob_hallucination), dreamer)
	//Talking objects
	else if(prob(4))
		INVOKE_ASYNC(src, PROC_REF(handle_object_hallucination), dreamer)

/datum/antagonist/maniac/proc/handle_object_hallucination(mob/living/dreamer)
	var/list/objects = list()
	for(var/obj/object in view(dreamer))
		if((object.invisibility > dreamer.see_invisible) || !object.loc || !object.name)
			continue
		var/weight = 1
		if(isitem(object))
			weight = 3
		else if(isstructure(object))
			weight = 2
		else if(ismachinery(object))
			weight = 2
		objects[object] = weight
	objects -= dreamer.contents
	if(!length(objects))
		return
	var/static/list/speech_sounds = list(
		'sound/villain/female_talk1.ogg',
		'sound/villain/female_talk2.ogg',
		'sound/villain/female_talk3.ogg',
		'sound/villain/female_talk4.ogg',
		'sound/villain/female_talk5.ogg',
		'sound/villain/male_talk1.ogg',
		'sound/villain/male_talk2.ogg',
		'sound/villain/male_talk3.ogg',
		'sound/villain/male_talk4.ogg',
		'sound/villain/male_talk5.ogg',
		'sound/villain/male_talk6.ogg',
	)
	var/obj/speaker = pickweight(objects)
	var/speech
	if(prob(1))
		speech = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
	else
		speech = pick_list_replacements("maniac.json", "dreamer_object")
		speech = replacetext(speech, "%OWNER", "[dreamer.real_name]")
	var/language = dreamer.get_random_understood_language()
	var/message = dreamer.compose_message(speaker, language, speech)
	dreamer.playsound_local(dreamer, pick(speech_sounds), vol = 60, vary = FALSE)
	if(dreamer.client.prefs?.chat_on_map)
		dreamer.create_chat_message(speaker, language, speech, spans = list(dreamer.speech_span))
	to_chat(dreamer, message)

/datum/antagonist/maniac/proc/handle_mob_hallucination(mob/living/dreamer)
	if(!dreamer.client)
		return
	var/mob_message = pick("It's mom!", "I have to HURRY UP!", "They are CLOSE!","They are NEAR!")
	var/turf/spawning_turf
	var/list/turf/spawning_turfs = list()
	for(var/turf/turf in view(dreamer))
		spawning_turfs += turf
	if(length(spawning_turfs))
		spawning_turf = pick(spawning_turfs)
	if(!spawning_turf)
		return
	var/mob_state = pick("mom", "shadow", "deepone")
	if(mob_message == "It's mom!")
		mob_state = "mom"
	var/image/mob_image = image('icons/roguetown/maniac/dreamer_mobs.dmi', spawning_turf, mob_state, FLOAT_LAYER, get_dir(spawning_turf, dreamer))
	mob_image.plane = GAME_PLANE_UPPER
	dreamer.client.images += mob_image
	to_chat(dreamer, span_userdanger("<span class='big'>[mob_message]</span>"))
	sleep(5)
	if(!dreamer?.client)
		return
	var/static/list/spookies = pick(
		'sound/villain/hall_attack1.ogg',
		'sound/villain/hall_attack2.ogg',
		'sound/villain/hall_attack3.ogg',
		'sound/villain/hall_attack4.ogg',
	)
	dreamer.playsound_local(dreamer, pick(spookies), 100)
	var/chase_tiles = 7
	var/chase_wait = rand(4,6)
	var/caught_dreamer = FALSE
	var/turf/current_turf = spawning_turf
	while(chase_tiles > 0)
		if(!dreamer?.client)
			return
		var/face_direction = get_dir(current_turf, dreamer)
		current_turf = get_step(current_turf, face_direction)
		if(!current_turf)
			break
		mob_image.dir = face_direction
		mob_image.loc = current_turf
		if(current_turf == get_turf(dreamer))
			caught_dreamer = TRUE
			break
		chase_tiles--
		sleep(chase_wait)
	if(!dreamer?.client)
		return
	if(caught_dreamer)
		dreamer.Stun(rand(2, 4) SECONDS)
		var/pain_message = pick("NO!", "THEY GOT ME!", "AGH!")
		to_chat(dreamer, span_userdanger("[pain_message]"))
	sleep(chase_wait)
	if(!dreamer?.client)
		return
	dreamer.client.images -= mob_image

/datum/antagonist/maniac/proc/handle_floors(mob/living/dreamer)
	if(!dreamer.client)
		return
	//Floors go crazy go stupid
	for(var/turf/open/floor in view(dreamer))
		if(!prob(7))
			continue
		INVOKE_ASYNC(src, PROC_REF(handle_floor), floor, dreamer)

/datum/antagonist/maniac/proc/handle_floor(turf/open/floor, mob/living/dreamer)
	var/mutable_appearance/fake_floor = image(floor.icon, floor, floor.icon_state, floor.layer + 0.01)
	dreamer.client.images += fake_floor
	var/offset = pick(-3,-2, -1, 1, 2, 3)
	var/disappearfirst = rand(1 SECONDS, 3 SECONDS) * abs(offset)
	animate(fake_floor, pixel_y = offset, time = disappearfirst, flags = ANIMATION_RELATIVE)
	sleep(disappearfirst)
	var/disappearsecond = rand(1 SECONDS, 3 SECONDS) * abs(offset)
	animate(fake_floor, pixel_y = -offset, time = disappearsecond, flags = ANIMATION_RELATIVE)
	sleep(disappearsecond)
	dreamer.client?.images -= fake_floor

/datum/antagonist/maniac/proc/handle_walls(mob/living/dreamer)
	if(!dreamer.client)
		return
	//Shit on THA walls
	for(var/turf/closed/wall in view(dreamer))
		if(!prob(4))
			continue
		INVOKE_ASYNC(src, PROC_REF(handle_wall), wall, dreamer)

/datum/antagonist/maniac/proc/handle_wall(turf/closed/wall, mob/living/dreamer)
	var/image/shit = image('icons/roguetown/maniac/shit.dmi', wall, "splat[rand(1,8)]")
	dreamer.client?.images += shit
	var/offset = pick(-1, 1, 2)
	var/disappearfirst = rand(2 SECONDS, 4 SECONDS)
	animate(shit, pixel_y = offset, time = disappearfirst, flags = ANIMATION_RELATIVE)
	sleep(disappearfirst)
	var/disappearsecond = rand(2 SECONDS, 4 SECONDS)
	animate(shit, pixel_y = -offset, time = disappearsecond, flags = ANIMATION_RELATIVE)
	sleep(disappearsecond)
	dreamer.client?.images -= shit

/datum/antagonist/maniac/proc/handle_waking_up(mob/living/dreamer)
	if(!dreamer.client)
		return
	if(prob(2.5))
		dreamer.emote("laugh")
	//Floors go crazier go stupider
	for(var/turf/open/floor in view(dreamer))
		if(!prob(20))
			continue
		INVOKE_ASYNC(src, PROC_REF(handle_waking_up_floor), floor, dreamer)

/datum/antagonist/maniac/proc/handle_waking_up_floor(turf/open/floor, mob/living/dreamer)
	var/mutable_appearance/fake_floor = image('icons/roguetown/maniac/dreamer_floors.dmi', floor,	pick("rcircuitanim", "gcircuitanim"), floor.layer + 0.1)
	dreamer.client.images += fake_floor
	var/offset = pick(-1, 1, 2)
	var/disappearfirst = 3 SECONDS
	animate(fake_floor, pixel_y = offset, time = disappearfirst, flags = ANIMATION_RELATIVE)
	sleep(disappearfirst)
	var/disappearsecond = 3 SECONDS
	animate(fake_floor, pixel_y = -offset, time = disappearsecond, flags = ANIMATION_RELATIVE)
	sleep(disappearsecond)
	dreamer.client?.images -= fake_floor
