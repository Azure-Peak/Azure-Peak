/// Base human NPC controller. Holds infrastructure shared by all humanoid NPC archetypes:
/// movement settings, targeting, common subtrees, and signal wiring. Do not assign this
/// controller directly — use /melee or /archer subtypes.
/datum/ai_controller/human_npc
	movement_delay = 0.1 SECONDS
	max_target_distance = 13
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_WEAPON_TYPE = /obj/item/rogueweapon,
		BB_ARMOR_CLASS = 2,
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),

		BB_HUMAN_NPC_ATTACK_ZONE_COUNTER = 0,  // how many times we've hit the same zone
		BB_HUMAN_NPC_LAST_ATTACK_ZONE = null,  // last zone we attacked
		BB_HUMAN_NPC_WEAKPOINT = null,         // cached weakpoint zone if we found one
		BB_HUMAN_NPC_JUMP_COOLDOWN = 0,        // world.time when we can next jump
		BB_HUMAN_NPC_FLANK_ANGLE = null,       // our claimed flank direction (degrees, 0-359)
		BB_HUMAN_NPC_FLANK_TARGET = null,      // the turf we're moving toward for flanking
		BB_HUMAN_NPC_HARASS_MODE = FALSE,      // TRUE when in hit-and-run mode
		BB_HUMAN_NPC_HARASS_RETREATING = FALSE,// TRUE when in the back-off phase of harass
		BB_HUMAN_NPC_HARASS_COOLDOWN = 0,      // world.time before we can dart in again
		BB_HUMAN_NPC_JUKE_COOLDOWN = 0,        // world.time before we can juke again
	)
	/// Subtrees shared by all human NPC archetypes. Subtypes prepend archetype-specific
	/// subtrees via their own planning_subtrees list.
	planning_subtrees = list(
		// /datum/ai_planning_subtree/pet_planning, - TEMP COMMENT OUT
		/datum/ai_planning_subtree/call_for_help,
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/use_powder,
		/datum/ai_planning_subtree/use_bandage,
		/datum/ai_planning_subtree/use_throwable,
		/datum/ai_planning_subtree/use_healing_drink,
		/datum/ai_planning_subtree/generic_wield,
		/datum/ai_planning_subtree/kick_attack,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/generic_stand,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/tree_climb,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/leap_attack,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,
		/datum/ai_planning_subtree/find_weapon,
		/datum/ai_planning_subtree/equip_item,
		/datum/ai_planning_subtree/loot,
	)

/datum/ai_controller/human_npc/TryPossessPawn(atom/new_pawn)
	. = ..()
	var/mob/living/living_pawn = new_pawn
	RegisterSignal(new_pawn, COMSIG_MOB_MOVESPEED_UPDATED, PROC_REF(update_movespeed))
	movement_delay = living_pawn.cached_multiplicative_slowdown
	new_pawn.AddComponent(/datum/component/ai_inventory_manager)
	new_pawn.AddElement(/datum/element/interrupt_on_damage)
	new_pawn.AddComponent(/datum/component/combat_vocalizer)

/datum/ai_controller/human_npc/UnpossessPawn(destroy)
	var/mob/living/living_pawn = pawn
	UnregisterSignal(pawn, list(
		COMSIG_MOB_MOVESPEED_UPDATED,
	))
	living_pawn.RemoveElement(/datum/element/interrupt_on_damage)
	qdel(living_pawn.GetComponent(/datum/component/ai_inventory_manager))
	qdel(living_pawn.GetComponent(/datum/component/combat_vocalizer))
	return ..()

/datum/ai_controller/human_npc/proc/update_movespeed(mob/living/pawn)
	SIGNAL_HANDLER
	movement_delay = pawn.cached_multiplicative_slowdown

/datum/ai_controller/human_npc/can_move()
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/living_pawn = pawn
	if(living_pawn.pulledby)
		return FALSE

/mob/living/carbon/human/proc/upgrade_ai_controller(new_controller_type)
	if(!ispath(new_controller_type, /datum/ai_controller))
		CRASH("upgrade_ai_controller called with non-controller typepath: [new_controller_type]")
	if(istype(ai_controller, new_controller_type))
		return // already on the right controller
	if(ai_controller)
		QDEL_NULL(ai_controller)
	ai_controller = new_controller_type
	InitializeAIController()

/// Melee-only human NPC. Same as base — the base class is already melee-focused since it
/datum/ai_controller/human_npc/melee

/// Archer human NPC. Adds archer-specific planning subtrees and blackboard keys on top of
/// the base. Uses the same melee subtree as a fallback when out of ammo / in melee range.
/datum/ai_controller/human_npc/archer
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

		// Archer-specific state — only relevant to mobs that carry a bow
		BB_ARCHER_NPC_BOW = null,
		BB_ARCHER_NPC_QUIVER = null,
		BB_ARCHER_NPC_EQUIPMENT_CACHE_EXPIRY = 0,
		BB_ARCHER_NPC_TARGET_ARROW = null,
		BB_ARCHER_NPC_STASHED_WEAPON = null,
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/call_for_help,
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/use_powder,
		/datum/ai_planning_subtree/use_bandage,
		/datum/ai_planning_subtree/use_throwable,
		/datum/ai_planning_subtree/use_healing_drink,
		/datum/ai_planning_subtree/generic_wield,
		/datum/ai_planning_subtree/kick_attack,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/generic_stand,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/tree_climb,
		/datum/ai_planning_subtree/archer_base, // Archer only
		/datum/ai_planning_subtree/ranged_attack_subtree, // Archer only
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/leap_attack,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,
		/datum/ai_planning_subtree/find_weapon,
		/datum/ai_planning_subtree/equip_item,
		/datum/ai_planning_subtree/retrieve_arrows,
		/datum/ai_planning_subtree/loot,
	)
