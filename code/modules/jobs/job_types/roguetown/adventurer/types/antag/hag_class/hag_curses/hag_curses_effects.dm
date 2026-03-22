/datum/status_effect/buff/hag_boon/creeping_moss/curse
	id = "choking_shroud"
	examine_text = "SUBJECTPRONOUN is being overtaken by a thick, parasitic moss! Perhaps it can be BURNED away!"

	heal_treshhold = 200
	alert_type = /atom/movable/screen/alert/status_effect/debuff/creeping_moss

/atom/movable/screen/alert/status_effect/debuff/creeping_moss
	name = "Choking Shroud"
	desc = "Moss is trying to creep over my face. It might be able to be BURNT off."
	icon_state = "debuff"

/datum/status_effect/buff/hag_boon/creeping_moss/curse/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner

	if(moss_layer >= 6 && H.stat != DEAD)
		H.adjustOxyLoss(10)
		if(prob(10))
			to_chat(H, span_userdanger("The moss is forcing its way into your throat! You can't breathe!"))

	if(H.on_fire && moss_layer > 0)
		if(prob(10))
			to_chat(H, span_danger("The flames sear away some of the parasite!"))
			trim_moss()
			return

	var/turf/T = get_turf(owner)
	if(!is_type_in_list(T, natural_turfs))
		return
	total_healed += (2 + (2 * moss_layer))

	if(total_healed >= heal_treshhold && moss_layer < 6)
		total_healed = 0
		grow_moss(H)
