
/obj/item/bodypart/proc/cavity_contents()
	. = list()
	if(!owner)
		return
	for(var/obj/item/organ/checked in owner.internal_organs)
		if(check_zone(checked.zone) != body_zone)
			continue
		if(!checked.medical_organ && !istype(checked, /obj/item/organ/bone))
			continue
		. += checked

/obj/item/bodypart/proc/on_operating_surface()
	if(!owner)
		return FALSE
	var/turf/patient_turf = get_turf(owner)
	return (locate(/obj/structure/bed) in patient_turf) || (locate(/obj/structure/table) in patient_turf)

/obj/item/bodypart/proc/cavity_is_open()
	var/flags = get_surgery_flags()
	if((flags & (SURGERY_INCISED|SURGERY_RETRACTED)) != (SURGERY_INCISED|SURGERY_RETRACTED))
		return FALSE
	if((body_zone == BODY_ZONE_CHEST || body_zone == BODY_ZONE_HEAD) && !(flags & SURGERY_BROKEN))
		return FALSE
	return TRUE

/obj/item/bodypart/proc/open_cavity(mob/user)
	if(!owner || !user)
		return FALSE
	if(!cavity_is_open())
		to_chat(user, span_warning("I must cut into [owner]'s [name] and hold it open before I can work inside."))
		return FALSE
	if(!length(cavity_contents()))
		to_chat(user, span_warning("There is nothing inside [owner]'s [name] to work on."))
		return FALSE
	ui_interact(user)
	return TRUE

/obj/item/bodypart/proc/close_cavity()
	SStgui.close_uis(src)

/obj/item/bodypart/ui_host(mob/user)
	return owner

/obj/item/bodypart/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/item/bodypart/ui_status(mob/user, datum/ui_state/state)
	if(!owner || !cavity_is_open())	//sealed up (or detached) -> the panel closes itself
		return UI_CLOSE
	return ..()

/obj/item/bodypart/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BodyCavity", "[owner ? "[owner]'s " : ""][name]")
		ui.open()

/obj/item/bodypart/ui_data(mob/user)
	var/list/data = list()
	data["zone_name"] = name
	data["on_surface"] = on_operating_surface()
	var/list/organs = list()
	for(var/obj/item/organ/checked as anything in cavity_contents())
		organs += list(cavity_organ_data(checked))
	data["organs"] = organs
	return data

/obj/item/bodypart/proc/cavity_organ_data(obj/item/organ/checked)
	var/list/entry = list()
	entry["ref"] = REF(checked)
	entry["name"] = checked.name
	if(istype(checked, /obj/item/organ/bone))
		var/obj/item/organ/bone/checked_bone = checked
		entry["is_bone"] = TRUE
		entry["fractured"] = checked_bone.is_fractured()
		switch(checked_bone.fracture)
			if(BONE_FRACTURE_MAJOR)
				entry["state"] = "shattered"
				entry["state_color"] = "bad"
			if(BONE_FRACTURE_MINOR)
				entry["state"] = "cracked"
				entry["state_color"] = "average"
			else
				entry["state"] = "whole"
				entry["state_color"] = "good"
	else
		entry["is_bone"] = FALSE
		entry["severe"] = (checked.crit_injury == ORGAN_INJURY_SEVERE)
		switch(checked.crit_injury)
			if(ORGAN_INJURY_DEAD)
				entry["state"] = "dead"
				entry["state_color"] = "bad"
			if(ORGAN_INJURY_SEVERE)
				entry["state"] = "gravely wounded"
				entry["state_color"] = "bad"
			if(ORGAN_INJURY_MINOR)
				entry["state"] = "wounded"
				entry["state_color"] = "average"
			else
				entry["state"] = "healthy"
				entry["state_color"] = "good"
	return entry

/obj/item/bodypart/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!owner)
		return TRUE
	var/mob/user = ui.user
	var/obj/item/organ/target = locate(params["ref"]) in owner.internal_organs
	if(!istype(target) || (check_zone(target.zone) != body_zone))
		return TRUE
	switch(action)
		if("repair")
			cavity_repair_organ(target, user)
			return TRUE
		if("extract")
			cavity_extract_organ(target, user)
			return TRUE
		if("setbone")
			cavity_set_bone(target, user)
			return TRUE

/obj/item/bodypart/proc/cavity_surgery_success(skill)
	switch(skill)
		if(SKILL_LEVEL_JOURNEYMAN)
			return 60
		if(SKILL_LEVEL_EXPERT)
			return 80
		if(SKILL_LEVEL_MASTER)
			return 92
	return 98

