/*
*	WEAPON SKILLS
*
*	For whoever's working with this:
*	The factor for a secondary weapon skill (or altgrip skill for that matter)
*	dictates skill gates, weapon skill in parry/dodge/reductions, etc.
*
*	Every skill define in the game that you use has an associated integer,
*	just imagine that the skill factor you're assigning to a weapon is
*	multiplied to that number and then that value is used in those
*	skill calcs.
*
*	For skill gates (for example, Journeyman skill in a weapon to unlock specials),
*	that final value never rounds up. For example, Jman in a weapon with 0.8 skillfactor
*	is 2.4, which is not crossing the threshold for weapon special unlock.
*
*	Keep that in mind.
*/

/obj/item/proc/has_wskill()
	return associated_skill || length(secondary_skills)

/obj/item/proc/wskill_factor(skill)
	if(!skill || skill == associated_skill)
		return 1
	if(length(secondary_skills) && (skill in secondary_skills))
		return secondary_skills[skill]
	return 1

// picks the best of the skills for the mathematical calculation
/mob/proc/get_wskill(obj/item/I, fallback, use_grip = TRUE)
	if(!I?.has_wskill())
		return fallback ? get_skill_level(fallback) : SKILL_LEVEL_NONE
	if(use_grip && length(I.current_alt_grip?.grip_skill))
		return I.current_alt_grip.grip_wskill(I, src)
	var/winner = get_wskill_type(I, FALSE)
	return winner ? get_skill_level(winner) * I.wskill_factor(winner) : SKILL_LEVEL_NONE

/mob/proc/get_wskill_type(obj/item/I, use_grip = TRUE)
	if(use_grip && length(I?.current_alt_grip?.grip_skill))
		return I.current_alt_grip.grip_skilltype(I, src)
	if(!length(I?.secondary_skills))
		return I?.associated_skill
	var/datum/skill/best_type = I.associated_skill
	var/best = I.associated_skill ? get_skill_level(I.associated_skill) : SKILL_LEVEL_NONE
	for(var/skill in I.secondary_skills)
		var/scaled = get_skill_level(skill) * I.secondary_skills[skill]
		if(!best_type || scaled > best)
			best = scaled
			best_type = skill
	return best_type

/mob/proc/get_wskill_factor(obj/item/I)
	var/winner = get_wskill_type(I)
	if(!I || !winner)
		return 1
	var/datum/alt_grip/grip = I.current_alt_grip
	return grip ? grip.skill_factor(I, winner) : I.wskill_factor(winner)
