/obj/item/fishingcage
	name = "fishing cage"
	desc = "A sturdy cage used to catch shellfishes. Put a leech or worm inside and an unfortunate shellfish should be lured inside shortly."
	icon_state = "fishingcage"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 0
	slot_flags = ITEM_SLOT_BACK
	var/check_counter = 0
	var/deployed = 0
	var/caught
	var/obj/item/bait
	var/time2catch = FISHING_CAGE_CATCH_TIME_SLOWEST SECONDS

/obj/item/fishingcage/attack_self(mob/user)
	. = ..()

	var/turf/T = get_step(user, user.dir)
	if(!istype(T, /turf/open/water))
		to_chat(user, span_warning("This goes into water!"))
		return

	user.visible_message(span_notice("[user] begins deploying the fishing cage..."), \
						span_notice("I begin deploying the fishing cage..."))
	var/deploy_speed = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 1, slowest = 6)

	if(!T.get_fish_source())
		to_chat(user, span_warning("This body of water seems devoid of aquatic life..."))
		return
	if(locate(/obj/item/fishingcage) in T)
		to_chat(user, span_warning("There's already a fishing cage here."))
		return

	if(do_after(user, deploy_speed, target = src))
		user.transferItemToLoc(src, T)
		deployed = 1
		icon_state = "fishingcage_deployed"
		anchored = 1

/obj/item/fishingcage/attack_hand(mob/user)
	if(deployed)
		var/deploy_speed = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), 0.5, slowest = 6)
		if(caught)
			user.visible_message(span_notice("[user] begins to harvest from the cage..."), \
								span_notice("I begin harvesting from the cage..."))
			if(do_after(user, deploy_speed, target = src))
				add_sleep_experience(user, /datum/skill/labor/fishing, 20)
				record_featured_stat(FEATURED_STATS_FISHERS, user)
				record_round_statistic(STATS_FISH_CAUGHT)
				var/datum/fish_source/source = GLOB.preset_fish_sources[/datum/fish_source/cage]
				source.simple_dispense_reward(caught, user.loc, get_turf(src))
				caught = null
				if(!bait)
					desc = initial(desc)
					icon_state = "fishingcage_deployed"
				else
					playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
					icon_state = "fishingcage_ready"
					start_catching(user)
		else
			user.visible_message(span_notice("[user] begins disarming the fishing cage..."), \
								span_notice("I begin disarming the fishing cage..."))
			if(do_after(user, deploy_speed, target = src))
				STOP_PROCESSING(SSobj, src)
				deployed = 0
				QDEL_NULL(bait)
				desc = initial(desc)
				icon_state = initial(icon_state)
				anchored = 0
				..()
	else
		..()

/obj/item/fishingcage/attackby(obj/item/I, mob/user, params)
	if(bait)
		to_chat(user, span_warning("There's bait already on the cage."))
		return
	if(I.isbait)
		user.visible_message(span_notice("[user] starts adding the bait to the fishing cage..."), \
							span_notice("I start to add [I] to the fishing cage..."))
		if(do_after(user, 3 SECONDS, target = src))
			playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
			I.forceMove(src)
			bait = I
			icon_state = "fishingcage_ready"
			start_catching(user)
			return
	. = ..()

/obj/item/fishingcage/proc/start_catching(mob/user)
	check_counter = world.time
	time2catch = get_skill_delay(user.get_skill_level(/datum/skill/labor/fishing), FISHING_CAGE_CATCH_TIME_FASTEST, FISHING_CAGE_CATCH_TIME_SLOWEST)
	START_PROCESSING(SSobj, src)

/obj/item/fishingcage/process()
	if(deployed && bait)
		if(world.time > check_counter + time2catch)
			check_counter = world.time
			var/datum/fish_source/source = GLOB.preset_fish_sources[/datum/fish_source/cage]
			caught = pickweight(source.get_fish_table(get_turf(src)))
			icon_state = "fishingcage_caught"
			bait.baitresilience--
			if(bait.baitresilience <= 0)
				QDEL_NULL(bait)
			STOP_PROCESSING(SSobj, src)
	..()

/obj/item/fishingcage/examine(mob/user)
	. = ..()
	if(icon_state == "fishingcage_caught")
		. += span_warning("Something seems to be inside...")
