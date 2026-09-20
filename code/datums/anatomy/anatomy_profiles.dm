// Anatomy profiles for the simple mob critical wounds system, with design exaplanation per profile.

/* TODO template - one line per mob still awaiting its redesign pass. State the conclusion,
not the options:
	TODO <mob>: <what the fight should become in one sentence>

TODO mirespider:
*/

/* Trash quadruped, wounds are not really core to fighting these animals, and it is just
there to provide player a tangible sense of progress.
*/
/datum/anatomy/quadruped
	limb_names = list(
		BODY_ZONE_HEAD = "head",
		BODY_ZONE_PRECISE_R_EYE = "head",
		BODY_ZONE_PRECISE_L_EYE = "head",
		BODY_ZONE_PRECISE_SKULL = "head",
		BODY_ZONE_PRECISE_EARS = "head",
		BODY_ZONE_PRECISE_NOSE = "nose",
		BODY_ZONE_PRECISE_MOUTH = "mouth",
		BODY_ZONE_PRECISE_NECK = "neck",
		BODY_ZONE_CHEST = "flank",
		BODY_ZONE_L_ARM = "foreleg",
		BODY_ZONE_R_ARM = "foreleg",
		BODY_ZONE_PRECISE_L_HAND = "foreleg",
		BODY_ZONE_PRECISE_R_HAND = "foreleg",
		BODY_ZONE_L_LEG = "hind leg",
		BODY_ZONE_R_LEG = "hind leg",
		BODY_ZONE_PRECISE_L_FOOT = "hind leg",
		BODY_ZONE_PRECISE_R_FOOT = "hind leg",
		BODY_ZONE_PRECISE_STOMACH = "stomach",
		BODY_ZONE_PRECISE_GROIN = "tail",
	)

/datum/anatomy/quadruped/trash/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.6, part_health_minimum = 30, break_wound = /datum/wound/cripple/maw, hint = "head")
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.45, part_health_minimum = 25, break_wound = /datum/wound/cripple/limb, hint = "legs")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.45, part_health_minimum = 25, break_wound = /datum/wound/cripple/limb, hint = "legs")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.45, part_health_minimum = 25, break_wound = /datum/wound/cripple/limb, hint = "legs")
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.45, part_health_minimum = 25, break_wound = /datum/wound/cripple/limb, hint = "legs")

/* Standard quadruped like direbear, mole that has an actual substantial HP pool. Crippling is a real mid fight tactic. Forelegs lower offensive output, hind legs lower movement. Part health being lower means that a fight would involve 2 - 3 parts instead of just 1 into death.
*/
/datum/anatomy/quadruped/standard/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 45, break_wound = /datum/wound/cripple/maw, hint = "head")
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/arm/foreleg, hint = "forelegs")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/arm/foreleg, hint = "forelegs")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb, hint = "hind legs")
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb, hint = "hind legs")

/* Deadite quadruped. Head will destroy and end it for good. Other body parts merely slow them.
*/
/datum/anatomy/quadruped/undead
	bloodless = TRUE

/datum/anatomy/quadruped/undead/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.5, part_health_minimum = 30, break_wound = /datum/wound/cripple/fatal/decapitate/small, hint = "head")
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 20, break_wound = /datum/wound/cripple/limb/undead, hint = "forelegs")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 20, break_wound = /datum/wound/cripple/limb/undead, hint = "forelegs")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 20, break_wound = /datum/wound/cripple/limb/undead, hint = "hind legs")
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 20, break_wound = /datum/wound/cripple/limb/undead, hint = "hind legs")

/datum/anatomy/biped
	limb_names = list(
		BODY_ZONE_HEAD = "head",
		BODY_ZONE_PRECISE_R_EYE = "head",
		BODY_ZONE_PRECISE_L_EYE = "head",
		BODY_ZONE_PRECISE_SKULL = "head",
		BODY_ZONE_PRECISE_EARS = "head",
		BODY_ZONE_PRECISE_NOSE = "nose",
		BODY_ZONE_PRECISE_MOUTH = "mouth",
		BODY_ZONE_PRECISE_NECK = "neck",
		BODY_ZONE_CHEST = "chest",
		BODY_ZONE_L_ARM = "arm",
		BODY_ZONE_R_ARM = "arm",
		BODY_ZONE_PRECISE_L_HAND = "hand",
		BODY_ZONE_PRECISE_R_HAND = "hand",
		BODY_ZONE_L_LEG = "leg",
		BODY_ZONE_R_LEG = "leg",
		BODY_ZONE_PRECISE_L_FOOT = "foot",
		BODY_ZONE_PRECISE_R_FOOT = "foot",
		BODY_ZONE_PRECISE_STOMACH = "gut",
		BODY_ZONE_PRECISE_GROIN = "groin",
	)

