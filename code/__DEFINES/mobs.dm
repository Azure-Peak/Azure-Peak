/*ALL MOB-RELATED DEFINES THAT DON'T BELONG IN ANOTHER FILE GO HERE*/

#define STATKEY_STR "strength"
#define STATKEY_PER "perception"
#define STATKEY_INT "intelligence"
#define STATKEY_CON "constitution"
#define STATKEY_WIL "willpower"
#define STATKEY_SPD "speed"
#define STATKEY_LCK "fortune"

//This was previously in vampirelord.dm and mob/living/stats.dm, the person defined it twice because vampirelord came in below that stats file, so now both of them can get it here.
#define MOBSTATS list(STATKEY_STR, STATKEY_PER, STATKEY_INT, STATKEY_CON, STATKEY_WIL, STATKEY_SPD, STATKEY_LCK)

//Misc mob defines

//for vision cone
#define FOV_DEFAULT 	           	(1<<0)
#define FOV_RIGHT 	            	(1<<1)
#define FOV_LEFT 	            	(1<<2)
#define FOV_BEHIND 	 	          	(1<<3) //180

//Ready states at roundstart for mob/dead/new_player
#define PLAYER_NOT_READY 0
#define PLAYER_READY_TO_PLAY 1
#define PLAYER_READY_TO_OBSERVE 2

//movement intent defines for the m_intent var
#define MOVE_INTENT_WALK "walk"
#define MOVE_INTENT_RUN  "run"
#define MOVE_INTENT_SNEAK "sneak"

//resist
#define RESIST_INTENT 0
#define SUBMIT_INTENT 1

//Blood levels
#define BLOOD_VOLUME_MAXIMUM 1120
#define BLOOD_VOLUME_SLIME_SPLIT 1120
#define BLOOD_VOLUME_NORMAL 560
#define BLOOD_VOLUME_SAFE 475
#define BLOOD_VOLUME_OKAY 336
#define BLOOD_VOLUME_BAD 224
#define BLOOD_VOLUME_SURVIVE 122

/// Blood pool regeneration in non-vampiric living mobs per SSmobs tick. 
#define BLOODPOL_REGEN 2

//Sizes of mobs, used by mob/living/var/mob_size
#define MOB_SIZE_TINY 0
#define MOB_SIZE_SMALL 1
#define MOB_SIZE_HUMAN 2
#define MOB_SIZE_LARGE 3

//Ventcrawling defines
#define VENTCRAWLER_NONE   0
#define VENTCRAWLER_NUDE   1
#define VENTCRAWLER_ALWAYS 2

//Bloodcrawling defines
#define BLOODCRAWL 1
#define BLOODCRAWL_EAT 2

//Mob bio-types flags
#define MOB_ORGANIC 	1 << 0
#define MOB_MINERAL		1 << 1
#define MOB_ROBOTIC 	1 << 2
#define MOB_UNDEAD		1 << 3
#define MOB_HUMANOID 	1 << 4
#define MOB_BUG 		1 << 5
#define MOB_BEAST		1 << 6
#define MOB_EPIC		1 << 7 //megafauna
#define MOB_REPTILE		1 << 8
#define MOB_SPIRIT		1 << 9

//Organ defines for carbon mobs
#define ORGAN_ORGANIC   1
#define ORGAN_ROBOTIC   2

#define BODYPART_ORGANIC   1
#define BODYPART_ROBOTIC   2

#define BODYPART_NOT_DISABLED 0
#define BODYPART_DISABLED_DAMAGE 1
#define BODYPART_DISABLED_PARALYSIS 2 //either a fall or twisting the limb
#define BODYPART_DISABLED_WOUND 3 //bone fracture
#define BODYPART_DISABLED_ROT 4 //limb is rotten oh nooo
#define BODYPART_DISABLED_CLAMPED 5 //limb is clamped by a hemostat or speculum

