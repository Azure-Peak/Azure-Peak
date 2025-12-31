//intents

/datum/intent/swing/sling
	chargetime = 1 //used for edge cases only, /datum/intent/shoot/sling/get_chargetime handles the actual number
	chargedrain = 2
	charging_slowdown = 3

/datum/intent/swing/sling/can_charge(atom/clicked_object) //checks for arms and spare empty hand removed since it can fire with one hand
	if(mastermob)
		if(istype(clicked_object, /obj/item/quiver) && istype(mastermob.get_active_held_item(), /obj/item/gun/ballistic))
			return FALSE
	return TRUE

/datum/intent/swing/sling/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] swings [masteritem]!"))
		playsound(mastermob, pick('sound/combat/Ranged/sling-draw-01.ogg'), 100, FALSE)

/datum/intent/swing/sling/get_chargetime() //determines swing length. damage is in /obj/item/gun/ballistic/revolver/grenadelauncher/sling/process_fire
	if(mastermob && chargetime)
		var/newtime = 0 //value to determine charging time in deciseconds
		newtime = (newtime + 20) //base 2.0 seconds
		newtime = (newtime - (mastermob.get_skill_level(/datum/skill/combat/slings) * 1.5)) //each point of skill is -0.15 seconds, maximum -0.9 seconds
		newtime = (newtime - (mastermob.STAPER / 2)) //each point of perception is -0.05 seconds, maximum -1.0 second
		newtime = (newtime - (mastermob.STASTR / 5)) //each point of strength is -0.02 seconds, maximum -0.4 seconds
		if(newtime > 0.5)
			return newtime //final time to 'charge' the sling. for example, 10 STR, 14 PER, and expert skill equals 5 or 0.5 seconds
		else
			return 0.5 //the minimum time to charge. used since a mixture of different factors is to be expected. very difficult to surpass
	else
		return chargetime //failsafe default value should the above conditions not be met

/datum/intent/arc/sling
	chargetime = 1
	chargedrain = 2
	charging_slowdown = 3

/datum/intent/arc/sling/can_charge(atom/clicked_object) //checks for arms and spare empty hand removed since it can fire with one hand
	if(mastermob)
		if(istype(clicked_object, /obj/item/quiver) && istype(mastermob.get_active_held_item(), /obj/item/gun/ballistic))
			return FALSE
	return TRUE

/datum/intent/arc/sling/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] swings [masteritem] in an arc!"))
		playsound(mastermob, pick('sound/combat/Ranged/sling-draw-01.ogg'), 100, FALSE)

/datum/intent/arc/sling/get_chargetime() //same calculations as swing but with a greater base for throwing through teammates
	if(mastermob && chargetime)
		var/newtime = 0 //value to determine charging time in deciseconds
		newtime = (newtime + 22) //base 2.2 seconds
		newtime = (newtime - (mastermob.get_skill_level(/datum/skill/combat/slings) * 1.5)) //each point of skill is -0.15 seconds, maximum -0.9 seconds
		newtime = (newtime - (mastermob.STAPER / 2)) //each point of perception is -0.05 seconds, maximum -1.0 second
		newtime = (newtime - (mastermob.STASTR / 5)) //each point of strength is -0.02 seconds, maximum -0.4 seconds
		if(newtime > 0.5)
			return newtime //final time to 'charge' the sling. for example, 10 STR, 14 PER, and expert skill equals 0.7 seconds
		else
			return 0.5 //the minimum time to charge. used since a mixture of different factors is to be expected. very difficult to surpass
	else
		return chargetime //failsafe default value should the above conditions not be met

//objs

