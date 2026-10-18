/obj/item/quest_writ/blockade
	name = "blockade defense scroll"
	desc = "A scroll to break a blockade. Travel to the blockaded region and defeat three waves of raiders. \
	Each wave must fall within fifteen minutes. The Steward may recall the scroll if you take too long to get there. \
	Hand it to someone to start the contract. Pinned to the Contract Ledger, it needs a fellowship of three. \
	The blockade grows harder and richer with each defender past the third, up to six. \
	If brigands hold stolen Crown coin, breaking the blockade seizes the hoard. The Crown taxes it as Recovered Spoils."
	icon_state = "scroll_quest_info"
	base_icon_state = "scroll_quest"
	var/last_arrival_check = 0

/obj/item/quest_writ/blockade/process()
	. = ..()
	var/datum/quest/kill/blockade_defense/Q = assigned_quest
	if(!Q)
		return
	if(!Q.armed)
		return
	if(world.time < last_arrival_check + (5 SECONDS))
		return
	last_arrival_check = world.time
	var/mob/living/bearer = get_carrying_bearer()
	if(bearer)
		Q.check_arrival(bearer)
