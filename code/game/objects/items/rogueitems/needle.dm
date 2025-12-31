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
	experimental_inhand = FALSE
	/// Amount of uses left
	var/stringamt = 20
	var/maxstring = 20
	/// If this needle is infinite
	var/infinite = FALSE
	/// If this needle can be used to repair items
	var/can_repair = TRUE
	grid_width = 32
	grid_height = 32

/obj/item/needle/examine()
	. = ..()
	if(!infinite)
		if(stringamt > 0)
			. += span_bold("It has [stringamt] uses left.")
		else
			. += span_bold("It has no uses left.")
	else
		. += "Can be used indefinitely."

/obj/item/needle/Initialize()
	. = ..()
	update_icon()

/obj/item/needle/update_overlays()
	. = ..()
	if(stringamt <= 0)
		return
	. += "[icon_state]string"


/obj/item/needle/use(used)
	if(infinite)
		return TRUE
	stringamt = stringamt - used
//	if(stringamt <= 0)
//		qdel(src)

/obj/item/needle/attack(mob/living/M, mob/user)
	sew(M, user)

/obj/item/needle/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/natural/fibers))
		if(infinite || maxstring - stringamt <= 0) //is the needle infinite OR does it have all of its uses left
			to_chat(user, span_warning("The needle has no need to be refilled."))
			return

		to_chat(user, "I begin threading the needle with additional fibers...")
		if(do_after(user, 6 SECONDS - user.get_skill_level(/datum/skill/craft/sewing), target = I))
			var/refill_amount
			refill_amount = min(5, (maxstring - stringamt))
			stringamt += refill_amount
			to_chat(user, "I replenish the needle's thread by [refill_amount] uses!")
			qdel(I)
		return
	return ..()

