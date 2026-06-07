/mob/proc/check_subtler(message, forced)
	if(copytext_char(message, 1, 2) == "@")
		if(message == "@")
			return
		emote("subtle", message = copytext_char(message, 2), intentional = !forced, custom_me = TRUE)
		return 1

//OV edit
/mob/proc/check_portal_clothing(message, forced)
	if(copytext_char(message, 1, 2) == "-")
		if(message == "-")
			return
		if(!ishuman(src))
			return
		var/mob/living/carbon/human/the_human = src
		var/list/portal_clothing = list()
		for(var/obj/item/clothing/the_clothing in the_human.get_equipped_items())
			for(var/datum/component/portal_clothes/portal in the_clothing.GetComponents(/datum/component/portal_clothes))
				portal_clothing += portal
		for(var/obj/item/undies/the_clothing in the_human.contents)
			for(var/datum/component/portal_clothes/portal in the_clothing.GetComponents(/datum/component/portal_clothes))
				portal_clothing += portal
		for(var/obj/item/legwears/the_clothing in the_human.contents)
			for(var/datum/component/portal_clothes/portal in the_clothing.GetComponents(/datum/component/portal_clothes))
				portal_clothing += portal
		for(var/obj/item/piercings/the_clothing in the_human.contents)
			for(var/datum/component/portal_clothes/portal in the_clothing.GetComponents(/datum/component/portal_clothes))
				portal_clothing += portal
		if(!portal_clothing.len)
			return
		if(portal_clothing.len == 1)
			for(var/datum/component/portal_clothes/portal in portal_clothing)
				portal.on_send(src, src, message)
		else
			var/datum/component/portal_clothes/which_portal = tgui_input_list(src, "Which portal are you responding to?", "Portal Clothing", portal_clothing)
			if(!which_portal)
				return
			which_portal.on_send(src, src, message)
		return 1
//OV edit end
