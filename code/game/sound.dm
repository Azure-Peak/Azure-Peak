/client
	var/list/played_loops = list() //uses dlink to link to the sound


/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, frequency = null, channel, pressure_affected = FALSE, ignore_walls = TRUE, soundping = FALSE, repeat, animal_pref = FALSE, quiet = FALSE)
	if(isarea(source))
		CRASH("playsound(): source is an area")

	var/soundfile = soundin
	if(istype(soundin, /sound))
		var/sound/sound = soundin
		soundfile = sound.file
	// Voice over sound, which implies it should come from the head.
	if(isdullahan(source) && findtext("[soundfile]", @"sound/vo"))
		var/mob/living/carbon/human/human = source
		var/datum/species/dullahan/dullahan = human.dna.species
		if(dullahan.headless)
			var/obj/item/bodypart/head/dullahan/head = dullahan.my_head
			source = head

	var/turf/turf_source = get_turf(source)
	if(isturf(source))
		turf_source = source

	if(!turf_source)
		return

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	// Looping through the player list has the added bonus of working for mobs inside containers
	var/sound/S = soundin
	if(!istype(S))
		S = sound(get_sfx(soundin))
	if(!extrarange)
		extrarange = 1
	var/maxdistance = (world.view + extrarange)
	var/source_z = turf_source.z
	var/list/listeners = SSmobs.clients_by_zlevel[source_z].Copy()
	var/list/muffled_listeners = list()

	var/turf/above_turf = GET_TURF_ABOVE(turf_source)
	var/turf/below_turf = GET_TURF_BELOW(turf_source)

	if(soundping)
		ping_sound(source)

	if(!ignore_walls) //these sounds don't carry through walls or vertically
		listeners = listeners & get_hearers_in_view(maxdistance,turf_source)
	else
		if(above_turf)
			muffled_listeners += SSmobs.clients_by_zlevel[above_turf.z]
			muffled_listeners += SSmobs.dead_players_by_zlevel[above_turf.z]

		if(below_turf)
			muffled_listeners += SSmobs.clients_by_zlevel[below_turf.z]
			muffled_listeners += SSmobs.dead_players_by_zlevel[below_turf.z]

	listeners += SSmobs.dead_players_by_zlevel[source_z]
	listeners += muffled_listeners
	. = list()

	for(var/mob/M as anything in listeners)
		var/turf/turf_check = get_turf(M)
		// Check relay instead.
		if(isdullahan(M))
			var/mob/living/carbon/human = M
			var/datum/species/dullahan/dullahan = human.dna.species
			if(dullahan.headless)
				turf_check = get_turf(dullahan.my_head)

		if(quiet)
			if(turf_check.z != turf_source.z)
				continue
			if(get_dist(turf_check, turf_source) > 3)
				continue

		if(get_dist(turf_check, turf_source) <= maxdistance)
			if(animal_pref)
				if(M.client?.prefs?.mute_animal_emotes)
					continue
			var/is_muffled = (M in muffled_listeners)
			if(M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, channel, pressure_affected, S, repeat, is_muffled))
				. += M


/proc/ping_sound(atom/A)
	var/image/I = image(icon = 'icons/effects/effects.dmi', loc = A, icon_state = "emote", layer = ABOVE_MOB_LAYER)
	if(!I)
		return
	I.pixel_y = 6
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	I.appearance_flags = RESET_COLOR
	flick_overlay(I, GLOB.clients, 6)

/proc/ping_sound_through_walls(turf/T)
	new /obj/effect/temp_visual/soundping(T)

/obj/effect/temp_visual/soundping
	plane = FULLSCREEN_PLANE
	layer = FLASH_LAYER
	icon = 'icons/effects/ore_visuals.dmi'
	icon_state = "zz"
	appearance_flags = 0 //to avoid having TILE_BOUND in the flags, so that the 480x480 icon states let you see it no matter where you are
	duration = 6
	pixel_x = -224
	pixel_y = -218

