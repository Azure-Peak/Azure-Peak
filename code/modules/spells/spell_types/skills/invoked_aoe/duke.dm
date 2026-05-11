/obj/effect/proc_holder/spell/self/grant_title
	name = "Grant Title"
	desc = "Grant someone a title of honor... Or shame."
	overlay_state = "recruit_titlegrant"
	antimagic_allowed = TRUE
	recharge_time = 100
	/// Maximum range for title granting
	var/title_range = 3
	/// Maximum length for the title
	var/title_length = 42

/obj/effect/proc_holder/spell/self/grant_title/cast(list/targets, mob/user = usr)
	. = ..()
	var/granted_title = input(user, "What title do you wish to grant?", "[name]") as null|text
	granted_title = reject_bad_text(granted_title, title_length)
	if(!granted_title)
		return
	var/list/recruitment = list()
	for(var/mob/living/carbon/human/village_idiot in (get_hearers_in_view(title_range, user) - user))
		//not allowed
		if(!can_title(village_idiot))
			continue
		recruitment[village_idiot.name] = village_idiot
	if(!length(recruitment))
		to_chat(user, span_warning("There are no potential honoraries in range."))
		return
	var/inputty = input(user, "Select an honorary!", "[name]") as anything in recruitment
	if(inputty)
		var/mob/living/carbon/human/recruit = recruitment[inputty]
		if(!QDELETED(recruit) && (recruit in get_hearers_in_view(title_range, user)))
			INVOKE_ASYNC(src, PROC_REF(village_idiotify), recruit, user, granted_title)
		else
			to_chat(user, span_warning("Honorific failed!"))
	else
		to_chat(user, span_warning("Honorific cancelled."))

/obj/effect/proc_holder/spell/self/grant_title/proc/can_title(mob/living/carbon/human/recruit)
	//wtf
	if(QDELETED(recruit))
		return FALSE
	//need a mind
	if(!recruit.mind)
		return FALSE
	//need to see their damn face
	if(!recruit.get_face_name(null))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/grant_title/proc/village_idiotify(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter, granted_title)
	if(QDELETED(recruit) || QDELETED(recruiter) || !granted_title)
		return FALSE
	if(GLOB.lord_titles[recruit.real_name])
		recruiter.say("I HEREBY STRIP YOU, [uppertext(recruit.name)], OF THE TITLE OF [uppertext(GLOB.lord_titles[recruit.real_name])]!")
		GLOB.lord_titles -= recruit.real_name
		message_admins("TITLE REVOKED: [ADMIN_LOOKUPFLW(recruiter)] has revoked [recruit.real_name] ([recruit.ckey]) the title of [granted_title]")
		log_game("TITLE REVOKED: [recruiter.real_name] ([recruiter.ckey]) has revoked [recruit.real_name] ([recruit.ckey]) the title of [granted_title]")
		return FALSE
	recruiter.say("I HEREBY GRANT YOU, [uppertext(recruit.name)], THE TITLE OF [uppertext(granted_title)]!")
	GLOB.lord_titles[recruit.real_name] = granted_title
	message_admins("TITLE GRANTED: [ADMIN_LOOKUPFLW(recruiter)] has granted [recruit.real_name] ([recruit.ckey]) the title of [granted_title]")
	log_game("TITLE GRANTED: [recruiter.real_name] ([recruiter.ckey]) has granted [recruit.real_name] ([recruit.ckey]) the title of [granted_title]")
	return TRUE

/obj/effect/proc_holder/spell/self/grant_nobility
	name = "Grant Nobility"
	desc = "Make someone a noble, or strip them of their nobility."
	overlay_state = "recruit_titlegrant"
	antimagic_allowed = TRUE
	recharge_time = 100
	/// Maximum range for nobility granting
	var/nobility_range = 3

/obj/effect/proc_holder/spell/self/grant_nobility/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/recruitment = list()
	for(var/mob/living/carbon/human/village_idiot in (get_hearers_in_view(nobility_range, user) - user))
		//not allowed
		if(!can_nobility(village_idiot))
			continue
		recruitment[village_idiot.name] = village_idiot
	if(!length(recruitment))
		to_chat(user, span_warning("There are no potential honoraries in range."))
		return
	var/inputty = input(user, "Select an honorary!", "[name]") as anything in recruitment
	if(inputty)
		var/mob/living/carbon/human/recruit = recruitment[inputty]
		if(!QDELETED(recruit) && (recruit in get_hearers_in_view(nobility_range, user)))
			INVOKE_ASYNC(src, PROC_REF(grant_nobility), recruit, user)
		else
			to_chat(user, span_warning("Honorific failed!"))
	else
		to_chat(user, span_warning("Honorific cancelled."))

/obj/effect/proc_holder/spell/self/grant_nobility/proc/can_nobility(mob/living/carbon/human/recruit)
	//wtf
	if(QDELETED(recruit))
		return FALSE
	//need a mind
	if(!recruit.mind)
		return FALSE
	//need to see their damn face
	if(!recruit.get_face_name(null))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_DEFILED_NOBLE)) // Their lux was tainted by evil matthios rite. They are utterly fucked.
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/grant_nobility/proc/grant_nobility(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(QDELETED(recruit) || QDELETED(recruiter))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_NOBLE))
		if(!(recruit.job in GLOB.foreign_positions))
			recruiter.say("I HEREBY STRIP YOU, [uppertext(recruit.name)], OF NOBILITY!!")
			REMOVE_TRAIT(recruit, TRAIT_NOBLE, TRAIT_GENERIC)
			REMOVE_TRAIT(recruit, TRAIT_NOBLE, TRAIT_VIRTUE)
			message_admins("NOBILITY REVOKED: [ADMIN_LOOKUPFLW(recruiter)] has revoked [recruit.real_name] ([recruit.ckey]) of nobility]")
			log_game("NOBILITY REVOKED: [recruiter.real_name] ([recruiter.ckey]) has revoked [recruit.real_name] ([recruit.ckey]) of nobility]")
			return FALSE
		else
			to_chat(recruiter, span_warning("Their nobility is not mine to strip!"))
			return FALSE
	recruiter.say("I HEREBY GRANT YOU, [uppertext(recruit.name)], NOBILITY!")
	ADD_TRAIT(recruit, TRAIT_NOBLE, TRAIT_GENERIC)
	message_admins("NOBILITY GRANTED: [ADMIN_LOOKUPFLW(recruiter)] has granted [recruit.real_name] ([recruit.ckey]) nobility]")
	log_game("NOBILITY GRANTED: [recruiter.real_name] ([recruiter.ckey]) has granted [recruit.real_name] ([recruit.ckey]) nobility]")
	return TRUE
