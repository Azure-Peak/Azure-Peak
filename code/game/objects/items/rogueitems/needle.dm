#define SEW_HP_EXP_NORMALIZER 100
// How much EXP per sewing action per intelligence
// 0.6 EXP at 10 INT
#define SEW_EXP_PER_STEP 0.06
// How much EXP per 100 sew threshold fixed per intelligence
// 7.5 EXP at 10 INT for 100 sew treshold
#define SEW_EXP_FINISH 0.75
// How many uses of thread a single strand of fiber winds onto a needle
#define FIBER_THREAD_USES 5

/obj/item/needle
	name = "needle"
	icon_state = "needle"
	desc = "This sharp needle can sew wounds, mend clothing, and stab someone if you’re desperate."
	icon = 'icons/roguetown/items/misc.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	anvilrepair = /datum/skill/craft/blacksmithing
	tool_behaviour = TOOL_SUTURE
	experimental_inhand = TRUE
	/// Amount of uses left
	var/stringamt = 20
	var/maxstring = 20
	/// If this needle is infinite
	var/infinite = FALSE
	/// If this needle can be used to repair items
	var/can_repair = TRUE
	grid_width = 32
	grid_height = 32
	//dropshrink = 0.75
	// we store the overlay to avoid needless icon updates.
	var/mutable_appearance/thread_overlay
	var/repair_integ_per_use = 300

/obj/item/needle/examine()
	. = ..()
	if(!infinite)
		if(stringamt > 0)
			. += span_bold("It has [stringamt] uses left.")
		else
			. += span_bold("It has no uses left.")
	else
		. += "Can be used indefinitely."
	if(repair_method == REPAIR_METHOD_EXPEDIENT)
		. += span_notice("This needle will repair quickly, but with some risk. Activate in-hand to change this.")
	else if(repair_method == REPAIR_METHOD_SAFE)
		. += span_notice("This needle will repair slowly, but safely. Activate in-hand to change this.")

/obj/item/needle/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click someone - while targeting the desired limb - to begin stitching a wound. Stitching automatically stops once you've completely sealed the specific wound.")
	. += span_info("While stitching a wound, it will bleed far slower than usual. This effect can be further stacked by applying cloth, bandages, or pressure to the wounded limb.")
	. += span_info("If multiple stitchable wounds are present on the targeted limb, you'll be given the option to choose which specific wound is treated first.")
	. += span_info("Needles require fibers to stitch, which can be found by cutting grass or foraging through bushes.")
	. += span_info("Activate in-hand to switch between Expedient (Fast) and Safe (Slow) methods of repair.")
	. += span_info("Even Expedient Repairs can be guarantee to be safe if done on foldable or fast tables, or if the Armor Class of the armor matches the training of the user.")
	. += span_info("To rethread an emptied needle, left-click it with a strand of fiber. A fiber bundle works too, and will keep feeding strands in one at a time until the needle is full.")

/obj/item/needle/Initialize(mapload)
	. = ..()
	thread_overlay = mutable_appearance(icon, "[icon_state]string")
	if(stringamt > 0)
		add_overlay(thread_overlay)

/obj/item/needle/use(used)
	if(infinite)
		return TRUE
	var/old_amt = stringamt
	stringamt = max(0, stringamt - used)
	if(old_amt > 0 && stringamt <= 0)
		cut_overlay(thread_overlay)

/obj/item/needle/attack(mob/living/M, mob/user)
	sew(M, user)

/// Is there any point in threading this needle? Complains to the user if not.
/obj/item/needle/proc/can_rethread(mob/user)
	if(infinite || maxstring - stringamt <= 0) //is the needle infinite OR does it have all of its uses left
		to_chat(user, span_warning("The needle has no need to be refilled."))
		return FALSE
	return TRUE

/obj/item/needle/proc/rethread_time(mob/user)
	return 6 SECONDS - user.get_skill_level(/datum/skill/craft/sewing)

/obj/item/needle/proc/rethread()
	var/old_amt = stringamt
	var/gained = min(FIBER_THREAD_USES, (maxstring - stringamt))
	stringamt += gained
	if(old_amt <= 0 && stringamt > 0)
		add_overlay(thread_overlay)
	return gained

/obj/item/needle/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/B = I
		if(!ispath(B.stacktype, /obj/item/natural/fibers)) //only bundles of something we could thread by hand
			return ..()
		if(!can_rethread(user))
			return

		to_chat(user, "I begin threading the needle from [B]...")
		var/refill_amount = 0
		while((stringamt < maxstring) && !QDELETED(B) && (B.amount > 0)) //one strand at a time, until full or the bundle runs dry
			if(!do_after(user, rethread_time(user), target = B))
				break
			if(QDELETED(B) || !B.use(1)) //use() unwinds the bundle itself once it's down to a single strand
				break
			refill_amount += rethread()
		if(refill_amount)
			to_chat(user, "I replenish the needle's thread by [refill_amount] uses!")
		return

	if(istype(I, /obj/item/natural/fibers))
		if(!can_rethread(user))
			return

		to_chat(user, "I begin threading the needle with additional fibers...")
		if(do_after(user, rethread_time(user), target = I))
			to_chat(user, "I replenish the needle's thread by [rethread()] uses!")
			qdel(I)
		return
	return ..()

