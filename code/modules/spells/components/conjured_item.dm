/* Component for adding a generic magical outline to a component, make it disappear if not held / worn
by Arcyne user after a duration
*/

/datum/component/conjured_item
	var/outline_color = GLOW_COLOR_ARCANE

/datum/component/conjured_item/Initialize(outline_color_override)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	if(outline_color_override)
		outline_color = outline_color_override

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

	var/obj/item/I = parent
	I.filters += filter(type = "drop_shadow", x=0, y=0, size=1, offset = 2, color = outline_color)
	I.smeltresult = null
	I.salvage_result = null
	I.fiber_salvage = FALSE
	I.craft_blocked = TRUE

/datum/component/conjured_item/proc/on_examine(datum/source, mob/user, list/examine_list)
	examine_list += "This item crackles with faint arcyne energy. It seems to be conjured."
