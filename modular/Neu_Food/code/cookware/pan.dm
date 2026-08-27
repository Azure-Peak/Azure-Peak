/obj/item/cooking/pan
	name = "frypan"
	desc = "Two in one: Cook and smash heads."
	icon = 'modular/Neu_Food/icons/cookware/pan.dmi'
	//lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	//righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = TRUE
	experimental_onhip = TRUE
	icon_state = "pan"
	wlength = WLENGTH_SHORT
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	can_parry = TRUE
	associated_skill = /datum/skill/craft/cooking // This make pan a "viable" weapon for cook with high hit / parry chance. Won't carry them alone ofc.
	swingsound = list('sound/combat/wooshes/blunt/shovel_swing.ogg','sound/combat/wooshes/blunt/shovel_swing2.ogg')
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'
	force = 20
	throwforce = 15
	possible_item_intents = list(/datum/intent/mace/strike/pan)
	wdefense = 2
	grid_width = 32
	grid_height = 64
	anvilrepair = /datum/skill/craft/weaponsmithing
	obj_flags = CAN_BE_HIT

	COOLDOWN_DECLARE(twirl_cooldown) //twirling has a cooldown on to_chat to reduce chatspam

/obj/item/cooking/pan/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/food/cooking/pan)
	AddComponent(/datum/component/container_craft, get_container_craft_family(/datum/container_craft/pan))
	AddComponent(/datum/component/food_burner, 2 MINUTES, TRUE, CALLBACK(src, PROC_REF(can_burn)))

/obj/item/cooking/pan/proc/can_burn()
	if(!istype(loc, /obj/machinery/light/rogue/hearth))
		return FALSE
	var/obj/machinery/light/rogue/hearth/hearth = loc
	if(!hearth.on)
		return FALSE
	return TRUE

/obj/item/cooking/pan/proc/get_item_overlay(obj/item/our_item)
	var/mutable_appearance/MA = mutable_appearance(our_item.icon, our_item.icon_state)
	MA.color = our_item.color
	MA.pixel_x = our_item.base_pixel_x + rand(-3, 3)
	MA.pixel_y = our_item.base_pixel_y + rand(-3, 3)
	MA.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	MA.blend_mode = BLEND_INSET_OVERLAY
	MA.transform *= 0.6
	return MA

/obj/item/cooking/pan/update_overlays()
	. = ..()
	for(var/obj/item/I as anything in contents)
		. += get_item_overlay(I)

/proc/cookware_accepts_ingredient(atom/cookware, obj/item/candidate)
	if(!cookware || !istype(candidate) || (candidate.item_flags & ABSTRACT) || candidate.obj_flags_ignore)
		return FALSE
	var/datum/component/storage/cookware_storage = cookware.GetComponent(/datum/component/storage)
	if(!cookware_storage || !LAZYLEN(cookware_storage.can_hold))
		return FALSE
	return is_type_in_typecache(candidate, cookware_storage.can_hold)

/obj/item/cooking/pan/attackby(obj/item/I, mob/living/user, params)
	if(!user.cmode && cookware_accepts_ingredient(src, I))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, I, user, FALSE, FALSE))
			to_chat(user, span_warning("There's no room left on [src]."))
		return TRUE
	return ..()

/obj/item/cooking/pan/attack_self(mob/user)
	if(!user.cmode && length(contents))
		flip_contents(user)
		return
	return ..()

/obj/item/cooking/pan/proc/flip_contents(mob/user)
	if(!length(contents))
		to_chat(user, span_warning("[src] is empty."))
		return
	var/turf/target_turf = get_step(user, user.dir)
	if(!target_turf || target_turf.density || !user.CanReach(target_turf))
		to_chat(user, span_warning("I need some room to to flip the content of [src] onto."))
		return
	var/obj/item/storage/bag/tray/tray = locate() in target_turf
	var/obj/structure/table/table = locate() in target_turf
	var/count = flip_onto(target_turf)
	if(!count)
		return
	update_icon()
	user.update_inv_hands()
	user.visible_message(span_info("[user] flips [src], sending [count] item[count == 1 ? "" : "s"] tumbling onto [tray || table || target_turf]."), span_info("I flip [src], sending [count] item[count == 1 ? "" : "s"] tumbling onto [tray || table || target_turf]."))
	playsound(user, 'sound/foley/dropsound/shovel_drop.ogg', 40, TRUE, -1)

