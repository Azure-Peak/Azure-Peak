/datum/hag_identity
	var/name											// name we stole
	var/name_color										// voice n name color
	var/descriptor_trait								// e.g. "furred"; type path
	var/descriptor_stature								// e.g. "scholar"; type path
	var/descriptor_voice								// e.g. "soft"; type path
	var/custom_trait									// custom_descriptor_entry instance for trait
	var/custom_stature									// custom_descriptor_entry instance for stature
	var/custom_voice									// custom_descriptor_entry instance for voice
	var/nobility										// boolean for if this identity is noble

/// pass in all the flags to give a new identity as a boon. pass in none of them to make them nameless
/datum/hag_identity/New(new_name, new_color, new_trait, new_stature, new_voice, ctrait, cstature, cvoice, noble)
	. = ..()
	if(new_name) // we're giving a name boon
		name = new_name
		name_color = new_color
		descriptor_trait = new_trait
		descriptor_stature = new_stature
		descriptor_voice = new_voice
		custom_trait = ctrait
		custom_stature = cstature
		custom_voice = cvoice
		nobility = noble
	else // we're stealing a name
		name = "Unknown"
		name_color = "#a0a0a0"
		descriptor_trait = /datum/mob_descriptor/trait/moderate
		descriptor_stature = /datum/mob_descriptor/stature/gentleperson
		descriptor_voice = /datum/mob_descriptor/voice/ordinary

/datum/component/hag_name
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/hag_identity/identity
	var/name_color			// we do actually need to store these so that we can revert them when it's removed
	var/custom_trait
	var/custom_stature
	var/custom_voice
	var/was_noble

/datum/component/hag_name/Initialize(datum/hag_identity/ID)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	identity = ID
	var/mob/living/carbon/human/victim = parent
	name_color = victim.voice_color
	victim.voice_color = ID.name_color
	if(ID.custom_voice) // we need to actually override these for custom trait/stature/voice descriptors to work
		custom_voice = victim.custom_descriptors[9]
		victim.custom_descriptors[9] = ID.custom_voice
	if(ID.custom_trait)
		custom_trait = victim.custom_descriptors[12]
		victim.custom_descriptors[12] = ID.custom_trait
	if(ID.custom_stature)
		custom_stature = victim.custom_descriptors[10]
		victim.custom_descriptors[10] = ID.custom_stature
	was_noble = HAS_TRAIT(parent, TRAIT_NOBLE)
	if(ID.nobility && !was_noble)
		ADD_TRAIT(parent, TRAIT_NOBLE, TRAIT_HAG_BOON)
	if(!ID.nobility && was_noble)
		REMOVE_TRAIT(parent, TRAIT_NOBLE, null) // nobility's attached to your identity i'm afraid

// we're being removed, so we reset anything we actually modified on the character
/datum/component/hag_name/Destroy(force, silent)
	var/mob/living/carbon/human/victim = parent
	victim.voice_color = name_color
	if(custom_voice)
		victim.custom_descriptors[9] = custom_voice
	if(custom_trait)
		victim.custom_descriptors[12] = custom_trait
	if(custom_stature)
		victim.custom_descriptors[10] = custom_stature
	if(was_noble && !HAS_TRAIT(parent, TRAIT_NOBLE))
		ADD_TRAIT(parent, TRAIT_NOBLE, TRAIT_HAG_BOON)
	if(!was_noble && HAS_TRAIT(parent, TRAIT_NOBLE))
		REMOVE_TRAIT(parent, TRAIT_NOBLE, null)
	return ..()
