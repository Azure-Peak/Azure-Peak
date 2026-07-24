/obj/item/roguebin
	name = "wood bin"
	desc = "A washbin, a trashbin, a bloodbin... your choices are truly limitless."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "washbin1"
	var/base_state
	density = TRUE
	opacity = FALSE
	anchored = FALSE
	max_integrity = 300
	w_class = WEIGHT_CLASS_GIGANTIC
	var/kover = FALSE
	drag_slowdown = 2
	throw_speed = 1
	throw_range = 1
	blade_dulling = DULLING_BASHCHOP
	obj_flags = CAN_BE_HIT

/obj/item/roguebin/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("Right-click the washbin to begin cleaning whatever item is in your active hand.")
	. += span_notice("Right-click the washbin without anything in your active hand to wash yourself. Depending on the stainage, you might need to further strip down to completely clean everything on your person.")
	. += span_notice("Washbins need to be filled with water, in order to clean. This can be done by left-clicking it with another container on the 'FEED' intent, or leaving it out in the rain. Using a washbin will pollute the water inside, making it unsafe to drink.")
	. += span_notice("Middle-clicking the washbin with the 'KICK' subintent selected will knock it over.")

/obj/item/roguebin/weather_trigger(W)
	if(W==/datum/weather/rain)
		START_PROCESSING(SSweather,src)

/obj/item/roguebin/Initialize()
	if(!base_state)
		create_reagents(600, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE)
		icon_state = "washbin[rand(1,2)]"
		base_state = icon_state
	AddComponent(/datum/component/storage/concrete/roguetown/bin)
	. = ..()
	pixel_x = 0
	pixel_y = 0
	update_icon()

/obj/item/roguebin/Destroy()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))
	return ..()


/obj/item/roguebin/update_icon()
	if(kover)
		icon_state = "[base_state]over"
	else
		icon_state = "[base_state]"
	cut_overlays()
	if(reagents)
		if(reagents.total_volume)
			var/mutable_appearance/filling = mutable_appearance('icons/roguetown/misc/structure.dmi', "liquid2")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)