/obj/item/cooking/pan/proc/flip_onto(turf/target_turf)
	var/list/obj/item/tumbling = contents.Copy()
	if(!length(tumbling))
		return 0
	var/turf/source_turf = get_turf(src)
	var/obj/item/storage/bag/tray/tray = locate() in target_turf
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_QUICK_EMPTY, target_turf)
	var/count = 0
	for(var/obj/item/item as anything in tumbling)
		if(item.loc != target_turf)
			continue
		count++
		animate_tumble(item, source_turf, target_turf)
		if(tray)
			addtimer(CALLBACK(src, PROC_REF(land_on_tray), item, tray), 0.4 SECONDS)
	return count

/obj/item/cooking/pan/proc/land_on_tray(obj/item/item, obj/item/storage/bag/tray/tray)
	if(QDELETED(item) || QDELETED(tray))
		return
	if(item.loc != tray.loc)
		return
	SEND_SIGNAL(tray, COMSIG_TRY_STORAGE_INSERT, item, null, TRUE, FALSE)

/obj/item/cooking/pan/proc/animate_tumble(obj/item/item, turf/source_turf, turf/target_turf)
	var/final_x = initial(item.pixel_x) + rand(-8, 8)
	var/final_y = initial(item.pixel_y) + rand(-8, 8)
	var/start_x = final_x + ((source_turf.x - target_turf.x) * world.icon_size)
	var/start_y = final_y + ((source_turf.y - target_turf.y) * world.icon_size)
	item.pixel_x = start_x
	item.pixel_y = start_y
	animate(item, pixel_x = final_x + ((start_x - final_x) * 0.5), pixel_y = max(start_y, final_y) + 14, time = 0.2 SECONDS, easing = SINE_EASING | EASE_OUT, flags = ANIMATION_PARALLEL)
	animate(pixel_x = final_x, pixel_y = final_y, time = 0.2 SECONDS, easing = SINE_EASING | EASE_IN)

/obj/item/cooking/pan/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(.)
		return
	var/list/obj/item/oldContents = contents.Copy()
	if(!length(oldContents))
		return
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_QUICK_EMPTY)
	var/generator/scatter_gen = generator(GEN_CIRCLE, 0, 48, NORMAL_RAND)
	for(var/obj/item/scattered_item as anything in oldContents)
		var/list/scatter_vector = scatter_gen.Rand()
		scattered_item.pixel_x = scattered_item.base_pixel_x + scatter_vector[1]
		scattered_item.pixel_y = scattered_item.base_pixel_y + scatter_vector[2]
		scattered_item.throw_impact(hit_atom, throwingdatum)

