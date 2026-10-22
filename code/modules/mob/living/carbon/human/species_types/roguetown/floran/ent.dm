/mob/living/carbon/human/species/floran/ent
	race = /datum/species/floran/ent

/datum/species/floran/ent
	name = "Ent"
	id = "ent"
	is_subrace = TRUE
	race_bonus = list(STAT_SPEED = -2, STAT_INTELLIGENCE = 1)
	skin_tone_wording = "Heartwood"
	desc_title = "Ent"
	desc = "Little is known about the Ents’ origins. Many speculate that they hail from a different plane of the fae and dryads; some think they are simply another victim of the Treefather’s will. Ents are, in themselves, sturdy, long‑lived, and mischievous creatures. Although they are generally friendly toward the other inhabitants of Psydonia, many rumors persist about them luring adventurers and sacrificing their bodies and lux to please nature — which has led to general mistrust of them."
	limbs_icon_m = 'icons/mob/species/ents_male.dmi'
	limbs_icon_f = 'icons/mob/species/ents_female.dmi'
	allowed_body_builds = null
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/piercing,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/bodypart_feature/pits,
		/datum/customizer/organ/snout/ent_veil,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/ent_birch,
		/datum/body_marking_set/ent_oak,
		/datum/body_marking_set/ent_swamp,
		/datum/body_marking_set/ent_bloom,
		)
	body_markings = list(
		/datum/body_marking/ent/head/bloom,
		/datum/body_marking/ent/chest/birch_mark,
		/datum/body_marking/ent/chest/oak_mark,
		/datum/body_marking/ent/chest/swamp_mark,
		/datum/body_marking/ent/chest/swamp_over,
		/datum/body_marking/ent/chest/grass,
		/datum/body_marking/ent/chest/petals_lower,
		/datum/body_marking/ent/limbs/birch,
		/datum/body_marking/ent/limbs/oak,
		/datum/body_marking/ent/limbs/swamp,
		/datum/body_marking/ent/limbs/petals,
		/datum/body_marking/ent/limbs/sticks,
		)
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY)
	burnmod = 1.5
	heatmod = 1.5
	inherent_traits = list(
		TRAIT_ENTCORE, // mimics TRAIT_IRONMAN's physiology without the construct upkeep
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_BLOODLOSS_NODEATH, // bleeds sap, feels it, but can never be bled out or collapsed by it
		TRAIT_STABLEHEART, // their core beats on its own: no heart attacks, no cardiac arrest
		)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/construct/ent,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/construct/ent,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/construct/ent,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/construct/ent,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/construct/ent,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/construct/ent,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/construct/ent,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts/ent,
		)
	mechanics_explanations = list("Takes twice as much damage from every burn source",
		"You cannot die, and do not faint from bloodloss, but still suffer its penalties",
		"*veil draws their hollow veil over their face, or sweeps it aside again.",
		"Light sources provide food, while staying in the dark quickly starves you.",
		"After a short channel, sink their roots into bare dirt, grass or open water. While rooted they are held fast and knit themselves back together, as a lesser miracle would, and their sap climbs back three times faster than it would on its own. Entering combat mode, being dragged off the soil, or simply letting go ends it. Also your head cannot be severed from body, but you will die if beaten too much",
		"They cannot jam lost limbs back into place themselves. Rooted in open water while missing limbs, a slow mending begins; after a full minute the lost limbs grow back.",
		"Laid in a grave and covered with dirt without grave markers or rites will slowly regenerate ents, and once fully mended - they can rise again")
	var/datum/action/innate/inroot/inroot
	var/photosyn_threshold = 0.15 // turf lumcount where drain turns into feeding (same bar as sneak/shadow lighting)
	var/photosyn_feed_rate = 3.6 // nutrition gained per Life tick once well lit
	var/dark_starve_rate = 7.2 // nutrition lost per Life tick in pitch dark: 1000 -> 350 in ~3 minutes

/datum/species/floran/ent/check_roundstart_eligible()
	return TRUE

// This is where an ent's color choice is limited - the Veil hollow and the bark
// markings both paint themselves with this wood, and can be repainted by hand.
/datum/species/floran/ent/get_skin_list()
	return list(
		"Birch" = SKIN_COLOR_ENT_BIRCH,
		"Swamp" = SKIN_COLOR_ENT_SWAMP,
		"Oak" = SKIN_COLOR_ENT_OAK,
		)

