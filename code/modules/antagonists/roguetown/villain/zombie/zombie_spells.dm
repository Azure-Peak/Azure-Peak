var/SEEK_BRAINS_COOLDOWN = 15 SECONDS

/obj/effect/proc_holder/spell/invoked/zombie_seek
	name = "Seek the Lyving"
	desc = "Sniff the air and find the scent of the nearest living person to seek and consume."
	recharge_time = 0.5 SECONDS
	chargetime = 0
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "sniff"
	invocation_type = "emote"
	action_icon_state = "sniff"
	invocation_emote_self = "<span class='notice'>I sniff the air.</span>"

	ignore_cockblock = TRUE
	breaks_invisibility = FALSE

/obj/effect/proc_holder/spell/invoked/zombie_seek/cast(list/humie, mob/user)

	//we do this before the checks because if we have this as a non-zombie, something is VERY wrong.
	if(!mind.has_antag_datum(/datum/antagonist/zombie))
		to_chat(user, span_zizo_plain("I am not a zombie and should not have access to this verb, report this bug to coders."))
		return FALSE
	if(world.time < user.last_seek_brains_use + SEEK_BRAINS_COOLDOWN)
		var/remaining = round((user.last_seek_brains_use + SEEK_BRAINS_COOLDOWN - world.time) / 10, 1)
		to_chat(user, span_warning("You must wait [remaining] seconds before using Seek again!"))
		return
	if(stat >= UNCONSCIOUS)
		return FALSE
	//set cooldown
	user.last_seek_brains_use = world.time
	var/closest_dist
	var/the_dir
	for(var/mob/living/carbon/human/humie as anything in GLOB.human_list)
		if(humie == user)
			continue
		if(humie.mob_biotypes & MOB_UNDEAD)
			continue
		if(humie.stat >= DEAD)
			continue
		if(HAS_TRAIT(humie, TRAIT_ZOMBIE_IMMUNE)) //no point hunting what you can't convert
			continue
		if(HAS_TRAIT(humie, TRAIT_NPC_EXAMINE)) //no point hunting NPCs, go harrass players
			continue
		var/total_distance = get_dist(user, humie)
		if(!closest_dist)
			closest_dist = total_distance
			the_dir = get_dir(user, humie)
		else
			if(total_distance < closest_dist)
				closest_dist = total_distance
				the_dir = get_dir(user, humie)
	if(!closest_dist)
		to_chat(user, span_warning("I failed to smell anything..."))
		return FALSE
	to_chat(user, span_cult("[pick("Flesh","Consume","Food","Lyving","Find it","Rasping thing")] [closest_dist] meters away, [dir2text(the_dir)]..."))
	user.playsound_local(loc, 'sound/misc/notice.ogg', 30, TRUE)
	return TRUE
