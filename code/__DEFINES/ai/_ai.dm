#define GET_AI_BEHAVIOR(behavior_type) SSai_behaviors.ai_behaviors[behavior_type]
#define HAS_AI_CONTROLLER_TYPE(thing, type) istype(thing?.ai_controller, type)
#define AI_STATUS_ON		1
#define AI_STATUS_OFF		2
#define AI_STATUS_IDLE		3

/// INT baseline at which NPC tactical chances are at 100%. Below scales down, above stays capped.
#define AI_INT_BASELINE 10
/// Scales a probability by the pawn's INT relative to baseline. INT 4 = 40%, INT 10 = 100%. Capped at 100%.
#define AI_INT_SCALE_PROB(pawn, chance) prob(min(chance, chance * pawn.STAINT / AI_INT_BASELINE))

///Carbon checks
#define SHOULD_RESIST(source) (source.on_fire || source.buckled || HAS_TRAIT(source, TRAIT_RESTRAINED) || source.pulledby)
#define SHOULD_STAND(source) (source.resting)
#define IS_DEAD_OR_INCAP(source) (source.incapacitated() || source.stat)

// How far should we, by default, be looking for interesting things to de-idle?
#define AI_DEFAULT_INTERESTING_DIST 10

///Max pathing attempts before auto-fail
#define MAX_PATHING_ATTEMPTS 30
///Flags for ai_behavior new()
#define AI_CONTROLLER_INCOMPATIBLE (1<<0)

///Does this task require movement from the AI before it can be performed?
#define AI_BEHAVIOR_REQUIRE_MOVEMENT (1<<0)
///Does this require the current_movement_target to be adjacent and in reach?
#define AI_BEHAVIOR_REQUIRE_REACH (1<<1)
///Does this task let you perform the action while you move closer? (Things like moving and shooting)
#define AI_BEHAVIOR_MOVE_AND_PERFORM (1<<2)
///Does finishing this task not null the current movement target?
#define AI_BEHAVIOR_KEEP_MOVE_TARGET_ON_FINISH (1<<3)
///Does finishing this task make the AI stop moving towards the target?
#define AI_BEHAVIOR_KEEP_MOVING_TOWARDS_TARGET_ON_FINISH (1<<4)
///Does this behavior NOT block planning?
#define AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION (1<<5)
///This behavior executes before all others and does not consume the process tick, allowing normal behaviors to run after it
#define AI_BEHAVIOR_EXECUTE_ALONGSIDE (1<<6)

///Cooldown on planning if planning failed last time
#define AI_FAILED_PLANNING_COOLDOWN 1.5 SECONDS

///Subtree defines
///This subtree should cancel any further planning, (Including from other subtrees)
#define SUBTREE_RETURN_FINISH_PLANNING 1

///AI flags
#define STOP_MOVING_WHEN_PULLED (1<<0)

//Blackboard

//Generic BB keys
#define BB_CURRENT_MIN_MOVE_DISTANCE "min_move_distance"

/// Signal sent when a blackboard key is set to a new value
#define COMSIG_AI_BLACKBOARD_KEY_SET(blackboard_key) "ai_blackboard_key_set_[blackboard_key]"
#define COMSIG_AI_BLACKBOARD_KEY_CLEARED(blackboard_key) "ai_blackboard_key_clear_[blackboard_key]"

///sent from ai controllers when they pick behaviors: (list/datum/ai_behavior/old_behaviors, list/datum/ai_behavior/new_behaviors)
#define COMSIG_AI_CONTROLLER_PICKED_BEHAVIORS "ai_controller_picked_behaviors"
///sent from ai controllers when a behavior is inserted into the queue: (list/new_arguments)
#define AI_CONTROLLER_BEHAVIOR_QUEUED(type) "ai_controller_behavior_queued_[type]"

///Targetting keys for something to run away from, if you need to store this separately from current target
#define BB_BASIC_MOB_FLEE_TARGET "BB_basic_flee_target"
#define BB_BASIC_MOB_FLEE_TARGET_HIDING_LOCATION "BB_basic_flee_target_hiding_location"
#define BB_FLEE_TARGETTING_DATUM "flee_targetting_datum"

#define BB_FUTURE_MOVEMENT_PATH "BB_future_path"
#define BB_RESISTING "BB_resisting"

