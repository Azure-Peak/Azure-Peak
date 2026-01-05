//config files
#define CONFIG_GET(X) global.config.Get(/datum/config_entry/##X)
#define CONFIG_SET(X, Y) global.config.Set(/datum/config_entry/##X, ##Y)

#ifndef MATURESERVER
#define CONFIG_MAPS_FILE "mapsrw.txt"
#else
#define CONFIG_MAPS_FILE "maps.txt"
#endif
//flags
/// can't edit
#define CONFIG_ENTRY_LOCKED 1
/// can't see value
#define CONFIG_ENTRY_HIDDEN 2

#define SIGNAL_HANDLER SHOULD_NOT_SLEEP(TRUE)

#define VALUE_MODE_NUM 0
#define VALUE_MODE_TEXT 1
#define VALUE_MODE_FLAG 2

#define KEY_MODE_TEXT 0
#define KEY_MODE_TYPE 1