/datum/anatomy/biped/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.45, part_health_minimum = 25, break_wound = /datum/wound/cripple/skull, hint = "head")
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 20, break_wound = /datum/wound/cripple/arm, hint = "arms")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 20, break_wound = /datum/wound/cripple/arm, hint = "arms")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 20, break_wound = /datum/wound/cripple/limb, hint = "legs")
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 20, break_wound = /datum/wound/cripple/limb, hint = "legs")

/* Lamia get a special body meant to reward you for targeting their arms, in exchange for dealing with their very glass cannony play style.
*/
/datum/anatomy/biped/lamia
	limb_names = list(
		BODY_ZONE_HEAD = "head",
		BODY_ZONE_PRECISE_R_EYE = "head",
		BODY_ZONE_PRECISE_L_EYE = "head",
		BODY_ZONE_PRECISE_SKULL = "head",
		BODY_ZONE_PRECISE_EARS = "head",
		BODY_ZONE_PRECISE_NOSE = "nose",
		BODY_ZONE_PRECISE_MOUTH = "mouth",
		BODY_ZONE_PRECISE_NECK = "neck",
		BODY_ZONE_CHEST = "torso",
		BODY_ZONE_L_ARM = "bladed arm",
		BODY_ZONE_R_ARM = "bladed arm",
		BODY_ZONE_PRECISE_L_HAND = "blade",
		BODY_ZONE_PRECISE_R_HAND = "blade",
		BODY_ZONE_L_LEG = "coils",
		BODY_ZONE_R_LEG = "coils",
		BODY_ZONE_PRECISE_L_FOOT = "tail",
		BODY_ZONE_PRECISE_R_FOOT = "tail",
		BODY_ZONE_PRECISE_STOMACH = "belly",
		BODY_ZONE_PRECISE_GROIN = "tail",
	)

/datum/anatomy/biped/lamia/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.5, part_health_minimum = 25, break_wound = /datum/wound/cripple/fatal/decapitate, hint = "head")
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 30, break_wound = /datum/wound/cripple/arm, hint = "bladed arms")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 30, break_wound = /datum/wound/cripple/arm, hint = "bladed arms")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb, hint = "coils")
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb, hint = "coils")

/*
*/
/datum/anatomy/biped/lamia/headless
	limb_names = list(
		BODY_ZONE_HEAD = "maw",
		BODY_ZONE_PRECISE_R_EYE = "maw",
		BODY_ZONE_PRECISE_L_EYE = "maw",
		BODY_ZONE_PRECISE_SKULL = "maw",
		BODY_ZONE_PRECISE_EARS = "maw",
		BODY_ZONE_PRECISE_NOSE = "maw",
		BODY_ZONE_PRECISE_MOUTH = "maw",
		BODY_ZONE_PRECISE_NECK = "gullet",
		BODY_ZONE_CHEST = "barrel",
		BODY_ZONE_L_ARM = "arm",
		BODY_ZONE_R_ARM = "arm",
		BODY_ZONE_PRECISE_L_HAND = "claw",
		BODY_ZONE_PRECISE_R_HAND = "claw",
		BODY_ZONE_L_LEG = "leg",
		BODY_ZONE_R_LEG = "leg",
		BODY_ZONE_PRECISE_L_FOOT = "leg",
		BODY_ZONE_PRECISE_R_FOOT = "leg",
		BODY_ZONE_PRECISE_STOMACH = "belly",
		BODY_ZONE_PRECISE_GROIN = "belly",
	)

/datum/anatomy/biped/lamia/headless/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.5, part_health_minimum = 40, break_wound = /datum/wound/cripple/fatal/decapitate, hint = "maw")
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 35, break_wound = /datum/wound/cripple/arm, hint = "arms")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 35, break_wound = /datum/wound/cripple/arm, hint = "arms")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb, hint = "legs")
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb, hint = "legs")

