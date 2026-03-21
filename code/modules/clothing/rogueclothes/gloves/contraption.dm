/obj/item/clothing/gloves/roguetown/chain/contraption
	var/obj/item/accepted_power_source = /obj/item/roguegear	//Bronze by default
	//this is what we use to double power items with, this isn't for all devices
	var/obj/item/prime_power_source = /obj/item/debug
	var/charge_per_source = 5
	var/charge_per_prime = 10
	//allows you to store several charges
	var/max_stored_charge = 20
	var/current_charge = 0
	var/misfire_chance = 15
	var/sneaky_misfire_chance
	var/misfiring = FALSE
	var/cog_accept = TRUE

/obj/item/clothing/gloves/roguetown/chain/contraption/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

    // === CONTRAPTION CORE BEHAVIOR ===
/obj/item/clothing/gloves/roguetown/chain/contraption/proc/battery_collapse(obj/O, mob/living/user)
	to_chat(user, span_info("The [accepted_power_source.name] powering [src] fizzles into nothing!"))
	playsound(src, pick('sound/combat/hits/onmetal/grille (1).ogg','sound/combat/hits/onmetal/grille (2).ogg'), 100, FALSE)
	//qdel(src)
	O.take_damage(400, BRUTE, "blunt", 1)

/obj/item/clothing/gloves/roguetown/chain/contraption/proc/misfire(obj/O, mob/living/user)
	to_chat(user, span_danger("[src] spark violently in your hands!"))
	playsound(src, 'sound/misc/bell.ogg', 100)
	addtimer(CALLBACK(src, PROC_REF(misfire_result), O, user), rand(5, 30))

/obj/item/clothing/gloves/roguetown/chain/contraption/proc/misfire_result(obj/O, mob/living/user)
	misfiring = TRUE
	explosion(src, light_impact_range = 2, flame_range = 2, smoke = TRUE)
	//qdel(src)
	O.take_damage(400, BRUTE, "blunt", 1)

/obj/item/clothing/gloves/roguetown/chain/contraption/proc/charge_deduction(obj/O, mob/living/user, deduction)
	current_charge -= deduction
	if(current_charge <= 0)
		addtimer(CALLBACK(src, PROC_REF(battery_collapse), O, user), 5)


/obj/item/clothing/gloves/roguetown/chain/contraption/voltic
	name = "voltic contraption gauntlets"
	desc = "A pair of bronze-plated gauntlets, fitted with whirring machinery. Runic enigmas have been meticulously etched onto its joints - a voltic incantation, humming with electrical power. </br>‎  </br>By right-clicking these gauntlets, I can unleash bursts of paralyzing lightning.. so long as the mechanisms are powered, at least."
	icon_state = "volticgauntlets"
	slot_flags = ITEM_SLOT_GLOVES
	armor = ARMOR_MAILLE
	resistance_flags = FIRE_PROOF
	blocksound = CHAINHIT
	max_integrity = ARMOR_INT_SIDE_BRONZE
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/bronze
	grid_width = 64
	grid_height = 32
	unarmed_bonus = 1.2
	misfire_chance = 5
	var/activate_sound = 'sound/items/stunmace_gen (2).ogg'
	var/cdtime = 1.5 MINUTES
	var/activetime = 5 SECONDS
	sellprice = 100
	var/delay = 5 SECONDS
	var/sprite_changes = 10
	var/datum/beam/current_beam = null
	var/active = FALSE
	var/cooldowny



