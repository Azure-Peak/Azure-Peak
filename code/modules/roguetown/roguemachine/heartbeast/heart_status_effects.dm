#define TERRITORIAL_FILTER "territorial_rage"

/atom/movable/screen/alert/status_effect/territorial_rage
	name = "Territorial Rage"
	desc = "The heartbeast is tearing you apart!"

/datum/status_effect/territorial_rage
	id = "territorial_rage"
	duration = 5 SECONDS
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/territorial_rage
	var/outline_color = "#8a2be2"
	var/limb_removed = FALSE

/datum/status_effect/territorial_rage/on_apply()
	if(!isliving(owner))
		return FALSE

	// Immobilize the target
	owner.Immobilize(duration)
	owner.add_filter(TERRITORIAL_FILTER, 2, list("type" = "outline", "color" = outline_color, "alpha" = 210, "size" = 2))
	owner.update_icon()
	to_chat(owner, span_userdanger("The heartbeast's tendrils grab you and start pulling you apart!"))

	animate(owner, pixel_y = owner.pixel_y + 8, time = 0.5 SECONDS, easing = SINE_EASING)

	return TRUE

/datum/status_effect/territorial_rage/tick()
	if(!isliving(owner))
		return
	var/mob/living/L = owner

	L.flash_fullscreen("redflash3", 1)
	L.adjustBruteLoss(15)

	if(!limb_removed && iscarbon(L))
		var/mob/living/carbon/C = L
		remove_limb(C)

/datum/status_effect/territorial_rage/on_remove()
	if(isliving(owner))
		var/mob/living/L = owner
		L.remove_filter(TERRITORIAL_FILTER)
		
		// Lower back down
		animate(L, pixel_y = L.pixel_y - 8, time = 0.5 SECONDS, easing = SINE_EASING)
	
	owner.visible_message(span_danger("The tendrils release [owner]!"))

/datum/status_effect/territorial_rage/proc/remove_limb(mob/living/carbon/C)
	if(limb_removed)
		return

	// Check which limbs are available to remove
	var/obj/item/bodypart/left_arm = C.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/bodypart/right_arm = C.get_bodypart(BODY_ZONE_R_ARM)
	var/obj/item/bodypart/left_leg = C.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/right_leg = C.get_bodypart(BODY_ZONE_R_LEG)

	// Count missing limbs
	var/missing_limbs = 0
	if(!left_arm) missing_limbs++
	if(!right_arm) missing_limbs++
	if(!left_leg) missing_limbs++
	if(!right_leg) missing_limbs++

	// If all 4 limbs are gone, remove head
	if(missing_limbs >= 4)
		remove_head(C)
		return

	// Otherwise remove one available limb
	var/obj/item/bodypart/to_remove = null
	if(left_arm)
		to_remove = left_arm
	else if(right_arm)
		to_remove = right_arm
	else if(left_leg)
		to_remove = left_leg
	else if(right_leg)
		to_remove = right_leg
	
	if(to_remove)
		C.visible_message(span_userdanger("[C]'s [to_remove.name] is torn off by the tendrils!"))
		to_remove.dismember(skip_checks = TRUE)

		var/obj/effect/temp_visual/dir_setting/bloodsplatter/splatter = new(get_turf(C), pick(GLOB.cardinals))
		splatter.color = "#880000"
		limb_removed = TRUE

/datum/status_effect/territorial_rage/proc/remove_head(mob/living/carbon/C)
	var/obj/item/bodypart/head = C.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		C.visible_message(span_userdanger("[C]'s head is violently torn off by the tendrils!"))
		head.dismember(skip_checks = TRUE)
		C.adjustBruteLoss(200)
		var/obj/effect/temp_visual/dir_setting/bloodsplatter/splatter = new(get_turf(C), pick(GLOB.cardinals))
		splatter.color = "#880000"
		splatter.transform *= 2

#undef TERRITORIAL_FILTER
