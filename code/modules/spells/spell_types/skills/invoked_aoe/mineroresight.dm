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
	for(var/turf/closed/mineral/rockturfs in view(7,get_turf(user)))
		if(istype(rockturfs, /turf/closed/mineral/random/rogue/med) || istype(rockturfs, /turf/closed/mineral/rogue/copper) || istype(rockturfs, /turf/closed/mineral/rogue/tin) || istype(rockturfs, /turf/closed/mineral/rogue/coal))
			found_ore(get_turf(rockturfs), user.client, "sparks")
			//to_chat(user, span_warning("I see some medium quality stone"))
		if(istype(rockturfs, /turf/closed/mineral/random/rogue/high) || istype(rockturfs, /turf/closed/mineral/rogue/cinnabar) || istype(rockturfs, /turf/closed/mineral/rogue/iron) || istype(rockturfs, /turf/closed/mineral/rogue/gold) || istype(rockturfs, /turf/closed/mineral/rogue/silver))
			found_ore(get_turf(rockturfs), user.client, "shieldsparkles")
			//to_chat(user, span_warning("I see some high quality stone"))
		if(istype(rockturfs, /turf/closed/mineral/rogue/gem))
			found_ore(get_turf(rockturfs), user.client, "quantum_sparks")
			//to_chat(user, span_warning("I see some GREAT quality stone"))
		if(istype(rockturfs, /turf/closed/mineral/rogue/bedrock))
			found_ore(get_turf(rockturfs), user.client, "purplesparkles")
			//to_chat(user, span_warning("I see stone too hard to hit"))

	//show the miners what boulders are valuable 
	for(var/obj/item/natural/rock/boulderobjs in view(7,get_turf(user)))
		if(istype(boulderobjs, /obj/item/natural/rock/copper) || istype(boulderobjs, /obj/item/natural/rock/tin) || istype(boulderobjs, /obj/item/natural/rock/coal))
			found_ore(get_turf(boulderobjs), user.client, "sparks")
			//to_chat(user, span_warning("I see some medium quality boulders"))
		if(istype(boulderobjs, /obj/item/natural/rock/cinnabar) || istype(boulderobjs, /obj/item/natural/rock/iron))
			found_ore(get_turf(boulderobjs), user.client, "shieldsparkles")
			//to_chat(user, span_warning("I see some high quality boulders"))
		if(istype(boulderobjs, /obj/item/natural/rock/gold) || istype(boulderobjs, /obj/item/natural/rock/silver) || istype(boulderobjs, /obj/item/natural/rock/gem))
			found_ore(get_turf(boulderobjs), user.client, "quantum_sparks")
			//to_chat(user, span_warning("I see some GREAT quality boulders"))

/proc/found_ore(atom/A, client/C, state)
	if(!A || !C || !state)
		return
	var/image/I = image(icon = 'icons/effects/effects.dmi', loc = A, icon_state = state, layer = 18)
	I.layer = 18
	I.plane = 18
	if(!I)
		return
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flick_overlay(I, list(C), 30)
