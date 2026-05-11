/obj/effect/proc_holder/spell/self/convertrole
	name = "Recruit Beggar"
	desc = "Recruit someone to your cause."
	overlay_state = "recruit_bog"
	antimagic_allowed = TRUE
	recharge_time = 100
	/// Role given if recruitment is accepted
	var/new_role = "Beggar"
	/// Faction shown to the user in the recruitment prompt
	var/recruitment_faction = "Beggars"
	/// Message the recruiter gives
	var/recruitment_message = "Serve the beggars, %RECRUIT!"
	/// Range to search for potential recruits
	var/recruitment_range = 3
	/// Say message when the recruit accepts
	var/accept_message = "I will serve!"
	/// Say message when the recruit refuses
	var/refuse_message = "I refuse."
	ignore_los = 1 // this needs to ignore normal "range", it looks like
	range = 3

/obj/effect/proc_holder/spell/self/convertrole/cast(list/targets,mob/user = usr)
	. = ..()
	var/list/recruitment = list()
	for(var/mob/living/carbon/human/recruit in (get_hearers_in_view(recruitment_range, user) - user))
		//not allowed
		if(!can_convert(recruit))
			continue
		recruitment[recruit.name] = recruit
	if(!length(recruitment))
		to_chat(user, span_warning("There are no potential recruits in range."))
		return
	var/inputty = input(user, "Select a potential recruit!", "[name]") as anything in recruitment
	if(inputty)
		var/mob/living/carbon/human/recruit = recruitment[inputty]
		if(!QDELETED(recruit) && (recruit in get_hearers_in_view(recruitment_range, user)))
			INVOKE_ASYNC(src, PROC_REF(convert), recruit, user)
		else
			to_chat(user, span_warning("Recruitment failed!"))
	else
		to_chat(user, span_warning("Recruitment cancelled."))

/obj/effect/proc_holder/spell/self/convertrole/proc/can_convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	//wtf
	if(QDELETED(recruit))
		return FALSE
	//need a mind
	if(!recruit.mind)
		return FALSE
	//only migrants and peasants
	if(!(recruit.job in GLOB.peasant_positions) && \
		!(recruit.job in GLOB.burgher_positions) && \
		!(recruit.job in GLOB.wanderer_positions) && \
		//unique case to re-allow exclusively deserters to recruit fellow wretches into the brotherhood
		!(recruiter.job == "Wretch" && recruit.job == "Wretch"))
		return FALSE
	if(recruit.cmode) //We probably don't want to accidentally flashbang this mid-fight.
		return FALSE
	//need to see their damn face
	if(!recruit.get_face_name(null))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/proc/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(QDELETED(recruit) || QDELETED(recruiter))
		return FALSE
	recruiter.say(replacetext(recruitment_message, "%RECRUIT", "[recruit]"), forced = "[name]")
	var/prompt = alert(recruit, "Do you wish to become a [new_role]?", "[recruitment_faction] Recruitment", "Yes", "No")
	if(QDELETED(recruit) || QDELETED(recruiter) || !(recruiter in get_hearers_in_view(recruitment_range, recruit)))
		return FALSE
	if(prompt != "Yes") //If they deny, we forcesay here.
		if(refuse_message)
			recruit.say(refuse_message, forced = "[name]")
		return FALSE
	if(accept_message) //If they accept, we forcesay here.
		recruit.say(accept_message, forced = "[name]")
	if(new_role) //We assign our role here.
		recruit.job = new_role
		SEND_SIGNAL(SSdcs, COMSIG_GLOB_ROLE_CONVERTED, recruiter, recruit, new_role)
		message_admins("ROLE RECRUITMENT: [recruiter.real_name] ([recruiter.ckey]) has converted [recruit.real_name] ([recruit.ckey]) to [new_role]")
		log_game("ROLE RECRUITMENT: [recruiter.real_name] ([recruiter.ckey]) has converted [recruit.real_name] ([recruit.ckey]) to [new_role]")
	return TRUE

///////////////////////////////////////
////DUKE RECRUITMENT - TOWN FACTION////
///////////////////////////////////////

/obj/effect/proc_holder/spell/self/convertrole/guard
	name = "Recruit Guardsmen"
	new_role = "Watchman"
	overlay_state = "recruit_guard"
	recruitment_faction = "Watchman"
	recruitment_message = "Serve the town guard, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/guard/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	recruit.verbs |= /mob/proc/haltyell

/obj/effect/proc_holder/spell/self/convertrole/warden
	name = "Recruit Warden"
	new_role = "Warden"
	recruitment_faction = "Wardens"
	recruitment_message = "Serve the Wardens, %RECRUIT!"
	accept_message = "FOR THE GROVE!"
	refuse_message = "I refuse."

//Consort/Duke has this
/obj/effect/proc_holder/spell/self/convertrole/servant
	name = "Recruit Servant"
	new_role = "Servant"
	overlay_state = "recruit_servant"
	recruitment_faction = "Servants"
	recruitment_message = "Serve the crown, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."
	recharge_time = 100

//////////////////////////////////////////////////////
////HEARTFELT LORD RECRUITMENT - HEARTFELT FACTION////
//////////////////////////////////////////////////////

// Spells + Orders (Orders are ONLY For HFT Lord job and the Hand Marshal Subclass)

