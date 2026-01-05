/datum/collective_message
	/// Unique ID for this collective
	var/collective_id = ""
	/// Set of all mobs involved in this collective
	var/list/involved_mobs = list()
	/// Unique span class for filtering
	var/collective_span_class = ""
	/// Display name for the chat tab
	var/collective_display_name = ""
	/// All sessions that belong to this collective
	var/list/sessions = list()
	///is our collective set to subtle mode
	var/subtle_mode = TRUE


/datum/collective_message/New(initial_session)
	var/datum/sex_session/session = initial_session
	collective_id = "collective_[GLOB.collective_counter++]"
	collective_span_class = "sex_collective_[collective_id]"

	// Add initial participants
	involved_mobs |= session.user
	involved_mobs |= session.target
	sessions += session

	update_display_name()
	update_subtle()

/datum/collective_message/proc/update_display_name()
	var/list/names = list()
	for(var/mob/living/carbon/human/person in involved_mobs)
		var/display_name = person.get_face_name() || person.name
		names += display_name

	collective_display_name = jointext(names, " & ")

/datum/collective_message/proc/can_merge_session(datum/sex_session/new_session)
	// Check if this session involves any of our current participants
	return (new_session.user in involved_mobs) || (new_session.target in involved_mobs)

/datum/collective_message/proc/toggle_subtle()
	subtle_mode = !subtle_mode

/datum/collective_message/proc/merge_session(datum/sex_session/new_session)
	// Add new participants if they're not already involved
	if(!(new_session.user in involved_mobs))
		involved_mobs |= new_session.user
	if(!(new_session.target in involved_mobs))
		involved_mobs |= new_session.target

	sessions += new_session
	new_session.collective = src

	update_subtle()

/datum/collective_message/proc/update_subtle()
	if(subtle_mode)
		return

// /datum/collective_message/proc/register_collective_tab()
// 	for(var/mob/living/carbon/human/person in involved_mobs)
// 		if(person?.client?.chatOutput)
// 			person.client.chatOutput.addCollectiveTab(collective_span_class, collective_display_name)

// /datum/collective_message/proc/update_collective_tab()
// 	for(var/mob/living/carbon/human/person in involved_mobs)
// 		if(person?.client?.chatOutput)
// 			person.client.chatOutput.updateCollectiveTab(collective_span_class, collective_display_name)

// /datum/collective_message/proc/unregister_collective_tab()
// 	for(var/mob/living/carbon/human/person in involved_mobs)
// 		if(person?.client?.chatOutput)
// 			person.client.chatOutput.removeCollectiveTab(collective_span_class)

// We don't have goon chat
// /datum/chatOutput/proc/addCollectiveTab(collective_id, display_name)
// 	var/list/params = list(collective_id, display_name)
// 	src.owner << output(list2params(params), "browseroutput:addCollectiveTab")

// /datum/chatOutput/proc/updateCollectiveTab(collective_id, display_name)
// 	var/list/params = list(collective_id, display_name)
// 	src.owner << output(list2params(params), "browseroutput:updateCollectiveTab")

// /datum/chatOutput/proc/removeCollectiveTab(collective_id)
// 	var/list/params = list(collective_id)
// 	owner << output(list2params(params), "browseroutput:removeCollectiveTab")
