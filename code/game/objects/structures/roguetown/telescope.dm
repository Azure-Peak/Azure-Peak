/obj/structure/telescope
	name = "telescope"
	desc = "A mysterious telescope pointing towards the stars. Peer through its glassy eye to \
	glimpse at what lies beyond the world's horizon."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "telescope"
	density = TRUE
	anchored = FALSE
	// this is for later use in the proc, idk i feel better storing it here than in the proc
	// before you ask this is just what noc sounds like and i found it in the files and it works ok...
	var/static/list/star_sounds = list(
		'sound/items/carvgood.ogg',
		'sound/items/carvhello.ogg',
		'sound/items/carvsorry.ogg',
		'sound/items/carvhelp.ogg',
		'sound/items/carvty.ogg',

	)

/obj/structure/telescope/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click the telescope to randomly glimpse at a notable star, planet, or astral presence.")

/obj/structure/telescope/attack_hand(mob/user)
	if(!ishuman(user))
		return
	// TODO: STATUS EFFECT THAT CALLS EARLY RETURN IF YOU'VE USED A TELE W/I THE LAST 15. OR. ALT MESSAGE.

	var/mob/living/carbon/human/H = user	

	if(H.has_status_effect(/datum/status_effect/telescope_used))
		to_chat(H, span_warning("My mind and eyes are exhausted! Let me rest!"))
		return
	
	var/picked_message = "You see nothing noteworthy." // debug
	var/got_fucked = FALSE // if u got astrata'd you can try again. as a treat.

	// these are so we can apply them at the end AFTER getting the message. visual clarity.
	var/status_effect = null
	var/stress_event = null
	
	to_chat(H,span_info("I begin looking through the telescope..."))
	H.emote("hmm", intentional = TRUE)
	if(do_after(H, 15 SECONDS, TRUE))
		// DAY.
		// ...who the fuck looks through a telescope during the day?
		if(GLOB.tod == "day")
			got_fucked = TRUE
			picked_message = span_warning("ASTRATA'S BLINDING LIGHT causes you INTENSE PAIN! OH, FUCK!")
			var/obj/item/bodypart/affecting = H.get_bodypart(BODY_ZONE_HEAD)
			if(affecting && affecting.receive_damage(0,5))
				// this also should blur the eyes but idk if adjust_blurriness is permanent or not and i dont want to risk it
				H.update_damage_overlays()
		
		// DUSK. 
		// ZURANUS only appears in the Dusk hours, while Astrata is lowering but Noc still isnt fully awakened.
		// If ZURANUS is not visible... IDK. Stars, I guess.
		else if(GLOB.tod == "dusk")
			var/see_zuranus = rand(0,2)
			if(see_zuranus == 2) // 33% chance
				// the mundane cannot see it
				picked_message = span_info("I feel a tad... strange. Maybe that was just a weird cloud?")
				H.playsound_local(H, 'sound/misc/adrenaline_rush.ogg', 30, TRUE)
				status_effect = /datum/status_effect/zuranus // special dreams... perhaps.
				switch(H.patron?.type)
					if(/datum/patron/divine/noc)
						picked_message = span_userdanger("Zuranus' shadowy presence gazes at me with eternal malice...")
						// bad stress
						stress_event = /datum/stressevent/see_zuranus
					if(/datum/patron/inhumen/zizo)
						picked_message = span_rose("I see the celestial form of Our Lady... how beautiful!")
						// good stress
						stress_event = /datum/stressevent/see_zuranus/zizoite
			else // no zuranus
				var/star_audio = pick(star_sounds)
				picked_message = span_info("NOC is settling in, the stars are just starting to shine!")
				H.playsound_local(H, star_audio, 40, TRUE)
		
		// DAWN. 
		// KYTHERIA is VISIBLE... ASTRATA MIGHT ALSO BLIND YOU. MOOD BUFF OR BLINDNESS.. CHOOSE WISELY...
		else if(GLOB.tod == "dawn")
			var/what_do_see = rand(0,2) // 33% of each
			switch(what_do_see)
				if(0) // hey jimmy, get me a pizza wit nothin. nothin?
					var/star_audio = pick(star_sounds)
					picked_message = span_info("NOC is performing his final rotations... Astrata is rising, a GLORIOUS MORNING...") // https://www.youtube.com/watch?v=7T_YtklLyyo
					H.playsound_local(H, star_audio, 40, TRUE)
				if(1) // good luck! kytheria!
					picked_message = span_rose("Kytheria's golden clouds swirl with blessed strife...")
					stress_event = /datum/stressevent/kytherian_blessing
					H.playsound_local(H, 'sound/magic/eora_bless.ogg', 40, TRUE)
				if(2) // bad luck-- astrata!
					got_fucked = TRUE
					picked_message = span_warning("ASTRATA'S BLINDING LIGHT causes you INTENSE PAIN! OH, FUCK!")
					var/obj/item/bodypart/affecting = H.get_bodypart(BODY_ZONE_HEAD)
					if(affecting && affecting.receive_damage(0,5))
						// this also should blur the eyes but idk if adjust_blurriness is permanent or not and i dont want to risk it
						H.update_damage_overlays()
		
		// NITE. most planets are visible. chance to see jove, hermes, noc, AND nepolx. random stars, too... or that XYLIXIAN FALSE-STAR.
		else if(GLOB.tod == "night")
			var/what_do_see = rand(0, 5)
			switch(what_do_see)
				if(0) // damn you xylix
					picked_message = span_info("It's too cloudy out to see anything! NO!!")
					switch(H.patron?.type)
						if(/datum/patron/divine/noc)
							picked_message = span_danger("Something is wrong-- I SEE A STAR WHERE IT SHOULDN'T BE IN THE HALF-SWORD CONSTELLATION!")
							stress_event = /datum/stressevent/xylix_star
							H.playsound_local(H, 'sound/magic/decoylaugh.ogg', 30, TRUE)
						if(/datum/patron/divine/xylix)
							picked_message = span_info("I see the Tricksters nocturnal machinations! Hehe!")
							stress_event = /datum/stressevent/xylix_star/xylixian
							H.playsound_local(H, 'sound/magic/decoylaugh.ogg', 30, TRUE)
				if(1) // and the wonders of the stars...
					// for some reason beyond my comprehension these HAVE to be in a /list var. so stupid.
					var/list/wonders_of_the_stars = list(
						span_info("You see a star!"),
						span_info("The stars smile upon you!"),
						span_info("Bands of starlight bedazzle the sky!"),
						span_info("Psydonia's worldly horizon stretches out as far as the telescope can see...")
					)
					var/star_audio = pick(star_sounds)
					picked_message = pick(wonders_of_the_stars)
					H.playsound_local(H, star_audio, 40, TRUE)
				if(2) // NOC
					status_effect = /datum/status_effect/buff/nocblessing
					H.playsound_local(H, 'sound/magic/message.ogg', 40, TRUE)
					var/list/wonders_of_the_stars = list(
						span_blue("Noc's silvered glare soothes your mind..."),
						span_blue("You see NOC spinning in the skyline!")
					)
					picked_message = pick(wonders_of_the_stars)
				if(3) // HERMES
					H.apply_status_effect(/datum/status_effect/buff/hermes_trismegistus)
					picked_message = span_info("Hermes' swift orbit graces a shadow between Astrata and Noc...")
					H.playsound_local('sound/items/write.ogg', 40, TRUE)
				if(4) // NEPOLX OR NEOPLX or NEOPETS
					picked_message = span_info("Nepolx's saffiric glow wounds the heart with a sense of sudden somberness...")
					H.playsound_local(H, 'sound/magic/mindlink.ogg', 40, TRUE)
					if(is_user_magic(H))
						// if theyre capable of using a scrying orb, nepolx makes them less likely 2 fuck it up
						status_effect = /datum/status_effect/buff/transparent_eyeball
				if(5) // JOVE. graggar ate ravox's celestial body, which turned it blue and gave it red(er) eyes. 
					picked_message = span_warning("Jove's bleeding vortex marrs its width with a crimson trail... ")
					H.playsound_local(H, 'sound/magic/psydonbleeds.ogg', 40, TRUE) // HE IS COMING.
					switch(H.patron?.type) // fucks w/ ravoxites and noccites.
						if(/datum/patron/divine/noc, /datum/patron/divine/ravox)
							stress_event = /datum/stressevent/something_stirs/telescope
							picked_message += span_warning("Jove used to represent justice, before it turned blue.") // pim turns green
						if(/datum/patron/inhumen/graggar)
							stress_event = /datum/stressevent/see_zuranus/graggarite
							picked_message += span_warning("The Goresworn often speak of Graggar's dominance over Jove! They say he ate it whole-- turned it blue!")
		// give out our message
		to_chat(H, picked_message)
		// apply extra effects
		if(stress_event)
			H.add_stress(stress_event)
		// apply our statuses
		if(status_effect)
			H.apply_status_effect(status_effect)
		// no spamming the 'scope pal
		if(!got_fucked)
			H.apply_status_effect(/datum/status_effect/telescope_used)

