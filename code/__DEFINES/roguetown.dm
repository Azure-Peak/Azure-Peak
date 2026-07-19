/*STAT DEFINES*/
#define STAT_STRENGTH "strength"
#define STAT_PERCEPTION "perception"
#define STAT_INTELLIGENCE "intelligence"
#define STAT_CONSTITUTION "constitution"
#define STAT_WILLPOWER "willpower"
#define STAT_SPEED "speed"
#define STAT_FORTUNE "fortune"

// Weapon balance defines
#define WBALANCE_NORMAL 0
#define WBALANCE_HEAVY -1
#define WBALANCE_SWIFT 1

//Coverage defines
#define COVERAGE_HEAD_NOSE		( HEAD | HAIR | EARS | NOSE )
#define COVERAGE_HEAD			( HEAD | HAIR | EARS )
#define COVERAGE_NASAL			( HEAD | HAIR | NOSE )
#define COVERAGE_SKULL			( HEAD | HAIR )

#define COVERAGE_VEST				( CHEST | VITALS )
#define COVERAGE_SHIRT				( CHEST | VITALS | ARMS )
#define COVERAGE_TORSO				( CHEST | GROIN | VITALS )
#define COVERAGE_ALL_BUT_ARMS		( CHEST | GROIN | VITALS | LEGS | FEET)
#define COVERAGE_ALL_BUT_LEGS		( CHEST | GROIN | VITALS | ARMS | HANDS)
#define COVERAGE_ALL_BUT_HANDLEGS	( CHEST | GROIN | VITALS | ARMS)
#define COVERAGE_ALL_BUT_HANDFEET	( CHEST | GROIN | VITALS | LEGS | ARMS)
#define COVERAGE_ALL_BUT_ARMFEET	( CHEST | GROIN | VITALS | LEGS )
#define COVERAGE_FULL				( CHEST | GROIN | VITALS | LEGS | ARMS | HANDS | FEET)
#define COVERAGE_NEARLY_FULL		( HEAD | CHEST | GROIN | VITALS | LEGS | ARMS | HANDS | FEET)
#define COVERAGE_FULL_BODY_ACTUAL	( HEAD | HAIR | EARS | EYES | NOSE | MOUTH | NECK | CHEST | GROIN | VITALS | LEGS | ARMS | HANDS | FEET)

#define COVERAGE_PANTS			( GROIN | LEGS )
#define COVERAGE_ALL_BUT_HANDFEET_LEG		( LEGS | FEET )

/*
Balloon Alert / Floating Text defines
*/
#define XP_SHOW_COOLDOWN (0.5 SECONDS)


//used in various places
#define ALL_RACES_TYPES list(\
	/datum/species/human/northern,\
	/datum/species/human/halfelf,\
	/datum/species/elf/dark,\
	/datum/species/elf/dark/raider,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/dwarf/mountain,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lizardfolk,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/anthromorph,\
	/datum/species/anthromorphsmall,\
	/datum/species/demihuman,\
	/datum/species/halforc,\
	/datum/species/kobold,\
	/datum/species/goblinp,\
	/datum/species/dullahan,\
	/datum/species/ooze,\
  /datum/species/dwarf/gnome\
)

#define RACES_RESPECTED \
	/datum/species/human/northern,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/human/halfelf,\
	/datum/species/dwarf/mountain,\
	/datum/species/aasimar,\
	/datum/species/lupian,\
	/datum/species/vulpkanin,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/dwarf/gnome\

#define RACES_RESPECTED_NO_AASIMAR \
	/datum/species/human/northern,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/human/halfelf,\
	/datum/species/dwarf/mountain,\
	/datum/species/lupian,\
	/datum/species/vulpkanin,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/dwarf/gnome\

#define RACES_TOLERATED \
	/datum/species/elf/dark,\
	/datum/species/tieberian,\
	/datum/species/lizardfolk,\
	/datum/species/tabaxi,\
	/datum/species/akula,\
	/datum/species/anthromorph,\
	/datum/species/demihuman,\
	/datum/species/halforc,\

