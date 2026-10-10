/datum/reagent/consumable
	var/datum/status_effect/buff/brew/brew_buff

/datum/reagent/consumable/proc/apply_brew(mob/living/M, fresh = FALSE)
	if(!brew_buff)
		return
	if(fresh || M.has_status_effect(brew_buff))
		M.apply_status_effect(brew_buff)

/datum/reagent/consumable/proc/brew_mend(mob/living/carbon/M, heal, oxy, wounds = 1, beast = 0.5)
	if(M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(beast * REAGENTS_EFFECT_MULTIPLIER)
		return
	M.adjustBruteLoss(-heal * REAGENTS_EFFECT_MULTIPLIER)
	M.adjustFireLoss(-heal * REAGENTS_EFFECT_MULTIPLIER)
	M.adjustOxyLoss(-oxy, 0)
	if(LAZYLEN(M.get_wounds()) && M.heal_wounds(wounds))
		M.update_damage_overlays()

/datum/reagent/consumable/brew
	drink_type = DRINKTYPE_CAFFEINE
	reagent_state = LIQUID
	hydration_factor = 5
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/consumable/brew/on_mob_metabolize(mob/living/L)
	. = ..()
	apply_brew(L, TRUE)

/datum/reagent/consumable/brew/on_mob_life(mob/living/carbon/M)
	. = ..()
	apply_brew(M)
