//Base hammer type. (Wood / Iron / Steel)
/obj/item/rogueweapon/hammer
	force = 21
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash)
	name = "template hammer"
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

/obj/item/rogueweapon/hammer/attack_hand(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_CURSE_MALUM))
		to_chat(user, span_warning("Your cursed hands burn at the touch of the hammer!"))
		user.freak_out()
		return
	. = ..()

/obj/item/rogueweapon/hammer/attack_obj(obj/attacked_object, mob/living/user)
	if(!isliving(user) || !user.mind)
		return
	var/mob/living/blacksmith = user
	var/repair_percent = 0.025 // 2.5% Repairing per hammer smack
	/// Repairing is MUCH better with an anvil!
	if(locate(/obj/machinery/anvil) in attacked_object.loc)
		repair_percent *= 2 // Double the repair amount if we're using an anvil
	var/exp_gained = 0

	if(isbodypart(attacked_object) && !user.cmode)
		var/obj/item/bodypart/attacked_prosthetic = attacked_object
		if(!attacked_prosthetic.anvilrepair) //No hammering flesh limbs
			return
		if(attacked_prosthetic.obj_integrity >= attacked_prosthetic.max_integrity && attacked_prosthetic.brute_dam == 0 && attacked_prosthetic.burn_dam == 0 && attacked_prosthetic.wounds == null && attacked_prosthetic.disabled == BODYPART_NOT_DISABLED) //A mouthful
			to_chat(user, span_warning("There is nothing to further repair on [attacked_prosthetic]."))
			return
		if(blacksmith.get_skill_level(attacked_prosthetic.anvilrepair) <= 0)
			if(prob(30))
				repair_percent = 0.01
			else
				repair_percent = 0
		else
			repair_percent *= blacksmith.get_skill_level(attacked_prosthetic.anvilrepair)
		playsound(src,'sound/items/bsmith3.ogg', 100, FALSE)
		if(repair_percent)
			repair_percent *= attacked_prosthetic.max_integrity
			exp_gained = min(attacked_prosthetic.obj_integrity + repair_percent, attacked_prosthetic.max_integrity) - attacked_prosthetic.obj_integrity
			attacked_prosthetic.obj_integrity = min(attacked_prosthetic.obj_integrity + repair_percent, attacked_prosthetic.max_integrity)
			attacked_prosthetic.brute_dam = max(attacked_prosthetic.brute_dam - 10, 0)
			attacked_prosthetic.burn_dam = max(attacked_prosthetic.burn_dam - 10, 0)
			attacked_prosthetic.wounds = null //Fixing fractures
			attacked_prosthetic.disabled = BODYPART_NOT_DISABLED
			if(repair_percent == 0.01) // If an inexperienced repair attempt has been successful
				to_chat(user, span_warning("You fumble your way into slightly repairing [attacked_prosthetic]."))
			else
				user.visible_message(span_info("[user] repairs [attacked_prosthetic]!"))
			blacksmith.mind.add_sleep_experience(attacked_prosthetic.anvilrepair, exp_gained/2) //We gain as much exp as we fix divided by 2
			if(do_after(user, CLICK_CD_MELEE, target = attacked_object))
				attack_obj(attacked_object, user)
			return
		else
			user.visible_message(span_warning("[user] fumbles trying to repair [attacked_prosthetic]!"))
			if(do_after(user, CLICK_CD_MELEE, target = attacked_object))
				attack_obj(attacked_object, user)
			return

	if(isitem(attacked_object) && !user.cmode)
		var/obj/item/attacked_item = attacked_object
		if(!attacked_item.anvilrepair || (attacked_item.obj_integrity >= attacked_item.max_integrity) || !isturf(attacked_item.loc))
			return

		if(!attacked_item.ontable())
			to_chat(user, span_warning("I should put this on a table or an anvil first."))
			return

		if(blacksmith.get_skill_level(attacked_item.anvilrepair) <= 0)
			if(HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR))
				if(locate(/obj/machinery/anvil) in attacked_object.loc)
					repair_percent = 0.035
				//Squires can repair on tables, but less efficiently
				else if(attacked_item.ontable())
					repair_percent = 0.015
			else if(prob(30))
				repair_percent = 0.01
			else
				repair_percent = 0
		else
			repair_percent *= blacksmith.get_skill_level(attacked_item.anvilrepair)

		playsound(src,'sound/items/bsmithfail.ogg', 40, FALSE)
		if(repair_percent)
			repair_percent *= attacked_item.max_integrity
			exp_gained = min(attacked_item.obj_integrity + repair_percent, attacked_item.max_integrity) - attacked_item.obj_integrity
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
			blacksmith.mind.add_sleep_experience(attacked_item.anvilrepair, exp_gained/2) //We gain as much exp as we fix divided by 2
			if(do_after(user, CLICK_CD_MELEE, target = attacked_object))
				attack_obj(attacked_object, user)
			return
		else
			user.visible_message(span_warning("[user] fumbles trying to repair [attacked_item]!"))
			if(do_after(user, CLICK_CD_MELEE, target = attacked_object))
				attack_obj(attacked_object, user)
			return

	if(isstructure(attacked_object) && !user.cmode)
		var/obj/structure/attacked_structure = attacked_object
		if(!attacked_structure.hammer_repair || !attacked_structure.max_integrity)
			return
		if(blacksmith.get_skill_level(attacked_structure.hammer_repair) <= 0)
			to_chat(user, span_warning("I don't know how to repair this.."))
			return
		repair_percent *= blacksmith.get_skill_level(attacked_structure.hammer_repair) * attacked_structure.max_integrity
		exp_gained = min(attacked_structure.obj_integrity + repair_percent, attacked_structure.max_integrity) - attacked_structure.obj_integrity
		attacked_structure.obj_integrity = min(attacked_structure.obj_integrity + repair_percent, attacked_structure.max_integrity)
		blacksmith.mind.add_sleep_experience(attacked_structure.hammer_repair, exp_gained) //We gain as much exp as we fix
		playsound(src,'sound/items/bsmithfail.ogg', 100, FALSE)
		user.visible_message(span_info("[user] repairs [attacked_structure]!"))
		if(attacked_object.obj_integrity <= attacked_object.max_integrity && do_after(user, CLICK_CD_MELEE, target = attacked_object))
			attack_obj(attacked_object, user)
		return

	. = ..()

