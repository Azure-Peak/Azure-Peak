// Martial/warrior archetypes

/datum/statpack/physical/trained
	name = "Trained"
	desc = "Years honing your physique has left you with a physical edge, but your faculties have been somewhat neglected."
	ui_fa_icon = "baseball-bat-ball"
	stat_array = list(STAT_STRENGTH = 1, STAT_CONSTITUTION = 1, STAT_WILLPOWER = 1, STAT_PERCEPTION = -1, STAT_INTELLIGENCE = -1)

/datum/statpack/physical/muscular
	name = "Muscular"
	desc = "Hard labor has honed you into a mass of sinew - a valuable trait in a world where might makes right."
	ui_fa_icon = "dumbbell"
	stat_array = list(STAT_STRENGTH = 2, STAT_CONSTITUTION = 1, STAT_PERCEPTION = -1, STAT_SPEED = -2)

/datum/statpack/physical/tactician
	name = "Alert"
	desc = "You sharpened both your body and your mind as best you were able, and vigilance has been your reward."
	ui_fa_icon = "triangle-exclamation"
	stat_array = list(STAT_STRENGTH = 1, STAT_PERCEPTION = 1, STAT_INTELLIGENCE = 1, STAT_CONSTITUTION = -1, STAT_WILLPOWER = -1)

/datum/statpack/physical/taut
	name = "Taut"
	desc = "Wound tight like the limbs of a time-teller, your physicality is poised to strike - or flee - at a moment's notice."
	ui_fa_icon = "staff-snake"
	stat_array = list(STAT_STRENGTH = 1, STAT_WILLPOWER = 1, STAT_SPEED = 1, STAT_PERCEPTION = -2, STAT_CONSTITUTION = -1)

/datum/statpack/physical/toil
	name = "Toil-hardened"
	desc = "Your lyfe, hard-lyved, has imparted one solitary adage: carry on above all else. And so you endure."
	ui_fa_icon = "person-digging"
	stat_array = list(STAT_WILLPOWER = 2, STAT_CONSTITUTION = 1, STAT_PERCEPTION = -1, STAT_INTELLIGENCE = -1)

/datum/statpack/physical/struggler
	name = "Struggler"
	desc = "Lyfe's dealt you a poor hand, so you've opted to simply flip the table instead."
	ui_fa_icon = "person-hiking"
	stat_array = list(STAT_STRENGTH = 2, STAT_CONSTITUTION = 2, STAT_WILLPOWER = 2, STAT_INTELLIGENCE = -3, STAT_PERCEPTION = -3, STAT_FORTUNE = -2)

/datum/statpack/physical/enduring
	name = "Enduring"
	desc = "You've spent yils willingly submitting your body through a most perilous journey. Stalwart in your faith, you've sworn to never flee again."
	ui_fa_icon = "heart"
	stat_array = list(STAT_CONSTITUTION = 3, STAT_WILLPOWER = 3, STAT_SPEED = -4)
