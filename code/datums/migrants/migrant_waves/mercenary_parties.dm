// Trio of Mercenaries - triumph only wave. 66 triumphs. It can only be summoned by pledging 66 triumphs.

// The Pentarchy - It can naturally roll and can be bought for 55 triumphs, but has some restrictions because at least 4 slots must be filled and the characters must be there. They cover the entire roster.

/datum/migrant_role/migrant_mercenary
	name = "Mercenary"
	role_category = "Mercenary"
	advclass_cat_rolls = list(CTAG_MERCENARY = 20)
	greet_text = "A blade for hire."

/datum/migrant_role/pentarchy
	abstract_type = /datum/migrant_role/pentarchy
	role_category = "Mercenary"

// Frontliner
/datum/migrant_role/pentarchy/vanguard
	name = "The Vanguard"
	advclass_cat_rolls = list(CTAG_MERCPARTY_VANGUARD = 20)
	greet_text = "The frontman of the Pentarchy. Combining gruff charm, bravado, and oftentimes a big weapon. You wade into your foes and cut them apart, rallying the rest around you."

/datum/migrant_role/pentarchy/marksman
	name = "The Marksman"
	advclass_cat_rolls = list(CTAG_MERCPARTY_MARKSMAN = 20)
	greet_text = "The skirmisher of the Pentarchy, you ensure that no prey escape the Pentarchy by planting an arrow or bolt between their eyes - or perhaps in their buttock."

/datum/migrant_role/pentarchy/bravo
	name = "The Bravo"
	advclass_cat_rolls = list(CTAG_MERCPARTY_BRAVO = 20)
	greet_text = "The face of the Pentarchy. A rogue who does not lack for charm. Often short on coins, but have every means to gain them."

// Bruiser
/datum/migrant_role/pentarchy/bulwark
	name = "The Bulwark"
	advclass_cat_rolls = list(CTAG_MERCPARTY_BULWARK = 20)
	greet_text = "The shield of the Pentarchy, set in the heaviest armor or the toughest skin. You will not fall. Be the shield to the rest of the Pentarchy."

/datum/migrant_role/pentarchy/warmage
	name = "The War-Mage"
	advclass_cat_rolls = list(CTAG_MERCPARTY_WARMAGE = 20)
	greet_text = "The destroyer of the Pentarchy. Fire. Ice. Lightning. Earth. Steel. Bring ruin upon your enemies and preferably, not the other four."

/datum/migrant_wave/merc_trio
	name = "Trio of Mercenaries"
	track = MIGRANT_TRACK_SPECIAL
	triumph_only = TRUE
	weight = 0
	triumph_threshold = 66 // 33 * 2
	max_spawns = 1 // a one-time contract - can't be summoned twice in a round
	spawn_landmark = "Pilgrim"
	required_roles = list(
		/datum/migrant_role/migrant_mercenary = 1,
	)
	optional_roles = list(
		/datum/migrant_role/migrant_mercenary = 2,
	)
	greet_text = "Summoned by the promise of lucrative contracts and constant conflicts, you and your fellow sellswords have made your way to Azure Peak to seek fortune."

// The Pentarchy - A band of five thematically constrained mercenaries.
/datum/migrant_wave/pentarchy
	name = "The Pentarchy"
	track = MIGRANT_TRACK_SPECIAL
	weight = 30 // Slightly lower than usual so it is a treat when it rolls
	min_round_time = 30 MINUTES
	max_spawns = 1
	triumph_threshold = 55 // buying the whole party outright costs well more than a natural roll since mercenaries are very impactful
	spawn_landmark = "Pilgrim"
	min_optional_fills = 4 // It's the pentarchy sire, you can only miss one
	optional_roles = list(
		/datum/migrant_role/pentarchy/vanguard = 1,
		/datum/migrant_role/pentarchy/bulwark = 1,
		/datum/migrant_role/pentarchy/marksman = 1,
		/datum/migrant_role/pentarchy/bravo = 1,
		/datum/migrant_role/pentarchy/warmage = 1,
	)
	greet_text = "An unlikely gathering of sellswords, perhaps formed in Azure Peak itself. The news of renewed conflicts and lucrative contracts funded by Azurean coins have lured you here. Make your fortune."
	greet_text_by_fill = list(
		"5" = "The Pentarchy rides whole. United in one company, one purpose - oh, who are we joking about. You five have always been the oddest bedfellow.",
		"4" = "The Pentarchy rides whole! Five blades! United as one! Except for the fifth one! No idea where they went! Guess we're the Tetrarchy now! Hoorah!"
	)