#define DEFAULT_BODYPART_ICON_ORGANIC 'icons/mob/human_parts_greyscale.dmi'
#define DEFAULT_BODYPART_ICON_ROBOTIC 'icons/mob/augmentation/augments.dmi'

#define MONKEY_BODYPART "monkey"
#define DEVIL_BODYPART "devil"
/*see __DEFINES/inventory.dm for bodypart bitflag defines*/

// Health/damage defines for carbon mobs
#define HUMAN_MAX_OXYLOSS 3
#define HUMAN_CRIT_MAX_OXYLOSS (SSmobs.wait/30)

#define STAMINA_REGEN_BLOCK_TIME (10 SECONDS)

#define HEAT_DAMAGE_LEVEL_1 1 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 1 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 1 //Amount of damage applied when your body temperature passes the 460K point and you are on fire

#define COLD_DAMAGE_LEVEL_1 1 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 1 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 1 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 1 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 1 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

//Brain Damage defines
#define BRAIN_DAMAGE_MILD 20
#define BRAIN_DAMAGE_SEVERE 100
#define BRAIN_DAMAGE_DEATH 200

#define BRAIN_TRAUMA_MILD /datum/brain_trauma/mild
#define BRAIN_TRAUMA_SEVERE /datum/brain_trauma/severe
#define BRAIN_TRAUMA_SPECIAL /datum/brain_trauma/special
#define BRAIN_TRAUMA_MAGIC /datum/brain_trauma/magic

#define TRAUMA_RESILIENCE_BASIC 1      //Curable with chems
#define TRAUMA_RESILIENCE_SURGERY 2    //Curable with brain surgery
#define TRAUMA_RESILIENCE_LOBOTOMY 3   //Curable with lobotomy
#define TRAUMA_RESILIENCE_MAGIC 4      //Curable only with magic
#define TRAUMA_RESILIENCE_ABSOLUTE 5   //This is here to stay

//Limit of traumas for each resilience tier
#define TRAUMA_LIMIT_BASIC 3
#define TRAUMA_LIMIT_SURGERY 2
#define TRAUMA_LIMIT_LOBOTOMY 3
#define TRAUMA_LIMIT_MAGIC 3
#define TRAUMA_LIMIT_ABSOLUTE INFINITY

#define BRAIN_DAMAGE_INTEGRITY_MULTIPLIER 0.5

//Surgery Defines
#define BIOWARE_GENERIC "generic"
#define BIOWARE_NERVES "nerves"
#define BIOWARE_CIRCULATION "circulation"
#define BIOWARE_LIGAMENTS "ligaments"

//Health hud screws for carbon mobs
#define SCREWYHUD_NONE 0
#define SCREWYHUD_CRIT 1
#define SCREWYHUD_DEAD 2
#define SCREWYHUD_HEALTHY 3

//Threshold levels for beauty for humans
#define BEAUTY_LEVEL_HORRID -66
#define BEAUTY_LEVEL_BAD -33
#define BEAUTY_LEVEL_DECENT 33
#define BEAUTY_LEVEL_GOOD 66
#define BEAUTY_LEVEL_GREAT 100

//Moods levels for humans
#define MOOD_LEVEL_HAPPY4 15
#define MOOD_LEVEL_HAPPY3 10
#define MOOD_LEVEL_HAPPY2 6
#define MOOD_LEVEL_HAPPY1 2
#define MOOD_LEVEL_NEUTRAL 0
#define MOOD_LEVEL_SAD1 -3
#define MOOD_LEVEL_SAD2 -7
#define MOOD_LEVEL_SAD3 -15
#define MOOD_LEVEL_SAD4 -20

//Sanity levels for humans
#define SANITY_MAXIMUM 150
#define SANITY_GREAT 125
#define SANITY_NEUTRAL 100
#define SANITY_DISTURBED 75
#define SANITY_UNSTABLE 50
#define SANITY_CRAZY 25
#define SANITY_INSANE 0

