/obj/structure/vampire/portalmaker
	name = "Rift Gate"
	icon_state = "obelisk"
	desc = "A large ominious oblisk of unknown and impossible design, runic letters and shapes flicker before your eyes within an endless void, sometimes stare long enough into the void within <font color='FF0000'>...and something will stare back.</font>"
	var/sending = FALSE

/obj/structure/vampire/portalmaker/examine(mob/user) //Currently unusable but it still gets text on how it /would/ have been. PLACEHOLDERY for now until someone else fixes this since I don't want to cobble together shitcode that might not work lol. //Sradar
	. = ..()
	if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
		. += span_bloody("Your means of transport through the edge of reality itself and back, through creating portal rifts that anyone can walk through for 1000 Vitae.")

/obj/structure/vampire/portalmaker/attack_hand(mob/living/user)
	var/list/possibleportals = list()

	. = TRUE


	if(!user.has_bloodpool_cost(1000))
		to_chat(user, span_warning("This costs 1000 vitae, I lack that."))
		return
	var/list/choices = list("RETURN", "SENDING", "I RESCIND")
	switch(input(user, "Which type of portal?", "Portal Type") as null|anything in choices)
		if("I RESCIND")
			return

		if("RETURN")
			for(var/obj/item/clothing/neck/portalamulet/P in GLOB.vampire_objects)
				possibleportals += P
			var/atom/choice = input(user, "Choose an area to open the portal", "Choices") as null|anything in possibleportals
			if(!choice)
				return
			user.visible_message("[user] begins to summon a portal.", "I begin to summon a portal.")
			if(!do_after(user, 3 SECONDS, src))
				return

			user.has_bloodpool_cost(-1000)
			if(istype(choice, /obj/item/clothing/neck/portalamulet))
				var/obj/item/clothing/neck/portalamulet/A = choice
				A.uses -= 1
				var/obj/effect/landmark/vteleportdestination/VR = new(A.loc)
				VR.amuletname = A.name
				create_portal_return(A.name, 3000)
				user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
				if(A.uses <= 0)
					A.visible_message("[A] shatters!")
					qdel(A)
		if("SENDING")
			if(sending)
				to_chat(user, "A portal is already active!")
				return
			for(var/obj/item/clothing/neck/portalamulet/P in GLOB.vampire_objects)
				possibleportals += P
			var/atom/choice = input(user, "Choose an area to open the portal to", "Choices") as null|anything in possibleportals
			if(!choice)
				return
			user.visible_message("[user] begins to summon a portal.", "I begin to summon a portal.")
			if(do_after(user, 3 SECONDS, src))
				user.has_bloodpool_cost(-1000)
				if(istype(choice, /obj/item/clothing/neck/portalamulet))
					var/obj/item/clothing/neck/portalamulet/A = choice
					A.uses -= 1
					var/turf/G = get_turf(A)
					new /obj/effect/landmark/vteleportsenddest(G.loc)
					if(A.uses <= 0)
						A.visible_message("[A] shatters!")
						qdel(A)
					create_portal()
					user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)

/obj/structure/vampire/portal
	name = "Eerie Portal"
	icon_state = "portal"
	var/duration = 999
	var/spawntime = null
	density = FALSE

/obj/structure/vampire/portal/Initialize()
	. = ..()
	set_light(3, 2, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)
	playsound(loc, 'sound/misc/portalopen.ogg', 100, FALSE, pressure_affected = FALSE)

	addtimer(CALLBACK(src, PROC_REF(delete)), 60 SECONDS)

/obj/structure/vampire/portal/proc/delete()
	visible_message(span_boldnotice("[src] shudders before rapidly closing."))
	qdel(src)

/obj/structure/vampire/portal/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		for(var/obj/effect/landmark/vteleport/dest in GLOB.landmarks_list)
			playsound(loc, 'sound/misc/portalenter.ogg', 100, FALSE, pressure_affected = FALSE)
			AM.forceMove(dest.loc)
			break

/obj/structure/vampire/portal/sending
	name = "Eerie Portal"
	icon_state = "portal"
	duration = 999
	spawntime = null
	var/turf/destloc

/obj/structure/vampire/portal/sending/Crossed(atom/movable/AM)
	if(isliving(AM))
		for(var/obj/effect/landmark/vteleportsenddest/V in GLOB.landmarks_list)
			AM.forceMove(V.loc)

/obj/structure/vampire/portal/sending/Destroy()
	for(var/obj/effect/landmark/vteleportsenddest/V in GLOB.landmarks_list)
		qdel(V)
	for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
		P.sending =  FALSE
	return ..()

/obj/structure/vampire/portalmaker/proc/create_portal_return(aname,duration)
	for(var/obj/effect/landmark/vteleportdestination/Vamp in GLOB.landmarks_list)
		if(Vamp.amuletname == aname)
			var/obj/structure/vampire/portal/P = new(get_turf(Vamp))
			P.duration = duration
			P.spawntime = world.time
			P.visible_message(span_boldnotice("A sickening tear is heard as a sinister portal emerges."))
		qdel(Vamp)

/obj/structure/vampire/portalmaker/proc/create_portal(choice,duration)
	sending = TRUE
	for(var/obj/effect/landmark/vteleportsending/S in GLOB.landmarks_list)
		var/obj/structure/vampire/portal/sending/P = new(S.loc)
		P.visible_message(span_boldnotice("A sickening tear is heard as a sinister portal emerges."))

/obj/item/clothing/neck/portalamulet
	name = "Gate Amulet"
	icon_state = "bloodtooth"
	icon = 'icons/roguetown/clothing/neck.dmi'
	var/uses = 3

/obj/item/clothing/neck/portalamulet/Initialize()
	GLOB.vampire_objects |= src
	. = ..()

/obj/item/clothing/neck/portalamulet/Destroy()
	GLOB.vampire_objects -= src
	return ..()

/* DISABLED FOR NOW
/obj/item/clothing/neck/portalamulet/attack_self(mob/user, params)
	. = ..()
	if(alert(user, "Create a portal?", "PORTAL GEM", "Yes", "No") == "Yes")
		uses -= 1
		var/obj/effect/landmark/vteleportdestination/Vamp = new(loc)
		Vamp.amuletname = name
		for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
			P.create_portal_return(name, 3000)
		user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
		if(uses <= 0)
			visible_message("[src] shatters!")
			qdel(src)
*/
