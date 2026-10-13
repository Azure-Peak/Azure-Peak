/datum/round_event_control/zizo_defilement
	name = "Zizo's Defilement"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/zizo_defilement
	weight = 4
	earliest_start = 25 MINUTES
	max_occurrences = 2
	min_players = 2
	allowed_storytellers = list(/datum/storyteller/zizo)

/datum/round_event/zizo_defilement/start()
	SSmapping.add_world_trait(/datum/world_trait/zizo_defilement, 15 MINUTES)

/datum/round_event_control/zizo_pet_cementery
	name = "Zizo's Pet Cementery"
	typepath = /datum/round_event/zizo_pet_cementery
	weight = 6
	earliest_start = 25 MINUTES
	max_occurrences = 2
	min_players = 35

/datum/round_event/zizo_pet_cementery/start()
	//Long duration but you might not even notice it.
	SSmapping.add_world_trait(/datum/world_trait/zizo_pet_cementery, 60 MINUTES)
	var/message
	switch(GLOB.tod)
		if("night")
			message = "The pale moon glimmers with an unnatural light, as the wails of creatures fill the night."
		if("dawn")
			message = "With the dawn rolls in a pale, sickly fog. The birds chirp a warped tune."
		if("dusk")
			message = "The fading twilight turns blood red for a moment. Creechers do not quieten, it is too dangerous to sleep."
		else
			message = "The sun quickly pales underneath a blanket of strangely shaped clouds. The bell of a saiga is followed by the scream of a hunter."
	to_world("<b><span class='span_danger'><span class='big'>[message]</span></span></b>")
	for(var/mob/M in GLOB.player_list)
		if (!M.can_hear())
			return
		M.playsound_local(M, 'sound/misc/evilevent.ogg', 100)