//Nutrition levels for humans
#define NUTRITION_LEVEL_FULL 1000
#define NUTRITION_LEVEL_FAT 800
#define NUTRITION_LEVEL_WELL_FED 700
#define NUTRITION_LEVEL_DEATHLESS 700
#define NUTRITION_LEVEL_FED 500
#define NUTRITION_LEVEL_HUNGRY 350
#define NUTRITION_LEVEL_STARVING 100

#define HYDRATION_LEVEL_FULL 1000
#define HYDRATION_LEVEL_HYDRATED 999
#define HYDRATION_LEVEL_DEATHLESS 700
#define HYDRATION_LEVEL_SMALLTHIRST 600
#define HYDRATION_LEVEL_THIRSTY 350
#define HYDRATION_LEVEL_DEHYDRATED 100

#define NUTRITION_LEVEL_START_MIN 500
#define NUTRITION_LEVEL_START_MAX 900

#define HYDRATION_LEVEL_START_MIN 500
#define HYDRATION_LEVEL_START_MAX 600

//Disgust levels for humans
#define DISGUST_LEVEL_MAXEDOUT 150
#define DISGUST_LEVEL_DISGUSTED 75
#define DISGUST_LEVEL_VERYGROSS 50
#define DISGUST_LEVEL_GROSS 25
#define DISGUST_LEVEL_SLIGHTLYGROSS 10

//Used as an upper limit for species that continuously gain nutriment
#define NUTRITION_LEVEL_ALMOST_FULL 995

//Charge levels for Ethereals
#define ETHEREAL_CHARGE_NONE 0
#define ETHEREAL_CHARGE_LOWPOWER 20
#define ETHEREAL_CHARGE_NORMAL 50
#define ETHEREAL_CHARGE_ALMOSTFULL 75
#define ETHEREAL_CHARGE_FULL 100

//Slime evolution threshold. Controls how fast slimes can split/grow
#define SLIME_EVOLUTION_THRESHOLD 10

//Slime extract crossing. Controls how many extracts is required to feed to a slime to core-cross.
#define SLIME_EXTRACT_CROSSING_REQUIRED 10

//Slime commands defines
#define SLIME_FRIENDSHIP_FOLLOW 			3 //Min friendship to order it to follow
#define SLIME_FRIENDSHIP_STOPEAT 			5 //Min friendship to order it to stop eating someone
#define SLIME_FRIENDSHIP_STOPEAT_NOANGRY	7 //Min friendship to order it to stop eating someone without it losing friendship
#define SLIME_FRIENDSHIP_STOPCHASE			4 //Min friendship to order it to stop chasing someone (their target)
#define SLIME_FRIENDSHIP_STOPCHASE_NOANGRY	6 //Min friendship to order it to stop chasing someone (their target) without it losing friendship
#define SLIME_FRIENDSHIP_STAY				3 //Min friendship to order it to stay
#define SLIME_FRIENDSHIP_ATTACK				8 //Min friendship to order it to attack

//Sentience types, to prevent things like sentience potions from giving bosses sentience
#define SENTIENCE_ORGANIC 1
#define SENTIENCE_ARTIFICIAL 2
// #define SENTIENCE_OTHER 3 unused
#define SENTIENCE_MINEBOT 4
#define SENTIENCE_BOSS 5

//Mob AI Status

//Hostile simple animals
//If you add a new status, be sure to add a list for it to the simple_animals global in _globalvars/lists/mobs.dm
#define AI_ON		1
#define AI_IDLE		2
#define AI_OFF		3
#define AI_Z_OFF	4

// these are exclusively for hostile humantype mobs
#define NPC_AI_OFF		0
#define NPC_AI_IDLE		1
#define NPC_AI_COMBAT	2
#define NPC_AI_RETREAT	3
#define NPC_AI_HUNT		4
#define NPC_AI_FLEE		5
#define NPC_AI_SLEEP    6

