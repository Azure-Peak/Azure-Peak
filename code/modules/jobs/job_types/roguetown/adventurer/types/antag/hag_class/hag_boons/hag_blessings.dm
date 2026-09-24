/datum/hag_boon/buff
	var/status_type = null

/datum/hag_boon/buff/apply_boon_effect(mob/living/L)
	L.apply_status_effect(status_type, type, tracker)
	return

/datum/hag_boon/buff/remove_boon_effect(mob/living/L)
	L.remove_status_effect(status_type)
	return

/datum/hag_boon/buff/storm_rebirth
	name = "Deathless"
	desc = "The first time the bearer dies, they shall be revived completely. Their body animated like a puppet, leaving them with a curse most terrible."
	points = 65
	status_type = /datum/status_effect/buff/hag_boon/storm_rebirth

/datum/hag_boon/buff/natural_communion
	name = "Natural Communion"
	desc = "The bearer will regenerate their stamina whilst on grass, dirt, snow or swampwater."
	points = 40
	status_type = /datum/status_effect/buff/hag_boon/natural_communion

/datum/hag_boon/buff/creeping_moss
	name = "Creeping Moss"
	desc = "The bearer will regenerate their health whilst on grass, dirt, snow or swampwater. Don't let the moss grow too thick..."
	points = 40
	status_type = /datum/status_effect/buff/hag_boon/creeping_moss

/datum/hag_boon/rejuvenate // ok, this isn't actually a status effect. but it belongs here more than any of the other files
	name = "Wyrd Rejuvenation"
	desc = "Cures all long-term physical ailments, including: blindness, ugliness, missing limbs, and leprosy. Does not heal immediate wounds such as fractures and bleeds, and will not fix divine curses such as lux-taint, silver-weakness, vampirisim, or lycanthropy."
	points = 20 // todo is this too small? maybe bump to 40

/// notably we do not actually apply any woundheal or thelike here; as a hag, you have very high medskill, use that if you want someone alyve, this is for curing permanent disabilities
/datum/hag_boon/rejuvenate/apply_boon_effect(mob/living/L)
	if(!ishuman(L))
		return // we. only want this to apply to humans. ok
	var/mob/living/carbon/human/H = L
	H.visible_message(span_warning("[H] stands, wreathed in a strange energy as [H.p_their()] body restores itself!"), span_green("I feel the burdens of the flesh lift from me!"))
	H.SetUnconscious(0) // this is all copied from the surge spell. it's just for aura, and shouldn't have any real effect
	H.SetSleeping(0)
	H.SetParalyzed(0)
	H.SetImmobilized(0)
	H.SetStun(0)
	H.SetKnockdown(0)
	if(H.has_status_effect(/datum/status_effect/incapacitating/off_balanced))
		H.remove_status_effect(/datum/status_effect/incapacitating/off_balanced)
	H.stam_paralyzed = FALSE
	H.set_resting(FALSE)
	H.rest_locked_until = world.time + 1 SECONDS

	// first, cure blindness, and cache other curable flaws for later
	var/list/blindness_flaws = list()
	var/datum/charflaw/leprosy/leper
	for(var/datum/charflaw/cf in H.charflaws)
		if(istype(cf, /datum/charflaw/noeyeall))
			H.clear_fullscreen("blind_flaw")
			REMOVE_TRAIT(H, TRAIT_NITEVISION, TRAIT_GENERIC)
			H.update_sight()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/noeyel))
			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head && H.dna?.species && istype(H.dna.species, /datum/species/dullahan))
				var/datum/species/dullahan/rev = H.dna.species
				if(rev.headless) // that'd explain it. attach their head before we proceed
					rev.my_head.attach_limb(H)
					H.update_a_intents()
					var/obj/item/organ/dullahan_vision/vision = H.getorganslot(ORGAN_SLOT_HUD)
					vision.viewing_head = FALSE
					H.reset_perspective()
					head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head) // something bizarre has happened
				continue
			head.remove_wound(/datum/wound/facial/eyes/left/permanent)
			H.update_fov_angles()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/noeyer))
			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head && H.dna?.species && istype(H.dna.species, /datum/species/dullahan))
				var/datum/species/dullahan/rev = H.dna.species
				if(rev.headless) // that'd explain it. attach their head before we proceed
					rev.my_head.attach_limb(H)
					H.update_a_intents()
					var/obj/item/organ/dullahan_vision/vision = H.getorganslot(ORGAN_SLOT_HUD)
					vision.viewing_head = FALSE
					H.reset_perspective()
					head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head) // something bizarre has happened
				continue
			head.remove_wound(/datum/wound/facial/eyes/right/permanent)
			H.update_fov_angles()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/colorblind))
			H.remove_client_colour(/datum/client_colour/monochrome)
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/leprosy))
			leper = cf
	if(length(blindness_flaws))
		to_chat(H, span_smallgreen("Light floods my senses as my sight is restored!"))
		for(var/datum/charflaw/cf in blindness_flaws)
			H.charflaws.Remove(cf)
			qdel(cf)
	if(leper)
		REMOVE_TRAIT(H, TRAIT_LEPROSY, TRAIT_GENERIC)
		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.change_stat(STATKEY_CON, 1)
		H.change_stat(STATKEY_WIL, 1)
		H.change_stat(STATKEY_SPD, 1)
		H.change_stat(STATKEY_LCK, 1)
		to_chat(H, span_smallgreen("My constitution bolsters as my illness vanishes!"))
		H.charflaws.Remove(leper)
		QDEL_NULL(leper)
	var/list/regenerable_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_TAUR)
	var/missing_limbs = H.get_missing_limbs()
	for(var/limb_zone in missing_limbs)
		if(limb_zone in regenerable_zones)
			H.regenerate_limb(limb_zone)
			H.visible_message(span_warning("[H]'s [limb_zone] rapidly regrows!"), span_smallgreen("I feel a terrible itching sensation as my [limb_zone] regrows!"))
	if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
		REMOVE_TRAIT(H, TRAIT_UNSEEMLY, null)
		to_chat(H, span_smallgreen("My posture straigtens, my face is mended; my disfigurement is lifted!"))
	clean_body_parts(H)
