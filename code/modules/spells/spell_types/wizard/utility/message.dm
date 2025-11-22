/obj/effect/proc_holder/spell/self/message
	name = "Message"
	desc = "Latch onto the mind of one who is familiar to you, whispering a message or sending an intuitive projection into their head."
	cost = 2
	xp_gain = TRUE
	releasedrain = 30
	recharge_time = 60 SECONDS
	warnie = "spellwarning"
	spell_tier = 1
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "message"
	/// The stat threshold needed to pass the identify check.
	var/identify_difficulty = 15

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
	var/input = input(user, "Who do you wish to contact?", src) as null|anything in eligible_players
	if(isnull(input))
		to_chat(user, span_warning("No target selected."))
		revert_cast()
		return

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == input)
			user.emote("me", 1, "mutters an incantation, their mouth briefly flashing white!", TRUE, custom_me = TRUE)

			// Standard message color, for anonymous communications.
			var/message_color = "7246ff"

			// Is this a message or a projection? Messages are whispered words, a projection is a projected image or vision.
			// Projections do have the benefit of not being whispered, but your saviours will have to make do with non-explicit
			// imagery from which they'll have to figure out what you're trying to tell them.
			var/is_projection = FALSE

			// Are we sending a message or a projection?
			if(alert(user, "Transmit as a worldessly projected vision or as a whispered message?", "", "Projection", "Message") == "Projection")
				is_projection = TRUE

			var/message = input(user, "You successfully make a connection! [is_projection == TRUE ? "What sensory vision are you trying to send into their mind?" : "What are you trying to whisper into their mind?"]")

			if(!message)
				revert_cast()
				return

			if(alert(user, "Send anonymously?", "", "Yes", "No") == "No") //yes or no popup, if you say No run this code
				identify_difficulty = 0 //anyone can clear this

			HL.playsound_local(HL, 'sound/magic/message.ogg', 100)
			user.playsound_local(user, 'sound/magic/message.ogg', 100)

			var/identified = FALSE
			if(HL.STAPER >= identify_difficulty) //quick stat check
				if(HL.mind)
					if(HL.mind.do_i_know(name=user.real_name)) //do we know who this person is?
						identified = TRUE // we do

						// Typecasting so we can access the user's voice color!
						if(ishuman(user))
							var/mob/living/carbon/human/H = user
							// If we aren't anonymous, we speak in our own voice colour.
							message_color = H.voice_color

						// If this a projection or not?
						if(!is_projection)
							to_chat(HL, span_big("Arcyne whispers slip into my mind, resolving into [user]'s voice: <font color=#[message_color]><i>\"[message]\"</i></font>"))
							to_chat(user, span_big("You whisper into [HL]'s mind, identifying yourself in the process: <font color=#[message_color]><i>\"[message]\"</i></font>"))
						else
							to_chat(HL, span_big("A brief vision suddenly flashes in my mind, familiar as originating from [user]'s headspace: <font color=#[message_color]>\[<b>[message]</b>\]</font>"))
							to_chat(user, span_big("You slip a brief vision into [HL]'s mind, identifying yourself in the process: <font color=#[message_color]>\[<b>[message]</b>\]</font>"))

			// We failed the check OR we just dont know who that is
			if(!identified)
				if(!is_projection)
					to_chat(HL, span_big("Arcyne whispers slip into my mind, resolving into an unknown [user.gender == FEMALE ? "woman" : "man"]'s voice: <font color=#[message_color]><i>\"[message]\"</i></font>"))
					to_chat(user, span_big("You whisper anonymously into [HL]'s mind: <font color=#[message_color]><i>\"[message]\"</i></font>"))
				else
					to_chat(HL, span_big("A brief vision suddenly flashes in my mind, originating from an unknown source: <font color=#[message_color]>\[<b>[message]</b>\]</font>"))
					to_chat(user, span_big("You slip a brief vision anonymously into [HL]'s mind: <font color=#[message_color]>\[<b>[message]</b>\]</font>"))

			// Messages are whispered out loud, projections are just a silent murmur.
			if(!is_projection)
				user.whisper(message)
			else
				user.emote("me", 1, "silently murmurs something resembling speech...", TRUE, custom_me = TRUE)

			log_game("[key_name(user)] sent a message to [key_name(HL)] with contents [message]")
			// maybe an option to return a message, here?
			return TRUE

	to_chat(user, span_warning("I seek a mental connection, but can't find [input]."))
	revert_cast()
	return
