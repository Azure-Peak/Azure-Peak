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
	var/graggar_boy_points = 0

/datum/antagonist/assassin/on_gain()
	var/mob/living/carbon/human/H = owner.current
	// EQUIPMENT
	var/ass_dagger = /obj/item/rogueweapon/huntingknife/idagger/steel/profane
	var/ass_lockpick = /obj/item/lockpick/assassin 
	var/ass_grappler = /obj/item/grapplinghook
	owner.special_items["Profane Dagger"] = ass_dagger // Assigned assassins can get their special dagger from right clicking certain objects.
	owner.special_items["Avantyne Lockpick"] = ass_lockpick // they get a special 30 integ pick w/ a higher pickchance
	owner.special_items["Grappling Hook"] = ass_grappler // The Vile Grappler:
	// DEVOTION INIT & SPELLS
	var/datum/devotion/C = new /datum/devotion(H, H.patron) // patron should ALWAYS be graggar.
	H.devotion = C
	C.grant_miracles(H, CLERIC_ORI, 0, CLERIC_REQ_0) // this is just here for future use.
	H.devotion.max_devotion = 10
	H.devotion.update_devotion(silent = TRUE)
	// you dont actually get miracle miracles. yet.
	var/obj/effect/proc_holder/spell/orison = owner.get_spell(/obj/effect/proc_holder/spell/targeted/touch/orison)
	if(orison)
		owner.RemoveSpell(orison)

	// MISC/INFODUMP
	owner.current.cmode_music = list('sound/music/cmode/antag/combat_assassin.ogg')
	greet()
	return ..()

/datum/antagonist/assassin/greet()
	. = ..()
	to_chat(owner.current, span_graggar("I've blended in well up until this point, but it's time for the Hunted of Graggar to perish. I must get my dagger from where I hid it."))
	addtimer(CALLBACK(src, PROC_REF(antagonist_explanation)), 15 SECONDS) // DEBUG

/datum/antagonist/assassin/proc/antagonist_explanation()
	to_chat(owner.current, span_userdanger("\nPlease remember, assassin is an antagonistic role! \
	You may attack YOUR TARGETS without escalation, however, you MUST still RESPECT ERP META-PROTECTIONS. \
	\nAs always, have good faith, or your toys may get removed!"))

	// TODO: COMMUNE W/ THE BLACK FLAME FOR POTENTIAL RITUAL PERMISSIONS.

/mob/living/carbon/human/proc/who_targets() // Verb for the assassin to remember their targets.
	set name = "Remember Targets"
	set category = "Special Verbs - Role"
	if(!mind)
		return
	mind.recall_targets(src)

/mob/living/carbon/human/proc/find_dagger()
	set name = "Sense Dagger"
	set category = "Special Verbs - Role"
	if(!mind)
		return
	// we need to get the antag datum instance off the person.
	var/datum/antagonist/assassin/villain = mind.has_antag_datum(/datum/antagonist/assassin)
	var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/knife = villain.attached_knife
	if(!villain)
		to_chat(src, span_danger("...how the fuck did you get access to this VERB? REPORT THIS TO CODERS ASAP."))
		return
	if(!knife || QDELETED(knife))
		to_chat(src, span_graggar("Your dagger has not been bonded to you... or has been destroyed!"))
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

/datum/stolen_face
	var/icon
	var/real_name = "debug"
	var/gender
	var/datum/dna/deena
	var/job
	var/faction 
	var/deathsound
	var/voice_color
	var/voice_pitch
	var/detail_color
	var/skin_tone
	var/lip_style
	var/lip_color
	var/age
	var/underwear
	var/shavelevel
	var/socks
	var/has_stubble
	var/headshot_link
	var/flavortext
	var/head_bodypart_features
	var/bodyparts

/datum/stolen_face/proc/steal_face(mob/living/carbon/human/H)
	// safety
	if(!ishuman(H))
		return

	icon = H.icon
	real_name = H.real_name
	gender = H.gender
	deena = H.dna // dna is weird, i want to hard copy it 
	job = H.job
	faction = H.faction
	deathsound = H.deathsound
	voice_color = H.voice_color
	voice_pitch = H.voice_pitch
	detail_color = H.detail_color
	skin_tone = H.skin_tone
	lip_style = H.lip_style
	lip_color = H.lip_color
	age = H.age
	underwear = H.underwear
	shavelevel = H.shavelevel
	socks = H.socks
	has_stubble = H.has_stubble
	headshot_link = H.headshot_link
	flavortext = H.flavortext

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		head_bodypart_features = head.bodypart_features?.Copy() // ditto dna

	bodyparts = H.bodyparts?.Copy() // this is temporary im not sure it'll work

/datum/stolen_face/proc/apply_face(mob/living/carbon/human/H)

	if(!ishuman(H))
		return

	deena.transfer_identity(H) // this proc is weird but needed-- praying this works

	H.icon = icon
	H.real_name = real_name
	H.gender = gender
	H.job = job
	H.faction = faction
	H.deathsound = deathsound
	H.voice_color = voice_color
	H.voice_pitch = voice_pitch
	H.detail_color = detail_color
	H.skin_tone = skin_tone
	H.lip_style = lip_style
	H.lip_color = lip_color
	H.age = age
	H.underwear = underwear
	H.shavelevel = shavelevel
	H.socks = socks
	H.has_stubble = has_stubble
	H.headshot_link = headshot_link
	H.flavortext = flavortext

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(head && head_bodypart_features)
		head.bodypart_features = head_bodypart_features

	H.updateappearance(mutcolor_update = TRUE)
	H.regenerate_icons()



