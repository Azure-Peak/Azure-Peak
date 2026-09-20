#define COMMUNICATION_COOLDOWN 300
#define COMMUNICATION_COOLDOWN_AI 300

SUBSYSTEM_DEF(communications)
	name = "Communications"
	flags = SS_NO_INIT | SS_NO_FIRE

	var/silicon_message_cooldown
	var/nonsilicon_message_cooldown

/datum/controller/subsystem/communications/proc/can_announce(mob/living/user, is_silicon)
	if(is_silicon && silicon_message_cooldown > world.time)
		. = FALSE
	else if(!is_silicon && nonsilicon_message_cooldown > world.time)
		. = FALSE
	else
		. = TRUE

/datum/controller/subsystem/communications/proc/make_announcement(mob/living/user, is_silicon, input)
	if(is_silicon)
		if(user.job)
			var/used_title = user.get_role_title()
			if(SSticker.rulermob != user)
				if(SSticker.regentmob == user)
					if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
						used_title = "Ancient Lord Regent"
					else
						used_title = "[used_title]" + " Regent"
				else if(user.mind?.has_antag_datum(/datum/antagonist/lich))
					used_title = "Lich"
				else if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
					used_title = "Ancient Lord"
			priority_announce(html_decode(user.treat_message(input)), "The [used_title] Decrees", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), sender = user)
			silicon_message_cooldown = world.time + 5 SECONDS
	else
		if(user.job)
			var/used_title = user.get_role_title()
			if(SSticker.rulermob != user)
				if(SSticker.regentmob == user)
					if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
						used_title = "Ancient Lord Regent"
					else
						used_title = "[used_title]" + " Regent"
				else if(user.mind?.has_antag_datum(/datum/antagonist/lich))
					used_title = "Lich"
				else if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
					used_title = "Ancient Lord"
			priority_announce(html_decode(user.treat_message(input)), "The [used_title] Speaks", 'sound/misc/bell.ogg', sender = user)
			nonsilicon_message_cooldown = world.time + 5 SECONDS
		else
			priority_announce(html_decode(user.treat_message(input)), "Someone Speaks", 'sound/misc/bell.ogg', sender = user)
			nonsilicon_message_cooldown = world.time + 5 SECONDS

#undef COMMUNICATION_COOLDOWN
#undef COMMUNICATION_COOLDOWN_AI
