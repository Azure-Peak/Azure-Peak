/particles/weather/leaves
	icon_state	= list("leaf1"=7, "leaf2"=1, "leaf3"=1)
	spin		= 6
	position 	= generator("box", list(-500,-256,0), list(400,500,0))
	gravity 	= list(0, -1, 0.1)
	friction    = 0.3
	transform 	= null
	//Weather effects, max values
	maxSpawning            = 25
	minSpawning            = 3
	wind                   = 2


/particles/weather/leaves/sakura
	icon_state	= "petals1"
	position 	= generator("box", list(-500,-256,0), list(400,500,0))
	gravity 	= list(0, -1, 0.1)
	friction 	= 0.5
	transform 	= null
	//Weather effects, max values
	maxSpawning            = 30
	minSpawning            = 5
	wind                   = 1

/datum/particle_weather/leaves_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/leaves

	scale_vol_with_severity = TRUE

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 40
	target_trait = PARTICLEWEATHER_LEAVES

/datum/particle_weather/leaves_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/leaves

	scale_vol_with_severity = TRUE

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 20
	target_trait = PARTICLEWEATHER_LEAVES

/datum/particle_weather/sakura_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/leaves/sakura

	scale_vol_with_severity = TRUE

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 0
	target_trait = PARTICLEWEATHER_SAKURA

/datum/particle_weather/sakura_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/leaves/sakura

	scale_vol_with_severity = TRUE

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 0
	target_trait = PARTICLEWEATHER_SAKURA
