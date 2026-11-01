/datum/charflaw/paranoid
	name = "Paranoid"
	desc = "I'm more anxious than most people. I can hear them, whispering behind my back - speaking in their tongues about my demise.. I know they are out to get me, I just know it!"
	ui_fa_icon = "house-crack"
	var/last_check = 0

/datum/charflaw/paranoid/flaw_on_life(mob/user)
	if(world.time < last_check + 10 SECONDS)
		return
	if(!ishuman(user))
		return

	last_check = world.time
	var/mob/living/carbon/human/H = user
	var/cnt = 0

	for(var/obj/effect/decal/cleanable/blood/B in view(7, user))
		cnt++
		if(cnt > 3)
			break

	if(cnt > 6)
		H.add_stress(/datum/stressevent/parablood)

/datum/charflaw/pacifist
	name = "Pacifist"
	desc = "I have taken a vow of non-violence. I will never do harm to another person, and I do not condone violence as an answer, even if my lyfe is at risk."
	ui_fa_icon = "person-praying"
	needs_extra_vice = TRUE

/datum/charflaw/pacifist/on_mob_creation(mob/user)
	. = ..()
	ADD_TRAIT(user, TRAIT_PACIFISM, "[type]")

/datum/charflaw/defenseless
	name = "Defenseless"
	desc = "I am either reckless to a fault or simply not savvy enough for combat. I will never block or dodge incoming attacks, leaving myself completely exposed to harm."
	ui_fa_icon = "person-praying"

/datum/charflaw/defenseless/on_mob_creation(mob/user)
	. = ..()
	ADD_TRAIT(user, TRAIT_NODEF, "[type]")