//determines if a mob can smash through it
#define ENVIRONMENT_SMASH_NONE			0
#define ENVIRONMENT_SMASH_STRUCTURES	(1<<0) 	//crates, lockers, ect
#define ENVIRONMENT_SMASH_WALLS			(1<<1)  //walls
#define ENVIRONMENT_SMASH_RWALLS		(1<<2)	//rwalls

#define NO_SLIP_WHEN_WALKING	(1<<0)
#define SLIDE					(1<<1)
#define GALOSHES_DONT_HELP		(1<<2)
#define SLIDE_ICE				(1<<3)
#define SLIP_WHEN_CRAWLING		(1<<4) //clown planet ruin

#define MAX_CHICKENS 50

///Flags used by the flags parameter of electrocute act.

///Makes it so that the shock doesn't take gloves into account.
#define SHOCK_NOGLOVES (1 << 0)
///Used when the shock is from a tesla bolt.
#define SHOCK_TESLA (1 << 1)
///Used when an illusion shocks something. Makes the shock deal stamina damage and not trigger certain secondary effects.
#define SHOCK_ILLUSION (1 << 2)
///The shock doesn't stun.
#define SHOCK_NOSTUN (1 << 3)

#define INCORPOREAL_MOVE_BASIC 1
#define INCORPOREAL_MOVE_SHADOW 2 // leaves a trail of shadows
#define INCORPOREAL_MOVE_JAUNT 3 // is blocked by holy water/salt

//Secbot and ED209 judgement criteria bitflag values
#define JUDGE_EMAGGED		(1<<0)
#define JUDGE_IDCHECK		(1<<1)
#define JUDGE_WEAPONCHECK	(1<<2)
#define JUDGE_RECORDCHECK	(1<<3)
//ED209's ignore monkeys
#define JUDGE_IGNOREMONKEYS	(1<<4)

#define MEGAFAUNA_DEFAULT_RECOVERY_TIME 5

#define SHADOW_SPECIES_LIGHT_THRESHOLD 0.2

// Offsets defines

#define OFFSET_UNIFORM "uniform"
#define OFFSET_ID "wear_ring"
#define OFFSET_GLOVES "gloves"
#define OFFSET_WRISTS "wear_wrists"
#define OFFSET_GLASSES "glasses"
#define OFFSET_EARS "ears"
#define OFFSET_SHOES "shoes"
#define OFFSET_S_STORE "s_store"
#define OFFSET_FACEMASK "mask"
#define OFFSET_HEAD "head"
#define OFFSET_FACE "face" //facial hair and hair
#define OFFSET_BELT "belt"
#define OFFSET_BACK "back"
#define OFFSET_SUIT "suit"
#define OFFSET_NECK "neck"
#define OFFSET_CLOAK "cloak"
#define OFFSET_MOUTH "mouth"
#define OFFSET_PANTS "wear_pants"
#define OFFSET_SHIRT "wear_shirt"
#define OFFSET_ARMOR "wear_armor"
#define OFFSET_HANDS "hands"
#define OFFSET_UNDIES "underwear"

#define OFFSET_ID_F "wear_ringf"
#define OFFSET_GLOVES_F "glovesf"
#define OFFSET_WRISTS_F "wear_wristsf"
#define OFFSET_FACEMASK_F "maskf"
#define OFFSET_HEAD_F "headf"
#define OFFSET_FACE_F "facef"
#define OFFSET_BELT_F "beltf"
#define OFFSET_BACK_F "backf"
#define OFFSET_NECK_F "neckf"
#define OFFSET_CLOAK_F "cloakf"
#define OFFSET_MOUTH_F "mouthf"
#define OFFSET_PANTS_F "wear_pantsf"
#define OFFSET_SHIRT_F "wear_shirtf"
#define OFFSET_ARMOR_F "wear_armorf"
#define OFFSET_HANDS_F "handsf"
#define OFFSET_UNDIES_F "underwearf"

