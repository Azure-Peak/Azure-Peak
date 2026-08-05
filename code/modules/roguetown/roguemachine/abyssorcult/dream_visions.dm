/datum/vision_quest
	/// Name of the quest
	var/name = "Vision Quest"
	/// Description shown to player
	var/description = ""
	/// Parchment tier required (1-3)
	var/required_tier = 1
	/// The phrase the player must say near target
	var/required_phrase = ""
	/// Reward type (singular, player chooses from this pool)
	var/list/possible_rewards = list()
	/// Bonus reward type (random)
	var/list/possible_bonus_rewards = list()
	/// Type of target description
	var/target_description = "a heretic"
	/// Short summary shown in menu
	var/summary = "A vision of judgment..."
	/// Long vision text printed to chat
	var/vision_text = "You see a vision of..."
	/// List of possible phrases to generate
	var/list/possible_phrases = list()
	/// Optional list of job/role strings that are valid targets for this quest
	// These are generic by default. Antags typically excluded to avoid meta reveals.
	var/list/valid_roles = list(
		"Orthodoxist",
		"Absolver",
		"Templar",
		"Sergeant",
		"Men-at-arms",
		"Knight",
		"Squire",
		"Mercenary",
		"Warden",
		"Adventurer",
		"Towner",
		"Acolyte",
		"Keeper",
		"Bishop",
		"Sexton",
		"Martyr",
		"Druid",
		"Cook",
		"Servant",
		"Shophand",
		"Soilson",
		"Tapster",
		"Councillor",
		"Archivist",
		"Clerk",
		"Hand",
		"Jester",
		"Court Magician",
		"Seneschal",
		"Steward",
		"Suitor",
		"Apothecary",
		"Town Crier",
		"Guildmaster",
		"Guildsman",
		"Innkeeper",
		"Magicians Associate",
		"Merchant",
		"Head Physician",
		"Tailor"
	)

/datum/vision_quest/proc/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(!target || target == seeker)
		return FALSE
	if(target.stat == DEAD)
		return FALSE
	if(!target.mind)
		return FALSE
	// I'm- not sure how else to prevent abyssorites from seeing emotional roleplay too often.
	// So we'll assume anyone wearing three items or less is doing emotional roleplay.
	if(target.contents && target.contents.len < 4)
		return FALSE
	if(length(valid_roles))
		if(target.mind.assigned_role in valid_roles)
			return TRUE
		return FALSE
	return TRUE

/datum/component/vision_quest_tracker
	var/datum/vision_quest/quest
	var/datum/weakref/target_ref
	var/mob/living/carbon/human/seeker
	var/datum/weakref/reward_rune_ref
	var/chosen_reward_path = null
	var/bonus_reward_path = null
	/// World time when the vision quest was initialized
	var/creation_time = 0
	/// Number of times sleeping has triggered a scry vision
	var/sleep_scry_count = 0
	/// World time when sleep scry was last triggered
	var/last_sleep_scry_time = 0

/datum/component/vision_quest_tracker/Initialize(datum/vision_quest/quest_datum, mob/target_mob, obj/structure/roguemachine/ritual_rune/rune, chosen_reward, bonus_reward)
	if(!istype(quest_datum, /datum/vision_quest) || !istype(target_mob) || !istype(rune))
		return COMPONENT_INCOMPATIBLE

	var/datum/vision_quest/quest_instance = new quest_datum.type()
	quest_instance.name = quest_datum.name
	quest_instance.description = quest_datum.description
	quest_instance.required_tier = quest_datum.required_tier
	quest_instance.required_phrase = quest_datum.required_phrase
	quest_instance.target_description = quest_datum.target_description
	quest_instance.summary = quest_datum.summary
	quest_instance.vision_text = quest_datum.vision_text

	quest = quest_instance
	target_ref = WEAKREF(target_mob)
	reward_rune_ref = WEAKREF(rune)
	seeker = parent
	chosen_reward_path = chosen_reward
	bonus_reward_path = bonus_reward
	creation_time = world.time

	if(ishuman(seeker))
		var/mob/living/carbon/human/H = seeker
		H.verbs += /mob/living/carbon/human/proc/recall_vision_quest

	RegisterSignal(parent, COMSIG_MOB_SAY, PROC_REF(on_say))
	RegisterSignal(parent, COMSIG_MOB_SLEEP, PROC_REF(on_mob_sleep))
	to_chat(seeker, span_purple("Vision granted: [quest.name]"))
	to_chat(seeker, span_notice("[quest.description]"))
	to_chat(seeker, span_purple("The vision unfolds before you:"))
	to_chat(seeker, span_notice("[quest.vision_text]"))
	var/mob/target = target_ref?.resolve()
	if(target)
		to_chat(seeker, span_boldnotice("You must say \"[quest.required_phrase]\" within two tiles of [target.real_name]."))
		to_chat(seeker, span_danger("Do not cause harm to [target.real_name], the waves demand you deliver the message, interfering with prophecy can be dangerous."))
		temporary_target_scry()
	else
		to_chat(seeker, span_warning("The vision's target has faded from this world..."))
		qdel(src)