#define RACES_SHUNNED \
	/datum/species/anthromorphsmall,\
	/datum/species/kobold,\
	/datum/species/goblinp,\
	/datum/species/ooze,\

#define RACES_DESPISED \
	/datum/species/dullahan,\

#define RACES_CONSTRUCT \
	/datum/species/construct/metal,\

#define RACES_OOZE \
	/datum/species/ooze,\


#define RACES_AASIMAR \
	/datum/species/aasimar, \

// Small races, usually applied due to sprite limits.
#define RACES_SMALL \
	/datum/species/dwarf/mountain,\
	/datum/species/kobold,\
	/datum/species/anthromorphsmall,\
	/datum/species/dwarf/gnome,\

// All but d. elves.
#define RACES_ANTHRAX \
	/datum/species/human/northern,\
	/datum/species/human/halfelf,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/dwarf/mountain,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lizardfolk,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/anthromorph,\
	/datum/species/anthromorphsmall,\
	/datum/species/demihuman,\
	/datum/species/halforc,\
	/datum/species/kobold,\
	/datum/species/goblinp,\
	/datum/species/dullahan,\
	/datum/species/dwarf/gnome,\
	/datum/species/construct/metal,\
	/datum/species/ooze,\

// All but elves & half-elves.
#define RACES_BLACKOAK \
	/datum/species/human/northern,\
	/datum/species/elf/dark/raider,\
	/datum/species/dwarf/mountain,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lizardfolk,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/anthromorph,\
	/datum/species/anthromorphsmall,\
	/datum/species/demihuman,\
	/datum/species/halforc,\
	/datum/species/kobold,\
	/datum/species/goblinp,\
	/datum/species/dullahan,\
	/datum/species/dwarf/gnome,\
	/datum/species/construct/metal,\
	/datum/species/ooze,\

// All but dwarves.
#define RACES_GRUDGE \
	/datum/species/human/northern,\
	/datum/species/human/halfelf,\
	/datum/species/elf/dark,\
	/datum/species/elf/dark/raider,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lizardfolk,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/anthromorph,\
	/datum/species/anthromorphsmall,\
	/datum/species/demihuman,\
	/datum/species/halforc,\
	/datum/species/kobold,\
	/datum/species/goblinp,\
	/datum/species/dullahan,\
	/datum/species/dwarf/gnome,\
	/datum/species/construct/metal,\
	/datum/species/ooze,\

// All but Dwarves, Gnomes, Kobolds, D. Elves, Oozes, Moths & Anthrosmall
#define RACES_UNDERDARK \
	/datum/species/human/northern,\
	/datum/species/human/halfelf,\
	/datum/species/elf/dark/raider,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lizardfolk,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/dracon,\
	/datum/species/anthromorph,\
	/datum/species/demihuman,\
	/datum/species/halforc,\
	/datum/species/dullahan,\


// All but Dracon, Lizardfolk, Kobolds.
#define RACES_LIRVAS\
	/datum/species/human/northern,\
	/datum/species/human/halfelf,\
	/datum/species/elf/dark,\
	/datum/species/elf/dark/raider,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/dwarf/mountain,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/moth,\
	/datum/species/anthromorph,\
	/datum/species/anthromorphsmall,\
	/datum/species/demihuman,\
	/datum/species/halforc,\
	/datum/species/goblinp,\
	/datum/species/dullahan,\
	/datum/species/dwarf/gnome,\
	/datum/species/construct/metal,\
	/datum/species/ooze,\


#define NOBLE_RACES_TYPES list(\
	/datum/species/human/northern,\
	/datum/species/human/halfelf,\
	/datum/species/elf/dark,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/dwarf/mountain,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lizardfolk,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/anthromorph,\
	/datum/species/anthromorphsmall,\
	/datum/species/demihuman,\
	/datum/species/kobold,\
	/datum/species/goblinp,\
)

