/obj/structure/roguemachine/dream_pool
	name = "dream pool"
	desc = ""
	icon = 'icons/obj/structures/abyssor_pool.dmi'
	icon_state = "whirl"
	resistance_flags = INDESTRUCTIBLE
	pixel_x = -32
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	var/gate_closed = TRUE
	/// Operational lockout flag to prevent spam-clicking the animations
	var/animating = FALSE

/obj/structure/roguemachine/dream_pool/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/structure/roguemachine/dream_pool/examine(mob/user)
	. = ..()
	if(gate_closed)
		. += "\n<span class='notice'>Incredibly heavy, rusty doors obscure the contents of this elaborate metallic indentation. It looks very old.</span>"
	else
		. += "\n<span class='purple'>The gate doors have retracted. A swirling vortex bombards you with imagery of a strange realm. Just looking into it makes you dizzy, best not to stare... Especially as something gazes back from beneath the surface.</span>"

/obj/structure/roguemachine/dream_pool/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(animating)
		to_chat(user, span_warning("The gate mechanism is currently operating!"))
		return

	if(gate_closed)
		open_gate(user)
	else
		close_gate(user)

/obj/structure/roguemachine/dream_pool/proc/open_gate(mob/user)
	animating = TRUE
	visible_message(span_notice("[src]'s heavy frame groans as the portal lock turns."))
	update_appearance()
	sleep(50) 
	gate_closed = FALSE
	animating = FALSE
	visible_message(span_purple("With a heavy hiss, the dream pool's gate slides fully open!"))
	update_appearance()

/obj/structure/roguemachine/dream_pool/proc/close_gate(mob/user)
	animating = TRUE
	visible_message(span_notice("The frame clangs as the pool doors begin sliding back into place."))
	gate_closed = TRUE 
	update_appearance()
	
	// Let the closing animation run out
	sleep(12)
	
	animating = FALSE
	visible_message(span_notice("[src]'s iris seal locks tightly into place."))
	update_appearance()
