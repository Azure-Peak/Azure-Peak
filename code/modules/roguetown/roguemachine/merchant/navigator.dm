#define EXPORT_TIME 2 MINUTES
#define EXPORT_TIME_TESTING 5 SECONDS

/obj/item/roguemachine/navigator
	name = "navigator"
	desc = "A machine that attracts the attention of trading balloons."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = TRUE
	blade_dulling = DULLING_BASH
	var/next_airlift
	max_integrity = 0
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	/// A fixed tax on all items sold through the balloon that overrides queens tax. Used for blackmarket
	var/fixed_tax = 0
	/// Motto displayed at the top of the vendor interface
	var/motto = "NAVIGATOR - Your goods, airborne."

/obj/item/roguemachine/navigator/examine()
	. = ..()
	var/export_time = EXPORT_TIME
	#ifdef LOCALTEST
	export_time = EXPORT_TIME_TESTING
	#endif
	. += span_notice("This machine attracts trading balloons every [DisplayTimeText(export_time)]. Goods are sucked into the air and mammons are dropped after tax has been collected.")

// 70% taxation and rip off to encourage people to risk it with merchant / others
/obj/item/roguemachine/navigator/smuggler
	name = "battered navigator"
	desc = "A crudely repaired navigator bolted to the hull of a leaky boat. It stinks of brine and contraband."
	motto = "NAVIGA??R - - ████ ██████ █████████ - FREEDOM OF TRANSACTION.."
	fixed_tax = 0.7

/obj/item/roguemachine/navigator/smuggler/examine(mob/user)
	. = ..()
	. += span_notice("The rates here are disastrous. Having a facilitator from the bathhouse nearby might improve them.")
	if(fixed_tax <= 0.5)
		. += span_notice("A facilitator is present. Current handler's fee: [fixed_tax * 100]%.")
	else
		. += span_warning("No facilitator present. Current handler's fee: [fixed_tax * 100]%.")

/obj/item/roguemachine/navigator/smuggler/process()
	if(!anchored)
		return TRUE
	// Only check bathhouse staff proximity on export tick, not every SSroguemachine fire
	if(world.time > next_airlift)
		var/bath_nearby = FALSE
		for(var/mob/living/carbon/human/H in range(7, src))
			if(H.stat != DEAD && (H.job in GLOB.bathhouse_positions))
				bath_nearby = TRUE
				break
		fixed_tax = bath_nearby ? 0.5 : 0.7
	return ..()

/obj/structure/roguemachine/balloon_pad
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE

/obj/item/roguemachine/navigator/attack_hand(mob/living/user)
	if(!anchored)
		return ..()
	user.changeNext_move(CLICK_CD_INTENTCAP)

	var/contents

	contents += "<center>[motto]<BR>"
	contents += "--------------<BR>"
	if(fixed_tax > 0)
		contents += "HANDLER'S FEE: [fixed_tax * 100] %<BR>"
	contents += "Next Balloon: [time2text((next_airlift - world.time), "mm:ss")]</center><BR>"

	if(!user.can_read(src, TRUE))
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 300)
	popup.set_content(contents)
	popup.open()

/obj/item/roguemachine/navigator/update_icon()
	if(!anchored)
		w_class = WEIGHT_CLASS_BULKY
		set_light(0)
		return
	w_class = WEIGHT_CLASS_GIGANTIC
	set_light(2, 2, 2, l_color = "#1b7bf1")

/obj/item/roguemachine/navigator/Initialize()
	. = ..()
	if(anchored)
		START_PROCESSING(SSroguemachine, src)
	update_icon()
	for(var/X in GLOB.alldirs)
		var/T = get_step(src, X)
		if(!T)
			continue
		new /obj/structure/roguemachine/balloon_pad(T)

/obj/item/roguemachine/navigator/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/item/roguemachine/navigator/process()
	if(!anchored)
		return TRUE
	var/export_time = EXPORT_TIME
	#ifdef LOCALTEST
		export_time = EXPORT_TIME_TESTING
	#endif
	if(world.time > next_airlift)
		next_airlift = world.time + export_time
		var/play_sound = FALSE
		for(var/D in GLOB.alldirs)
			var/budgie = 0
			var/turf/T = get_step(src, D)
			if(!T)
				continue
			var/obj/structure/roguemachine/balloon_pad/E = locate() in T
			if(!E)
				continue
			for(var/obj/I in T)
				if(I.anchored || !isturf(I.loc) || istype(I, /obj/item/roguecoin)|| istype(I, /obj/structure/handcart))
					continue
				var/prize = I.get_real_price() * (1 - fixed_tax)
				if(prize >= 1)
					play_sound=TRUE
					budgie += prize
					I.visible_message(span_warning("[I] is sucked into the air!"))
					qdel(I)
			budgie = round(budgie)
			record_round_statistic(STATS_TRADE_VALUE_EXPORTED, budgie)
			if(budgie > 0)
				play_sound=TRUE
				E.budget2change(budgie)
				budgie = 0
		if(play_sound)
			playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)

#undef EXPORT_TIME
#undef EXPORT_TIME_TESTING
