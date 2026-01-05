/obj/item/flashlight
	name = "flashlight"
	desc = ""
	custom_price = 10
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = null
	light_system = MOVABLE_LIGHT
	light_outer_range = 4
	light_power = 1
	slot_flags = ITEM_SLOT_BELT
	var/weather_resistant = FALSE
	possible_item_intents = list(INTENT_GENERIC)
	var/on = FALSE

/obj/item/flashlight/Initialize()
	. = ..()
	if(icon_state == "[initial(icon_state)]-on")
		on = TRUE
	update_brightness()

/obj/item/flashlight/proc/update_brightness(mob/user = null)
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = initial(icon_state)
	set_light_on(on)

/obj/item/flashlight/attack_self(mob/user)
	on = !on
	update_brightness(user)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()
	return 1

/obj/item/flashlight/suicide_act(mob/living/carbon/human/user)
	if (user.eye_blind)
		user.visible_message("<span class='suicide'>[user] is putting [src] close to [user.p_their()] eyes and turning it on... but [user.p_theyre()] blind!</span>")
		return SHAME
	user.visible_message("<span class='suicide'>[user] is putting [src] close to [user.p_their()] eyes and turning it on! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (FIRELOSS)

/obj/item/flashlight/attack(mob/living/carbon/M, mob/living/carbon/human/user)
	add_fingerprint(user)
	return ..()

// FLARES

/obj/item/flashlight/flare
	name = "flare"
	desc = ""
	w_class = WEIGHT_CLASS_SMALL
	light_outer_range = 7 // Pretty bright.
	icon_state = "flare"
	item_state = "flare"
	actions_types = list()
	heat = 1000
	light_color = LIGHT_COLOR_FLARE
	grind_results = list(/datum/reagent/sulfur = 15)

	var/fuel = 12000
	var/on_damage = 7
	var/produce_heat = 1500
	var/times_used = 0

/obj/item/flashlight/flare/process()
	open_flame(heat)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/ignition_effect(atom/A, mob/user)
	if(fuel && on)
		. = "<span class='notice'>[user] lights [A] with [src] like a real \
			badass.</span>"
	else
		. = ""

/obj/item/flashlight/flare/proc/turn_off()
	on = FALSE
	force = initial(src.force)
	damtype = initial(src.damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

/obj/item/flashlight/flare/update_brightness(mob/user = null)
	..()
	if(on)
		item_state = "[initial(item_state)]-on"
	else
		item_state = "[initial(item_state)]"

/obj/item/flashlight/flare/attack_self(mob/user)

	// Usual checks
	if(!fuel)
		to_chat(user, "<span class='warning'>[src] is out of fuel!</span>")
		return
	if(on)
		to_chat(user, "<span class='warning'>[src] is already on!</span>")
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message("<span class='notice'>[user] lights \the [src].</span>", "<span class='notice'>I light \the [src]!</span>")
		force = on_damage
//		damtype = "fire"
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/get_temperature()
	return on * heat

/obj/item/flashlight/flare/torch
	name = "torch"
	desc = "A stick with enough fiber wrapped around the end to burn for a decent amount of time. Mind it \
	should you choose to ford across water."
	w_class = WEIGHT_CLASS_NORMAL
	light_outer_range = 7
	force = 5
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "torch"
	item_state = "torch"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	light_color = "#f5a885"
	on_damage = 10
	flags_1 = null
	possible_item_intents = list(/datum/intent/use, /datum/intent/hit)
	slot_flags = ITEM_SLOT_HIP
	//remove the = null to re-add the torch crackle sounds. (???? what the fuck)
	var/datum/looping_sound/torchloop/soundloop = null
	//added for torch burnout
	var/should_self_destruct = TRUE
	max_integrity = 50
	fuel = 30 MINUTES
	light_depth = 0
	light_height = 0
	grid_width = 32
	grid_height = 32

/obj/item/flashlight/flare/torch/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -8,"sy" = 4,"nx" = 10,"ny" = 4,"wx" = -7,"wy" = 3,"ex" = 2,"ey" = 6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 2,"sturn" = 2,"wturn" = -2,"eturn" = -2,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/flashlight/flare/torch/Initialize()
	GLOB.weather_act_upon_list += src
	. = ..()
	if(soundloop)
		soundloop = new(src, FALSE)

/obj/item/flashlight/flare/torch/Destroy()
	GLOB.weather_act_upon_list -= src
	. = ..()

/obj/item/flashlight/flare/torch/process()
	open_flame(heat)
	if(!fuel || !on)
		turn_off()
		STOP_PROCESSING(SSobj, src)
		if(!fuel)
			icon_state = "torch-empty"
		return
	if(!istype(loc,/obj/machinery/light/rogue/torchholder))
		if(!ismob(loc))
			if(prob(23))
				turn_off()
				STOP_PROCESSING(SSobj, src)
				return
		else
			var/mob/M = loc
			if(!(src in M.held_items))
				if(prob(23))
					turn_off()
					STOP_PROCESSING(SSobj, src)
					return
		fuel = max(fuel - 10, 0)

/obj/item/flashlight/flare/torch/attack_self(mob/user)

	// Usual checks
	if(!fuel)
		to_chat(user, "<span class='warning'>[src] doesn't have any pitch left!</span>")
		return
	if(on)
		turn_off()

/obj/item/flashlight/flare/torch/extinguish()
	if(on)
		turn_off()

/obj/item/flashlight/flare/torch/weather_act_on(weather_trait, severity)
	if(weather_trait != PARTICLEWEATHER_RAIN)
		return
	if(weather_resistant)
		return
	extinguish()

/obj/item/flashlight/flare/torch/turn_off()
	playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
	if(soundloop)
		soundloop.stop()
	STOP_PROCESSING(SSobj, src)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
		M.update_inv_belt()
	damtype = BRUTE

/obj/item/flashlight/flare/torch/fire_act(added, maxstacks)
	if(fuel)
		if(!on)
			playsound(src.loc, 'sound/items/firelight.ogg', 100)
			on = TRUE
			damtype = BURN
			update_brightness()
			force = on_damage
			if(soundloop)
				soundloop.start()
			if(ismob(loc))
				var/mob/M = loc
				M.update_inv_hands()
			START_PROCESSING(SSobj, src)
			return TRUE
	return ..()

/obj/item/flashlight/flare/torch/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if (!proximity)
		return
	if (on && (prob(50) || (user.used_intent.type == /datum/intent/use)))
		if (ismob(A))
			A.spark_act()
		else
			A.fire_act(3,3)

		if (should_self_destruct)  // check if self-destruct
			times_used += 1
			if (times_used >= 8) //amount used before burning out
				user.visible_message("<span class='warning'>[src] has burnt out and falls apart!</span>")
				qdel(src)

/obj/item/flashlight/flare/torch/spark_act()
	fire_act()

/obj/item/flashlight/flare/torch/get_temperature()
	if(on)
		return FIRE_MINIMUM_TEMPERATURE_TO_SPREAD
	return ..()

/obj/item/flashlight/flare/torch/prelit/Initialize() //Prelit version, testing to see if it causes less issues with pre_equip dropping stuff in your hands
	. = ..()
	spark_act()

/obj/item/flashlight/flare/torch/metal
	name = "fieftorch"
	desc = "A candleholder of wrought iron, oft-found mounted to the sconces in a castle's hallway."
	icon_state = "mtorch"
	light_outer_range = 6
	force = 10 //Doubled from the regular torch, to reflect its sturdier construction. Classified as an improvised weapon, as it shouldn't scale off any weapon skill.
	on_damage = 15
	wdefense = 1 //Metal rod. Offers a pittance-of-a-chance to parry an incoming strike.
	smeltresult = /obj/item/rogueore/coal
	max_integrity = 100	
	fuel = 120 MINUTES
	should_self_destruct = FALSE
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike) //Reflects the fact that it is, in essence, a heavy rod of iron. 
	extinguishable = FALSE
	weather_resistant = TRUE

/obj/item/flashlight/flare/torch/metal/prelit/Initialize() //Prelit version
	. = ..()
	spark_act()

/obj/item/flashlight/flare/torch/lantern
	name = "iron lamptern"
	icon_state = "lamp"
	desc = "A light to guide the way."
	light_outer_range = 5
	on = FALSE
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_HIP
	obj_flags = CAN_BE_HIT
	force = 1
	on_damage = 5
	fuel = 120 MINUTES
	should_self_destruct = FALSE
	grid_width = 32
	grid_height = 64
	extinguishable = FALSE
	weather_resistant = TRUE

/obj/item/flashlight/flare/torch/lantern/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(on && (prob(50) || (user.used_intent.type == /datum/intent/use)))
		if(ismob(A))
			A.spark_act()
		else
			A.fire_act(3,3)

/obj/item/flashlight/flare/torch/lantern/process()
	open_flame(heat)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/torch/lantern/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -2,"sy" = -4,"nx" = 9,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 2,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/flashlight/flare/torch/lantern/prelit/Initialize() //Prelit version
	. = ..()
	spark_act()

/obj/item/flashlight/flare/torch/lantern/bronzelamptern
	name = "bronze lamptern"
	icon_state = "bronzelamp"
	item_state = "bronzelamp"
	desc = "A marvel of engineering that emits a strange green glow."
	light_outer_range = 6
	light_color ="#4ac77e"
	on = FALSE

/obj/item/flashlight/flare/torch/lantern/bronzelamptern/malums_lamptern //unqiue item as a dungeon reward. Functionally a kite shield and a bronze lamptern combined into one
	name = "ancient lamptern"
	icon_state = "bronzelamp"
	item_state = "bronzelamp"
	desc = "A marvel of enginseering that emits a strange teal glow. This one bears an emblem related to Malum and has an inscription. It reads, 'Wield me against your foe and the power of creation shall shield you from harm.'"
	light_outer_range = 8
	light_color = "#2bd0d6"
	color = "#2bd0d6"
	on = TRUE
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	wlength = WLENGTH_NORMAL
	wdefense = 11
	var/coverage = 90
	possible_item_intents = list(INTENT_GENERIC, /datum/intent/shield/bash, /datum/intent/shield/block)
	sharpness = IS_BLUNT
	can_parry = TRUE
	associated_skill = /datum/skill/combat/shields
	max_integrity = 300
	obj_integrity = null
	integrity_failure = 0.2
	obj_broken = null
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	anvilrepair = /datum/skill/craft/engineering
	required_repair_skill = 6 // Only the most skilled engineers can repair it
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/magicshield (1).ogg','sound/combat/parry/shield/magicshield (2).ogg','sound/combat/parry/shield/magicshield (3).ogg')
	break_sound = 'sound/foley/machinebreak.ogg'
	blade_dulling = DULLING_BASH
	sellprice = 500 // who sells a holy relic?
	resistance_flags = FIRE_PROOF

/obj/item/flashlight/flare/torch/lantern/bronzelamptern/malums_lamptern/pickup(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_CABAL))
		to_chat(user, "<font color='yellow'> You attempt to take the lamptern. Runic flames of creation lap up the length of your arm in defiance of your Dark Mistress! Curses!</font>")
		user.adjust_fire_stacks(5)
		user.ignite_mob()
		user.Stun(40)
		playsound(get_turf(user), 'sound/magic/ahh2.ogg', 100)
	..()

