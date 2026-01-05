/*ALL DEFINES RELATED TO COMBAT GO HERE*/

//Damage and status effect defines

//Damage defines //TODO: merge these down to reduce on defines
#define BRUTE		"brute"
#define BURN		"fire"
#define TOX			"toxin"
#define OXY			"oxygen"
#define CLONE		"clone"
#define STAMINA 	"stamina"
#define BRAIN		"brain"

//Omnibus'ing melee attack types
#define MELEE_TYPES list("blunt", "slash", "stab")

//bitflag damage defines used for suicide_act
#define BRUTELOSS 	            	(1<<0)
#define FIRELOSS 	            	(1<<1)
#define TOXLOSS 	            	(1<<2)
#define OXYLOSS 	            	(1<<3)
#define SHAME 			            (1<<4)
#define MANUAL_SUICIDE          	(1<<5)	//suicide_act will do the actual killing.
#define MANUAL_SUICIDE_NONLETHAL	(1<<6)  //when the suicide is conditionally lethal

#define EFFECT_STUN			"stun"
#define EFFECT_KNOCKDOWN	"knockdown"
#define EFFECT_UNCONSCIOUS	"unconscious"
#define EFFECT_PARALYZE		"paralyze"
#define EFFECT_IMMOBILIZE	"immobilize"
#define EFFECT_IRRADIATE	"irradiate"
#define EFFECT_STUTTER		"stutter"
#define EFFECT_SLUR 		"slur"
#define EFFECT_EYE_BLUR		"eye_blur"
#define EFFECT_DROWSY		"drowsy"
#define EFFECT_JITTER		"jitter"

//Bitflags defining which status effects could be or are inflicted on a mob
#define CANSTUN			(1<<0)
#define CANKNOCKDOWN	(1<<1)
#define CANUNCONSCIOUS	(1<<2)
#define CANPUSH			(1<<3)
#define GODMODE			(1<<4)

//Health Defines
#define HEALTH_THRESHOLD_CRIT 0
#define HEALTH_THRESHOLD_FULLCRIT 0
#define HEALTH_THRESHOLD_DEAD -100

#define HEALTH_THRESHOLD_NEARDEATH -90 //Not used mechanically, but to determine if someone is so close to death they hear the other side

// Actually a divisor. Where 1 / this * 100% value of burn damage on lethal zones (Chest & Head) causes you to enter hardcrit. 
#define FIRE_HARDCRIT_DIVISOR 106 // 106 = 94.5% burn damage = hardcrit
#define FIRE_HARDCRIT_DIVISOR_MINDLESS 200 // 200 = 50% burn damage = hardcrit for mindless mobs  
#define STRENGTH_SOFTCAP 14	//STR value past which we get diminishing returns in our damage calculations.
#define STRENGTH_MULT 0.1	//STR multiplier per STR point up to the softcap. Works as a %-age. 0.1 = 10% per point.
#define STRENGTH_CAPPEDMULT 0.034	//STR multiplier per STR point past the softcap
//Actual combat defines

//click cooldowns, in tenths of a second, used for various combat actions
#define CLICK_CD_EXHAUSTED 60
#define CLICK_CD_TRACKING 30
#define CLICK_CD_SLEUTH 10
#define CLICK_CD_HEAVY 16
#define CLICK_CD_CHARGED 14
#define CLICK_CD_MELEE 12
#define CLICK_CD_FAST 8
#define CLICK_CD_INTENTCAP 6
#define CLICK_CD_RANGE 4
#define CLICK_CD_RAPID 2
#define CLICK_CD_CLICK_ABILITY 6
#define CLICK_CD_BREAKOUT 100
#define CLICK_CD_HANDCUFFED 10
#define CLICK_CD_RESIST 20
#define CLICK_CD_GRABBING 10

//Aimed / Swift defines
#define EXTRA_STAMDRAIN_SWIFSTRONG 10
#define CLICK_CD_MOD_SWIFT 0.75
#define CLICK_CD_MOD_AIMED 1.25

//Cuff resist speeds
#define FAST_CUFFBREAK 1
#define INSTANT_CUFFBREAK 2

// animation types
#define ATTACK_ANIMATION_BONK "bonk"
#define ATTACK_ANIMATION_SWIPE "swipe"
#define ATTACK_ANIMATION_THRUST "thrust"