#define CLOTHED_RACES_TYPES list(\
	/datum/species/human/northern,\
	/datum/species/human/halfelf,\
	/datum/species/elf/dark,\
	/datum/species/elf/dark/raider,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/dwarf/mountain,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lizardfolk,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/anthromorph,\
	/datum/species/anthromorphsmall,\
	/datum/species/demihuman,\
	/datum/species/halforc,\
	/datum/species/orc,\
	/datum/species/kobold,\
	/datum/species/goblinp,\
	/datum/species/construct/metal,\
	/datum/species/dullahan,\
	/datum/species/dwarf/gnome,\
	/datum/species/ooze\
)
// Non-dwarf non-kobold non-goblin mostly
#define NON_DWARVEN_RACE_TYPES list(\
	/datum/species/human/northern,\
	/datum/species/human/halfelf,\
	/datum/species/elf/dark,\
	/datum/species/elf/dark/raider,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lizardfolk,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/anthromorph,\
	/datum/species/demihuman,\
	/datum/species/halforc,\
	/datum/species/construct/metal,\
	/datum/species/dullahan,\
	/datum/species/ooze,\
)
// Non-elf non-dwarf non-kobold non-goblin mostly
#define HUMANLIKE_RACE_TYPES list(\
	/datum/species/human/northern,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lizardfolk,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/anthromorph,\
	/datum/species/demihuman,\
	/datum/species/construct/metal,\
	/datum/species/dullahan,\
	/datum/species/ooze,\
)

/*Used for races that won't break the game completely if an NPC picks from this listing - Or look terrible like, really, really terrible.

HARD NOS:
-> Reverents (Head/Body issues + NPCs can't use this properly)
-> Constructs (Meant to be RARE, keep them solely limited to NPC types MEANT for them)
-> Assimar (Pure lux via lux extraction, balance issues)


Notable but possible races
-> Drow axed for now to avoid extra checks until I proc the voice + hair stuff properly in a refactor to make their hair white + yellow/red/green eye colors more often
-> Murklings as well because y'know, hair is supposed to be body-colored since they're just gloop of some assimulated fool
-> Anthromorphs/lizards look poor without their snouts, like really, really goofy af.

-> some other races look bad but they're semi-acceptable for now I.E teiflings/halfkin since they don't come w/ears and tails randomly.

Regards: Shadows
PS: You may also wanna split this list for regional stuff + weight stuff in future.
We also might want a proper NPC randomise set of verbs for less copypasting shit over and over, I've been meaning for that but not gotten to it yet.

To avoid TOO much conflicts w/random char parts, consider a proc that checks if we have X race and applies features out of a listing. Its kinda janky but its an idea.

*/
#define NPC_RACES_TYPES list(\
	/datum/species/human/northern,\
	/datum/species/human/halfelf,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/dwarf/mountain,\
	/datum/species/tieberian,\
	/datum/species/demihuman,\
	/datum/species/halforc,\
	/datum/species/goblinp,\
	/datum/species/dwarf/gnome\
)

#define OLD_GOD_PATRON list(/datum/patron/old_god)

#define ALL_CLERIC_PATRONS list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/necra, /datum/patron/divine/pestra, /datum/patron/divine/ravox, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/divine/undivided) // Currently unused.

#define ALL_PALADIN_PATRONS list(/datum/patron/divine/undivided, /datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/abyssor, /datum/patron/divine/dendor, /datum/patron/divine/necra, /datum/patron/divine/pestra, /datum/patron/divine/ravox, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/divine/xylix, /datum/patron/old_god) // Currently unused.

#define ALL_ACOLYTE_PATRONS list(/datum/patron/divine/undivided, /datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/pestra, /datum/patron/divine/ravox, /datum/patron/divine/eora, /datum/patron/divine/xylix, /datum/patron/divine/necra, /datum/patron/divine/abyssor, /datum/patron/divine/malum) // Currently unused.