/*
/obj/effect/temp_visual/soundping/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration, easing = EASE_IN)
*/
/mob/proc/playsound_local(atom/turf_source, soundin, vol as num, vary, frequency, falloff, channel, pressure_affected = TRUE, sound/S, repeat, muffled)
	if(!client || !can_hear())
		return FALSE

	if(!S)
		S = sound(get_sfx(soundin))

	S.wait = 0 //No queue
	S.channel = channel
	if(!S.channel)
		S.channel = SSsounds.random_available_channel()

	var/obj/item/bodypart/head/dullahan/user_head
	if(isdullahan(src))
		var/mob/living/carbon/human = src
		var/datum/species/dullahan/dullahan = human.dna.species
		if(dullahan.headless)
			user_head = dullahan.my_head
			muffled = istype(user_head.loc, /obj/structure/closet) || istype(user_head.loc, /obj/item/storage/)

	if(muffled)
		S.environment = 11
		if(falloff)
			falloff *= 1.5
		else
			falloff = FALLOFF_SOUNDS * 1.5
		vol *= 0.75

	var/vol2use = vol
	if(client.prefs)
		vol2use = vol * (client.prefs.mastervol * 0.01)
	vol2use = min(vol2use, 100)

	S.volume = vol2use

	var/area/A = get_area(get_turf(src))
	if(A)
		if(A.soundenv != -1)
			S.environment = A.soundenv

	if(vary)
		S.frequency = get_rand_frequency()
	if(frequency)
		S.frequency = frequency

	if(isturf(turf_source))
		// Check distance to relay instead.
		var/atom/movable/tocheck = user_head ? user_head : src

		var/turf/T = get_turf(tocheck)

		//sound volume falloff with distance
		var/distance = get_dist(T, turf_source)
		S.volume -= (distance * (0.10 * S.volume)) //10% each step
/*
		if(pressure_affected)
			//Atmosphere affects sound
			var/pressure_factor = 1
			var/datum/gas_mixture/hearer_env = T.return_air()
			var/datum/gas_mixture/source_env = turf_source.return_air()

			if(hearer_env && source_env)
				var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
				if(pressure < ONE_ATMOSPHERE)
					pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //space
				pressure_factor = 0

			if(distance <= 1)
				pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

			S.volume *= pressure_factor
			//End Atmosphere affecting sound
*/

		if(S.volume <= 0)
			return FALSE //No sound
		var/atom/our_turf = get_turf(src)
		var/dx = turf_source.x - our_turf.x
		if(dx <= 1 && dx >= -1)
			S.x = 0
		else
			S.x = dx
		var/dz = turf_source.y - our_turf.y
		if(dz <= 1 && dz >= -1)
			S.z = 0
		else
			S.z = dz

		var/dy = turf_source.z - our_turf.z
		S.y = dy

		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	if(repeat && istype(repeat, /datum/looping_sound))
		var/datum/looping_sound/D = repeat
		var/datum/weakref/our_ref = WEAKREF(src)
		if(our_ref in D.thingshearing) //we are already hearing this loop
			if(client.played_loops[D])
				var/sound/DS = client.played_loops[D]["SOUND"]
				if(DS)
					var/volly = client.played_loops[D]["VOL"]
					if(volly != S.volume)
						DS.x = S.x
						DS.y = S.y
						DS.z = S.z
						DS.falloff = S.falloff
						client.played_loops[D]["VOL"] = S.volume
						update_sound_volume(DS, S.volume)
						if(client.played_loops[D]["MUTESTATUS"]) //we have sound so turn this off
							client.played_loops[D]["MUTESTATUS"] = null
		else
			D.thingshearing += our_ref
			client.played_loops[D] = list()
			client.played_loops[D]["SOUND"] = S
			client.played_loops[D]["VOL"] = S.volume
			client.played_loops[D]["MUTESTATUS"] = null
			S.repeat = 1

	SEND_SOUND(src, S)

	return TRUE

/proc/sound_to_playing_players(soundin, volume = 100, vary = FALSE, frequency = 0, falloff = FALSE, channel = 0, pressure_affected = FALSE, sound/S)
	if(!S)
		S = sound(get_sfx(soundin))
	for(var/m in GLOB.player_list)
		if(ismob(m) && !isnewplayer(m))
			var/mob/M = m
			M.playsound_local(M, null, volume, vary, frequency, falloff, channel, pressure_affected, S)

/mob/proc/stop_sound_channel(chan)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	SEND_SOUND(src, S)

/mob/proc/mute_sound_channel(chan)
	for(var/sound/S in client.SoundQuery())
		if(S.channel == chan)
			S.status |= SOUND_MUTE | SOUND_UPDATE
			SEND_SOUND(src, S)
			S.status &= ~SOUND_UPDATE

/mob/proc/unmute_sound_channel(chan)
	if(!client)
		return
	for(var/sound/S in client.SoundQuery())
		if(S.channel == chan)
			S.status |= SOUND_UPDATE
			S.status &= ~SOUND_MUTE
			SEND_SOUND(src, S)
			S.status &= ~SOUND_UPDATE

/mob/proc/mute_sound(sound/S)
	if(!client)
		return
	if(!S)
		return
	S.status |= SOUND_MUTE | SOUND_UPDATE
	SEND_SOUND(src, S)
	S.status &= ~SOUND_UPDATE

