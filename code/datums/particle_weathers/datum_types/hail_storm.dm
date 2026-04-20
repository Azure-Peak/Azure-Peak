//Hail - Goes down
/particles/weather/hail
	icon_state				= list("cross"=2, "curl"=5, "puff"=4)
	color					= "#ccffff"
	position				= generator("box", list(-500,-256,0), list(400,500,0))
	grow					= list(-0.01,-0.01)
	gravity					= list(0, -10, 0.5)
	drift					= generator("circle", 0, 1) // Some random movement for variation
	friction				= 0.3  // shed 30% of velocity and drift every 0.1s
	transform				= null // Rain is directional - so don't make it "3D"
	//Weather effects, max values
	maxSpawning				= 250
	minSpawning				= 50
	wind					= 2
	spin					= 0 // explicitly set spin to 0 - there is a bug that seems to carry generators over from old particle effects

/datum/particle_weather/hail
	name = "Hail"
	desc = "Hailstorm"
	particleEffectType = /particles/weather/hail

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/hail)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_hail)

	minSeverity = 30
	maxSeverity = 60
	maxSeverityChange = 5
	severitySteps = 5
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 5
	target_trait = PARTICLEWEATHER_SNOW

/datum/particle_weather/hail/weather_act(mob/living/L)
	if(issimple(L))
		return

	L.adjust_bodytemperature(-rand(5, 15))
	var/armor_block = L.run_armor_check(BODY_ZONE_HEAD, "blunt", blade_dulling=BCLASS_BLUNT)
	if(L.apply_damage(rand(5, 10), UNARMED_ATTACK, BODY_ZONE_HEAD, armor_block))
		if(prob(25))
			to_chat(L, span_danger("You're being assailed by an onslaught of hail!"))
	else
		if(prob(25))
			to_chat(L, span_warning("Rocks of ice plink off of your headcover."))

