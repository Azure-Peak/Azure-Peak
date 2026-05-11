/obj/effect/proc_holder/spell/invoked/engineertuneup
	name = "Tune Up"
	desc = "Ratchet your Wrench to help improve constructs, repair contraptions, and bars at the cost of cog charges"
	overlay_state = "brasswrench"
	releasedrain = 1
	chargedrain = 0
	chargetime = 1
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/misc/ratchet.ogg'
	action_icon = 'icons/mob/actions/engineer_skills.dmi'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS //very stupidly simple spell
	miracle = FALSE
	devotion_cost = 0 //come on, this is very basic

/obj/effect/proc_holder/spell/invoked/engineertuneup/cast(list/targets, mob/living/user)
	var/holdingwrench = FALSE
	//a list of valide items the wrench can repair
	var/repairablelist = list(/obj/structure/bars,
							  /obj/structure/bars/cemetery,
							  /obj/structure/bars/chainlink,
							  /obj/structure/bars/grille,
							  /obj/structure/bars/passage,
							  /obj/structure/bars/passage/shutter,
							  /obj/structure/bars/passage/steel,
							  /obj/structure/bars/pipe,
							  /obj/structure/bars/pipe/left,
							  /obj/structure/bars/shop,
							  /obj/structure/bars/shop/bronze,
							  /obj/structure/bars/steel,
							  /obj/structure/bars/tough,
							  /obj/structure/chair/freedomchair/crafted,
							  /obj/structure/englauncher,
							  /obj/structure/fermentation_keg/distiller,
							  /obj/structure/floordoor,
							  /obj/structure/fluff/clock,
							  /obj/structure/fluff/wallclock,
							  /obj/structure/fluff/wallclock/l,
							  /obj/structure/fluff/wallclock/r,
							  /obj/structure/fluff/wallclock/vampire,
							  /obj/structure/fluff/wallclock/vampire/l,
							  /obj/structure/fluff/wallclock/vampire/r,
							  /obj/structure/gate,
							  /obj/structure/gate/bars,
							  /obj/structure/lever,
							  /obj/structure/lever/wall,
							  /obj/structure/mineral_door/bars,
							  /obj/structure/mineral_door/barsold,
							  /obj/structure/pressure_plate,
							  /obj/structure/roguemachine/potionseller/crafted,
							  /obj/structure/table/cooling,
							  /obj/structure/winch)
	var/barlist = list(/obj/structure/bars,
					   /obj/structure/bars/cemetery,
					   /obj/structure/bars/chainlink,
					   /obj/structure/bars/grille,
					   /obj/structure/bars/passage,
					   /obj/structure/bars/passage/shutter,
					   /obj/structure/bars/passage/steel,
					   /obj/structure/bars/pipe,
					   /obj/structure/bars/pipe/left,
					   /obj/structure/bars/shop,
					   /obj/structure/bars/shop/bronze,
					   /obj/structure/bars/steel,
					   /obj/structure/bars/tough)
	var/doorlist = list(/obj/structure/mineral_door/bars,
						/obj/structure/mineral_door/barsold)
	var/gatelist = list(/obj/structure/gate,
						/obj/structure/gate/bars)


	//winding up only works on constructs
	if(ishuman(targets[1]) && (is_species(targets[1], /datum/species/construct)||is_species(targets[1], /datum/species/construct/metal)))
		var/mob/living/carbon/human/human_target = targets[1]
		if(human_target in range(1, user))
			if(user.get_skill_level(/datum/skill/craft/engineering) < 4)
				to_chat(user, span_warning("I don't have the engineering skill to operate this device!"))
				return

			//check if we're holding a wrench
			for(var/obj/item/I in user.held_items)
				if((istype(I, /obj/item/contraption/linker))||(istype(I, /obj/item/contraption/linker/master)))
					holdingwrench = TRUE
			//if no wrench is found then wipe the skill
			if (!holdingwrench)
				to_chat(user, span_warning("I'm not holding a wrench, how can I tune something up?!"))
				user.mind.RemoveSpell(new /obj/effect/proc_holder/spell/invoked/engineertuneup)
				return

			//check if their chest is exposed to wind them up
			if(!get_location_accessible(human_target, BODY_ZONE_CHEST))
				to_chat(user, span_warning("I need to see their chest to tune up their core!"))
				return

			// Check if target is dead
			if(human_target.stat != DEAD)
				// Animation and sound
				playsound(user, 'sound/misc/ratchet.ogg', 100, TRUE)
				do_sparks(8, TRUE, human_target)
				human_target.visible_message(span_danger("[user] starts to tune up [human_target]'s core!"))		
				if(do_after(usr, 10 SECONDS, target = human_target))
					for(var/obj/item/contraption/I in user.held_items)
						if((istype(I, /obj/item/contraption/linker))||(istype(I, /obj/item/contraption/linker/master)))
							if(I.current_charge < 10)
								to_chat(user, span_warning("There's not enough charge for this!")) //revive failed, not enough fuel
								return
							else
								I.current_charge -= 10
								human_target.Jitter(25)
								human_target.visible_message(span_notice("[human_target] shakes and sparks with a buzz!"), 
																		span_userdanger("You shake and spark as you're tuned up!"))
									
								// Apply buffs
								human_target.apply_status_effect(/datum/status_effect/buff/tuneup)
								return
						else	
							to_chat(user, span_warning("I need to hold onto the wrench!"))
				else
					to_chat(user, span_warning("[human_target] got moved before I was finished!"))
					to_chat(human_target, span_warning("I was moved before being tuned up!"))
					return
		else 
			to_chat(user, span_warning("I need to be next to [human_target] to wind them up"))
			return
	//this should repair certain stuctures
	if(isstructure(targets[1]))
		if(is_type_in_list(targets[1], repairablelist))
			var/obj/structure/structurerepair = targets[1]

			if(user.get_skill_level(/datum/skill/craft/engineering) < 4)
				to_chat(user, span_warning("I don't have the engineering skill to operate this device!"))
				return

			//check if we're holding a wrench
			for(var/obj/item/I in user.held_items)
				if((istype(I, /obj/item/contraption/linker))||(istype(I, /obj/item/contraption/linker/master)))
					holdingwrench = TRUE

			//if no wrench is found then wipe the skill
			if (!holdingwrench)
				to_chat(user, span_warning("I'm not holding a wrench, how can I tune something up?!"))
				user.mind.RemoveSpell(new /obj/effect/proc_holder/spell/invoked/engineertuneup)
				return

			
			// Animation and sound
			playsound(user, 'sound/misc/ratchet.ogg', 100, TRUE)
			do_sparks(8, TRUE, structurerepair)
			user.visible_message(span_danger("[user] starts to repair [structurerepair]"))		
			if(do_after(usr, 10 SECONDS, target = structurerepair))
				if(structurerepair.obj_integrity < structurerepair.max_integrity)
					if(do_after(user, (150 / user.get_skill_level(/datum/skill/craft/engineering)), target = structurerepair)) // making this generic carpentry, even though it could be masonry
						for(var/obj/item/contraption/I in user.held_items)
							if((istype(I, /obj/item/contraption/linker))||(istype(I, /obj/item/contraption/linker/master)))
								if(I.current_charge < 20)
									to_chat(user, span_warning("There's not enough charge for this!")) //revive failed, not enough fuel
									return
								else
									I.current_charge -= 20
									playsound(user, 'sound/misc/ratchet.ogg', 100, TRUE)
									structurerepair.density = TRUE
									structurerepair.opacity = TRUE
									structurerepair.obj_broken = FALSE
									structurerepair.obj_integrity = structurerepair.max_integrity							
									user.visible_message(span_notice("[user] repaired [structurerepair.name]."), \
															span_notice("I repaired [structurerepair.name]."))
									if(is_type_in_list(structurerepair, barlist))
										var/obj/structure/bars/barsrepairable = structurerepair
										barsrepairable.icon_state = "[initial(barsrepairable.icon_state)]"
										barsrepairable.opacity = FALSE
									if(is_type_in_list(structurerepair, gatelist))
										var/obj/structure/gate/gaterepairable = structurerepair
										gaterepairable.icon_state = "[gaterepairable.base_state]"
										gaterepairable.opacity = FALSE
									if(is_type_in_list(structurerepair, doorlist))
										var/obj/structure/mineral_door/doorsrepairable = structurerepair
										doorsrepairable.icon_state = "[doorsrepairable.base_state]"
										doorsrepairable.brokenstate = TRUE
										doorsrepairable.repair_state = 0
									return	
				else
					user.visible_message(span_notice("It's already fully repaired."))
					return
			else 
				to_chat(user, span_warning("I need to be next to [structurerepair] to repair them"))
				return
	if(isitem(targets[1]))
		var/obj/item/contraptionrepair = targets[1]
		if(ispath(contraptionrepair.type, /obj/item/contraption))

			if(user.get_skill_level(/datum/skill/craft/engineering) < 3)
				to_chat(user, span_warning("I don't have the engineering skill to operate this device!"))
				return

			//check if we're holding a wrench
			for(var/obj/item/I in user.held_items)
				if((istype(I, /obj/item/contraption/linker))||(istype(I, /obj/item/contraption/linker/master)))
					holdingwrench = TRUE

			//if no wrench is found then wipe the skill
			if (!holdingwrench)
				to_chat(user, span_warning("I'm not holding a wrench, how can I tune something up?!"))
				user.mind.RemoveSpell(new /obj/effect/proc_holder/spell/invoked/engineertuneup)
				return

			
			// Animation and sound
			playsound(user, 'sound/misc/ratchet.ogg', 100, TRUE)
			do_sparks(8, TRUE, contraptionrepair)
			user.visible_message(span_danger("[user] starts to repair [contraptionrepair]"))		
			if(do_after(usr, 3 SECONDS, target = contraptionrepair))
				if(contraptionrepair.obj_integrity < contraptionrepair.max_integrity)
					if(do_after(user, (150 / user.get_skill_level(/datum/skill/craft/engineering)), target = contraptionrepair)) // making this generic carpentry, even though it could be masonry
						for(var/obj/item/contraption/I in user.held_items)
							if((istype(I, /obj/item/contraption/linker))||(istype(I, /obj/item/contraption/linker/master)))
								if(I.current_charge < 2)
									to_chat(user, span_warning("There's not enough charge for this!")) //revive failed, not enough fuel
									return
								else
									I.current_charge -= 2
									playsound(user, 'sound/misc/ratchet.ogg', 100, TRUE)
									contraptionrepair.obj_integrity = contraptionrepair.max_integrity							
									user.visible_message(span_notice("[user] repaired [contraptionrepair.name]."), \
															span_notice("I repaired [contraptionrepair.name]."))
									return	
				else
					user.visible_message(span_notice("It's already fully repaired."))
					return
			else 
				to_chat(user, span_warning("I need to be next to [contraptionrepair] to repair them"))
				return

	revert_cast()
	return FALSE