#define BB_MOB_AGGRO_TABLE "aggro_table" // Associative list of [mob] -> threat_level
#define BB_AGGRO_DECAY_TIMER "aggro_decay_timer"
#define BB_HIGHEST_THREAT_MOB "highest_threat_mob"
#define BB_THREAT_THRESHOLD "threat_threshold" // Minimum threat to be considered hostile
#define BB_AGGRO_RANGE "aggro_range" // Range at which mobs can detect and add threats
#define BB_AGGRO_MAINTAIN_RANGE "aggro_maintain_range" // Range at which target is dropped if exceeded

///time until we should next eat, set by the generic hunger subtree
#define BB_NEXT_HUNGRY "BB_NEXT_HUNGRY"
///what we're going to eat next
#define BB_BASIC_MOB_FOOD_TARGET "BB_basic_food_target"
///what corpse we'll next try to eat
#define BB_BASIC_MOB_CORPSE_TARGET "BB_basic_mob_corpse_target"
///What creature we want to cocoon
#define BB_BASIC_MOB_COCOON_TARGET "BB_basic_mob_cocoon_target"
///Who we want dead above all else...
#define BB_MAIN_TARGET "BB_main_target"
///How many times we'll attack defendants before getting disinterested
#define BB_RETALIATE_ATTACKS_LEFT "BB_relatiate_attacks_left"
#define BB_RETALIATE_COOLDOWN "BB_retaliate_cooldown"

#define BB_BASIC_MOB_TAMED "BB_basic_mob_tamed"

#define BB_WANDER_POINT "BB_wander_point"

#define BB_MOB_EQUIP_TARGET "BB_equip_target"
#define BB_WEAPON_TYPE "BB_weapon_type"
#define BB_ARMOR_CLASS "BB_armorclass"

//farm animals ai
#define BB_CHICKEN_LAY_EGG "BB_chicken_lay_egg"
#define BB_CHICKEN_NESTING_BOX "BB_chicken_nest_box"
#define BB_COW_TIP_REACTING "BB_cow_tip_reacting"
#define	BB_COW_TIPPER "BB_cow_tipper"

//Move then recheck ai
#define MOVEMENT_LOOP_START_FAST (1<<0)

#define SPT_PROB_RATE(prob_per_second, seconds_per_tick) (1 - (1 - (prob_per_second)) ** (seconds_per_tick))
#define SPT_PROB(prob_per_second_percent, seconds_per_tick) (prob(100*SPT_PROB_RATE((prob_per_second_percent)/100, (seconds_per_tick))))

#define BB_HUMAN_BEG_TARGET "human_beg_target"
#define BB_HUMAN_NPC_ATTACK_ZONE_COUNTER "human_npc_attack_zone_counter"
#define BB_HUMAN_NPC_LAST_ATTACK_ZONE    "human_npc_last_attack_zone"
#define BB_HUMAN_NPC_WEAKPOINT           "human_npc_weakpoint"
#define BB_HUMAN_NPC_JUMP_COOLDOWN       "human_npc_jump_cooldown"
#define BB_HUMAN_NPC_FLANK_ANGLE         "human_npc_flank_angle"
#define BB_HUMAN_NPC_FLANK_TARGET        "human_npc_flank_target"
#define BB_HUMAN_NPC_HARASS_MODE         "human_npc_harass_mode"
#define BB_HUMAN_NPC_HARASS_RETREATING   "human_npc_harass_retreating"
#define BB_HUMAN_NPC_HARASS_COOLDOWN     "human_npc_harass_cooldown"
#define BB_HUMAN_NPC_JUKE_COOLDOWN       "human_npc_juke_cooldown"
#define BB_HUMAN_NPC_FEINT_COOLDOWN      "human_npc_feint_cooldown"
#define BB_HUMAN_NPC_TECHNIQUE_CD        "human_npc_technique_cd"
#define BB_AI_ALERT_MODE_UNTIL           "ai_alert_mode_until"
#define AI_ALERT_MODE_DURATION           (30 SECONDS)
#define BB_HUMAN_NPC_CURRENT_INTENT_ATTACKS_LEFT "human_npc_intent_attacks"
#define BB_BEGGING_FOOD_ITEM "item_beg_target"
#define BB_ARCHER_NPC_TARGET_ARROW      "archer_target_arrow"
#define BB_ARCHER_NPC_STASHED_WEAPON    "archer_stashed_weapon"
#define BB_ARCHER_NPC_EQUIPMENT_CACHE_EXPIRY "archer_npc_equipment_cache_expiry"
#define BB_ARCHER_NPC_BOW               "archer_npc_bow"
#define BB_ARCHER_NPC_QUIVER            "archer_npc_quiver"
#define BB_INVENTORY_MAP        "inventory_map"        // list(category = list(item_ref = slot_name))
#define BB_CONTAINER_REFS       "container_refs"       // list(slot_name = item_ref)
#define BB_INVENTORY_DIRTY      "inventory_dirty"      // bool, triggers reappraisal
#define BB_HELD_CONSUMABLE      "held_consumable"      // item we pulled out to use
#define BB_TARGET_ZONE_OVERRIDE	"bb_target_override"
#define BB_LOOT_TARGET "loot_target"
#define BB_LOOT_TARGET_ITEM "loot_target_item"
#define BB_LOOT_BLACKLIST "loot_blacklist"
#define BB_LOOT_NEXT_SCAN "loot_next_scan"
#define BB_MUG_DEMAND_ELAPSED "mug_elapsed_time"
#define BB_MUG_TARGET "mug_target"
#define BB_MUG_TARGET_ITEM "mug_rootbeer"