#define ALL_DIVINE_PATRONS list(/datum/patron/divine/undivided, /datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/ravox, /datum/patron/divine/necra, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora)

#define ALL_GRONNIC_PATRONS list(/datum/patron/inhumen/zizo, /datum/patron/inhumen/graggar, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha, /datum/patron/divine/abyssor, /datum/patron/divine/dendor)

#define ALL_INHUMEN_PATRONS list(/datum/patron/inhumen/zizo, /datum/patron/inhumen/graggar, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)

#define NON_PSYDON_PATRONS list(/datum/patron/divine/undivided, /datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/ravox, /datum/patron/divine/necra, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/inhumen/zizo, /datum/patron/inhumen/graggar, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)	//For lord/heir usage

#define ALL_PATRONS  list(/datum/patron/divine/undivided, /datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/ravox, /datum/patron/divine/necra, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/old_god, /datum/patron/inhumen/zizo, /datum/patron/inhumen/graggar, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)

#define ALL_SLAYER_PATRONS list(/datum/patron/divine/malum, /datum/patron/divine/ravox)

#define ALL_KAZENGUN_PATRONS list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/abyssor, /datum/patron/divine/dendor, /datum/patron/divine/necra, /datum/patron/divine/pestra, /datum/patron/divine/ravox, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/divine/xylix, /datum/patron/old_god, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha) //the twelve + saidon

#define PLATEHIT "plate"
#define CHAINHIT "chain"
#define SOFTHIT "soft"
#define SOFTUNDERHIT "softunder" // This is just for the soft underarmors like gambesons and arming jackets so they can be worn with light armors that use the same sound like studded leather

/proc/get_armor_sound(blocksound, blade_dulling)
	switch(blocksound)
		if(PLATEHIT)
			if(blade_dulling == BCLASS_CUT||blade_dulling == BCLASS_CHOP)
				return pick('sound/combat/hits/armor/plate_slashed (1).ogg','sound/combat/hits/armor/plate_slashed (2).ogg','sound/combat/hits/armor/plate_slashed (3).ogg','sound/combat/hits/armor/plate_slashed (4).ogg')
			if(blade_dulling == BCLASS_STAB||blade_dulling == BCLASS_PICK||blade_dulling == BCLASS_BITE)
				return pick('sound/combat/hits/armor/plate_stabbed (1).ogg','sound/combat/hits/armor/plate_stabbed (2).ogg','sound/combat/hits/armor/plate_stabbed (3).ogg')
			else
				return pick('sound/combat/hits/armor/plate_blunt (1).ogg','sound/combat/hits/armor/plate_blunt (2).ogg','sound/combat/hits/armor/plate_blunt (3).ogg')
		if(CHAINHIT)
			if(blade_dulling == BCLASS_BITE||blade_dulling == BCLASS_STAB||blade_dulling == BCLASS_PICK||blade_dulling == BCLASS_CUT||blade_dulling == BCLASS_CHOP)
				return pick('sound/combat/hits/armor/chain_slashed (1).ogg','sound/combat/hits/armor/chain_slashed (2).ogg','sound/combat/hits/armor/chain_slashed (3).ogg','sound/combat/hits/armor/chain_slashed (4).ogg')
			else
				return pick('sound/combat/hits/armor/chain_blunt (1).ogg','sound/combat/hits/armor/chain_blunt (2).ogg','sound/combat/hits/armor/chain_blunt (3).ogg')
		if(SOFTHIT)
			if(blade_dulling == BCLASS_BITE||blade_dulling == BCLASS_STAB||blade_dulling == BCLASS_PICK||blade_dulling == BCLASS_CUT||blade_dulling == BCLASS_CHOP)
				return pick('sound/combat/hits/armor/light_stabbed (1).ogg','sound/combat/hits/armor/light_stabbed (2).ogg','sound/combat/hits/armor/light_stabbed (3).ogg')
			else
				return pick('sound/combat/hits/armor/light_blunt (1).ogg','sound/combat/hits/armor/light_blunt (2).ogg','sound/combat/hits/armor/light_blunt (3).ogg')
		if(SOFTUNDERHIT)
			if(blade_dulling == BCLASS_BITE||blade_dulling == BCLASS_STAB||blade_dulling == BCLASS_PICK||blade_dulling == BCLASS_CUT||blade_dulling == BCLASS_CHOP)
				return pick('sound/combat/hits/armor/light_stabbed (1).ogg','sound/combat/hits/armor/light_stabbed (2).ogg','sound/combat/hits/armor/light_stabbed (3).ogg')
			else
				return pick('sound/combat/hits/armor/light_blunt (1).ogg','sound/combat/hits/armor/light_blunt (2).ogg','sound/combat/hits/armor/light_blunt (3).ogg')

