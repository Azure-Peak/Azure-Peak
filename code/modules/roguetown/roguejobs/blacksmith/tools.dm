//Base hammer type. (Wood / Iron / Steel)
/obj/item/rogueweapon/hammer
	force = 21
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash)
	name = "hammer"
	desc = "If you see this - scream, cry, piss, run, shit yourself, then report it to a dev. Shouldn't be here."
	icon_state = "hammer"
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	wlength = WLENGTH_SHORT
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	associated_skill = /datum/skill/combat/maces
	smeltresult = /obj/item/ash
	grid_width = 32
	grid_height = 64
	var/quality = 1
	is_tool = TRUE

/obj/item/rogueweapon/hammer/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click a damaged item made of metal - such as a weapon, armorpiece, or prosthetic - to repair it. Repairs work best when done on an anvil, but a regular old table can suffice in a pinch.")
	. += span_info("Left-click a damaged structure to repair it. Like with repairing items, the chance to successfully repair some integrity on each strike scales with the appropriate skill; the Carpentry skill for structures, Weaponsmithing for weapons, etcetera.")

/obj/item/rogueweapon/hammer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -8,"nx" = 12,"ny" = -8,"wx" = -5,"wy" = -8,"ex" = 6,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -4,"nx" = -5,"ny" = -4,"wx" = -5,"wy" = -3,"ex" = 7,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -45,"sturn" = 45,"wturn" = -45,"eturn" = 45,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/hammer/attack_hand(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_CURSE_MALUM))
		to_chat(user, span_warning("Your cursed hands burn at the touch of the hammer!"))
		user.freak_out()
		return
	. = ..()

/obj/item/rogueweapon/hammer/attack_obj(obj/attacked_object, mob/living/user)
	if(!isliving(user) || !user.mind)
		return

	if(isbodypart(attacked_object) && !user.cmode)
		repair_bodypart(attacked_object, user)
		return

	if(isitem(attacked_object) && !user.cmode)
		repair_item(attacked_object, user)
		return

	if(isstructure(attacked_object) && !user.cmode)
		repair_structure(attacked_object, user)
		return

	. = ..()

/obj/item/rogueweapon/hammer/proc/get_repair_percent(obj/attacked_object)
	. = 0.025 // 2.5% Repairing per hammer smack
	if(locate(/obj/machinery/anvil) in attacked_object.loc)
		. *= 2 // Double the repair amount if we're using an anvil

/obj/item/rogueweapon/hammer/proc/repair_bodypart(obj/item/bodypart/attacked_prosthetic, mob/living/user)
	if(!attacked_prosthetic.anvilrepair) //No hammering flesh limbs
		return
	if(attacked_prosthetic.obj_integrity >= attacked_prosthetic.max_integrity && attacked_prosthetic.brute_dam == 0 && attacked_prosthetic.burn_dam == 0 && attacked_prosthetic.wounds == null && attacked_prosthetic.disabled == BODYPART_NOT_DISABLED)
		to_chat(user, span_warning("There is nothing to further repair on [attacked_prosthetic]."))
		return

	do
		var/repair_percent = get_repair_percent(attacked_prosthetic)
		if(user.get_skill_level(attacked_prosthetic.anvilrepair) <= 0)
			if(prob(30))
				repair_percent = 0.01
			else
				repair_percent = 0
		else
			repair_percent *= user.get_skill_level(attacked_prosthetic.anvilrepair)

		playsound(src,'sound/items/bsmith3.ogg', 100, FALSE)
		if(repair_percent)
			repair_percent *= attacked_prosthetic.max_integrity
			var/exp_gained = min(attacked_prosthetic.obj_integrity + repair_percent, attacked_prosthetic.max_integrity) - attacked_prosthetic.obj_integrity
			attacked_prosthetic.obj_integrity = min(attacked_prosthetic.obj_integrity + repair_percent, attacked_prosthetic.max_integrity)
			attacked_prosthetic.brute_dam = max(attacked_prosthetic.brute_dam - 10, 0)
			attacked_prosthetic.burn_dam = max(attacked_prosthetic.burn_dam - 10, 0)
			attacked_prosthetic.wounds = null //Fixing fractures
			attacked_prosthetic.disabled = BODYPART_NOT_DISABLED
			if(repair_percent == 0.01) // If an inexperienced repair attempt has been successful
				to_chat(user, span_warning("You fumble your way into slightly repairing [attacked_prosthetic]."))
			else
				user.visible_message(span_info("[user] repairs [attacked_prosthetic]!"))
			user.mind.add_sleep_experience(attacked_prosthetic.anvilrepair, exp_gained/2) //We gain as much exp as we fix divided by 2
		else
			user.visible_message(span_warning("[user] fumbles trying to repair [attacked_prosthetic]!"))

		if(attacked_prosthetic.obj_integrity >= attacked_prosthetic.max_integrity && attacked_prosthetic.brute_dam == 0 && attacked_prosthetic.burn_dam == 0 && attacked_prosthetic.wounds == null && attacked_prosthetic.disabled == BODYPART_NOT_DISABLED)
			break

	while(do_after(user, CLICK_CD_MELEE, target = attacked_prosthetic))