#define ARCHER_NPC_EQUIPMENT_CACHE_TIME (40 SECONDS)
#define ARCHER_NPC_MIN_RANGE            3   // tiles - closer than this, prefer melee
#define ARCHER_NPC_ARROW_SEARCH_RANGE   9
#define ARCHER_NPC_SIMULATED_CHARGETIME 1.5 SECONDS // fallback bow charge time
#define ARCHER_NPC_CROSSBOW_CHARGETIME  2.5 SECONDS // crossbows are slower to fire
#define ARCHER_NPC_SLING_CHARGETIME     0.8 SECONDS // slings are fast
#define ARCHER_NPC_ROF_PENALTY          1.3   // NPC charge time multiplier (1.3 = 30% slower than calculated)
#define ARCHER_NPC_SPREAD_PER_POINT     7     // spread per PER point below 15
#define ARCHER_NPC_ARC_SPREAD_PENALTY   20    // extra spread when arcing over allies

// Keys used by one and only one behavior
// Used to hold state without making bigass lists
/// For /datum/ai_behavior/find_potential_targets, what if any field are we using currently
#define BB_FIND_TARGETS_FIELD(type) "bb_find_targets_field_[type]"


#define AI_ITEM_BANDAGE         (1<<0)   // stops bleeding, applied to self/others
#define AI_ITEM_HEALING_DRINK   (1<<1)   // drinkable healing reagent container
#define AI_ITEM_FOOD            (1<<2)   // edible
#define AI_ITEM_POWDER          (1<<3)   // snortable /obj/item/reagent_containers/powder
#define AI_ITEM_KEY             (1<<4)
#define AI_ITEM_TOOL            (1<<5)
#define AI_ITEM_AMMO            (1<<6)
#define AI_ITEM_GRENADE         (1<<7)
#define AI_ITEM_MELEE           (1<<8)
#define AI_ITEM_GUN             (1<<9)
#define AI_ITEM_DRINK           (1<<10)  // generic drinkable (not necessarily healing)
#define AI_ITEM_THROWING        (1<<11)
#define AI_ITEM_QUIVER          (1<<12)

GLOBAL_LIST_INIT(ai_item_flags, list(
	AI_ITEM_BANDAGE,
	AI_ITEM_HEALING_DRINK,
	AI_ITEM_FOOD,
	AI_ITEM_POWDER,
	AI_ITEM_KEY,
	AI_ITEM_TOOL,
	AI_ITEM_AMMO,
	AI_ITEM_GRENADE,
	AI_ITEM_MELEE,
	AI_ITEM_GUN,
	AI_ITEM_DRINK,
	AI_ITEM_THROWING,
	AI_ITEM_QUIVER,
))

#define AI_INVENTORY_WATCHED_SLOTS (ITEM_SLOT_BELT | ITEM_SLOT_BACK_L | ITEM_SLOT_BACK_R | \
    ITEM_SLOT_HIP | ITEM_SLOT_ARMOR | ITEM_SLOT_PANTS | \
    ITEM_SLOT_SHIRT | ITEM_SLOT_CLOAK | ITEM_SLOT_BACK | ITEM_SLOT_NECK | ITEM_SLOT_WRISTS)


