/obj/structure/roguemachine/ritual_rune
	name = "abyssal focal rune"
	desc = "A dark, engraved sigil etched into the floor. It hums with faint oceanic energy when near a dream pool."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssor_pool"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	/// The specific dream pool this rune has permanently bonded with
	var/obj/structure/roguemachine/dream_pool/linked_pool

/obj/structure/roguemachine/ritual_rune/proc/attempt_pool_link()
	if(linked_pool)
		return TRUE
	var/obj/structure/roguemachine/dream_pool/found_pool = locate() in range(5, src)
	if(found_pool)
		linked_pool = found_pool
		return TRUE
	return FALSE

/obj/structure/roguemachine/ritual_rune/attack_hand(mob/user, params)
	MiddleClick(user, params)

/obj/structure/roguemachine/ritual_rune/MiddleClick(mob/user, params)
	if(!ishuman(user) || user.stat == DEAD || user.stat == UNCONSCIOUS)
		return ..()
	if(!linked_pool)
		if(attempt_pool_link())
			to_chat(user, span_purple("The rune flares to life, establishing a permanent link with a nearby dream pool!"))
		else
			to_chat(user, span_warning("The rune glows faintly but fails to locate a dream pool within 7 tiles to anchor its power."))
			return TRUE
	if(!user.Adjacent(src))
		to_chat(user, span_warning("You are too far away from the focal rune to channel through it."))
		return TRUE
	linked_pool.handle_ritual_start(user)
	return TRUE

/obj/structure/roguemachine/ritual_rune/examine(mob/user)
	. = ..()
	if(linked_pool)
		. += "\n<span class='purple'>It is attuned to a nearby dream pool.</span>"
	else
		. += "\n<span class='warning'>It lies completely dormant. It needs to be activated near a dream pool to get attuned.</span>"

/obj/structure/roguemachine/ritual_rune/Destroy()
	linked_pool = null
	return ..()
