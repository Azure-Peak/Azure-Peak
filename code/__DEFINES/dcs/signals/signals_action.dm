// Action signals

///from base of datum/action/proc/Trigger(): (datum/action)
#define COMSIG_ACTION_TRIGGER "action_trigger"
	// Return to block the trigger from occuring
	#define COMPONENT_ACTION_BLOCK_TRIGGER (1<<0)
/// From /datum/action/Grant(): (mob/grant_to)
#define COMSIG_ACTION_GRANTED "action_grant"
/// From /datum/action/Remove(): (mob/removed_from)
#define COMSIG_ACTION_REMOVED "action_removed"
/// From /datum/action/Remove(): (datum/action)
#define COMSIG_MOB_REMOVED_ACTION "mob_action_removed"
/// From /datum/action/apply_button_overlay()
#define COMSIG_ACTION_OVERLAY_APPLY "action_overlay_applied"

// Cooldown action signals

/// From base of /datum/action/cooldown/proc/PreActivate(), sent to the action owner: (datum/action/cooldown/activated)
#define COMSIG_MOB_ABILITY_STARTED "mob_ability_base_started"
	/// Return to block the ability from starting / activating
	#define COMPONENT_BLOCK_ABILITY_START (1<<0)
/// From base of /datum/action/cooldown/proc/PreActivate(), sent to the action owner: (datum/action/cooldown/finished)
#define COMSIG_MOB_ABILITY_FINISHED "mob_ability_base_finished"
/// From base of /datum/action/cooldown/proc/CooldownEnded()
#define COMSIG_ACTION_COOLDOWN_ENDED "mob_action_cooldown_ended"
