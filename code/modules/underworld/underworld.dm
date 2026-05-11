/obj/item/flashlight/lantern/shrunken
	name = "shrunken lamp"
	desc = "A beacon."
	icon_state = "shrunkenlamp"
	item_state = "shrunkenlamp"
	lefthand_file = 'icons/roguetown/underworld/enigma_husks.dmi'
	righthand_file = 'icons/roguetown/underworld/enigma_husks.dmi'
	light_outer_range = 4
	light_power = 20
	light_color = LIGHT_COLOR_BLOOD_MAGIC

/obj/item/flashlight/lantern/shrunken/update_brightness(mob/user = null)
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(3, 3, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)
	else
		icon_state = initial(icon_state)
		set_light(0)

/obj/structure/underworld/carriageman
	name = "The Ferryman"
	desc = (span_cult("Eternal wandering I am damned, unless a coin in my mouth was crammed."))
	icon = 'icons/roguetown/underworld/enigma_carriageman.dmi'
	icon_state = "carriageman"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	density = TRUE
	var/toll = FALSE


/obj/structure/underworld/carriageman/examine(mob/living/user)
	. = ..()
	if((user.patron?.type == /datum/patron/divine/necra) && (HAS_TRAIT(user, TRAIT_RITUALIST)))
		. += (span_cult(" I could exchange a toll to refresh my rites..."))
		return

/obj/structure/underworld/carriageman/Initialize()
	. = ..()
	set_light(5, 4, 30, l_color = LIGHT_COLOR_BLUE)

/obj/structure/underworld/carriageman/attack_hand(mob/living/user)
	if(!istype(user, /mob/living/carbon/spirit))
		if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE)&& toll)
			to_chat(user, "<br><font color=purple><span class='bold'>HANDS EXCHANGE PAY AND OATHS GIVE WAY, BE ON YOUR WAY</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			toll = FALSE
			if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
				user.remove_status_effect(/datum/status_effect/debuff/ritesexpended)
			return
		if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE)&& !toll)
			to_chat(user, "<br><font color=purple><span class='bold'>RITES ARE A FICKLE THING, SWORN ONCE A DAY- <br> PAY THE TOLL, AND OATHS GIVE WAY</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			return
		to_chat(user, span_warning("The ferryman does not acknowledge the living."))
		return
	var/mob/living/carbon/spirit/ghost = user
	if(!ghost.paid)
		user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
		to_chat(user, "<br><font color=purple><span class='bold'>FETCH THE TOLL AND YOU MAY BOARD</span></font>")
	else
		to_chat(user, "<br><font color=purple><span class='bold'>HANDS EXCHANGE PAY, BE ON YOUR WAY</span></font>")
		user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)

/obj/structure/underworld/carriageman/attackby(obj/item/W, mob/living/user)
	if(!istype(user, /mob/living/carbon/spirit)&& !toll && HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		if(istype(W, /obj/item/thetoll))
			qdel(W)
			to_chat(user, "<br><font color=purple><span class='bold'>THE TOLL IS PAID, A TRANSACTION MADE.</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			toll = TRUE
			return
	if(!istype(user, /mob/living/carbon/spirit)&& toll && HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		if(istype(W, /obj/item/thetoll))
			to_chat(user, "<br><font color=purple><span class='bold'>ONE TRANSACTION AT A TIME.</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			return
	if(!istype(user, /mob/living/carbon/spirit) && !HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		to_chat(user, span_warning("The ferryman does not acknowledge the living."))
	var/mob/living/carbon/spirit/ghost = user
	if(istype(W, /obj/item/underworld/coin))
		if(!ghost.paid)
			qdel(W)
			to_chat(ghost, "<br><font color=purple><span class='bold'>THE TOLL IS PAID, THROUGH THE CARRIAGE THE UNDERMAIDEN WAITS.</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			ghost.paid = TRUE
			return
		if(ghost.paid)
			to_chat(ghost, "<br><font color=purple><span class='bold'>FURTHER PAYMENT WILL NOT CHANGE HER JUDGEMENT.</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
	else
		to_chat(ghost, "<br><font color=purple><span class='bold'>ONLY THE TOLL WILL I ACCEPT</span></font>")
		user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)

/obj/structure/underworld/barrier //Blocks sprite locations
	name = "DONT STAND HERE"
	desc = "The Undermaiden awaits."
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"
	density = TRUE
	anchored = TRUE

/obj/structure/underworld/carriage_normal
	name = "Carriage"
	desc = "Azure Peak awaits."
	icon = 'icons/roguetown/underworld/enigma_carriage.dmi'
	icon_state = "carriage_normal"
	anchored = TRUE
	density = TRUE

/obj/structure/underworld/carriage
	name = "Carriage"
	desc = "The Undermaiden awaits."
	icon = 'icons/roguetown/underworld/enigma_carriage.dmi'
	icon_state = "carriage_lit"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	density = TRUE


/obj/structure/underworld/carriage/Initialize()
	. = ..()
	set_light(5, 3, 30, l_color = LIGHT_COLOR_BLUE)

/obj/structure/underworld/carriage/attack_hand(mob/living/carbon/spirit/user)
	if(user.paid)
		switch(alert("Are you ready to be judged?",,"Yes","No"))
			if("Yes")
				playsound(user, 'sound/misc/deadbell.ogg', 50, TRUE, -2, ignore_walls = TRUE)
				user.returntolobby()
			if("No")
				usr << "You delay fate."
	else
		to_chat(user, "<B><font size=3 color=red>It's LOCKED.</font></B>")

GLOBAL_VAR_INIT(underworld_coins, 0)

/obj/item/underworld/coin
	name = "The Toll"
	desc = "This is more than just a coin."
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "soultoken_floor"
	var/should_track = TRUE

/obj/item/underworld/coin/Initialize()
	. = ..()
	if(should_track)
		GLOB.underworld_coins += 1

/obj/item/underworld/coin/Destroy()
	if(should_track)
		GLOB.underworld_coins -= 1
	coin_upkeep()
	return ..()

/obj/item/underworld/coin/pickup(mob/user)
	..()
	if(should_track)
		GLOB.underworld_coins -= 1
	coin_upkeep()
	icon_state = "soultoken"

/obj/item/underworld/coin/dropped(mob/user)
	..()
	if(should_track)
		GLOB.underworld_coins += 1
	icon_state = "soultoken_floor"

/obj/item/underworld/coin/notracking
	should_track = FALSE

/proc/coin_upkeep()
	if(GLOB.underworld_coins < 8)
		for(var/obj/effect/landmark/underworldcoin/B in GLOB.landmarks_list)
			new /obj/item/underworld/coin(B.loc)


