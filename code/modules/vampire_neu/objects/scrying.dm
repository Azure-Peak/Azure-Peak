/obj/structure/vampire/scryingorb
	name = "Eye of Night"
	icon_state = "scrying"
	desc = "An unholy creation of impossible design, floats before you. Upon its surface flashes countless images and shapes beyond your understanding, places that shouldn't exist. Merely being in its vicinity sends a shiver down your spine."
/obj/structure/vampire/scryingorb/attack_hand(mob/living/carbon/human/user)
	if(user?.mind.has_antag_datum(/datum/antagonist/vampire/lord))
		user.visible_message("<font color='red'>[user]'s eyes turn dark red, as they channel the [src]</font>", "<font color='red'>I begin to channel my consciousness into a Predator's Eye.</font>")
		if(do_after(user, 6 SECONDS, src))
			user.scry_ghost(/mob/dead/observer/eye/arcane)
	else
		to_chat(user, span_warning("I don't have the power to use this!"))

/obj/structure/vampire/scryingorb/examine(mob/user)
	. = ..()
	if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
		. += span_bloody("Your scrying eye; spy upon the mortal or immortal realms alyke, peer through all languages and places. Just be careful whom walks past your eye. Your presence is powerful enough to be noticed even lyke this.")

/mob/dead/observer/eye/arcane
	icon_state = "arcaneeye"
	see_in_dark = 2
	hud_type = /datum/hud/eye
	/// If we have limited scrying
	var/limited_scry = FALSE
	/// The central turf we are restricted to scrying around
	var/turf/scry_center_turf
	/// The maximum tile distance from the center turf allowed
	var/scry_range = 2

/mob/dead/observer/eye/arcane/proc/scry_tele()
	set category = "RoleUnique.Arcane Eye"
	set name = "Teleport"
	set desc= "Teleport to a location"
	set hidden = 0

	if(!isobserver(usr))
		to_chat(usr, span_warning("You're not an Eye!"))
		return
	area_tele()

/mob/dead/observer/eye/arcane/Initialize()
	. = ..()
	add_verb(src, list(
		/mob/dead/observer/eye/arcane/proc/scry_tele,
		/mob/dead/observer/eye/arcane/proc/cancel_scry,
		/mob/dead/observer/eye/arcane/proc/eye_down,
		/mob/dead/observer/eye/arcane/proc/eye_up,
		/mob/dead/observer/eye/arcane/proc/vampire_telepathy))
	name = "Arcane Eye"

/mob/dead/observer/eye/arcane/proc/cancel_scry()
	set category = "RoleUnique.Arcane Eye"
	set name = "Cancel Eye"
	set desc= "Return to Body"

	if(reenter_corpse())
		qdel(src)

/mob/dead/observer/eye/arcane/Crossed(mob/living/L)
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

/mob/dead/observer/eye/arcane/proc/vampire_telepathy()
	set name = "Telepathy"
	set category = "RoleUnique.Arcane Eye"

	var/msg = sanitize(input("Send a message.", "Command") as text|null)
	if(!msg)
		return
	for(var/datum/mind/V in SSmapping.retainer.vampires)
		to_chat(V, span_boldnotice("A message from [src.real_name]:[msg]"))
	for(var/datum/mind/D in SSmapping.retainer.death_knights)
		to_chat(D, span_boldnotice("A message from [src.real_name]:[msg]"))
	for(var/mob/dead/observer/eye/arcane/A in GLOB.mob_list)
		to_chat(A, span_boldnotice("A message from [src.real_name]:[msg]"))

/mob/dead/observer/eye/arcane/proc/eye_up()
	set category = "RoleUnique.Arcane Eye"
	set name = "Move Up"

	if(zMove(UP, TRUE))
		to_chat(src, span_notice("I move upwards."))

/mob/dead/observer/eye/arcane/proc/eye_down()
	set category = "RoleUnique.Arcane Eye"
	set name = "Move Down"

	if(zMove(DOWN, TRUE))
		to_chat(src, span_notice("I move down."))

