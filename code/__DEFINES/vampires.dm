#define VITAE_LEVEL_STARVING 100
#define VITAE_LEVEL_HUNGRY 250
#define VITAE_LEVEL_FED 500

#define BLOOD_PREFERENCE_ALL (BLOOD_PREFERENCE_RATS | BLOOD_PREFERENCE_HOLY | BLOOD_PREFERENCE_SLEEPING | BLOOD_PREFERENCE_LIVING | BLOOD_PREFERENCE_FANCY)

#define BLOOD_PREFERENCE_DEAD (1<<0)
#define BLOOD_PREFERENCE_LIVING (1<<1)
#define BLOOD_PREFERENCE_HOLY (1<<2)
#define BLOOD_PREFERENCE_SLEEPING (1<<3)
#define BLOOD_PREFERENCE_KIN (1<<4)
#define BLOOD_PREFERENCE_FANCY (1<<5)
#define BLOOD_PREFERENCE_RATS (1<<6)

#define GENERATION_METHUSELAH 4
#define GENERATION_ANCILLAE 3
#define GENERATION_NEONATE 2
#define GENERATION_THINBLOOD 1

#define GENERATION_MODIFIER 1

#define COVENS_PER_CLAN 3
#define COVENS_PER_WRETCH_CLAN 2

#define VAMP_CONVERT_TIMEOUT 4 MINUTES
#define VAMP_CONVERT_POST_STUN    1 MINUTES
#define VAMP_CONVERT_BLOOD_GAIN   500

/// Mandatory mofe_after() before a vampire can batform. (SHAPESHIFT_MOVEAFTER - vampire.generation) SECONDS
#define SHAPESHIFT_MOVEAFTER 5

/// Vitae drained from mobs **with client** is multiplied by this define
#define CLIENT_VITAE_MULTIPLIER 3
/// Given to the vampire in case their victim refuses to be converted. Given only once per unique vamp victim.
#define VITAE_PER_UNIQUE_CONVERSION_REJECT 500

GLOBAL_LIST_INIT(vamp_generation_to_text, list(
	"Thin Blood",
	"Neonate",
	"Ancillae",
	"Methuselah",
))
