/*
Exercise Verbs
*/

/mob/living/carbon/human/verb/pushup()
	set name = "Do Pushup"
	set desc = "Makes you do a pushup."
	set category = "Emotes"

	do_pushups()

/mob/living/carbon/human/proc/do_pushups()
	if(!can_do_pushup())
		return

	setDir(EAST)
	visible_message(span_notice("[src] gets down and prepares to do some pushups."), span_notice("You get down for some pushups."), span_notice("You hear rustling."))

	switch(alert(src, "Regular pushups or on your knees?", "Pushups", "Regular", "On Knees"))
		if("Regular")
			visible_message(span_notice("[src] shifts [p_their()] weight onto [p_their()] hands and feet."), span_notice("You move your weight onto your hands and feet."), span_notice("You hear rustling."))
			execute_pushups(on_knees = FALSE)
		if("On Knees")
			visible_message(span_notice("[src] shifts [p_their()] weight onto [p_their()] knees."), span_notice("You move your weight onto your knees."), span_notice("You hear rustling."))
			execute_pushups(on_knees = TRUE)

/mob/living/carbon/human/proc/stop_pushups()
	setDir(null)

/mob/living/carbon/human/proc/execute_pushups(var/on_knees = FALSE)
	if(!can_do_pushup())
		return
	var/target_y = -5
	var/pushups_in_a_row

	var/stamina_loss = calculate_stamina_loss_per_pushup(on_knees)
	while(stamina + stamina_loss < max_stamina)
		if(!can_do_pushup())
			stop_pushups()
			return
		animate(src, pixel_y = target_y, time = 0.8 SECONDS, easing = QUAD_EASING) //down to the floor
		if(!lying || !do_after(src, 0.6 SECONDS, needhand = TRUE, progress = FALSE))
			visible_message(span_notice("[src] stops doing pushups."), span_notice("You stop doing pushups."), span_notice("You hear movements."))
			animate(src, pixel_y = 0, time = 0.2 SECONDS, easing = QUAD_EASING)
			stop_pushups()
			return
		animate(src, pixel_y = 0, time = 0.8 SECONDS, easing = QUAD_EASING) //back up
		if(!lying || !do_after(src, 0.6 SECONDS, needhand = TRUE, progress = FALSE))
			visible_message(span_notice("[src] stops doing pushups."), span_notice("You stop doing pushups."), span_notice("You hear movements."))
			animate(src, pixel_y = 0, time = 0.2 SECONDS, easing = QUAD_EASING)
			stop_pushups()
			return
		pushups_in_a_row++
		var/number_words = numberToWords(pushups_in_a_row)
		balloon_alert_to_viewers(number_words, number_words, 7, y_offset = -12)
		stamina_add(stamina_loss)
	to_chat(src, span_warning("You slump down to the floor, too tired to keep going."))
	stop_pushups()

/mob/living/carbon/human/proc/can_do_pushup()
	if(incapacitated())
		return FALSE

	if(!resting)
		to_chat(src, span_warning("You need to lie on the floor to do a pushup."))
		return FALSE

	if(buckling)
		to_chat(src, span_warning("You need to lie on the floor to do a pushup."))
		return FALSE

	var/list/missing_limbs = get_missing_limbs()
	if(length(missing_limbs))
		to_chat(src, span_warning("You can't do pushups with missing limbs."))
		return FALSE

	if(!isturf(loc))
		to_chat(src, span_warning("You cannot do that here!"))
		return FALSE

	return TRUE

/mob/living/carbon/human/proc/calculate_stamina_loss_per_pushup(var/on_knees = FALSE)
	var/stamina_loss = 8 - get_skill_level(/datum/skill/misc/athletics)
	if(head)
		if(head.armor_class == ARMOR_CLASS_HEAVY)
			stamina_loss += 3
		else if(head.armor_class == ARMOR_CLASS_MEDIUM)
			stamina_loss += 1
	if(wear_armor)
		if(wear_armor.armor_class == ARMOR_CLASS_HEAVY)
			stamina_loss += 5
		else if(wear_armor.armor_class == ARMOR_CLASS_MEDIUM)
			stamina_loss += 2
	if(backr || backl)
		stamina_loss += 3
	var/painpercent = get_complex_pain() / pain_threshold
	if(painpercent > 0.5)
		stamina_loss += 8
	if(on_knees)
		stamina_loss -= 5
	return max(stamina_loss, 1)
