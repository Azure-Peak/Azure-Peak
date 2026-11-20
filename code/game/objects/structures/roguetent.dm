
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

/obj/structure/roguetent/Initialize(mapload)
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
	set_opacity(FALSE)
	update_icon()
	alert_ai_visibility_change(src)

/obj/structure/roguetent/proc/close_up(mob/user)
	visible_message(span_info("[user] closes [src]."))
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = TRUE
	set_opacity(TRUE)
	update_icon()

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

/obj/structure/roguetent/colored
	name = "blue tent door"
	base_state = "tentdoor_blue"
	icon_state = "tentdoor_blue-closed"

/obj/structure/roguetent/colored/update_icon()
	icon_state = "[base_state]-[density ? "closed" : "open"]"

/obj/structure/roguetent/colored/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_blue-open"

/obj/structure/roguetent/colored/cyan
	name = "cyan tent door"
	base_state = "tentdoor_cyan"
	icon_state = "tentdoor_cyan-closed"

/obj/structure/roguetent/colored/cyan/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_cyan-open"

/obj/structure/roguetent/colored/brown
	name = "brown tent door"
	base_state = "tentdoor_brown"
	icon_state = "tentdoor_brown-closed"

/obj/structure/roguetent/colored/brown/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_brown-open"

/obj/structure/roguetent/colored/green
	name = "green tent door"
	base_state = "tentdoor_green"
	icon_state = "tentdoor_green-closed"

/obj/structure/roguetent/colored/green/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_green-open"

/obj/structure/roguetent/colored/purple
	name = "purple tent door"
	base_state = "tentdoor_purple"
	icon_state = "tentdoor_purple-closed"

/obj/structure/roguetent/colored/purple/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_purple-open"

/obj/structure/roguetent/colored/red
	name = "red tent door"
	base_state = "tentdoor_red"
	icon_state = "tentdoor_red-closed"

/obj/structure/roguetent/colored/red/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_red-open"

/obj/structure/roguetent/colored/bluedeco
	name = "blue decorated tent door"
	base_state = "tentdoor_bluedeco"
	icon_state = "tentdoor_bluedeco-closed"

/obj/structure/roguetent/colored/bluedeco/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_bluedeco-open"

/obj/structure/roguetent/colored/cyandeco
	name = "cyan decorated tent door"
	base_state = "tentdoor_cyandeco"
	icon_state = "tentdoor_cyandeco-closed"

/obj/structure/roguetent/colored/cyandeco/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_cyandeco-open"

/obj/structure/roguetent/colored/browndeco
	name = "brown decorated tent door"
	base_state = "tentdoor_browndeco"
	icon_state = "tentdoor_browndeco-closed"

/obj/structure/roguetent/colored/browndeco/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_browndeco-open"

/obj/structure/roguetent/colored/greendeco
	name = "green decorated tent door"
	base_state = "tentdoor_greendeco"
	icon_state = "tentdoor_greendeco-closed"

/obj/structure/roguetent/colored/greendeco/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_greendeco-open"

/obj/structure/roguetent/colored/purpledeco
	name = "purple decorated tent door"
	base_state = "tentdoor_purpledeco"
	icon_state = "tentdoor_purpledeco-closed"

/obj/structure/roguetent/colored/purpledeco/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_purpledeco-open"

/obj/structure/roguetent/colored/reddeco
	name = "red decorated tent door"
	base_state = "tentdoor_reddeco"
	icon_state = "tentdoor_reddeco-closed"

/obj/structure/roguetent/colored/reddeco/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_reddeco-open"

/obj/structure/roguetent/colored/noc
	name = "navy tent door"
	base_state = "tentdoor_noc"
	icon_state = "tentdoor_noc-closed"

/obj/structure/roguetent/colored/noc/open
	density = FALSE
	opacity = FALSE
	icon_state = "tentdoor_noc-open"