/obj/item/rogueweapon/hammer/proc/repair_item(obj/item/attacked_item, mob/living/user)
	if(!attacked_item.anvilrepair || (attacked_item.obj_integrity >= attacked_item.max_integrity) || !isturf(attacked_item.loc))
		return

	if(!attacked_item.ontable())
		to_chat(user, span_warning("I should put this on a table or an anvil first."))
		return

	do
		var/repair_percent = get_repair_percent(attacked_item)
		if(user.get_skill_level(attacked_item.anvilrepair) <= 0)
			if(HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(user, TRAIT_SELF_SUSTENANCE))
				if(locate(/obj/machinery/anvil) in attacked_item.loc)
					repair_percent = 0.035
				//Squires can repair on tables, but less efficiently
				else if(attacked_item.ontable())
					repair_percent = 0.015
			else if(prob(30))
				repair_percent = 0.01
			else
				repair_percent = 0
		else
			repair_percent *= user.get_skill_level(attacked_item.anvilrepair)

		playsound(src,'sound/items/bsmithfail.ogg', 40, FALSE)
		if(repair_percent)
			repair_percent *= attacked_item.max_integrity
			var/exp_gained = min(attacked_item.obj_integrity + repair_percent, attacked_item.max_integrity) - attacked_item.obj_integrity
			attacked_item.obj_integrity = min(attacked_item.obj_integrity + repair_percent, attacked_item.max_integrity)
			if(repair_percent == 0.01) // If an inexperienced repair attempt has been successful
				to_chat(user, span_warning("You fumble your way into slightly repairing [attacked_item]."))
			else
				user.visible_message(span_info("[user] repairs [attacked_item]!"))
				if(attacked_item.body_parts_covered != attacked_item.body_parts_covered_dynamic)
					user.visible_message(span_info("[user] repairs [attacked_item]'s coverage!"))
					attacked_item.repair_coverage()
			if(attacked_item.obj_broken && attacked_item.obj_integrity == attacked_item.max_integrity)
				attacked_item.obj_fix()
			user.mind.add_sleep_experience(attacked_item.anvilrepair, exp_gained/2) //We gain as much exp as we fix divided by 2
		else
			user.visible_message(span_warning("[user] fumbles trying to repair [attacked_item]!"))

		if(attacked_item.obj_integrity >= attacked_item.max_integrity)
			break

	while(do_after(user, CLICK_CD_MELEE, target = attacked_item))

/obj/item/rogueweapon/hammer/proc/repair_structure(obj/structure/attacked_structure, mob/living/user)
	if(!attacked_structure.hammer_repair || !attacked_structure.max_integrity)
		return
	if(user.get_skill_level(attacked_structure.hammer_repair) <= 0)
		to_chat(user, span_warning("I don't know how to repair this.."))
		return

	do
		var/repair_percent = get_repair_percent(attacked_structure)
		repair_percent *= user.get_skill_level(attacked_structure.hammer_repair) * attacked_structure.max_integrity
		var/exp_gained = min(attacked_structure.obj_integrity + repair_percent, attacked_structure.max_integrity) - attacked_structure.obj_integrity
		attacked_structure.obj_integrity = min(attacked_structure.obj_integrity + repair_percent, attacked_structure.max_integrity)
		user.mind.add_sleep_experience(attacked_structure.hammer_repair, exp_gained) //We gain as much exp as we fix
		playsound(src,'sound/items/bsmithfail.ogg', 100, FALSE)
		user.visible_message(span_info("[user] repairs [attacked_structure]!"))

		if(attacked_structure.obj_integrity >= attacked_structure.max_integrity)
			break

	while(do_after(user, CLICK_CD_MELEE, target = attacked_structure))

