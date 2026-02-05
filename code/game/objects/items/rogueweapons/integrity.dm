/obj/item
	/// Current blade integrity
	var/blade_int = 0
	/// Blade integrity at which dismemberment reaches 100% effectiveness
	var/dismember_blade_int = 0
	/// Maximum blade integrity
	var/max_blade_int = 0
	/// Whether to randomize the blade integrity on init.
	var/randomize_blade_int_on_init = FALSE
	/// Required skill to repair the blade integrity
	var/required_repair_skill = 0
	/// Sharpness loss multiplier.
	var/sharpness_mod = 1

/obj/item/proc/remove_bintegrity(amt as num, mob/user)
	if(sharpness == IS_BLUNT)
		return FALSE
	if(sharpness_mod != 1)
		amt *= sharpness_mod
	if(user && HAS_TRAIT(user, TRAIT_SHARPER_BLADES))
		amt = amt * 0.7

	var/mob/living/L
	if(loc && loc == user)
		L = user
	else	//If we're sending messages it should be sent to a mob
		if(loc && ishuman(loc))
			L = loc

	if(L)
		amt -= L.get_tempo_bonus(TEMPO_TAG_DEF_SHARPNESSFACTOR)
		amt = max(amt, 0)

	if(L && max_blade_int)
		var/ratio = blade_int / max_blade_int
		var/newratio = (blade_int - amt) / max_blade_int
		if(ratio > SHARPNESS_TIER1_THRESHOLD && newratio <= SHARPNESS_TIER1_THRESHOLD) //We are above the first threshold but are about to hit it.
			if(L.STAINT > 9)
				to_chat(L, span_info("<i><font color = '#ececec'>The edge chips! \The [src]'s damage will start to slowly wane, now.</font></i>"))
			playsound(L, 'sound/combat/sharpness_loss1.ogg', 75, TRUE)

		//We are above the second threshold but are about to hit it.
		if(ratio > SHARPNESS_TIER2_THRESHOLD && newratio <= SHARPNESS_TIER2_THRESHOLD)
			if(L.STAINT > 9)
				to_chat(L, span_userdanger("A chunk snapped off! \The [src]'s damage will decay much quicker now."))
			playsound(L, 'sound/combat/sharpness_loss2.ogg', 100, TRUE)

	blade_int = blade_int - amt
	if(blade_int <= 0)
		blade_int = 0
		return FALSE
	return TRUE

/obj/item/proc/degrade_bintegrity(amt as num)
	if(max_blade_int <= 10)
		max_blade_int = 10
		return FALSE
	else
		max_blade_int = max_blade_int - amt
		if(max_blade_int <= 10)
			max_blade_int = 10
		return TRUE

/obj/item/proc/add_bintegrity(amt as num, mob/user)
	if(HAS_TRAIT(user, TRAIT_SHARPER_BLADES))
		amt *= 1.3
	if(blade_int >= max_blade_int)
		blade_int = max_blade_int
		return FALSE
	else
		var/ratio = blade_int / max_blade_int
		if(ratio < SHARPNESS_TIER2_THRESHOLD && ((blade_int + amt) / max_blade_int) > SHARPNESS_TIER2_THRESHOLD)
			to_chat(user, span_info("The <b>chunks</b> smooth out. The edge regains some smoothness."))
		if(ratio < SHARPNESS_TIER1_THRESHOLD && ((blade_int + amt) / max_blade_int) > SHARPNESS_TIER1_THRESHOLD)
			to_chat(user, span_info("The <b>chips</b> disappear. The edge is now as sharp as ever."))
		blade_int = blade_int + amt
		if(blade_int >= max_blade_int)
			blade_int = max_blade_int
		return TRUE

/obj/structure/attackby(obj/item/I, mob/user, params)
	user.changeNext_move(user.used_intent.clickcd)
	. = ..()


/obj/machinery/attackby(obj/item/I, mob/user, params)
	user.changeNext_move(user.used_intent.clickcd)
	. = ..()

/obj/item/attackby(obj/item/I, mob/user, params)
	if(!no_use_cd)
		user.changeNext_move(user.used_intent.clickcd)
	if(max_blade_int)
		if(istype(I, /obj/item/natural))
			var/obj/item/natural/ST = I
			if(!ST.sharpening_factor)
				return
			var/loopcount = round(max_blade_int / ST.sharpening_factor, 1) + 1
			sharpen(ST, user, 0.3)
			user.changeNext_move(CLICK_CD_TRACKING)
			if(blade_int >= max_blade_int)
				to_chat(user, span_info("Fully sharpened."))
				return
			for(var/i in 1 to loopcount)
				if(blade_int >= max_blade_int)
					to_chat(user, span_info("Fully sharpened."))
					break
				if(do_after(user, 1.5 SECONDS, same_direction = TRUE))
					sharpen(ST, user)
				else
					break
			return
	. = ..()

/obj/item/proc/sharpen(obj/item/natural/ST, mob/user, factor = 1)
	playsound(src.loc, pick('sound/items/sharpen_long1.ogg','sound/items/sharpen_long2.ogg'), 100, TRUE)
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_notice("[user] sharpens [src]!"))
	degrade_bintegrity(0.5)
	add_bintegrity((ST.sharpening_factor * factor), user)

	if(prob(ST.spark_chance))
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_step(user,user.dir)
		S.set_up(1, 1, front)
		S.start()

//Could do without being a proc, but just in case this is expanded later.
//Just used for grindstones, currently, to restore quality of a blade.
/obj/item/proc/restore_bintegrity()
	max_blade_int = initial(max_blade_int)//Given it's reduced above.
	blade_int = initial(max_blade_int)//Now return it.
