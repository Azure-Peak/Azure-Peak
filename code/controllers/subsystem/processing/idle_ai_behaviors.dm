PROCESSING_SUBSYSTEM_DEF(idle_ai_behaviors)
	name = "idle_ai_behaviors"
	flags = SS_NO_INIT | SS_BACKGROUND
	wait = 10 SECONDS // AP: Idle mobs have no nearby players — no need to wander frequently
	priority = FIRE_PRIORITY_IDLE_NPC
	init_order = INIT_ORDER_AI_IDLE_CONTROLLERS //must execute only after ai behaviors are initialized