/mob/proc/unmute_sound(sound/S)
	if(!client)
		return
	if(!S)
		return
	S.status |= SOUND_UPDATE
	S.status &= ~SOUND_MUTE
	SEND_SOUND(src, S)
	S.status &= ~SOUND_UPDATE

/mob/proc/update_sound_volume(sound/S, vol)
	if(!client)
		return
	if(!S)
		return
	if(vol)
		S.volume = vol
		S.status |= SOUND_UPDATE
		S.status &= ~SOUND_MUTE
		SEND_SOUND(src, S)
		S.status &= ~SOUND_UPDATE

/mob/proc/update_music_volume(chan, vol)
	if(client)
		if(client.musicfading)
			if(vol > client.musicfading)
				return
	if(vol)
		for(var/sound/S in client.SoundQuery())
			if(S.channel == chan)
				unmute_sound_channel(chan)
				S.volume = vol
				S.status |= SOUND_UPDATE
				SEND_SOUND(src, S)
				S.status &= ~SOUND_UPDATE
	else
		mute_sound_channel(chan)

/mob/proc/update_channel_volume(chan, vol)
	if(vol)
		for(var/sound/S in client.SoundQuery())
			if(S.channel == chan)
				unmute_sound_channel(chan)
				S.volume = vol
				S.status |= SOUND_UPDATE
				SEND_SOUND(src, S)
				S.status &= ~SOUND_UPDATE

/client/proc/playtitlemusic()
	set waitfor = FALSE
	UNTIL(SSticker.login_music) //wait for SSticker init to set the login music

	if(prefs && (prefs.toggles & SOUND_LOBBY))
		SEND_SOUND(src, sound(SSticker.login_music, repeat = 1, wait = 0, volume = prefs.lobbymusicvol, channel = CHANNEL_LOBBYMUSIC)) // MAD JAMS

