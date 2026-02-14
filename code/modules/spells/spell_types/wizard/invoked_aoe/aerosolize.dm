/obj/effect/proc_holder/spell/invoked/aerosolize
	name = "Aerosolize" //once again renamed to fit better :)
	desc = "Turns a container of liquid into a smoke containing the reagents of that liquid. Be warned, you absord the liquid you aerosolize"
	overlay_state = "aerosolize"
	releasedrain = 50
	chargetime = 15 // same as a fireball
	recharge_time = 30 SECONDS
	range = 6
	warnie = "spellwarning"
	movement_interrupt = FALSE
	no_early_release = FALSE
	chargedloop = null
	sound = 'sound/magic/whiteflame.ogg'
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("Converti in Nebulam!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE // Spell w/ offensive potential, but don't matter cuz you have no hands. Still, consistency
	human_req = TRUE // Combat spell
	cost = 3

	xp_gain = TRUE
	miracle = FALSE

	var/delay = 12
	var/mutable_appearance/aero_target
	
/obj/effect/proc_holder/spell/invoked/aerosolize/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	if(T)
		new /obj/effect/temp_visual/trap(T)
		sleep(delay)
		var/obj/item/held_item = user.get_active_held_item()
		var/obj/item/reagent_containers/con = held_item
		if(con)
			if(con.spillable)
				if(con.reagents.total_volume > 0)
					var/datum/reagents/R = con.reagents
					var/datum/effect_system/smoke_spread/chem/smoke = new
					smoke.set_up(R, 1, T, FALSE)
					smoke.start()
					con.reagents.trans_to(user, con.reagents.total_volume) // Transfers all of the reagents into the user
					user.visible_message(span_warning("[user] sprays the contents of the [held_item], absorbing it and creating a cloud!"), span_warning("You spray the contents of the [held_item], absorbing it and creating a cloud!"))
					playsound(user, 'sound/magic/webspin.ogg', 100)
				else
					to_chat(user, "<span class='warning'>The [held_item] is empty!</span>")
					revert_cast()
			else
				to_chat(user, "<span class='warning'>I can't get access to the contents of this [held_item]!</span>")
				revert_cast()
		else
			to_chat(user, "<span class='warning'>I need to hold a container to cast this!</span>")
			revert_cast()
	else
		to_chat(user, "<span class='warning'>I couldn't find a good place for this!</span>")
		revert_cast()
