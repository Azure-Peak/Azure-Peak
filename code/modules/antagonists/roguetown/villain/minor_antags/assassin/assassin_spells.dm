// this is the replacement for the previous hitlist that didnt work very well
// honestly this is dogshit & i should just reflavor the entire gnoll spell but this will do for now bc iiii dont feel like
// trying to reflavor that and checking for dagger and whatever
/datum/action/cooldown/spell/assassin
	name = "Debug"
	desc = "You have somehow managed to get the /cooldown/spell/assassin parent spell. Please report this to a coder w/ your roundID and how this happened."
	background_icon = 'icons/mob/actions/graggarmiracles.dmi'
	button_icon = 'icons/mob/actions/assassinspells.dmi'
	button_icon_state = ""

/datum/action/cooldown/spell/assassin/get_targets
	name = "Recall Targets"
	desc = "Recall the name of all targets not currently slain and bound into a dagger. Select a target to get a sense of where they are."
	click_to_activate = FALSE
	sound = null
	// no invocation is intentional. we want you to at least get to your target w/o being instantly foudn out.
	// find dagger SHOULD have one as you're probably in the shit if you're having to find the fuckin thing.
	// if you REALLY insist on having one, add a mute-person workaround. thx.
	ignore_can_speak = TRUE
	spell_requirements = SPELL_REQUIRES_HUMAN
	charge_required = FALSE
	cooldown_time = 1 MINUTES
	button_icon_state = "find_mark"

/datum/action/cooldown/spell/assassin/get_targets/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/assassin = owner
	// hotwired gnoll sniff code
	var/list/possible_targets = list()

	for(var/mob/living/L in GLOB.player_list)
		if(L == assassin || istype(L, /mob/living/carbon/human/dummy))
			continue
		var/is_hunted = L.has_flaw(/datum/charflaw/targeted)
		var/is_trapped = HAS_TRAIT(L, TRAIT_CLAIMED_BY_DARKSTAR)
		var/is_valid_prey = is_hunted && !is_trapped

		if(is_valid_prey)
			var/entry_name = "[L.real_name]"
			var/target_job = L.get_role_title()
			if(target_job)
				entry_name += " - [target_job]"
			else
				entry_name += " - Unknown"
			possible_targets[entry_name] = L

	if(!length(possible_targets))
		to_chat(assassin, span_warning("You are alone. For now."))
		return

	var/selection = tgui_input_list(assassin, "Who are we hunting tonite?", "Deepen the Drowning Pool", possible_targets)
	if(!selection)
		return

	var/mob/living/tracked_target = possible_targets[selection]
	to_chat(assassin, span_notice("You focus your senses on [tracked_target.real_name]."))
	var/directions = get_tracking_directions(assassin, tracked_target)
	to_chat(assassin, span_cult("[directions]"))

/datum/action/cooldown/spell/assassin/get_targets/proc/get_tracking_directions(mob/living/user, mob/living/tracked_target)
// first things first. let's make sure nothing got fucked since we started the cast().
	if(!user)
		return FALSE
	if(!tracked_target)
		return span_warning("Something is wrong. My target seems to have disappeared...")

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(tracked_target)

	if(!user_turf)
		return span_warning("Something is wrong. Where am I...?")
	if(!target_turf)
		return span_warning("Something is wrong. My target seems to have disappeared...")

	// we are in a forbidden realm, stop the proc.
	if(are_you_ready_to_enter_my_dark_realm(get_area(user)))
		return span_warning("The location I am in bears some sort of protective workings. I will not be able to search for a target within this domain.")
	// if the target is in a forbidden realm, give some info then stop the proc.
	var/dark_realm_target_text = are_you_ready_to_enter_my_dark_realm(get_area(tracked_target))
	if(dark_realm_target_text)
		to_chat(user, span_cult("...something is wrong. I feel a tingle, a vision."))
		return span_warning(dark_realm_target_text)

	// hacked quest code. they get a proper homing beacon cus this only goes off 1/ a min.

	var/z_level_hint = ""
	if(target_turf.z != user_turf.z)
		var/z_diff = abs(target_turf.z - user_turf.z)
		z_level_hint = target_turf.z > user_turf.z ? \
			"[z_diff] level\s above you" : \
			"[z_diff] level\s below you"
	else
		z_level_hint = "on this level"

	var/dx = target_turf.x - user_turf.x
	var/dy = target_turf.y - user_turf.y
	var/distance = round(sqrt(dx*dx + dy*dy))

	var/direction_text = get_precise_direction_between(user_turf, target_turf)
	if(!direction_text)
		direction_text = "unknown direction"
	var/distance_text = "unreachable"
	switch(distance)
		if(0 to 7)
			distance_text = "within your vision"
		if(8 to 14)
			distance_text = "very close"
		if(15 to 40)
			distance_text = "close"
		if(41 to 100)
			distance_text = "distant"
		if(101 to INFINITY)
			distance_text = "far away"

	return "[tracked_target.real_name] is [distance_text], [distance] paces to the [direction_text] [z_level_hint]."

