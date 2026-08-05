/* Originally written by Bhijn & Myr on Citadel[1], with various other contributions since- see the Splurt & Citadel github for a full list of contributors.
[1]https://github.com/Citadel-Station-13/Citadel-Station-13/pull/15677
*/

/atom/movable

	// Text-to-bark sounds
	var/sound/vocal_bark
	var/vocal_bark_id
	var/vocal_pitch = 1
	var/vocal_pitch_range = 0.2 //Actual pitch is (pitch - (vocal_pitch_range*0.5)) to (pitch + (vocal_pitch_range*0.5))
	var/vocal_volume = 50 //Baseline. This gets modified by yelling and other factors
	var/vocal_speed = 4 //Lower values are faster, higher values are slower

	var/vocal_current_bark //When barks are queued, this gets passed to the bark proc. If vocal_current_bark doesn't match the args passed to the bark proc (if passed at all), then the bark simply doesn't play. Basic curtailing of spam~

/// Sets the vocal bark for the atom, using the bark's ID
/atom/movable/proc/set_bark(id)
	if(!id)
		return FALSE
	var/datum/bark/B = GLOB.bark_list[id]
	if(!B)
		return FALSE
	vocal_bark = sound(initial(B.soundpath))
	vocal_bark_id = id
	return vocal_bark

/atom/movable/vv_edit_var(var_name, var_value, massedit)
	if(var_name == NAMEOF(src, vocal_bark))
		if(isfile(var_value))
			vocal_bark = sound(var_value)
		. = TRUE

	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	return ..()

/atom/movable/proc/handle_special_bark(atom/movable/source, list/hearers, distance, volume, pitch)
	SIGNAL_HANDLER

	if(!CONFIG_GET(flag/enable_global_barks))
		return

	var/list/soundpaths
	switch(GLOB.bark_list[source.vocal_bark_id])
		if(/datum/bark/gaster)
			soundpaths = list(
				'code/modules/blooper/voice/bloopers/undertale/voice_gaster_1.ogg',
				'code/modules/blooper/voice/bloopers/undertale/voice_gaster_2.ogg',
				'code/modules/blooper/voice/bloopers/undertale/voice_gaster_3.ogg',
				'code/modules/blooper/voice/bloopers/undertale/voice_gaster_4.ogg',
				'code/modules/blooper/voice/bloopers/undertale/voice_gaster_5.ogg',
				'code/modules/blooper/voice/bloopers/undertale/voice_gaster_6.ogg',
				'code/modules/blooper/voice/bloopers/undertale/voice_gaster_7.ogg'
			)
		else
			return //No change needed

	source.vocal_bark = sound(pick(soundpaths))

/atom/movable/proc/bark(list/hearers, distance, volume, pitch, queue_time)
	if(queue_time && vocal_current_bark != queue_time)
		return
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_BARK, hearers, distance, volume, pitch))
		return //bark interception. this probably counts as some flavor of BDSM
	if(!vocal_bark)
		if(!vocal_bark_id || !set_bark(vocal_bark_id)) //just-in-time bark generation
			return
	volume = min(volume, 100)
	var/turf/T = get_turf(src)
	for(var/mob/M in hearers)
		// Uncomment if you ever modernize the playsound procs
		// M.playsound_local(T, vol = volume, vary = TRUE, frequency = pitch, max_distance = distance, falloff_distance = 0, falloff_exponent = BARK_SOUND_FALLOFF_EXPONENT(distance), S = vocal_bark, distance_multiplier = 1)
		M.playsound_local(
						turf_source = T,
						vol = volume,
						vary = TRUE,
						frequency = pitch,
						falloff = 1,
						S = vocal_bark,
		)
