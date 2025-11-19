/obj/effect/proc_holder/spell/self/howl
	name = "Howl"
	desc = "!"
	overlay_state = "howl"
	antimagic_allowed = TRUE
	recharge_time = 600 //1 minute
	ignore_cockblock = TRUE
	var/use_language = FALSE

/obj/effect/proc_holder/spell/self/howl/cast(mob/user = usr)
	..()
	var/message = input("Howl at the hidden moon...", "MOONCURSED") as text|null
	if(!message) return

	var/datum/antagonist/werewolf/werewolf_player = user.mind.has_antag_datum(/datum/antagonist/werewolf)

	// sound played for owner
	playsound(src, pick('sound/vo/mobs/wwolf/howl (1).ogg','sound/vo/mobs/wwolf/howl (2).ogg'), 75, TRUE)

	for(var/mob/player in GLOB.player_list)

		if(!player.mind) continue
		if(player.stat == DEAD) continue
		if(isbrain(player)) continue

		// Announcement to other werewolves (and anyone else who has beast language somehow)
		if(player.mind.has_antag_datum(/datum/antagonist/werewolf) || (player.has_language(/datum/language/beast)))
			to_chat(player, span_boldannounce("[werewolf_player ? werewolf_player.wolfname : user.real_name] howls to the hidden moon: [message]"))

		//sound played for other players
		if(player == src) continue
		if(get_dist(player, src) > 7)
			player.playsound_local(get_turf(player), pick('sound/vo/mobs/wwolf/howldist (1).ogg','sound/vo/mobs/wwolf/howldist (2).ogg'), 50, FALSE, pressure_affected = FALSE)

	var/log_type = werewolf_player ? "(WEREWOLF))" : "(BEAST LANGUAGE)"

	user.log_message("howls: [message] ([log_type])", LOG_GAME)

/obj/effect/proc_holder/spell/self/claws
	name = "Lupine Claws"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 20 //2 seconds
	ignore_cockblock = TRUE
	var/list/extended_claw_record = list(FALSE, FALSE)
	var/static/claw_type = /obj/item/rogueweapon/werewolf_claw

/obj/effect/proc_holder/spell/self/claws/cast(list/targets, mob/user)
	. = ..()
	var/list/current_hands = list(FALSE, FALSE)
	current_hands[LEFT_HANDS] = user.get_item_for_held_index(LEFT_HANDS)
	current_hands[RIGHT_HANDS] = user.get_item_for_held_index(RIGHT_HANDS)
	var/extending_claws = FALSE
	// note the potential (and intentional) double negative for having a hand for that index; if you're missing
	// that arm, we need to return a truthy value to flip into a falsy value, so you don't try to extend claws
	// if you're missing one arm and trying to free up the other hand from your current claws
	if(!(current_hands[LEFT_HANDS] || !user.has_hand_for_held_index(LEFT_HANDS)) || !(current_hands[RIGHT_HANDS] || !user.has_hand_for_held_index(RIGHT_HANDS)))
		extending_claws = TRUE
	//LEFT_HANDS = 1, RIGHT_HANDS = 2, see code/__DEFINES/inventory.dm
	for(var/hand_index = 1, hand_index < 3, hand_index++)
		var/current_item = current_hands[hand_index]
		if(extending_claws)
			// don't try to force a claw into a hand holding something, like a succulent limb inconveniently
			// attached to a victim
			if(current_hands[hand_index])
				continue
			// don't try to force a claw into a hand that was detached from you, non-succulently
			if(!user.has_hand_for_held_index(hand_index))
				continue
			var/new_claw
			if(hand_index == LEFT_HANDS)
				new_claw = new /obj/item/rogueweapon/werewolf_claw/left(user)
				user.put_in_l_hand(new_claw)
				extended_claw_record[LEFT_HANDS] = new_claw
			else
				new_claw = new /obj/item/rogueweapon/werewolf_claw/right(user)
				user.put_in_r_hand(new_claw)
				extended_claw_record[RIGHT_HANDS] = new_claw
			RegisterSignal(new_claw, COMSIG_QDELETING, PROC_REF(clear_claw_entry))
			continue
		var/claw_entry = extended_claw_record[hand_index]
		if(claw_entry && current_item != claw_entry)
			var/msg = "[user] held item wasn't extended_claw_entry as expected; Expected: [claw_entry], Got: [current_item]"
			log_admin(msg)
			log_runtime(msg)
		if(istype(current_item, claw_type))
			if(!claw_entry)
				var/msg = "[user] had a werewolf claw that wasn't being tracked by the claw entries: [current_item]"
				log_admin(msg)
				log_runtime(msg)
			user.temporarilyRemoveItemFromInventory(I = current_item, force = TRUE)
			qdel(current_item)
		extended_claw_record[hand_index] = FALSE		
	return TRUE

/obj/effect/proc_holder/spell/self/claws/proc/clear_claw_entry(datum/source)
	SIGNAL_HANDLER
	var/claw_index = extended_claw_record.Find(source)
	if(claw_index)
		extended_claw_record[claw_index] = FALSE


/obj/effect/proc_holder/spell/invoked/repulse/werewolf
	name = "Terrifying Howl"
	desc = "Let loose a howl of dread, repelling anyone around you."
	overlay_state = "howl"
	recharge_time = 6 MINUTES
	ignore_cockblock = TRUE
	chargetime = 0
	warnie = null
	showsparkles = FALSE
	chargedloop = null
	invocations = null 
	invocation_type = "none"
	sound = list('sound/vo/mobs/wwolf/roar.ogg')
