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
