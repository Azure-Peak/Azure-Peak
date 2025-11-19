/obj/effect/proc_holder/spell/invoked/mindlink
	name = "Mindlink"
	desc = "Establish a telepathic link with an ally for three minutes. Use ,y before a message to communicate telepathically."
	clothes_req = FALSE
	overlay_state = "mindlink"
	associated_skill = /datum/skill/magic/arcane
	cost = 3
	xp_gain = TRUE
	recharge_time = 3 MINUTES
	spell_tier = 3
	invocations = list("Mens Nexu")
	invocation_type = "whisper"

	// Charged spell variables
	chargedloop = /datum/looping_sound/invokegen
	chargedrain = 1
	chargetime = 20
	releasedrain = 25
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	warnie = "spellwarning"
	ignore_los = TRUE

/obj/effect/proc_holder/spell/invoked/mindlink/cast(list/targets, mob/living/user)
	. = ..()
	if(!istype(user))
		return

	var/list/possible_targets = list()
	if(user.mind.known_people.len)
		for(var/people in user.mind.known_people)
			possible_targets += people
	else
		to_chat(user, span_warning("You have no known people to establish a mindlink with!"))
		revert_cast()
		return FALSE

	possible_targets = sortList(possible_targets)

	if(user.client)
		possible_targets = list(user.real_name) + possible_targets // Oohhhhhh this looks bad. But this is supposed to append ourselves at the start of the ordered list.

	user.emote("me", 1, "'s eyes briefly glow with an otherworldly light.", TRUE, custom_me = TRUE)

	var/first_target_name = input(user, "Choose the first person to link", "Mindlink") as null|anything in possible_targets

	if(!first_target_name)
		revert_cast()
		return FALSE

	var/mob/living/first_target

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == first_target_name)
			first_target = HL

	possible_targets -= first_target_name

	var/second_target_name = input(user, "Choose the second person to link", "Mindlink") as null|anything in possible_targets

	if(!second_target_name)
		revert_cast()
		return FALSE

	var/mob/living/second_target

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == second_target_name)
			second_target = HL

	user.visible_message(span_notice("[user] touches their temples and concentrates..."), span_notice("I establish a mental connection between [first_target] and [second_target]..."))

	// Create the mindlink
	var/datum/mindlink/link = new(first_target, second_target)
	GLOB.mindlinks += link

	to_chat(first_target, span_notice("A mindlink has been established with [second_target]! Use ,y before a message to communicate telepathically."))
	to_chat(second_target, span_notice("A mindlink has been established with [first_target]! Use ,y before a message to communicate telepathically."))

	addtimer(CALLBACK(src, PROC_REF(break_link), link), 3 MINUTES)
	return TRUE

/obj/effect/proc_holder/spell/invoked/mindlink/proc/break_link(datum/mindlink/link)
	if(!link)
		return

	to_chat(link.owner, span_warning("The mindlink with [link.target] fades away..."))
	to_chat(link.target, span_warning("The mindlink with [link.owner] fades away..."))

	GLOB.mindlinks -= link
	qdel(link)


