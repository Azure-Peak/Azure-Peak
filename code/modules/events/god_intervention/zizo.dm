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