/obj/item/rogueweapon/hammer/attack(mob/living/M, mob/user)

	if(!user.cmode)
		var/wCount = M.get_wounds()
		if((M.getBruteLoss() + M.getFireLoss()) <= 0 && !length(wCount))
			user.visible_message(
				span_notice("[M] is good as new!"),
				span_notice("I am good as new!")
			)
			playsound(user.loc, 'sound/items/bsmith4.ogg', 100, FALSE)
			if(prob(30))
				M.emote("whimper") // robbit aboose
			return	
		else
			if(M.has_status_effect(/datum/status_effect/debuff/integrity_rig))
				if(M == user)
					to_chat(user, span_warning("I can't get the right angle to fix this, I need help from someone else!"))
					return
				user.visible_message(span_warning("[user] begins lining up a decisive strike onto the Jury Rig!"))
				if(!do_after(user, 4 SECONDS))
					return
				M.remove_status_effect(/datum/status_effect/debuff/integrity_rig)
				playsound(M.loc, 'sound/misc/bonk.ogg', 100, FALSE, -1) // satisfying
				for(var/datum/wound/W in wCount)
					if(W.severity >= WOUND_SEVERITY_CRITICAL)
						qdel(W)
						break
			hammerheal(M, user)
	else
		. = ..() //normal hit

/obj/item/rogueweapon/hammer/proc/hammerheal(mob/living/M, mob/living/user)
	if(!user || !M)
		return

	if(!M.can_inject(user, TRUE))
		return

	if(!ishuman(M))
		return

	if(!HAS_TRAIT(M, TRAIT_IRONMAN))
		to_chat(user, span_warning("They are not made of metal, you can't tinker with that."))
		return

	var/qualified = FALSE

	if(user == M)
		qualified = TRUE
	else
		if(user.get_skill_level(/datum/skill/craft/armorsmithing) >= SKILL_LEVEL_JOURNEYMAN)
			qualified = TRUE
		if(user.get_skill_level(/datum/skill/craft/engineering) >= SKILL_LEVEL_JOURNEYMAN)
			qualified = TRUE
		if(user.get_skill_level(/datum/skill/craft/blacksmithing) >= SKILL_LEVEL_JOURNEYMAN)
			qualified = TRUE

	var/mob/living/carbon/human/H = M

	// BUILD PRIORITY LIST ONCE
	var/list/priority_limbs = list()

	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(!BP || QDELETED(BP))
			continue

		var/priority = BP.brute_dam + BP.burn_dam

		for(var/datum/wound/W in BP.wounds)
			if(W.severity >= WOUND_SEVERITY_MODERATE)
				priority += 20
			else
				priority += 10

		if(priority > 0)
			priority_limbs[BP] = priority

	// sort descending (highest priority first)
	priority_limbs = sortTim(priority_limbs, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE)

	do
		if(!user || !M || QDELETED(user) || QDELETED(M))
			break

		if(user.stat != CONSCIOUS)
			break

		if(get_dist(user, M) > 1)
			break

		if(!priority_limbs.len)
			break

		var/obj/item/bodypart/affecting = priority_limbs[1]

		if(!affecting || QDELETED(affecting))
			priority_limbs.Cut(1,2)
			continue

		var/has_complex_wounds = FALSE
		var/list/wCount = H.get_wounds()

		for(var/datum/wound/W in wCount)
			if(W.severity >= WOUND_SEVERITY_MODERATE)
				has_complex_wounds = TRUE
				break

		var/has_tongs = FALSE
		var/has_wrench = FALSE

		for(var/obj/item/I in user.held_items)
			if(!I || QDELETED(I))
				continue

			if(istype(I, /obj/item/rogueweapon/tongs))
				has_tongs = TRUE

			if(istype(I, /obj/item/contraption/linker))
				has_wrench = TRUE

		if(has_complex_wounds && !(has_tongs || has_wrench))
			to_chat(user, span_warning("These injuries are too severe to repair with just a hammer! Either Tongs or a Wrench on your free hand are needed."))
			return

		var/used_time = 90 

		if(user.mind)
			used_time -= (user.get_skill_level(/datum/skill/craft/engineering) * 7)
			used_time -= (user.get_skill_level(/datum/skill/craft/armorsmithing) * 2)
			used_time -= (user.get_skill_level(/datum/skill/craft/blacksmithing) * 2)

		if(has_tongs)
			used_time *= 0.75

		if(has_wrench)
			used_time *= 0.25

		used_time = round(max(used_time, 5))

		if(has_complex_wounds)
			playsound(user.loc, 'sound/misc/ratchet.ogg', 80, FALSE)
		else
			playsound(user.loc, 'sound/items/bsmith1.ogg', 100, FALSE)

		if(!do_after(user, used_time, TRUE, M))
			return

		if(!user || !M || QDELETED(user) || QDELETED(M))
			break

		if(user.stat || get_dist(user, M) > 1)
			break

		playsound(user.loc, 'sound/items/bsmith4.ogg', 100, FALSE)

		var/brute_heal = (M == user) ? 10 : 25
		var/fire_heal = (M == user) ? 10 : 25

		if(!qualified)
			var/current_total = M.getBruteLoss() + M.getFireLoss()
			var/minimum_allowed = 300

			if(current_total <= minimum_allowed)
				user.visible_message(span_warning("[user] hesitates while working on [M], no longer knowing how to proceed."), span_warning("I don't know how to proceed from here..."))
				break

			if(prob(50))
				user.visible_message(span_notice("[user] manages to hammer [M]'s [affecting.name] into better shape."),span_notice("I think that worked."))
			else
				user.visible_message(span_warning("[user] awkwardly tinkers with [M]'s [affecting.name], uncertain what to do."), span_warning("I'm not sure what I'm doing..."))
				playsound(user.loc, 'sound/items/bsmith4.ogg', 100, FALSE)
				shake_camera(M, 2, 1)
				shake_camera(user, 2, 1)

				if(prob(30))
					if(prob(50))
						M.emote("whimper")
					else
						M.emote("cry")

				continue

			var/allowed_healing = current_total - minimum_allowed

			brute_heal = min(brute_heal, allowed_healing)
			fire_heal = min(fire_heal, allowed_healing)

		affecting.heal_damage(brute_heal, fire_heal)

		if(has_tongs || has_wrench)
			H.heal_wounds(5)

		H.update_damage_overlays()
		user.mind.add_sleep_experience(/datum/skill/craft/engineering, (user.STAINT*2.5))

		if(M == user)
			user.visible_message(span_notice("[user] repairs [user.p_their()] [affecting.name]."), span_notice("I repair my [affecting.name]."))
		else
			user.visible_message(span_notice("[user] repairs [M]'s [affecting.name]."),	span_notice("I repair [M]'s [affecting.name]."))

		// CHECK IF THIS LIMB IS DONE → MOVE TO NEXT
		if((affecting.brute_dam + affecting.burn_dam) <= 0 && !length(affecting.wounds))
			priority_limbs.Cut(1,2)

		if((M.getBruteLoss() + M.getFireLoss()) <= 0 && !length(H.get_wounds()))
			user.visible_message(span_notice("[M] is good as new!"), span_notice("I am good as new!"))
			break

	while(do_after(user, CLICK_CD_MELEE, TRUE, M))

