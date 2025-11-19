/obj/effect/proc_holder/spell/invoked/learn
	name = "Learn From Another"
	overlay_state = "knowledge"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/learn/cast(list/targets, mob/user = usr)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/teacher = targets[1]
		if(teacher == user)
			to_chat(user, span_warning("In teaching myself, I become both the question and the answer."))
			revert_cast()
			return
		if(HAS_TRAIT(user, TRAIT_STUDENT))
			to_chat(user, span_warning("I've learned all I can for the time being."))
			revert_cast()
			return
		if(teacher.cmode)//to hopefully stop you from trolling someone with a dialogue box during combat
			to_chat(user, span_warning("[teacher] is in combat!"))
			to_chat(teacher, span_warning("[user] wants to learn from you, but you're in combat."))//notify them since they might not ACTUALLY be in combat, just have cmode on
			revert_cast()
			return
		var/distance = get_dist(teacher, user)
		if(distance <= 2)
			to_chat(usr, span_notice("I ask [teacher] to teach me one of [teacher.p_their()] skills."))
			if(alert(teacher, "Teach [user] one of your skills?", "Teaching", "Yes", "No") == "Yes")
				to_chat(user, span_nicegreen("[teacher] has decided to teach you. Stay close and let them decide what they will reveal..."))

				var/list/known_skills = list()
				var/list/skill_names = list()//we use this in the user input window for the names of the skills
				if(teacher.mind)
					var/teacher_skill = 0
					var/user_skill = 0
					for(var/skill_type in SSskills.all_skills)
						var/datum/skill/skill = GetSkillRef(skill_type)
						if(skill in teacher.skills?.known_skills)
							teacher_skill = teacher.get_skill_level(skill_type)
							user_skill = user.get_skill_level(skill_type)
							if(teacher_skill > user_skill)//only add it to the list of teachable stuff if the spellcaster can gain skill in it
								LAZYADD(skill_names, skill)
								LAZYADD(known_skills,skill_type)

					if(!length(known_skills))
						to_chat(teacher, span_warning("[user] already knows everything I can teach."))
						to_chat(user, span_warning("[teacher] can't teach me anything."))
						revert_cast()
						return
					var/skill_choice = input(teacher, "Choose a skill to teach","Skills") as null|anything in skill_names
					if(skill_choice)
						for(var/real_skill in known_skills)//real_skill is the actual datum for the skill rather than the "Skill" string
							if(skill_choice == GetSkillRef(real_skill))//if skill_choice (the name string) is equal to real_skill's name ref, essentially
								distance = get_dist(teacher, user)
								if(distance > 2)
									to_chat(teacher, span_warning("I moved too far away from [user]."))
									to_chat(user, span_warning("[teacher] moved too far away from me."))
									revert_cast()
									return
								teacher.visible_message(("[teacher] begins teaching [user] about [skill_choice]."), ("I begin teaching [user] about [skill_choice]."))
								if(!do_mob(user, teacher, 100))
									to_chat(teacher, span_warning("I moved too far away from [user]."))
									to_chat(user, span_warning("[teacher] moved too far away from me."))
									revert_cast()
									return

								teacher_skill = teacher.get_skill_level(real_skill)
								user_skill = user.get_skill_level(real_skill)
								if(teacher_skill - user_skill > 2) //if the teacher has over two levels over the user, add 2 levels of skill to the user
									user.adjust_skillrank(real_skill, 2, FALSE)
									user.visible_message(span_notice("[teacher] teaches [user] about [skill_choice]."), span_notice("I grow much more proficient in [skill_choice]!"))
								else //if the teacher has 2 or 1 levels over the user, only add 1 level
									user.adjust_skillrank(real_skill, 1, FALSE)
									user.visible_message(span_notice("[teacher] teaches [user] about [skill_choice]."), span_notice("I grow more proficient in [skill_choice]!"))
								ADD_TRAIT(user, TRAIT_STUDENT, TRAIT_GENERIC)

			else
				to_chat(user, span_warning("[teacher] has decided to keep [teacher.p_their()] knowledge private."))
				revert_cast()
				return
	else
		revert_cast()
		return FALSE
