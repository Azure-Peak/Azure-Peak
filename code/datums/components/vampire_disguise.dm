#define MASQUERADE_IMMUNE(H) (H.get_vampire_generation() == GENERATION_METHUSELAH)

/datum/component/vampire_disguise
	/// Current disguise state
	var/disguised = FALSE
	/// Cached appearance for disguise
	var/cache_skin
	var/cache_eyes
	var/cache_hair
	var/cache_facial
	var/cache_boobs
	var/cache_ears
	/// Transform cooldown
	COOLDOWN_DECLARE(transform_cooldown)
	/// Bloodpool cost per life tick while disguised
	var/disguise_upkeep = 0
	/// Minimum bloodpool required to maintain disguise
	var/min_bloodpool = 50

/datum/component/vampire_disguise/Initialize(upkeep = 0, min_blood = 50)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	disguise_upkeep = upkeep
	min_bloodpool = min_blood

	var/mob/living/carbon/human/H = parent
	cache_original_appearance(H)

	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(handle_disguise_upkeep))
	RegisterSignal(parent, COMSIG_DISGUISE_STATUS, PROC_REF(disguise_status))
	RegisterSignal(parent, COMSIG_FORCE_UNDISGUISE, PROC_REF(force_undisguise))

/datum/component/vampire_disguise/proc/cache_original_appearance(mob/living/carbon/human/H)
	cache_skin = H.skin_tone
	cache_eyes = H.cache_eye_color()
	cache_hair = H.cache_hair_color(FALSE)
	cache_facial = H.cache_hair_color(TRUE)
	var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
	cache_ears = ears?.accessory_colors
	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
	cache_boobs = breasts?.accessory_colors

/datum/component/vampire_disguise/proc/handle_disguise_upkeep(mob/living/carbon/human/source)
	SIGNAL_HANDLER

	if(!disguised)
		return

	// MASQUERADE LOCK CHECK (auto break)
	if(source in GLOB.coven_breakers_list && !MASQUERADE_IMMUNE(source))
		to_chat(source, span_danger("My broken Masquerade shatters my mortal guise!"))
		remove_disguise(source)
		return

	// Check if we have enough blood to maintain disguise
	if(source.bloodpool < disguise_upkeep)
		to_chat(source, span_warning("My disguise fails as I run out of blood!"))
		remove_disguise(source)
		return

	// Drain bloodpool
	source.adjust_bloodpool(-disguise_upkeep)

/datum/component/vampire_disguise/proc/apply_disguise(mob/living/carbon/human/H)
	if(disguised)
		return FALSE

	// MASQUERADE LOCK CHECK
	if(H in GLOB.coven_breakers_list && !MASQUERADE_IMMUNE(H))
		to_chat(H, span_danger("I have broken the Masquerade. I cannot assume a mortal guise."))
		return FALSE

	if(!COOLDOWN_FINISHED(src, transform_cooldown))
		to_chat(H, span_warning("I must wait before transforming again."))
		return FALSE

	if(H.bloodpool < min_bloodpool)
		to_chat(H, span_warning("I don't have enough blood to maintain a disguise."))
		return FALSE

	disguised = TRUE
	COOLDOWN_START(src, transform_cooldown, 5 SECONDS)

	// Restore human appearance
	H.skin_tone = cache_skin
	if(islist(cache_hair))
		H.set_hair_color(
			cache_hair["hair_color"],
			cache_hair["natural_gradient"],
			cache_hair["natural_color"],
			cache_hair["hair_dye_gradient"],
			cache_hair["hair_dye_color"],
			FALSE
		)
	if(islist(cache_facial))
		H.set_facial_hair_color(
			cache_facial["hair_color"],
			cache_facial["natural_gradient"],
			cache_facial["natural_color"],
			cache_facial["hair_dye_gradient"],
			cache_facial["hair_dye_color"],
			FALSE
		)

	var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
	ears?.accessory_colors = cache_ears
	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
	breasts?.accessory_colors = cache_boobs

	H.set_eye_color(cache_eyes["eye_color"], cache_eyes["second_color"], TRUE)

	to_chat(H, span_notice("I assume a mortal guise."))
	return TRUE

/datum/component/vampire_disguise/proc/remove_disguise(mob/living/carbon/human/H)
	if(!disguised)
		return FALSE

	disguised = FALSE
	COOLDOWN_START(src, transform_cooldown, 5 SECONDS)

	// Apply vampire appearance - get it from clan
	if(H.clan && istype(H.clan, /datum/clan))
		var/datum/clan/vclan = H.clan
		vclan.apply_vampire_look(H)

	to_chat(H, span_warning("My true nature is revealed!"))
	return TRUE

/datum/component/vampire_disguise/proc/force_undisguise(mob/living/carbon/human/H)
	if(!disguised || MASQUERADE_IMMUNE(H))
		return FALSE

	H.visible_message("<font color='white'>[H]'s curse manifests!</font>", ignored_mobs = list(H))
	remove_disguise(H)
	to_chat(H, span_danger("My disguise is forcibly broken!"))
	return TRUE

/datum/component/vampire_disguise/proc/disguise_status()
	return disguised

/datum/component/vampire_disguise/nosferatu
	var/original_ear_accessory_type
	var/original_ear_accessory_colors

/datum/component/vampire_disguise/nosferatu/cache_original_appearance(mob/living/carbon/human/H)
	var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
	original_ear_accessory_type = ears?.accessory_type
	original_ear_accessory_colors = ears?.accessory_colors
	return ..()

/datum/component/vampire_disguise/nosferatu/apply_disguise(mob/living/carbon/human/H)
	var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
	ears?.set_accessory_type(original_ear_accessory_type)
	ears?.accessory_colors = original_ear_accessory_colors
	return ..()

#undef MASQUERADE_IMMUNE