/datum/component/hag_boon_manifestation
	var/boon_type
	var/points

/datum/component/hag_boon_manifestation/Initialize(boon_type, points)
	if(!isobj(parent)) return COMPONENT_INCOMPATIBLE
	src.boon_type = boon_type
	src.points = points
	RegisterSignal(parent, COMSIG_OBJ_HANDED_OVER, PROC_REF(on_handed_over))

/datum/component/hag_boon_manifestation/proc/on_handed_over(datum/source, mob/living/receiver, mob/living/offerer)
	SIGNAL_HANDLER
	var/datum/component/hag_curio_tracker/HCT = offerer.GetComponent(/datum/component/hag_curio_tracker)
	if(!HCT) return

	// Verify the Hag actually still has the boon prepared
	if(!(HCT.user_can_receive_boon(boon_type, receiver.real_name)))
		to_chat(offerer, span_warning("[receiver] cannot contain this boon's power right now."))
		to_chat(receiver, span_warning("The item in your hand turns to harmless gray dust."))
		qdel(parent)
		return

	if(HCT.consume_prepared_boon(boon_type))
		HCT.grant_boon(receiver.real_name, boon_type, points)
		to_chat(offerer, span_notice("The boon takes hold in [receiver]'s soul."))
	else
		to_chat(offerer, span_warning("The boon loses its potency and fades into dust."))
		to_chat(receiver, span_warning("The item in your hand turns to harmless gray dust."))

	qdel(parent)

/obj/item/hag_blessing_item
	name = "boon"
	desc = "An offering of incredible strength."
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	icon_state = "boon"
	//item_flags = DROPDEL

/obj/item/hag_blessing_item/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(expire_boon)), 10 SECONDS)

/obj/item/hag_blessing_item/proc/expire_boon()
	src.visible_message(span_notice("The boon fizzles out into nothing, it wasn't accepted fast enough."))
	qdel(src)

/datum/component/hag_magical_item
	var/datum/hag_boon/boon_type

/datum/component/hag_magical_item/Initialize(boon_type)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	src.boon_type = boon_type
	RegisterSignal(parent, COMSIG_OBJ_HANDED_OVER, PROC_REF(on_handed_over))

/datum/component/hag_magical_item/proc/on_handed_over(datum/source, mob/living/receiver, mob/living/offerer)
	SIGNAL_HANDLER
	var/datum/component/hag_curio_tracker/HCT = offerer.GetComponent(/datum/component/hag_curio_tracker)
	if(!HCT) return

	if(HCT.user_can_receive_boon(boon_type, receiver.real_name))
		HCT.grant_boon(receiver.real_name, boon_type, boon_type.points)
		var/obj/item/O = parent
		var/target_id = initial(O.name)

		var/datum/component/hag_magical_item_affinity/Keychain = receiver.GetComponent(/datum/component/hag_magical_item_affinity)
		if(Keychain)
			Keychain.add_id(target_id)
		else
			receiver.AddComponent(/datum/component/hag_magical_item_affinity, target_id)

		to_chat(offerer, span_notice("You bind the [O.name] to [receiver.real_name]."))
		to_chat(receiver, span_boldnotice("The [O.name] hums with a dark, familiar energy."))

		// Component safe to delete.
		qdel(src)
	else
		to_chat(offerer, span_warning("The connection fails. [receiver.real_name] has too many boons or curses already."))
		to_chat(receiver, span_warning("Your body can't contain more nature magic right now."))

/datum/component/hag_magical_item_affinity
	var/list/authorized_ids = list()

/datum/component/hag_magical_item_affinity/Initialize(item_id)
	if(!iscarbon(parent)) return COMPONENT_INCOMPATIBLE
	add_id(item_id)

/datum/component/hag_magical_item_affinity/proc/add_id(item_id)
	authorized_ids |= item_id
	var/mob/living/L = parent
	if(!L.GetComponent(/datum/component/hag_artifact_repair))
		L.AddComponent(/datum/component/hag_artifact_repair)
