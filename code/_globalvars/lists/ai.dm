///all basic ai subtrees
GLOBAL_LIST_EMPTY(ai_subtrees)

///basic ai controllers based on status
GLOBAL_LIST_INIT(ai_controllers_by_status, alist(
	AI_STATUS_ON = list(),
	AI_STATUS_OFF = list(),
	AI_STATUS_IDLE = list(),
))

///basic ai controllers based on their z level
GLOBAL_LIST_EMPTY(ai_controllers_by_zlevel)

///z-levels that are weatherproof (indoors) - AI sleeps on these when no clients present
GLOBAL_LIST_INIT(weatherproof_z_levels, list())
