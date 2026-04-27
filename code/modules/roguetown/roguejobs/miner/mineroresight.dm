#define RANGE_ORE_ONE 3
#define RANGE_ORE_TWO 5
#define RANGE_ORE_THREE 7
#define INTERVAL_ONE 3 SECONDS
#define INTERVAL_TWO 6 SECONDS
#define INTERVAL_THREE 10 SECONDS

/datum/component/ore_sight
	var/current_choice_index = 1
	var/last_pulse
	var/range = RANGE_ORE_ONE
	var/static/list/lranges = list(
		RANGE_ORE_ONE,
		RANGE_ORE_TWO,
		RANGE_ORE_THREE
	)
	var/interval = INTERVAL_ONE
	var/static/list/lintervals = list(
		INTERVAL_ONE,
		INTERVAL_TWO,
		INTERVAL_THREE
	)
	var/is_active = FALSE
	var/safety_count = 0

/datum/component/ore_sight/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	
	var/mob/M = parent
	if(!M.client)
		return COMPONENT_INCOMPATIBLE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.verbs += /mob/living/carbon/human/proc/toggle_oresight
		H.verbs += /mob/living/carbon/human/proc/range_oresight
	

/datum/component/ore_sight/process()
	if(is_active)
		if(world.time > (last_pulse + interval))
			mine_pulse()

/datum/component/ore_sight/proc/mine_pulse()
	last_pulse = world.time
	var/turf/origin = get_turf(parent)
	var/stuff_found = FALSE
	for(var/turf/closed/mineral/T in RANGE_TURFS(range, origin))
		if(T)
			var/obj/effect/temp_visual/fxtype
			switch(T.type)
				if(/turf/closed/mineral/random/rogue/med, /turf/closed/mineral/rogue/copper, /turf/closed/mineral/rogue/tin, /turf/closed/mineral/rogue/coal)
					fxtype = /obj/effect/temp_visual/medqualityore
				if(/turf/closed/mineral/random/rogue/high, /turf/closed/mineral/rogue/cinnabar, /turf/closed/mineral/rogue/iron, /turf/closed/mineral/rogue/gold, /turf/closed/mineral/rogue/silver)
					fxtype = /obj/effect/temp_visual/highqualityore
				if(/turf/closed/mineral/rogue/gem)
					fxtype = /obj/effect/temp_visual/gemqualityore
				if(/turf/closed/mineral/rogue/bedrock)
					fxtype = /obj/effect/temp_visual/bedrockore
			if(fxtype)
				stuff_found = TRUE
				new fxtype(get_turf(T))
	for(var/obj/item/natural/rock/boulder in get_hear(range, origin))
		if(boulder)
			var/obj/effect/temp_visual/fxtype
			switch(boulder.type)
				if(/obj/item/natural/rock/copper, /obj/item/natural/rock/tin, /obj/item/natural/rock/coal)
					fxtype = /obj/effect/temp_visual/medqualityore
				if(/obj/item/natural/rock/cinnabar, /obj/item/natural/rock/iron)
					fxtype = /obj/effect/temp_visual/highqualityore
				if(/obj/item/natural/rock/gold, /obj/item/natural/rock/silver, /obj/item/natural/rock/gem)
					fxtype = /obj/effect/temp_visual/gemqualityore
			if(fxtype)
				stuff_found = TRUE
				new fxtype(get_turf(boulder))

	if(!stuff_found)
		safety_count++
	else
		safety_count = 0
	if(safety_count >= 6)
		safety_count = 0
		toggle(force_off = TRUE)

/datum/component/ore_sight/proc/change_range()
	if(current_choice_index < length(lranges))
		current_choice_index++
	else
		current_choice_index = 1
	var/msg
	switch(current_choice_index)
		if(1)
			msg = "Shortest range (3 tiles), quickest refresh (3 seconds)."
		if(2)
			msg = "Medium range (5 tiles), medium refresh (6 seconds)."
		if(3)
			msg = "Maximum range (7 tiles), longest refresh (10 seconds)."
	var/mob/M = parent
	to_chat(M, span_notice(msg))
	range = lranges[current_choice_index]
	interval = lintervals[current_choice_index]

/datum/component/ore_sight/proc/toggle(force_off = FALSE)
	if(force_off)
		is_active = FALSE
		STOP_PROCESSING(SSdcs, src)
		var/mob/M = parent
		to_chat(M, span_info("No viable rocks detected for several cycles. Switching ore sight off to prevent undue lag."))
		return
	is_active = !is_active
	var/msg = span_notice("Toggling Ore Sight [is_active ? "ON" : "OFF"].")
	var/mob/M = parent
	to_chat(M, msg)
	if(is_active)
		START_PROCESSING(SSdcs, src)
	else
		STOP_PROCESSING(SSdcs, src)

/obj/effect/temp_visual/medqualityore
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	dir = NORTH
	name = "useful ore"
	desc = "The stone here must contain something handy."
	randomdir = FALSE
	duration = 1 SECONDS
	layer = 18

/obj/effect/temp_visual/highqualityore
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	dir = NORTH
	name = "valuable ore"
	desc = "The stone here must contain something pricy!"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = 18

/obj/effect/temp_visual/gemqualityore
	icon = 'icons/effects/effects.dmi'
	icon_state = "quantum_sparks"
	dir = NORTH
	name = "glittering ore"
	desc = "GEMS! I'M RICH!!!"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = 18

/obj/effect/temp_visual/bedrockore
	icon = 'icons/effects/effects.dmi'
	icon_state = "purplesparkles"
	dir = NORTH
	name = "bedrock"
	desc = "The stone here's too hard to break."
	randomdir = FALSE
	duration = 1 SECONDS
	layer = 18

#undef RANGE_ORE_ONE
#undef RANGE_ORE_TWO
#undef RANGE_ORE_THREE
#undef INTERVAL_ONE
#undef INTERVAL_TWO
#undef INTERVAL_THREE
