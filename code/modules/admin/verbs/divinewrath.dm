/client/proc/divine_wrath(mob/M in GLOB.mob_list)
	if(!holder || !check_rights(R_FUN))
		return

	var/mob/living/target = M

	var/list/curse_choices = list(
		"Curse of Astrata" = /datum/curse/astrata,
		"Curse of Noc" = /datum/curse/noc,
		"Curse of Dendor" = /datum/curse/dendor,
		"Curse of Abyssor" = /datum/curse/abyssor,
		"Curse of Ravox" = /datum/curse/ravox,
		"Curse of Necra" = /datum/curse/necra,
		"Curse of Xylix" = /datum/curse/xylix,
		"Curse of Pestra" = /datum/curse/pestra,
		"Curse of Malum" = /datum/curse/malum,
		"Curse of Eora" = /datum/curse/eora,
		"Curse of Zizo" = /datum/curse/zizo,
		"Curse of Graggar" = /datum/curse/graggar,
		"Curse of Matthios" = /datum/curse/matthios,
		"Curse of Baotha" = /datum/curse/baotha,
		)

	if(!isliving(target))
		to_chat(usr, "This can only be used on instances of type /mob/living")
		return

	var/target_name = input(usr, "Who shall receive divine punishment?", "Target Name") as text|null
	if (!target_name)
		return

	var/curse_pick = input(usr, "Choose a curse to apply or lift.", "Select Curse") as null|anything in curse_choices
	if (!curse_pick)
		return

	var/curse_type = curse_choices[curse_pick]

	for (var/mob/living/carbon/human/H in GLOB.player_list)
		if (H.real_name == target_name)
			var/datum/curse/temp = new curse_type()

			if (H.is_cursed(temp))
				H.remove_curse(temp)
				priority_announce("Gods have lifted [curse_pick] from [H.real_name]!", title = "DIVINE MERCY", sound = 'sound/misc/bell.ogg')
				message_admins("ADMIN DIVINE WRATH: ([ckey]) has lifted [curse_pick] from [H.real_name]) ") //[ADMIN_LOOKUPFLW(user)] Maybe add this here if desirable but dunno.
				log_game("ADMIN DIVINE WRATH: ([ckey]) has lifted [curse_pick] from [H.real_name])")
			else
				if (length(H.curses) >= 1)
					to_chat(src, span_syndradio("[H.real_name] is already afflicted by another curse."))
					message_admins("ADMIN DIVINE WRATH: ([ckey]) has attempted to strike [H.real_name] ([H.ckey] with [curse_pick])")
					log_game("ADMIN DIVINE WRATH: ([ckey]) has attempted to strike [H.real_name] ([H.ckey] with [curse_pick])")
					return

				H.add_curse(curse_type)
				priority_announce("Gods have stricken [H.real_name] with [curse_pick]!", title = "DIVINE PUNISHMENT", sound = 'sound/misc/excomm.ogg')
				message_admins("ADMIN DIVINE WRATH: ([ckey]) has stricken [H.real_name] ([H.ckey] with [curse_pick])")
				log_game("ADMIN DIVINE WRATH: ([ckey]) has stricken [H.real_name] ([H.ckey] with [curse_pick])")
