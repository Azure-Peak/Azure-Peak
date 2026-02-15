
/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	name = "crossbow"
	desc = "A deadly weapon that shoots a bolt with terrific power. Unlike the common bow, \
	it uses a sophisticated mechanism to renock - and retain - its half-length bolts; a \
	matter that relies more on raw strength than dexterity to master. </br>A favorite \
	amongst the Keep's ever-dutiful watchmen, both for its relative ease-of-use and \
	effectiveness against Psydonia's unchivalrous inhabitants."
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "crossbow0"
	item_state = "crossbow"
	experimental_onhip = TRUE
	experimental_onback = TRUE
	possible_item_intents = list(/datum/intent/shoot/crossbow, /datum/intent/arc/crossbow, /datum/intent/buttstroke)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/xbow
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	randomspread = 1
	spread = 0
	can_parry = TRUE
	wdefense = 3
	max_integrity = 100
	var/chargingspeed = 40
	var/reloadtime = 40
	var/movingreload = FALSE
	var/onehanded = FALSE
	var/hasloadedsprite = FALSE
	force = 15
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

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Crossbows increase in accuracy with a higher <b>PERCEPTION</b>, but deal a static amount of damage \
	regardless of character stats.")
	. += span_info("Crossbows cannot be nocked directly from their quiver and require time to load.")
	if(onehanded)
		. += span_info("This weapon can be used in one hand, at the penalty of aim time.")
		if(HAS_TRAIT(user, TRAIT_DUALWIELDER))
			. += span_info("You can fire two of this weapon at the same time. You shoot the second at half its accuracy factor.")

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
	if(mastermob && masteritem)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/c_bow = masteritem
		if(mastermob.get_num_arms(FALSE) < 2 && !c_bow.onehanded || mastermob.get_inactive_held_item() && !c_bow.onehanded)
			to_chat(mastermob, span_warning("I need a free hand to draw [masteritem]!"))
			return FALSE
	if(istype(clicked_object, /obj/item/quiver) && istype(mastermob?.get_active_held_item(), /obj/item/gun/ballistic))
		return FALSE

	return TRUE

/datum/intent/shoot/crossbow/get_chargetime()
	if(mastermob && chargetime && masteritem)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/c_bow = masteritem
		var/newtime = chargetime
		//skill block
		newtime += basetime
		newtime -= (mastermob.get_skill_level(/datum/skill/combat/crossbows) * 4.25) // minus 4.25 per skill point
		newtime -= ((mastermob.STAPER)) // minus 1 per perception

		if(c_bow.onehanded)
			if(mastermob.get_num_arms(FALSE) < 2 || mastermob.get_inactive_held_item())
				newtime *= 1.5 // more time if firing one-handed.
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
	if(mastermob && masteritem)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/c_bow = masteritem
		if(mastermob.get_num_arms(FALSE) < 2 && !c_bow.onehanded || mastermob.get_inactive_held_item() && !c_bow.onehanded)
			to_chat(mastermob, span_warning("I need a free hand to draw [masteritem]!"))
			return FALSE
	if(istype(clicked_object, /obj/item/quiver) && istype(mastermob?.get_active_held_item(), /obj/item/gun/ballistic))
		return FALSE

	return TRUE

/datum/intent/arc/crossbow/get_chargetime()
	if(mastermob && chargetime && masteritem)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/c_bow = masteritem
		var/newtime = chargetime
		//skill block
		newtime += basetime
		newtime -= (mastermob.get_skill_level(/datum/skill/combat/crossbows) * 20)
		//per block
		newtime += 20
		newtime -= ((mastermob.STAPER)*1.5)

		if(c_bow.onehanded)
			if(mastermob.get_num_arms(FALSE) < 2 || mastermob.get_inactive_held_item())
				newtime *= 2 // more time if firing one-handed.

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
				if(do_after(user, reloadtime - user.STASTR - user.get_skill_level(/datum/skill/combat/crossbows), target = user ))
					playsound(user, 'sound/combat/Ranged/crossbow_medium_reload-01.ogg', 100, FALSE) //11 STR + MASTER Crossbow = 2.5~ second reload not including TIDI
					cocked = TRUE //13 STR + NO Crossbow still amounts to around 3 seconds reload, so as it is each level of skill is +1 STR equivalent.
			else
				if(move_after(user, reloadtime - user.STASTR, target = user)) //Slurbow becomes instant loading if it uses skills at 11 STR + MASTER Crossbow
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


