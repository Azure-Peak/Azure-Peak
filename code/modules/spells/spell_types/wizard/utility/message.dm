/datum/action/cooldown/spell/message
	name = "Message"
	desc = "Latch onto the mind of one who is familiar to you, whispering a message or sending an intuitive projection into their head."
	button_icon_state = "message"
	sound = 'sound/magic/message.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Mens Dicta")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// The stat threshold needed to pass the identify check.
	var/identify_difficulty = 15

/datum/action/cooldown/spell/message/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!istype(user) || !user.mind)
		return FALSE

	if(!user.mind.known_people.len)
		to_chat(user, span_warning("I don't know anyone."))
		return FALSE

	var/list/eligible_players = list()
	for(var/people in user.mind.known_people)
		eligible_players += people
	eligible_players = sortList(eligible_players)

	var/input = tgui_input_list(user, "Who do you wish to contact?", "Message", eligible_players)
	if(isnull(input))
		to_chat(user, span_warning("No target selected."))
		return FALSE

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name != input)
			continue

		user.emote("me", 1, "mutters an incantation, their mouth briefly flashing white!", TRUE, custom_me = TRUE)

		var/message_color = "7246ff"
		var/is_projection = FALSE

		if(alert(user, "Transmit as a wordlessly projected vision or as a whispered message?", "", "Projection", "Message") == "Projection")
			is_projection = TRUE

		var/message = input(user, "You successfully make a connection! [is_projection ? "What sensory vision are you trying to send into their mind?" : "What are you trying to whisper into their mind?"]")
		if(!message)
			return FALSE

		if(alert(user, "Send anonymously?", "", "Yes", "No") == "No")
			identify_difficulty = 0

		HL.playsound_local(HL, 'sound/magic/message.ogg', 100)
		user.playsound_local(user, 'sound/magic/message.ogg', 100)

		var/identified = FALSE
		if(HL.STAPER >= identify_difficulty)
			if(HL.mind)
				if(HL.mind.do_i_know(name=user.real_name))
					identified = TRUE
					if(ishuman(user))
						message_color = user.voice_color
					if(!is_projection)
						to_chat(HL, span_big("Arcyne whispers slip into my mind, resolving into [user]'s voice: <font color=#[message_color]><i>\"[message]\"</i></font>"))
						to_chat(user, span_big("You whisper into [HL]'s mind, identifying yourself in the process: <font color=#[message_color]><i>\"[message]\"</i></font>"))
					else
						to_chat(HL, span_big("A brief vision suddenly flashes in my mind, familiar as originating from [user]'s headspace: <font color=#[message_color]>\[<b>[message]</b>\]</font>"))
						to_chat(user, span_big("You slip a brief vision into [HL]'s mind, identifying yourself in the process: <font color=#[message_color]>\[<b>[message]</b>\]</font>"))

		if(!identified)
			if(!is_projection)
				to_chat(HL, span_big("Arcyne whispers slip into my mind, resolving into an unknown [user.gender == FEMALE ? "woman" : "man"]'s voice: <font color=#[message_color]><i>\"[message]\"</i></font>"))
				to_chat(user, span_big("You whisper anonymously into [HL]'s mind: <font color=#[message_color]><i>\"[message]\"</i></font>"))
			else
				to_chat(HL, span_big("A brief vision suddenly flashes in my mind, originating from an unknown source: <font color=#[message_color]>\[<b>[message]</b>\]</font>"))
				to_chat(user, span_big("You slip a brief vision anonymously into [HL]'s mind: <font color=#[message_color]>\[<b>[message]</b>\]</font>"))

		if(!is_projection)
			user.whisper(message, language = /datum/language/common)
		else
			user.emote("me", 1, "silently murmurs something resembling speech...", TRUE, custom_me = TRUE)

		log_game("[key_name(user)] sent a message to [key_name(HL)] with contents [message]")
		return TRUE

	to_chat(user, span_warning("I seek a mental connection, but can't find [input]."))
	return FALSE
