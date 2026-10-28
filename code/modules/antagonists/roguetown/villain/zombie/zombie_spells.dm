/datum/action/cooldown/spell/zombie_seek
	name = "Seek the Lyving"
	desc = "Sniff the air and find the scent of the nearest living person to seek out."
	charge_required = FALSE
	cooldown_time = 15 SECONDS
	click_to_activate = FALSE
	self_cast_possible = TRUE
	invocations = null
	invocation_type = INVOCATION_NONE

	primary_resource_type = SPELL_COST_NONE
	primary_resource_cost = 0
	background_icon = 'icons/mob/actions/zombie_spells.dmi'
	button_icon = 'icons/mob/actions/zombie_spells.dmi'
	button_icon_state = "seekliving"

	spell_flags = SPELL_IGNORE_SPELLBLOCK //need to be able to use this as a zombie to begin with, else it wouldn't be a good zombie spell now.

/datum/action/cooldown/spell/zombie_seek/cast(mob/living/carbon/user)
	//we do this before the checks because if we have this as a non-zombie, something is VERY wrong.
	if(!user.mind.has_antag_datum(/datum/antagonist/zombie))
		to_chat(user, span_zizo_plain("I am not a zombie and should not have access to this spell, something went very wrong! Please report this to a coder w/ your roundID and how/when this happened."))
		return FALSE
	if(user.stat >= UNCONSCIOUS)
		return FALSE
	//set cooldown
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
	user.playsound_local(user, 'sound/misc/notice.ogg', 30, TRUE)
	return TRUE
