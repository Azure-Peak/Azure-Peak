/datum/action/cooldown/spell/augment_buff/enlarge
	name = "Enlarge Person"
	desc = "For a time, enlarges your target to a giant hulking version of themselves capable of bashing into doors. Does not work on folk who are already large. Can only be used on members of your fellowship."
	fluff_desc = "Despite its lack of practical combat utility, the spell of Enlarge is surprisingly popular and over 70% of male mages are known to be able to recite its incantation rapidly even if it is not prepared for the dae, according to a survey of the Grenzelhoftian Celestial War Academy's student body."
	button_icon_state = "enlarge"

	invocations = list("Dilatare!")
	invocation_type = INVOCATION_SHOUT
	cooldown_time = 2 MINUTES

	point_cost = 1

/datum/action/cooldown/spell/augment_buff/enlarge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/carbon/target = cast_on
	if(target != H && !shares_fellowship(H, target))
		to_chat(H, span_warning("[target] is not of my fellowship!"))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_BIGGUY))
		to_chat(H, span_warning("They're too big to enlarge!"))
		return FALSE

	ADD_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
	target.transform = target.transform.Scale(1.25, 1.25)
	target.transform = target.transform.Translate(0, (0.25 * 16))
	target.update_transform()
	to_chat(target, span_warning("I feel taller than usual, and like I could run through a door!"))
	target.visible_message("[target]'s body grows in size!")
	addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 60 SECONDS)
	return TRUE

/datum/action/cooldown/spell/augment_buff/enlarge/proc/remove_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
	target.transform = target.transform.Translate(0, -(0.25 * 16))
	target.transform = target.transform.Scale(1/1.25, 1/1.25)
	target.update_transform()
	to_chat(target, span_warning("I feel smaller all of a sudden."))
	target.visible_message("[target]'s body shrinks quickly!")
