
/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	name = "crossbow"
	desc = "A deadly weapon that shoots a bolt with terrific power."
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "crossbow0"
	item_state = "crossbow"
	experimental_onhip = TRUE
	experimental_onback = TRUE
	possible_item_intents = list(/datum/intent/shoot/crossbow, /datum/intent/arc/crossbow, INTENT_GENERIC)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/xbow
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	randomspread = 1
	spread = 0
	can_parry = TRUE
	var/chargingspeed = 40
	var/reloadtime = 40
	var/movingreload = FALSE
	var/hasloadedsprite = FALSE
	force = 10
	var/cocked = FALSE
	cartridge_wording = "bolt"
	load_sound = 'sound/foley/nockarrow.ogg'
	fire_sound = 'sound/combat/Ranged/crossbow-small-shot-02.ogg'
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	resistance_flags = FIRE_PROOF
	obj_flags = UNIQUE_RENAME
	damfactor = 1.2
	accfactor = 1.1

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/shoot/crossbow
	chargedrain = 0 //no drain to aim a crossbow
	var/basetime = 40

/datum/intent/shoot/crossbow/slurbow
	chargedrain = 0 //no drain to aim a crossbow
	basetime = 20

/datum/intent/shoot/crossbow/can_charge(atom/clicked_object)
	if(mastermob)
		if(mastermob.get_num_arms(FALSE) < 2)
			return FALSE
		if(mastermob.get_inactive_held_item())
			return FALSE
		if(istype(clicked_object, /obj/item/quiver) && istype(mastermob.get_active_held_item(), /obj/item/gun/ballistic))
			return FALSE
	return TRUE


/datum/intent/shoot/crossbow/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + basetime
		newtime = newtime - (mastermob.get_skill_level(/datum/skill/combat/crossbows) * 4.25) // minus 4.25 per skill point
		newtime = newtime - ((mastermob.STAPER)) // minus 1 per perception
		if(newtime > 1)
			return newtime
		else
			return 1
	return chargetime

/datum/intent/arc/crossbow
	chargetime = 1
	var/basetime = 40
	chargedrain = 0 //no drain to aim a crossbow

/datum/intent/arc/crossbow/slurbow
	chargetime = 1
	basetime = 20
	chargedrain = 0



/datum/intent/arc/crossbow/can_charge(atom/clicked_object)
	if(mastermob)
		if(mastermob.get_num_arms(FALSE) < 2)
			return FALSE
		if(mastermob.get_inactive_held_item())
			return FALSE
		if(istype(clicked_object, /obj/item/quiver) && istype(mastermob.get_active_held_item(), /obj/item/gun/ballistic))
			return FALSE
	return TRUE

/datum/intent/arc/crossbow/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + basetime
		newtime = newtime - (mastermob.get_skill_level(/datum/skill/combat/crossbows) * 20)
		//per block
		newtime = newtime + 20
		newtime = newtime - ((mastermob.STAPER)*1.5)
		if(newtime > 0)
			return newtime
		else
			return 10
	return chargetime


/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/shoot_with_empty_chamber()
	if(cocked)
		playsound(src.loc, 'sound/combat/Ranged/crossbow-small-shot-02.ogg', 100, FALSE)
		cocked = FALSE
		update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/attack_self(mob/living/user)
	if(chambered)
		..()
	else
		if(!cocked)
			to_chat(user, span_info("I step on the stirrup and use all my might..."))
			if(!movingreload)
				if(do_after(user, reloadtime - user.STASTR, target = user))
					playsound(user, 'sound/combat/Ranged/crossbow_medium_reload-01.ogg', 100, FALSE)
					cocked = TRUE
			else
				if(move_after(user, reloadtime - user.STASTR, target = user))
					playsound(user, 'sound/combat/Ranged/crossbow_medium_reload-01.ogg', 100, FALSE)
					cocked = TRUE
		else
			to_chat(user, span_warning("I carefully de-cock the crossbow."))
			cocked = FALSE
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		if(cocked)
			if((loc == user) && (user.get_inactive_held_item() != src))
				return
			..()
		else
			to_chat(user, span_warning("I need to cock the bow first."))


/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(user.get_num_arms(FALSE) < 2)
		return FALSE
	if(user.get_inactive_held_item())
		return FALSE
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB

		BB.accuracy += accfactor * (user.STAPER - 8) * 3 // 8+ PER gives +3 per level. Exponential.
		BB.bonus_accuracy += (user.STAPER - 8) // 8+ PER gives +1 per level. Does not decrease over range.
		BB.bonus_accuracy += (user.get_skill_level(/datum/skill/combat/crossbows) * 5) // +5 per XBow level.'
		BB.armor_penetration *= penfactor
		BB.damage *= damfactor
	cocked = FALSE
	..()

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/update_icon()
	. = ..()
	cut_overlays()
	icon_state = "[item_state][cocked ? "1" : "0"]"

	if(chambered && !hasloadedsprite)
		var/mutable_appearance/ammo = mutable_appearance('icons/roguetown/weapons/ammo.dmi', chambered.icon_state)
		add_overlay(ammo)
	if(chambered && hasloadedsprite)
		icon_state = "[item_state][2]"
	
	if(!ismob(loc))
		return
	var/mob/M = loc
	M.update_inv_hands()

/obj/item/ammo_box/magazine/internal/shot/xbow
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt
	caliber = "regbolt"
	max_ammo = 1
	start_empty = TRUE


/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	name = "slurbow"
	desc = "A lighter weight crossbow with a distinct barrel shroud holding the bolt in place. Light enough to arm by hand. <br>They're popular among among highwaymen and the patrolling lamplighters of Otava."
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "slurbow0"
	item_state = "slurbow"
	possible_item_intents = list(/datum/intent/shoot/crossbow/slurbow, /datum/intent/arc/crossbow/slurbow, INTENT_GENERIC)
	chargingspeed = 20
	damfactor = 0.6
	accfactor = 1.3
	reloadtime = 20
	hasloadedsprite = TRUE
	movingreload = TRUE
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_HIP
	penfactor = 0.5		//Bolts have 50 pen, this decreases to 25. Should only pen armor with less than 67 protection.

