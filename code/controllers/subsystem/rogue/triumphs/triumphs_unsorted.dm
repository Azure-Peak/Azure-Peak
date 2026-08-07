




/mob/proc/show_triumphs_list()
	return SStriumphs.show_triumph_leaderboard(src.client)

/mob/proc/get_triumphs()
	if(!ckey)
		return
	return SStriumphs.get_triumphs(ckey)

/client/proc/adjusttriumph()
	set category = "Admin.Special"
	set name = "Adjust Own Triumphs"
	var/input = input(src, "how much") as num
	if(mob && input)
		var/old_triumphs = mob.get_triumphs()
		mob.adjust_triumphs(input, TRUE, "Adjust Own Triumphs (admin verb)")
		log_admin("[key_name(src)]: Modified own Triumphs by [input], from [old_triumphs] to [old_triumphs + input]")
		message_admins(span_adminnotice("[key_name_admin(src)]: Modified own Triumphs by [input], from [old_triumphs] to [old_triumphs + input]"))





