/obj/structure/vampire/scryingorb // Method of spying on the town
	name = "Eye of Night"
	icon_state = "scrying"
	desc = "An unholy creation of impossible design, floats before you. Upon its surface flashes countless images and shapes beyond your understanding, places that shouldn't exist. Merely being in its vicinity sends a shiver down your spine."
/obj/structure/vampire/scryingorb/attack_hand(mob/living/carbon/human/user)
	if(user?.mind.has_antag_datum(/datum/antagonist/vampire/lord))
		user.visible_message("<font color='red'>[user]'s eyes turn dark red, as they channel the [src]</font>", "<font color='red'>I begin to channel my consciousness into a Predator's Eye.</font>")
		if(do_after(user, 6 SECONDS, src))
			user.scry(can_reenter_corpse = 1, force_respawn = FALSE)
	else
		to_chat(user, span_warning("I don't have the power to use this!"))

/obj/structure/vampire/scryingorb/examine(mob/user)
	. = ..()
	if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
		. += span_bloody("Your scrying eye; spy upon the mortal or immortal realms alyke, peer through all languages and places. Just be careful whom walks past your eye. Your presence is powerful enough to be noticed even lyke this.")

/mob/dead/observer/rogue/arcaneeye
	sight = 0
	see_in_dark = 2
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_OBSERVER

	misting = 0
	var/mob/living/carbon/human/vampirelord = null
	icon_state = "arcaneeye"
	draw_icon = FALSE
	hud_type = /datum/hud/eye

/mob/dead/observer/rogue/arcaneeye/proc/scry_tele()
	set category = "Arcane Eye"
	set name = "Teleport"
	set desc= "Teleport to a location"
	set hidden = 0

	if(!isobserver(usr))
		to_chat(usr, span_warning("You're not an Eye!"))
		return
	var/list/filtered = list()
	for(var/V in GLOB.sortedAreas)
		var/area/A = V
		if(!A.hidden)
			filtered += A
	var/area/thearea  = input("Area to jump to", "BOOYEA") as null|anything in filtered

	if(!thearea)
		return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		to_chat(usr, span_warning("No area available."))
		return

	usr.forceMove(pick(L))

/mob/dead/observer/rogue/arcaneeye/Initialize()
	. = ..()
	set_invisibility(GLOB.observer_default_invisibility)
	verbs += list(
		/mob/dead/observer/rogue/arcaneeye/proc/scry_tele,
		/mob/dead/observer/rogue/arcaneeye/proc/cancel_scry,
		/mob/dead/observer/rogue/arcaneeye/proc/eye_down,
		/mob/dead/observer/rogue/arcaneeye/proc/eye_up,
		/mob/dead/observer/rogue/arcaneeye/proc/vampire_telepathy)
	name = "Arcane Eye"
	grant_all_languages()

/mob/dead/observer/rogue/arcaneeye/proc/cancel_scry()
	set category = "Arcane Eye"
	set name = "Cancel Eye"
	set desc= "Return to Body"

	if(vampirelord)
		vampirelord.ckey = ckey
		qdel(src)
	else
		to_chat(src, "My body has been destroyed! I'm trapped!")

/mob/dead/observer/rogue/arcaneeye/Crossed(mob/living/L)
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/V = L
		var/holyskill = V.get_skill_level(/datum/skill/magic/holy)
		var/magicskill = V.get_skill_level(/datum/skill/magic/arcane)
		if(magicskill >= 2)
			to_chat(V, "<font color='red'>An ancient and unusual magic looms in the air around you.</font>")
			return
		if(holyskill >= 2)
			to_chat(V, "<font color='red'>An ancient and unholy magic looms in the air around you.</font>")
			return
		if(prob(20))
			to_chat(V, "<font color='red'>You feel like someone is watching you, or something.</font>")
			return

/mob/dead/observer/rogue/arcaneeye/proc/vampire_telepathy()
	set name = "Telepathy"
	set category = "Arcane Eye"

	var/msg = input("Send a message.", "Command") as text|null
	if(!msg)
		return
	for(var/datum/mind/V in SSmapping.retainer.vampires)
		to_chat(V, span_boldnotice("A message from [src.real_name]:[msg]"))
	for(var/datum/mind/D in SSmapping.retainer.death_knights)
		to_chat(D, span_boldnotice("A message from [src.real_name]:[msg]"))
	for(var/mob/dead/observer/rogue/arcaneeye/A in GLOB.mob_list)
		to_chat(A, span_boldnotice("A message from [src.real_name]:[msg]"))

/mob/dead/observer/rogue/arcaneeye/proc/eye_up()
	set category = "Arcane Eye"
	set name = "Move Up"

	if(zMove(UP, TRUE))
		to_chat(src, span_notice("I move upwards."))

/mob/dead/observer/rogue/arcaneeye/proc/eye_down()
	set category = "Arcane Eye"
	set name = "Move Down"

	if(zMove(DOWN, TRUE))
		to_chat(src, span_notice("I move down."))

/mob/dead/observer/rogue/arcaneeye/Move(NewLoc, direct)
	if(world.time < next_gmove)
		return
	next_gmove = world.time + 3

	if(updatedir)
		setDir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own
	var/oldloc = loc

	if(NewLoc)
		forceMove(NewLoc)
	else
		forceMove(get_turf(src))  //Get out of closets and such as a ghost
		if((direct & NORTH) && y < world.maxy)
			y++
		else if((direct & SOUTH) && y > 1)
			y--
		if((direct & EAST) && x < world.maxx)
			x++
		else if((direct & WEST) && x > 1)
			x--

	Moved(oldloc, direct)

/mob/proc/scry(can_reenter_corpse = 1, force_respawn = FALSE, drawskip)
	stop_sound_channel(CHANNEL_HEARTBEAT) //Stop heartbeat sounds because You Are A Ghost Now
	var/mob/dead/observer/rogue/arcaneeye/eye = new(src)	// Transfer safety to observer spawning proc.
	SStgui.on_transfer(src, eye) // Transfer NanoUIs.
	eye.can_reenter_corpse = can_reenter_corpse
	eye.vampirelord = src
	eye.ghostize_time = world.time
	eye.key = key
	return eye