/obj/item/bodypart/proc/cavity_repair_organ(obj/item/organ/target, mob/user)
	if(istype(target, /obj/item/organ/bone) || !target.medical_organ)
		return
	var/obj/item/tool = user.get_active_held_item()
	if(tool?.tool_behaviour != TOOL_SUTURE)
		to_chat(user, span_warning("I need a suture in hand to stitch [owner]'s [target.name]."))
		return
	if(target.crit_injury != ORGAN_INJURY_SEVERE)
		to_chat(user, span_warning("[target.name] has no grave wound to stitch - minor hurts mend with rest."))
		return
	if(!on_operating_surface())
		to_chat(user, span_warning("I can't operate properly unless [owner] is laid on a bed or table."))
		return
	var/skill = user.get_skill_level(/datum/skill/misc/medicine)
	if(skill < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I'm not skilled enough to stitch an organ."))
		return
	user.visible_message(span_notice("[user] begins to stitch [owner]'s [target.name]."), span_notice("I begin to stitch the wounds in [owner]'s [target.name]..."))
	if(!do_after(user, 7 SECONDS, target = owner))
		return
	if(!cavity_is_open() || target.owner != owner || target.crit_injury != ORGAN_INJURY_SEVERE)
		return
	if(prob(cavity_surgery_success(skill)))
		target.heal_injury()
		to_chat(user, span_notice("I stitch the worst of the damage in [owner]'s [target.name]; rest will mend the rest."))
	else
		to_chat(user, span_warning("My hands slip - I fail to close the wound in [owner]'s [target.name]!"))
		owner.reagents?.add_reagent(/datum/reagent/infection/minor, rand(1, 4))
	SStgui.update_uis(src)

/obj/item/bodypart/proc/cavity_extract_organ(obj/item/organ/target, mob/user)
	var/obj/item/tool = user.get_active_held_item()
	if(tool?.tool_behaviour != TOOL_HEMOSTAT && tool?.tool_behaviour != TOOL_IMPROVISED_HEMOSTAT)
		to_chat(user, span_warning("I need a hemostat in hand to pull [owner]'s [target.name] free."))
		return
	if(!on_operating_surface())
		to_chat(user, span_warning("I can't operate properly unless [owner] is laid on a bed or table."))
		return
	var/is_bone = istype(target, /obj/item/organ/bone)
	user.visible_message(span_warning("[user] begins to work [owner]'s [target.name] loose."), span_notice("I begin to [is_bone ? "pry" : "extract"] [owner]'s [target.name]..."))
	if(!do_after(user, (is_bone ? 7 SECONDS : 6 SECONDS), target = owner))
		return
	if(!cavity_is_open() || target.owner != owner)
		return
	target.Remove(owner)
	target.forceMove(owner.drop_location())
	user.put_in_hands(target)
	to_chat(user, is_bone ? span_warning("I wrench [owner]'s [target.name] out - the limb is ruined without it.") : span_notice("I extract [owner]'s [target.name]."))
	log_combat(user, owner, "surgically extracted [target.name] (cavity) from")
	SStgui.update_uis(src)

/obj/item/bodypart/proc/cavity_set_bone(obj/item/organ/target, mob/user)
	var/obj/item/organ/bone/target_bone = target
	if(!istype(target_bone))
		return
	var/obj/item/tool = user.get_active_held_item()
	if(tool?.tool_behaviour != TOOL_BONESETTER)
		to_chat(user, span_warning("I need a bonesetter in hand to set [owner]'s [target_bone.name]."))
		return
	if(!target_bone.is_fractured())
		to_chat(user, span_warning("[target_bone.name] is whole - there's nothing to set."))
		return
	user.visible_message(span_notice("[user] begins to set [owner]'s [target_bone.name]."), span_notice("I begin to set [owner]'s [target_bone.name]..."))
	if(!do_after(user, 6 SECONDS, target = owner))
		return
	if(!cavity_is_open() || target_bone.owner != owner)
		return
	for(var/datum/wound/fracture/limb_fracture in wounds)
		limb_fracture.set_bone()
	target_bone.mend()
	to_chat(user, span_notice("I set [owner]'s [target_bone.name]."))
	SStgui.update_uis(src)


/datum/surgery_step/open_cavity
	name = "Look inside"
	accept_hand = TRUE
	implements = list(
		TOOL_RETRACTOR = 100,
		TOOL_IMPROVISED_RETRACTOR = 100,
	)
	time = 0
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED
	skill_min = SKILL_LEVEL_NONE
	possible_locs = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_PRECISE_SKULL,
		BODY_ZONE_CHEST,
		BODY_ZONE_PRECISE_R_EYE,
		BODY_ZONE_PRECISE_L_EYE,
		BODY_ZONE_PRECISE_MOUTH,
		BODY_ZONE_PRECISE_STOMACH,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
	)

/datum/surgery_step/open_cavity/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/BP = target.get_bodypart(check_zone(target_zone))
	BP?.open_cavity(user)
	return FALSE

/datum/surgery_step/sew_cavity
	name = "Sew shut"
	implements = list(
		TOOL_SUTURE = 100,
	)
	time = 3 SECONDS
	surgery_flags = SURGERY_INCISED
	skill_min = SKILL_LEVEL_NOVICE

/datum/surgery_step/sew_cavity/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to sew [target]'s [parse_zone(target_zone)] shut..."),
		span_notice("[user] begins to sew [target]'s [parse_zone(target_zone)] shut."),
		span_notice("[user] begins to sew [target]'s [parse_zone(target_zone)] shut."))
	return TRUE

/datum/surgery_step/sew_cavity/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		bodypart.close_cavity()	//shut the panel before we seal the patient up
		for(var/datum/wound/slash/incision/incision in bodypart.wounds)
			incision.sew_wound()
	display_results(user, target, span_notice("I sew [target]'s [parse_zone(target_zone)] shut."),
		span_notice("[user] sews [target]'s [parse_zone(target_zone)] shut."),
		span_notice("[user] sews [target]'s [parse_zone(target_zone)] shut."))
	return TRUE
