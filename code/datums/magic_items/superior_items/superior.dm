///T2 Enchantments
/datum/magic_item/superior/nightvision
	name = "night vision"
	description = "It has a sigil of Noc's eye."
	glow_color = "#B0C4DE"
	var/active_item = FALSE

/datum/magic_item/superior/nightvision/on_equip(var/obj/item/i, var/mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		ADD_TRAIT(user, TRAIT_DARKVISION, "[type]")
		active_item = TRUE
		to_chat(user, span_notice("I can see much better!"))


/datum/magic_item/superior/nightvision/on_drop(var/obj/item/i, var/mob/living/user)
	if(active_item)
		REMOVE_TRAIT(user, TRAIT_DARKVISION, "[type]")
		active_item = FALSE
		to_chat(user, span_notice("I feel mundane once more"))

/datum/magic_item/superior/featherstep
	name = "feather step"
	description = "It feels as light as a feather"
	glow_color = "#66CDAA"
	var/active_item = FALSE

/datum/magic_item/superior/featherstep/on_equip(var/obj/item/i, var/mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_LIGHT_STEP, "[type]")
		user.change_stat(STATKEY_SPD, 1, "featherstep_enchant")
		to_chat(user, span_notice("I feel much more nimble!"))


/datum/magic_item/superior/featherstep/on_drop(var/obj/item/i, var/mob/living/user)
	if(active_item)
		active_item = FALSE
		REMOVE_TRAIT(user, TRAIT_LIGHT_STEP, "[type]")
		user.change_stat(STATKEY_SPD, 0, "featherstep_enchant")
		to_chat(user, span_notice("I feel mundane once more"))

/datum/magic_item/superior/climbing
	name = "spider's movement"
	description = "It bristles with ends like fine hairs."
	glow_color = "#2E8B57"
	var/active_item = FALSE
	var/masterclimber = FALSE
	var/legendaryclimber = FALSE

/datum/magic_item/superior/climbing/on_equip(var/obj/item/i, var/mob/living/user, slot)
	. = ..()
	if(user.get_skill_level(/datum/skill/misc/climbing)== 6)
		to_chat(user, span_notice("I'm too skilled to use this"))
		return
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		if(user.get_skill_level(/datum/skill/misc/climbing)== 5)
			masterclimber = TRUE
			user.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		else
			user.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		to_chat(user, span_notice("I feel almost spiderlike!"))

/datum/magic_item/superior/climbing/on_drop(var/obj/item/i, var/mob/living/user)
	. = ..()
	if(active_item)
		active_item = FALSE
		if(masterclimber)
			user.adjust_skillrank(/datum/skill/misc/climbing, -1, TRUE)
		else
			user.adjust_skillrank(/datum/skill/misc/climbing, -2, TRUE)
		to_chat(user, span_notice("I feel mundane once more"))

/datum/magic_item/superior/thievery
	name = "fast fingers"
	description = "It looks like it fits just right"
	glow_color = "#483D8B"
	var/active_item = FALSE
	var/masterstealer = FALSE
	var/legendstealer = FALSE
	var/legendlockpick = FALSE

/datum/magic_item/superior/thievery/on_equip(var/obj/item/i, var/mob/living/user, slot)
	. = ..()
	if((user.get_skill_level(/datum/skill/misc/stealing)== 6) && (user.get_skill_level(/datum/skill/misc/lockpicking)== 6))
		to_chat(user, span_notice("I'm too skilled to use this"))
		return
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		if (user.get_skill_level(/datum/skill/misc/stealing) == 6)
			legendstealer = TRUE
			masterstealer = FALSE
		if (user.get_skill_level(/datum/skill/misc/stealing)== 5)
			user.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
			masterstealer = TRUE
		else
			user.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)

		if (user.get_skill_level(/datum/skill/misc/lockpicking)== 6)
			legendlockpick = TRUE
		else
			user.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)

		to_chat(user, span_notice("I feel more dexterious!"))

/datum/magic_item/superior/thievery/on_drop(var/obj/item/i, var/mob/living/user)
	. = ..()
	if(active_item)
		active_item = FALSE
		if (!legendstealer)
			if (masterstealer)
				user.adjust_skillrank(/datum/skill/misc/stealing, -1, TRUE)
			else
				user.adjust_skillrank(/datum/skill/misc/stealing, -2, TRUE)
		if(!legendlockpick)
			user.adjust_skillrank(/datum/skill/misc/lockpicking, -1, TRUE)
		to_chat(user, span_notice("I feel mundane once more"))

/datum/magic_item/superior/smithing
	name = "smithing"
	description = "It's warm with forge flame."
	glow_color = "#B87333"

/datum/magic_item/superior/smithing/on_apply(var/obj/item/i)
	.=..()
	var/obj/item/rogueweapon/hammer/hammer = i
	hammer.quality = hammer.quality *2

/datum/magic_item/superior/adaptive
	name = "adaptive"
	description = "Who are you, that you do not know your own enemy?"
	glow_color = "#6A5ACD"
	var/list/last_used = list()

/datum/magic_item/superior/adaptive/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < (src.last_used[source] + 2 MINUTES))
		return
	if(!isliving(user) || !isliving(target) || target == user)
		return

	var/mob/living/attacker = user
	var/mob/living/defender = target
	var/list/defender_stats = list(
		STATKEY_STR = defender.get_stat(STATKEY_STR),
		STATKEY_PER = defender.get_stat(STATKEY_PER),
		STATKEY_INT = defender.get_stat(STATKEY_INT),
		STATKEY_CON = defender.get_stat(STATKEY_CON),
		STATKEY_WIL = defender.get_stat(STATKEY_WIL),
		STATKEY_SPD = defender.get_stat(STATKEY_SPD),
		STATKEY_LCK = defender.get_stat(STATKEY_LCK),
	)
	var/highest_stat
	var/highest_value = -999999
	for(var/stat_key in defender_stats)
		if(defender_stats[stat_key] > highest_value)
			highest_value = defender_stats[stat_key]
			highest_stat = stat_key
	if(!highest_stat)
		return
	attacker.apply_status_effect(/datum/status_effect/buff/adaptive_enchant, highest_stat)
	to_chat(attacker, span_notice("[source] adapts to [defender], empowering my [highest_stat]!"))
	last_used[source] = world.time

/datum/magic_item/superior/hubris
	name = "hubris"
	description = "-and so the Worm said, 'kill everyone who is not us', and then did Cain become her first acolyte."
	glow_color = "#B22222"

/datum/magic_item/superior/hubris/on_apply(var/obj/item/i)
	. = ..()
	var/oldinteg
	i.force += 5
	i.wdefense -= 5
	if(i.wdefense <= 0)
		i.wdefense = 0

//DAMN, TEA CANT FUCKING CODE!!
	i.obj_integrity = i.max_integrity
	oldinteg = ((i.obj_integrity) / 2)
	i.max_integrity = oldinteg
	i.obj_integrity = i.max_integrity //OHHH MY GODDD
	if(!i.obj_integrity == oldinteg)
		i.obj_integrity = 100 //FUCK IT
