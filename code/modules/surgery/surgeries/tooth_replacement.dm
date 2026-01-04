/datum/surgery/tooth_replacement
	name = "Tooth Replacement"
	possible_locs = list(BODY_ZONE_PRECISE_MOUTH)
	target_mobtypes = list(/mob/living/carbon/human)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/cauterize,
	)

/datum/surgery_step/tooth_replacement
	name = "Tooth Replacement"

	possible_locs = list(BODY_ZONE_PRECISE_MOUTH)
	implements = list(/obj/item/gold_tooth)
	possible_locs = list(
		BODY_ZONE_PRECISE_MOUTH
	)
	lying_required = TRUE
	self_operable = FALSE
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_EXPERT
	surgery_flags = NONE

/datum/surgery_step/tooth_replacement/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(!.)
		return
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/T = target
	var/obj/item/bodypart/head/head = T.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		to_chat(user, span_warning("They don't have a head!"))
		return
	if(head.teeth >= initial(head.teeth))
		to_chat(user, span_notice("They aren't missing any teeth!"))
		return FALSE

/datum/surgery_step/tooth_replacement/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/T = target
	display_results(user, target, span_notice("You insert a gold tooth into [T]'s delicate gums."))
	var/obj/item/bodypart/head/head = T.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		head.teeth++
		head.gold_teeth++
	qdel(tool)
	return TRUE
