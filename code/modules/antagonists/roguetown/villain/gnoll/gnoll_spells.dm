/obj/effect/proc_holder/spell/self/claws/gnoll
	name = "Gnoll claws"
	claw_type = /obj/item/rogueweapon/werewolf_claw/gnoll

/obj/effect/proc_holder/spell/self/howl/gnoll
	howl_sounds = list('sound/vo/mobs/gnoll/yeen_howl.ogg')
	howl_sounds_far = list('sound/vo/mobs/hyena/gnoll_distant.ogg')
	wolf_antag_type = /datum/antagonist/gnoll
	howl_spies_allowed = FALSE
	howl_distance_limit = 20

/obj/effect/proc_holder/spell/invoked/gnoll_sniff
	name = "Track"
	desc = "Graggar has some worthy folks for you, hunt them down! Cast on self to set target, cast to track target, cast on a person to remember their scent temporarily"
	recharge_time = 0.5 SECONDS
	chargetime = 0.1 SECONDS
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "sniff"
	invocation_type = "emote"
	action_icon_state = "sniff"
	invocation_emote_self = "<span class='notice'>I sniff the air.</span>"
	var/mob/living/tracked_target = null

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/cast(list/targets, mob/user)
	var/mob/living/target = targets[1]

	if(!tracked_target || QDELETED(tracked_target) || tracked_target.stat == DEAD || target == user)
		select_new_target(user)
	else
		give_tracking_directions(user)

	if(is_valid_hunted(target) && target != user)
		tracked_target = target
		to_chat(user, span_notice("You catch the scent of [target.real_name]. The hunt begins!"))
		user.playsound_local(get_turf(user), 'sound/vo/mobs/wwolf/sniff.ogg', 50, TRUE)
	else if (!tracked_target)
		to_chat(user, span_warning("[target] isn't something you can hunt."))
		revert_cast()
		return FALSE
	
	return TRUE

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/select_new_target(mob/user)
	var/list/possible_targets = list()
	var/list/display_names = list()

	for(var/mob/living/L in GLOB.mob_living_list)
		if(L == user || istype(L, /mob/living/carbon/human/dummy))
			continue
		if(L.has_flaw(/datum/charflaw/hunted))
			var/entry_name = "[L.real_name][L.job ? " - [L.job]" : ""]"
			possible_targets[entry_name] = L
			display_names += entry_name

	if(!length(display_names))
		to_chat(user, span_warning("The air is stale. No hunted souls are in the region."))
		return

	var/selection = input(user, "Whose scent shall we follow?", "The Great Hunt") as null|anything in sort_list(display_names)
	if(!selection)
		return

	tracked_target = possible_targets[selection]
	to_chat(user, span_notice("You focus your senses on [tracked_target.real_name]."))
	give_tracking_directions(user)

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/give_tracking_directions(mob/user)
	if(!tracked_target || QDELETED(tracked_target) || tracked_target.stat == DEAD)
		to_chat(user, span_warning("The scent has gone cold... your target is no more."))
		tracked_target = null
		return

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(tracked_target)

	if(user_turf.z != target_turf.z)
		to_chat(user, span_notice("The scent of [tracked_target.real_name] drifts from [user_turf.z > target_turf.z ? "below" : "above"] you."))
	else
		var/dist = get_dist(user, tracked_target)
		var/dir_text = dir2text(get_dir(user, tracked_target))
		
		if(dist <= 1)
			to_chat(user, span_boldnotice("The prey is right here! Blood and steel!"))
		else if(dist < 10)
			to_chat(user, span_notice("The scent is thick to the [dir_text]. They are very close."))
		else
			to_chat(user, span_notice("You catch a faint whiff of [tracked_target.real_name] to the [dir_text]."))

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/is_valid_hunted(atom/A)
	if(!isliving(A))
		return FALSE
	var/mob/living/L = A
	if(!L || QDELETED(L) || L.stat == DEAD)
		return FALSE
	return TRUE