/obj/item/needle/attack_obj(obj/O, mob/living/user)
	if(!isitem(O))
		return
	var/obj/item/I = O
	if(can_repair)
		if(stringamt < 1)
			to_chat(user, span_warning("The needle has no thread left!"))
			return
		if(I.sewrepair && I.max_integrity)
			if(I.obj_integrity == I.max_integrity)
				to_chat(user, span_warning("This is not broken."))
				return
			if(!I.ontable())
				to_chat(user, span_warning("I should put this on a table first."))
				return
			playsound(loc, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)

			// These are all constants used for tuning the balance of sewing.
			/// The chance to damage an item when entirely unskilled.
			var/const/BASE_FAIL_CHANCE = 60
			/// The (combined) skill level at or above which repairs can't fail.
			var/const/SKILL_NO_FAIL = SKILL_LEVEL_APPRENTICE
			/// Each level in tanning/sewing reduces the skill chance by this much, so that at SKILL_NO_FAIL you don't fail anymore.
			var/const/FAIL_REDUCTION_PER_LEVEL = BASE_FAIL_CHANCE / SKILL_NO_FAIL
			/// The damage done to an item when sewing fails while entirely unskilled.
			var/const/BASE_SEW_DAMAGE = 30
			/// Each level in either tanning or sewing reduces the damage caused by a failure by this many points
			var/const/DAMAGE_REDUCTION_PER_LEVEL = 5
			/// The base integrity repaired when sewing succeeds while entirely unskilled.
			var/const/BASE_SEW_REPAIR = 10
			/// The additional integrity repaired per combined level in sewing/tanning.
			var/const/SEW_REPAIR_PER_LEVEL = 10
			/// How many seconds does unskilled sewing take?
			var/const/BASE_SEW_TIME = 6 SECONDS
			/// At what (combined) level do we
			var/const/SKILL_FASTEST_SEW = SKILL_LEVEL_LEGENDARY
			/// The reduction in sewing time for each (combined) level in sewing/tanning.
			var/const/SEW_TIME_REDUCTION_PER_LEVEL = 1 SECONDS
			/// The minimum sewing time to prevent instant sewing at max level.
			var/const/SEW_MIN_TIME = 0.5 SECONDS
			/// The maximum sewing time for squires.
			var/const/SQUIRE_MAX_TIME = BASE_SEW_TIME / 3 // always at least twice as fast as the base time / Apparently takes too long so dunno we will see at 2 seconds
			/// The XP granted by failure. Scaled by INT. If 0, no XP is granted on failure.
			var/const/XP_ON_FAIL = 0.5
			/// The XP granted by success. Scaled by INT. If 0, no XP is granted on success.
			var/const/XP_ON_SUCCESS = 1
			/// The minimum delay between automatic sewing attempts.
			var/const/AUTO_SEW_DELAY = CLICK_CD_MELEE

			// This is the actual code that applies those constants.
			// If you want to adjust the balance please try just tweaking the above constants first!
			var/skill = user.get_skill_level(/datum/skill/craft/sewing) + user.get_skill_level(/datum/skill/craft/tanning)
			// The more knowlegeable we are the less chance we damage the object
			var/failed = prob(BASE_FAIL_CHANCE - (skill * FAIL_REDUCTION_PER_LEVEL))
			var/sewtime = max(SEW_MIN_TIME, BASE_SEW_TIME - (SEW_TIME_REDUCTION_PER_LEVEL * skill))
			if(HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR))
				failed = FALSE // Make sure they can't fail but let them suffer sewtime
			if(!do_after(user, sewtime, target = I))
				return
			if(failed)
				// We do DAMAGE_REDUCTION_PER_LEVEL less damage per level.
				// You could write this as I.obj_integrity - BASE_SEW_DAMAGE + (skill * DAMAGE_REDUCTION_PER_LEVEL)
				// but that's less obvious and makes it look like it could repair it if your skill was high enough (false).
				I.obj_integrity = max(0, I.obj_integrity - (BASE_SEW_DAMAGE - (skill * DAMAGE_REDUCTION_PER_LEVEL)))
				user.visible_message(span_info("[user] damages [I] due to a lack of skill!"))
				playsound(src, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				if(XP_ON_FAIL > 0)
					user.mind.add_sleep_experience(/datum/skill/craft/sewing, user.STAINT * XP_ON_FAIL)
				if(do_after(user, AUTO_SEW_DELAY, target = I))
					attack_obj(I, user)
				return
			else
				playsound(loc, 'sound/foley/sewflesh.ogg', 50, TRUE, -2)
				user.visible_message(span_info("[user] repairs [I]!"))
				if(I.body_parts_covered != I.body_parts_covered_dynamic)
					user.visible_message(span_info("[user] repairs [I]'s coverage!"))
					I.repair_coverage()
				if(XP_ON_SUCCESS > 0)
					user.mind.add_sleep_experience(/datum/skill/craft/sewing, user.STAINT * XP_ON_SUCCESS)
				I.obj_integrity = min(I.obj_integrity + BASE_SEW_REPAIR + skill * SEW_REPAIR_PER_LEVEL, I.max_integrity)
				if(I.obj_broken && istype(I, /obj/item/clothing) && I.obj_integrity >= I.max_integrity)
					var/obj/item/clothing/cloth = I
					cloth.obj_fix()
					return
				if(do_after(user, AUTO_SEW_DELAY, target = I))
					attack_obj(I, user)
		return
	return ..()

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
				patient.visible_message(span_smallgreen("One last drop of blood trickles from the [(target_wound?.name)] on [patient] before it closes."), span_smallgreen("The throbbing warmth coming out of [target_wound] soothes and stops. It no longer bleeds."))
			else
				patient.visible_message(span_smallgreen("One last drop of blood trickles from the [(target_wound?.name)] on [patient]'s [affecting.name] before it closes."), span_smallgreen("The throbbing warmth coming out of [target_wound] soothes and stops. It no longer bleeds."))
			informed = TRUE
		if(istype(target_wound, /datum/wound/dynamic))
			var/datum/wound/dynamic/dynwound = target_wound
			if(dynwound.is_maxed)
				dynwound.is_maxed = FALSE
			if(dynwound.is_armor_maxed)
				dynwound.is_armor_maxed = FALSE
		if(target_wound.sew_progress < target_wound.sew_threshold)
			continue
		if(doctor.mind)
			doctor.mind.add_sleep_experience(/datum/skill/misc/medicine, doctor.STAINT * 2.5)
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
	anvilrepair = null

/obj/item/needle/pestra
	name = "needle of pestra"
	desc = span_green("This needle has been blessed by the goddess of medicine herself!")
	infinite = TRUE

/obj/item/needle/aalloy
	name = "decrepit needle"
	icon_state = "aneedle"
	desc = "This decrepit old needle doesn't seem helpful for much."
	stringamt = 5
	maxstring = 5