/datum/component/vision_quest_tracker/proc/on_say(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[1]
	var/clean_message = sanitize_speech_phrase(message)
	var/clean_phrase = sanitize_speech_phrase(quest.required_phrase)
	if(findtext(clean_message, clean_phrase))
		var/mob/target = target_ref?.resolve()
		if(!target)
			to_chat(seeker, span_warning("The vision's target is gone... Your quest is lost."))
			qdel(src)
			return
		var/dist = get_dist(seeker, target)
		if(dist <= 2 && target.stat != DEAD)
			complete_quest()
		else
			to_chat(seeker, span_warning("The vision flickers - you are not close enough to [target.real_name] or they are not present."))

/datum/component/vision_quest_tracker/proc/on_mob_sleep(datum/source)
	SIGNAL_HANDLER

	if(world.time > creation_time + 10 MINUTES)
		to_chat(seeker, span_notice("It's been too long since the initial vision.. my dreams cannot summon my vision's target again."))
		return

	if(sleep_scry_count >= 2)
		to_chat(seeker, span_notice("I've muddied the waters of the dream too much, I cannot see my vision's target in my dreams again."))
		return

	if(last_sleep_scry_time && world.time < last_sleep_scry_time + 1 MINUTES)
		return

	sleep_scry_count++
	last_sleep_scry_time = world.time

	to_chat(seeker, span_purple("Your slumber pulls you back into the vision..."))
	temporary_target_scry()

/datum/component/vision_quest_tracker/proc/sanitize_speech_phrase(phrase)
	var/cleaned = lowertext(phrase)
	cleaned = replacetext(cleaned, "&#39;", "'")
	cleaned = replacetext(cleaned, "&apos;", "'")
	cleaned = replacetext(cleaned, "’", "'")
	cleaned = replacetext(cleaned, "‘", "'")
	return cleaned

/datum/component/vision_quest_tracker/proc/complete_quest()
	var/obj/structure/roguemachine/ritual_rune/rune = reward_rune_ref?.resolve()
	if(rune && !QDELETED(rune))
		var/turf/T = get_turf(rune)
		if(T)
			if(chosen_reward_path)
				for(var/i in 1 to 3)
					new chosen_reward_path(T)
			if(bonus_reward_path)
				for(var/i in 1 to 2)
					new bonus_reward_path(T)
			to_chat(seeker, span_green("The vision solidifies! Your rewards appear at the ritual rune."))
		else
			to_chat(seeker, span_warning("The ritual rune is gone! Your rewards are lost."))
	else
		to_chat(seeker, span_warning("The ritual rune is gone! Your rewards are lost."))
	qdel(src)

/datum/component/vision_quest_tracker/Destroy()
	if(ishuman(seeker))
		var/mob/living/carbon/human/H = seeker
		H.verbs -= /mob/living/carbon/human/proc/recall_vision_quest
	UnregisterSignal(parent, COMSIG_MOB_SAY)
	quest = null
	target_ref = null
	reward_rune_ref = null
	seeker = null
	return ..()

/datum/component/vision_quest_tracker/proc/temporary_target_scry()
	var/mob/living/carbon/human/target = target_ref?.resolve()
	if(!target || target.stat == DEAD)
		to_chat(seeker, span_warning("The vision is too faint to manifest..."))
		return FALSE

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	// Trigger standard eye manifestation
	var/mob/dead/observer/eye/arcane/eye = seeker.scry_ghost(/mob/dead/observer/eye/arcane/abyssor)
	if(!eye)
		return FALSE

	eye.forceMove(target_turf)
	eye.scry_center_turf = target_turf

	to_chat(seeker, span_purple("Your mind pierces the veil to glimpse your target... You have 6 seconds."))
	addtimer(CALLBACK(eye, TYPE_PROC_REF(/mob/dead/observer/eye/arcane, cancel_scry)), 6 SECONDS)
	return TRUE

/mob/living/carbon/human/proc/recall_vision_quest()
	set name = "Recall Vision Quest"
	set category = "RoleUnique.Cleric"
	set desc = "Recall the required phrase, target details, and objectives for your active vision quest."

	var/datum/component/vision_quest_tracker/tracker = GetComponent(/datum/component/vision_quest_tracker)
	if(!tracker || !tracker.quest)
		to_chat(src, span_warning("You do not currently have an active vision quest."))
		return

	var/datum/vision_quest/Q = tracker.quest
	var/mob/target = tracker.target_ref?.resolve()

	to_chat(src, span_purple("--- Vision Quest: [Q.name] ---"))
	to_chat(src, span_notice("Summary: [Q.summary]"))
	if(target)
		to_chat(src, span_boldnotice("Target: [target.real_name]"))
		to_chat(src, span_boldnotice("Required Phrase: \"[Q.required_phrase]\" (Must say within 2 tiles)"))
	else
		to_chat(src, span_danger("Target: [Q.target_description] (Faded from this world)"))
