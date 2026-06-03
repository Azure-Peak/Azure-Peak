
//objects in /obj/effect should never be things that are attackable, use obj/structure instead.
//Effects are mostly temporary visual effects like sparks, smoke, as well as decals, etc...
/obj/effect
	icon = 'icons/effects/effects.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	move_resist = INFINITY
	obj_flags = 0
	anchored = TRUE
	density = FALSE

/obj/effect/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	return

/obj/effect/fire_act(added, maxstacks)
	return

/obj/effect/acid_act()
	return

/obj/effect/ex_act(severity, target)
	if(target == src)
		qdel(src)
	else
		switch(severity)
			if(1)
				qdel(src)
			if(2)
				if(prob(60))
					qdel(src)
			if(3)
				if(prob(25))
					qdel(src)


/obj/effect/ConveyorMove()
	return

/obj/effect/abstract/ex_act(severity, target)
	return


/obj/effect/solid_invisible_barrier
	density = TRUE
	opacity = 0
	invisibility = INVISIBILITY_MAXIMUM
	icon_state = "nothing"

/obj/effect/dump_harddel_info()
	if(harddel_deets_dumped)
		return
	harddel_deets_dumped = TRUE
	var/list/parts = list("Effect type: [type]", "icon: [icon]", "icon_state: \"[icon_state]\"", "name: \"[name]\"", "layer: [layer]", "vis_contents: [length(vis_contents)]")
	parts += loc ? "loc.type: [loc.type] ([loc.x],[loc.y],[loc.z])" : "loc: NULLSPACE"
	if(LAZYLEN(datum_components))
		var/list/comp_types = list()
		for(var/key in datum_components)
			comp_types += "[key]"
		parts += "datum_components: [comp_types.Join(",")]"
	if(LAZYLEN(comp_lookup))
		var/list/sig_keys = list()
		for(var/sig in comp_lookup)
			sig_keys += "[sig]"
		parts += "comp_lookup signals: [sig_keys.Join(",")]"
	if(LAZYLEN(signal_procs))
		var/list/sig_sources = list()
		for(var/target in signal_procs)
			var/sig_entry = signal_procs[target]
			sig_sources += "[target]:[islist(sig_entry) ? jointext(sig_entry, "+") : sig_entry]"
		parts += "signal_procs targets: [sig_sources.Join(" ; ")]"
	if(spatial_grid_key)
		parts += "spatial_grid_key: [spatial_grid_key]"
	if(LAZYLEN(important_recursive_contents))
		var/list/irc_keys = list()
		for(var/key in important_recursive_contents)
			irc_keys += "[key]"
		parts += "important_recursive_contents: [irc_keys.Join(",")]"
	return parts.Join(" - ")
