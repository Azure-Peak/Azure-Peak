// Signals sent to or by spells

// Generic spell signals

/// Sent from /datum/action/cooldown/spell/before_cast() to the caster: (datum/action/cooldown/spell/spell, atom/cast_on)
#define COMSIG_MOB_BEFORE_SPELL_CAST "mob_spell_pre_cast"
/// Sent from /datum/action/cooldown/spell/before_cast() to the spell: (atom/cast_on)
#define COMSIG_SPELL_BEFORE_CAST "spell_pre_cast"
	/// Return to prevent the spell cast from continuing.
	#define SPELL_CANCEL_CAST (1 << 0)
	/// Return from before cast signals to prevent the spell from giving off sound or invocation.
	#define SPELL_NO_FEEDBACK (1 << 1)
	/// Return from before cast signals to prevent the spell from going on cooldown before aftercast.
	#define SPELL_NO_IMMEDIATE_COOLDOWN (1 << 2)
	/// Return from before cast signals to prevent the spell from invoking cost before aftercast.
	#define SPELL_NO_IMMEDIATE_COST (1 << 3)

/// Sent from /datum/action/cooldown/spell/set_click_ability() to the caster: (datum/action/cooldown/spell/spell)
#define COMSIG_MOB_SPELL_ACTIVATED "mob_spell_active"
	/// Same as spell_cancel_cast, as they're able to be used interchangeably
	#define SPELL_CANCEL_ACTIVATION SPELL_CANCEL_CAST

/// Sent from /datum/action/cooldown/spell/cast() to the caster: (datum/action/cooldown/spell/spell, atom/cast_on)
#define COMSIG_MOB_CAST_SPELL "mob_cast_spell"
/// Sent from /datum/action/cooldown/spell/cast() to the spell: (atom/cast_on)
#define COMSIG_SPELL_CAST "spell_cast"
/// Sent from /datum/action/cooldown/spell/after_cast() to the caster: (datum/action/cooldown/spell/spell, atom/cast_on)
#define COMSIG_MOB_AFTER_SPELL_CAST "mob_after_spell_cast"
/// Sent from /datum/action/cooldown/spell/after_cast() to the spell: (atom/cast_on)
#define COMSIG_SPELL_AFTER_CAST "spell_after_cast"
/// Sent from /datum/action/cooldown/spell/reset_spell_cooldown() to the spell: ()
#define COMSIG_SPELL_CAST_RESET "spell_cast_reset"
/// Sent from /datum/action/cooldown/spell/proc/invocation() to the mob: (datum/source, /datum/action/cooldown/spell/spell, list/invocation)
#define COMSIG_MOB_PRE_INVOCATION "spell_pre_invocation"
	///index for the invocation message string
	#define INVOCATION_MESSAGE 1
	///index for the invocation type string
	#define INVOCATION_TYPE 2

// Projectile spell signals
/// Sent from /datum/action/cooldown/spell/projectile/on_cast_hit() to the spell: (atom/hit, mob/firer, obj/projectile/projectile)
#define COMSIG_SPELL_PROJECTILE_HIT "spell_projectile_hit"

// Touch spell signals
/// Sent from /datum/action/cooldown/spell/touch/do_hand_hit() to the spell: (atom/victim, mob/caster, obj/item/melee/touch_attack/hand)
#define COMSIG_SPELL_TOUCH_HAND_HIT "spell_touch_hand_cast"
