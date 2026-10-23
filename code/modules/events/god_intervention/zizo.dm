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
	var/message
	switch(GLOB.tod)
		if("night")
			message = "Under the moon, forms a pale, sickly fog followed by an ominious chill seeping into the deepest parts of town."
		if("dawn")
			message = "With the dawn rolls in a pale, sickly fog. An ominious chill seeps into the deepest parts of town."
		if("dusk")
			message = "A pale, sickly fog forms under the fading twilight. An ominious chill seeps into the deepest parts of town."
		else
			message = "The sun quickly pales underneath a blanket of pale, sickly fog. An ominious chill seeps into the deepest parts of town."
	priority_announce("[message]", "Bad Omen", 'sound/misc/evilevent.ogg')
	SSParticleWeather.run_weather(/datum/particle_weather/fog/zizo, TRUE) //unique sickly fog

/datum/round_event_control/zizo_pet_cementery
	name = "Zizo's Pet Cementery"
	typepath = /datum/round_event/zizo_pet_cementery
	weight = 6
	earliest_start = 25 MINUTES
	max_occurrences = 2
	min_players = 35

/datum/round_event/zizo_pet_cementery/start()
	//Long duration, followed w/ a cool mist effect.
	SSmapping.add_world_trait(/datum/world_trait/zizo_pet_cementery, 60 MINUTES)
	var/message
	switch(GLOB.tod)
		if("night")
			message = "The pale moon glimmers with an unnatural light as a pale, sickly mist forms beneath; followed by the wails of Creechers filling the night."
		if("dawn")
			message = "With the dawn rolls in a pale, sickly fog. The birds chirp a warped tune, followed by the wails of Creechers in the distance."
		if("dusk")
			message = "The fading twilight turns blood red for a moment, a pale, sickly fog forms. Creechers do not quieten, it is too dangerous to sleep."
		else
			message = "The sun quickly pales underneath a blanket of pale, sickly fog. The bell of a distant saiga is followed by the scream of a hunter."
	priority_announce("[message]", "Bad Omen", 'sound/misc/evilevent.ogg')
	SSParticleWeather.run_weather(/datum/particle_weather/fog/zizo_short, TRUE) //unique but shorter-lived sickly fog
