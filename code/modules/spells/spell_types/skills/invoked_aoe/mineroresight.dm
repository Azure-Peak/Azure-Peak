// a skill to help miners find medium to high quality rock and to sort out boulders before breaking them
/obj/effect/proc_holder/spell/invoked/mineroresight
	name = "Miner's Ore Sight"
	desc = "check for good ore"
	overlay_state = "analyze"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/diagnose.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 2 SECONDS //very stupidly simple spell
	miracle = FALSE
	devotion_cost = 0 //come on, this is very basic

/obj/effect/proc_holder/spell/invoked/mineroresight/cast(list/targets, mob/living/user)
	//show the miners what rock turfs are valuable
	for(var/turf/closed/mineral/rockturfs in get_hear(7,get_turf(user)))
		if(istype(rockturfs, /turf/closed/mineral/random/rogue/med) || istype(rockturfs, /turf/closed/mineral/rogue/copper) || istype(rockturfs, /turf/closed/mineral/rogue/tin) || istype(rockturfs, /turf/closed/mineral/rogue/coal))
			new /obj/effect/temp_visual/medqualityore(get_turf(rockturfs))
			//to_chat(user, span_warning("I see some medium quality stone"))
		if(istype(rockturfs, /turf/closed/mineral/random/rogue/high) || istype(rockturfs, /turf/closed/mineral/rogue/cinnabar) || istype(rockturfs, /turf/closed/mineral/rogue/iron) || istype(rockturfs, /turf/closed/mineral/rogue/gold) || istype(rockturfs, /turf/closed/mineral/rogue/silver))
			new /obj/effect/temp_visual/highqualityore(get_turf(rockturfs))
			//to_chat(user, span_warning("I see some high quality stone"))
		if(istype(rockturfs, /turf/closed/mineral/rogue/gem))
			new /obj/effect/temp_visual/gemqualityore(get_turf(rockturfs))
			//to_chat(user, span_warning("I see some GREAT quality stone"))
		if(istype(rockturfs, /turf/closed/mineral/rogue/bedrock))
			new /obj/effect/temp_visual/bedrockore(get_turf(rockturfs))
			//to_chat(user, span_warning("I see stone too hard to hit"))

	//show the miners what boulders are valuable 
	for(var/obj/item/natural/rock/boulderobjs in get_hear(7,get_turf(user)))
		if(istype(boulderobjs, /obj/item/natural/rock/copper) || istype(boulderobjs, /obj/item/natural/rock/tin) || istype(boulderobjs, /obj/item/natural/rock/coal))
			new /obj/effect/temp_visual/medqualityore(get_turf(boulderobjs))
			//to_chat(user, span_warning("I see some medium quality boulders"))
		if(istype(boulderobjs, /obj/item/natural/rock/cinnabar) || istype(boulderobjs, /obj/item/natural/rock/iron))
			new /obj/effect/temp_visual/highqualityore(get_turf(boulderobjs))
			//to_chat(user, span_warning("I see some high quality boulders"))
		if(istype(boulderobjs, /obj/item/natural/rock/gold) || istype(boulderobjs, /obj/item/natural/rock/silver) || istype(boulderobjs, /obj/item/natural/rock/gem))
			new /obj/effect/temp_visual/gemqualityore(get_turf(boulderobjs))
			//to_chat(user, span_warning("I see some GREAT quality boulders"))

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

