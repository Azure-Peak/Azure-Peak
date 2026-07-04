
/obj/structure/roguetent
	name = "tent door"
	desc = "A door made of sturdy fabric stretched over wooden frames."
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "tent_door1"
	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	max_integrity = 100
	var/base_state = "tent_door"
	blade_dulling = DULLING_BASHCHOP
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	destroy_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'

/obj/structure/roguetent/Initialize()
	update_icon()
	..()

/obj/structure/roguetent/update_icon()
	if(density)
		icon_state = "[base_state][pick(1,2)]"
	else
		icon_state = "[base_state]0"

/obj/structure/roguetent/proc/open_up(mob/user)
	visible_message(span_info("[user] opens [src]."))
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = FALSE
	opacity = FALSE
	update_icon()
	alert_ai_visibility_change(src)

/obj/structure/roguetent/proc/close_up(mob/user)
	visible_message(span_info("[user] closes [src]."))
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = TRUE
	opacity = TRUE
	update_icon()

/obj/structure/roguetent/attack_paw(mob/living/user)
	attack_hand(user)

/obj/structure/roguetent/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!density)
		close_up(user)
	else
		open_up(user)

/obj/structure/roguetent/CanAStarPass(ID, to_dir, atom/movable/caller)
	if(!density)
		return TRUE
	if(HAS_TRAIT(caller, TRAIT_BASHDOORS))
		return TRUE
	return ishuman(caller)

/obj/structure/roguetent/Bumped(atom/movable/AM)
	..()
	if(!density)
		return
	if(!ismob(AM))
		return
	var/mob/user = AM
	if(HAS_TRAIT(user, TRAIT_BASHDOORS))
		user.visible_message(span_warning("[user] smashes through [src]!"))
		take_damage(max_integrity, "brute", "blunt", 1)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.ai_controller)
			return
		open_up(user)
