/datum/hag_boon/name
	name = "Name"
	desc = "Bestows a name you've been taken to another. Be sure to take theirs first! They'll inherit the name, masked name, voice color, and vocal descriptor of the person you took the name from initially."
	points = 20

// the checks for this boon mean L is guaranteed to be a human with a "nameless" name component
/datum/hag_boon/name/apply_boon_effect(mob/living/L)
	. = ..()
	var/mob/living/carbon/human/H = L
	if(!istype(H) || !granter) // should never happen
		return

	var/datum/component/hag_curio_tracker/HCT = granter.GetComponent(/datum/component/hag_curio_tracker)
	if(!HCT)
		return // again, should never happen

	var/name2give = tgui_input_list(granter, "Which name to give?", "A NAME IS BESTOWED", HCT.stored_names)
	if(!name2give)
		return

	var/datum/hag_identity/ID = HCT.stored_names[name2give]
	if(ID.donor == L.real_name) // this is THEIR name; giving it back is an act of charity and doesn't incur a point cost
		points = 0

	qdel(H.GetComponent(/datum/component/hag_name))
	H.AddComponent(/datum/component/hag_name, ID)
