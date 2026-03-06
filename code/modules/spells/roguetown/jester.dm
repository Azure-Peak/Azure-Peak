/obj/effect/proc_holder/spell/self/telljoke
	name = "Comedia"
	desc = "Say something funny to someone in high spirits, it will brighten their mood."
	overlay_state = "comedy"
	antimagic_allowed = TRUE
	invocation_type = "shout"
	recharge_time = 600
	range = 7

/obj/effect/proc_holder/spell/self/telljoke/cast(list/targets,mob/user = usr)
	. = ..()
	var/joker = input(user, "Say something funny!", "Comedia")
	if(!joker)
		return FALSE
	user.say(joker, forced = "spell")
	sleep(20)
	playsound(get_turf(user), 'sound/magic/comedy.ogg', 100)
	for(var/mob/living/carbon/CA in view(range, get_turf(user)))
		if(CA == user)
			continue
		if(CA.cmode)
			continue
		if(CA.get_stress_amount() <= 0)
			CA.add_stress(/datum/stressevent/joke)
			CA.emote(pick("laugh","chuckle","giggle"), forced = TRUE)
			
			// Apply Xylix buff to those with the trait who hear the laughter
			// Only apply if the hearer is not the one laughing and not the spell caster
			for(var/mob/living/carbon/human/H in hearers(7, CA))
				if(H == CA || H == user || !H.client)
					continue
				if(HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy))
					H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
					to_chat(H, span_info("The laughter brings a smile to my face, and fortune to my steps!"))
		sleep(rand(1,5))

/obj/effect/proc_holder/spell/self/telltragedy
	name = "Tragedia"
	desc = "Remind someone in low spirits that it could be much worse."
	overlay_state = "tragedy"
	antimagic_allowed = TRUE
	invocation_type = "shout"
	recharge_time = 600
	range = 7

/obj/effect/proc_holder/spell/self/telltragedy/cast(list/targets,mob/user = usr)
	. = ..()
	var/joker = input(user, "Say something sad!", "Tragedia")
	if(!joker)
		return FALSE
	user.say(joker, forced = "spell")
	sleep(20)
	playsound(get_turf(user), 'sound/magic/tragedy.ogg', 100)
	for(var/mob/living/carbon/CA in view(range, get_turf(user)))
		if(CA == user)
			continue
		if(CA.cmode)
			continue
		if(CA.get_stress_amount() > 0)
			CA.add_stress(/datum/stressevent/tragedy)
			CA.emote(pick("sigh","hmm"), forced = TRUE)
		sleep(rand(1,5))