/// Pass an area to this proc and it will return a string if the area is equal to any given "off-level" map. It returns FALSE, otherwise.
/datum/action/cooldown/spell/assassin/proc/are_you_ready_to_enter_my_dark_realm(area/target_area)
	// LIST OF ALL AREAS THAT ARE USED IN PLACES W/O BEING ON LIKE-- THE SAME Z LEVEL. TO PREVENT WEIRD Z-LEVEL SHIT W/ THE TRACKING. WE JUST
	// RETURN A STRING = SOMETHING AKIN TO DEATH WHISPERS. THIS KINDA SUCKS ASS BUT UNLESS WE GOT A DEFINE FOR THE Z LEVELS USED ONLY IN A READIBLE
	// ACCESSIBLE MANNER IDK HOW ELSE TO CHECK IT.
	var/static/list/forbidden_realms = list(
	// WRETCH
	/area/rogue/under/cave/inhumen = "I recognize this place. My target is somewhere beneath the abode for Wretches and Scumbags... likely within the defiled chapel.",
	/area/rogue/outdoors/woods/wretch_lair = "I recognize this place. My target is somewhere beneath the abode for Wretches and Scumbags.",
	// BANDITS
	/area/rogue/indoors/banditcamp = "Jingling coin. Merriment and ale. I can smell the Free-God's domain. He steals away my ability to see clearly.",
	// VAMPIRE
	/area/rogue/indoors/vampire_manor = "I see a vision of a manor, bats, and a glowing red eye. My target's exact location is protected.",
	/area/rogue/outdoors/woods/vampire_lair = "I see a vision of a manor, bats, and a glowing red eye. My target's exact location is protected.",
	// LICH-BASED STUFF
	/area/rogue/indoors/lich_start = "A chill creeps up my spine. It reminds me of the Zizoid Cults of old. Perhaps my target is near a liche...?",
	/area/rogue/under/cave/licharena = "A chill creeps up my spine. It reminds me of the Zizoid Cults of old. Perhaps my target is near a liche...?",
	// UNDERWORLD
	/area/rogue/indoors/deathsedge = "I hear veiled whispers. My target is within Necra's Domain.",
	/area/rogue/underworld = "Something is deeply, deeply wrong. My senses tell me my target is somewhere in the Underworld.",
	// SPECIAL
	/area/rogue/indoors/eventarea = "My HEART POUNDS. My target is hidden somewhere special.",
	/area/rogue/indoors/ravoxarena = "Clamorous battle! My head hurts... my target has been transported into Ravox's domain!",
	// HAG
	/area/rogue/indoors/shelter/bog_hag = "The foul magicks of faerie-creachers surrounds my target. A hag has taken what I desire."
	)
	if(!target_area)
		return FALSE
	for(var/path in forbidden_realms)
		if(istype(target_area, path))
			return forbidden_realms[path]
	return FALSE
	// in the long term it is (probably) for the best if assassins get a spot on the wretch-map w/ some sort of idol where they can recall
	// their dagger if it's in any of these areas.


/datum/action/cooldown/spell/assassin/get_dagger
	name = "Summon Dagger"
	desc = span_cult("Summon your personal Profane Dagger. ") + "Your dagger is required for a number of your abilities. By using the 'PECULATE' intent, \
	you can steal the faces of viable dead-or-dying targets. This also captures the souls of those marked by Graggar. Your dagger is unable to be destroyed \
	by normal means, but a Necran rite, or perhaps some other odd happening can render it naught but smoke.\
	\nYou get one dagger. Make it count."
	click_to_activate = FALSE
	sound = null
	ignore_can_speak = TRUE
	spell_requirements = SPELL_REQUIRES_HUMAN
	charge_required = FALSE

/datum/action/cooldown/spell/assassin/get_dagger/cast(atom/cast_on)
	. = ..()
	var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/new_dagger = new(get_turf(owner))
	owner.put_in_active_hand(new_dagger, TRUE)
	var/datum/antagonist/assassin/my_owner = owner.mind.has_antag_datum(/datum/antagonist/assassin, TRUE)
	my_owner.my_dagger = new_dagger
	new_dagger.dominator = owner
	// little more flavor cus its cool
	var/static/list/lines = list(
		"I'M SO EXCITED!",
		"The pact is sealed!",
		"WE'VE BEEN WAITING FOR YOU!",
		"About TIME!",
		"I'm so hungry...",
		"A man speaks a name-- we do the rest!",
		"...you've changed, or am I imagining things?",
		"So many names on our lips...",
		"DISCARD YOUR HIDDEN FLESH!",
		"This blood is yours to weep!",
		// THIS IS ONENESS & ANNIHILATION
		"...and who are you?"
	)
	var/picked_message = pick(lines)
	to_chat(owner, "<span style='color:#3F5C6D'>The profane dagger</span> whispers, " + span_artery("<i>\"[picked_message]\"</i>"))
	owner.playsound_local(owner, 'sound/misc/zizo.ogg', 10, FALSE)
	grant_innate_spells(owner)
	src.Remove(owner)


