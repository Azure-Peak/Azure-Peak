/datum/element/tipped_item
	element_flags = ELEMENT_DETACH

	//Reagent blacklist. Killer's ice should probably be here too TBH.
	var/list/blacklisted_reagents = list(
		/datum/reagent/sleep_powder
	)

/datum/element/tipped_item/Attach(atom/movable/target, amount)
	. = ..()
	if(!ismovableatom(target))
		return ELEMENT_INCOMPATIBLE
	if(!target.reagents)
		target.create_reagents(1)
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_ITEM_PRE_ATTACK, PROC_REF(check_dip))
	RegisterSignal(target, COMSIG_ITEM_ATTACK_EFFECT_SELF, PROC_REF(try_inject))

/datum/element/tipped_item/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, list(COMSIG_PARENT_EXAMINE, COMSIG_ITEM_PRE_ATTACK, COMSIG_ITEM_ATTACK_EFFECT_SELF))

/datum/element/tipped_item/proc/check_dip(obj/item/dipper, obj/item/reagent_containers/attacked_container, mob/living/attacker, params)
	SIGNAL_HANDLER

	if(!istype(attacked_container))
		return
	if(!(attacked_container.reagents.flags & DRAINABLE))
		return
	if(dipper.reagents.total_volume == dipper.reagents.maximum_volume)
		return

	INVOKE_ASYNC(src, PROC_REF(start_dipping), dipper, attacked_container, attacker)


/datum/element/tipped_item/proc/start_dipping(obj/item/dipper, obj/item/reagent_containers/attacked_container, mob/living/attacker, params)
	var/reagentlog = attacked_container.reagents
	attacker.visible_message(span_danger("[attacker] is dipping \the [dipper] in [attacked_container]!"), "You dip \the [dipper] in \the [attacked_container]!", vision_distance = 2)
	if(!do_after(attacker, 2 SECONDS, target = attacked_container))
		return
	for(var/datum/reagent/R as anything in attacked_container.reagents.reagent_list)
		if(is_type_in_list(R, blacklisted_reagents))
			to_chat(attacker, span_warning("[R.name] is too caustic to apply to \the [dipper] safely!"))
			return
	attacked_container.reagents.trans_to(dipper, 1, transfered_by = attacker)
	attacker.visible_message(span_danger("[attacker] dips \the [dipper] in \the [attacked_container]!"), "You dip \the [dipper] in \the [attacked_container]!", vision_distance = 2)
	log_combat(attacker, dipper, "dipped", addition="with [reagentlog]")

/datum/element/tipped_item/proc/try_inject(obj/item/source, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/victim, selzone)
	SIGNAL_HANDLER
	if(!istype(victim))
		return
	var/reagentlog2 = source.reagents
	log_combat(user, victim, "poisoned", addition="with [reagentlog2]")
	source.reagents.trans_to(victim, 1, transfered_by = user)

/datum/element/tipped_item/proc/on_examine(atom/movable/source, mob/user, list/examine_list)
	if(source.reagents.total_volume)
		var/reagent_color = mix_color_from_reagents(source.reagents.reagent_list)
		examine_list += span_red("Has been dipped in <font color=[reagent_color]>something</font>!")