/*
*/
/datum/anatomy/drakkyn
	limb_names = list(
		BODY_ZONE_HEAD = "head",
		BODY_ZONE_PRECISE_R_EYE = "eye",
		BODY_ZONE_PRECISE_L_EYE = "eye",
		BODY_ZONE_PRECISE_SKULL = "head",
		BODY_ZONE_PRECISE_EARS = "head",
		BODY_ZONE_PRECISE_NOSE = "snout",
		BODY_ZONE_PRECISE_MOUTH = "maw",
		BODY_ZONE_PRECISE_NECK = "neck",
		BODY_ZONE_CHEST = "breast",
		BODY_ZONE_L_ARM = "wing",
		BODY_ZONE_R_ARM = "wing",
		BODY_ZONE_PRECISE_L_HAND = "wing",
		BODY_ZONE_PRECISE_R_HAND = "wing",
		BODY_ZONE_L_LEG = "hind leg",
		BODY_ZONE_R_LEG = "hind leg",
		BODY_ZONE_PRECISE_L_FOOT = "hind leg",
		BODY_ZONE_PRECISE_R_FOOT = "hind leg",
		BODY_ZONE_PRECISE_STOMACH = "belly",
		BODY_ZONE_PRECISE_GROIN = "tail",
	)

/datum/anatomy/drakkyn/build_zones()
	add_zone(BODY_ZONE_PRECISE_MOUTH, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 120, break_wound = /datum/wound/cripple/maw, hint = "maw", melee_hit_bonus = -10, ranged_hit_bonus = -30)
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 100, break_wound = /datum/wound/cripple/arm, hint = "wings")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 100, break_wound = /datum/wound/cripple/arm, hint = "wings")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 100, break_wound = /datum/wound/cripple/limb, hint = "hind legs", melee_hit_bonus = 20)
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 100, break_wound = /datum/wound/cripple/limb, hint = "hind legs", melee_hit_bonus = 20)

/* Tough biped, taller than a human. Head can only be struck once toppled, and is an instant kill with
less hp than their global HP pool. It also stop it from reanimating. Guts is a part that allows you to kill them by disembowelment. Legs will topple it. Arms will weaken its attacks.
Aiming legs should be nearly guaranteed due to their profile
*/
/datum/anatomy/biped/tough/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 100, break_wound = /datum/wound/cripple/fatal/decapitate, hint = "head", requires_prone = TRUE, melee_hit_bonus = -10, ranged_hit_bonus = -30) // Better build up that PER chudling
	add_zone(BODY_ZONE_PRECISE_STOMACH, damage_mult = 1, part_health_fraction = 0.6, part_health_minimum = 150, break_wound = /datum/wound/cripple/fatal/guts, hint = "gut")
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 80, break_wound = /datum/wound/cripple/arm, hint = "arms")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 80, break_wound = /datum/wound/cripple/arm, hint = "arms")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 80, break_wound = /datum/wound/cripple/limb/topple, hint = "legs", melee_hit_bonus = 40)
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 80, break_wound = /datum/wound/cripple/limb/topple, hint = "legs", melee_hit_bonus = 40)

/* Amorphous. A literal blob. Only one part. But give you a partial wound to reward you. Examples: ooze blob.
*/
/datum/anatomy/amorphous
	limb_names = list(
		BODY_ZONE_HEAD = "mass",
		BODY_ZONE_PRECISE_R_EYE = "mass",
		BODY_ZONE_PRECISE_L_EYE = "mass",
		BODY_ZONE_PRECISE_SKULL = "mass",
		BODY_ZONE_PRECISE_EARS = "mass",
		BODY_ZONE_PRECISE_NOSE = "mass",
		BODY_ZONE_PRECISE_MOUTH = "maw",
		BODY_ZONE_PRECISE_NECK = "mass",
		BODY_ZONE_CHEST = "core",
		BODY_ZONE_L_ARM = "mass",
		BODY_ZONE_R_ARM = "mass",
		BODY_ZONE_PRECISE_L_HAND = "mass",
		BODY_ZONE_PRECISE_R_HAND = "mass",
		BODY_ZONE_L_LEG = "mass",
		BODY_ZONE_R_LEG = "mass",
		BODY_ZONE_PRECISE_L_FOOT = "mass",
		BODY_ZONE_PRECISE_R_FOOT = "mass",
		BODY_ZONE_PRECISE_STOMACH = "core",
		BODY_ZONE_PRECISE_GROIN = "mass",
	)