// Intent Effective Range presets
#define EFF_RANGE_NONE 0
#define EFF_RANGE_EXACT 1
#define EFF_RANGE_ABOVE 2
#define EFF_RANGE_BELOW 3

//Grab levels
#define GRAB_PASSIVE				0
#define GRAB_AGGRESSIVE				1
#define GRAB_NECK					2
#define GRAB_KILL					3

//Grab breakout odds
#define BASE_GRAB_RESIST_CHANCE 	30

//slowdown when in softcrit. Note that crawling slowdown will also apply at the same time!
#define SOFTCRIT_ADD_SLOWDOWN 1
//slowdown when crawling
#define CRAWLING_ADD_SLOWDOWN 7
//slowdown for dislocated limbs
#define DISLOCATED_ADD_SLOWDOWN 2
//slowdown for fractured limbs
#define FRACTURED_ADD_SLOWDOWN 3

//Attack types for checking shields/hit reactions
#define MELEE_ATTACK 1
#define UNARMED_ATTACK 2
#define PROJECTILE_ATTACK 3
#define THROWN_PROJECTILE_ATTACK 4
#define LEAP_ATTACK 5

//attack visual effects
#define ATTACK_EFFECT_PUNCH		"punch"
#define ATTACK_EFFECT_KICK		"kick"
#define ATTACK_EFFECT_SMASH		"smash"
#define ATTACK_EFFECT_CLAW		"claw"
#define ATTACK_EFFECT_SLASH		"slash"
#define ATTACK_EFFECT_DISARM	"disarm"
#define ATTACK_EFFECT_BITE		"bite"
#define ATTACK_EFFECT_MECHFIRE	"mech_fire"
#define ATTACK_EFFECT_MECHTOXIN	"mech_toxin"
#define ATTACK_EFFECT_BOOP		"boop" //Honk

//hurrrddurrrr
#define QINTENT_BITE		 1
#define QINTENT_JUMP		 2
#define QINTENT_KICK		 3
#define QINTENT_SPECIAL		 4
#define QINTENT_GIVE		 5
#define QINTENT_SPELL		 6

//Intent blade class for dismember class
#define BCLASS_BLUNT		"blunt"
#define BCLASS_SMASH		"smashing"
#define BCLASS_CUT			"slash"
#define BCLASS_CHOP			"chopping"
#define BCLASS_STAB			"stabbing"
#define BCLASS_PICK			"stab"
#define BCLASS_LASHING		"lashing"
#define BCLASS_PIERCE		"pierce"
#define BCLASS_TWIST		"twist"
#define BCLASS_PUNCH		"punch"
#define BCLASS_BITE			"bite"
#define BCLASS_BURN			"charring"
#define BCLASS_PEEL			"peel"
#define BCLASS_PUNISH		"punish"
#define BCLASS_EFFECT		"effect"
#define BCLASS_SUNDER       "sunder"

//Material class (what material is striking)
#define MCLASS_GENERIC		1
#define MCLASS_WOOD			2
#define MCLASS_STONE		3
#define MCLASS_METAL		4

//lengths.
#define WLENGTH_SHORT		1		//can only attack legs from the ground. must grab if standing to attack
#define WLENGTH_NORMAL		2		//can only attack legs from ground. dont need to grab. maces, short swords, kicks
#define WLENGTH_LONG		3		//can attack chest and down from the ground. dont need to grab. swords 2h axes
#define WLENGTH_GREAT		4		//can attack any bodypart from ground. think spears

//attacktype
#define DULLING_CUT 1
#define DULLING_BASH 2
#define DULLING_BASHCHOP 3
#define DULLING_PICK 4 //rockwalls
#define DULLING_FLOOR 5 //floors, only attacked by overhead smash and chop intents like from 2hammers
#define DULLING_SHAFT_WOOD 6
#define DULLING_SHAFT_REINFORCED 7
#define DULLING_SHAFT_METAL 8
#define DULLING_SHAFT_GRAND 9
#define DULLING_SHAFT_CONJURED 10
//see get_complex_damage()

//NOTE: INTENT_HOTKEY_* defines are not actual intents!
//they are here to support hotkeys
#define INTENT_HOTKEY_LEFT  "left"
#define INTENT_HOTKEY_RIGHT "right"

