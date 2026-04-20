/datum/component/hideous_face
	var/datum/callback/seen_callback


/datum/component/hideous_face/Initialize(datum/callback/_seen_callback)
	. = ..()
	if(!_seen_callback)
		return COMPONENT_INCOMPATIBLE
	seen_callback = _seen_callback


/datum/component/hideous_face/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(check_life))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/hideous_face/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(COMSIG_PARENT_EXAMINE, COMSIG_HUMAN_LIFE))

/datum/component/hideous_face/proc/on_examine(mob/source, mob/user, list/examine_list)
	var/mob/living/carbon/human/H = parent
	if(user == H)
		return
	if ((H.wear_mask?.flags_inv & HIDEFACE) && (H.head?.flags_inv & HIDEFACE))
		return
	examine_list += span_warning("[H]'s face is horrifying!")
	if(!iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user
	if(!HAS_TRAIT(carbon_user, TRAIT_EORAN_CALM) && !HAS_TRAIT(carbon_user, TRAIT_EORAN_SERENE))
		to_chat(carbon_user, span_userdanger("By [carbon_user.patron?.name]! They are disgusting!!!"))
		carbon_user.stress_freakout()

/datum/component/hideous_face/proc/check_life()
	var/mob/living/carbon/human/H = parent
	if ((H.wear_mask?.flags_inv & HIDEFACE) && (H.head?.flags_inv & HIDEFACE))
		return
	if(!H.CheckEyewitness(H, H, 7, FALSE))
		return
	seen_callback?.Invoke(H)