GLOBAL_LIST_INIT(lockhashes, list())
GLOBAL_LIST_INIT(lockids, list())
GLOBAL_LIST_EMPTY(credits_icons)
GLOBAL_LIST_EMPTY(indexed)
GLOBAL_LIST_EMPTY(cursedsamples)
GLOBAL_LIST_EMPTY(accused)
GLOBAL_LIST_EMPTY(confessors)

//preference stuff
#define FAMILY_NONE 1
#define FAMILY_PARTIAL 2
#define FAMILY_FULL 3

GLOBAL_LIST_EMPTY(head_bounties)
GLOBAL_LIST_EMPTY(noticeboard_notices)
GLOBAL_LIST_EMPTY(noticeboard_listings)
GLOBAL_LIST_EMPTY(job_respawn_delays)
GLOBAL_LIST_EMPTY(round_join_times)

//stress levels
#define STRESS_MAX 30
#define STRESS_INSANE 7
#define STRESS_VBAD 5
#define STRESS_BAD 3
#define STRESS_NEUTRAL 2
#define STRESS_GOOD 1
#define STRESS_VGOOD 0

/*
	Formerly bitflags, now we are strings
	Currently used for classes
*/

#define CTAG_ALLCLASS		"CAT_ALLCLASS"		// jus a define for allclass to not deal with actively typing strings
#define CTAG_DISABLED 		"CAT_DISABLED" 		// Disabled, aka don't make it fuckin APPEAR
#define CTAG_PILGRIM 		"CAT_PILGRIM"  		// Pilgrim classes
#define CTAG_ADVENTURER 	"CAT_ADVENTURER"  	// Adventurer classes
#define CTAG_TOWNER 		"CAT_TOWNER"  		// Villager class - Villagers can use it
#define CTAG_ANTAG 			"CAT_ANTAG"  		// Antag class - results in an antag
#define CTAG_BANDIT			"CAT_BANDIT"		// Bandit class - Tied to the bandit antag really
#define CTAG_ASSASSIN		"CAT_ASSASSIN"		// Assassin classes - Tied to the assassin antag for specialization
#define CTAG_CHALLENGE 		"CAT_CHALLENGE"  	// Challenge class - Meant to be free for everyone
#define CTAG_VAGABOND		"CAT_VAGABOND"		// Vagabond class - start with nothing and work your way up
#define CTAG_ORTHODOXIST	"CAT_ORTHODOXIST"	// For Orthodoxist subclasses
#define CTAG_INQUSITOR		"CAT_INQUISITOR"	// For Inquisitor subclasses
#define CTAG_ABSOLVER		"CAT_ABSOLVER"		// For Absolver (sub)class
#define CTAG_COURTAGENT		"CAT_COURTAGENT"	// Court agent classes
#define CTAG_WRETCH			"CAT_WRETCH"		// Wretch classes untethered from adventurer
#define CTAG_TRADER			"CAT_TRADER"		// Trader classes untethered from adventurer
#define CTAG_LSKELETON		"CAT_LSKELETON"		// Lich Fortified Skeleton classes
#define CTAG_NSKELETON		"CAT_NSKELETON"		// Necromancer Greater Skeleton classes
#define CTAG_SSKELETON		"CAT_SSKELETON"		// Disposable Bad Omen Skeleton Classes
#define CTAG_VAMPSERVANT	"CAT_VAMPSERVANT"	// Vampire lord bloodpool servant classes
#define CTAG_VAMPGUARD		"CAT_VAMPGUARD"		// Vampire Lord bloodpool guard classes
#define CTAG_VAMPSPAWN		"CAT_VAMPSPAWN"		// Vampire Lord bloodpool elite classes
#define CTAG_LICKER_WRETCH  "CAT_LICKER_WRETCH" // Licker wretch. Nuff said.
#define CTAG_GNOLL			"CAT_GNOLL"			// Wretch-esque gnolls, graggar's chosen.
#define CTAG_GNOLL_IMPURE	"CAT_GNOLL_IMPURE"	// Reward for beating enough gnolls.
#define CTAG_HAG			"CAT_HAG"

