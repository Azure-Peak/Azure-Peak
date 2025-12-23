/obj/item/caparison
	name = "caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. This one fits on a Saiga."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "caparison"
	var/caparison_state = "caparison"
	var/female_caparison_state = "caparison-f"
	gender = NEUTER
	var/list/valid_animal_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/saiga
	)

/obj/item/caparison/attack(mob/living/M, mob/living/user)
	if(!issimple(M))
		to_chat(user, span_warning("\The [src] can only be used on animals!"))
		return
	if(!is_type_in_list(M, valid_animal_types))
		to_chat(user, span_warning("\The [src] cannot be used on [M]! It is only meant for specific animals."))
		return

	var/mob/living/simple_animal/animal = M
	if(animal.adult_growth)
		to_chat(user, span_warning("[animal] is a juvenile and cannot wear a caparison!"))
		return
	if(animal.ccaparison)
		to_chat(user, span_warning("[animal] is already wearing a caparison!"))
		return
	if(!animal.ssaddle)
		to_chat(user, span_warning("[animal] needs to be saddled before you can fit a caparison onto it!"))
		return

	user.visible_message(span_notice("[user] is fitting a caparison onto [animal]..."), span_notice("I start fitting a caparison onto [animal]..."))
	if(!do_after(user, 5 SECONDS, TRUE, animal))
		return

	animal.ccaparison = src
	forceMove(animal)
	animal.update_icon()
	user.visible_message(span_notice("[user] fits a caparison onto [animal]."), span_notice("I fit a caparison onto [animal]."))

/obj/item/caparison/psy
	name = "psydonite caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with Psycrosses. This one fits on a Saiga."
	caparison_state = "psy_caparison"
	female_caparison_state = "psy_caparison-f"

/obj/item/caparison/astrata
	name = "astratan caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with Astratan crosses. This one fits on a Saiga."
	caparison_state = "astra_caparison"
	female_caparison_state = "astra_caparison-f"

/obj/item/caparison/eora
	name = "eoran caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with Eoran hearts. This one fits on a Saiga."
	caparison_state = "eora_caparison"
	female_caparison_state = "eora_caparison-f"
