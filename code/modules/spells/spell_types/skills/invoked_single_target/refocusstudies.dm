//A skill to help others learn new skills by forgetting old ones
/obj/effect/proc_holder/spell/invoked/refocusstudies
	name = "Refocus Studies"
	desc = "Help another refocus their studies. Sacrifice a skill level in a skill above Journeyman to gain 3 sleep advancement points and a 30 minutes buff that will increase intelligence by +2 but reduce willpower by 1."
	overlay_state = "book3"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/refocusstudies/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/choices = list()
	var/mob/living/L = targets[1]
	var/list/datum/skill/skill_choices = list(
	//skills alphabetically... this will be sloppy based on the descriptive name but easier for devs
	/datum/skill/craft/crafting,
	/datum/skill/craft/weaponsmithing,
	/datum/skill/craft/armorsmithing,
	/datum/skill/craft/blacksmithing,
	/datum/skill/craft/smelting,
	/datum/skill/craft/carpentry,
	/datum/skill/craft/masonry,
	/datum/skill/craft/traps,
	/datum/skill/craft/cooking,
	/datum/skill/craft/engineering,
	/datum/skill/craft/tanning,
	/datum/skill/craft/alchemy,
	/datum/skill/craft/ceramics,
	/datum/skill/craft/sewing,

	/datum/skill/combat/knives,
	/datum/skill/combat/swords,
	/datum/skill/combat/polearms,
	/datum/skill/combat/maces,
	/datum/skill/combat/axes,
	/datum/skill/combat/whipsflails,
	/datum/skill/combat/bows,
	/datum/skill/combat/crossbows,
	/datum/skill/combat/wrestling,
	/datum/skill/combat/unarmed,
	/datum/skill/combat/shields,
	/datum/skill/combat/slings,

	/datum/skill/labor/farming,
	/datum/skill/labor/mining,
	/datum/skill/labor/fishing,
	/datum/skill/labor/butchering,
	/datum/skill/labor/lumberjacking,

	/datum/skill/magic/arcane,

	/datum/skill/misc/athletics,
	/datum/skill/misc/climbing,
	/datum/skill/misc/reading,
	/datum/skill/misc/swimming,
	/datum/skill/misc/stealing,
	/datum/skill/misc/sneaking,
	/datum/skill/misc/lockpicking,
	/datum/skill/misc/riding,
	/datum/skill/misc/music,
	/datum/skill/misc/medicine,
	/datum/skill/misc/tracking,
	)
	for(var/i = 1, i <= skill_choices.len, i++)
		var/datum/skill/learn_item = skill_choices[i]
		if((L.get_skill_level(learn_item) < SKILL_LEVEL_JOURNEYMAN))
			continue //skip if they're not high enough level to recycle a skill
		choices["[learn_item.name]"] = learn_item

	var/teachingtime = 30 SECONDS

	if(isliving(targets[1]))
		if(L == usr)
			to_chat(L, span_warning("I can not refocus my studies, only others."))
			return
		else
			if(L in range(1, usr))
				to_chat(usr, span_notice("My student needs some time to select a lesson."))
				var/chosen_skill = input(L, "Choose which skills to sacrifice, you will get back 3 sleep points and a buff to help you study", "Choose a skill") as null|anything in choices
				var/datum/skill/item = choices[chosen_skill]
				if(!item)
					return  // student canceled
				if(alert(L, "Are you sure> you want lose a level in [item.name]?", "Learning", "Sacrifice", "Cancel") == "Cancel")
					return
				if(L.has_status_effect(/datum/status_effect/buff/refocus))
					to_chat(L, span_warning("I've refocused too recently"))
					to_chat(usr, span_warning("My student cannot be refocused so soon"))
					return // cannot teach the same student twice
				if(L.get_skill_level(item) < SKILL_LEVEL_JOURNEYMAN)
					to_chat(L, span_warning("I don't have enough skill in [item.name] to sacrifice it."))
					to_chat(usr, span_warning("I try teaching [L] [item.name] but my student couldnt grasp the lesson!"))
					return // some basic skill will not require you novice level
				else
					to_chat(L, span_notice("[usr] starts teach me how to refocus my efforts, I slowly lose my grasp on [item.name]!"))
					to_chat(usr, span_notice("[L] gets to listen carefully to my lesson about refocusing, they slowly lose their grasp on [item.name]."))
					if(do_after(usr, teachingtime, target = L))
						user.visible_message("<font color='yellow'>[user] teaches [L] a lesson.</font>")
						to_chat(usr, span_notice("My student has refocused, but lost insight on [item.name]!"))
						L.adjust_skillrank(item, -1, FALSE)
						L.apply_status_effect(/datum/status_effect/buff/refocus)
						L.mind.sleep_adv.sleep_adv_points += 3
					else
						to_chat(usr, span_warning("[L] got distracted and wandered off!"))
						to_chat(L, span_warning("I must be more focused on my studies!"))
						return
			else
				to_chat(usr, span_warning("My student can barely hear me from there."))
				return
	else
		revert_cast()
		return FALSE