//MINOR TWEAKS/MISC
#define AGE_MIN				18	//youngest a character can be
#define AGE_MAX				85	//oldest a character can be
#define WIZARD_AGE_MIN		30	//youngest a wizard can be
#define APPRENTICE_AGE_MIN	29	//youngest an apprentice can be
#define SHOES_SLOWDOWN		0	//How much shoes slow you down by default. Negative values speed you up
#define POCKET_STRIP_DELAY			40	//time taken (in deciseconds) to search somebody's pockets
#define DOOR_CRUSH_DAMAGE	15	//the amount of damage that airlocks deal when they crush you

#define HUNGER_FACTOR		0.15	//factor at which mob nutrition decreases
#define ETHEREAL_CHARGE_FACTOR	0.12 //factor at which ethereal's charge decreases
#define REAGENTS_METABOLISM 1	//How many units of reagent are consumed per tick, by default.
#define REAGENTS_EFFECT_MULTIPLIER (REAGENTS_METABOLISM / 0.4)	// By defining the effect multiplier this way, it'll exactly adjust all effects according to how they originally were with the 0.4 metabolism

// Eye protection
#define FLASH_PROTECTION_SENSITIVE -1
#define FLASH_PROTECTION_NONE 0
#define FLASH_PROTECTION_FLASH 1
#define FLASH_PROTECTION_WELDER 2

// Roundstart trait system

#define MAX_QUIRKS 6 //The maximum amount of quirks one character can have at roundstart

// AI Toggles
#define AI_CAMERA_LUMINOSITY	5
#define AI_VOX // Comment out if you don't want VOX to be enabled and have players download the voice sounds.

// /obj/item/bodypart on_mob_life() retval flag
#define BODYPART_LIFE_UPDATE_HEALTH (1<<0)

// Pending icon update bitflags for deferred batching
#define PENDING_UPDATE_BODY       (1<<0)
#define PENDING_UPDATE_HAIR       (1<<1)
#define PENDING_UPDATE_DAMAGE     (1<<2)
#define PENDING_UPDATE_INV_HANDS  (1<<3)
#define PENDING_UPDATE_INV_GLOVES (1<<4)
#define PENDING_UPDATE_INV_SHOES  (1<<5)
#define PENDING_UPDATE_INV_HEAD   (1<<6)
#define PENDING_UPDATE_INV_BELT   (1<<7)
#define PENDING_UPDATE_INV_BACK   (1<<8)
#define PENDING_UPDATE_INV_ARMOR  (1<<9)
#define PENDING_UPDATE_INV_SHIRT  (1<<10)
#define PENDING_UPDATE_INV_PANTS  (1<<11)
#define PENDING_UPDATE_INV_CLOAK  (1<<12)
#define PENDING_UPDATE_INV_ALL    (PENDING_UPDATE_INV_HANDS|PENDING_UPDATE_INV_GLOVES|PENDING_UPDATE_INV_SHOES|PENDING_UPDATE_INV_HEAD|PENDING_UPDATE_INV_BELT|PENDING_UPDATE_INV_BACK|PENDING_UPDATE_INV_ARMOR|PENDING_UPDATE_INV_SHIRT|PENDING_UPDATE_INV_PANTS|PENDING_UPDATE_INV_CLOAK)

#define MAX_REVIVE_FIRE_DAMAGE 180
#define MAX_REVIVE_BRUTE_DAMAGE 180

#define HUMAN_FIRE_STACK_ICON_NUM	5

#define GRAB_PIXEL_SHIFT_PASSIVE 6
#define GRAB_PIXEL_SHIFT_AGGRESSIVE 12
#define GRAB_PIXEL_SHIFT_NECK 16

#define PULL_PRONE_SLOWDOWN 2
#define HUMAN_CARRY_SLOWDOWN 0

