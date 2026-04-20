//A skill for bath attendants to help their clients relax
/obj/effect/proc_holder/spell/invoked/massage
	name = "Massage"
	desc = "Massage a client, working out the soreness in their muscles"
	overlay_state = "massage"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE
	invocation_type = "none"

/obj/effect/proc_holder/spell/invoked/massage/cast(list/targets, mob/user = usr)
	var/mob/living/massagee = targets[1]
	var/mob/living/massager = user
	var/massagetime = 20 SECONDS
	var/agreementone = FALSE
	var/agreementtwo = FALSE
	var/chance = rand(0,100)
	var/chance_append = max((massager.get_stat(STATKEY_LCK) - 10) * 5, 0)
	chance = min(chance + chance_append, 100)

	if(!ishuman(massagee))
		to_chat(massager, span_warning("I don't think I can massage that."))
		revert_cast()
		return

	if(massager == massagee)
		to_chat(massager, span_warning("Sadly, I can't give myself a pat on the back."))
		revert_cast()
		return

	if((massagee.mobility_flags & MOBILITY_STAND))
		// Check if they're in bathing water or at a hotspring
		var/turf/massage_spot = get_turf(massagee)
		var/in_valid_location = FALSE

		// Check for bath/water tile
		if(istype(massage_spot, /turf/open/water/bath))
			in_valid_location = TRUE

		// Check for hotspring structure
		if(locate(/obj/structure/hotspring) in massage_spot)
			in_valid_location = TRUE

		if(!in_valid_location)
			to_chat(massager, span_warning("My client must be laying down, or standing in water suitable for bathing."))
			revert_cast()
			return

	if(isliving(massagee)) //target needs to be living
		if(massagee in range(1, massager))
			switch(alert(massager,"Are you sure you want give [massagee.name] a massage?", "Do you want give a Massage?","Yes","No"))
				if("Yes")
					to_chat(massager, span_warning("I ask if they are ready")) //make sure this is who I want to massage
					agreementone = TRUE
				if("No")
					to_chat(massager, span_warning("I decided not to"))
					return
				else
					to_chat(massager, span_warning("I decided not to"))
					return

			switch(alert(massagee, "Do you want to be given a massage by [massager.name]?", "Do you want a Massage?", "No", "Yes"))
				if("No")
					to_chat(massager, span_warning("They declined"))
					return
				if("Yes")
					to_chat(massager, span_warning("They agree")) //make sure they consent to a massage
					agreementtwo = TRUE
				else
					to_chat(massager, span_warning("They declined"))
					return

			if (agreementone && agreementtwo)
				//we can proceed, they weren't afk
			else
				to_chat(massager, span_warning("They can't agree right now")) //a final catch all
				return

			if(massagee.has_status_effect(/datum/status_effect/debuff/muscle_sore) || massagee.has_status_effect(/datum/status_effect/buff/massage) || massagee.has_status_effect(/datum/status_effect/buff/goodmassage) || massagee.has_status_effect(/datum/status_effect/buff/greatmassage))
				to_chat(massagee, span_warning("My muscles are still recovering"))
				to_chat(massager, span_warning("my client has had too many strains on their muscles and need time"))
				return // can not continually give massages, the buff needs to wear off and you need to sleep off any cramps
			else
				to_chat(massagee, span_notice("[massager] starts to give me a massage."))
				to_chat(massager, span_notice("[massagee] starts to receive a massage."))
				playsound(massager, pick('modular/Neu_Food/sound/kneading.ogg','modular/Neu_Food/sound/kneading_alt.ogg'), 10, TRUE)
				massagetime = pick(20 SECONDS, 25 SECONDS, 30 SECONDS, 35 SECONDS, 40 SECONDS) //randomize times
				if(do_after(massager, massagetime, target = massagee))
					switch(chance)
						if(0 to 49)
							to_chat(massagee, span_notice("Ah, a massage helps my body relax"))
							massagee.apply_status_effect(/datum/status_effect/buff/massage)
							to_chat(massager, span_warning("I gave an ok massage."))
						if(50 to 95)
							to_chat(massagee, span_notice("That massage made my body feel really good"))
							massagee.apply_status_effect(/datum/status_effect/buff/goodmassage)
							to_chat(massager, span_warning("I gave a good massage."))
						if (96 to 100)
							to_chat(massagee, span_notice("WOW! That massage made me feel great!"))
							massagee.apply_status_effect(/datum/status_effect/buff/greatmassage)
							to_chat(massager, span_warning("I gave a great massage!"))
		else
			to_chat(massager, span_warning("the [massagee] needs to stay near me during their massage!"))
			to_chat(massagee, span_warning("I need to stay near [massager] during my massage!"))
			if (prob(55))
				to_chat(massagee, span_warning("Ah, I barely managed to escape a cramp just then, I must be careful."))
			else
				to_chat(massagee, span_bad("Oh no, I can feel it, A CRAMP!"))
				massagee.apply_status_effect(/datum/status_effect/debuff/muscle_sore)
