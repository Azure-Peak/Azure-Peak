/datum/element/envenomed_blade
	element_flags = ELEMENT_DETACH

/datum/element/envenomed_blade/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_ITEM_ATTACK_EFFECT_SELF, PROC_REF(on_hit))

/datum/element/envenomed_blade/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, list(COMSIG_PARENT_EXAMINE, COMSIG_ITEM_ATTACK_EFFECT_SELF))

/datum/element/envenomed_blade/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_red("Its edge is laced with poison.")

/datum/element/envenomed_blade/proc/on_hit(obj/item/source, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/victim, selzone)
	SIGNAL_HANDLER
	if(!user || !isliving(victim) || HAS_TRAIT(victim, TRAIT_TOXIMMUNE))
		return
	var/bleeding = affecting ? affecting.get_bleed_rate() : victim.simple_bleeding
	if(bleeding <= 0)
		return
	victim.apply_status_effect(/datum/status_effect/debuff/envenomed)
	log_combat(user, victim, "envenomed", source)
