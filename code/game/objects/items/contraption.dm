//This is being left out, as it might be dangerous without a way to keep players from relinking the keep doors.

/obj/item/contraption
	name = "random piece of machinery"
	desc = "A cog with teeth meticulously crafted for tight interlocking."
	icon_state = "gear"
	w_class = WEIGHT_CLASS_SMALL
	var/on_icon
	var/off_icon
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = /obj/item/ingot/bronze
	slot_flags = ITEM_SLOT_HIP
	var/obj/item/accepted_power_source = /obj/item/roguegear
	/// This is the amount of charges we get per power source
	var/charge_per_source = 5
	var/current_charge = 0
	var/misfire_chance
	var/sneaky_misfire_chance
	/// Are we misfiring? Important for chain reactions.
	var/misfiring = FALSE
	obj_flags_ignore = TRUE
	/// If this contraption should accept cogs that alter its behaviour
	var/special_cog = FALSE

/obj/item/contraption/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
"sx" = -6,
"sy" = -2,
"nx" = 9,
"ny" = -1,
"wx" = -6,
"wy" = -1,
"ex" = -2,
"ey" = -3,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 21,
"sturn" = -18,
"wturn" = -18,
"eturn" = 21,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/contraption/examine(mob/user)
	. = ..()
	if(!istype(user, /mob/living))
		return
	/*var/mob/living/player = user
	var/skill = player.mind?.get_skill_level(/datum/skill/craft/engineering)
	if(current_charge)
		. += span_warning("The contraption has [current_charge] charges left.")
	if(!current_charge)
		. += span_warning("This contraption requires a new [initial(accepted_power_source.name)] to function.")
	if(misfire_chance)
		if(skill > 2)
			. += span_warning("You calculate this contraptions chance of failure to be anywhere between [max(0, (misfire_chance - skill) - rand(4))]% and [max(2, (misfire_chance - skill) + rand(3))]%.")
		else
			. += span_warning("It seems slightly unstable...")
	if(skill >= 6 && sneaky_misfire_chance)
		. += span_warning("This contraption has a chance for catastrophic failure in the hands of the inexperient.")*/