/obj/item/roguebin/onkick(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(kover)
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message(span_warning("[user] kicks [src]!"), \
				span_warning("I kick [src]!"))
			return
		if(prob(L.STASTR * 8))
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message(span_warning("[user] kicks over [src]!"), \
				span_warning("I kick over [src]!"))
			kover = TRUE
			chem_splash(loc, 2, list(reagents))
			var/datum/component/storage/STR = GetComponent(/datum/component/storage)
			if(STR)
				var/list/things = STR.contents()
				for(var/obj/item/I in things)
					STR.remove_from_storage(I, get_turf(src))
			update_icon()
		else
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message(span_warning("[user] kicks [src]!"), \
				span_warning("I kick [src]!"))

/obj/item/roguebin/attack_hand(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.rmb_show(user)
		return TRUE

/obj/item/roguebin/attack_right(mob/user)
	. = ..()
	if(.)
		return
	if(kover)
		if(kover)
			user.visible_message(span_notice("[user] starts to pick up [src]..."), \
				span_notice("I start to pick up [src]..."))
			if(do_after(user, 30, target = src))
				kover = FALSE
				update_icon()
			return
	else
		if(!reagents || !reagents.maximum_volume)
			return
		if(isliving(user))
			var/mob/living/carbon/L = user
			if(L.stat != CONSCIOUS)
				return
			var/removereg = /datum/reagent/water
			if(!reagents.has_reagent(/datum/reagent/water, 5))
				removereg = /datum/reagent/water/gross
				if(!reagents.has_reagent(/datum/reagent/water/gross, 5))
					to_chat(user, span_warning("No water to wash these stains."))
					return
			reagents.remove_reagent(removereg, 5)
			var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
			playsound(user, pick_n_take(wash), 100, FALSE)
			var/item2wash = user.get_active_held_item()
			if(!item2wash)
				user.visible_message(span_info("[user] starts to wash in [src]."))
				if(do_after(L, 30, target = src))
					wash_atom(user, CLEAN_STRONG)
					playsound(user, pick(wash), 100, FALSE)
					user.remove_stress(/datum/stressevent/sewertouched)
			else
				user.visible_message(span_info("[user] starts to wash [item2wash] in [src]."))
				if(do_after(L, 30, target = src))
					wash_atom(item2wash, CLEAN_STRONG)
					playsound(user, pick(wash), 100, FALSE)
					if(iscarbon(user))
						var/mob/living/carbon/C = user
						C.update_inv_hands()
			var/datum/reagent/water_to_dirty = reagents.has_reagent(/datum/reagent/water, 5)
			if(water_to_dirty)
				var/amount_to_dirty = water_to_dirty.volume
				if(amount_to_dirty)
					reagents.remove_reagent(/datum/reagent/water, amount_to_dirty)
					reagents.add_reagent(/datum/reagent/water/gross, amount_to_dirty)
			return

//We need to use this or the object will be put in storage instead of attacking it
/obj/item/roguebin/StorageBlock(obj/item/I, mob/user)
	if(user.used_intent)
		if(user.used_intent.type in list(/datum/intent/fill,/datum/intent/pour,/datum/intent/splash))
			return TRUE
	if(istype(I, /obj/item/rogueweapon/tongs))
		var/obj/item/rogueweapon/tongs/T = I
		if(T.hingot && istype(T.hingot))
			return TRUE
	return FALSE

/obj/item/roguebin/attackby(obj/item/I, mob/user, params)
	if(!reagents || !reagents.maximum_volume) //trash
		return ..()
	if(istype(I, /obj/item/rogueweapon/tongs))
		var/obj/item/rogueweapon/tongs/T = I
		if(T.hingot && istype(T.hingot))
			var/removereg = /datum/reagent/water
			if(!reagents.has_reagent(/datum/reagent/water, 5))
				removereg = /datum/reagent/water/gross
				if(!reagents.has_reagent(/datum/reagent/water/gross, 5))
					to_chat(user, span_warning("Need more water to quench in."))
					return
			if(!T.hingot.currecipe)
				to_chat(user, span_warning("Huh?"))
				return
			if(T.hingot.currecipe.progress < T.hingot.currecipe.max_progress)
				to_chat(user, span_warning("It's not finished yet."))
				return
			if(!T.hott)
				to_chat(user, span_warning("I need to heat it to temper the metal."))
				return
			var/used_turf = user.loc
			if(!isturf(used_turf))
				used_turf = get_turf(src)
			var/datum/anvil_recipe/R = T.hingot.currecipe
			var/obj/item/crafteditem = R.created_item
			if(R.createditem_num > 1)
				R.createditem_num--
				var/obj/item/IT = new crafteditem(used_turf)
				R.handle_creation(IT)
				var/newname = IT.name
				var/newmaxinteg = IT.max_integrity
				var/newinteg = IT.obj_integrity
				var/newprice = IT.sellprice
				var/obj/item/lockpick/L = IT
				var/newpicklvl = L.picklvl
				var/obj/item/rogueweapon/W = IT
				var/newforce = W.force
				var/newthrow = W.throwforce
				var/newblade = W.blade_int
				var/newmaxblade = W.max_blade_int
				var/newap = W.armor_penetration
				var/newdef = W.wdefense
				var/obj/item/clothing/C = IT
				var/newdamdef = C.damage_deflection
				var/newintegfail = C.integrity_failure
				var/newarmor = C.armor
				var/newdelay = C.equip_delay_self
				while(R.createditem_num)
					R.createditem_num--
					var/obj/item/editme = new crafteditem(used_turf)
					editme.name = newname
					editme.max_integrity = newmaxinteg
					editme.obj_integrity = newinteg
					editme.sellprice = newprice
					if(istype(editme, /obj/item/lockpick))
						editme.picklvl = newpicklvl
					if(istype(editme, /obj/item/rogueweapon))
						editme.force = newforce
						editme.throwforce = newthrow
						editme.blade_int = newblade
						editme.max_blade_int = newmaxblade
						editme.armor_penetration = newap
						editme.wdefense = newdef
					if(istype(IT, /obj/item/clothing))
						editme.damage_deflection = newdamdef
						editme.integrity_failure = newintegfail
						editme.armor = newarmor
						editme.equip_delay_self = newdelay
			else // Just make one buddy
				var/obj/item/IT = new crafteditem(used_turf)
				R.handle_creation(IT)
			playsound(src,pick('sound/items/quench_barrel1.ogg','sound/items/quench_barrel2.ogg'), 100, FALSE)
			QDEL_NULL(T.hingot)
			T.update_icon()
			reagents.remove_reagent(removereg, 5)
			var/datum/reagent/water_to_dirty = reagents.has_reagent(/datum/reagent/water, 5)
			if(water_to_dirty)
				var/amount_to_dirty = water_to_dirty.volume
				if(amount_to_dirty)
					reagents.remove_reagent(/datum/reagent/water, amount_to_dirty)
					reagents.add_reagent(/datum/reagent/water/gross, amount_to_dirty)
			update_icon()
			return
	. = ..()

/obj/item/roguebin/trash
	name = "trash bin"
	desc = "An eyesore that is meant to make things look cleaner."
	icon_state = "trashbin"
	base_state = "trashbin"

/obj/item/roguebin/trash/StorageBlock(obj/item/I, mob/user)
	return FALSE

// This is specifically NOT a bin child. I am just putting in here BC I dont know a better spot.
// If we're lucky, I managed to figure out how to hack together base SS13 cryopod storage code.
// This SHOULD be an indestrucible object that accepts items from the user for storage. Place it at spawnpoints for litter reduction.
/obj/item/litterbin
	name = "litterbin"
	desc = "The Garret-Ambrose litterbin is a convoluted device utilizing previously forbidden teleportation magicks. It is capable \
	of storing a vast quantity of items, which can be retrieved by any living person through a mental-link. It has been rendered \
	impervious to all forms of damage, and appears quite stuck in the ground. \
	\nThis device is sponsored by the Azurean Fellowship of the Arcyne Sciences."
	// temp icon
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "washbin1"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	max_integrity = 0
	w_class = WEIGHT_CLASS_GIGANTIC
	item_flags = INDESTRUCTIBLE | LAVA_PROOF | ACID_PROOF
	var/list/stored_items = list()

/obj/item/litterbin/attackby(obj/item/I, mob/user, params)
	// hardening: lets make sure that important items that we designate in a helper proc do not go in
	if(!item_verification_check(I))
		to_chat(user, span_warning("This item is important! It will not go into the bin!"))
		return
	// move it into bin, add item to list. idk why we cant just check contents for it but the cryogenic sleeper code from other servers
	// did something similar to this & i dont want to risk it!
	I.forceMove(src)
	stored_items += I
	to_chat(user, span_info("I store [I] in the litterbin."))

/obj/item/litterbin/attack_hand(mob/user)
	. = ..()
	if(!stored_items.len)
		to_chat(user, span_warning("There are no items within the litterbin!"))
		return

	var/obj/item/I = tgui_input_list(user, "SELECT AN ITEM TO RETRIEVE!", "LITTERBIN", stored_items)

	// no items does nothing
	if(!I)
		return
	// if someone else yoinked it before this line ran, no item... :(
	if(!(I in stored_items))
		to_chat(user, span_warning("This item is not within the bin!"))
		return

	// idk why u have to forcemove this shit out of the bin before you put in hand but u do
	I.forceMove(get_turf(loc))
	user.put_in_hand(I)
	stored_items -= I
	to_chat(user, span_notice("I retrieve [I]!"))

// expandable proc for later. we re-use this when we loop thru objs w/ storage.
// returns true if the if statements are not met. this is probably expensive as fuck but idk what else to do
/obj/item/litterbin/proc/item_verification_check(obj/item/I)
	if(I.is_important)
		return FALSE
	if(istype(I, /obj/item/roguekey))
		return FALSE
	// recursively check through all containers. i have learned from my mistake, last time. at the same time: recursive proc i vomit
	if(I.contents.len)
		for(var/obj/item/contained_item in I.contents)
			if(!item_verification_check(contained_item))
				return FALSE
	return TRUE
