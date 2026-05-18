/datum/patron/divine/ravox
	name = "Ravox"
	domain = "God of Justice, Glory, Battle"
	desc = "Stalwart warrior, glorious justicar; legends say he came down to the Basin to repel the vile hordes of demons with his own hands, and that he seeks warriors for his divine army among mortals."
	worshippers = "Warriors, Sellswords & those who seek Justice"
	mob_traits = list(TRAIT_SHARPER_BLADES)
	traits_tier = list(TRAIT_BATTLEMASTER = CLERIC_T1, TRAIT_JUSTICARSIGHT = CLERIC_T3)
	miracles = list(/datum/action/cooldown/spell/touch/orison				= CLERIC_ORI,
					/datum/action/cooldown/spell/ravox/tug					= CLERIC_T0,
					/datum/action/cooldown/spell/ravox/provocation	       	= CLERIC_T0,
					/datum/action/cooldown/spell/miracle/heal 				= CLERIC_T1,
					/datum/action/cooldown/spell/miracle/bloodmiracle		= CLERIC_T1,
					/datum/action/cooldown/spell/ravox/strikeoraegis		= CLERIC_T1,
					/datum/action/cooldown/spell/ravox/withstand		   	= CLERIC_T2,
					/datum/action/cooldown/spell/ravox/challenge			= CLERIC_T2,
					/datum/action/cooldown/spell/ravox/persistence			= CLERIC_T3,
					/datum/action/cooldown/spell/ravox/battlecry			= CLERIC_T3,
					/datum/action/cooldown/spell/ravox/spirits 				= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/ravox	= CLERIC_T4,
	)
	confess_lines = list(
		"RAVOX IS JUSTICE!",
		"THROUGH STRIFE, GRACE!",
		"THROUGH PERSISTENCE, GLORY!",
	)
	storyteller = /datum/storyteller/ravox
	COOLDOWN_DECLARE(lesser_heal_buff_cooldown)

	titles = list(
		"Justiciar",
		"Justicar" // it is misspelled ingame enough that we should probably accept this too 
	)

// Near a knight statue, cross, or within the church
/datum/patron/divine/ravox/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer near any knight statue and its subtypes.
	for(var/obj/structure/fluff/statue/knight/K in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Ravox to hear my prayer I must either pray within the church, near a psycross, or near a knighly statue in memorium of the fallen.."))
	return FALSE

/datum/patron/divine/ravox/on_lesser_heal(
    mob/living/user,
    mob/living/target,
    message_out,
    message_self,
    conditional_buff,
    situational_bonus
)
	*message_out = span_info("An air of righteous defiance rises near [target]!")
	*message_self = span_notice("I'm filled with an urge to fight on!")

	var/bonus = 0

	if(istype(target.rmb_intent, /datum/rmb_intent/strong))
		bonus++
	
	if(istype(target.get_active_held_item(), /obj/item/rogueweapon))
		bonus += 0.5
	
	if(target == user && target.blood_volume <= BLOOD_VOLUME_OKAY && COOLDOWN_FINISHED(src, lesser_heal_buff_cooldown))
		user.emote("warcry")
		user.blood_volume += BLOOD_VOLUME_SURVIVE / 3
		bonus += 2
		COOLDOWN_START(src, lesser_heal_buff_cooldown, 30 SECONDS)

	if(!bonus)
		return

	*conditional_buff = TRUE
	*situational_bonus = bonus
