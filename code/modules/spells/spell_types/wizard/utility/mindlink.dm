/datum/action/cooldown/spell/mindlink
	button_icon = 'icons/mob/actions/roguespells.dmi'
	name = "Mindlink"
	desc = "Establish a telepathic link with an ally for three minutes. Use ,Y before a message to communicate telepathically."
	button_icon_state = "mindlink"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Mens Nexu")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 3 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/mindlink/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/list/possible_targets = list()
	if(user.mind.known_people.len)
		for(var/people in user.mind.known_people)
			possible_targets += people
	else
		to_chat(user, span_warning("You have no known people to establish a mindlink with!"))
		return FALSE

	possible_targets = sortList(possible_targets)

	if(user.client)
		possible_targets = list(user.real_name) + possible_targets

	user.emote("me", 1, "'s eyes briefly glow with an otherworldly light.", TRUE, custom_me = TRUE)

	var/first_target_name = tgui_input_list(user, "Choose the first person to link", "Mindlink", possible_targets)

	if(!first_target_name)
		return FALSE

	var/mob/living/first_target

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == first_target_name)
			first_target = HL

	possible_targets -= first_target_name

	var/second_target_name = tgui_input_list(user, "Choose the second person to link", "Mindlink", possible_targets)

	if(!second_target_name)
		return FALSE

	var/mob/living/second_target

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == second_target_name)
			second_target = HL

	for(var/datum/mindlink/ML in GLOB.mindlinks)
		if(ML)
			if(ML.owner == first_target || ML.target == first_target || ML.owner == second_target || ML.target == second_target)
				to_chat(user, span_warning("A mindlink is already present binding one of the targets!"))
				return FALSE

	user.visible_message(span_notice("[user] touches their temples and concentrates..."), span_notice("I establish a mental connection between [first_target] and [second_target]..."))

	// Create the mindlink
	var/datum/mindlink/link = new(first_target, second_target)
	GLOB.mindlinks += link

	to_chat(first_target, span_notice("A mindlink has been established with [second_target]! Use ,y before a message to communicate telepathically. Use ,mst to break the link."))
	to_chat(second_target, span_notice("A mindlink has been established with [first_target]! Use ,y before a message to communicate telepathically. Use ,mst to break the link."))

	addtimer(CALLBACK(src, PROC_REF(break_link), link), 3 MINUTES)
	return TRUE

/datum/action/cooldown/spell/mindlink/proc/break_link(datum/mindlink/link)
	if(!link)
		return

	to_chat(link.owner, span_warning("The mindlink with [link.target] fades away..."))
	to_chat(link.target, span_warning("The mindlink with [link.owner] fades away..."))

	GLOB.mindlinks -= link
	qdel(link)
