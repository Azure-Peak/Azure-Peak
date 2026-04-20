/obj/structure/boatbell
	name = "bell"
	desc = "This is the doomspeller of Azure Peak."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "bell"
	density = FALSE
	max_integrity = 0
	anchored = TRUE
	var/last_ring
	var/datum/looping_sound/boatloop/soundloop

/obj/structure/boatbell/Initialize()
	soundloop = new(src, FALSE)
	soundloop.start()
	. = ..()

/obj/structure/boatbell/attack_hand(mob/user)
	if(world.time < last_ring + 50)
		return
	user.visible_message(span_info("[user] rings the bell."))
	playsound(src, 'sound/misc/boatbell.ogg', 100, extrarange = 5)
	last_ring = world.time

/obj/structure/boatbell/fluff/attack_hand(mob/user)
	if(world.time < last_ring + 50)
		return
	user.visible_message(span_info("[user] rings the bell."))
	playsound(src, 'sound/misc/boatbell.ogg', 100, extrarange = 5)
	last_ring = world.time

/obj/structure/standingbell
	name = "service bell"
	desc = "A bronze thimble, interlaced with a morsel of magitech. The bell's ring can be heard all across the \
	kingdom, only to those who're familiar with its unique chime. Such makes it an ideal choice among the Churches \
	and Guilds, so that no abbey-nor-smithy is left empty for long."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "standingbell"
	density = FALSE
	max_integrity = 0
	anchored = TRUE
	var/cooldown = 5 MINUTES
	var/on_cooldown = FALSE
	var/area/localarea
	/// If there is a location more specific than the area you need this to call people to, fill this in while mapping.
	/// Implemented for use inside the keep, so servant bells can declare the exact location you're being called to despite
	/// the keep being only one area. Nothing breaks if you don't fill this out.
	var/specific_location

/obj/structure/standingbell/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click to ring the bell, following a lengthy timed action.")
	. += span_info("Ringing the bell will play a distinct audio cue to every living character who's associated with the bell's location, notifying them - irregardless of where they are - that someone's requesting their presence.")
	. += span_info("Note that unlike the SCOM or HERMES, these living characters aren't informed as to who's specifically requesting their presence; only that someone has rung the bell, and that their presence is desired back home.")

/obj/structure/standingbell/Initialize()
	. = ..()
	localarea = get_area_name(src)
	if(specific_location)
		desc += "This one calls to the [specific_location]."

/obj/structure/standingbell/attack_hand(mob/living/user)
	if(on_cooldown)
		to_chat(user, span_warning("The bell has already been rung recently."))
	else
		user.changeNext_move(CLICK_CD_INTENTCAP)
		user.visible_message(span_warning("[user] begins to ring [src]."))
		if(do_after(user, 3 SECONDS))
			on_cooldown = TRUE
			user.visible_message(span_info("[user] rings [src]"))
			playsound(src, 'sound/misc/bell_small.ogg', 100, extrarange = 5)
			addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), cooldown)
			var/list/rolestonotify = list()
			switch(localarea)
				if("church")
					rolestonotify = list("Bishop", "Acolyte", "Druid", "Martyr", "Templar", "Sexton")
				if("Shop")
					rolestonotify = list("Merchant", "Shophand")
				if("Physician")
					rolestonotify = list("Head Physician", "Apothecary")
				if("The Guild of Craft")
					rolestonotify = list("Guildmaster", "Guildsman")
				if("Steward")
					rolestonotify = list("Steward", "Clerk")
				if("Baths")
					rolestonotify = list("Bathmaster", "Bathhouse Attendant")
				if("The Inquisition")
					rolestonotify = list("Inquisitor", "Orthodoxist", "Absolver")
				if("Garrison")
					rolestonotify = list("Man at Arms", "Sergeant", "Watchman")
				if("Manor", "keep basement")
					rolestonotify = list("Servant", "Seneschal")
			if(!specific_location)
				send_ooc_note(span_blue(("I hear the distant sound of [src] ringing. I'm being called to the <b>[localarea]</b>.")), \
				job = rolestonotify)
			else
				send_ooc_note(span_blue(("I hear the distant sound of [src] ringing. I'm being called to the <b>[specific_location]</b>.")), \
				job = rolestonotify)

/obj/structure/standingbell/proc/reset_cooldown()
	visible_message(span_notice ("[src] is ready for use again."))
	on_cooldown = FALSE