/obj/item/cooking/pan/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -9,"sy" = -9,"nx" = 12,"ny" = -9,"wx" = -7,"wy" = -9,"ex" = 6,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = -1,"wflip" = -1,"eflip" = 5)
			if("wielded")
				return list("shrink" = 0.5,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/cooking/pan/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Frying pans can be placed atop a hearth by left-clicking it. Left-click the placed pan with an ingredient to put it on.")
	. += span_info("Left-click a loaded pan with an empty hand to see everything it holds. Middle-click takes the pan off the hearth.")
	. += span_info("As long as the hearth is lit, everything in the pan will cook at once. Take it off the pan to stop the cooking.")
	. += span_info("Meats, cackleberries, and sliced vegetables are the ideal choices for frying. Other ingredients and recipes might require the gentle caress of an oven, instead.")
	. += span_info("Leaving a fully fried item on a lit hearth for too long will cause it to burn away.")
	. += span_info("Use a loaded pan in your hand outside of combat mode to flip it, throwing everything on it onto the table or tile you're facing. If a tray is there, the food lands on the tray instead.")
	. += span_info("You can twirl [src] by right-clicking it in your hand while in combat mode. Doing so safely requires Expert skill; anything less risks harming yourself.")

/datum/intent/mace/strike/pan
	hitsound = list('sound/combat/hits/blunt/frying_pan(1).ogg', 'sound/combat/hits/blunt/frying_pan(2).ogg', 'sound/combat/hits/blunt/frying_pan(3).ogg', 'sound/combat/hits/blunt/frying_pan(4).ogg')

/obj/item/cooking/pan/aalloy
	name = "decrepit pan"
	desc = "Frayed bronze, wrought into a handheld griddle. Just a little oil's more than enough to slicken the surprisingly-unmarred surface."
	icon_state = "apan"
	color = "#bb9696"

/obj/item/cooking/pan/bronze
	name = "bronze pan"
	desc = "Psydonia's greatest mystery isn't the meaning of lyfe, but how these pans are able to perfectly fry a nite's meal without needing even a single drop of oil."
	icon_state = "bronzepan"
	throwforce = 30 //We both know why.
	max_integrity = 200

/obj/item/cooking/pan/blacksteel
	name = "blacksteel pan"
	desc = "When in doubt on how to make something worthy of a lord, use the most expensive tools to say it brings flavor."
	icon_state = "blpan"
	wdefense = 4 //it's gonna cost a whole ingot of blacksteel gotta make it interesting
	throwforce = 30 //We both know why.
	max_integrity = 300

/obj/item/cooking/pan/stone
	name = "hotrock"
	desc = "Chiseled flat to fry flesh atop a hearth, these stones were the first to shepherd finer tastes to Psydonia's ur-civilizations."
	icon_state = "stonepan"
	throwforce = 20
	w_class = WEIGHT_CLASS_HUGE
	twohands_required = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 100
	minstr = 9
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	throw_range = 5
	grid_width = 64
	grid_height = 64
	slot_flags = null
	possible_item_intents = list(/datum/intent/hit, /datum/intent/mace/smash/wood)
	drop_sound = 'sound/foley/brickdrop.ogg'
	pickup_sound = 'sound/foley/brickdrop.ogg'

/obj/item/cooking/pan/stone/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -4,"wy" = -4,"ex" = 2,"ey" = -4,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/cooking/pan/rmb_self(mob/user)
	. = ..()
	if(. || !user.cmode) // don't want people to accidentally do this while cooking
		return

	SpinAnimation(4, 2) // The spin happens regardless of the cooldown

	if(!COOLDOWN_FINISHED(src, twirl_cooldown))
		return

	COOLDOWN_START(src, twirl_cooldown, 3 SECONDS)
	if((user.get_skill_level(associated_skill) < SKILL_LEVEL_EXPERT) && prob(40))
		var/crit = prob(60) // separate role to KO
		var/critmsg = " <span class='crit'><b>Critical hit!</b> [user] is knocked out!</span>"
		user.visible_message(span_danger("While trying to twirl [src] [user] flings it instead, hitting [user.p_themselves()] in the head![crit ? critmsg : ""]"), span_userdanger("While trying to twirl [src] you fling it instead, hitting yourself in the head![crit ? critmsg : ""]"))
		var/mob/living/carbon/human/unfortunate_idiot = user
		unfortunate_idiot.apply_damage(src.force, BRUTE, BODY_ZONE_PRECISE_SKULL)
		if(crit)
			unfortunate_idiot.flash_fullscreen("whiteflash3")
			unfortunate_idiot.Unconscious(5 SECONDS)
			playsound(get_turf(unfortunate_idiot), 'sound/combat/tf2crit.ogg', 100, FALSE)
		playsound(get_turf(unfortunate_idiot), 'sound/combat/hits/blunt/frying_pan(1).ogg', 100, FALSE)
		user.dropItemToGround(src, TRUE)
	else
		user.visible_message(span_notice("[user] twirls [src] in a dramatic flourish!"), span_notice("You twirl [src] dramatically."))
		playsound(src, 'sound/foley/equip/swordsmall1.ogg', 20, FALSE)

	return