/mob/dead/observer/eye/arcane/Move(NewLoc, direct)
	if(scry_center_turf && limited_scry)
		var/turf/destination = NewLoc ? get_turf(NewLoc) : get_step(src, direct)
		if(destination && get_dist(destination, scry_center_turf) > scry_range)
			to_chat(src, span_warning("The vision's power binds you to this area!"))
			return FALSE
	if(updatedir)
		setDir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own
	if(NewLoc)
		var/turf/target_turf = get_turf(NewLoc)
		if(target_turf)
			return forceMove(target_turf)
		return FALSE
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return FALSE
	var/turf/step_turf = get_step(current_turf, direct)
	if(step_turf)
		return forceMove(step_turf)
	return FALSE

/mob/dead/observer/eye/arcane/abyssor
	limited_scry = TRUE

/mob/dead/observer/eye/arcane/beach
	name = "Abyssal Inundation Eye"
	var/obj/structure/roguemachine/dream_pool/source_pool

/mob/dead/observer/eye/arcane/beach/Initialize()
	. = ..()
	add_verb(src, list(/mob/dead/observer/eye/arcane/beach/proc/unleash_inundation))

/mob/dead/observer/eye/arcane/beach/Move(NewLoc, direct)
	var/turf/destination = NewLoc ? get_turf(NewLoc) : get_step(src, direct)
	if(destination)
		var/area/A = get_area(destination)
		var/static/list/allowed_areas = list(
			/area/rogue/outdoors/beach,
			/area/rogue/outdoors/beach/north,
			/area/rogue/outdoors/beach/south
		)
		if(!(A.type in allowed_areas))
			to_chat(src, span_warning("The abyssal pool binds your sight to the beach!"))
			return FALSE

	return ..()

/mob/dead/observer/eye/arcane/beach/proc/unleash_inundation()
	set category = "RoleUnique.Arcane Eye"
	set name = "Unleash Inundation"
	set desc = "Select the water tile you are currently hovering over to crash a tidal wave here, washing all channelers and deep ones onto the dry ground."
	set hidden = 0

	if(!isobserver(usr))
		to_chat(usr, span_warning("You're not an Eye!"))
		return

	var/turf/target_turf = get_turf(src)

	if(!istype(target_turf, /turf/open/water/ocean))
		to_chat(src, span_warning("You must unleash the wave onto a water tile!"))
		return

	var/non_water_count = 0
	var/list/landing_spots = list()
	for(var/turf/T in range(5, target_turf))
		if(!istype(T, /turf/open/water/ocean))
			non_water_count++
			if(!T.density)
				landing_spots += T

	if(non_water_count < 5)
		to_chat(src, span_warning("This location lacks enough dry shoreline (needs at least 5 non-water tiles nearby)!"))
		return

	if(!landing_spots.len)
		landing_spots += target_turf

	if(!source_pool)
		cancel_scry()
		return

	var/list/mob/living/travelers = list()
	for(var/mob/living/M in range(2, source_pool))
		if(M.stat != DEAD)
			travelers += M

	for(var/mob/living/M in travelers)
		var/turf/land_turf = pick(landing_spots)
		if(do_teleport(M, land_turf))
			M.setDir(pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
			M.Knockdown(40)
			if(ishuman(M))
				M.apply_status_effect(/datum/status_effect/debuff/waterlogged)
			to_chat(M, span_purple("A terrifying, dark tidal wave pulls you into the pool vortex and forcefully slams you onto the shore!"))

	var/list/deep_ones = list(
		/mob/living/simple_animal/hostile/rogue/deepone,
		/mob/living/simple_animal/hostile/rogue/deepone/arm,
		/mob/living/simple_animal/hostile/rogue/deepone/spit,
		/mob/living/simple_animal/hostile/rogue/deepone/wiz
	)

	addtimer(CALLBACK(source_pool, TYPE_PROC_REF(/obj/structure/roguemachine/dream_pool, spawn_deep_one_wave), deep_ones, landing_spots), 4 SECONDS)
	cancel_scry()
