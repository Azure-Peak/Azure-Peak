/mob/living/carbon/human/verb/lay_egg()
	set name = "Lay Egg"
	set category = "IC"
	set desc = "Strain your body to lay an egg, at great exertion."

	visible_message(span_warning("[src] starts laying an egg."))
	balloon_alert_to_viewers("laying egg!")

	if(!do_after(src, 5 SECONDS, target = src))
		return

	stamina_add(200)

	var/turf/T = get_turf(src)
	var/obj/item/reagent_containers/food/snacks/egg/E = new(T)
	E.pixel_x = rand(-6, 6)
	E.pixel_y = rand(-6, 6)

	visible_message(span_warning("[src] lays an egg."))
	balloon_alert_to_viewers("laid an egg!")
