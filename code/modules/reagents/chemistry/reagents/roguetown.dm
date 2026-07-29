/datum/reagent/miasmagas
	name = "miasmagas"
	description = "."
	color = "#801E28" // rgb: 128, 30, 40
	taste_description = "ugly"
	metabolization_rate = 1

/datum/reagent/miasmagas/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M, TRAIT_NOSTINK) && !physician_mask_check(M))
		M.add_nausea(15)
		M.add_stress(/datum/stressevent/miasmagas)
	return ..()

/proc/physician_mask_check(mob/living/carbon/M)
	if(!M)
		return FALSE
	if(!istype(M, /mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/H = M
	if(!H.wear_mask)
		return FALSE
	return istype(H.wear_mask, /obj/item/clothing/mask/rogue/physician)

/datum/reagent/rogueacid
	name = "rogueacid"
	description = "."
	reagent_state = LIQUID
	color = "#5eff00"
	taste_description = "burning"
	self_consuming = TRUE

/datum/reagent/rogueacid/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	M.adjustFireLoss(35, 0)
	..()

// Injected by TRAIT_VENOMOUS chewers (lamia and drider lower bodies). Ported from Emerald Summit
// PR #167. Not produced by any chemistry recipe; antidote can purge it.
/datum/reagent/lam_venom
	name = "Lamia Venom"
	description = ""
	reagent_state = LIQUID
	color = "#083b1c"
	taste_description = "liquid fire"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM * 3
	harmful = TRUE

/datum/reagent/lam_venom/on_mob_life(mob/living/carbon/M)
	// The venomous are immune to their own kind's venom. ES checked islamia()/isdrider(); here the
	// trait is granted by the lower body, so it doubles as the immunity check.
	if(HAS_TRAIT(M, TRAIT_VENOMOUS))
		return ..()
	// Looks a lot worse than it is - effectively caps max stamina in half, which also drains energy.
	if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
		if(M.stamina <= M.max_stamina/2)
			M.stamina_add(10)
	// A screenflash at a low rate, to notify them if the stamina cap and energy drain doesn't.
	M.adjust_drugginess(1)
	if(prob(10))
		to_chat(M, span_warning("My flesh burns!"))
		if(prob(1))
			M.emote("agony")
	return ..()
