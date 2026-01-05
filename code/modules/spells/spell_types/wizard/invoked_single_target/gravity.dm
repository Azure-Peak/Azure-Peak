/obj/effect/proc_holder/spell/invoked/gravity // to do: get scroll icon
	name = "Gravity"
	desc = "Weighten space around someone, crushing them and knocking them to the floor. Stronger opponents will resist and be off-balanced. Consumes <b>Arcane Marks</b> to slightly increase knockdown time and damage."
	cost = 3
	overlay_state = "hierophant"
	xp_gain = TRUE
	releasedrain = 20
	chargedrain = 1
	chargetime = 10
	recharge_time = 20 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("Pondus!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_MEDIUM
	gesture_required = TRUE
	range = 7
	var/delay = 5
	var/damage = 0 // damage based off your str
	var/area_of_effect = 0
	var/extra_time = 0



/obj/effect/proc_holder/spell/invoked/gravity/cast(list/targets, mob/user)
	var/turf/T = get_turf(targets[1])

	for(var/turf/affected_turf in get_hear(area_of_effect, T)) 
		if(affected_turf.density)
			continue


	for(var/turf/affected_turf in get_hear(area_of_effect, T))
	
		new /obj/effect/temp_visual/gravity_trap(affected_turf)

		playsound(T, 'sound/magic/gravity.ogg', 80, TRUE, soundping = FALSE)

		sleep(delay)
		new /obj/effect/temp_visual/gravity(affected_turf)
		for(var/mob/living/L in affected_turf.contents)
			if(L.anti_magic_check())
				visible_message(span_warning("The gravity fades away around you [L] "))  //antimagic needs some testing
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				return TRUE

			var/mark_stacks = consume_arcane_mark_stacks(L)
			extra_time = (mark_stacks*4)
			if(L.STASTR <= 15)
				L.adjustBruteLoss(60+(extra_time))
				L.Knockdown(5+(extra_time))
				if(mark_stacks == 3)
					to_chat(L, "<span class='userdanger'>GRAVITAS COLLAPSE; TRYPTICH-MARKE DETONATION!</span>")
				else
					to_chat(L, "<span class='userdanger'>I'm magically weighed down, losing my footing!</span>")
			else
				L.OffBalance(10+(extra_time))
				L.adjustBruteLoss(15)
				to_chat(L, "<span class='userdanger'>I'm magically weighed down, but my strength resist!</span>")
	return TRUE

/obj/effect/temp_visual/gravity
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_squares"
	name = "gravity magic"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 3 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 2
	light_color = COLOR_PALE_PURPLE_GRAY

/obj/effect/temp_visual/gravity_trap
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	dir = NORTH
	name = "rippling arcyne energy"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 5 SECONDS
	layer = MASSIVE_OBJ_LAYER
