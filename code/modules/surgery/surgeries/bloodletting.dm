/datum/surgery/bloodletting
	name = "Force toxins out"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/cutvein,
		/datum/surgery_step/bloodlet,
	)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)
	target_mobtypes = list(/mob/living/carbon/human)


/datum/surgery_step/cutvein
	name = "Cut vein"
	implements = list(
		TOOL_SCALPEL = 75,
		TOOL_SHARP = 30,
	)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 5 SECONDS
	surgery_flags = SURGERY_CLAMPED
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_step/cutvein/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to cut [target]'s vein on [parse_zone(target_zone)]..."),
		span_notice("[user] begins to cut [target]'s vein on [parse_zone(target_zone)]."),
		span_notice("[user] begins to cut [target]'s vein on [parse_zone(target_zone)]."))
	return TRUE

/datum/surgery_step/cutvein/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("Blood dips out of the cut vein in [target]'s [parse_zone(target_zone)]."),
		span_notice("Blood drips out of the cut vein in [target]'s [parse_zone(target_zone)]."))
	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part)
		gotten_part.add_wound(/datum/wound/slash/vein)
	return TRUE

/datum/surgery_step/bloodlet
	name = "Force out bad blood"
	implements = list(
		TOOL_HAND = 80,
	)
	accept_hand = TRUE
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 6.4 SECONDS
	surgery_flags = SURGERY_CUTVEIN
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/organ1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/bloodlet/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to force the blood out of [target]'s vein in [parse_zone(target_zone)]..."),
		span_notice("[user] begins to force the blood out of [target]'s vein in [parse_zone(target_zone)]!"),
		span_notice("[user] begins to force the blood out of [target]'s vein in [parse_zone(target_zone)]!"))
	return TRUE

/datum/surgery_step/bloodlet/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I force blood out [target]'s vein in [parse_zone(target_zone)]."),
		span_notice("[user] forces blood out [target]'s vein in [parse_zone(target_zone)]!"),
		span_notice("[user] forces blood out [target]'s vein in [parse_zone(target_zone)]!"))
	target.adjustToxLoss (-25, 0)
	target.blood_volume -=50
	return TRUE
