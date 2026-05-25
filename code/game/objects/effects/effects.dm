
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
	return "Effect type: [type] - icon: [icon] - icon_state: [icon_state] - name: \"[name]\" - layer: [layer] - vis_contents: [length(vis_contents)] [loc ? "loc.type: [loc.type] ([loc.x],[loc.y],[loc.z])" : "loc: NULLSPACE"]"
