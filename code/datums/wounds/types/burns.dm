/datum/wound/dynamic/burn
	name = "burn"
	whp = 1 // 1 to 1 to puncture, as it is an AP type
	sewn_whp = 0
	bleed_rate = 1
	sewn_bleed_rate = 0.04
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.15
	sewn_clotting_threshold = 0.1
	sew_threshold = 10
	can_sew = TRUE
	can_cauterize = FALSE
	passive_healing = 0.1
	severity_type = SEVERITY_TYPE_WHP
	sound_effect = list('sound/combat/hits/burn (1).ogg', 'sound/combat/hits/burn (2).ogg')
	severity_stages = list(
		"reddened" = 10,
		"blistering" = 35,
		"scalded" = 70,
		"charred" = 120,
		"cindered" = 180,
	)

#define BURN_UPG_WHPRATE 1.2
#define BURN_UPG_PAINRATE 0.25
#define BURN_UPG_BLEEDRATE 0.12
#define BURN_CHAR_THRESHOLD 120
#define BURN_UPG_CLAMP_RAW (ARTERY_LIMB_BLEEDRATE * 0.2)
#define BURN_ARMORED_BLEED_CLAMP (ARTERY_LIMB_BLEEDRATE * 0.5)
#define BURN_MAX_BLEED (ARTERY_LIMB_BLEEDRATE * 0.75)

/datum/wound/dynamic/burn/upgrade(dam, armor, exposed)
	whp += (dam * BURN_UPG_WHPRATE)
	woundpain += (dam * BURN_UPG_PAINRATE)
	set_bleed_rate(bleed_rate + clamp((dam * BURN_UPG_BLEEDRATE), 0.1, BURN_UPG_CLAMP_RAW))
	if(bleed_rate > BURN_MAX_BLEED)
		set_bleed_rate(BURN_MAX_BLEED)
	if(armor && !exposed)
		armor_check(armor, BURN_ARMORED_BLEED_CLAMP)
	if(whp >= BURN_CHAR_THRESHOLD && !disabling)
		disabling = TRUE
		passive_healing = 0
		clotting_threshold = 1
		clotting_rate = 0.1
		bodypart_owner?.update_disabled()
	update_stage()
	..()

#undef BURN_UPG_WHPRATE
#undef BURN_UPG_PAINRATE
#undef BURN_UPG_BLEEDRATE
#undef BURN_CHAR_THRESHOLD
#undef BURN_UPG_CLAMP_RAW
#undef BURN_ARMORED_BLEED_CLAMP
#undef BURN_MAX_BLEED

/datum/wound/charring
	name = "severe burn"
	check_name = span_warning("<B>CHARRED</B>")
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The flesh is seared to the bone!",
		"The %BODYPART is charred black!",
		"The skin blisters and splits open!",
		"The flesh crackles and chars!",
	)
	sound_effect = 'sound/combat/crit.ogg'
	whp = 60
	sewn_whp = 25
	woundpain = 80
	sewn_woundpain = 30
	bleed_rate = 5
	sewn_bleed_rate = 0.5
	sew_threshold = 120
	mob_overlay = ""
	can_sew = TRUE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	bypass_bloody_wound_check = TRUE

/datum/wound/charring/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/charring) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/charring/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	affected.temporary_crit_paralysis(15 SECONDS)

/datum/wound/charring/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("firescream", TRUE)
	flash_color(affected, "#a83c1a", 15)
	affected.Slowdown(15)
	affected.Paralyze(15)
	shake_camera(affected, 2, 2)
	playsound(affected, 'sound/health/burning.ogg', 60, TRUE)
	var/noblood = FALSE
	if(iscarbon(affected))
		var/mob/living/carbon/charred_carbon = affected
		if(charred_carbon.dna?.species)
			noblood = (NOBLOOD in charred_carbon.dna.species.species_traits)
	if(HAS_TRAIT(affected, TRAIT_NOBREATH) || noblood)
		var/burn_crit_count = 0
		for(var/datum/wound/charring/char_wound in affected.get_wounds())
			burn_crit_count++
		if(burn_crit_count >= 2)
			affected.visible_message(span_boldwarning("[affected]'s body is consumed by searing burns!"))
			to_chat(affected, span_boldwarning("The searing heat overwhelms my body!"))
			affected.emote("deathgasp", TRUE)
			affected.death()
		else
			to_chat(affected, span_userdanger("Searing heat scorches through me - another burn like this will be fatal!"))

/datum/wound/charring/sew_wound()
	. = ..()
	if(.)
		bodypart_owner?.update_disabled()

/datum/wound/charring/chest
	name = "torso charring"
	crit_message = list(
		"The torso is seared!",
		"The chest is charred black!",
		"The ribcage crackles with heat!",
	)
	mortal = TRUE

/datum/wound/charring/head
	name = "head charring"
	crit_message = list(
		"The skull is seared!",
		"The face is charred beyond recognition!",
		"The head is engulfed in searing heat!",
	)
	mortal = TRUE
