/datum/component/peaceflower_tracker
	var/obj/item/clothing/head/peaceflower/flower

/datum/component/peaceflower_tracker/Initialize(obj/item/clothing/head/peaceflower/flower_source)
	if(!isliving(parent) || !istype(flower_source))
		return COMPONENT_INCOMPATIBLE

	flower = flower_source
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_wearer_damaged))
	RegisterSignal(flower, COMSIG_PARENT_QDELETING, PROC_REF(on_flower_deleted))

/datum/component/peaceflower_tracker/proc/on_wearer_damaged(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(!flower || damage <= 0)
		return

	flower.take_damage(damage, damagetype, "none", 0)
	if(flower.obj_broken)
		qdel(flower)
		return

	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		if(prob(50))
			to_chat(H, span_warning("The violence of the world withers the [flower.name]!"))

/datum/component/peaceflower_tracker/proc/on_flower_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/peaceflower_tracker/Destroy()
	// Nulling it here to avoid hard deletes.
	var/mob/living/carbon/C = parent
	REMOVE_TRAIT(C, TRAIT_PACIFISM, "peaceflower_[REF(flower)]")
	flower = null
	return ..()
