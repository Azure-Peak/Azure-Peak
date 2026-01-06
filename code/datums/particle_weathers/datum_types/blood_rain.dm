/particles/weather/blood_rain
	icon_state             = "drop"
	color                  = "#ff0000"
	position               = generator("box", list(-500,-256,0), list(400,500,0))
	grow			       = list(-0.01,-0.01)
	gravity                = list(0, -10, 0.5)
	drift                  = generator("circle", 0, 1) // Some random movement for variation
	friction               = 0.3  // shed 30% of velocity and drift every 0.1s
	transform 			   = null // Rain is directional - so don't make it "3D"
	//Weather effects, max values
	maxSpawning            = 250
	minSpawning            = 50
	wind                   = 2
	spin                   = 0 // explicitly set spin to 0 - there is a bug that seems to carry generators over from old particle effects


/datum/particle_weather/blood_rain_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/blood_rain

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/rain)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_rain)

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 10
	target_trait = PARTICLEWEATHER_BLOODRAIN

/datum/particle_weather/blood_rain_gentle/weather_act(mob/living/L)
	L.adjust_fire_stacks(-100)
	L.SoakMob(FULL_BODY)

/datum/particle_weather/blood_rain_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/blood_rain

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/storm)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_rain)

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 10
	target_trait = PARTICLEWEATHER_BLOODRAIN

//Makes you a bit chilly
/datum/particle_weather/blood_rain_storm/weather_act(mob/living/L)
	L.adjust_fire_stacks(-100)
	L.SoakMob(FULL_BODY)