/obj/item/flashlight/flare/torch/lantern/copper
	name = "copper lamptern"
	icon_state = "clamp"
	desc = "A simple and cheap lamptern."
	on = FALSE
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_HIP
	force = 1
	on_damage = 5
	fuel = 120 MINUTES
	should_self_destruct = FALSE

/obj/item/flashlight/flare/torch/lantern/copper/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -2,"sy" = -4,"nx" = 9,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 2,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/flashlight/flare/torch/lantern/pumpkin
	name = "pumpkin lamptern"
	desc = "A decorated pumpkin shell. Usually seasonal, a frightful beacon in the night."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	icon_state = "pumpkinlamp"
	item_state = "pumpkinlamp"
	grid_width = 64
	grid_height = 32
	w_class = WEIGHT_CLASS_SMALL
	light_color = "#ffb272ff"
	on = FALSE

	slot_flags = ITEM_SLOT_HEAD
	flags_inv = HIDEFACE|HIDEEARS|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	body_parts_covered = FULL_HEAD|NECK
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	equip_delay_self = 3 SECONDS
	unequip_delay_self = 3 SECONDS

	force = 1
	on_damage = 3
	wdefense = 1 //The pumpkin has a chance of getting in the way of strikes.
	fuel = 0 MINUTES
	should_self_destruct = FALSE
	sellprice = 8 //Allows a minor business to bloom from them. This may require adjustments.