/obj/effect/proc_holder/spell/self/convertrole/heartfelt
	name = "Recruit Retinue"
	new_role = "Heartfelt Retinue"
	overlay_state = "recruit_brother"
	recruitment_faction = "Heartfelt"
	recruitment_message = "Join in the service of Heartfelt, %RECRUIT!"
	accept_message = "For Heartfelt!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/heartfelt/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(HAS_TRAIT(recruit, TRAIT_HEARTFELT))
		to_chat(recruiter, span_warning("They're already part of our cause!"))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_GUARDSMAN))
		to_chat(recruiter, span_warning("They're already part of the Peak's guard! They can't join our cause!"))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_INQUISITION))
		to_chat(recruiter, span_warning("Their loyalty is to Psydon alone! They can't join our cause!"))
		return FALSE
	//If you're reading this, please refactor this once we have TRAIT_CLERGY thanks
	if(HAS_TRAIT(recruit, TRAIT_CLERGY))
		to_chat(recruiter, span_warning("Clergy cannot join our cause! Their loyalty is to the Ten!"))
		return FALSE
	..()

//////////////////////////////////////
////ZIZO. ZIZO. ZIZO. ZIZO. ZIZO.////
/// DARK KNIGHT SQUIRE + KNIGHT  ////
/////////////////////////////////////
/obj/effect/proc_holder/spell/self/convertrole/zizosquire
	name = "Recruit Squire"
	new_role = "Retainer"
	overlay_state = "recruit_guard"
	recruitment_faction = "Retainers"
	recruitment_message = "Join my service as a retainer, %RECRUIT!"
	accept_message = "I pledge my service to you!"
	refuse_message = "I must decline your offer."

/obj/effect/proc_holder/spell/self/convertrole/zizosquire/can_convert(mob/living/carbon/human/recruit)
	if(QDELETED(recruit))
		return FALSE
	if(!(locate(/datum/antagonist/zizo_knight/squire) in recruit?.mind?.antag_datums))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/zizosquire/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(QDELETED(recruit) || QDELETED(recruiter))
		return FALSE

	var/datum/antagonist/zizo_knight/zk_antag = locate(/datum/antagonist/zizo_knight) in recruiter.mind?.antag_datums
	var/datum/antagonist/zizo_knight/squire/zs_antag = locate(/datum/antagonist/zizo_knight/squire) in recruit.mind?.antag_datums

	var/datum/objective/dark_itinerant/zizotrain = new /datum/objective/dark_itinerant(null, recruiter.mind)
	var/datum/objective/dark_itinerant/zizoserve = new /datum/objective/dark_itinerant/squire(null, recruit.mind)

	zizotrain.target = recruit.mind
	zizotrain.explanation_text = "Train your squire [recruit.real_name] in the field. Show them the ropes. Ensure they survive."
	zk_antag.objectives += zizotrain
	zizoserve.target = recruiter.mind
	zizoserve.explanation_text =  "Serve faithfully to your knight [recruiter.real_name], heed their commands and help them."
	zs_antag.objectives += zizoserve
	recruit.mind.announce_objectives()
	recruiter.mind.announce_objectives()

	. = ..()
	if(!.)
		return FALSE

	qdel(src)

/datum/objective/dark_itinerant
	name = "Train your squire"
	explanation_text = "Train your squire in the field. Show them the ropes. Ensure they survive."
	triumph_count = 5

/datum/objective/dark_itinerant/check_completion()
	return !target || considered_alive(target, enforce_human = TRUE)

/datum/objective/dark_itinerant/squire
	name = "Serve your Knight"
	explanation_text = "Serve faithfully to your knight, heed their commands and help them."
	triumph_count = 5


////////////////////////////////////
////FOR THE BROTHERHOOD (Wretch)////
////////////////////////////////////
/obj/effect/proc_holder/spell/self/convertrole/brotherhood
	name = "Recruit Brotherhood Militia"
	new_role = "Brother"
	overlay_state = "recruit_brotherhood"
	recruitment_faction = "Brother"
	recruitment_message = "We're in this together now, %RECRUIT!"
	accept_message = "For the Brotherhood!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/brotherhood/cast(list/targets,mob/user = usr)
	. = ..()
	var/list/recruitment = list()
	for(var/mob/living/carbon/human/recruit in (get_hearers_in_view(recruitment_range, user) - user))
		//not allowed
		if(!can_convert(recruit))
			continue
		recruitment[recruit.name] = recruit
	if(!length(recruitment))
		to_chat(user, span_warning("There are no potential recruits in range."))
		return
	var/inputty = input(user, "Select a potential recruit!", "[name]") as anything in recruitment
	if(inputty)
		var/mob/living/carbon/human/recruit = recruitment[inputty]
		if(!QDELETED(recruit) && (recruit in get_hearers_in_view(recruitment_range, user)))
			INVOKE_ASYNC(src, PROC_REF(convert), recruit, user)
		else
			to_chat(user, span_warning("Recruitment failed!"))
	else
		to_chat(user, span_warning("Recruitment cancelled."))


/obj/effect/proc_holder/spell/self/convertrole/brother
	name = "Recruit Brother"
	new_role = "Brother"
	overlay_state = "recruit_brother"
	recruitment_faction = "Brother"
	recruitment_message = "We're in this together now, %RECRUIT!"
	accept_message = "All for one and one for all!"
	refuse_message = "I refuse."