/obj/item/rogueweapon/hammer/wood	// wood hammer (mallet)
	name = "wooden mallet"
	desc = "A wooden mallet is an Artificer's second best friend! But it may also come in handy to a Blacksmith or Tailor.."
	icon_state = "hammer_w"
	force = 16
	anvilrepair = /datum/skill/craft/crafting

/obj/item/rogueweapon/hammer/stone	// stone hammer
	name = "stone hammer"
	desc = "A makeshift hammer, made with a crudly chisled-down rock."
	icon_state = "hammer_r"
	force = 18
	max_integrity = 15
	anvilrepair = /datum/skill/craft/crafting

/obj/item/rogueweapon/hammer/paalloy
	name = "ancient hammer"
	desc = "A hammer of polished gilbronze. Remade masterfully upon a smooth handle, it shall make forth the armaments of Her legionnaries and great works.."
	icon_state = "ahammer"
	force = 21
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/hammer/aalloy
	name = "decrepit hammer"
	desc = "A hammer of wrought bronze. It has pounded out the beginning of a thousand legacies; of humble adventurers, of noble legionnaires, and of foolish heroes."
	icon_state = "ahammer"
	force = 12
	max_integrity = 10
	smeltresult = /obj/item/ingot/aaslag
	color = "#bb9696"
	sellprice = 15

