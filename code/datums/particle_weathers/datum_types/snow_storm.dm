//Snow - goes down and swirls
/particles/weather/snow
	icon_state             = list("cross"=2, "snow_1"=5, "snow_2"=2, "snow_3"=2,)
	color                  = "#ffffff"
	position               = generator("box", list(-500,-256,5), list(500,500,0))
	spin                   = generator("num",-10,10)
	gravity                = list(0, -2, 0.1)
	drift                  = generator("circle", 0, 3) // Some random movement for variation
	friction               = 0.3  // shed 30% of velocity and drift every 0.1s
	transform 			   = null // Looks weird without it
	//Weather effects, max values
	maxSpawning           = 50
	minSpawning           = 10
	wind                  = 2

/datum/particle_weather/snow_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/snow

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/snow)

	minSeverity = 5
	maxSeverity = 20
	maxSeverityChange = 5
	severitySteps = 5
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 15
	target_trait = PARTICLEWEATHER_SNOW

//Makes you a little chilly
/datum/particle_weather/snow_gentle/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(5,10))


/datum/particle_weather/snow_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/snow

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/snow)

	minSeverity = 40
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 10
	target_trait = PARTICLEWEATHER_SNOW

//Makes you a lot little chilly
/datum/particle_weather/snow_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(10,25))

/turf
	var/turf_flags = TURF_EFFECT_AFFECTABLE

/turf/Exited(atom/movable/gone, direction)
	if(!istype(gone))
		return
	SEND_SIGNAL(src, COMSIG_TURF_EXITED, gone, direction)
	SEND_SIGNAL(gone, COMSIG_MOVABLE_TURF_EXITED, src, direction)

