// Miscellaneous/novelty statpacks

/datum/statpack/wildcard/wretched
	name = "Wretched"
	desc = "The cruelty of Enigma leaves many in its wake - you among them. But with her terrible eye turned elsewhere, perhaps it is time for your fortune to be made..."
	stat_array = list(STAT_STRENGTH = -2, STAT_PERCEPTION = -2, STAT_INTELLIGENCE = -2, STAT_CONSTITUTION = -2, STAT_WILLPOWER = -2, STAT_SPEED = -2, STAT_FORTUNE = 3)

/datum/statpack/wildcard/fated
	name = "Fated"
	desc = "The first or the last - let destiny's fickle loom decree what your fate shall be. Allows for a second virtue. Xylixians get better odds!"
	stat_array = list(STAT_STRENGTH = list(-2, 2), STAT_PERCEPTION = list(-2, 2), STAT_INTELLIGENCE = list(-2, 2), STAT_CONSTITUTION = list(-2, 2), STAT_WILLPOWER = list(-2, 2), STAT_SPEED = list(-2, 2), STAT_FORTUNE = list(-2, 2))
	virtuous = TRUE

	/// Stats are locked in once you spawn, so you cant FT and then respawn to re-roll it
	var/list/locked_stat_array = list()

/datum/statpack/wildcard/fated/get_stat_array(mob/living/carbon/human/recipient, mob/dead/new_player/new_player)
	var/player_ckey = recipient.ckey || new_player?.ckey
	var/loaded_slot = recipient.client?.prefs?.loaded_slot || new_player?.client?.prefs?.loaded_slot
	var/key = "[player_ckey]-[loaded_slot]"

	if(locked_stat_array[key])
		return locked_stat_array[key]

	if(recipient.patron == GLOB.patronlist[/datum/patron/divine/xylix])
		var/list/xylixian_array = stat_array.Copy()

		// first, we need to determine how many non-fortune stats there are
		var/non_fortune_stats = 0
		for(var/stat_key in xylixian_array)
			if(stat_key == STAT_FORTUNE)
				continue
			non_fortune_stats++

		// now, we need to determine how many of them will be given a better result
		var/enchanted_stats = rand(0, non_fortune_stats)

		for(var/stat_key in shuffle(xylixian_array))
			if(stat_key == STAT_FORTUNE)
				xylixian_array[stat_key] = list(0, 2)
			else
				if(enchanted_stats > 0)
					xylixian_array[stat_key] = list(-1, 2)
					enchanted_stats--
				else
					xylixian_array[stat_key] = list(-2, 2)
		return xylixian_array
	return ..()

/datum/statpack/wildcard/fated/post_apply(mob/living/carbon/human/recipient, mob/dead/new_player/new_player, list/applied_stats)
	var/player_ckey = recipient.ckey || new_player?.ckey
	var/loaded_slot = recipient.client?.prefs?.loaded_slot || new_player?.client?.prefs?.loaded_slot
	var/key = "[player_ckey]-[loaded_slot]"

	// lock in the stats
	locked_stat_array[key] = applied_stats.Copy()

	var/list/messages = list("Fate has adjusted your statblock as such...")
	if(recipient.patron == GLOB.patronlist[/datum/patron/divine/xylix])
		messages += span_notice("Xylix smiles upon you, believer!")
	messages += ""
	for(var/stat_key in applied_stats)
		var/value = applied_stats[stat_key]
		var/message = "[capitalize(stat_key)]: [value]"
		if(value > 0)
			messages += span_green(message)
		else if(value == 0)
			messages += span_notice(message)
		else
			messages += span_red(message)

	if(recipient.ckey)
		to_chat(recipient, examine_block(messages.Join("\n")))
	else if(new_player?.ckey)
		to_chat(new_player, examine_block(messages.Join("\n")))

/datum/statpack/wildcard/frail
	name = "Frail"
	desc = "The growing dark limns your vision more with every passing day: your flesh and mind are failing you, and destiny has turned her gaze from you. How will your tale endure such hardship?"
	stat_array = list(STAT_STRENGTH = -4, STAT_PERCEPTION = -4, STAT_INTELLIGENCE = -4, STAT_CONSTITUTION = -4, STAT_WILLPOWER = -4, STAT_SPEED = -4, STAT_FORTUNE = -4)

/datum/statpack/wildcard/austere
	name = "Austere"
	desc = "You've kept your humors balanced, your body honed and mind sharp enough. Fate has left you mostly unchanged, in every way."

/datum/statpack/wildcard/virtuous
	name = "Virtuous"
	desc = "The breadth of my being is one of many, distinguished talents. \n (Allows access to 'virtues', special traits/quirks that replace the bonus normally given by a statpack.)"
	virtuous = TRUE