/obj/item/rogueweapon/hammer/attack(mob/living/M, mob/user)

	if(!user.cmode)
		hammerheal(M, user)
	else
		. = ..() //normal hit

/obj/item/rogueweapon/hammer/proc/hammerheal(mob/living/M, mob/user)
	if(!M.can_inject(user, TRUE))
		return
	if(!ishuman(M))
		return
	if(M.construct)
		var/mob/living/carbon/human/H = M
		var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
		if(!affecting)
			return
		var/used_time = 70
		if(user.mind)
			used_time -= (user.get_skill_level(/datum/skill/craft/engineering) * 10)
		playsound(loc, 'sound/items/bsmith1.ogg', 100, FALSE)
		if(!do_mob(user, M, used_time))
			return
		playsound(loc, 'sound/items/bsmith4.ogg', 100, FALSE)

		var/list/wCount = H.get_wounds()
		H.adjustBruteLoss(-10)
		H.adjustFireLoss(-10)
		H.update_damage_overlays()
		if(wCount.len > 0)
			if(M == user)
				H.heal_wounds(2)
			else
				H.heal_wounds(10) // Other heal are far more powerful and can heal skullcrack in 15 hits instead of 75
			H.update_damage_overlays()
		if(M == user)
			user.visible_message(span_notice("[user] hammers [user.p_their()] [affecting]."), span_notice("I hammer my [affecting]."))
		else
			user.visible_message(span_notice("[user] hammers [M]'s [affecting]."), span_notice("I hammer [M]'s [affecting]."))
		if(wCount.len > 0)
			// Auto repeat healing
			hammerheal(M, user)
	else //Non-construct.
		to_chat(user, span_warning("I can't tinker on living flesh!"))

/obj/item/rogueweapon/hammer/wood	// wood hammer (mallet)
	name = "wooden mallet"
	desc = "A wooden mallet is an artificers second best friend! But it may also come in handy to a smith..."
	icon_state = "hammer_w"
	force = 16

/obj/item/rogueweapon/hammer/stone	// stone hammer
	name = "stone hammer"
	desc = "A makeshift hammer, made with a crudly chisled-down rock."
	icon_state = "hammer_r"
	force = 18
	max_integrity = 15

/obj/item/rogueweapon/hammer/aalloy
	name = "decrepit hammer"
	desc = "A hammer of wrought bronze. It has pounded out the beginning of a thousand legacies; of humble adventurers, of noble legionnaires, and of foolish heroes."
	icon_state = "ahammer"
	force = 12
	max_integrity = 10
	smeltresult = /obj/item/ingot/aaslag
	color = "#bb9696"
	sellprice = 15



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
	force = 25
	name = "blacksteel hammer"
	desc = "A hammer made of blacksteel, to drive even the hardest metals into submission."
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "bs_masterhammer"
	item_state = "bs_masterhammer"
	quality = 2
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/hammer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,
"sx" = -15,
"sy" = -12,
"nx" = 9,
"ny" = -11,
"wx" = -11,
"wy" = -11,
"ex" = 1,
"ey" = -12,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 90,
"sturn" = -90,
"wturn" = -90,
"eturn" = 90,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/tongs
	force = 10
	possible_item_intents = list(/datum/intent/mace/strike)
	name = "tongs"
	desc = "A pair of blacksteel tongs that'll hold onto Psydonia's hottest metal without ever warping. 'Tis a symbol of prestige."
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

/obj/item/rogueweapon/tongs/examine(mob/user)
	. = ..()
	if(hott)
		. += span_warning("The tip is hot to the touch.")

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
			hingot.forceMove(get_turf(user))
			hingot = null
			hott = FALSE
			update_icon()

/obj/item/rogueweapon/tongs/dropped()
	. = ..()
	if(hingot)
		hingot.forceMove(get_turf(src))
		hingot = null
	hott = FALSE
	update_icon()

/obj/item/rogueweapon/tongs/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,
"sx" = -15,
"sy" = -12,
"nx" = 9,
"ny" = -11,
"wx" = -11,
"wy" = -11,
"ex" = 1,
"ey" = -12,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 90,
"sturn" = -90,
"wturn" = -90,
"eturn" = 90,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/tongs/stone
	name = "stone tongs"
	icon_state = "stonetongs"
	force = 5
	smeltresult = null
	max_integrity = 15

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

/obj/item/rogueweapon/tongs/aalloy/update_icon()
	. = ..()
	if(!hingot)
		icon_state = "atongs"
	else
		if(hott)
			icon_state = "atongsi1"
		else
			icon_state = "atongsi0"

/obj/item/rogueweapon/tongs/blacksteel
	name = "blacksteel tongs"
	desc = "A pair of blacksteel jaws almost certainly used as a sign of prestige."
	icon_state = "bs_tongs"
	wdefense = 6
	icon = 'icons/roguetown/weapons/tools.dmi'
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/tongs/blacksteel/update_icon()
	. = ..()
	if(!hingot)
		icon_state = "bs_tongs"
	else
		if(hott)
			icon_state = "bs_tongsi1"
		else
			icon_state = "bs_tongsi0"