//Flags that control what things can spawn species (whitelist)
//Badmin magic mirror
#define MIRROR_BADMIN (1<<0)
//Standard magic mirror (wizard)
#define MIRROR_MAGIC  (1<<1)
//Pride ruin mirror
#define MIRROR_PRIDE  (1<<2)
//Race swap wizard event
#define RACE_SWAP     (1<<3)
//xenobio black crossbreed
#define SLIME_EXTRACT (1<<5)
//Wabbacjack staff projectiles
#define WABBAJACK     (1<<6)

#define SLEEP_CHECK_DEATH(X) sleep(X); if(QDELETED(src) || stat == DEAD) return;

//defense intents
#define INTENT_DODGE 1
#define INTENT_PARRY 2

//skin tones defines

//DWARF SKIN TONES
#define SKIN_COLOR_PLATINUM "ffe0d1"
#define SKIN_COLOR_AURUM "fcccb3"
#define SKIN_COLOR_QUICKSILVER "edc6b3"
#define SKIN_COLOR_BRASS "e2b9a3"
#define SKIN_COLOR_IRON "d9a284"
#define SKIN_COLOR_MALACHITE "c69b83"
#define SKIN_COLOR_OBSIDIAN "3b2e27"
#define SKIN_COLOR_BRIMSTONE "271f1a"
#define SKIN_COLOR_JADE "d6bea9"
#define SKIN_COLOR_CERAGYRITE "4c4a4f"

//DARK ELF SKIN TONES
#define SKIN_COLOR_COMMORAH "9796a9"
#define SKIN_COLOR_GLOOMHAVEN "897489"
#define SKIN_COLOR_DARKPILA "938f9c"
#define SKIN_COLOR_SSHANNTYNLAN "746e6e"
#define SKIN_COLOR_LLURTH_DREIR "6a616d"
#define SKIN_COLOR_TAFRAVMA "5f5f70"
#define SKIN_COLOR_YUETHINDRYNN "2f2f38"
#define SKIN_COLOR_KOREDYNN "32356b"
#define SKIN_COLOR_AISEEDRYNN "a3c1c9"
#define SKIN_COLOR_GRENDUSKRA "8b8585"
#define SKIN_COLOR_HUNSEK "6c6799"

//GNOME UNIQUE SKIN TONES
#define SKIN_COLOR_ASHEN "A79E96"
#define SKIN_COLOR_UNDERDARK "7C8A97"
#define SKIN_COLOR_BEACH "BE9D7B"
#define SKIN_COLOR_PALM "795138"

//WOOD ELF SKIN TONES
#define SKIN_COLOR_GRENZEL_WOODS "fff0e9"
#define SKIN_COLOR_DANDELION_CREEK "ffe0d1"
#define SKIN_COLOR_ROSEVEIL "fcccb3"
#define SKIN_COLOR_AZUREGROVE "edc6b3"
#define SKIN_COLOR_ARBORSHOME "e2b9a3"
#define SKIN_COLOR_ETRUSCAN_SWAMPS "d9a284"
#define SKIN_COLOR_ALMONDVALLE "c9a893"
#define SKIN_COLOR_WALNUT_WOODS "ba9882"
#define SKIN_COLOR_SHALVINE_FORESTS "ac8369"
#define SKIN_COLOR_LALVE_STEPPES "9c6f52"
#define SKIN_COLOR_NALEDI_COAST "4e3729"
#define SKIN_COLOR_TIMBERBORN "5d4c41"
#define SKIN_COLOR_LOTUS_COAST "eae1C8"


//SUN ELF SKIN TONES
#define SKIN_COLOR_DAWN "eaCebe"
#define SKIN_COLOR_MORNING "dbaB8f"
#define SKIN_COLOR_NOON "be8f73"
#define SKIN_COLOR_EVENING "a57962"
#define SKIN_COLOR_SUNSET "7B5752"  
#define SKIN_COLOR_DUSK "564044" 
#define SKIN_COLOR_GILDED "e1b772"
#define SKIN_COLOR_SELFBRASS "d6a35b"

