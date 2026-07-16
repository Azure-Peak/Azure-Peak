GLOBAL_VAR_INIT(log_directory, "data/logs/") // See world.dm for the full calculated path
GLOBAL_PROTECT(log_directory)

#define DECLARE_LOG_NAMED(log_var_name, log_file_name, start)\
GLOBAL_VAR(##log_var_name);\
GLOBAL_PROTECT(##log_var_name);\
/world/_initialize_log_files(temp_log_override = null){\
	..();\
	GLOB.##log_var_name = temp_log_override || "[GLOB.log_directory]/[##log_file_name].log";\
	if(!temp_log_override && ##start){\
		start_log(GLOB.##log_var_name);\
	}\
}

#define DECLARE_LOG(log_name, start) DECLARE_LOG_NAMED(##log_name, "[copytext(#log_name, 1, length(#log_name) - 3)]", start)
#define START_LOG TRUE
#define DONT_START_LOG FALSE

/// Populated by log declaration macros to set log file names and start messages
/world/proc/_initialize_log_files(temp_log_override = null)
	// Needs to be here to avoid compiler warnings
	SHOULD_CALL_PARENT(TRUE)
	return

// All individual log files.
// These should be used where the log category cannot easily be a json log file.
DECLARE_LOG(config_error_log, DONT_START_LOG)
DECLARE_LOG(perf_log, DONT_START_LOG) // Declared here but name is set in time_track subsystem

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
DECLARE_LOG_NAMED(test_log, "tests", START_LOG)
#endif

GLOBAL_VAR(round_id)
GLOBAL_PROTECT(round_id)

GLOBAL_LIST_EMPTY(character_list)
GLOBAL_LIST_EMPTY(character_ckey_list)
GLOBAL_LIST_EMPTY(actors_list)
GLOBAL_LIST_EMPTY(roleplay_ads)
GLOBAL_VAR(rogue_round_id)

GLOBAL_LIST_EMPTY(bombers)
GLOBAL_PROTECT(bombers)
GLOBAL_LIST_EMPTY(admin_log)
GLOBAL_PROTECT(admin_log)
GLOBAL_LIST_EMPTY(lastsignalers)	//keeps last 100 signals here in format: "[src] used [REF(src)] @ location [src.loc]: [freq]/[code]"
GLOBAL_PROTECT(lastsignalers)
GLOBAL_LIST_EMPTY(lawchanges) //Stores who uploaded laws to which silicon-based lifeform, and what the law was
GLOBAL_PROTECT(lawchanges)

GLOBAL_LIST_EMPTY(combatlog)
GLOBAL_PROTECT(combatlog)
GLOBAL_LIST_EMPTY(IClog)
GLOBAL_PROTECT(IClog)
GLOBAL_LIST_EMPTY(OOClog)
GLOBAL_PROTECT(OOClog)
GLOBAL_LIST_EMPTY(adminlog)
GLOBAL_PROTECT(adminlog)

GLOBAL_LIST_EMPTY(active_turfs_startlist)

/////Picture logging
GLOBAL_VAR(picture_log_directory)
GLOBAL_PROTECT(picture_log_directory)

GLOBAL_VAR_INIT(picture_logging_id, 1)
GLOBAL_PROTECT(picture_logging_id)
GLOBAL_VAR(picture_logging_prefix)
GLOBAL_PROTECT(picture_logging_prefix)
/////

#undef DECLARE_LOG
#undef DECLARE_LOG_NAMED
#undef START_LOG
#undef DONT_START_LOG
