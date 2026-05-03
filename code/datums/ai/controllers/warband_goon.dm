// essentially the same as the base human_npc 
// except we're DROPPING the Loot, Call for Help & Leap Attack subtrees, and ADDING travel_to_point + outskirts blackboard entries
/datum/ai_controller/human_npc/melee/goon
	ai_movement = /datum/ai_movement/hybrid_pathing/dumb_hybrid_movement/goon
	movement_delay = 0.1 SECONDS
	max_target_distance = 200

	blackboard = list(
		BB_WEAPON_TYPE = /obj/item/rogueweapon,
		BB_ARMOR_CLASS = 2,
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),

		BB_HUMAN_NPC_ATTACK_ZONE_COUNTER = 0,
		BB_HUMAN_NPC_LAST_ATTACK_ZONE = null,
		BB_HUMAN_NPC_WEAKPOINT = null,
		BB_HUMAN_NPC_JUMP_COOLDOWN = 0,
		BB_HUMAN_NPC_FLANK_ANGLE = null,
		BB_HUMAN_NPC_FLANK_TARGET = null,
		BB_HUMAN_NPC_HARASS_MODE = FALSE,
		BB_HUMAN_NPC_HARASS_RETREATING = FALSE,
		BB_HUMAN_NPC_HARASS_COOLDOWN = 0,
		BB_HUMAN_NPC_JUKE_COOLDOWN = 0,
		BB_MOVEMENT_PATH_PROTECTED = FALSE,

		BB_OUTSKIRTS_OBJECTIVE_REF = null,
		BB_OUTSKIRTS_CACHED_PATH = null,
		BB_OUTSKIRTS_REACHED_OBJECTIVE = FALSE,
		BB_OUTSKIRTS_MOVEMENT_START = 0,
		BB_OUTSKIRTS_BESIEGING_MOBS = list(),
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/generic_stand,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,
		/datum/ai_planning_subtree/outskirts_attack,
		/datum/ai_planning_subtree/use_powder,
		/datum/ai_planning_subtree/use_bandage,
		/datum/ai_planning_subtree/use_throwable,
		/datum/ai_planning_subtree/use_healing_drink,
		/datum/ai_planning_subtree/generic_wield,
		/datum/ai_planning_subtree/kick_attack,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/tree_climb,
		/datum/ai_planning_subtree/find_weapon,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
		/datum/ai_planning_subtree/equip_item,
	)
