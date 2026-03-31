/obj/effect/proc_holder/spell/targeted/touch/nondetection
	name = "Nondetection"
	desc = "Consume a handful of ash and shroud a target that you touch from divination magic for 1 hour."
	clothes_req = FALSE
	drawmessage = "I prepare to form a magical shroud."
	dropmessage = "I release my arcyne focus."
	school = "abjuration"
	overlay_state = "nondetection"
	recharge_time = 10 SECONDS
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/nondetection
	spell_tier = 1
	hide_charge_effect = TRUE 
	// Nondetection shouldn't need an invocation
	xp_gain = TRUE
	cost = 1 // Shit, situational

/obj/item/melee/touch_attack/nondetection
	name = "\improper arcyne focus"
	desc = "Touch a creature to cover them in an anti-scrying shroud for 1 hour, consumes some ash as a catalyst."
	catchphrase = null
	possible_item_intents = list(INTENT_HELP)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#3FBAFD"

/obj/item/melee/touch_attack/nondetection/attack_self()
	attached_spell.remove_hand()

/obj/effect/proc_holder/spell/targeted/touch/nondetection/proc/add_buff_timer(mob/living/user)
	addtimer(CALLBACK(src, PROC_REF(remove_buff), user), wait = 1 HOURS)

/obj/effect/proc_holder/spell/targeted/touch/nondetection/proc/remove_buff(mob/living/user)
	if(QDELETED(user))
		return
	
	REMOVE_TRAIT(user, TRAIT_ANTISCRYING, MAGIC_TRAIT)
	to_chat(user, span_warning("I feel my anti-scrying shroud failing."))

/obj/item/melee/touch_attack/nondetection/afterattack(atom/target, mob/living/carbon/user, proximity)
	var/obj/effect/proc_holder/spell/targeted/touch/nondetection/base_spell = attached_spell
	var/requirement = FALSE
	var/obj/item/sacrifice

	if(isliving(target))

		var/mob/living/spelltarget = target

		for(var/obj/item/I in user.held_items)
			if(istype(I, /obj/item/ash))
				requirement = TRUE
				sacrifice = I

		if(!requirement)
			to_chat(user, span_warning("I require some ash in a free hand."))
			return

		if(!do_after(user, 5 SECONDS, target = spelltarget))
			return

		qdel(sacrifice)
		ADD_TRAIT(spelltarget, TRAIT_ANTISCRYING, MAGIC_TRAIT)
		if(spelltarget != user)
			user.visible_message("[user] draws a glyph in the air and blows some ash onto [spelltarget].")
		else
			user.visible_message("[user] draws a glyph in the air and covers themselves in ash.")

		base_spell.add_buff_timer(spelltarget)
		attached_spell.remove_hand()
	return