/datum/anatomy/amorphous/build_zones()
	add_zone(BODY_ZONE_CHEST, damage_mult = 1, part_health_fraction = 0.5, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb/core, hint = "core")

/* Mimic. Amorphous, but tongue is a real appendage so you can target it to reduce its damage and reward you for knowing how to deal with them. Knowledge check, basically.
*/
/datum/anatomy/amorphous/mimic
	limb_names = list(
		BODY_ZONE_HEAD = "lid",
		BODY_ZONE_PRECISE_R_EYE = "lid",
		BODY_ZONE_PRECISE_L_EYE = "lid",
		BODY_ZONE_PRECISE_SKULL = "lid",
		BODY_ZONE_PRECISE_EARS = "lid",
		BODY_ZONE_PRECISE_NOSE = "lid",
		BODY_ZONE_PRECISE_MOUTH = "tongue",
		BODY_ZONE_PRECISE_NECK = "hinge",
		BODY_ZONE_CHEST = "body",
		BODY_ZONE_L_ARM = "body",
		BODY_ZONE_R_ARM = "body",
		BODY_ZONE_PRECISE_L_HAND = "body",
		BODY_ZONE_PRECISE_R_HAND = "body",
		BODY_ZONE_L_LEG = "body",
		BODY_ZONE_R_LEG = "body",
		BODY_ZONE_PRECISE_L_FOOT = "body",
		BODY_ZONE_PRECISE_R_FOOT = "body",
		BODY_ZONE_PRECISE_STOMACH = "gullet",
		BODY_ZONE_PRECISE_GROIN = "body",
	)

/datum/anatomy/amorphous/mimic/build_zones()
	. = ..()
	add_zone(BODY_ZONE_PRECISE_MOUTH, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 60, break_wound = /datum/wound/cripple/maw/tongue, hint = "tongue", melee_hit_bonus = -10)

/* Spiders.
Fangs (Mouth) defang them and give them lower damage.  Legs cripple and slow them.
*/
/datum/anatomy/spider
	limb_names = list(
		BODY_ZONE_HEAD = "head",
		BODY_ZONE_PRECISE_R_EYE = "eyes",
		BODY_ZONE_PRECISE_L_EYE = "eyes",
		BODY_ZONE_PRECISE_SKULL = "head",
		BODY_ZONE_PRECISE_EARS = "head",
		BODY_ZONE_PRECISE_NOSE = "head",
		BODY_ZONE_PRECISE_MOUTH = "fangs",
		BODY_ZONE_PRECISE_NECK = "head",
		BODY_ZONE_CHEST = "thorax",
		BODY_ZONE_L_ARM = "leg",
		BODY_ZONE_R_ARM = "leg",
		BODY_ZONE_PRECISE_L_HAND = "leg",
		BODY_ZONE_PRECISE_R_HAND = "leg",
		BODY_ZONE_L_LEG = "leg",
		BODY_ZONE_R_LEG = "leg",
		BODY_ZONE_PRECISE_L_FOOT = "leg",
		BODY_ZONE_PRECISE_R_FOOT = "leg",
		BODY_ZONE_PRECISE_STOMACH = "abdomen",
		BODY_ZONE_PRECISE_GROIN = "abdomen",
	)

/datum/anatomy/spider/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 30, break_wound = /datum/wound/cripple/maw/fangs, hint = "fangs")
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 25, break_wound = /datum/wound/cripple/limb, hint = "legs")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 25, break_wound = /datum/wound/cripple/limb, hint = "legs")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 25, break_wound = /datum/wound/cripple/limb, hint = "legs")
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 25, break_wound = /datum/wound/cripple/limb, hint = "legs")

/*
	Spinneret (Abdomen) disables their ability to web. Relatively low health zone to aim at.
*/
/datum/anatomy/spider/spitter/build_zones()
	. = ..()
	add_zone(BODY_ZONE_PRECISE_STOMACH, damage_mult = 1, part_health_fraction = 0.15, part_health_minimum = 15, break_wound = /datum/wound/cripple/spinneret, hint = "abdomen", melee_hit_bonus = 20)

/*
*/
/datum/anatomy/spider/mirespider