/obj/item/flashlight/flare/torch/lantern/pumpkin/examine(mob/user)
	. = ..()
	if(fuel <= 0)
		. += span_smallnotice("It looks like it could use a new candle.")

/obj/item/flashlight/flare/torch/lantern/pumpkin/update_brightness(mob/user)
	. = ..()
	item_state = icon_state
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			user.update_inv_head()

/obj/item/flashlight/flare/torch/lantern/pumpkin/attackby(obj/item/I, mob/living/user, params)
	if((istype(I, /obj/item/candle/yellow)) && (fuel <= 0))
		user.visible_message(span_notice("[user] inserts a candle into [src]."), \
							span_notice("I insert a candle into [src]."))
		if(do_after(user, 2 SECONDS))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 60, TRUE, -1)
			fuel += 120 MINUTES
			var/obj/item/candle/yellow/C = I
			if(C.lit == TRUE)
				on = TRUE
				update_brightness(user)
			qdel(I)
	return ..()

/obj/item/flashlight/flare/torch/lantern/pumpkin/psy
	name = "psy-do-lamptern"
	desc = "A large and decorated pumpkin shell. Usually seasonal, yet it ENDURES."
	icon_state = "pumpkinlamppsy"
	item_state = "pumpkinlamppsy"

/obj/item/flashlight/flare/torch/lantern/pumpkin/ten
	name = "tennite pumpkin lamptern"
	desc = "A large and decorated pumpkin shell. It looks like a lot of work to make it stay in one piece."
	icon_state = "pumpkinlampten"
	item_state = "pumpkinlampten"

