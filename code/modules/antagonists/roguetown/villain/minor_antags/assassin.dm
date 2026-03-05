// Assassin, cultist of graggar. Normally found as a drifter.
/datum/antagonist/assassin
	name = "Assassin"
	roundend_category = "assassins"
	antagpanel_category = "Assassin"
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "assassin"
	show_name_in_check_antagonists = TRUE
	confess_lines = list(
		"MY CREED IS BLOOD!",
		"THE DAGGER TOLD ME WHO TO CUT!",
		"DEATH IS MY DEVOTION!",
		"THE DARK SUN GUIDES MY HAND!",
		"HAIL HE WHO HARVESTS!"
	)
	antag_flags = FLAG_FAKE_ANTAG

	var/traits_assassin = list(
		TRAIT_ASSASSIN,
		TRAIT_NOSTINK,
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
	)

	var/attached_knife = null

/datum/antagonist/assassin/on_gain()
	owner.current.cmode_music = list('sound/music/cmode/antag/combat_assassin.ogg')
	var/ass_dagger = /obj/item/rogueweapon/huntingknife/idagger/steel/profane
	var/ass_lockpick = /obj/item/lockpick/assassin 
	var/ass_grappler = /obj/item/grapplinghook
	owner.special_items["Profane Dagger"] = ass_dagger // Assigned assassins can get their special dagger from right clicking certain objects.
	owner.special_items["Avantyne Lockpick"] = ass_lockpick // they get a special 30 integ pick w/ a higher pickchance
	owner.special_items["Grappling Hook"] = ass_grappler // The Vile Grappler:
	to_chat(owner.current, "<span class='danger'>I've blended in well up until this point, but it's time for the Hunted of Graggar to perish. I must get my dagger from where I hid it.</span>")
	return ..()

/mob/living/carbon/human/proc/who_targets() // Verb for the assassin to remember their targets.
	set name = "Remember Targets"
	set category = "Graggar"
	if(!mind)
		return
	mind.recall_targets(src)

/mob/living/carbon/human/proc/find_dagger()
	set name = "Sense Dagger"
	set category = "Graggar"
	if(!mind)
		return
	// we need to get the antag datum instance off the person.
	var/datum/antagonist/assassin/villain = mind.has_antag_datum(/datum/antagonist/assassin)
	var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/knife = villain.attached_knife
	if(!villain)
		to_chat(src, span_danger("...how the fuck did you get access to this VERB? REPORT THIS TO CODERS ASAP."))
		return
	if(!knife || QDELETED(knife))
		to_chat(src, span_graggarnoanimate("Your dagger has not been bonded to you... or has been destroyed!"))
		return
	// find our dagger
	villain.find_dagger()

/datum/antagonist/assassin/proc/find_dagger()
	if(!owner.current)
		return
	var/mob/living/carbon/human/ass = owner.current
	var/turf/owner_turf = get_turf(ass)
	var/turf/knife_turf = get_turf(attached_knife)
	var/up_or_down = "on the same level"
	var/direction = "unknown"

	// This is butchered find corpse code. Thank you onutsio.
	if(owner_turf.z != knife_turf.z)
		if(knife_turf.z > owner_turf.z)
			up_or_down = "above"
		else
			up_or_down = "below"
	// get our cardinal...
	var/get_direction = get_dir(ass, attached_knife)
	switch(get_direction)
		if(NORTH)
			direction = "north"
		if(SOUTH)
			direction = "south"
		if(EAST)
			direction = "east"
		if(WEST)
			direction = "west"
		if(NORTHEAST)
			direction = "northeast"
		if(NORTHWEST)
			direction = "northwest"
		if(SOUTHEAST)
			direction = "southeast"
		if(SOUTHWEST)
			direction = "southwest"
	to_chat(ass, span_danger("The dagger is [direction] and [up_or_down]."))

/datum/antagonist/assassin/on_removal()
	if(!silent && owner.current)
		to_chat(owner.current,"<span class='danger'>The red fog in my mind is fading. I am no longer an [name]!</span>")
	return ..()

/datum/antagonist/assassin/on_life(mob/user)
	if(!user)
		return
	var/mob/living/carbon/human/H = user
	H.verbs |= /mob/living/carbon/human/proc/who_targets
	H.verbs |= /mob/living/carbon/human/proc/find_dagger

/datum/antagonist/assassin/roundend_report()
	var/traitorwin = FALSE
	for(var/obj/item/I in owner.current) // Check to see if the Assassin has their profane dagger on them, and then check the souls contained therein.
		if(istype(I, /obj/item/rogueweapon/huntingknife/idagger/steel/profane))
			for(var/mob/dead/observer/profane/A in I) // Each trapped soul is announced to the server
				if(A)
					to_chat(world, "The [A.name] has been stolen for Graggar by [owner.name].<span class='greentext'>DAMNATION!</span>")
					traitorwin = TRUE

	if(!considered_alive(owner))
		traitorwin = FALSE

	if(traitorwin)
		to_chat(world, "<span class='greentext'>The [name] [owner.name] has TRIUMPHED!</span>")
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(world, "<span class='redtext'>The [name] [owner.name] has FAILED!</span>")
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)