/* Aberrant body type. Used for dreamfiends. They have tentacle, maw etc from their sprites. Aiming head = lowered damage by breaking their maw apart. Arm too, further lowers their damage potential.
*/
/datum/anatomy/aberrant
	limb_names = list(
		BODY_ZONE_HEAD = "maw",
		BODY_ZONE_PRECISE_R_EYE = "maw",
		BODY_ZONE_PRECISE_L_EYE = "maw",
		BODY_ZONE_PRECISE_SKULL = "maw",
		BODY_ZONE_PRECISE_EARS = "maw",
		BODY_ZONE_PRECISE_NOSE = "maw",
		BODY_ZONE_PRECISE_MOUTH = "maw",
		BODY_ZONE_PRECISE_NECK = "stalk",
		BODY_ZONE_CHEST = "mass",
		BODY_ZONE_L_ARM = "tentacle",
		BODY_ZONE_R_ARM = "tentacle",
		BODY_ZONE_PRECISE_L_HAND = "tentacle",
		BODY_ZONE_PRECISE_R_HAND = "tentacle",
		BODY_ZONE_L_LEG = "crawling limb",
		BODY_ZONE_R_LEG = "crawling limb",
		BODY_ZONE_PRECISE_L_FOOT = "crawling limb",
		BODY_ZONE_PRECISE_R_FOOT = "crawling limb",
		BODY_ZONE_PRECISE_STOMACH = "mass",
		BODY_ZONE_PRECISE_GROIN = "mass",
	)

/datum/anatomy/aberrant/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.45, part_health_minimum = 60, break_wound = /datum/wound/cripple/maw, hint = "maw")
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/arm/tentacle, hint = "tentacles")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/arm/tentacle, hint = "tentacles")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb, hint = "crawling limbs")
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb, hint = "crawling limbs")

// Construct have blunt favored wounds that are otherwise the same. On larger constructs, there is a core that must be exposed by breaking a leg.
/datum/anatomy/construct
	bloodless = TRUE
	pen_flavor = "plating"
	bclass_part_mult = list(
		BCLASS_BLUNT = CONSTRUCT_BLUNT_PART_MULT,
		BCLASS_SMASH = CONSTRUCT_BLUNT_PART_MULT,
	)
	limb_names = list(
		BODY_ZONE_HEAD = "mantle",
		BODY_ZONE_PRECISE_R_EYE = "mantle",
		BODY_ZONE_PRECISE_L_EYE = "mantle",
		BODY_ZONE_PRECISE_SKULL = "mantle",
		BODY_ZONE_PRECISE_EARS = "mantle",
		BODY_ZONE_PRECISE_NOSE = "mantle",
		BODY_ZONE_PRECISE_MOUTH = "mantle",
		BODY_ZONE_PRECISE_NECK = "mantle",
		BODY_ZONE_CHEST = "core",
		BODY_ZONE_L_ARM = "arm",
		BODY_ZONE_R_ARM = "arm",
		BODY_ZONE_PRECISE_L_HAND = "fist",
		BODY_ZONE_PRECISE_R_HAND = "fist",
		BODY_ZONE_L_LEG = "leg",
		BODY_ZONE_R_LEG = "leg",
		BODY_ZONE_PRECISE_L_FOOT = "leg",
		BODY_ZONE_PRECISE_R_FOOT = "leg",
		BODY_ZONE_PRECISE_STOMACH = "core",
		BODY_ZONE_PRECISE_GROIN = "core",
	)

/datum/anatomy/construct/trash/build_zones()
	add_zone(BODY_ZONE_CHEST, damage_mult = 1, part_health_fraction = 0.5, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb/core/fracture, hint = "core")

/datum/anatomy/construct/standard/build_zones()
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/arm/fracture, hint = "arms")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/arm/fracture, hint = "arms")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb/fracture, hint = "legs")
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 40, break_wound = /datum/wound/cripple/limb/fracture, hint = "legs")

// Arm weaken its heavy swing and legs make it slower. You get rewarded for knowledge chekc of legs into core
/datum/anatomy/construct/tough/build_zones()
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 220, break_wound = /datum/wound/cripple/arm/fracture, hint = "arms")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 220, break_wound = /datum/wound/cripple/arm/fracture, hint = "arms")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 250, break_wound = /datum/wound/cripple/limb/topple/fracture, hint = "legs", melee_hit_bonus = 40)
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 250, break_wound = /datum/wound/cripple/limb/topple/fracture, hint = "legs", melee_hit_bonus = 40)