/obj/item/contraption/proc/battery_collapse(atom/A, mob/living/user)
	to_chat(user, span_info("The [accepted_power_source.name] wastes away into nothing."))
	playsound(src, pick('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, FALSE)
	shake_camera(user, 1, 1)
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_turf(src)
	S.set_up(1, 1, front)
	S.start()
	return

/obj/item/contraption/proc/misfire(atom/A, mob/living/user)
	user.mind.add_sleep_experience(/datum/skill/craft/engineering, (user.STAINT * 5))
	to_chat(user, span_info("Oh fuck."))
	playsound(src, 'sound/misc/bell.ogg', 100)
	addtimer(CALLBACK(src, PROC_REF(misfire_result), A, user), rand(5, 30))

/obj/item/contraption/proc/misfire_result(atom/A, mob/living/user)
	misfiring = TRUE
	explosion(src, light_impact_range = 3, flame_range = 1, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	qdel(src)

/obj/item/contraption/proc/charge_deduction(atom/A, mob/living/user, deduction)
	current_charge -= deduction
	if(!current_charge)
		addtimer(CALLBACK(src, PROC_REF(battery_collapse), A, user), 5)

/obj/item/contraption/attackby(obj/item/I, mob/user, params)
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_turf(src)
	/*if(istype(I, /obj/item/roguegear)) && special_cog)
		var/obj/item/roguegear/cog = I
		//if(cog.name_prefix)
		//	name = "[cog.name_prefix] [initial(name)]"
		//else
		if(istype(I, /obj/item/roguegear))
			name = initial(name)
		qdel(cog)
		playsound(src, pick('sound/combat/hits/onwood/fence_hit1.ogg', 'sound/combat/hits/onwood/fence_hit2.ogg', 'sound/combat/hits/onwood/fence_hit3.ogg'), 100, FALSE)
		shake_camera(user, 1, 1)
		S.set_up(1, 1, front)
		S.start()
		to_chat(user, "<span class='warning'>I use [cog] to modify [src]!</span>")
		return */
	if(istype(I, accepted_power_source))
		user.changeNext_move(CLICK_CD_FAST)
		S.set_up(1, 1, front)
		S.start()
		if(current_charge)
			to_chat(user, span_info("I try to insert the [I.name] but theres already \a [initial(accepted_power_source.name)] inside!"))
			playsound(src, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
			shake_camera(user, 1, 1)
		else
			to_chat(user, span_info("I insert the [I.name] and the [name] starts ticking."))
			current_charge = charge_per_source
			playsound(src, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
			qdel(I)
			addtimer(CALLBACK(src, PROC_REF(play_clock_sound)), 5)
	if(istype(I, /obj/item/rogueweapon/hammer))
		hammer_action(I, user)
	..()

/obj/item/contraption/proc/hammer_action(obj/item/I, mob/user)
	user.changeNext_move(CLICK_CD_FAST)
	flick(off_icon, src)
	user.visible_message(span_info("[user] beats the [name] into submission!"))
	playsound(src, pick('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/sheet (2).ogg', 'sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, TRUE)
	shake_camera(user, 1, 1)
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_turf(I)
	S.set_up(1, 1, front)
	S.start()
	var/probability = rand(1, 100)
	if(!current_charge)
		misfire(I, user)
		return
	if(probability <= 5)
		misfire(I, user)
	else if(probability <= 40)
		if(current_charge < charge_per_source)
			current_charge += 1
		misfire_chance = rand(1, 30)
	else
		misfire_chance = rand(10, 100)

/obj/item/contraption/proc/play_clock_sound()
	playsound(src, 'sound/misc/clockloop.ogg', 25, TRUE)

/obj/item/contraption/attack_obj(obj/O, mob/living/user)
	if(!current_charge)
		flick(off_icon, src)
		to_chat(user, span_info("The contraption beeps! It requires \a [initial(accepted_power_source.name)]!"))
		playsound(src, 'sound/magic/magic_nulled.ogg', 100, TRUE)
		return


//Shamelessly stolen multitool code
/obj/item/contraption/linker
	name = "engineering wrench"
	desc = "This strange contraption is able to connect machinery through an unknown calibration method, allowing them to communicate over long distances."
	icon = 'icons/obj/wrenches.dmi'
	icon_state = "brasswrench"
	w_class = WEIGHT_CLASS_SMALL
	tool_behaviour = TOOL_MULTITOOL
	var/datum/buffer // simple machine buffer for device linkage
	smeltresult = /obj/item/ingot/bronze
	charge_per_source = 20
	grid_width = 64
	grid_height = 32

/obj/item/contraption/linker/master
	name = "Guild Master's Wrench"
	desc = "Able to do more advanced linking than a standard wrench. Keep it out of apprentice's hands"
	charge_per_source = 200

/obj/item/contraption/linker/hammer_action(obj/item/I, mob/user)
	return

/obj/item/contraption/linker/Destroy()
	if(buffer)
		remove_buffer(buffer)
	return ..()

/obj/item/contraption/linker/examine(mob/user)
	. = ..()
	if(user.get_skill_level(/datum/skill/craft/engineering) >= 3)
		. += span_notice("Its buffer [buffer ? "contains [buffer]." : "is empty."]")
	else
		. += span_notice("All you can make out is a bunch of gibberish.")

/obj/item/contraption/linker/attack_self(mob/user)
	. = ..()
	if(user.get_skill_level(/datum/skill/craft/engineering) >= 3)
		to_chat(user, "You wipe [src] of its stored buffer.")
		remove_buffer(src)
	else
		to_chat(user, span_warning("I have no idea how to use [src]!"))

/obj/item/contraption/linker/proc/set_buffer(datum/buffer)
	if(src.buffer)
		remove_buffer(src.buffer)
	src.buffer = buffer
	if(!QDELETED(buffer))
		RegisterSignal(buffer, COMSIG_PARENT_QDELETING, PROC_REF(remove_buffer))

/**
 * Called when the buffer's stored object is deleted
 *
 * This proc does not clear the buffer of the multitool, it is here to
 * handle the deletion of the object the buffer references
 */
/obj/item/contraption/linker/proc/remove_buffer(datum/source)
	SIGNAL_HANDLER
	SEND_SIGNAL(src, COMSIG_MULTITOOL_REMOVE_BUFFER, source)
	UnregisterSignal(buffer, COMSIG_PARENT_QDELETING)
	buffer = null

/obj/item/contraption/wood_metalizer
	name = "wood metalizer"
	desc = "A creation of genious or insanity. This cursed contraption is somehow able to turn wood into metal."
	icon_state = "metalizer"
	on_icon = "metalizer_flick"
	off_icon = "metalizer_off"
	w_class = WEIGHT_CLASS_NORMAL
	misfire_chance = 15
	charge_per_source = 5
	grid_height = 64
	grid_width = 64

/obj/item/contraption/wood_metalizer/attack_obj(obj/O, mob/living/user)
	..()
	if(!current_charge)
		return
	var/skill = user.get_skill_level(/datum/skill/craft/engineering)
	if(istype(O, /obj/item/grown/log/tree/small)&& skill>3)
		var/newdir = O.dir
		var/obj/I = O
		var/obj/item/randomingot = pick (/obj/item/ingot/bronze,/obj/item/ingot/iron,/obj/item/ingot/copper, /obj/item/ingot/tin, /obj/item/rogueore/coal)
		var/obj/result = new randomingot(get_turf(I))
		result.dir = newdir
		qdel(I)
	else 
		to_chat(user, span_info("The [name] refuses to function."))
		playsound(user, 'sound/items/flint.ogg', 100, FALSE)
		flick(off_icon, src)
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_turf(O)
		S.set_up(1, 1, front)
		S.start()
		return
	flick(on_icon, src)
	charge_deduction(O, user, 1)
	shake_camera(user, 1, 1)
	playsound(src, 'sound/magic/swap.ogg', 100, TRUE)
	return

/obj/item/contraption/folding_table_stored
	name = "folding table"
	desc = "A folding table, useful for setting up a temporary workspace."
	icon = 'icons/roguetown/misc/gadgets.dmi'
	icon_state = "foldingTableStored"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF
	grid_height = 32
	grid_width = 64

/obj/item/contraption/folding_table_stored/attack_self(mob/user)
	. = ..()
	//deploy the table if the user clicks on it with an open turf in front of them
	var/turf/target_turf = get_step(user,user.dir)
	if(target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		to_chat(user, span_danger("I can't deploy the folding table here!"))
		return NONE
	if(isopenturf(target_turf))
		deploy_folding_table(user, target_turf)
		return TRUE
	return NONE

/obj/item/contraption/folding_table_stored/proc/deploy_folding_table(mob/user, atom/location)
	to_chat(user, "<span class='notice'>You deploy the folding table.</span>")
	new /obj/structure/table/wood/folding(location)
	qdel(src)

/obj/item/contraption/shears
	possible_item_intents = list(/datum/intent/use,/datum/intent/snip)
	max_integrity = 150
	name = "auto shears"
	desc = "A powered shear used for achieving a clean separation between limb and patient. Keeping the patient still is imperative to aligning the blades."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "shears"
	on_icon = "shears"
	off_icon = "shears"
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = /obj/item/ingot/bronze
	charge_per_source = 4
	grid_height = 32
	grid_width = 64

/obj/item/contraption/shears/hammer_action(obj/item/I, mob/user)
	return

/obj/item/contraption/shears/attack(mob/living/amputee, mob/living/user)
	if(!current_charge)
		return

	if(!iscarbon(amputee))

		return

	var/targeted_zone = check_zone(user.zone_selected)
	if(targeted_zone == BODY_ZONE_CHEST || targeted_zone == BODY_ZONE_HEAD)
		to_chat(user, span_warning("I can't amputate that!"))
		return

	var/mob/living/carbon/patient = amputee

	if(HAS_TRAIT(patient, TRAIT_NODISMEMBER))
		to_chat(user, span_warning("[patient]'s limbs look too sturdy to amputate."))
		return

	var/obj/item/bodypart/limb_snip_candidate

	limb_snip_candidate = patient.get_bodypart(targeted_zone)
	if(!limb_snip_candidate)
		to_chat(user, span_warning("[patient] is already missing that limb, what more do you want?"))
		return
	var/agreementone
	var/agreementtwo
	if(patient.mind)
		if(patient == user)
			switch(alert(user,"Do I want to cut off my [limb_snip_candidate.name]?", "Do you want amputate?","No","Yes"))
				if("Yes")
					to_chat(user, span_warning("I prepare the device...")) //make sure this is who we want to amputate
					agreementone = TRUE
				if("No")
					to_chat(user, span_warning("I decided not to"))
					return
				else
					to_chat(user, span_warning("I decided not to"))
					return
		else if(patient in range(1, user))
			switch(alert(user,"Are you sure you want amputate [patient.name] [limb_snip_candidate.name]?", "Do you want amputate?","No","Yes"))
				if("Yes")
					to_chat(user, span_warning("I prepare the device...")) //make sure this is who we want to amputate
					agreementone = TRUE
				if("No")
					to_chat(user, span_warning("I decided not to"))
					return
				else
					to_chat(user, span_warning("I decided not to"))
					return
			if((patient.mobility_flags & MOBILITY_STAND))
				to_chat(user, span_warning("My patient must be laying down."))
				return
			switch(alert(patient, "Do you agree to have your [limb_snip_candidate.name] amputated by [user.name]?", "Do you agree to an amputation?", "Resist", "Accept"))
				if("Resist")
					to_chat(user, span_warning("the device fails, the patient is not willing"))
					return
				if("Accept")
					to_chat(user, span_warning("They agree, we can proceed")) //make sure they consent to the amputation
					agreementtwo = TRUE
				else
					to_chat(user, span_warning("the device fails, the patient is not willing"))
					return
			if (agreementone && agreementtwo)
				//we can proceed, they weren't afk
			else
				to_chat(user, span_warning("They can't agree right now")) //a final catch all
				return

	var/amputation_speed_mod = 1

	patient.visible_message(span_danger("[user] begins to secure [src] around [patient]'s [limb_snip_candidate.name]."), span_userdanger("[user] begins to secure [src] around your [limb_snip_candidate.name]!"))
	playsound(get_turf(patient), 'sound/misc/ratchet.ogg', 20, TRUE)
	if(patient.stat >= UNCONSCIOUS || patient.buckled || locate(/obj/structure/table/optable) in get_turf(patient))
		amputation_speed_mod *= 0.5
	if(patient.stat != DEAD && (patient.jitteriness || patient.mobility_flags & MOBILITY_STAND)) //jittering will make it harder to secure the shears, even if you can't otherwise move
		amputation_speed_mod *= 1.5 //15*0.5*1.5=11.25

	var/skill_modifier = 1
	if(user.get_skill_level(/datum/skill/craft/engineering)>(user.get_skill_level(/datum/skill/misc/medicine))) //use the higher skill
		skill_modifier = 1.5 - (user.get_skill_level(/datum/skill/craft/engineering) / 6)
	else //default to using medicine with no engineering skill
		skill_modifier = 1.5 - (user.get_skill_level(/datum/skill/misc/medicine) / 6)
	if(do_after(user, 15 SECONDS * amputation_speed_mod * skill_modifier, target = patient))
		playsound(get_turf(patient), 'sound/misc/guillotine.ogg', 20, TRUE)
		limb_snip_candidate.drop_limb(TRUE)
		user.visible_message(span_danger("[src] violently slams shut, amputating [patient]'s [limb_snip_candidate.name]."), span_notice("You amputate [patient]'s [limb_snip_candidate.name] with [src]."))
		charge_deduction(amputee, user, 1)

/obj/item/contraption/shears/attack_obj(obj/O, mob/living/user)
	if(user.used_intent.type == /datum/intent/snip && istype(O, /obj/item))
		var/obj/item/item = O
		if(item.sewrepair && item.salvage_result) // We can only salvage objects which can be sewn!
			var/salvage_time = 70
			var/skill_level = user.get_skill_level(/datum/skill/craft/sewing)
			skill_level = clamp((skill_level+1),1,6)
			if(user.get_skill_level(/datum/skill/craft/engineering)>(user.get_skill_level(/datum/skill/craft/sewing))) //use the higher skill
				salvage_time = (70 - ((user.get_skill_level(/datum/skill/craft/engineering)) * 10))
			else //default to using sewing with no engineering skill
				salvage_time = (70 - ((user.get_skill_level(/datum/skill/craft/sewing)) * 10))

			if(!do_after(user, salvage_time, target = user))
				return

			if(item.fiber_salvage) //We're getting fiber as base if fiber is present on the item
				new /obj/item/natural/fibers(get_turf(item))
			if(istype(item, /obj/item/storage))
				var/obj/item/storage/bag = item
				bag.emptyStorage()

			if(prob(50 - (skill_level * 10))) // We are dumb and we failed!
				to_chat(user, span_info("I ruined some of the materials due to my lack of skill..."))
				playsound(item, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				qdel(item)
				user.mind.add_sleep_experience(/datum/skill/craft/sewing, (user.STAINT)) //Getting exp for failing
				return //We are returning early if the skill check fails!
			item.salvage_amount -= item.torn_sleeve_number
			for(var/i = 1; i <= item.salvage_amount; i++) // We are spawning salvage result for the salvage amount minus the torn sleves!
				var/obj/item/Sr = new item.salvage_result(get_turf(item))
				Sr.color = item.color
			user.visible_message(span_notice("[user] salvages [item] into usable materials."))
			playsound(item, 'sound/items/flint.ogg', 100, TRUE)
			qdel(item)
			user.mind.add_sleep_experience(/datum/skill/craft/sewing, (user.STAINT))
	return ..()

/obj/item/contraption/lock_imprinter
	name = "lock improver"
	desc = "A useful contraption improves locks at the cost of locks."
	icon_state = "imprinter"
	on_icon = "imprinter_flick"
	off_icon = "imprinter_off"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_power_source = /obj/item/customlock
	misfire_chance = 0
	sneaky_misfire_chance = 20
	charge_per_source = 2
	grid_height = 32
	grid_width = 64

/obj/item/contraption/lock_imprinter/attack_obj(obj/O, mob/living/user)
	..()
	if(current_charge<1)
		flick(off_icon, src)
		to_chat(user, span_info("The contraption beeps! It requires \a [initial(accepted_power_source.name)]!"))
		playsound(src, 'sound/magic/magic_nulled.ogg', 100, TRUE)
		return

	else if(ispath(O.type, /obj/structure/mineral_door))
		var/obj/structure/mineral_door/doorupgrade = O
		var/oldlockdifficulty = doorupgrade.lockdifficulty
		var/newlockdifficulty = oldlockdifficulty + 1
		if(newlockdifficulty > 4)
			flick(off_icon, src)
			to_chat(user, span_info("The contraption beeps! its upgraded to its limit!"))
			playsound(src, 'sound/magic/magic_nulled.ogg', 100, TRUE)
			return
		flick(on_icon, src)
		shake_camera(user, 1, 1)
		user.visible_message(span_notice("[user] holds the [name] up to the [O.name] causing sparks to fly!"))
		playsound(src, pick('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/sheet (2).ogg', 'sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, TRUE)
		doorupgrade.lockdifficulty = newlockdifficulty
		charge_deduction(O, user, 1)
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_turf(O)
		S.set_up(1, 1, front)
		S.start()
		user.mind.add_sleep_experience(/datum/skill/craft/engineering, (user.STAINT)) // Only imprinting gives EXP
		return
