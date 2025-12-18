// Arcyne Prison, with warning
/obj/effect/proc_holder/spell/invoked/forcewall/arcyne_prison
	name = "Arcyne Prison"
	desc = "Conjure a wall of weak arcane force around a 5x5 area after a short delay, trapping anyone within. You can pass through it."
	school = "transmutation"
	releasedrain = 50
	spell_tier = 4 // Trolling spell, CM only.
	invocations = list("Mysticus Carcer!") // Magical Prison of Mysterious Magic.
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_HIGH
	wall_type = /obj/structure/forcefield_weak/arcyne_prison
	cost = 6

/obj/effect/proc_holder/spell/invoked/forcewall/arcyne_prison/cast(list/targets,mob/user = usr)
	var/turf/target = get_turf(targets[1])

	for(var/turf/affected_turf in get_hear(2, target))
		if(!(affected_turf in get_hear(2, target)))
			continue
		if(get_dist(target, affected_turf) != 2)
			continue
		new /obj/effect/temp_visual/trap_wall(affected_turf)
		addtimer(CALLBACK(src, PROC_REF(new_wall), affected_turf, user), wait = 1 SECONDS)

	user.visible_message("[user] mutters an incantation and a prison of arcyne force manifests out of thin air!")
	return TRUE

/obj/structure/forcefield_weak/arcyne_prison
	desc = "A wall of pure arcyne force. This looks like it would be easily broken."
	name = "Arcyne Prison"
	max_integrity = 50 // Ultra 