/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/process_fire(
	atom/target,
	mob/living/user,
	message = TRUE,
	params = null,
	zone_override = "",
	bonus_spread = 0
)
	// Two-handed restriction
	if(user.get_num_arms(FALSE) < 2 && !onehanded)
		return FALSE
	if(user.get_inactive_held_item() && !onehanded)
		return FALSE

	// Spread calculation
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0

	// Projectile stat modification
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		if(!BB)
			continue

		BB.accuracy += accfactor * (user.STAPER - 8) * 3 // 8+ PER gives +3 per level. Exponential.
		BB.bonus_accuracy += (user.STAPER - 8) // 8+ PER gives +1 per level. Does not decrease over range.
		BB.bonus_accuracy += (user.get_skill_level(/datum/skill/combat/crossbows) * 5) // +5 per XBow level.'
		BB.armor_penetration *= penfactor
		BB.damage *= damfactor

	cocked = FALSE

	. = ..()
	if(!.)
		return
	if(!onehanded)
		return

	// Safe dual-wield handling
	var/obj/item/other_hand = user.get_inactive_held_item()
	if(!istype(other_hand, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow))
		return

	var/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/alt_cbow = other_hand
	if(!alt_cbow.onehanded)
		return
	if(!alt_cbow.chambered)
		return
	if(!HAS_TRAIT(user, TRAIT_DUALWIELDER))
		return

	// Fire off-hand crossbow at reduced accuracy
	alt_cbow.accfactor /= 2
	alt_cbow.process_fire(target, user, FALSE)
	alt_cbow.accfactor = initial(alt_cbow.accfactor)


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

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/aalloy
	name = "ancient crossbow"
	desc = "A deadly weapon from another tyme, which shoots a bolt with terrific power. Unlike the common bow, it uses a sophisticated mechanism to renock - and retain - its half-length bolts; a matter that relies more on raw strength than dexterity to master. </br>Once, these mechanical delights bristled the arms of Zaelorian's ancient empire; now, it shudders in the grasp of Zizo's deathless crusade."
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "ancientcrossbow0"
	item_state = "ancientcrossbow"
	max_integrity = 80

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/light
	name = "stockless crossbow"
	desc = "A deadly weapon that shoots a bolt with terrific power. The stock has been whittled down into a 'cabbit's foot'-styled grip; fletchable on the move without compromising the lethality of its bolts. Without a stock to bolster one's draw-strength, however, it means preparing each shot is more laborious than the last. </br>Rockhill's wytch-hunting folk heroes were oft-mythed to wield two of these at once."
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "crossbowshort0"
	item_state = "crossbowshort"
	possible_item_intents = list(/datum/intent/shoot/crossbow/slurbow, /datum/intent/arc/crossbow/slurbow, /datum/intent/buttstroke)
	chargingspeed = 30
	accfactor = 0.75
	penfactor = 0.75 //Full damage, but reduce armor-penetration. Rough sidegrade  
	reloadtime = 60 //Less leverage to work with, but not as difficult as larger weapons.
	force = 13
	movingreload = TRUE
	onehanded = TRUE
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_SMALL //Theoretically stowable in a belt or satchel, unlike the larger variants.
	grid_height = 96
	grid_width = 64

/datum/intent/buttstroke
	name = "buttstroke"
	blade_class = BCLASS_BLUNT
	attack_verb = list("strikes", "buttstrokes")
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	damfactor = 1.1 //Translates into 11 DMG for a Slurbow, 16.5 DMG for a Crossbow, and 23 DMG for a Siegebow.
	swingdelay = 0
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR - 50 //Reduces integrity damage modifier to +10%.

