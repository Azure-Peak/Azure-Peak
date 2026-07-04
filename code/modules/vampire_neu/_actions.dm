/mob/living/carbon/human/proc/vampire_telepathy()
	var/TELEPATHY_COOLDOWN = 30 SECONDS

	set name = "Telepathy"
	set category = "RoleUnique.Vampire"

	if(!clan)
		return

	if(world.time < src.last_telepathy_use + TELEPATHY_COOLDOWN)
		var/remaining = round((src.last_telepathy_use + TELEPATHY_COOLDOWN - world.time) / 10, 1)
		to_chat(src, span_warning("You must wait [remaining] seconds before using Telepathy again!"))
		return

	var/msg = input(src, "Send a message", "COMMAND")
	if(!msg)
		return

	if(src.bloodpool > 80)
		src.adjust_bloodpool(-80)
	else
		to_chat(src, span_danger("I don't have enough blood to send a telepathy message!"))
		return

	// set cooldown
	src.last_telepathy_use = world.time


	log_game("VAMPIRE TELEPATHY: [(src).real_name] ([(src).ckey]) used vampiric telepathy to say: \"[msg]\"")
	var/message = span_narsie("<B>[span_purple("VAMPIRE")] - <span style='color:#[voice_color]'>[real_name]</span></B> says: \"[msg]\"")
	src.playsound_local(loc, 'sound/misc/vampirespell.ogg', 50, TRUE) //Que since it takes a bit you might go AFK briefly //Little ping when doing it.
	to_chat(clan?.clan_members, message)

/mob/living/carbon/human/proc/disguise_verb()
	set name = "Disguise"
	set category = "RoleUnique.Vampire"

	var/datum/component/vampire_disguise/disguise_comp = GetComponent(/datum/component/vampire_disguise)
	if(!disguise_comp)
		to_chat(src, span_warning("I cannot disguise myself."))
		return

	if(disguise_comp.disguised)
		disguise_comp.remove_disguise(src)
	else
		disguise_comp.apply_disguise(src)

/mob/living/carbon/human/proc/vampire_disguise(datum/antagonist/vampire/VD)
	if(clan)
		return
	var/datum/component/vampire_disguise/disguise_comp = GetComponent(/datum/component/vampire_disguise)
	disguise_comp.apply_disguise(src)

/mob/living/carbon/human/proc/vampire_undisguise(datum/antagonist/vampire/VD)
	if(clan)
		return
	var/datum/component/vampire_disguise/disguise_comp = GetComponent(/datum/component/vampire_disguise)
	disguise_comp.remove_disguise(src)
