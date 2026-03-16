/obj/effect/proc_holder/spell/invoked/spiritual_siphon
	name = "Spiritual Siphon"
	desc = "Absorbs mosses and select components into your spirit, or manifests up to five stored items onto the ground."
	invocation_type = "whisper"
	invocations = list("Bloom inside.")
	recharge_time = 5 SECONDS
	range = 1

/obj/effect/proc_holder/spell/invoked/spiritual_siphon/cast(list/targets, mob/living/user)
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H)
		to_chat(user, span_warning("Your soul lacks the hollow spaces required to store these blossoms."))
		return FALSE

	var/atom/target = targets[1]
	var/turf/T = get_turf(target)

	// Prioritize absorption if there are items on the floor
	var/absorbed_any = FALSE
	for(var/obj/item/I in T)
		if(H.absorb_item(I))
			absorbed_any = TRUE

	if(absorbed_any)
		to_chat(user, span_notice("The mosses dissolve into your shadow."))
		playsound(T, 'sound/magic/magnet.ogg', 50, TRUE)
		return TRUE

	// If nothing was absorbed, try to dump
	if(H.dump_materials(T))
		to_chat(user, span_notice("You manifest a handful of stored components."))
		playsound(T, 'sound/magic/slimesquish.ogg', 50, TRUE)
		return TRUE
	else
		to_chat(user, span_warning("You have nothing stored to manifest."))
		return FALSE

/obj/effect/proc_holder/spell/invoked/spiritual_siphon/get_spell_statistics(mob/living/user)
	. = ..() 

	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H || !length(H.stored_materials))
		. += span_info("Spiritual Veil: Empty")
		return

	. += "<br><span class='notice'><b>Spiritual Veil Contents:</b></span>"
	for(var/path in H.stored_materials)
		var/count = H.stored_materials[path]
		if(count > 0)
			var/name = initial(path:name)
			// Show usage/capacity: e.g., "Sorrow Moss: 4/10"
			var/limit = H.material_limits[path] || "?"
			. += span_info("- [name]: [count]/[limit]")