/datum/species/floran/ent/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	if(isnull(inroot))
		inroot = new
	inroot.Grant(C)
	C.apply_status_effect(/datum/status_effect/buff/ent_burial_regen)
	// The head is grown onto the trunk rather than hung from it: while this species is worn the
	// head cannot be parted from the body. Weapons, guillotines and dismember() all gate on
	// bodypart.dismemberable, so this one flag closes every decapitation path at once.
	var/obj/item/bodypart/head/ent_head = C.get_bodypart(BODY_ZONE_HEAD)
	if(ent_head)
		ent_head.dismemberable = FALSE

/datum/species/floran/ent/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	if(inroot)
		C.remove_status_effect(/datum/status_effect/buff/inrooting)
		inroot.Remove(C)
		QDEL_NULL(inroot)
	C.remove_status_effect(/datum/status_effect/buff/ent_burial_regen)
	. = ..()
	var/obj/item/bodypart/head/old_head = C.get_bodypart(BODY_ZONE_HEAD)
	if(old_head)
		old_head.dismemberable = initial(old_head.dismemberable)

/datum/species/floran/ent/handle_digestion(mob/living/carbon/human/H)
	if(H.stat != DEAD)
		var/light_amount = 0
		if(isturf(H.loc)) // no light reaches them inside a container
			var/turf/T = H.loc
			light_amount = T.get_lumcount()
		var/light_delta = CLAMP((light_amount - photosyn_threshold) * (dark_starve_rate / photosyn_threshold), -dark_starve_rate, photosyn_feed_rate)
		H.adjust_nutrition(light_delta)
		H.hydration = HYDRATION_LEVEL_DEATHLESS // sap drinks through their roots: they never thirst
	update_needs(H)

/proc/ent_rootable_turf(turf/T)
	if(!T)
		return FALSE
	return (istype(T, /turf/open/floor/rogue/dirt) \
		|| istype(T, /turf/open/floor/rogue/grass) \
		|| istype(T, /turf/open/floor/rogue/grassred) \
		|| istype(T, /turf/open/floor/rogue/grassyel) \
		|| istype(T, /turf/open/floor/rogue/grasscold) \
		|| istype(T, /turf/open/water))

/datum/action/innate/inroot
	name = "Inroot"
	desc = "Sink my roots into dirt, grass or open water and hold still, mending myself as a lesser miracle would."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "shieldsparkles"
	var/channel_time = 3 SECONDS
	var/channeling = FALSE

/datum/action/innate/inroot/Activate()
	var/mob/living/carbon/human/H = owner
	if(!istype(H) || channeling)
		return
	if(H.has_status_effect(/datum/status_effect/buff/inrooting))
		return
	if(H.cmode)
		to_chat(H, span_warning("I cannot open my roots while ready for battle."))
		return
	if(!ent_rootable_turf(get_turf(H)))
		to_chat(H, span_warning("Only bare dirt, grass and open water can hold my roots."))
		return
	channeling = TRUE
	H.visible_message(
		span_notice("[H] twists [H.p_their()] feet toward the ground..."),
		span_notice("I loosen my roots and reach down into the earth...")
	)
	if(!do_after(H, channel_time, FALSE, H) || H.cmode || H.stat || !ent_rootable_turf(get_turf(H)))
		channeling = FALSE
		to_chat(H, span_warning("My roots fail to take hold."))
		return
	channeling = FALSE
	if(!istype(H.dna?.species, /datum/species/floran/ent))
		return
	active = TRUE
	H.apply_status_effect(/datum/status_effect/buff/inrooting)

/datum/action/innate/inroot/Deactivate()
	var/mob/living/carbon/human/H = owner
	active = FALSE
	if(istype(H) && H.has_status_effect(/datum/status_effect/buff/inrooting))
		H.remove_status_effect(/datum/status_effect/buff/inrooting)
		to_chat(H, span_notice("I draw my roots back in."))

/datum/status_effect/buff/inrooting
	id = "inrooting"
	alert_type = /atom/movable/screen/alert/status_effect/buff/inrooting
	examine_text = "SUBJECTPRONOUN is rooted deep into the earth."
	duration = -1
	tick_interval = 1 SECONDS
	var/healing_on_tick = 6
	// on top of the passive 0.5 per 2s Life tick, this 1s tick makes rooted sap regen 3x the normal rate
	var/blood_heal_per_tick = 0.5
	var/outline_colour = "#6bff6b"
	var/regrow_time = 60 SECONDS
	var/regrow_elapsed = 0
	var/datum/progressbar/regrow_bar

