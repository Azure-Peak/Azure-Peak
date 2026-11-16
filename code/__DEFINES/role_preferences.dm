

//Values for antag preferences, event roles, etc. unified here



//These are synced with the Database, if you change the values of the defines
//then you MUST update the database!
#define ROLE_MANIAC				"Maniac"
#define ROLE_WEREWOLF			"Werewolf"
#define ROLE_VAMPIRE			"Vampire"
#define ROLE_NBEAST				"Vampire Lord"
#define ROLE_BANDIT				"Bandit"
#define ROLE_ASSASSIN			"Assassin"
#define ROLE_DELF				"Dark Elf"
#define ROLE_PREBEL				"Peasant Rebel"
#define ROLE_REBEL_LEADER		"Rebellion Leader"
#define ROLE_ASPIRANT			"Aspirant"
#define ROLE_LICH				"Lich"
#define ROLE_DREAMWALKER		"Dreamwalker"
#define ROLE_GNOLL				"Gnoll"
#define ROLE_HAG				"Hag"
#define ROLE_ASCENDANT			"Ascendant"
#define ROLE_WRETCH				"Wretch"
#define ROLE_UNBOUND_DEATHKNIGHT "Unbound Death Knight"
#define ROLE_DARK_ITINERANT "Dark Itinerant"
#define ROLE_RENEGADE			"Renegade"
#define ROLE_ANTAGONIST			"Antagonist"

#define ROLE_SYNDICATE			"Syndicate"
#define ROLE_TRAITOR			"Traitor"
#define ROLE_OPERATIVE			"Operative"
#define ROLE_CHANGELING			"Changeling"
#define ROLE_WIZARD				"Wizard"
#define ROLE_MALF				"Malf AI"
#define ROLE_REV				"Revolutionary"
#define ROLE_REV_HEAD			"Head Revolutionary"
#define ROLE_PAI				"pAI"
#define ROLE_CULTIST			"Cultist"
#define ROLE_BLOB				"Blob"
#define ROLE_NINJA				"Space Ninja"
#define ROLE_ABDUCTOR			"Abductor"
#define ROLE_REVENANT			"Revenant"
#define ROLE_DEVIL				"Devil"
#define ROLE_BROTHER			"Blood Brother"
#define ROLE_BRAINWASHED		"Brainwashed Victim"
#define ROLE_OVERTHROW			"Syndicate Mutineer"		//Role removed, left here for safety.
#define ROLE_HIVE				"Hivemind Host"				//Role removed, left here for safety.
#define ROLE_OBSESSED				"Obsessed"
#define ROLE_SENTIENCE			"Sentience Potion Spawn"
#define ROLE_MIND_TRANSFER		"Mind Transfer Potion"
#define ROLE_POSIBRAIN			"Posibrain"
#define ROLE_DRONE				"Drone"
#define ROLE_DEATHSQUAD			"Deathsquad"
#define ROLE_LAVALAND			"Lavaland"
#define ROLE_INTERNAL_AFFAIRS	"Internal Affairs Agent"
#define ROLE_NECRO_SKELETON		"Necromancer Skeleton"
#define ROLE_SIEGE_SKELETON		"Siege Skeleton"
#define ROLE_LICH_SKELETON		"Lich Skeleton"
#define ROLE_CHOSEN				"Chosen"
#define ROLE_VAMPIRE_SUMMON		"Vampire Summon"
#define ROLE_NOTORIOUS_BOUNTY	"Notorious Bounty Target"

GLOBAL_LIST_INIT(special_roles_rogue, list(
	ROLE_MANIAC = /datum/antagonist/maniac,
	ROLE_PREBEL = /datum/antagonist/prebel,
	ROLE_REBEL_LEADER = /datum/antagonist/prebel/head,
	ROLE_BANDIT = /datum/antagonist/bandit,
	ROLE_ASPIRANT = /datum/antagonist/aspirant,
	ROLE_WEREWOLF = /datum/antagonist/werewolf,
	ROLE_NBEAST = /datum/antagonist/vampire/lord,
	ROLE_VAMPIRE = /datum/antagonist/vampire,
	ROLE_LICH = /datum/antagonist/lich,
	ROLE_DREAMWALKER = /datum/antagonist/dreamwalker,
	ROLE_GNOLL = /datum/antagonist/gnoll,
	ROLE_ASSASSIN = /datum/antagonist/assassin,
	ROLE_HAG = /datum/antagonist/hag,
	ROLE_RENEGADE = /datum/antagonist/renegade,
))

//ADD BACK DARK ELF AND MANIAC TO THE LIST IF THEY ARE EVER REENABLED
GLOBAL_LIST_INIT(antagonist_ban_groups, list(
	"All Antagonists" = list(ROLE_ANTAGONIST),
	"Major Antagonists" = list(ROLE_ASCENDANT, ROLE_ASPIRANT, ROLE_BANDIT, ROLE_HAG, ROLE_NBEAST, ROLE_WEREWOLF, ROLE_LICH, ROLE_PREBEL, ROLE_REBEL_LEADER, ROLE_RENEGADE),
	"Lesser Antagonists" = list(ROLE_WRETCH, ROLE_DREAMWALKER, ROLE_GNOLL, ROLE_VAMPIRE, ROLE_ASSASSIN),
	"Antagonist Ghost Roles" = list(ROLE_NECRO_SKELETON, ROLE_LICH_SKELETON, ROLE_UNBOUND_DEATHKNIGHT, ROLE_DARK_ITINERANT, ROLE_VAMPIRE_SUMMON, ROLE_NOTORIOUS_BOUNTY),
))

//Job defines for what happens when you fail to qualify for any job during job selection
#define BEOVERFLOW	1
#define BERANDOMJOB "Be Random Role"
#define RETURNTOLOBBY	"Return to Lobby"
