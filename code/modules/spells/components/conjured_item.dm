/* Component for adding a generic magical outline to a component, make it disappear if not held / worn
by Arcyne user after a duration
*/

#define CONJURED_ITEM_DROP_LIFETIME (5 MINUTES)

/datum/component/conjured_item
	var/outline_color = GLOW_COLOR_ARCANE
	var/noglow = FALSE
	var/dispelling = FALSE
	var/decay_timer

/datum/component/conjured_item/Initialize(outline_color_override, no_glow = FALSE, mob/caster, datum/conjure_source)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	noglow = no_glow
	if(outline_color_override)
		outline_color = outline_color_override

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	if(caster)
		RegisterSignal(caster, COMSIG_PARENT_QDELETING, PROC_REF(on_binding_destroyed))
	if(conjure_source)
		RegisterSignal(conjure_source, COMSIG_PARENT_QDELETING, PROC_REF(on_binding_destroyed))

	var/obj/item/I = parent
	if(!noglow)
		I.filters += filter(type = "drop_shadow", x=0, y=0, size=1, offset = 2, color = outline_color)
	I.smeltresult = null
	I.salvage_result = null
	I.fiber_salvage = FALSE
	I.craft_blocked = TRUE
	I.sellprice = 0
	I.static_price = TRUE

	update_decay_timer()

/datum/component/conjured_item/Destroy()
	if(decay_timer)
		deltimer(decay_timer)
		decay_timer = null
	return ..()

/datum/component/conjured_item/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += "This item crackles with faint arcyne energy. It seems to be conjured."

/datum/component/conjured_item/proc/on_moved(datum/source)
	SIGNAL_HANDLER
	update_decay_timer()

/datum/component/conjured_item/proc/update_decay_timer()
	if(dispelling)
		return
	var/obj/item/I = parent
	if(QDELETED(I))
		return
	if(ismob(I.loc) || isobj(I.loc))
		if(decay_timer)
			deltimer(decay_timer)
			decay_timer = null
		return
	if(isturf(I.loc) && !decay_timer)
		decay_timer = addtimer(CALLBACK(src, PROC_REF(dispel)), CONJURED_ITEM_DROP_LIFETIME, TIMER_STOPPABLE)

/// The spell/tome/caster that this conjured item is bound to has been destroyed - unravel the item.
/datum/component/conjured_item/proc/on_binding_destroyed(datum/source)
	SIGNAL_HANDLER
	dispel()

/datum/component/conjured_item/proc/dispel()
	if(dispelling)
		return
	var/obj/item/I = parent
	if(QDELETED(I))
		return
	dispelling = TRUE
	if(decay_timer)
		deltimer(decay_timer)
		decay_timer = null
	I.visible_message(span_warning("[I] shimmers and fades away!"))
	playsound(get_turf(I), 'sound/magic/magic_nulled.ogg', 50, TRUE)
	qdel(I)

#undef CONJURED_ITEM_DROP_LIFETIME