/*
*/
/datum/anatomy/construct/apex/build_zones()
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.15, part_health_minimum = 350, break_wound = /datum/wound/cripple/arm/fracture, hint = "arms")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.15, part_health_minimum = 350, break_wound = /datum/wound/cripple/arm/fracture, hint = "arms")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 500, break_wound = /datum/wound/cripple/limb/topple/fracture, hint = "legs", melee_hit_bonus = 40)
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 500, break_wound = /datum/wound/cripple/limb/topple/fracture, hint = "legs", melee_hit_bonus = 40)
	add_zone(BODY_ZONE_CHEST, damage_mult = 1, part_health_fraction = 0.12, part_health_minimum = 300, break_wound = /datum/wound/cripple/fatal/core, hint = "core", requires_broken = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), exposed_message = "core is laid bare!")

/*
*/
/datum/anatomy/winged
	limb_names = list(
		BODY_ZONE_HEAD = "head",
		BODY_ZONE_PRECISE_R_EYE = "head",
		BODY_ZONE_PRECISE_L_EYE = "head",
		BODY_ZONE_PRECISE_SKULL = "head",
		BODY_ZONE_PRECISE_EARS = "head",
		BODY_ZONE_PRECISE_NOSE = "head",
		BODY_ZONE_PRECISE_MOUTH = "mouth",
		BODY_ZONE_PRECISE_NECK = "neck",
		BODY_ZONE_CHEST = "thorax",
		BODY_ZONE_L_ARM = "wing",
		BODY_ZONE_R_ARM = "wing",
		BODY_ZONE_PRECISE_L_HAND = "wing",
		BODY_ZONE_PRECISE_R_HAND = "wing",
		BODY_ZONE_L_LEG = "leg",
		BODY_ZONE_R_LEG = "leg",
		BODY_ZONE_PRECISE_L_FOOT = "leg",
		BODY_ZONE_PRECISE_R_FOOT = "leg",
		BODY_ZONE_PRECISE_STOMACH = "thorax",
		BODY_ZONE_PRECISE_GROIN = "thorax",
	)

/*
*/
/datum/anatomy/winged/trash/build_zones()
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 20, break_wound = /datum/wound/cripple/limb/wing, hint = "wings", melee_hit_bonus = 20, ranged_hit_bonus = 10)
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 20, break_wound = /datum/wound/cripple/limb/wing, hint = "wings", melee_hit_bonus = 20, ranged_hit_bonus = 10)

/*
*/
/datum/anatomy/winged/standard/build_zones()
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 70, break_wound = /datum/wound/cripple/limb/wing, hint = "wings", melee_hit_bonus = 20, ranged_hit_bonus = 10)
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 70, break_wound = /datum/wound/cripple/limb/wing, hint = "wings", melee_hit_bonus = 20, ranged_hit_bonus = 10)
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 90, break_wound = /datum/wound/cripple/maw, hint = "head")

/*
*/
/datum/anatomy/winged/apex/build_zones()
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 160, break_wound = /datum/wound/cripple/limb/wing, hint = "wings", melee_hit_bonus = 20, ranged_hit_bonus = 10)
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 160, break_wound = /datum/wound/cripple/limb/wing, hint = "wings", melee_hit_bonus = 20, ranged_hit_bonus = 10)
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 200, break_wound = /datum/wound/cripple/maw, hint = "head")

/*
*/
/datum/anatomy/dryad
	pen_flavor = "heartwood"
	limb_names = list(
		BODY_ZONE_HEAD = "crown",
		BODY_ZONE_PRECISE_R_EYE = "crown",
		BODY_ZONE_PRECISE_L_EYE = "crown",
		BODY_ZONE_PRECISE_SKULL = "crown",
		BODY_ZONE_PRECISE_EARS = "crown",
		BODY_ZONE_PRECISE_NOSE = "crown",
		BODY_ZONE_PRECISE_MOUTH = "maw",
		BODY_ZONE_PRECISE_NECK = "bole",
		BODY_ZONE_CHEST = "heartwood",
		BODY_ZONE_L_ARM = "bough",
		BODY_ZONE_R_ARM = "bough",
		BODY_ZONE_PRECISE_L_HAND = "bough",
		BODY_ZONE_PRECISE_R_HAND = "bough",
		BODY_ZONE_L_LEG = "root",
		BODY_ZONE_R_LEG = "root",
		BODY_ZONE_PRECISE_L_FOOT = "root",
		BODY_ZONE_PRECISE_R_FOOT = "root",
		BODY_ZONE_PRECISE_STOMACH = "heartwood",
		BODY_ZONE_PRECISE_GROIN = "bole",
	)