/obj/item/flashlight/flare/torch/lantern/pumpkin/zizo
	name = "zumpkin lamptern"
	desc = "A large and decorated pumpkin shell. Its strangely gloomy."
	icon_state = "pumpkinlampz"
	item_state = "pumpkinlampz"
	light_color = "#ceff72ff"

/obj/item/flashlight/flare/torch/lantern/pumpkin/grin
	name = "smiling pumpkin lamptern"
	desc = "A large and decorated pumpkin shell. Its smile is not reassuring."
	icon_state = "pumpkinlamp0"
	item_state = "pumpkinlamp0"

/obj/item/flashlight/flare/torch/lantern/pumpkin/frown
	name = "angry pumpkin lamptern"
	desc = "A large and decorated pumpkin shell. It seems quite angry at something, hopefully not you."
	icon_state = "pumpkinlamp1"
	item_state = "pumpkinlamp1"

/obj/item/flashlight/flare/torch/lantern/pumpkin/surprise
	name = "surprised pumpkin lamptern"
	desc = "A large and decorated pumpkin shell. It is quite surprised to see you."
	icon_state = "pumpkinlamp2"
	item_state = "pumpkinlamp2"

/obj/item/flashlight/flare/torch/lantern/pumpkin/woozy
	name = "woozy pumpking lamptern"
	desc = "A large and decorated pumpkin shell... It seems drunk?!"
	icon_state = "pumpkinlamp3"
	item_state = "pumpkinlamp3"