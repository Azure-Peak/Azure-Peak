/obj/effect/proc_holder/spell/self/message
	name = "Message"
	desc = "Latch onto the mind of one who is familiar to you, whispering a message into their head."
	cost = 2
	xp_gain = TRUE
	releasedrain = 30
	recharge_time = 60 SECONDS
	warnie = "spellwarning"
	spell_tier = 1
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "message"
	var/identify_difficulty = 15 //the stat threshold needed to pass the identify check

/obj/effect/proc_holder/spell/self/message/cast(list/targets, mob/user)
	. = ..()

	var/list/eligible_players = list()

	if(user.mind.known_people.len)
		for(var/people in user.mind.known_people)
			eligible_players += people
	else
		to_chat(user, span_warning("I don't know anyone."))
		revert_cast()
		return
	eligible_players = sortList(eligible_players)
	user.emote("me", 1, "mutters an incantation and their mouth briefly flashes white.", TRUE, custom_me = TRUE)
	var/input = input(user, "Who do you wish to contact?", src) as null|anything in eligible_players
	if(isnull(input))
		to_chat(user, span_warning("No target selected."))
		revert_cast()
		return
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == input)
			var/message = input(user, "You make a connection. What are you trying to say?")
			if(!message)
				revert_cast()
				return
			if(alert(user, "Send anonymously?", "", "Yes", "No") == "No") //yes or no popup, if you say No run this code
				identify_difficulty = 0 //anyone can clear this

			var/identified = FALSE
			HL.playsound_local(HL, 'sound/magic/message.ogg', 100)
			if(HL.STAPER >= identify_difficulty) //quick stat check
				if(HL.mind)
					if(HL.mind.do_i_know(name=user.real_name)) //do we know who this person is?
						identified = TRUE // we do
						to_chat(HL, "Arcyne whispers fill the back of my head, resolving into [user]'s voice: <font color=#7246ff>[message]</font>")

			if(!identified) //we failed the check OR we just dont know who that is
				to_chat(HL, "Arcyne whispers fill the back of my head, resolving into an unknown [user.gender == FEMALE ? "woman" : "man"]'s voice: <font color=#7246ff>[message]</font>")
			user.whisper(message)
			log_game("[key_name(user)] sent a message to [key_name(HL)] with contents [message]")
			// maybe an option to return a message, here?
			return TRUE
	to_chat(user, span_warning("I seek a mental connection, but can't find [input]."))
	revert_cast()
	return
