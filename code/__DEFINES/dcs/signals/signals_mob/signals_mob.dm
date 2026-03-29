#define COMSIG_MOB_MOVESPEED_UPDATED "mob_updated_movespeed"
///from base of /mob/Login(): ()
#define COMSIG_MOB_LOGIN "mob_login"
///from base of /mob/Logout(): ()
#define COMSIG_MOB_LOGOUT "mob_logout"
//seems somewhat useful
#define COMSIG_MOB_STATCHANGE "mob_statchange"

/// Return value to cancel an attack chain from a signal handler.
#define COMPONENT_CANCEL_ATTACK_CHAIN (1<<0)

///before attackingtarget has happened, source is the attacker and target is the attacked
#define COMSIG_HOSTILE_PRE_ATTACKINGTARGET "hostile_pre_attackingtarget"
	#define COMPONENT_HOSTILE_NO_PREATTACK (1<<0) //cancel the attack, only works before attack happens
//#define COMPONENT_HOSTILE_NO_ATTACK COMPONENT_CANCEL_ATTACK_CHAIN //cancel the attack, only works before attack happens
///after attackingtarget has happened, source is the attacker and target is the attacked, extra argument for if the attackingtarget was successful
#define COMSIG_HOSTILE_POST_ATTACKINGTARGET "hostile_post_attackingtarget"

///Called when a /mob/living/simple_animal/hostile finds a new target: (atom/source, new_target)
#define COMSIG_HOSTILE_FOUND_TARGET "comsig_hostile_found_target"


#define COMSIG_SIMPLEMOB_PRE_ATTACK_RANGED "basicmob_pre_attack_ranged"
	#define COMPONENT_CANCEL_RANGED_ATTACK COMPONENT_CANCEL_ATTACK_CHAIN //! Cancel to prevent the attack from happening

///from the ranged_attacks component for basic mobs: (mob/living/basic/firer, atom/target, modifiers)
#define COMSIG_SIMPLEMOB_POST_ATTACK_RANGED "basicmob_post_attack_ranged"

///Check for /datum/emote/living/pray/run_emote(): message
#define COMSIG_CARBON_PRAY "carbon_prayed"
///Prevents the carbon's patron from hearing this prayer due to cancelation.
#define CARBON_PRAY_CANCEL (1<<0)

/// Called from the base of '/obj/item/bodypart/proc/drop_limb(special)' ()
#define COMSIG_MOB_DISMEMBER "mob_drop_limb"
	#define COMPONENT_CANCEL_DISMEMBER (1<<0) //cancel the drop limb

///From living/Life() (seconds, times_fired)
#define COMSIG_LIVING_LIFE "living_life"

/// From /obj/item/grabbing/bite/drinklimb() (mob/living/target)
#define COMSIG_LIVING_DRINKED_LIMB_BLOOD "living_drinked_limb_blood"

/// From /obj/item/organ/proc/Remove() (mob/living/carbon/lost_organ, obj/item/organ/removed, special, drop_if_replaced)
#define COMSIG_MOB_ORGAN_REMOVED "mob_organ_removed"