/datum/action/cooldown/spell/assassin/get_dagger/proc/grant_innate_spells(mob/owner)
	if(owner)
		var/datum/action/cooldown/spell/assassin/get_targets/A = new
		var/datum/action/cooldown/spell/assassin/find_dagger/B = new
		A.Grant(owner)
		B.Grant(owner)

// This spell just lets you find the dagger that's attached to your datum. Significantly less cooldown.
/datum/action/cooldown/spell/assassin/find_dagger
	name = "Locate Dagger"
	desc = "Find your personal profane dagger."
	click_to_activate = FALSE
	// overriden in spell_feedback as we pick from 3 sounds
	sound = 'sound/misc/bleed (1).ogg'
	// mutes get a unique emote invocation as spell_feedback
	ignore_can_speak = TRUE
	invocation_type = INVOCATION_WHISPER
	invocations = list("For the harsh path, a violent way.",
						"Sing to me, bluebird..."
	)
	spell_requirements = SPELL_REQUIRES_HUMAN
	charge_required = FALSE
	cooldown_time = 20 SECONDS
	button_icon_state = "find_dagger_alt"

/datum/action/cooldown/spell/assassin/find_dagger/after_cast(atom/cast_on)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/directions = "Something is wrong..."
	directions = get_tracking_directions(H)
	to_chat(H, directions)

/datum/action/cooldown/spell/assassin/find_dagger/spell_feedback(mob/living/invoker)
	if(!invoker)
		return
	if(!invoker.can_speak_vocal())
		invocation_type = INVOCATION_EMOTE
		invocations = list(span_artery("%CASTER subtly smiles."), span_artery("%CASTER grins wildly."))
	. = ..()


/datum/action/cooldown/spell/assassin/find_dagger/proc/get_tracking_directions(mob/living/user)
	// this is going to be sloppy im sorry
	if(!user)
		return span_warning("What...?")
	var/datum/antagonist/assassin/assassin_datum = user.mind.has_antag_datum(/datum/antagonist/assassin)
	if(!assassin_datum)
		return span_warning("I am not an assassin!")
	if(!assassin_datum.my_dagger)
		return span_warning("My dagger is unbound, missing, or destroyed!")
	// declare this here for overriding later
	var/found_directions
	// ok we have a dagger and all
	var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/evil_dagger = assassin_datum.my_dagger

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(evil_dagger)

	// (i think) this is a lowkey genius idea & less expensive than getallcontents'ing a mob
	if(user_turf == target_turf)
		return "<span style='color:#3F5C6D'>The profane dagger</span> whispers, " + span_cult("<i>\"I'm right here!\"</i>")
	if(!user_turf)
		return span_warning("My dagger is unbound, missing, or destroyed!")
	if(!target_turf)
		return span_warning("My dagger is unbound, missing, or destroyed!")
	// hacked quest code. they get a proper homing beacon cus this only goes off 1/ a min.

	if(are_you_ready_to_enter_my_dark_realm(get_area(user)))
		return span_warning("The location I am in bears some sort of protective workings. I will not be able to search for my knife within this domain.")
	// if the knife is in a forbidden realm, give some info then stop the proc.
	var/dark_realm_target_text = are_you_ready_to_enter_my_dark_realm(get_area(evil_dagger))
	if(dark_realm_target_text)
		to_chat(span_cult("...something is wrong. I feel a tingle, a vision."))
		return span_warning(dark_realm_target_text)


	var/z_level_hint = ""
	if(target_turf.z != user_turf.z)
		var/z_diff = abs(target_turf.z - user_turf.z)
		z_level_hint = target_turf.z > user_turf.z ? \
			"[z_diff] level\s above me" : \
			"[z_diff] level\s below me"
	else
		z_level_hint = "on this level"

	var/dx = target_turf.x - user_turf.x
	var/dy = target_turf.y - user_turf.y
	var/distance = round(sqrt(dx*dx + dy*dy))

	var/direction_text = get_precise_direction_between(user_turf, target_turf)
	if(!direction_text)
		direction_text = "unknown direction"
	var/distance_text = "unreachable"
	switch(distance)
		if(0 to 7)
			distance_text = "within my vision"
		if(8 to 14)
			distance_text = "very close"
		if(15 to 40)
			distance_text = "close"
		if(41 to 100)
			distance_text = "distant"
		if(101 to INFINITY)
			distance_text = "far away"

	found_directions = span_artery("My [evil_dagger.name] is [distance_text], [distance] paces to the [direction_text] [z_level_hint].")

	return found_directions