//HUMEN SKIN TONES
#define SKIN_COLOR_GRENZELHOFT "fff0e9"
#define SKIN_COLOR_HAMMERHOLD "ffe0d1"
#define SKIN_COLOR_AVAR "fcccb3"
#define SKIN_COLOR_ROCKHILL "edc6b3"
#define SKIN_COLOR_OTAVA "e2b9a3"
#define SKIN_COLOR_ETRUSCA "d9a284"
#define SKIN_COLOR_GRONN "c9a893"
#define SKIN_COLOR_GIZA "ba9882"
#define SKIN_COLOR_SHALVISTINE "ac8369"
#define SKIN_COLOR_LALVESTINE "9c6f52"
#define SKIN_COLOR_NALEDI "4e3729"
#define SKIN_COLOR_KAZENGUN "dbcca9"
#define SKIN_COLOR_NALEDI_LIGHT "5d4c41"

//DULLAHAN SKIN TONES
#define SKIN_COLOR_PALE_GRENZELHOFT "ebdad2"
#define SKIN_COLOR_PALE_HAMMERHOLD "ffe0d1"
#define SKIN_COLOR_PALE_EBON "54463d"
#define SKIN_COLOR_PALE_KAZENGUN "c9a893"

//AASIMAR SKIN TONES
#define SKIN_COLOR_CULTOR "b5a4a4"
#define SKIN_COLOR_SPIRITUS "f0eded"
#define SKIN_COLOR_PLANETAR "ffd859"
#define SKIN_COLOR_DEVA "b6f1f2"
#define SKIN_COLOR_SOLAR "daeaeb"
#define SKIN_COLOR_EMPYREA "a9ded1"
#define SKIN_COLOR_GAEIA "db874f"
#define SKIN_COLOR_CELESTIAL "e1c565"
#define SKIN_COLOR_OLYMPIA "c7f9cc"
#define SKIN_COLOR_NECRAL "23130c"
#define SKIN_COLOR_ABYSSAL "22577a"

//HALF ELF SKIN TONES
#define SKIN_COLOR_GRENZEL_AVAR "fff0e9"
#define SKIN_COLOR_TIMBER_GRONN "ffe0d1"
#define SKIN_COLOR_GIZA_AZURE "fcccb3"
#define SKIN_COLOR_WALNUT_STINE "edc6b3"
#define SKIN_COLOR_ETRUSTCAN_DANDELION "e2b9a3"
#define SKIN_COLOR_NALEDI_BORN "5a4a41"
#define SKIN_COLOR_KAZE_LOTUS "E0D5B8"
#define SKIN_COLOR_ETRUSCA_LIRVAS "d9a284"
#define SKIN_COLOR_FREE_FOLK "c9a893"
#define SKIN_COLOR_AVAR_BORNE "ba9882"
#define SKIN_COLOR_SHALVINE_AZURE "ac8369"
#define SKIN_COLOR_LALVE_NALEDI "9c6f52"
#define SKIN_COLOR_NALEDI_OTAVA "4e3729"
#define SKIN_COLOR_HAMMER_GRONN "5d4c41"

//HALF ORK SKIN TONES
#define SKIN_COLOR_BLOOD_AXE "A84C4F"
#define SKIN_COLOR_GROONN "50715C"
#define SKIN_COLOR_BLACK_HAMMER "1B2B21"
#define SKIN_COLOR_SHELLCREST "3C5166"
#define SKIN_COLOR_SKULL_SEEKER "3D3725"
#define SKIN_COLOR_CRESCENT_FANG "8A8951"
#define SKIN_COLOR_MURKWALKER "716646"
#define SKIN_COLOR_SHATTERHORN "D6D5E2"
#define SKIN_COLOR_SPIRITCRUSHER "9D4D62"

