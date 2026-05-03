/obj/effect/proc_holder/spell/targeted/shapeshift
	name = "Shapechange"
	desc = ""
	clothes_req = FALSE
	human_req = FALSE
	recharge_time = 200
	cooldown_min = 50
	range = -1
	include_user = TRUE
	invocation_type = "none"
	action_icon_state = "shapeshift"

	var/revert_on_death = TRUE
	var/die_with_shapeshifted_form = FALSE
	var/knockout_on_death = 50
	var/convert_damage = TRUE
	var/convert_damage_type = BRUTE
	var/do_gib = TRUE

	var/pick_again = null
	var/shapeshift_type
	var/list/possible_shapes = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/cat,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf,
		/mob/living/simple_animal/hostile/retaliate/rogue/mole,
		/mob/living/simple_animal/hostile/retaliate/rogue/saiga
	)


/obj/effect/proc_holder/spell/targeted/shapeshift/cast(list/targets, mob/user = usr)
	. = ..()

	var/datum/antagonist/vampire/VD = user?.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(VD && SEND_SIGNAL(user, COMSIG_DISGUISE_STATUS))
		to_chat(user, span_warning("My curse is hidden."))
		return

	if(user.restrained(ignore_grab = FALSE))
		to_chat(user, span_warn("I am restrained, I can't shapeshift!"))
		return

	if(src in user.mob_spell_list)
		user.mob_spell_list.Remove(src)
		user.mind.AddSpell(src)

	if(user.buckled)
		user.buckled.unbuckle_mob(src, force = TRUE)

	for(var/mob/living/M in targets)

		// Pick form if not set
		if(!shapeshift_type)
			var/list/animal_list = list()
			for(var/path in possible_shapes)
				var/mob/living/simple_animal/A = path
				animal_list[initial(A.name)] = path

			var/choice = input(M, "Choose Your Animal Form!", "It's Morphing Time!", null) as null|anything in sortList(animal_list)
			if(!choice)
				return

			if(shapeshift_type) // someone else set it mid-input
				return

			shapeshift_type = animal_list[choice]

		// Already shapeshifted? Then restore
		var/obj/shapeshift_holder/S = locate(/obj/shapeshift_holder) in M
		if(S)
			Restore(M)
			continue

		// Special delayed revert case
		if(shapeshift_type == /mob/living/simple_animal/hostile/retaliate/gaseousform)
			spawn(100)
				Restore(M)

		Shapeshift(M)
		return TRUE

	return



/obj/effect/proc_holder/spell/targeted/shapeshift/proc/Shapeshift(mob/living/caster)
	var/obj/shapeshift_holder/H = locate(/obj/shapeshift_holder) in caster
	if(H)
		to_chat(caster, span_warning("You're already shapeshifted!"))
		return

	if(do_gib)
		playsound(caster.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)

	// Create the new form
	var/mob/living/shape = new shapeshift_type(get_turf(caster))

	// Create holder INSIDE the new form, passing shape explicitly
	H = new /obj/shapeshift_holder(shape, src, caster, shape)

	if(do_gib)
		caster.spawn_gibs(FALSE)



/obj/effect/proc_holder/spell/targeted/shapeshift/proc/Restore(mob/living/shape)
	var/obj/shapeshift_holder/H = locate(/obj/shapeshift_holder) in shape
	if(!H)
		return

	H.restore()

	if(pick_again == TRUE)
		shapeshift_type = null

	clothes_req = initial(clothes_req)
	human_req = initial(human_req)
