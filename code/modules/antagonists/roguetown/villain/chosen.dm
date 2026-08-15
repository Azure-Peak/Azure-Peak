/datum/antagonist/chosen
	name = "Chosen" // special role that basically just exists to give
	job_rank = ROLE_CHOSEN // storytellers the ability to add objectives to whoever. this is probably
	show_in_roundend = FALSE // terrible because i dont know what the fuck i'm doing beyond	guessing and reading code.
	increase_votepwr = FALSE // like this, what does this do?
	rogue_enabled = TRUE // or this? I DONT KNOW BECAUSE THERES NO DOCUMENTATION
	antagpanel_category = "DIY Storyteller" // hopefully gets the point across
	antag_flags = FLAG_FAKE_ANTAG
	confess_lines = list(
		"MY GOALS ARE BEYOND YOUR UNDERSTANDING!",
	)
/datum/antagonist/chosen/on_gain()
	greet()
	return ..()

/datum/antagonist/chosen/on_removal()
	to_chat(owner.current, span_userdanger("The memory of my tasks evades me. What was I doing, again...?"))
	return ..()

/datum/antagonist/chosen/greet()
	to_chat(owner.current,span_userdanger("I have been CHOSEN for tasks by an external entity, or the TUMOR within my mind... I must SURVIVE to recieve further instructions."))
	owner.announce_objectives()
	return ..()