/datum/anatomy/dryad/build_zones()
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 150, break_wound = /datum/wound/cripple/arm, hint = "boughs")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.2, part_health_minimum = 150, break_wound = /datum/wound/cripple/arm, hint = "boughs")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 180, break_wound = /datum/wound/cripple/limb/topple/root, hint = "roots", melee_hit_bonus = 40)
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 180, break_wound = /datum/wound/cripple/limb/topple/root, hint = "roots", melee_hit_bonus = 40)

/*
*/
/datum/anatomy/winged/infernal
	limb_names = list(
		BODY_ZONE_HEAD = "head",
		BODY_ZONE_PRECISE_R_EYE = "head",
		BODY_ZONE_PRECISE_L_EYE = "head",
		BODY_ZONE_PRECISE_SKULL = "head",
		BODY_ZONE_PRECISE_EARS = "head",
		BODY_ZONE_PRECISE_NOSE = "snout",
		BODY_ZONE_PRECISE_MOUTH = "maw",
		BODY_ZONE_PRECISE_NECK = "neck",
		BODY_ZONE_CHEST = "body",
		BODY_ZONE_L_ARM = "wing",
		BODY_ZONE_R_ARM = "wing",
		BODY_ZONE_PRECISE_L_HAND = "claw",
		BODY_ZONE_PRECISE_R_HAND = "claw",
		BODY_ZONE_L_LEG = "leg",
		BODY_ZONE_R_LEG = "leg",
		BODY_ZONE_PRECISE_L_FOOT = "leg",
		BODY_ZONE_PRECISE_R_FOOT = "leg",
		BODY_ZONE_PRECISE_STOMACH = "body",
		BODY_ZONE_PRECISE_GROIN = "tail",
	)

/datum/anatomy/winged/infernal/build_zones()
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 30, break_wound = /datum/wound/cripple/limb/wing, hint = "wings", ranged_hit_bonus = 10)
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 30, break_wound = /datum/wound/cripple/limb/wing, hint = "wings", ranged_hit_bonus = 10)

/*
*/
/datum/anatomy/quadruped/standard/hellhound
	limb_names = list(
		BODY_ZONE_HEAD = "head",
		BODY_ZONE_PRECISE_R_EYE = "head",
		BODY_ZONE_PRECISE_L_EYE = "head",
		BODY_ZONE_PRECISE_SKULL = "head",
		BODY_ZONE_PRECISE_EARS = "head",
		BODY_ZONE_PRECISE_NOSE = "snout",
		BODY_ZONE_PRECISE_MOUTH = "furnace maw",
		BODY_ZONE_PRECISE_NECK = "neck",
		BODY_ZONE_CHEST = "flank",
		BODY_ZONE_L_ARM = "foreleg",
		BODY_ZONE_R_ARM = "foreleg",
		BODY_ZONE_PRECISE_L_HAND = "foreleg",
		BODY_ZONE_PRECISE_R_HAND = "foreleg",
		BODY_ZONE_L_LEG = "hind leg",
		BODY_ZONE_R_LEG = "hind leg",
		BODY_ZONE_PRECISE_L_FOOT = "hind leg",
		BODY_ZONE_PRECISE_R_FOOT = "hind leg",
		BODY_ZONE_PRECISE_STOMACH = "belly",
		BODY_ZONE_PRECISE_GROIN = "tail",
	)