/obj/item/needle/attack_self(mob/user)
	. = ..()
	if(!length(gripped_intents))
		if(repair_method == REPAIR_METHOD_EXPEDIENT)
			repair_method = REPAIR_METHOD_SAFE
			to_chat(user, span_notice("You will now repair slowly and safely."))
		else
			repair_method = REPAIR_METHOD_EXPEDIENT
			to_chat(user, span_notice("You will now repair with great speed, but risk damaging integrity slightly."))
		user.playsound_local(get_turf(user), 'sound/misc/click.ogg', 100, TRUE)

/obj/item/needle/attack_obj(obj/O, mob/living/user)
	if(!isitem(O))
		return

	if(!stringamt && !infinite)
		to_chat(user, span_warning("The needle is out of thread!"))
		return

	var/obj/item/attacked_item = O
	if(repair_method == REPAIR_METHOD_EXPEDIENT)
		var/repaired_integ = do_special_repair(attacked_item, user, REPAIR_TYPE_SEW)
		if(repaired_integ)
			use_for_repairs(repaired_integ, user)
	else
		do_safe_repair(attacked_item, user, REPAIR_TYPE_SEW)
	return ..()

/obj/item/needle/proc/use_for_repairs(integ, mob/living/user)
	if(!integ || infinite)
		return
	repair_integ_per_use = repair_integ_per_use - integ
	for(var/i in 1 to 10)	// I cannot fathom this needing more than 10 iterations. Otherwise this is just while() phobia.
		if(repair_integ_per_use <= 0 && stringamt > 0)
			var/newinteg = abs(repair_integ_per_use)
			repair_integ_per_use = initial(repair_integ_per_use)
			use(1)
			var/balloon_str = "String used..."
			if(stringamt <= 0)
				balloon_str = "<font color = '#9b2727'>String used up!</font>"
			user.balloon_alert(user, balloon_str)
			repair_integ_per_use -= newinteg
		else
			break


