//The base component for magical items.
//Allows for item agnostic handling, and avoids needing to change the base item code
//Most of our logic should be contained in the actual effects

/datum/component/magic_item
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS					//We want to handle all magical effects with a single component per item
	var/list/magical_effects = list()							//All our magical effects. Or nonmagical. I'm not a cop
	var/enchanting_capacity = 2 								//How many enchantments can be on the item

/datum/component/magic_item/Initialize(var/datum/magic_item/magical_item_effect)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	..()
	magical_item_effect.do_literally_anything_thanks()
	add_enchantment(magical_item_effect)
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))


/datum/component/magic_item/proc/add_enchantment(var/datum/magic_item/magical_item_effect)
	if(islist(magical_item_effect))
		var/list/magical_item_effects = magical_item_effect
		for(var/datum/magic_item/effect in magical_item_effects)
			if(!istype(effect, /datum/magic_item))
				continue
			if(effect in magical_effects)
				continue
			add_single_enchantment(effect)
	else
		add_single_enchantment(magical_item_effect)

/datum/component/magic_item/proc/add_single_enchantment(var/datum/magic_item/magical_item_effect)
	if(magical_item_effect in magical_effects)
		return
	magical_effects.Add(magical_item_effect)
	var/obj/item/p = parent
	magical_item_effect.on_apply(p)

/datum/component/magic_item/proc/on_examine(atom/movable/source, mob/user, list/examine_list)
	for(var/datum/magic_item/effect in magical_effects)
		if(effect.description)
			examine_list += span_info(effect.description)

/datum/component/magic_item/InheritComponent(datum/component/C, i_am_original, var/datum/magic_item/magical_item_effect)
	add_enchantment(magical_item_effect)
	..()