//the define for visible message range in combat
#define COMBAT_MESSAGE_RANGE 5
#define DEFAULT_MESSAGE_RANGE 7

//Shove knockdown lengths (deciseconds)
#define SHOVE_KNOCKDOWN_SOLID 30
#define SHOVE_KNOCKDOWN_HUMAN 30
#define SHOVE_KNOCKDOWN_TABLE 30
#define SHOVE_KNOCKDOWN_COLLATERAL 10
#define SHOVE_CHAIN_PARALYZE 40

//Shove slowdown
#define SHOVE_SLOWDOWN_LENGTH 30
#define SHOVE_SLOWDOWN_STRENGTH 0.85 //multiplier

//Shove disarming item list
GLOBAL_LIST_INIT(shove_disarming_types, typecacheof(list(
	/obj/item/gun,
)))


//Combat object defines

//Embedded objects
#define EMBEDDED_PAIN_CHANCE 					15	//Chance for embedded objects to cause pain (damage user)
#define EMBEDDED_ITEM_FALLOUT 					5	//Chance for embedded object to fall out (causing pain but removing the object)
#define EMBED_CHANCE							45	//Chance for an object to embed into somebody when thrown (if it's sharp)
#define EMBEDDED_PAIN_MULTIPLIER				2	//Coefficient of multiplication for the damage the item does while embedded (this*item.w_class)
#define EMBEDDED_FALL_PAIN_MULTIPLIER			5	//Coefficient of multiplication for the damage the item does when it falls out (this*item.w_class)
#define EMBEDDED_IMPACT_PAIN_MULTIPLIER			4	//Coefficient of multiplication for the damage the item does when it first embeds (this*item.w_class)
#define EMBED_THROWSPEED_THRESHOLD				4	//The minimum value of an item's throw_speed for it to embed (Unless it has embedded_ignore_throwspeed_threshold set to 1)
#define EMBEDDED_UNSAFE_REMOVAL_PAIN_MULTIPLIER 8	//Coefficient of multiplication for the damage the item does when removed without a surgery (this*item.w_class)
#define EMBEDDED_UNSAFE_REMOVAL_TIME			0	//A Time in ticks, total removal time = (this*item.w_class)

//Gun weapon weight
#define WEAPON_LIGHT 1
#define WEAPON_MEDIUM 2
#define WEAPON_HEAVY 3
//Gun trigger guards
#define TRIGGER_GUARD_ALLOW_ALL -1
#define TRIGGER_GUARD_NONE 0
#define TRIGGER_GUARD_NORMAL 1
//Gun bolt types
///Gun has a bolt, it stays closed while not cycling. The gun must be racked to have a bullet chambered when a mag is inserted.
///  Example: c20, shotguns, m90
#define BOLT_TYPE_STANDARD 1
///Gun has a bolt, it is open when ready to fire. The gun can never have a chambered bullet with no magazine, but the bolt stays ready when a mag is removed.
///  Example: Some SMGs, the L6
#define BOLT_TYPE_OPEN 2
///Gun has no moving bolt mechanism, it cannot be racked. Also dumps the entire contents when emptied instead of a magazine.
///  Example: Break action shotguns, revolvers
#define BOLT_TYPE_NO_BOLT 3
///Gun has a bolt, it locks back when empty. It can be released to chamber a round if a magazine is in.
///  Example: Pistols with a slide lock, some SMGs
#define BOLT_TYPE_LOCKING 4
//Sawn off nerfs
///accuracy penalty of sawn off guns
#define SAWN_OFF_ACC_PENALTY 25
///added recoil of sawn off guns
#define SAWN_OFF_RECOIL 1

//ammo box sprite defines
///ammo box will always use provided icon state
#define AMMO_BOX_ONE_SPRITE 0
///ammo box will have a different state for each bullet; <icon_state>-<bullets left>
#define AMMO_BOX_PER_BULLET 1
///ammo box will have a different state for full and empty; <icon_state>-max_ammo and <icon_state>-0
#define AMMO_BOX_FULL_EMPTY 2

//Projectile Reflect
#define REFLECT_NORMAL 				(1<<0)
#define REFLECT_FAKEPROJECTILE		(1<<1)

//Object/Item sharpness
#define IS_BLUNT			0
#define IS_SHARP			1
#define IS_SHARP_ACCURATE	2