#define CTAG_WARDEN			"CAT_WARDEN"		// Warden class - Handles warden class selector.
#define CTAG_WATCH			"CAT_WATCH"			// Watch class - Handles Town Watch class selector
#define CTAG_MENATARMS		"CAT_MENATARMS"		// Men-at-Arms class - Handles Men-at-Arms class selector
#define CTAG_SERGEANT		"CAT_SERGEANT"		// Sergeant class - Handles Sergeant class selector (weapons selection)
#define CTAG_ROYALGUARD		"CAT_ROYALGUARD"	// Royal Guard class - Handles Royal Guard class selector
#define CTAG_CONSORT		"CAT_CONSORT"		// Consort/Suitor subclasses
#define CTAG_MERCENARY		"CAT_MERCENARY"		// Mercenary class - Handles Mercenary class selector
#define CTAG_HAND			"CAT_HAND"			// Hand class - Handles Hand class selector
#define CTAG_TEMPLAR		"CAT_TEMPLAR"		// Templar class - Handles Templar class selector
#define CTAG_SEXTON			"CAT_SEXTON"		// Sexton class - Handles Sexton class selector
#define CTAG_HEIR			"CAT_HEIR"			// Prince(cess) class - Handles Heir class selector
#define CTAG_LORD			"CAT_LORD"			// Lord class - Handles Lord class selector
#define CTAG_SQUIRE			"CAT_SQUIRE"		// Squire class - Handles Squire class selector
#define CTAG_VETERAN		"CAT_VETERAN"		// Veteran class - Handles Veteran class selector
#define CTAG_MARSHAL		"CAT_MARSHAL"		// Marshal class
#define CTAG_SENESCHAL		"CAT_SENESCHAL"		// Seneschal's aesthetic choices.
#define CTAG_SERVANT		"CAT_SERVANT"		// Servant's aesthetic choices.
#define CTAG_WAPPRENTICE	"CTAG_WAPPRENTICE"	// Mage Apprentice Classes - Handles Mage Apprentices class selector
#define CTAG_GUILDSMASTER 	"CAT_GUILDSMASTER"	// Guildsmaster class - Handles Guildsmaster class selector
#define CTAG_GUILDSMEN 		"CAT_GUILDSMEN"		// Guildsmen class - Handles Guildsmen class selector
#define CTAG_BATHWORKER		"CAT_BATHWORKER"	// Bathhouse Attendant's aesthetic choices.

// List of Migrant Classes.
#define CTAG_HFT_LORD "CAT_HFT_LORD"  // Heartfelt Lord Class - Handles Heartfelt Lord class selector.
#define CTAG_HFT_HAND "CAT_HFT_HAND"  // Heartfelt Hand Class - Handles Heartfelt Hand class selector.
#define CTAG_HFT_KNIGHT "CAT_HFT_KNIGHT"  // Heartfelt Knight Class - Handles Heartfelt Knight class selector.
#define CTAG_HFT_RETINUE "CAT_HFT_RETINUE"  // Heartfelt Retinue Class - Handles Heartfelt Retinue class selector.