/obj/item/rogueweapon/hammer/bronze
	name = "bronze hammer"
	desc = "'I've been gripping this thing since before I could even walk - I didn't choose this, this is who I am. I just strike it. I don't think.' </br>'I spent my youth desperate to forge a better sword, become a more skilled smith, before I knew it..' </br>'I was old.' </br>'I don't even know what the hell I strike the iron for. But there is still one thing I like about it..' </br>'..the sparks. I like seeing sparks.. ..breathtaking, life, bursting before my eyes for just a moment..'"
	icon_state = "hammer_bronze"
	smeltresult = /obj/item/ingot/bronze
	force = 24
	max_integrity = 300

/obj/item/rogueweapon/hammer/copper
	name = "copper hammer"
	desc = "A copper hammer, slightly better than a stone hammer."
	icon_state = "hammer_c"
	force = 20
	max_integrity = 100

/obj/item/rogueweapon/hammer/iron	// iron hammer
	name = "hammer"
	desc = "Each strikes reverberate loudly chanting war!"
	icon_state = "hammer_i"
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/hammer/steel	// steel hammer
	name = "claw hammer"
	desc = "Steel to drive the iron nail without mercy."
	icon_state = "hammer_s"
	smeltresult = /obj/item/ingot/steel

/*
/obj/item/rogueweapon/hammer/steel/attack_turf(turf/T, mob/living/user)
	if(!user.cmode)
		if(T.hammer_repair && T.max_integrity && !T.obj_broken)
			var/repair_percent = 0.05
			if(user.mind)
				if(user.get_skill_level(I.hammer_repair) <= 0)
					to_chat(user, span_warning("I don't know how to repair this.."))
					return
				repair_percent = max(user.get_skill_level(I.hammer_repair) * 0.05, 0.05)
			repair_percent = repair_percent * I.max_integrity
			I.obj_integrity = min(obj_integrity+repair_percent, I.max_integrity)
			playsound(src,'sound/items/bsmithfail.ogg', 100, FALSE)
			user.visible_message(span_info("[user] repairs [I]!"))
			return
	..()
*/
/obj/item/rogueweapon/hammer/blacksteel
	name = "blacksteel hammer"
	desc = "A hammer made of blacksteel, to drive even the hardest metals into submission."
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "bs_masterhammer"
	item_state = "bs_masterhammer"
	quality = 2
	smeltresult = /obj/item/ingot/blacksteel
	max_integrity = 450
	force = 28

/obj/item/rogueweapon/tongs
	force = 10
	possible_item_intents = list(/datum/intent/mace/strike)
	name = "tongs"
	desc = "A pair of iron tongs that'll hold onto Psydonia's hottest metal, betwixt a hammering and an anvil's song to forge masterworks of craft."
	icon_state = "tongs"
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	wlength = WLENGTH_SHORT
	slot_flags = ITEM_SLOT_HIP
	tool_behaviour = TOOL_IMPROVISED_HEMOSTAT
	associated_skill = /datum/skill/craft/blacksmithing	//Tongs don't do a lot of damage and have 3 defense. This associated skill should be alright.
	var/obj/item/ingot/hingot = null
	var/hott = FALSE
	smeltresult = /obj/item/ingot/iron
	grid_width = 32
	grid_height = 64
	is_tool = TRUE
	var/auto_collect = TRUE

/obj/item/rogueweapon/tongs/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click an ingot to pick it up. When an ingot is held by the tongs, left-clicking a forge will heat it up. Heated-up ingots can then be placed on an anvil and struck with a hammer to smith various items.")
	. += span_info("Activate in your hand to drop the picked-up ingot.")
	. += span_info("Right click to toggle auto collection of multiple ingots from furnaces.")

/obj/item/rogueweapon/tongs/examine(mob/user)
	. = ..()
	if(hott)
		. += span_warning("The tip is hot to the touch.")
	if(auto_collect)
		. += span_notice("It is set to auto collect multiple ingots from furnaces.")

/obj/item/rogueweapon/tongs/attack_right(mob/user)
	auto_collect = !auto_collect
	to_chat(user, span_notice("The tongs will [auto_collect ? "" : "no longer "]automatically collect from furnaces."))
	. = ..()

/obj/item/rogueweapon/tongs/get_temperature()
	if(hott)
		return FIRE_MINIMUM_TEMPERATURE_TO_SPREAD
	return ..()

/obj/item/rogueweapon/tongs/fire_act(added, maxstacks)
	. = ..()
	hott = world.time
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(make_unhot), world.time), 10 SECONDS)

