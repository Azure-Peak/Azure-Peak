/obj/effect/proc_holder/spell/invoked/engineerwindup
	name = "Wind up"
	desc = "Use your drill to wind up Constructs, buffing or even reviving them"
	overlay_state = "drill"
	releasedrain = 1
	chargedrain = 0
	chargetime = 1
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/misc/DrillHit.ogg'
	action_icon = 'icons/mob/actions/engineer_skills.dmi'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	recharge_time = 1 MINUTES //very stupidly simple spell
	miracle = FALSE
	devotion_cost = 0 //come on, this is very basic

/obj/effect/proc_holder/spell/invoked/engineerwindup/cast(list/targets, mob/living/user)
	var/holdingdrill = FALSE


	//winding up only works on constructs
	if(ishuman(targets[1]) && (is_species(targets[1], /datum/species/construct)||is_species(targets[1], /datum/species/construct/metal)))
		var/mob/living/carbon/human/human_target = targets[1]
		if(human_target in range(1, user))
			if(user.get_skill_level(/datum/skill/craft/engineering) < 4)
				to_chat(user, span_warning("I don't have the engineering skill to operate this device!"))
				return

			//check if we're holding a drill
			for(var/obj/item/I in user.held_items)
				if(istype(I, /obj/item/contraption/pick/drill))
					holdingdrill = TRUE
			//if no drill is found then wipe the skill
			if (!holdingdrill)
				to_chat(user, span_warning("I'm not holding a drill, how can I wind something up?!"))
				user.mind.RemoveSpell(new /obj/effect/proc_holder/spell/invoked/engineerwindup)
				return

			//check if their chest is exposed to wind them up
			if(!get_location_accessible(human_target, BODY_ZONE_CHEST))
				to_chat(user, span_warning("I need to see their chest to wind up their core!"))
				return
			// Check if target is dead
			if(human_target.check_revive(user))
				// Prompt ghost
				to_chat(human_target, span_ghostalert("You sense someone spinning your core, attempting to pull you back to your body!"))
				var/alert_result = alert(human_target, "They are calling for you. Are you ready?", "Reanimation", "I need to wake up", "Don't let me go")

				// Verify occupant is still valid
				if(human_target.stat != DEAD)
					to_chat(user, span_warning("The subject is no longer dead!"))
					return

				if(alert_result != "I need to wake up")
					to_chat(user, span_warning("[human_target] refuses to return."))
					return

				// Animation and sound
				playsound(user, 'sound/misc/DrillDone.ogg', 100, TRUE)
				do_sparks(8, TRUE, human_target)
				human_target.visible_message(span_danger("The drill starts to spin [human_target] core!"))				

				if(do_after(usr, 10 SECONDS, target = human_target))
					for(var/obj/item/contraption/I in user.held_items)
						if(istype(I, /obj/item/contraption/pick/drill))
							if(I.current_charge < 300)
								to_chat(user, span_warning("There's not enough charge for this!")) //revive failed, not enough fuel
								return
							else
								I.current_charge -= 300

					// Revive process
					human_target.adjustOxyLoss(-human_target.getOxyLoss())
					if(human_target.revive(full_heal = FALSE))
						// Restore consciousness
						human_target.grab_ghost(force = TRUE)
						human_target.emote("gasp")
						human_target.Jitter(100)
						human_target.electrocute_act(25, src, 1)//slight damage
						human_target.visible_message(span_notice("[human_target] jerks awake with a buzz!"), 
													 span_userdanger("You awaken with a jolt as your core is spun!"))
						
						// Apply debuffs
						human_target.mind.remove_antag_datum(/datum/antagonist/zombie)
						human_target.apply_status_effect(/datum/status_effect/debuff/revived)
						return
				else
					to_chat(user, span_warning("[human_target] got moved before I was finished!"))
					to_chat(human_target, span_warning("I was moved before being wound up!"))
					return
			else //they aren't dead, so we'll buff them instead
				// Animation and sound
				playsound(user, 'sound/misc/DrillDone.ogg', 100, TRUE)
				do_sparks(8, TRUE, human_target)
				human_target.visible_message(span_danger("The drill starts to spin [human_target] core!"))			

				if(do_after(usr, 10 SECONDS, target = human_target))
					for(var/obj/item/contraption/I in user.held_items)
						if(istype(I, /obj/item/contraption/pick/drill))
							if(I.current_charge < 150)
								to_chat(user, span_warning("There's not enough charge for this!")) //revive failed, not enough fuel
								return
							else
								I.current_charge -= 150
					human_target.emote("gasp")
					human_target.Jitter(25)
					human_target.apply_status_effect(/datum/status_effect/buff/windup)
					human_target.visible_message(span_notice("[human_target] body jerks with a buzz!"), 
												 span_userdanger("Your body buzzes with a jolt as your core is spun!"))
					return
				else
					to_chat(user, span_warning("[human_target] got moved before I was finished!"))
					to_chat(human_target, span_warning("I was moved before being wound up!"))
					return



		else 
			to_chat(user, span_warning("I need to be next to [human_target] to wind them up"))
			return
	revert_cast()
	return FALSE