//TIEFLING SKIN TONES
#define SKIN_COLOR_NESSYSS "C62D4C"
#define SKIN_COLOR_VHESLYN "991F1D"
#define SKIN_COLOR_SARVYRA "80284a"
#define SKIN_COLOR_JEHOEL "DBA960"
#define SKIN_COLOR_URVIX "5B5F96"
#define SKIN_COLOR_ARLENNETH "9197C5"
#define SKIN_COLOR_HELIXIA "B289C6"
#define SKIN_COLOR_NYMSEA "A8619E"
#define SKIN_COLOR_CALVUS "E0CED8"
#define SKIN_COLOR_VOIBION "53392f"
#define SKIN_COLOR_CHYERNO "252e41"
#define SKIN_COLOR_DREMA "D16A51"
#define SKIN_COLOR_CHIR "549ab6"
#define SKIN_COLOR_VESYL "7a2525"
#define SKIN_COLOR_KROSEC "f9f9f9"
#define SKIN_COLOR_ASZA "7a5497"
#define SKIN_COLOR_KRIZZSHA "a191cc"
#define SKIN_COLOR_TOSIZ "5b7343"
#define SKIN_COLOR_VELOTHEL "87a665"
#define SKIN_COLOR_XIR "dbb189"
#define SKIN_COLOR_ESSE "886537"

//GOBLIN SKIN TONES
#define SKIN_COLOR_OCHRE "968127"
#define SKIN_COLOR_MEADOW "909630"
#define SKIN_COLOR_OLIVE "6b8a08"
#define SKIN_COLOR_GREEN "4c6835"
#define SKIN_COLOR_MOSS "43533e"
#define SKIN_COLOR_TAIGA "373f29"
#define SKIN_COLOR_BRONZE "725237"
#define SKIN_COLOR_RED "87312a"
#define SKIN_COLOR_TEAL "008080"
#define SKIN_COLOR_FROST "6486b0"
#define SKIN_COLOR_ABYSS "2a6986"
#define SKIN_COLOR_HADAL "24353d"
#define SKIN_COLOR_PEA	"a9b994"

//ARGONIAN SKIN TONES
#define SKIN_COLOR_AQUARELA "ffff88"
#define SKIN_COLOR_AMOR "f47174"
#define SKIN_COLOR_SANGUE "ff0000"
#define SKIN_COLOR_LAMA "cd853f"
#define SKIN_COLOR_AMAZONIA "32cd32"
#define SKIN_COLOR_SERRA "6b8e23"

//SPECIAL SKIN TONES
#define SKIN_COLOR_ROT "878f79"

//LIZARD SKIN TONES
#define LIZARD_SKIN_SUNNY "cdae46"
#define LIZARD_SKIN_DARKSKY "78a0a1"
#define LIZARD_SKIN_GREY "899596"
#define LIZARD_SKIN_GREENY "84aea4"
#define LIZARD_SKIN_BROWN "865331"
#define LIZARD_SKIN_CELESTIAL "9d8947"
#define LIZARD_SKIN_OLYMPIA "7a9d7d"
#define LIZARD_SKIN_NECRAL "502b1b"
#define LIZARD_SKIN_ABYSSAL "255b80"

//TABAXI FUR COLOR
#define ORANGE_FUR "de7642"
#define LIGHTGREY_FUR "a8aa97"
#define DARKGREY_FUR "677881"
#define LIGHTORANGE_FUR "da672a"
#define LIGHTBROWN_FUR "6d4530"
#define WHITEBROWN_FUR "c69b83"
#define DARKBROWN_FUR "3b2e27"
#define BLACK_FUR	 "271f1a"

// Pixel shifting
#define PIXEL_SHIFT_MAXIMUM 16
#define PIXEL_SHIFT_PASSABLE_THRESHOLD 8

#define TYPING_INDICATOR_TIMEOUT 20 MINUTES

// NPC Debugging
#ifdef NPC_THINK_DEBUG
#define NPC_THINK(message) visible_message(message, runechat_message = message)
#else
#define NPC_THINK(message)
#endif
