/obj/effect/proc_holder/spell/targeted/shapeshift/dendormole
	name = "Borrowed Power"
	desc = "Greater power bestowed upon you, use it to shape into Dendor's special beest."
	invocations = list("Blood shall feed the flowers!")
	invocation_type = "shout"
	overlay_state = "tamebeast"
	human_req = FALSE
	range = -1
	include_user = TRUE
	recharge_time = 120 SECONDS // cause too little is cheaty, too much is pain
	cooldown_min = 50
	action_icon_state = "shapeshift"
	associated_skill = /datum/skill/magic/druidic
	chargetime = 5 SECONDS
	devotion_cost = 200

/obj/effect/proc_holder/spell/targeted/shapeshift/dendormole/cast(list/targets, mob/user = usr)
	// Use wildshape transformation system instead of shapeshift
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return
	
	// If already in dendormole form, revert back to human
	if(istype(H, /mob/living/carbon/human/species/wildshape/dendormole))
		H.wildshape_untransform()
		return TRUE
	
	// Otherwise transform into dendormole
	H.wildshape_transformation(/mob/living/carbon/human/species/wildshape/dendormole)
	return TRUE

/obj/effect/proc_holder/spell/targeted/shapeshift/mireboi
	name = "Crawler Form"
	desc = "Rare power bestowed by Druids from the manic depths of Dendor's domain, used to take the form of an agile arachnoid critter."
	invocations = list("Spin and Skitter!")
	invocation_type = "shout"
	overlay_state = "tamebeast"
	human_req = FALSE
	range = -1
	include_user = TRUE
	recharge_time = 60 SECONDS
	cooldown_min = 60
	action_icon_state = "shapeshift"
	associated_skill = /datum/skill/magic/holy
	chargetime = 10 SECONDS
	devotion_cost = 100

/obj/effect/proc_holder/spell/targeted/shapeshift/mireboi/cast(list/targets, mob/user = usr)
	// Use wildshape transformation system instead of shapeshift
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return
	
	// If already in mirecrawler form, revert back to human
	if(istype(H, /mob/living/carbon/human/species/wildshape/mirecrawler))
		H.wildshape_untransform()
		return TRUE
	
	// Otherwise transform into mirecrawler
	H.wildshape_transformation(/mob/living/carbon/human/species/wildshape/mirecrawler)
	return TRUE
