/datum/npc_warband
	parent_type = /datum/npc_part
	abstract_type = /datum/npc_warband
	var/name = "warband"
	var/category
	var/faction_tag = ""
	var/gm_hidden = FALSE
	var/list/members
	var/threat_point = 0

/datum/npc_warband/New()
	. = ..()
	for(var/mob/living/member as anything in members)
		threat_point += initial(member.threat_point) * members[member]

/datum/npc_warband/proc/expand()
	. = list()
	for(var/mob/living/member as anything in members)
		for(var/i in 1 to members[member])
			. += member
