#define CONDUIT_FILTER "arcyne_conduit"

/datum/component/arcyne_conduit
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/outline_color = "#4a90d9"
	var/gain_cooldown = 2 SECONDS // 2 seconds between melee momentum gains
	var/last_melee_gain = 0
	var/datum/weakref/owner_ref

/datum/component/arcyne_conduit/Initialize(outline_color_override, mob/living/owner)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	if(outline_color_override)
		outline_color = outline_color_override
	if(owner)
		owner_ref = WEAKREF(owner)
		RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_owner_death))
	var/obj/item/I = parent
	I.add_filter(CONDUIT_FILTER, 2, list("type" = "outline", "color" = outline_color, "alpha" = 200, "size" = 1))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(on_attack_success))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/arcyne_conduit/UnregisterFromParent()
	var/obj/item/I = parent
	if(istype(I))
		I.remove_filter(CONDUIT_FILTER)
	UnregisterSignal(parent, list(COMSIG_ITEM_ATTACK, COMSIG_PARENT_EXAMINE))
	var/mob/living/owner = owner_ref?.resolve()
	if(owner)
		UnregisterSignal(owner, COMSIG_LIVING_DEATH)

/datum/component/arcyne_conduit/proc/on_owner_death()
	SIGNAL_HANDLER
	var/mob/living/owner = owner_ref?.resolve()
	if(owner)
		var/datum/status_effect/buff/arcyne_momentum/M = owner.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(M)
			M.bound_weapon = null
	qdel(src)

/datum/component/arcyne_conduit/proc/on_attack_success(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(!isliving(user) || !isliving(target))
		return
	if(target == user)
		return
	if(target.stat == DEAD)
		return
	if(world.time < last_melee_gain + gain_cooldown)
		return
	var/datum/status_effect/buff/arcyne_momentum/M = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M)
		M = user.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M)
		M.add_stacks(1)
		last_melee_gain = world.time

/datum/component/arcyne_conduit/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice("This weapon pulses with faint arcyne energy. It is bound as an arcyne conduit, to be used by a skilled spellblade.")

#undef CONDUIT_FILTER