/obj/item/gun/ballistic/revolver/grenadelauncher/sling
	name = "sling"
	desc = "Twisted fibers manifest into a strung pouch capable of hurling stones afar."
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "sling"
	item_state = "sling"
	experimental_onhip = TRUE
	experimental_onback = TRUE
	possible_item_intents = list(
		/datum/intent/swing/sling,
		/datum/intent/arc/sling,
		INTENT_GENERIC,
		)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/sling
	fire_sound = 'sound/combat/Ranged/sling-shot-01.ogg'
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	randomspread = 0
	spread = 0
	can_parry = TRUE
	force = 10 //i guess if someone wanted to wrap this around their hand and punch they could?
	verbage = "load"
	cartridge_wording = "stone"
	load_sound = 'sound/foley/slingload.ogg'
	obj_flags = UNIQUE_RENAME
	grid_width = 32
	grid_height = 64
	var/atom/movable/temp_stone = null //stones are not ammo so they aren't acceptable by ballistics. this var will keep the stone temporarily stored
	var/bonus_stone_force = 0 //above comment is relevant. a magical stone's bonus force is kept on the sling itself and changed accordingly

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/get_mechanics_examine(mob/user)
	. += span_info("Slings increase in damage and accuracy the higher your <b>PERCEPTION</b> and <b>STRENGTH</b>.")
	. += span_info("Slings can be loaded directly from a pouch while your offhand is occupied by another item.")

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.5,
					"sx" = -3,
					"sy" = -5,
					"nx" = 6,
					"ny" = -5,
					"wx" = -1,
					"wy" = -5,
					"ex" = -2,
					"ey" = -5,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					)
			if("onbelt")
				return list(
					"shrink" = 0.4,
					"sx" = 0,
					"sy" = -3,
					"nx" = 4,
					"ny" = -5,
					"wx" = -3,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,
					)

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/shoot_with_empty_chamber()
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing) || istype(A, /obj/item/natural/stone))
		if(temp_stone == null && istype(A, /obj/item/natural/stone)) //code of the damned. this must be done since regular stone objects cannot be loaded into the magazine and I did not want to change stones to be an ammo type
			bonus_stone_force = A.force - 10 //base stone force is 10. regular stone will yield 0 additional damage
			temp_stone = A //storing the stone incase it needs to be ejected
			user.transferItemToLoc(A, temp_stone) //off to stone purgatory you go
			A = new /obj/item/ammo_casing/caseless/rogue/sling_bullet //putting a temporary sling bullet in its place. bonus force is kept on the sling and set to 0 if shot or stone is ejected
		..()
		
/obj/item/gun/ballistic/revolver/grenadelauncher/sling/attack_self(mob/user) //more unholy code
	if (temp_stone != null) //if there's a 'stone' in the sling, drop it and delete the temporary ammo inside
		user.dropItemToGround(temp_stone) //pulling the stone from stone purgatory and dropping it
		temp_stone = null //clearing the temp reference var
		bonus_stone_force = 0 //the sling no longer has a stone so bonus magical stone damage is set to 0
		for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
			qdel(CB) //taking the temporary bullet out
		icon_state = "sling" //manually making it look empty
	..()

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		BB.embedchance = 0.1 //for some reason, if the embedchance is 0, the reusable projectile will not drop after hitting a mob. so it's a 1/1000 chance now
		BB.accuracy += accfactor * (user.STAPER - 8) * 3 // 8+ PER gives +3 per level. Exponential.
		BB.bonus_accuracy += (user.STAPER - 8) // 8+ PER gives +1 per level. Does not decrease over range.
		BB.bonus_accuracy += (user.get_skill_level(/datum/skill/combat/slings) * 5) // +5 per Sling level.
		BB.damage *= damfactor
		if(user.client.chargedprog < 100)
			BB.damage = BB.damage - (BB.damage * (user.client.chargedprog / 100))
		else
			BB.damage = BB.damage
		BB.damage = BB.damage * (((user.STAPER / 1.25) + (user.STASTR / 5)) / 10) * damfactor + bonus_stone_force
		// each point of perception is 8% damage. each point of strength is 2% damage. 100% damage at 10 in both. the stone's bonus force is added as a flat amount
		if (temp_stone != null) //reseting after stone ammo use
			bonus_stone_force = 0 //stone is thrown, so the bonus is lost
			temp_stone = null //stone is gone, forever.
	. = ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/update_icon()
	. = ..()
	cut_overlays()
	if(chambered)
		icon_state = "[initial(icon_state)]_ready"
		var/mutable_appearance/ammo = mutable_appearance('icons/roguetown/weapons/ammo.dmi', chambered.icon_state)
		add_overlay(ammo)
	if(!ismob(loc))
		return
	var/mob/M = loc
	M.update_inv_hands()

/obj/item/ammo_box/magazine/internal/shot/sling
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet
	caliber = "slingbullet"
	max_ammo = 1
	start_empty = TRUE