// List of mono-class categories. Only here for standardisation sake, but can be added on if desired.
#define CTAG_BISHOP			"CAT_BISHOP"
#define CTAG_MARTYR			"CAT_MARTYR"
#define CTAG_ACOLYTE		"CAT_ACOLYTE"
#define CTAG_DRUID			"CAT_DRUID"

#define CTAG_STEWARD		"CAT_STEWARD"
#define CTAG_CLERK			"CAT_CLERK"
#define CTAG_COUNCILLOR		"CAT_COUNCIL"

#define CTAG_COURTMAGE		"CAT_COURTMAGE"

#define CTAG_COURTPHYS		"CAT_COURTPHYS"
#define CTAG_APOTH			"CAT_APOTH"

#define CTAG_MERCH			"CAT_MERCH"
#define CTAG_SHOPHAND		"CAT_SHOPHAND"
#define CTAG_ARCHIVIST		"CAT_ARCHIVIST"
#define CTAG_KEEPER			"CAT_KEEPER"
#define CTAG_TAILOR			"CAT_TAILOR"
#define CTAG_SOILBRIDE		"CAT_SOILBRIDE"
#define CTAG_INNKEEPER		"CAT_INNKEEPER"
#define CTAG_COOK			"CAT_COOK"
#define CTAG_BATHMOM		"CAT_BATHMOM"
#define CTAG_TAPSTER		"CAT_TAPSTER"
#define CTAG_LUNATIC		"CAT_LUNATIC"
/*
	Defines for the triumph buy datum categories
*/
#define TRIUMPH_CAT_ROUND_EFX "ROUND-EFX"
#define TRIUMPH_CAT_CHARACTER "CHARACTER"
#define TRIUMPH_CAT_MISC "MISC!"
#define TRIUMPH_CAT_ACTIVE_DATUMS "ACTIVE"

#define ARMOR_CLASS_NONE 0
#define ARMOR_CLASS_LIGHT 1
#define ARMOR_CLASS_MEDIUM 2
#define ARMOR_CLASS_HEAVY 3

/*
	Defines for class select categories
*/

//Adventurer categories
#define CLASS_CAT_NOBLE	"Noble"
#define CLASS_CAT_CLERIC "Cleric"
#define CLASS_CAT_ROGUE	"Rogue"
#define CLASS_CAT_MYSTIC "Mystic"
#define CLASS_CAT_RANGER "Ranger"
#define CLASS_CAT_MAGE "Mage"
#define CLASS_CAT_WARRIOR "Warrior"
#define CLASS_CAT_TRADER "Trader"
#define CLASS_CAT_NOMAD "Nomad"

//Wretch categories
#define CLASS_CAT_ACCURSED "Accursed"
#define CLASS_CAT_BATTLEMAGE "Battlemage"

//Mercenary categories
#define CLASS_CAT_ETRUSCA "Etrusca"
#define CLASS_CAT_GRENZELHOFT "Grenzelhoft"
#define CLASS_CAT_NALEDI "Naledi"
#define CLASS_CAT_RANESHENI "Ranesheni"
#define CLASS_CAT_AAVNR "Aavnr"
#define CLASS_CAT_GRONN "Gronn"
#define CLASS_CAT_OTAVA "Otava"
#define CLASS_CAT_KAZENGUN "Kazengun"
#define CLASS_CAT_RACIAL "Race Exclusive" //Used for black oaks, grudgebearer dwarves, etc.

//Migrant categories
#define CLASS_CAT_HFT_COURT "Upper Court"
#define CLASS_CAT_HFT_GUARD "House Guard"
#define CLASS_CAT_HFT_WORKER "Workers"

//Armor material categories
#define ARMOR_MAT_PLATE 1
#define ARMOR_MAT_LEATHER 2
#define ARMOR_MAT_CHAINMAIL 3
