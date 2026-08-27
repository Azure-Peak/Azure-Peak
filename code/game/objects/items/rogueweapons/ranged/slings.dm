//intents

/proc/sling_draw_sound(chargetime)
	switch(chargetime)
		if(0 to 11)
			return 'sound/combat/Ranged/sling-draw-01.ogg'
		else
			return 'sound/combat/Ranged/sling-draw-01-14ds.ogg'

/datum/intent/swing/sling
	chargetime = 1 //used for edge cases only, the sling's get_draw_time() handles the actual number
	chargedrain = SLING_CHARGEDRAIN
	charging_slowdown = 3
	needs_loaded_launcher = TRUE

/datum/intent/swing/sling/can_charge(atom/clicked_object)
	if(istype(clicked_object, /obj/item/quiver) && istype(mastermob?.get_active_held_item(), /obj/item/gun/ballistic))
		return FALSE
	if(needs_loaded_launcher && !launcher_is_loaded())
		to_chat(mastermob, span_warning("I have nothing loaded!"))
		return FALSE

	return TRUE

/datum/intent/swing/sling/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] swings [masteritem]!"))
		playsound(mastermob, sling_draw_sound(get_chargetime()), 100, FALSE, channel = CHANNEL_WEAPON_DRAW)

/datum/intent/swing/sling/get_chargetime() //swing length lives on the sling itself so players and NPCs share one curve. damage is in /obj/item/gun/ballistic/revolver/grenadelauncher/sling/process_fire
	if(mastermob && chargetime)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/sling/sling = masteritem
		if(istype(sling))
			var/newtime = sling.get_draw_time(mastermob, FALSE)
			if(newtime)
				return newtime
	return chargetime //failsafe default value should the above conditions not be met

/datum/intent/arc/sling
	chargetime = 1
	chargedrain = SLING_CHARGEDRAIN
	charging_slowdown = 3
	ready_sound = 'sound/foley/slingload.ogg'

/datum/intent/arc/sling/can_charge(atom/clicked_object)
	if(istype(clicked_object, /obj/item/quiver) && istype(mastermob?.get_active_held_item(), /obj/item/gun/ballistic))
		return FALSE
	if(needs_loaded_launcher && !launcher_is_loaded())
		to_chat(mastermob, span_warning("I have nothing loaded!"))
		return FALSE

	return TRUE

/datum/intent/arc/sling/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] swings [masteritem] in an arc!"))
		playsound(mastermob, sling_draw_sound(get_chargetime()), 100, FALSE, channel = CHANNEL_WEAPON_DRAW)

/datum/intent/arc/sling/get_chargetime() //same curve as swing but slower, for throwing through teammates
	if(mastermob && chargetime)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/sling/sling = masteritem
		if(istype(sling))
			var/newtime = sling.get_draw_time(mastermob, TRUE)
			if(newtime)
				return newtime
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
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BELT | ITEM_SLOT_WRISTS
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
	ranged_skill = /datum/skill/combat/slings
	per_scales_damage = TRUE
	release_drain = SLING_RELEASEDRAIN
	draw_base = SLING_DRAW_BASE
	draw_floor = SLING_DRAW_FLOOR
	uses_draw_curve = TRUE
	var/atom/movable/temp_stone = null //stones are not ammo so they aren't acceptable by ballistics. this var will keep the stone temporarily stored
	var/bonus_stone_force = 0 //above comment is relevant. a magical stone's bonus force is kept on the sling itself and changed accordingly

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("My <b>SLINGS</b> skill defines how precise my shots are and how fast I can swing.")
	. += span_info("Slings increase in damage the higher your <b>PERCEPTION</b>.")
	. += span_info("When I shoot a target too close or too far away, I will only hit the chest.")
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
	spread = get_ranged_spread(user)
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		BB.embedchance = 0.1 //for some reason, if the embedchance is 0, the reusable projectile will not drop after hitting a mob. so it's a 1/1000 chance now
		apply_ranged_accuracy(BB, user)
		BB.damage *= damfactor
		apply_early_release_penalty(BB, user)
		BB.damage = BB.damage * get_per_damage_scaling(user) + bonus_stone_force
		if (temp_stone != null) //reseting after stone ammo use
			bonus_stone_force = 0 //stone is thrown, so the bonus is lost
			temp_stone = null //stone is gone, forever.
	. = ..()
	if(.)
		pay_release_drain(user)

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/update_icon()
	. = ..()
	cut_overlays()
	if(chambered)
		icon_state = "[initial(icon_state)]_ready"
		var/mutable_appearance/ammo = mutable_appearance(chambered.icon, chambered.icon_state)
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

// RESKINS GO BELOW. THIS IS MOSTLY FOR FLAVOR/SOVL. P L E A S E DON'T MAKE THIS ANY DIFFERENT FROM YOUR NORMAL SLING, THANK YOU.

/datum/intent/swing/sling/wood/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] draws [masteritem]!"))
		playsound(mastermob, 'sound/combat/Ranged/bow-draw-01.ogg', 100, FALSE)

/datum/intent/arc/sling/wood/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] draws [masteritem] in an arc!"))
		playsound(mastermob, 'sound/combat/Ranged/bow-draw-01.ogg', 100, FALSE)

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/wood/update_icon()
	. = ..()

	cut_overlays()

	if(chambered)
		icon_state = "[initial(icon_state)]_ready"
	else
		icon_state = initial(icon_state)

	if(!ismob(loc))
		return

	var/mob/M = loc
	M.update_inv_hands()

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/wood // sling reskin that uses bow draw noise instead of swing overhead
	name = "slingshot"
	desc = "A forked branch fitted with braided cords and a leather cup. Favored by farmhands and village youths alike, it casts stones by drawing the cords taut and releasing them with a sharp snap. Crude in appearance, yet surprisingly effective in practiced hands."
	icon_state = "altsling"
	item_state = "altsling"
	possible_item_intents = list(/datum/intent/swing/sling/wood, /datum/intent/arc/sling/wood, INTENT_GENERIC)
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BELT | ITEM_SLOT_NECK | ITEM_SLOT_BACK

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/bog/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("This sling uses a forked frame instead of overhead rotation, allowing stones to be launched by drawing the cords back and releasing. This is just fluff, it behaves exactly as a sling should.")

/obj/item/gun/ballistic/revolver/grenadelauncher/sling/wood/bog // aura farming
	name = "bogbark slingshot"
	desc = "A slingshot carved from bogbark wood, its dark frame warped by years spent drinking from the Terrorbog's foul waters. Old dents, scrapes, and dark stains mark its limbs. The weapon is said to have felled more than a few trolls before being recovered from the pulverized remains of a Levy deep within the mire. Whether the stories are true or not, the wood feels unnaturally sturdy in the hand."
	aura_color = "#00ff00"