/obj/item/needle/proc/sew(mob/living/target, mob/living/user)
	if(!istype(user))
		return FALSE
	var/mob/living/doctor = user
	var/mob/living/patient = target
	if(stringamt < 1)
		to_chat(user, span_warning("The needle has no thread left!"))
		return
	var/list/sewable
	var/obj/item/bodypart/affecting
	var/is_simple_animal = !iscarbon(patient)
	if(iscarbon(patient))
		affecting = patient.get_bodypart(check_zone(doctor.zone_selected))
		if(!affecting)
			to_chat(doctor, span_warning("That limb is missing."))
			return FALSE
		sewable = affecting.get_sewable_wounds()
	else
		sewable = patient.get_sewable_wounds()
	if(!length(sewable))
		to_chat(doctor, span_warning("There aren't any wounds to be sewn."))
		return FALSE
	var/datum/wound/target_wound = sewable.len > 1 ? input(doctor, "Which wound?", "[src]") as null|anything in sewable : sewable[1]
	if(!target_wound)
		return FALSE

	var/moveup = 10
	var/medskill = doctor.get_skill_level(/datum/skill/misc/medicine)
	var/informed = FALSE
	moveup = (medskill+1) * 4
	if(medskill > SKILL_LEVEL_EXPERT)
		if(medskill == SKILL_LEVEL_MASTER)
			moveup = medskill * 6
		else if(medskill == SKILL_LEVEL_LEGENDARY)
			moveup = medskill * 7
	while(!QDELETED(target_wound) && !QDELETED(src) && \
		!QDELETED(user) && (target_wound.sew_progress < target_wound.sew_threshold) && \
		stringamt >= 1)
		var/sewing_start_delay = 2 SECONDS
		if(medskill > SKILL_LEVEL_EXPERT)
			if(medskill == SKILL_LEVEL_MASTER)
				sewing_start_delay = 1.5 SECONDS
			else if(medskill == SKILL_LEVEL_LEGENDARY)
				sewing_start_delay = 1 SECONDS
		if(!do_after(doctor, sewing_start_delay, target = patient))
			break
		playsound(loc, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)
		target_wound.sew_progress = min(target_wound.sew_progress + moveup, target_wound.sew_threshold)
		var/bleedreduction = max((0.5 * medskill), 0.5)
		if(medskill > SKILL_LEVEL_EXPERT)
			if(medskill == SKILL_LEVEL_MASTER)
				bleedreduction = 3
			else if(medskill == SKILL_LEVEL_LEGENDARY)
				bleedreduction = 4
		target_wound.set_bleed_rate(max( (target_wound.bleed_rate - bleedreduction), 0))
		if(target_wound.bleed_rate == 0 && !informed)
			if(is_simple_animal)
				patient.visible_message(span_smallgreen("One last drop of blood trickles from the [(target_wound?.name)] on [patient] before it closes."), span_smallgreen("The throbbing warmth coming out of the [target_wound] soothes and stops. It no longer bleeds."))
			else
				patient.visible_message(span_smallgreen("One last drop of blood trickles from the [(target_wound?.name)] on [patient]'s [affecting.name] before it closes."), span_smallgreen("The throbbing warmth coming out of the [target_wound] soothes and stops. It no longer bleeds."))
			informed = TRUE
		if(istype(target_wound, /datum/wound/dynamic))
			var/datum/wound/dynamic/dynwound = target_wound
			if(dynwound.is_maxed)
				dynwound.is_maxed = FALSE
			if(dynwound.is_armor_maxed)
				dynwound.is_armor_maxed = FALSE
		if(target_wound.sew_progress < target_wound.sew_threshold)
			if(doctor.mind)
				doctor.mind.add_sleep_experience(/datum/skill/misc/medicine, doctor.STAINT * SEW_EXP_PER_STEP)
			continue
		if(doctor.mind)
			var/exp_scale = target_wound.sew_threshold / SEW_HP_EXP_NORMALIZER
			var/base_exp = doctor.STAINT * SEW_EXP_FINISH
			doctor.mind.add_sleep_experience(/datum/skill/misc/medicine, base_exp * exp_scale)
		use(1)
		target_wound.sew_wound()
		if(patient == doctor)
			if(is_simple_animal)
				doctor.visible_message(span_notice("[doctor] sews \a [target_wound.name] on [doctor.p_them()]self."), span_notice("I stitch \a [target_wound.name] on myself."))
			else
				doctor.visible_message(span_notice("[doctor] sews \a [target_wound.name] on [doctor.p_them()]self."), span_notice("I stitch \a [target_wound.name] on my [affecting]."))
		else
			if(is_simple_animal)
				doctor.visible_message(span_notice("[doctor] sews \a [target_wound.name] on [patient]."), span_notice("I stitch \a [target_wound.name] on [patient]."))
			else if(affecting)
				doctor.visible_message(span_notice("[doctor] sews \a [target_wound.name] on [patient]'s [affecting]."), span_notice("I stitch \a [target_wound.name] on [patient]'s [affecting]."))
			else
				doctor.visible_message(span_notice("[doctor] sews \a [target_wound.name] on [patient]."), span_notice("I stitch \a [target_wound.name] on [patient]."))
		if(is_simple_animal)
			var/mob/living/simple_animal/animal_patient = patient
			animal_patient.adjustHealth(-((animal_patient.maxHealth / 20) * (medskill + 1)), TRUE)
		log_combat(doctor, patient, "sew", "needle")
		return TRUE
	return FALSE

/obj/item/needle/thorn
	name = "needle"
	icon_state = "thornneedle"
	desc = "This rough needle can be used to sew cloth and wounds."
	stringamt = 5
	maxstring = 5
	repair_integ_per_use = 150
	anvilrepair = null

/obj/item/needle/thorn/cleric
	name = "clerical needle"
	icon_state = "lesserneedle"
	desc = "This iron-tipped needle can stem the flow of nastier wounds; a blessing, when one is delivered a grave blow while far away from the Church."
	stringamt = 20
	maxstring = 20
	anvilrepair = null

/obj/item/needle/pestra
	name = "needle of pestra"
	icon_state = "pestraneedle"
	desc = span_green("This needle has been blessed by the goddess of medicine herself!")
	infinite = TRUE

/obj/item/needle/tailor
	name = "tailor's needle"
	icon_state = "tailorneedle"
	desc = "An elongated needle made for the true professional of their craft - for no masterwork was born of a faulty tool."
	infinite = TRUE

/obj/item/needle/bronze
	name = "bronze needle"
	icon_state = "bronzeneedle"
	desc = "A deceptively long needle with a craned tip, laced for labors-a-plenety."
	stringamt = 30
	maxstring = 30

/obj/item/needle/bronze/communal
	name = "communal bronze needle"
	desc = "A needle left with utmost goodwill intentions, meant to help repair the equipment of those in need. You didn't snatch it for yourself, did you?"
	stringamt = 50
	maxstring = 50

/obj/item/needle/aalloy
	name = "decrepit needle"
	icon_state = "aneedle"
	desc = "This decrepit old needle doesn't seem helpful for much."
	stringamt = 5
	maxstring = 5
	repair_integ_per_use = 200

#undef SEW_HP_EXP_NORMALIZER
#undef SEW_EXP_PER_STEP
#undef SEW_EXP_FINISH
#undef FIBER_THREAD_USES
