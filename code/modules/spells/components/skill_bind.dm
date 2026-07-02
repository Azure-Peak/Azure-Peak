/datum/component/skill_bind
	var/swapped_skill
	var/original_skill
	var/stored = FALSE

/datum/component/skill_bind/Initialize(skill)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	if(!skill)
		return COMPONENT_INCOMPATIBLE
	swapped_skill = skill
	var/obj/item/I = parent
	original_skill = I.associated_skill
	stored = TRUE
	I.associated_skill = swapped_skill
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/skill_bind/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += "An arcyne bond guides this weapon; it answers to a conjurer's training."

/datum/component/skill_bind/Destroy()
	var/obj/item/I = parent
	if(istype(I) && stored && I.associated_skill == swapped_skill)
		I.associated_skill = original_skill
	return ..()
