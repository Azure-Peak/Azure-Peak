//Investigate logging defines
#define INVESTIGATE_ATMOS			"atmos"
#define INVESTIGATE_BOTANY			"botany"
#define INVESTIGATE_CARGO			"cargo"
#define INVESTIGATE_EXPERIMENTOR	"experimentor"
#define INVESTIGATE_RECORDS			"records"
#define INVESTIGATE_SINGULO			"singulo"
#define INVESTIGATE_SUPERMATTER		"supermatter"
#define INVESTIGATE_TELESCI			"telesci"
#define INVESTIGATE_WIRES			"wires"
#define INVESTIGATE_PORTAL			"portals"
#define INVESTIGATE_RESEARCH		"research"
#define INVESTIGATE_HALLUCINATIONS	"hallucinations"
#define INVESTIGATE_RADIATION		"radiation"
#define INVESTIGATE_EXONET			"exonet"
#define INVESTIGATE_NANITES			"nanites"
#define INVESTIGATE_PRESENTS		"presents"

// Logging types for log_message()
#define LOG_ATTACK			(1 << 0)
#define LOG_SAY				(1 << 1)
#define LOG_WHISPER			(1 << 2)
#define LOG_EMOTE			(1 << 3)
#define LOG_DSAY			(1 << 4)
#define LOG_PDA				(1 << 5)
#define LOG_CHAT			(1 << 6)
#define LOG_COMMENT			(1 << 7)
#define LOG_TELECOMMS		(1 << 8)
#define LOG_OOC				(1 << 9)
#define LOG_ADMIN			(1 << 10)
#define LOG_OWNERSHIP		(1 << 11)
#define LOG_GAME			(1 << 12)
#define LOG_ADMIN_PRIVATE	(1 << 13)
#define LOG_ASAY			(1 << 14)
#define LOG_MECHA			(1 << 15)
#define LOG_VIRUS			(1 << 16)
#define LOG_CLONING			(1 << 17)
#define LOG_LOOC			(1 << 18)
#define LOG_SEEN			(1 << 19)
#define LOG_NPC_SAY			(1 << 20)
#define LOG_CRAFT			(1 << 21)

#define SEEN_LOG_SAY 1
#define SEEN_LOG_EMOTE 2
#define SEEN_LOG_ATTACK 3

//Individual logging panel pages
#define INDIVIDUAL_ATTACK_LOG		(LOG_ATTACK)
#define INDIVIDUAL_SAY_LOG			(LOG_SAY | LOG_WHISPER | LOG_DSAY)
#define INDIVIDUAL_NPC_SAY_LOG		(LOG_NPC_SAY)
#define INDIVIDUAL_EMOTE_LOG		(LOG_EMOTE)
#define INDIVIDUAL_COMMS_LOG		(LOG_PDA | LOG_CHAT | LOG_COMMENT | LOG_TELECOMMS)
#define INDIVIDUAL_OOC_LOG			(LOG_OOC | LOG_ADMIN)
#define INDIVIDUAL_LOOC_LOG			(LOG_LOOC | LOG_ADMIN)
#define INDIVIDUAL_OWNERSHIP_LOG	(LOG_OWNERSHIP)
#define INDIVIDUAL_SHOW_ALL_LOG		(LOG_ATTACK | LOG_SAY | LOG_WHISPER | LOG_EMOTE | LOG_DSAY | LOG_PDA | LOG_CHAT | LOG_COMMENT | LOG_TELECOMMS | LOG_OOC | LOG_ADMIN | LOG_OWNERSHIP | LOG_GAME | LOG_CRAFT | LOG_NPC_SAY)
#define INDIVIDUAL_SEEN_LOG		(LOG_SEEN)

#define LOGSRC_CLIENT "Client"
#define LOGSRC_MOB "Mob"
/// The number of entries to store per category, don't make this too large or you'll start to see performance issues
#define CONFIG_MAX_CACHED_LOG_ENTRIES 1000

/// The number of *minimum* ticks between each log re-render, making this small will cause performance issues
/// Admins can still manually request a re-render
#define LOG_UPDATE_TIMEOUT 5 SECONDS

// Log entry keys
#define LOG_ENTRY_KEY_TIMESTAMP "ts"
#define LOG_ENTRY_KEY_CATEGORY "cat"
#define LOG_ENTRY_KEY_MESSAGE "msg"
#define LOG_ENTRY_KEY_DATA "data"
#define LOG_ENTRY_KEY_WORLD_STATE "w-state"
#define LOG_ENTRY_KEY_SEMVER_STORE "s-store"
#define LOG_ENTRY_KEY_ID "id"
#define LOG_ENTRY_KEY_SCHEMA_VERSION "s-ver"

////////////////////// CATEGORIES

// Internal categories
#define LOG_CATEGORY_INTERNAL_CATEGORY_NOT_FOUND "internal-category-not-found"
#define LOG_CATEGORY_INTERNAL_ERROR "internal-error"

// Misc categories
#define LOG_CATEGORY_ATTACK "attack"
#define LOG_CATEGORY_CHARACTER "character"
#define LOG_CATEGORY_CONFIG "config"
#define LOG_CATEGORY_HUNTED "hunted"
#define LOG_CATEGORY_MANIFEST "manifest"
#define LOG_CATEGORY_QDEL "qdel"
#define LOG_CATEGORY_QUEST "quest"
#define LOG_CATEGORY_RUNTIME "runtime"

// Admin categories
#define LOG_CATEGORY_ADMIN "admin"
#define LOG_CATEGORY_ADMIN_DSAY "admin-dsay"

// Admin private categories
#define LOG_CATEGORY_ADMIN_PRIVATE "adminprivate"
#define LOG_CATEGORY_ADMIN_PRIVATE_ASAY "adminprivate-asay"

// Debug categories
#define LOG_CATEGORY_DEBUG "debug"
#define LOG_CATEGORY_DEBUG_ASSET "debug-asset"
#define LOG_CATEGORY_DEBUG_JOB "debug-job"
#define LOG_CATEGORY_DEBUG_MAPPING "debug-mapping"
#define LOG_CATEGORY_DEBUG_SQL "debug-sql"

// Game categories
#define LOG_CATEGORY_GAME "game"
#define LOG_CATEGORY_GAME_ACCESS "game-access"
#define LOG_CATEGORY_GAME_EMOTE "game-emote"
#define LOG_CATEGORY_GAME_LOOC "game-looc"
#define LOG_CATEGORY_GAME_OOC "game-ooc"
#define LOG_CATEGORY_GAME_PAPER "game-paper"
#define LOG_CATEGORY_GAME_PRAYER "game-prayer"
#define LOG_CATEGORY_GAME_SAY "game-say"
#define LOG_CATEGORY_GAME_TOPIC "game-topic"
#define LOG_CATEGORY_GAME_VOTE "game-vote"
#define LOG_CATEGORY_GAME_WHISPER "game-whisper"
#define LOG_CATEGORY_GAME_CRAFT "game-craft"

// HREF categories
#define LOG_CATEGORY_HREF "href"
#define LOG_CATEGORY_HREF_TGUI "href-tgui"

////////////////////// CATEGORIES END

// Flags that apply to the entry_flags var on logging categories
// These effect how entry datums process the inputs passed into them
/// Enables data list usage for readable log entries
/// You'll likely want to disable internal formatting to make this work properly
#define ENTRY_USE_DATA_W_READABLE (1<<0)

#define SCHEMA_VERSION "schema-version"

// Default log schema version
#define LOG_CATEGORY_SCHEMA_VERSION_NOT_SET "0.0.1"
