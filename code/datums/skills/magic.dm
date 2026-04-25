/datum/skill/magic
	abstract_type = /datum/skill/magic
	name = "Magic"
	desc = ""
	randomable_dream_xp = FALSE
	color = "#9f74d6"
	max_skillbook_level = 3

/datum/skill/magic/holy
	name = "Miracles"
	desc = "Gives you access to higher tier of miracles from your patrons."
	expert_name = "Devotee"

/datum/skill/magic/blood
	name = "Hemomancy"
	desc = "Affects Vampiric weapons, and Vampiric Disciplines."
	expert_name = "Sorcerer"

/datum/skill/magic/arcane
	name = "Arcana"
	desc = "Governs arcyne knowledge - improves arcane crafting, and magical identification of sneaking people."
	expert_name = "Arcanist"

/datum/skill/magic/druidic
	name = "Druidism"
	desc = "Currently only increases the tier of animals you are allowed to transform into - capping out at Tier 3."
	expert_name = "Druid"
	max_skillbook_level = 0
