/datum/chimeric_tech_node
	// Make sure this identifier is unique
	var/name = "Base Node"
	var/description = "This is the default description."
	var/tech_path // The path of the actual implementation datum/object
	var/string_id = "BASE_NODE" // Used to find the datums in the tech subsytem

	var/unlocked = FALSE
	var/is_recipe_node = FALSE

	var/required_tier = 1        	// Heartbeast Language Tier requirement
	var/cost = 50                	// Tech Points cost
	var/list/prerequisites = list() // List of required node paths
	var/recipe_override = null

	var/selection_weight = 10    // Higher number = more likely to appear

/// HEALING MIRACLE TECHS
/datum/chimeric_tech_node/awaken_healing
	name = "Awaken divine regeneration"
	description = "Clears the veil weakening healing miracles in this region, improving healing miracles greatly."
	string_id = "HEAL_TIER1"
	required_tier = 1
	cost = 15
	selection_weight = 15

/datum/chimeric_tech_node/enhanced_healing
	name = "Enhance divine regeneration"
	description = "Increases the healing of most healing miracles slightly."
	string_id = "HEAL_TIER2"
	required_tier = 3
	cost = 85
	selection_weight = 15
	prerequisites = list("HEAL_TIER1") 

/datum/chimeric_tech_node/awaken_resurrection
	name = "Awaken divine resurrection"
	description = "Decreases the cooldown of resurrection miracles significantly."
	string_id = "REVIVE_TIER1"
	required_tier = 2
	cost = 40
	selection_weight = 50
	prerequisites = list("HEAL_TIER1")

/datum/chimeric_tech_node/enhanced_resurrection
	name = "Enhance divine resurrection"
	description = "Decreases the cost of resurrection miracles significantly."
	string_id = "REVIVE_TIER2"
	required_tier = 3
	cost = 120
	selection_weight = 50
	prerequisites = list("REVIVE_TIER1")

// CRAFTING RECIPE TECHS
/datum/chimeric_tech_node/residual_frankenbrew
	name = "Impure lux filtration"
	description = "Allows making a small amount of revival elixer for fulmenor chairs out of impure lux."
	string_id = "LUX_FILTRATION"
	required_tier = 1
	cost = 5
	selection_weight = 5
	is_recipe_node = TRUE

/datum/chimeric_tech_node/meat_decoy
	name = "meat decoys"
	description = "Allows making flesh decoys out of fresh meat to distract hostile, unintelligent creechurs."
	string_id = "FLESH_DECOYS"
	required_tier = 1
	cost = 5
	selection_weight = 5
	is_recipe_node = TRUE

/datum/chimeric_tech_node/viscera_decoy
	name = "Visceral decoys"
	description = "Allows making flesh decoys out of viscera instead of fresh meat."
	string_id = "VISCERA_DECOYS"
	required_tier = 1
	cost = 5
	selection_weight = 1
	is_recipe_node = TRUE
	prerequisites = list("FLESH_DECOYS")

/datum/chimeric_tech_node/black_rose
	name = "Black Rose Synthesis"
	description = "Allows crafting of black roses from corrupted flesh and beast blood. It is believed heartbeasts were in part created by Pestra herself to control the black rot that lingers withing these roses."
	string_id = "BLACK_ROSE"
	required_tier = 4
	cost = 100
	selection_weight = 2
	prerequisites = list("INFESTATION_TIER3")
	is_recipe_node = TRUE

/datum/chimeric_tech_node/corpse_ticks
	name = "Corpse Ticks"
	description = "Allows leechticks to attach to dead bodies to extract their lux"
	string_id = "CORPSE_TICKS"
	required_tier = 1
	cost = 5
	selection_weight = 1

/// INFESTATION CHARGE CAPACITY TECHS
/datum/chimeric_tech_node/infestation_capacity_1
	name = "Enhanced Infestation Capacity"
	description = "Increases maximum infestation charges to 5."
	string_id = "INFESTATION_TIER1"
	required_tier = 1
	cost = 20
	selection_weight = 10

/datum/chimeric_tech_node/infestation_capacity_2
	name = "Superior Infestation Capacity"
	description = "Increases maximum infestation charges to 9."
	string_id = "INFESTATION_TIER2"
	required_tier = 2
	cost = 30
	selection_weight = 8
	prerequisites = list("INFESTATION_TIER1")

/datum/chimeric_tech_node/infestation_capacity_3
	name = "Reveal The Divine Gift Of Pestra"
	description = "Increases maximum infestation charges to 10. At 10 charges, Master pestrans gain access to Divine Rebirth."
	string_id = "INFESTATION_TIER3"
	required_tier = 3
	cost = 50
	selection_weight = 6
	prerequisites = list("INFESTATION_TIER2")

/datum/chimeric_tech_node/infestation_rot_snacks
	name = "Food Contamination"
	description = "Allows infestation to be cast on food items, rotting them and granting half a charge."
	string_id = "INFESTATION_ROT_SNACKS"
	required_tier = 1
	cost = 8
	selection_weight = 4

/datum/chimeric_tech_node/infestation_rot_multiple_1
	name = "Spread Contamination"
	description = "Infestation now affects 1 additional nearby food item when cast on snacks."
	string_id = "INFESTATION_ROT_MULTIPLE_1"
	required_tier = 2
	cost = 25
	selection_weight = 10
	prerequisites = list("INFESTATION_ROT_SNACKS")

/datum/chimeric_tech_node/infestation_rot_multiple_2
	name = "Mass Contamination"
	description = "Infestation now affects 3 additional nearby food items when cast on snacks."
	string_id = "INFESTATION_ROT_MULTIPLE_2"
	required_tier = 3
	cost = 40
	selection_weight = 8
	prerequisites = list("INFESTATION_ROT_MULTIPLE_1")

/datum/chimeric_tech_node/infestation_attack_vector
	name = "Virulent blade"
	description = "Pestilent blade now has a small chance to trigger when landing a succesful blow, even whilst the target isn't infected."
	string_id = "INFESTATION_ATTACK_VECTOR"
	required_tier = 1
	cost = 5
	selection_weight = 2
