/datum/vision_quest
	/// Name of the quest
	var/name = "Vision Quest"
	/// Description shown to player
	var/description = ""
	/// Parchment tier required (1-3)
	var/required_tier = 1
	/// The phrase the player must say near target
	var/required_phrase = ""
	/// List of reward types (assoc list: path -> amount)
	var/list/rewards = list()
	/// Two bonus resources (assoc list)
	var/list/bonus_rewards = list()

/datum/vision_quest/proc/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	// Override in subtypes
	return TRUE

/datum/vision_quest/proc/get_reward_list()
	. = rewards.Copy()
	for(var/path in bonus_rewards)
		.[path] += bonus_rewards[path]

/datum/vision_quest/orthodox_hunt
	name = "Heretic's Folly"
	description = "An Orthodoxist stands in defiance of the old ways. Confront them with the phrase 'Your faith is a hollow echo' and witness their doubt."
	required_tier = 1
	required_phrase = "Your faith is a hollow echo"
	rewards = list(/obj/item/ingot/sylveric = 1)
	bonus_rewards = list(/obj/item/reagent_containers/food/snacks/rogue/meat = 2)

/datum/vision_quest/orthodox_hunt/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(target == seeker) return FALSE
	if(!target.mind) return FALSE
	if(target.mind.assigned_role == "Orthodoxist")
		return TRUE
	return FALSE

// Example quest: A knight's pride
/datum/vision_quest/knight_challenge
	name = "Cracked Armor"
	description = "A knight's arrogance must be broken. Whisper 'The old gods remember your oaths' near them."
	required_tier = 2
	required_phrase = "The old gods remember your oaths"
	rewards = list(/obj/item/ingot/sylveric = 2, /obj/item/roguegem/blue = 1)
	bonus_rewards = list(/obj/item/roguecoin/silver = 3)

/datum/vision_quest/knight_challenge/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(target == seeker) return FALSE
	if(!target.mind) return FALSE
	if(target.mind.assigned_role in list("Knight", "Sergeant", "Templar"))
		return TRUE
	return FALSE

// Example quest: Abyssor follower
/datum/vision_quest/abyssor_follower
	name = "The Deep Father's Gaze"
	description = "One who follows Abyssor must be reminded of his true form. Say 'The tide does not forgive' near them."
	required_tier = 1
	required_phrase = "The tide does not forgive"
	rewards = list(/obj/item/ingot/sylveric = 1)
	bonus_rewards = list(/obj/item/reagent_containers/glass/bottle = 1)

/datum/vision_quest/abyssor_follower/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(target == seeker) return FALSE
	if(!target.mind) return FALSE
	if(target.patron?.type == /datum/patron/divine/abyssor)
		return TRUE
	return FALSE

/datum/component/vision_quest_tracker
	var/datum/vision_quest/quest
	var/mob/living/carbon/human/target
	var/mob/living/carbon/human/seeker
	var/obj/structure/roguemachine/ritual_rune/reward_rune

/datum/component/vision_quest_tracker/Initialize(datum/vision_quest/quest_datum, mob/target_mob, obj/structure/roguemachine/ritual_rune/rune)
	if(!istype(quest_datum, /datum/vision_quest) || !istype(target_mob) || !istype(rune))
		return COMPONENT_INCOMPATIBLE
	quest = quest_datum
	target = target_mob
	reward_rune = rune
	seeker = parent
	RegisterSignal(parent, COMSIG_MOB_SAY, PROC_REF(on_say))
	to_chat(seeker, span_purple("Vision granted: [quest.name]"))
	to_chat(seeker, span_notice("[quest.description]"))
	to_chat(seeker, span_warning("You must say \"[quest.required_phrase]\" within two tiles of [target.real_name]."))

/datum/component/vision_quest_tracker/proc/on_say(mob/speaker, message)
	SIGNAL_HANDLER

	if(speaker != seeker)
		return
	if(findtext(message, quest.required_phrase))
		var/dist = get_dist(seeker, target)
		if(dist <= 2 && target.stat != DEAD)
			complete_quest()
		else
			to_chat(seeker, span_warning("The vision flickers - you are not close enough to [target.real_name] or they are not present."))

/datum/component/vision_quest_tracker/proc/complete_quest()
	var/turf/T = get_turf(reward_rune)
	if(T)
		var/list/reward_list = quest.get_reward_list()
		for(var/reward_path in reward_list)
			var/amount = reward_list[reward_path]
			for(var/i in 1 to amount)
				new reward_path(T)
		to_chat(seeker, span_green("The vision solidifies! Your rewards appear at the ritual rune."))
	else
		to_chat(seeker, span_warning("The ritual rune is gone! Your rewards are lost."))
	qdel(src)

/datum/component/vision_quest_tracker/Destroy()
	UnregisterSignal(parent, COMSIG_MOB_SAY)
	quest = null
	target = null
	reward_rune = null
	seeker = null
	return ..()
