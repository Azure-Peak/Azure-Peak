/datum/status_effect/bog_communion
	id = "bog_communion"
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/bog_communion

/datum/status_effect/bog_communion/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_ROOT_WALKER, TRAIT_MIRACLE)
	to_chat(owner, span_boldnotice("You feel the ancient roots of the bog entwining with your soul..."))
	return TRUE

/datum/status_effect/bog_communion/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_ROOT_WALKER, TRAIT_MIRACLE)
		to_chat(owner, span_warning("Your connection to the deep roots withers away."))
	return ..()

/atom/movable/screen/alert/status_effect/bog_communion
	name = "Bog Communion"
	desc = "The roots recognize you as one of their own. You may walk the deep paths."
	icon_state = "buff"

/obj/effect/proc_holder/spell/invoked/root_affinity
	name = "Root Affinity"
	desc = "Temporarily grant yourself or an ally communion with the heartroot trees commonly found in the bog, allowing them travel between them."
	invocations = list("The roots shall part to grant passage!")
	recharge_time = 15 MINUTES
	chargetime = 0.5 SECONDS
	clothes_req = FALSE
	sound = 'sound/magic/bless.ogg'
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/root_affinity/cast(list/targets, mob/living/user)
	var/mob/living/target = targets[1]
	if(!isliving(target))
		revert_cast()
		return FALSE
	// Technically an antag check but only druids get this... Mostly so hags can't get nerfed travel.
	if(HAS_TRAIT(target, TRAIT_ANCIENT_HAG))
		to_chat(user, span_warning("[target] is already too deeply entwined with the roots."))
		revert_cast()
		return FALSE
	target.apply_status_effect(/datum/status_effect/bog_communion)
	return TRUE
