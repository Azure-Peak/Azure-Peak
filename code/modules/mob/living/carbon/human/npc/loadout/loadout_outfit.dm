/datum/outfit/npc
	name = "NPC"
	var/list/loadouts

/datum/outfit/npc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	apply_loadouts(H, visualsOnly)

/datum/outfit/npc/proc/apply_loadouts(mob/living/carbon/human/H, visualsOnly = FALSE)
	for(var/path in loadouts)
		var/datum/npc_loadout/loadout = get_npc_part(path)
		if(!loadout)
			continue
		loadout.apply(src, H, visualsOnly)

