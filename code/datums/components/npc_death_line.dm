GLOBAL_LIST_INIT(npc_death_lines, world.file2list("strings/rt/npc_death_lines.txt"))
GLOBAL_LIST_INIT(npc_death_lines_goblin, world.file2list("strings/rt/npc_death_lines_goblin.txt"))

/// Makes an NPC say a dying line when killed.
/// Uses the global npc_death_lines list by default, or pass a custom list.
/// Usage: AddComponent(/datum/component/npc_death_line) or AddComponent(/datum/component/npc_death_line, list("custom1"), 50)
/datum/component/npc_death_line
	var/list/messages
	var/chance = 100

/datum/component/npc_death_line/Initialize(list/death_messages, trigger_chance = 100)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	messages = length(death_messages) ? death_messages : GLOB.npc_death_lines
	chance = trigger_chance
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_death))

/datum/component/npc_death_line/Destroy()
	messages = null
	return ..()

/datum/component/npc_death_line/proc/on_death(datum/source, gibbed)
	SIGNAL_HANDLER
	if(!prob(chance))
		return
	var/mob/living/owner = parent
	var/message = pick(messages)
	owner.visible_message(span_say("[owner] gasps, \"[message]\""))
