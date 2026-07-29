// Assassin, cultist of graggar. Normally found as a drifter.
// Requires at least one living player with the Hunted flaw, otherwise no assassins spawn.
// Roundstart scaling (storyteller_scale_slots): scaling=1, min_players=20, default_cap=2.
//  Cap | <20 | 20-49 | 50+
//   2  |  0  |   1   |  2
/datum/antagonist/assassin
	name = "Assassin"
	roundend_category = "assassins"
	antagpanel_category = "Assassin"
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "assassin"
	show_name_in_check_antagonists = TRUE
	show_in_antagpanel = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_ROUNDSTART | STORYTELLER_ANTAG_SOFT
	override_candidatereq = TRUE
	storyteller_min_players = CHARACTER_INJECTION_MIN_POP
	storyteller_slot_scaling = 1
	storyteller_slot_default_cap = 2
	confess_lines = list(
		"MY CREED IS BLOOD!",
		"THE DAGGER TOLD ME WHO TO CUT!",
		"DEATH IS MY DEVOTION!",
		"THE DARK SUN GUIDES MY HAND!",
		"ALL HAIL HE-WHO-HARVESTS!",
	)
	antag_flags = FLAG_FAKE_ANTAG
	/// This is the assassin's bound dagger, which we can reference for later spells.
	var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/my_dagger

	var/traits_assassin = list(
		TRAIT_ASSASSIN,
		TRAIT_NOSTINK,
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
	)

/datum/antagonist/assassin/on_gain()
	owner.current.cmode_music = list('sound/music/cmode/antag/combat_thewall.ogg') // placeholder until a violent way is released
	// TODO: TO_CHAT
	// TODO: GRANT SPELLS
	var/datum/action/cooldown/spell/assassin/get_dagger/A = new
	A.Grant(owner.current)
	return ..()


/datum/antagonist/assassin/on_removal()
	if(!silent && owner.current)
		// TODO: TO_CHAT
		to_chat(owner.current,"<span class='danger'>The red fog in my mind is fading. I am no longer an [name]!</span>")
	return ..()

/datum/antagonist/assassin/roundend_report()
	var/traitorwin = FALSE
	for(var/obj/item/I in owner.current.GetAllContents()) // Check to see if the Assassin has their profane dagger on them, and then check the souls contained therein.
		if(istype(I, /obj/item/rogueweapon/huntingknife/idagger/steel/profane))
			var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pissdagger = I
			for(var/datum/profane_soul_data/soul in pissdagger.stored_souls) // Each trapped soul is announced to the server
				if(soul)
					to_chat(world, "The soul of [soul.name] has been stolen for Graggar by [owner.name].<span class='greentext'>DAMNATION!</span>")
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
		var/is_valid_prey = is_hunted
		if(is_valid_prey)
			var/entry_name = "[L.real_name]"
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
	button_icon_state = "find_dagger"


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
