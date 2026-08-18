/obj/item/reagent_containers/lux
	name = "lux"
	desc = "The stuff of life and souls, retrieved from within a hopefully-willing donor. It's a bit clammy and squishy, like a half-fried egg."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux"
	item_state = "lux"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/vitae = 5)
	grind_results = list(/datum/reagent/vitae = 5)
	sellprice = 90
	dropshrink = 0.7

/obj/item/reagent_containers/lux/attack(mob/living/target, mob/living/user)
	if(!istype(target, /mob/living/carbon/human))
		return ..()
	if(target.stat != DEAD)
		return ..()
	if(!HAS_TRAIT(target, TRAIT_NODECAP) || !HAS_TRAIT(target, TRAIT_IRONMAN)) // direct infusion for special snowflake races i guess
		return ..()
	if(!target.check_revive(user))
		return
	var/mob/living/carbon/human/H = target
	if(!do_after(user, 25 SECONDS, target = H))
		return
	if(QDELETED(H) || H.stat != DEAD)
		return
	if(!target.check_revive(user))
		return
	H.adjustOxyLoss(-H.getOxyLoss())
	if(!H.revive(full_heal = FALSE))
		to_chat(user, span_warning("[H] is too damaged to receive this infusion.")) // to prevent conveyor belting them back out so easily
		return
	var/mob/living/carbon/spirit/underworld_spirit = H.get_spirit()
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(H, TRUE)
	H.grab_ghost(force = TRUE)
	H.emote("breathgasp")
	H.Jitter(100)
	H.update_body()
	H.visible_message(span_notice("[H] is jolted back from Necra's hold!"), span_green("I awake from the void."))
	qdel(src)

/datum/reagent/vitae
	name = "Vitae"
	description = "The extracted and processed essence of life."
	color = "#7d8e98" // rgb: 96, 165, 132
	overdose_threshold = 10
	metabolization_rate = 0.1

/datum/reagent/vitae/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 0.25	* REAGENTS_EFFECT_MULTIPLIER)
	M.adjustFireLoss(0.25	* REAGENTS_EFFECT_MULTIPLIER, 0)
	..()
	. = 1

/datum/reagent/vitae/on_mob_life(mob/living/carbon/M)
	M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/vitae)
	..()

/obj/item/reagent_containers/lux_impure
	name = "impure lux"
	desc = "The stuff of life and souls, retrieved from within a hopefully-willing donor. It's eerie and impure, requiring purification."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux_impure"
	item_state = "lux_impure"
	sellprice = 15
	dropshrink = 0.7

/obj/item/reagent_containers/lux_moss
	name = "corrupted lux"
	desc = "Something is amiss with this piece of lifeforce. You can see a faint glimpse of a rock piece hurling through the sky."
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	icon_state = "mosslux"
	item_state = "mosslux"
	sellprice = 1
	dropshrink = 0.7
