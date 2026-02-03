/obj/structure/spike_pit
	name = "spike pit"
	desc = "A hole filled with sharp wooden ends that protrude upwards."
	icon_state = "spike_pit"
	can_buckle = TRUE
	icon = 'icons/turf/roguefloor.dmi'
	density = FALSE
	anchored = TRUE
	can_buckle = FALSE
	max_integrity = 100
	buckle_lying = 90
	layer = 2.8

/obj/structure/spike_pit/Crossed(atom/movable/AM)
	var/hitsound = pick('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	var/was_thrown = AM.throwing // If you are thrown - like by fetch spells, it destroys the pit for balance.

	if(isliving(AM))
		var/mob/living/L = AM
		if(L.movement_type & (FLYING|FLOATING)) //don't close the trap if they're flying/floating over it.
			return ..()
		if(L.is_jumping) // Allow jumping over the pit
			return ..()

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/area = BODY_ZONE_L_LEG
		if(prob(50))
			area = BODY_ZONE_R_LEG
		var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(area))
		if(!affecting) //if somehow no legs
			affecting =  H.get_bodypart(check_zone(BODY_ZONE_CHEST))

		//Wounds bleed pretty slow alone so this is more to be annoying than dangerous.
		var/damage = 30
		affecting.receive_damage(damage)
		var/datum/wound/choice = /datum/wound/puncture
		if(prob(25))
			choice = /datum/wound/puncture/large
		affecting.add_wound(choice)
		H.forceMove(drop_location())

		H.emote("painscream")
		var/delay = 20 - H.STACON // Might be too long, if you figure out a better answer let me know.
		delay = delay * 10
		//H.Paralyze(delay)
		buckle_mob(H, TRUE)
		H.clear_alert("buckled") //easiest way to hide this option. Have to click the pit with a free hand to get loose.
		playsound(src.loc, hitsound, 100)
		if(was_thrown)
			AM.throwing?.finalize(FALSE) // Stop throw momentum, so spike pit are not destroyed in a row
			visible_message(span_warning("The spikes shatter from the impact!"))
			qdel(src)
		return

	if(istype(AM, /mob/living/simple_animal))
		var/mob/living/simple_animal/L = AM
		L.adjustHealth(40)
		L.Paralyze(40)
		buckle_mob(L, TRUE)
		L.get_sound("pain")
		playsound(src.loc, hitsound, 100)
		if(was_thrown)
			AM.throwing?.finalize(FALSE) // Stop throw momentum, so spike pit are not destroyed in a row
			visible_message(span_warning("The spikes shatter from the impact!"))
			qdel(src)
		return

	. = ..()

/obj/structure/spike_pit/attackby(obj/item/I, mob/user, params)

	if(istype(I, /obj/item/rogueweapon/shovel))
		playsound(loc,'sound/items/dig_shovel.ogg', 100, TRUE)
		to_chat(user, span_info("I start covering up \the [name]..."))
		if(do_after(user, 5 SECONDS, src))
			playsound(loc,'sound/items/empty_shovel.ogg', 100, TRUE)
			qdel(src)
			return
	. = ..()

/obj/structure/spike_pit/attack_hand(mob/user)
	if(has_buckled_mobs())
		var/person = buckled_mobs[1].name
		if(user == buckled_mobs[1])
			person = "themself"
		user.visible_message(span_warning("[user.name] starts to pull [person] off \the [name]..."))
		if(do_after(user, 3 SECONDS))
			unbuckle_mob(buckled_mobs[1], TRUE)
			user.visible_message(span_warning("[user.name] pulls [person] out of the spikes."))
	. = ..()