/obj/item/rogueweapon/tongs/update_icon()
	. = ..()
	if(!hingot)
		icon_state = "tongs"
	else
		if(hott)
			icon_state = "tongsi1"
		else
			icon_state = "tongsi0"

/obj/item/rogueweapon/tongs/proc/make_unhot(input)
	if(hott == input)
		hott = FALSE
		update_icon()

/obj/item/rogueweapon/tongs/attack_self(mob/user)
	if(hingot)
		if(isturf(user.loc))
			var/turf/T = get_turf(user)
			if(!T)
				T = get_turf(src)
			if(T)
				hingot.forceMove(T)
			hingot = null
			hott = FALSE
			update_icon()
			
/obj/item/rogueweapon/tongs/dropped(mob/user)
	. = ..()
	if(!hingot)
		hott = FALSE
		update_icon()
		return

	var/turf/T = get_turf(src) || (user ? get_turf(user) : null)
	if(T)
		hingot.forceMove(T)
	hingot = null
	hott = FALSE
	update_icon()

/obj/item/rogueweapon/tongs/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -8,"nx" = 12,"ny" = -8,"wx" = -5,"wy" = -8,"ex" = 6,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -4,"nx" = -5,"ny" = -4,"wx" = -5,"wy" = -3,"ex" = 7,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -45,"sturn" = 45,"wturn" = -45,"eturn" = 45,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/tongs/stone
	name = "stone tongs"
	icon_state = "stonetongs"
	force = 5
	smeltresult = null
	max_integrity = 15
	auto_collect = FALSE

/obj/item/rogueweapon/tongs/stone/update_icon()
	. = ..()
	if(!hingot)
		icon_state = "stonetongs"
	else
		if(hott)
			icon_state = "stonetongsi1"
		else
			icon_state = "stonetongsi0"

/obj/item/rogueweapon/tongs/aalloy
	name = "decrepit tongs"
	desc = "Wrought bronze pincers the molten alloy, putting it before the anvil and hammer. Soon, it will fashion a new legacy; one unmarred by this dogmatic millenia."
	icon_state = "atongs"
	force = 5
	smeltresult = null
	max_integrity = 10
	color = "#bb9696"
	sellprice = 5
	auto_collect = FALSE

/obj/item/rogueweapon/tongs/aalloy/update_icon()
	. = ..()
	if(!hingot)
		icon_state = "atongs"
	else
		if(hott)
			icon_state = "atongsi1"
		else
			icon_state = "atongsi0"

/obj/item/rogueweapon/tongs/paalloy
	name = "ancient tongs"
	desc = "Wrought bronze pincers the molten alloy, putting it before the anvil and hammer. Soon, it will fashion a new legacy; one unmarred by this dogmatic millenia."
	icon_state = "atongs"
	smeltresult = null
	auto_collect = TRUE

/obj/item/rogueweapon/tongs/paalloy/update_icon()
	. = ..()
	if(!hingot)
		icon_state = "atongs"
	else
		if(hott)
			icon_state = "atongsi1"
		else
			icon_state = "atongsi0"

/obj/item/rogueweapon/tongs/bronze
	name = "bronze tongs"
	desc = "Pincers of bronze, handled of wood. Plunge into the coals without fear of burning, so that you may command alloy-and-stone to morph as you please."
	icon_state = "bronzetongs"
	wdefense = 6
	smeltresult = /obj/item/ingot/bronze
	icon = 'icons/roguetown/weapons/tools.dmi'
	force = 14
	max_integrity = 300
	auto_collect = TRUE

/obj/item/rogueweapon/tongs/bronze/update_icon()
	. = ..()
	if(!hingot)
		icon_state = "bronzetongs"
	else
		if(hott)
			icon_state = "bronzetongsi1"
		else
			icon_state = "bronzetongsi0"

/obj/item/rogueweapon/tongs/blacksteel
	name = "blacksteel tongs"
	desc = "A pair of blacksteel jaws, almost certainly used as a sign of prestige."
	icon_state = "bs_tongs"
	wdefense = 6
	icon = 'icons/roguetown/weapons/tools.dmi'
	smeltresult = /obj/item/ingot/blacksteel
	force = 20
	max_integrity = 450
	auto_collect = TRUE

/obj/item/rogueweapon/tongs/blacksteel/update_icon()
	. = ..()
	if(!hingot)
		icon_state = "bs_tongs"
	else
		if(hott)
			icon_state = "bs_tongsi1"
		else
			icon_state = "bs_tongsi0"