/obj/item/clothing/gloves/roguetown/chain/contraption/voltic/attackby(obj/item/I, mob/user, params)
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_turf(src)
	if(istype(I, accepted_power_source))
		user.changeNext_move(CLICK_CD_FAST)
		S.set_up(1, 1, front)
		S.start()
		if((max_stored_charge - current_charge) < charge_per_source) //checking if there's too much charge
			to_chat(user, span_info("I try to insert the [I.name] but theres already \a [initial(accepted_power_source.name)] inside!"))
			playsound(src, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
			shake_camera(user, 1, 1)
		else
			to_chat(user, span_info("I insert the [I.name] and the [name] starts ticking."))
			current_charge += charge_per_source
			playsound(src, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
			qdel(I)
			//addtimer(CALLBACK(src, PROC_REF(play_clock_sound)), 5)
	if(istype(I, prime_power_source))
		user.changeNext_move(CLICK_CD_FAST)
		S.set_up(1, 1, front)
		S.start()
		if((max_stored_charge - current_charge) < charge_per_prime) //checking if there's too much charge with a prime source
			if((max_stored_charge - current_charge) < charge_per_source) //if there's too much for prime, we give it the standard charge
				to_chat(user, span_info("I try to insert the [I.name] but theres already \a [initial(accepted_power_source.name)] inside!"))
				playsound(src, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
				shake_camera(user, 1, 1)
			else
				to_chat(user, span_info("I insert the [I.name] and the [name] starts ticking. I feel I reached capacity before it was fully used"))
				current_charge = max_stored_charge
				playsound(src, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
				qdel(I)
				//addtimer(CALLBACK(src, PROC_REF(play_clock_sound)), 5)
		else
			to_chat(user, span_info("I insert the [I.name] and the [name] starts ticking. It gets a big boost"))
			current_charge += charge_per_prime
			playsound(src, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
			qdel(I)
			//addtimer(CALLBACK(src, PROC_REF(play_clock_sound)), 5)


/obj/item/clothing/gloves/roguetown/chain/contraption/voltic/attack_right(mob/user)
	if(loc != user)
		return
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, span_warning("Nothing happens."))
			return
	user.visible_message(span_warning("[user] primes the [src]!"))
	if(activate_sound)
		playsound(user, activate_sound, 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src, PROC_REF(demagicify)), activetime)
	active = TRUE
	update_icon()
	activate(user)

/obj/item/clothing/gloves/roguetown/chain/contraption/voltic/proc/demagicify()
	active = FALSE
	update_icon()
	if(ismob(loc))
		var/mob/user = loc
		user.visible_message(span_warning("[src] settles down."))
		user.update_inv_wear_id()

    // === VOLTIC ZAP ===
/obj/item/clothing/gloves/roguetown/chain/contraption/voltic/proc/activate(mob/living/user)
	if (!user)
		return
	if (obj_broken)
		to_chat(user, span_warning("The gauntlets spark. they are too damaged to work!"))
		return
	if (!current_charge)
		to_chat(user, span_warning("The gauntlets sputter. It needs a [initial(accepted_power_source.name)]!"))
		playsound(src, 'sound/magic/magic_nulled.ogg', 100)
		return
	var/skill = user.get_skill_level(/datum/skill/craft/engineering)

	if(skill > 1) //if they have 2 or above it won't misfire
		misfire_chance = 0
	// Check for misfire before activation
	if(misfire_chance && prob(max(0, misfire_chance - user.goodluck(2) - skill)))
		misfire(src, user)
		return
	// spend a charge
	charge_deduction(null, user, 1)

	var/list/mob/living/valid_targets = list()
	// Find targets in range
	for (var/mob/living/carbon/C in view(2, user))
		if (C.anti_magic_check())
			visible_message(span_warning("The lightning fizzles harmlessly against [C]!"))
			playsound(get_turf(C), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if (C == user)
			continue
		valid_targets += C
		user.visible_message(span_warning("[C] is connected to [user] with a voltic link!"),
		span_warning("You create a static link with [C]."))

	if (!valid_targets.len)
		return

	// Create beam effects and apply shock
	for (var/mob/living/carbon/C in valid_targets)
		if (C == user)
			continue
		var/datum/beam/current_beam
		for (var/x = 1; x <= sprite_changes; x++)
			current_beam = new(user, C, time = 50 / sprite_changes, beam_icon_state = "lightning[ rand(1,12) ]", btype = /obj/effect/ebeam, maxdistance = 10)
			INVOKE_ASYNC(current_beam, TYPE_PROC_REF(/datum/beam, Start))
			sleep(delay / sprite_changes)

		var/dist = get_dist(user, C)
		if (dist <= 2)
			if (HAS_TRAIT(C, TRAIT_SHOCKIMMUNE))
				continue
			else
				C.Immobilize(0.5 SECONDS)
				C.apply_status_effect(/datum/status_effect/debuff/clickcd, 6 SECONDS)
				C.electrocute_act(1, src, 1, SHOCK_NOSTUN)
				C.apply_status_effect(/datum/status_effect/buff/lightningstruck, 6 SECONDS)
		else
			playsound(user, 'sound/items/stunmace_toggle (3).ogg', 100)
			user.visible_message(span_warning("The voltaic link fizzles out!"), span_warning("[C] is too far away!"))