/obj/structure/globe
	name = "globe"
	desc = "A wooden globe representing the world. Key landmarks are indicated by adjacent \
	annotations; at a glance you can pick out 'Otava', 'Grenzelhoft', 'Kazengun', 'Naledi', \
	and on the northern half of the western continent, a modest peninsula marked as 'Azuria'."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "globe"
	density = TRUE
	anchored = FALSE

/obj/structure/globe/attack_hand(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/random_message = pick("You spin the globe!", "You land on Azuria!", "You land on Raneshen!", "You land on Grenzelhoft!", "You land on Otava!", "You land on Naledi!", "You land on Kazengun!", "You land on Valoria!", "You land on Gronn!", "You land on the Fjalls!", "You land on Lirvas!", "You land on Lingyue!", "You land on Hammerhold!", "You land on Etruscea!", "You land on Aavnr!", "You land on Port Izekyube!", "You land on Port Thornvale!", "You land on Syon's Rest!", "You land on Mount Decapitation!", "You land on Rockhill!", "You land on an unmarked squiggle of land - perhaps another spin?", "You land on an unmarked patch of sea - perhaps another spin?")
	to_chat(H, span_notice("[random_message]"))

/obj/structure/globe/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click the globe to spin it, before randomly landing on a notable kingdom or point of interest.")
