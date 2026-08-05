/datum/log_category/attack
	category = LOG_CATEGORY_ATTACK
	config_flag = /datum/config_entry/flag/log_attack

/datum/log_category/character
	category = LOG_CATEGORY_CHARACTER

/datum/log_category/config
	category = LOG_CATEGORY_CONFIG

/datum/log_category/hunted
	category = LOG_CATEGORY_HUNTED

/datum/log_category/manifest
	category = LOG_CATEGORY_MANIFEST
	config_flag = /datum/config_entry/flag/log_manifest

/datum/log_category/quest
	category = LOG_CATEGORY_QUEST

// Logs seperately, printed into on server shutdown to store hard deletes and such
/datum/log_category/qdel
	category = LOG_CATEGORY_QDEL
	// We want this human readable so it's easy to see at a glance
	entry_flags = ENTRY_USE_DATA_W_READABLE
