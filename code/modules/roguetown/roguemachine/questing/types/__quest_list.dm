GLOBAL_LIST_INIT(global_quest_contract_groups, list(
	QUEST_GROUP_ERRANDS = list(QUEST_RETRIEVAL, QUEST_COURIER),
	QUEST_GROUP_BOUNTIES = list(QUEST_HUNT, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOSS),
))

GLOBAL_LIST_INIT(global_quest_registry, list(
	QUEST_RETRIEVAL = /datum/quest/retrieval,
	QUEST_COURIER = /datum/quest/courier,
	QUEST_HUNT = /datum/quest/kill/hunt,
	QUEST_CLEAR_OUT = /datum/quest/kill/clearout,
	QUEST_RAID = /datum/quest/kill/raid,
	QUEST_BOSS = /datum/quest/kill/boss,
))