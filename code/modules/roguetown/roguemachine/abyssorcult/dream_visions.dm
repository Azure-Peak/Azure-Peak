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

/datum/component/vision_quest_tracker/Initialize(datum/vision_quest/quest_datum, mob/target_mob, obj/structure/roguemachine/ritual_rune/rune, chosen_reward, bonus_reward)
	if(!istype(quest_datum, /datum/vision_quest) || !istype(target_mob) || !istype(rune))
		return COMPONENT_INCOMPATIBLE
	quest = quest_datum
	target_ref = WEAKREF(target_mob)
	reward_rune_ref = WEAKREF(rune)
	seeker = parent
	chosen_reward_path = chosen_reward
	bonus_reward_path = bonus_reward

	RegisterSignal(parent, COMSIG_MOB_SAY, PROC_REF(on_say))
	to_chat(seeker, span_purple("Vision granted: [quest.name]"))
	to_chat(seeker, span_notice("[quest.description]"))
	to_chat(seeker, span_purple("The vision unfolds before you:"))
	to_chat(seeker, span_notice("[quest.vision_text]"))
	var/mob/target = target_ref?.resolve()
	if(target)
		to_chat(seeker, span_warning("You must say \"[quest.required_phrase]\" within two tiles of [target.real_name]."))
		temporary_target_scry()
	else
		to_chat(seeker, span_warning("The vision's target has faded from this world..."))
		qdel(src)

/datum/component/vision_quest_tracker/proc/on_say(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[1]
	var/lower_message = lowertext(message)
	var/lower_phrase = lowertext(quest.required_phrase)
	if(findtext(lower_message, lower_phrase))
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

	to_chat(seeker, span_purple("Your mind pierces the veil to glimpse your target... You have 4 seconds."))
	addtimer(CALLBACK(eye, TYPE_PROC_REF(/mob/dead/observer/eye/arcane, cancel_scry)), 4 SECONDS)
	return TRUE