/*
*/
/datum/anatomy/orb
	limb_names = list(
		BODY_ZONE_HEAD = "eye",
		BODY_ZONE_PRECISE_R_EYE = "eye",
		BODY_ZONE_PRECISE_L_EYE = "eye",
		BODY_ZONE_PRECISE_SKULL = "eye",
		BODY_ZONE_PRECISE_EARS = "shell",
		BODY_ZONE_PRECISE_NOSE = "shell",
		BODY_ZONE_PRECISE_MOUTH = "eye",
		BODY_ZONE_PRECISE_NECK = "shell",
		BODY_ZONE_CHEST = "molten shell",
		BODY_ZONE_L_ARM = "shell",
		BODY_ZONE_R_ARM = "shell",
		BODY_ZONE_PRECISE_L_HAND = "shell",
		BODY_ZONE_PRECISE_R_HAND = "shell",
		BODY_ZONE_L_LEG = "shell",
		BODY_ZONE_R_LEG = "shell",
		BODY_ZONE_PRECISE_L_FOOT = "shell",
		BODY_ZONE_PRECISE_R_FOOT = "shell",
		BODY_ZONE_PRECISE_STOMACH = "molten shell",
		BODY_ZONE_PRECISE_GROIN = "molten shell",
	)

/datum/anatomy/orb/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 150, break_wound = /datum/wound/cripple/skull/blinded, hint = "eye", melee_hit_bonus = -10, ranged_hit_bonus = -30)

/*
*/
/datum/anatomy/biped/tough/fiend/build_zones()
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 250, break_wound = /datum/wound/cripple/arm, hint = "arms")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 250, break_wound = /datum/wound/cripple/arm, hint = "arms")
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.3, part_health_minimum = 300, break_wound = /datum/wound/cripple/skull/silenced, hint = "head", melee_hit_bonus = -10, ranged_hit_bonus = -30)
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 250, break_wound = /datum/wound/cripple/limb/topple, hint = "legs", melee_hit_bonus = 40)
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 250, break_wound = /datum/wound/cripple/limb/topple, hint = "legs", melee_hit_bonus = 40)

/*
*/
/datum/anatomy/construct/primordial
	limb_names = list(
		BODY_ZONE_HEAD = "crown",
		BODY_ZONE_PRECISE_R_EYE = "crown",
		BODY_ZONE_PRECISE_L_EYE = "crown",
		BODY_ZONE_PRECISE_SKULL = "crown",
		BODY_ZONE_PRECISE_EARS = "crown",
		BODY_ZONE_PRECISE_NOSE = "crown",
		BODY_ZONE_PRECISE_MOUTH = "crown",
		BODY_ZONE_PRECISE_NECK = "crown",
		BODY_ZONE_CHEST = "core",
		BODY_ZONE_L_ARM = "limb",
		BODY_ZONE_R_ARM = "limb",
		BODY_ZONE_PRECISE_L_HAND = "limb",
		BODY_ZONE_PRECISE_R_HAND = "limb",
		BODY_ZONE_L_LEG = "base",
		BODY_ZONE_R_LEG = "base",
		BODY_ZONE_PRECISE_L_FOOT = "base",
		BODY_ZONE_PRECISE_R_FOOT = "base",
		BODY_ZONE_PRECISE_STOMACH = "core",
		BODY_ZONE_PRECISE_GROIN = "core",
	)

/datum/anatomy/construct/primordial/build_zones()
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 120, break_wound = /datum/wound/cripple/arm/fracture, hint = "limbs")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 120, break_wound = /datum/wound/cripple/arm/fracture, hint = "limbs")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 120, break_wound = /datum/wound/cripple/limb/fracture, hint = "base")
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.25, part_health_minimum = 120, break_wound = /datum/wound/cripple/limb/fracture, hint = "base")

/* Deadite tough biped. Mirrors the living profile. They have a topple gated head that kills them outright.
*/
/datum/anatomy/biped/tough/undead
	bloodless = TRUE

/datum/anatomy/biped/tough/undead/build_zones()
	add_zone(BODY_ZONE_HEAD, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 100, break_wound = /datum/wound/cripple/fatal/decapitate, hint = "head", requires_prone = TRUE, melee_hit_bonus = -10, ranged_hit_bonus = -30)
	add_zone(BODY_ZONE_L_ARM, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 80, break_wound = /datum/wound/cripple/arm, hint = "arms")
	add_zone(BODY_ZONE_R_ARM, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 80, break_wound = /datum/wound/cripple/arm, hint = "arms")
	add_zone(BODY_ZONE_L_LEG, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 80, break_wound = /datum/wound/cripple/limb/topple, hint = "legs", melee_hit_bonus = 40)
	add_zone(BODY_ZONE_R_LEG, damage_mult = 1, part_health_fraction = 0.35, part_health_minimum = 80, break_wound = /datum/wound/cripple/limb/topple, hint = "legs", melee_hit_bonus = 40)