/proc/get_rand_frequency()
	return rand(43100, 45100) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(islist(soundin))
		soundin = pick(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("rustle")
				soundin = pick('sound/foley/equip/rummaging-01.ogg','sound/foley/equip/rummaging-02.ogg','sound/foley/equip/rummaging-03.ogg')
			if ("bodyfall")
				soundin = pick('sound/foley/bodyfall (1).ogg','sound/foley/bodyfall (2).ogg','sound/foley/bodyfall (3).ogg','sound/foley/bodyfall (4).ogg')
			if ("clothwipe")
				soundin = pick('sound/foley/cloth_wipe (1).ogg','sound/foley/cloth_wipe (2).ogg','sound/foley/cloth_wipe (3).ogg')
			if ("glassbreak")
				soundin = pick('sound/combat/hits/onglass/glassbreak (1).ogg','sound/combat/hits/onglass/glassbreak (2).ogg','sound/combat/hits/onglass/glassbreak (3).ogg')
			if ("parrywood")
				soundin = pick('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
			if ("unarmparry")
				soundin = pick('sound/combat/parry/pugilism/unarmparry (1).ogg','sound/combat/parry/pugilism/unarmparry (2).ogg','sound/combat/parry/pugilism/unarmparry (3).ogg')
			if ("dagger")
				soundin = pick('sound/combat/parry/bladed/bladedsmall (1).ogg', 'sound/combat/parry/bladed/bladedsmall (2).ogg', 'sound/combat/parry/bladed/bladedsmall (3).ogg')
			if ("rapier")
				soundin = pick('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
			if ("sword")
				soundin = pick('sound/combat/parry/bladed/bladedmedium (1).ogg', 'sound/combat/parry/bladed/bladedmedium (2).ogg', 'sound/combat/parry/bladed/bladedmedium (3).ogg')
			if ("largeblade")
				soundin = pick('sound/combat/parry/bladed/bladedlarge (1).ogg', 'sound/combat/parry/bladed/bladedlarge (2).ogg', 'sound/combat/parry/bladed/bladedlarge (3).ogg')
			if ("unsheathe_sword")
				soundin = pick('sound/foley/equip/swordsmall1.ogg', 'sound/foley/equip/swordsmall2.ogg')
			if ("brandish_blade")
				soundin = pick('sound/foley/equip/swordlarge1.ogg', 'sound/foley/equip/swordlarge2.ogg')
			if ("burn")
				soundin = pick('sound/combat/hits/burn (1).ogg','sound/combat/hits/burn (2).ogg')
			if ("nodmg")
				soundin = pick('sound/combat/hits/nodmg (1).ogg','sound/combat/hits/nodmg (2).ogg')
			if ("plantcross")
				soundin = pick('sound/foley/plantcross1.ogg','sound/foley/plantcross2.ogg','sound/foley/plantcross3.ogg','sound/foley/plantcross4.ogg')
			if ("smashlimb")
				soundin = pick('sound/combat/hits/smashlimb (1).ogg','sound/combat/hits/smashlimb (2).ogg','sound/combat/hits/smashlimb (3).ogg')
			if("genblunt")
				soundin = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg')
			if("wetbreak")
				soundin = pick('sound/combat/fracture/fracturewet (1).ogg',
'sound/combat/fracture/fracturewet (2).ogg',
'sound/combat/fracture/fracturewet (3).ogg')
			if("fracturedry")
				soundin = pick('sound/combat/fracture/fracturedry (1).ogg',
'sound/combat/fracture/fracturedry (2).ogg',
'sound/combat/fracture/fracturedry (3).ogg')
			if("headcrush")
				soundin = pick('sound/combat/fracture/headcrush (1).ogg',
'sound/combat/fracture/headcrush (2).ogg',
'sound/combat/fracture/headcrush (3).ogg',
'sound/combat/fracture/headcrush (4).ogg')
			if("punch")
				soundin = pick('sound/combat/hits/punch/punch (1).ogg','sound/combat/hits/punch/punch (2).ogg','sound/combat/hits/punch/punch (3).ogg')
			if("punch_hard")
				soundin = pick('sound/combat/hits/punch/punch_hard (1).ogg','sound/combat/hits/punch/punch_hard (2).ogg','sound/combat/hits/punch/punch_hard (3).ogg')
			if("smallslash")
				soundin = pick('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
			if("woodimpact")
				soundin = pick('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
			if("bubbles")
				soundin = pick('sound/foley/bubb (1).ogg','sound/foley/bubb (2).ogg','sound/foley/bubb (3).ogg','sound/foley/bubb (4).ogg','sound/foley/bubb (5).ogg')
			if("parrywood")
				soundin = pick('sound/combat/parry/wood/parrywood (1).ogg','sound/combat/parry/wood/parrywood (2).ogg','sound/combat/parry/wood/parrywood (3).ogg')
			if("whiz")
				soundin = pick('sound/foley/whiz (1).ogg','sound/foley/whiz (2).ogg','sound/foley/whiz (3).ogg','sound/foley/whiz (4).ogg')
			if("genslash")
				soundin = pick('sound/combat/hits/bladed/genslash (1).ogg','sound/combat/hits/bladed/genslash (2).ogg','sound/combat/hits/bladed/genslash (3).ogg')
			if("bladewooshsmall")
				soundin = pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
			if("bluntwooshmed")
				soundin = pick('sound/combat/wooshes/blunt/wooshmed (1).ogg','sound/combat/wooshes/blunt/wooshmed (2).ogg','sound/combat/wooshes/blunt/wooshmed (3).ogg')
			if("bluntwooshlarge")
				soundin = pick('sound/combat/wooshes/blunt/wooshlarge (1).ogg','sound/combat/wooshes/blunt/wooshlarge (2).ogg','sound/combat/wooshes/blunt/wooshlarge (3).ogg')
			if("punchwoosh")
				soundin = pick('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
			if(SFX_CHAIN_STEP)
				soundin = pick(
							'sound/foley/footsteps/armor/chain (1).ogg',
							'sound/foley/footsteps/armor/chain (2).ogg',
							'sound/foley/footsteps/armor/chain (3).ogg',
							)
			if(SFX_PLATE_STEP)
				soundin = pick(
							'sound/foley/footsteps/armor/plate (1).ogg',
							'sound/foley/footsteps/armor/plate (2).ogg',
							'sound/foley/footsteps/armor/plate (3).ogg',
							)
			if(SFX_PLATE_COAT_STEP)
				soundin = pick(
							'sound/foley/footsteps/armor/coatplates (1).ogg',
							'sound/foley/footsteps/armor/coatplates (2).ogg',
							'sound/foley/footsteps/armor/coatplates (3).ogg',
							)
			if(SFX_JINGLE_BELLS)
				soundin = pick(
							'sound/items/jinglebell1.ogg',
							'sound/items/jinglebell2.ogg',
							'sound/items/jinglebell3.ogg',
							'sound/items/jinglebell4.ogg',
							)
			if(SFX_WOOD_ARMOR)
				soundin = pick(
							'sound/foley/footsteps/armor/woodarmor (1).ogg',
							'sound/foley/footsteps/armor/woodarmor (2).ogg',
							'sound/foley/footsteps/armor/woodarmor (3).ogg',
							)
	return soundin