//His Grace.
#define HIS_GRACE_SATIATED 0 //He hungers not. If bloodthirst is set to this, His Grace is asleep.
#define HIS_GRACE_PECKISH 20 //Slightly hungry.
#define HIS_GRACE_HUNGRY 60 //Getting closer. Increases damage up to a minimum of 20.
#define HIS_GRACE_FAMISHED 100 //Dangerous. Increases damage up to a minimum of 25 and cannot be dropped.
#define HIS_GRACE_STARVING 120 //Incredibly close to breaking loose. Increases damage up to a minimum of 30.
#define HIS_GRACE_CONSUME_OWNER 140 //His Grace consumes His owner at this point and becomes aggressive.
#define HIS_GRACE_FALL_ASLEEP 160 //If it reaches this point, He falls asleep and resets.

#define HIS_GRACE_FORCE_BONUS 4 //How much force is gained per kill.

#define EXPLODE_NONE 0				//Don't even ask me why we need this.
#define EXPLODE_DEVASTATE 1
#define EXPLODE_HEAVY 2
#define EXPLODE_LIGHT 3
#define EXPLODE_GIB_THRESHOLD 50	//ex_act() with EXPLODE_DEVASTATE severity will gib mobs with less than this much bomb armor

#define EMP_HEAVY 1
#define EMP_LIGHT 2

#define GRENADE_CLUMSY_FUMBLE 1
#define GRENADE_NONCLUMSY_FUMBLE 2
#define GRENADE_NO_FUMBLE 3

//We will round to this value in damage calculations.
#define DAMAGE_PRECISION 0.1

#define STRONG_STANCE_DMG_BONUS 0.1
#define STRONG_SHP_BONUS 2
#define STRONG_INTG_BONUS 2

//bullet_act() return values
#define BULLET_ACT_HIT				"HIT"		//It's a successful hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_BLOCK			"BLOCK"		//It's a blocked hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_FORCE_PIERCE		"PIERCE"	//It pierces through the object regardless of the bullet being piercing by default.
#define BULLET_ACT_TURF				"TURF"		//It hit us but it should hit something on the same turf too. Usually used for turfs.
#define BULLET_ACT_MISS				"MISS"

//Weapon values
#define BLUNT_DEFAULT_PENFACTOR		-100
#define NONBLUNT_BLUNT_DAMFACTOR 0.6 // Damage factor when a non blunt weapon is used with blunt intent. Meant to make it worse than a real one.
#define BLUNT_DEFAULT_INT_DAMAGEFACTOR 1.6 // Universal blunt intent integrity damage factor. Replaces Roguepen

// Integrity & Sharpness Value
#define INTEG_PARRY_DECAY			1	//Default integrity decay on parry.
#define INTEG_PARRY_DECAY_NOSHARP	5	//Integrity decay on parry for weapons with no sharpness OR for off-hand parries.
#define SHARPNESS_ONHIT_DECAY		3	//Sharpness decay on parry.
#define SHARPNESS_TIER1_THRESHOLD	0.8	//%-age threshold when damage starts to fall off -- mainly damfactor and STR factor. NOT base damage value.
#define SHARPNESS_TIER1_FLOOR		0.45//%-age threshold when damfactors and STR factors become 0.
#define SHARPNESS_TIER2_THRESHOLD	0.2 //%-age threshold when damage *really* falls off. Base damage value included.

#define UNARMED_DAMAGE_DEFAULT		12

/// Damage multiplier of silver weapons against mobs with TRAIT_SIMPLE_WOUNDS
#define SILVER_SIMPLEMOB_DAM_MULT 3

#define PROJ_PARRY_TIMER	0.65 SECONDS	//The time after an attack (swinging in the air counts) when a thrown item would be deflected at a higher chance.

/* COMBAT DEFINES for NON ARMOR VALUES */

#define BASE_PARRY_STAMINA_DRAIN 5 // Unmodified stamina drain for parry, now a var instead of setting on simplemobs
#define BAD_GUARD_FATIGUE_DRAIN 20 //Percentage of your green bar lost on letting a guard expire.
#define GUARD_PEEL_REDUCTION 2	//How many Peel stacks to lose if a Guard is hit.
#define BAIT_PEEL_REDUCTION 1	//How many Peel stacks to lose if we perfectly bait.
#define BASE_RCLICK_CD 30 SECONDS