/atom/movable/screen/alert/status_effect/buff/inrooting
	name = "Inrooted"
	desc = "My roots drink deep of the earth and knit me back together. Combat mode, leaving the soil or being pulled free ends it."
	icon_state = "lesser_heal"

/datum/status_effect/buff/inrooting/on_apply()
	. = ..()
	if(!.)
		return
	var/filter = owner.get_filter("inroot_aura")
	if(!filter)
		owner.add_filter("inroot_aura", 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	owner.visible_message(
		span_notice("[owner]'s limbs sink and twist, roots burrowing into the ground!"),
		span_notice("My roots lock into the soil. I am rooted.")
	)
	owner.Immobilize(2 SECONDS)
	return TRUE

/datum/status_effect/buff/inrooting/on_remove()
	if(owner)
		if(owner.AmountImmobilized() <= (2 SECONDS))
			owner.SetImmobilized(0, FALSE)
		owner.remove_filter("inroot_aura")
	reset_regrowth()
	. = ..()

/datum/status_effect/buff/inrooting/tick()
	if(!owner)
		return
	if(owner.stat == DEAD)
		stop_rooting()
		return
	if(owner.cmode)
		stop_rooting(span_warning("My roots snap as I brace for battle!"))
		return
	if(!ent_rootable_turf(get_turf(owner)) || length(owner.grabbedby))
		stop_rooting(span_warning("I am uprooted from the soil!"))
		return
	owner.Immobilize(2 SECONDS)
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = outline_colour
	owner.heal_wounds(healing_on_tick)
	if(!(owner.status_flags & GODMODE))
		owner.heal_overall_damage(healing_on_tick, healing_on_tick, 0, BODYPART_ORGANIC, FALSE)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(BLOOD_VOLUME_NORMAL, owner.blood_volume + blood_heal_per_tick)
	handle_regrowth()

// Missing limbs regrow only while rooted in open water: a 1 minute progressbar, then they grow back.
/datum/status_effect/buff/inrooting/proc/handle_regrowth()
	if(!ishuman(owner))
		reset_regrowth()
		return
	var/mob/living/carbon/human/H = owner
	if(!istype(get_turf(H), /turf/open/water))
		reset_regrowth()
		return
	var/list/missing = H.get_missing_limbs()
	missing -= list(BODY_ZONE_HEAD, BODY_ZONE_CHEST)
	if(!length(missing))
		reset_regrowth()
		return
	regrow_elapsed += initial(tick_interval)
	if(isnull(regrow_bar))
		regrow_bar = new(H, regrow_time, H)
	regrow_bar.update(regrow_elapsed)
	if(regrow_elapsed < regrow_time)
		return
	regrow_bar.update(regrow_time)
	for(var/zone in missing)
		H.regenerate_limb(zone)
	var/obj/effect/temp_visual/heal/R = new /obj/effect/temp_visual/heal_rogue(get_turf(H))
	R.color = outline_colour
	H.visible_message(
		span_notice("[H]'s lost limbs swell and grow back from [H.p_their()] roots!"),
		span_green("New limbs push forth- I am whole again.")
	)
	reset_regrowth()

/datum/status_effect/buff/inrooting/proc/reset_regrowth()
	regrow_elapsed = 0
	if(regrow_bar)
		QDEL_NULL(regrow_bar)

/datum/status_effect/buff/inrooting/proc/stop_rooting(feedback)
	if(feedback)
		to_chat(owner, feedback)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/datum/species/floran/ent/S = H.dna?.species
		if(istype(S) && S.inroot)
			S.inroot.active = FALSE
	owner.remove_status_effect(/datum/status_effect/buff/inrooting)

// TRUE while the body sits under a grave whose dirt has been filled in.
// Reads the dirthole rather than the buried flag, so digging the grave
// back open unhooks the regrowth however the body was packed away.
/proc/ent_is_buried(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	var/atom/movable/A = H
	while(istype(A, /atom/movable))
		if(istype(A, /obj/structure/closet/dirthole))
			var/obj/structure/closet/dirthole/grave = A
			return !grave.opened
		A = A.loc
	return FALSE

/datum/status_effect/buff/ent_burial_regen
	id = "ent_burial_regen"
	duration = -1
	tick_interval = 2 SECONDS
	alert_type = null // raised and lowered by tick() so it only shows while interred
	var/healing_on_tick = 4 // 120 damage mended a minute
	var/healing_blood_on_tick = 20
	var/outline_colour = "#6bff6b"
	var/interred = FALSE
	var/risen = FALSE

/atom/movable/screen/alert/status_effect/buff/ent_burial_regen
	name = "Grave Regrowth"
	desc = "The earth holds me close while my trunk knits itself whole. Once mended, I rise."
	icon_state = "lesser_heal"

/datum/status_effect/buff/ent_burial_regen/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(!ent_is_buried(H))
		if(interred)
			interred = FALSE
			H.clear_alert(id)
			examine_text = null
			to_chat(H, span_notice("The earth is taken from me. My regrowth sleeps until I am buried again."))
		risen = FALSE
		return
	if(!interred)
		interred = TRUE
		H.throw_alert(id, /atom/movable/screen/alert/status_effect/buff/ent_burial_regen)
		examine_text = "SUBJECTPRONOUN lies buried beneath the earth, slowly knitting whole."
		to_chat(H, span_notice("The earth closes over me. Slowly, my trunk knits itself whole again."))
	H.heal_wounds(healing_on_tick)
	if(!(H.status_flags & GODMODE))
		H.heal_overall_damage(healing_on_tick, healing_on_tick, 0, BODYPART_ORGANIC, FALSE)
	H.adjustOxyLoss(-healing_on_tick, 0)
	H.adjustToxLoss(-healing_on_tick, 0)
	H.adjustCloneLoss(-healing_on_tick, 0)
	if(H.blood_volume < BLOOD_VOLUME_NORMAL)
		H.blood_volume = min(H.blood_volume + healing_blood_on_tick, BLOOD_VOLUME_NORMAL)
	if(ent_is_whole(H) && !risen)
		rise_from_grave()

// TRUE when every point of damage is gone; health itself is no guide, since
// carbon health counts only oxygen and toxin (see updatehealth).
/proc/ent_is_whole(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	return !(H.oxyloss || H.toxloss || H.cloneloss || H.getBruteLoss() || H.getFireLoss())

// The dead wake the way a resurrection would - body first, then the spirit -
// while one merely buried alive only throws off dirt and paralysis.
/datum/status_effect/buff/ent_burial_regen/proc/rise_from_grave()
	var/mob/living/carbon/human/H = owner
	var/was_dead = (H.stat == DEAD)
	if(was_dead)
		if(HAS_TRAIT(H, TRAIT_DNR)) // Death's Door and its like still hold them
			return
		H.updatehealth() // heals pass on updating it, so bring it current before asking
		if(!H.can_be_revived())
			return
		if(!H.revive(full_heal = FALSE))
			return
	// Finish leftover wound mending in one moment so the ent never wakes broken and pinned.
	for(var/datum/wound/wound as anything in H.get_wounds())
		if(!isnull(wound.whp))
			wound.heal_wound(wound.whp)
	H.update_damage_overlays()
	H.blood_volume = max(H.blood_volume, BLOOD_VOLUME_NORMAL)
	H.remove_CC()
	for(var/obj/item/bodypart/BP as anything in H.bodyparts)
		BP.remove_crit_paralysis()
	risen = TRUE
	if(was_dead)
		var/mob/living/carbon/spirit/underworld_spirit = H.get_spirit()
		if(underworld_spirit)
			var/mob/dead/observer/ghost = underworld_spirit.ghostize()
			qdel(underworld_spirit)
			ghost?.mind?.transfer_to(H, TRUE)
		H.grab_ghost(force = TRUE)
		H.emote("breathgasp")
	var/turf/T = get_turf(H)
	if(T)
		var/obj/effect/temp_visual/heal/R = new /obj/effect/temp_visual/heal_rogue(T)
		R.color = outline_colour
		playsound(T, 'sound/foley/climb.ogg', 80, TRUE)
		T.visible_message(span_warning("The fresh earth over [H]'s grave churns and cracks!"))
	if(was_dead)
		to_chat(H, span_green("SAP RACES BACK THROUGH MY TRUNK- I am whole again. The dirt above me shifts; I claw toward the light."))
	else
		to_chat(H, span_green("MY WOUNDS ARE KNIT WHOLE AND THE SAP RUNS FREE- I stir beneath the earth, ready to claw toward the light."))