//

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	name = "slurbow"
	desc = "A lighter weight crossbow with a distinct barrel shroud holding the bolt in place. While its reduced draw-weight does hamper the power of its bolts, it's consequently much easier to rearm and aim than the common crossbow; doubly-so, while on the move. </br>They're popular among among highwaymen and the patrolling lamplighters of Otava."
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "slurbow0"
	item_state = "slurbow"
	possible_item_intents = list(/datum/intent/shoot/crossbow/slurbow, /datum/intent/arc/crossbow/slurbow, /datum/intent/buttstroke)
	chargingspeed = 20
	damfactor = 0.6
	accfactor = 1.3
	reloadtime = 20
	force = 10
	hasloadedsprite = TRUE
	movingreload = TRUE
	onehanded = TRUE
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_HIP
	penfactor = 0.5		//Bolts have 50 pen, this decreases to 25. Should only pen armor with less than 67 protection.
	wdefense = 2
	max_integrity = 80

//

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy
	name = "siegebow"
	desc = "A heavier weight crossbow - the basis of a mounted ballista, made fit for handheld usage. Integrated just beneath the stock is a windlass mechanism, necessary to surmount the siegebow's titanic draw-strength. It loads heavier, full-length bolts; purpose-made to pulverize. </br>Assembled in Grenzelhoft, championed by Valoria, and unfamiliar to the highlands of Azure Peak."
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "heavybow0"
	item_state = "heavybow"
	possible_item_intents = list(/datum/intent/shoot/crossbow/heavy, /datum/intent/arc/crossbow/heavy, /datum/intent/buttstroke/heavy, /datum/intent/effect/daze) //Remember, this is quite heavy.
	load_sound = 'sound/foley/doors/lockmetal.ogg'
	fire_sound = 'sound/combat/Ranged/crossbow_big_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/shot/heavy_xbow
	minstr = 12 //Should only affect melee damage. Sells the impression that you're hauling some serious artillery around.
	force = 20
	wdefense = 4
	max_integrity = 150
	chargingspeed = 60 //+20, or a little over +50% the standard charging speed.
	reloadtime = 160 //Roughly sixteen seconds, or +200% the standard reloading speed.
	accfactor = 0.5 //Hey, I'd like to see you try to aim a siege weapon while standing up!
	equip_delay_self = 3 SECONDS
	unequip_delay_self = 3 SECONDS
	inv_storage_delay = 2 SECONDS

/obj/item/ammo_box/magazine/internal/shot/heavy_xbow
	ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt
	caliber = "heabolt"
	max_ammo = 1
	start_empty = TRUE

/datum/intent/shoot/crossbow/heavy
	basetime = 60
	chargetime = 1
	chargedrain = 1 //Takes 50% longer to properly aim and fire. Imparts a stamina drain and audio cue, too.
	charging_slowdown = 2 //Slows down movement, on par with a dedicated longbow. You can probably guess why.

/datum/intent/arc/crossbow/heavy
	basetime = 60
	chargetime = 1.5
	chargedrain = 1 //Ditto.
	charging_slowdown = 2.5 //Little more than before, with the assumption that you're taking your time for a more precise shot.

/datum/intent/shoot/crossbow/heavy/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] readies [masteritem]!"))
		playsound(mastermob, pick('sound/combat/Ranged/crossbow_medium_reload-02.ogg'), 100, FALSE)

/datum/intent/arc/crossbow/heavy/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] readies [masteritem] for a precise shot!"))
		playsound(mastermob, pick('sound/combat/Ranged/crossbow_medium_reload-02.ogg'), 100, FALSE)

/datum/intent/buttstroke/heavy
	name = "heavy buttstroke"
	damfactor = 1.15
	swingdelay = 6
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR - 45 //Reduces integrity damage modifier to +15%.

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/paalloy
	name = "ancient siegebow"
	desc = "A heavier weight crossbow from another tyme - the basis of a mounted ballista, made fit for handheld usage. Integrated just beneath the stock is a windlass mechanism, necessary to surmount the siegebow's titanic draw-strength. It loads heavier, full-length bolts; purpose-made to pulverize. </br>'Rudmarsch's walls broke beneath the volley, and Her sickness petered through the cracks..'"
	icon_state = "ancientheavybow0"
	item_state = "ancientheavybow"
	max_integrity = 130

//
