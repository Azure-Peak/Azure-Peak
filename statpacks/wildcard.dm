// Miscellaneous/novelty statpacks

/datum/statpack/wildcard/wretched
	name = "Wretched"
	desc = "The cruelty of Enigma leaves many in its wake - you among them. But with her terrible eye turned elsewhere, perhaps it is time for your fortune to be made..."
	stat_array = list(STAT_STRENGTH = -2, STAT_PERCEPTION = -2, STAT_INTELLIGENCE = -2, STAT_CONSTITUTION = -2, STAT_WILLPOWER = -2, STAT_SPEED = -2, STAT_FORTUNE = 3)

/datum/statpack/wildcard/fated
	name = "Fated"
	desc = "The first or the last - let destiny's fickle loom decree what your fate shall be. Allows for a second virtue."
	stat_array = list(STAT_STRENGTH = list(-2, 2), STAT_PERCEPTION = list(-2, 2), STAT_INTELLIGENCE = list(-2, 2), STAT_CONSTITUTION = list(-2, 2), STAT_WILLPOWER = list(-2, 2), STAT_SPEED = list(-2, 2), STAT_FORTUNE = list(-2, 2))
	virtuous = TRUE

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

