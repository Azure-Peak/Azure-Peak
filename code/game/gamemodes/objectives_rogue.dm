/datum/objective/bandit
	name = "bandit"
	explanation_text = "Feed valuables to the idol."

/datum/objective/bandit/check_completion()
	if(SSmapping.retainer.bandit_contribute >= SSmapping.retainer.bandit_goal)
		return TRUE

/datum/objective/bandit/update_explanation_text()
	..()
	explanation_text = "Feed [SSmapping.retainer.bandit_goal] mammon to an idol of greed."


/datum/objective/delf
	name = "delf"
	explanation_text = "Feed honeys to the mother."

/datum/objective/delf/check_completion()
	if(SSmapping.retainer.delf_contribute >= SSmapping.retainer.delf_goal)
		return TRUE

/datum/objective/delf/update_explanation_text()
	..()
	explanation_text = "Feed [SSmapping.retainer.delf_goal] honeys to the mother."

/datum/objective/werewolf
	name = "conquer"
	explanation_text = "You are touched by the Mad God of the Wilds, Dendor - be it through a bite... Or a terrible blessing. And you are SO, SO VERY HUNGRY. The form Dendor promises will be fearsome, but the transition will be agonizing. Fear not the full moon - and let the feast begin."
	team_explanation_text = "Lycanthropy is a terrible disease that's been recorded in scattered accounts going back hundreds of years. Whatever madness drove Dendor to create such an aberration is beyond mortal minds - and whatever the reason, he has been unwilling or unable to undo it. Nightly transformations and prodigious increases in mass drive the body into an active state of insatiable starvation, driving animalistic, rabid behavior."
	triumph_count = 5

/datum/objective/werewolf/check_completion()
	if(vampire_werewolf() == "werewolf")
		return TRUE

/datum/objective/vampire
	name = "conquer"
	explanation_text = "Put an end to the werewolf menace in Azure Peak, or unite with them against the forces of the Nine."
	team_explanation_text = "The feud between werewolves and vampires reaches back to the dawn of time. Will the two factions destroy each other, or find a way to coexist and face the mortals of Azure Peak together?"
	triumph_count = 5

/datum/objective/vampire/check_completion()
	if(vampire_werewolf() == "vampire")
		return TRUE