/* TEMPO DEFINES */
#define TEMPO_CULL_DELAY 	12 SECONDS	//Interval for checking our tempo lists. Only relevant to player mobs with TRAIT_TEMPO
#define TEMPO_DELAY_ONE 30 SECONDS	//How long the attacker will stay "in memory" before getting deleted, the more attackers the shorter the duration.
#define TEMPO_DELAY_TWO	15 SECONDS
#define TEMPO_DELAY_MAX	8 SECONDS
#define TEMPO_CAP 7
#define TEMPO_MAX 4
#define TEMPO_TWO 3
#define TEMPO_ONE 2

#define TEMPO_TAG_STAMLOSS_PARRY "parry"
#define TEMPO_TAG_STAMLOSS_DODGE "dodge"
#define TEMPO_TAG_ARMOR_INTEGFACTOR "integ"
#define TEMPO_TAG_NOLOS_PARRY "nolosparry"
#define TEMPO_TAG_DEF_SHARPNESSFACTOR "sharpness"
#define TEMPO_TAG_DEF_INTEGFACTOR "parryinteg"
#define TEMPO_TAG_PARRYCD_BONUS	"parrycd"
#define TEMPO_TAG_RCLICK_CD_BONUS "rclickcd"
#define TEMPO_TAG_DEF_BONUS	"defbonus"


/*
Medical defines
*/
#define ARTERY_LIMB_BLEEDRATE 20	//This is used as a reference point for dynamic wounds, so it's better off as a define.
#define CONSTITUTION_BLEEDRATE_MOD 0.1	//How much slower we'll be bleeding for every CON point. 0.1 = 10% slower.
#define CONSTITUTION_BLEEDRATE_CAP 15	//The CON value up to which we get a bleedrate reduction.

/*
 Misc. Category. Spin it out if needed
*/
#define CRIT_DISMEMBER_DAMAGE_THRESHOLD 0.75 // 75% damage threshold for dismemberment / crit
#define STANDING_DECAP_GRACE_PERIOD 2 SECONDS // Time after falling prone where you still count as standing for decap purpose
#define INT_NOISE_DELAY 1 SECONDS

/*
	Critical Resistance Defines 
*/
// Normal classes are guaranteed 4 resists, NPC 1, noblood / revenant 1
#define CRIT_RESISTANCE_STACKS_PLAYER 4
#define CRIT_RESISTANCE_STACKS_NPC 1
#define CRIT_RESISTANCE_STACKS_OP 1 // Noblood / Revenant etc.
#define CRIT_RESISTANCE_EFFECTIVE_BLEEDRATE 0.5 // How much CR reduce bleedrate by
#define CRIT_RESISTANCE_TIMER_CD 30 SECONDS // Cooldown between guaranteed CR procs. DOES NOT APPLY TO DISMEMBERMENT.

#define PREVENT_CRITS_NONE	0
#define PREVENT_CRITS_MOST	1
#define PREVENT_CRITS_ALL	2

/*
	Dullfactor Defines. These should be removed at some point.
*/

#define DULLFACTOR_COUNTERED_BY 1.2 // If a shaft is COUNTERED by a weapon type, this is the damage to go for
#define DULLFACTOR_NEUTRAL 1 // If a shaft is NEUTRAL to a weapon type, this is the damage to go for
#define DULLFACTOR_COUNTERS 0.8 // If a shaft COUNTERS a damage type, this is the damage to go for
#define DULLFACTOR_ANTAG 0.5 // For Grand Shaft. Also for dull blade
// Previously value were closer to 0.4 - 0.5 and 1.5 - 1.7x, but it felt like it make weapons
// counter certain shaft type too hard, so now the value is between 0.8 to 1.2x for regular type

//Visible message presets.
#define VISMSG_ARMOR_BLOCKED " <span class='armoralert'>Armor stops the damage.</span>"
#define VISMSG_ARMOR_INT_STAGEONE "<span class='armoralert'><i> Dented.</i></span>"
#define VISMSG_ARMOR_INT_STAGETWO "<span class='armoralert'> Damaged.</span>"
#define VISMSG_ARMOR_INT_STAGETHREE "<span class='armoralert'><b> Crumbling!</b></span>"
