///src is the vessel, currently-possessed, that we want to restore
/mob/living/carbon/human/proc/release_vessel(dying = FALSE)
	var/mob/dead/observer/eye/screye/displaced_soul/estranged_lux
	for(var/mob/dead/observer/eye/screye/displaced_soul/one_among_many in GLOB.displaced_souls)
		if(one_among_many.vessel == src)
			estranged_lux = one_among_many
	if(!estranged_lux) // where's your soul, sire
		return FALSE
	var/mob/living/carbon/human/original = estranged_lux.possessor
	if(!SEND_SIGNAL(src, COMSIG_MOB_POSSESS_RELEASE, estranged_lux, original, dying))			// handle things like HCT transfer
		return FALSE
	if(devotion)
		devotion.holder = original
		original.devotion = devotion
	devotion = estranged_lux.vessel_devotion													// swap the devotion objs back around
	patron = estranged_lux.vessel_patron														// and reset their patron
	mind.transfer_to(original) 																	// then transfer the mind back
	custom_descriptors[9] = estranged_lux.original_identity.custom_voice 						// reset the vessel's voice to the non-possessed one
	remove_mob_descriptor(get_descriptor_of_slot(MOB_DESCRIPTOR_SLOT_VOICE, mob_descriptors))
	add_mob_descriptor(estranged_lux.original_identity.descriptor_voice)
	voice_color = estranged_lux.original_identity.name_color
	estranged_lux.vessel_orig_mind.transfer_to(src)												// this should automatically set the key and thereby transfer the client - edit I WAS VERY WRONG
	key = estranged_lux.key																		// ????????
	estranged_lux.archived_skills.set_current(estranged_lux.vessel_skills ? original : src)		// for some reason this wasn't happening automatically on unpossess
	REMOVE_TRAIT(src, TRAIT_POSSESSED, null)													// we don't know what trait_source was, just clear it all
	QDEL_NULL(estranged_lux)																	// resets the state and clears the slate
	original.reset_perspective()																// needed for revs and such
	reset_perspective()
	original.clear_orphaned_actions()															// if remove_spells = FALSE this will be needed to prevent a familiar
	return TRUE																					// getting all the CM's spells for example

///src is the possessing mob, vessel is the mob to be possessed. role-agnostic and can be called on non-hags safely, have fun. set remove_spells to FALSE if you want the possessor to have access to the possessee's spells. set vessel_skills to TRUE if you want the vessel's skills to be used instead of the possessor's
/mob/living/carbon/human/proc/possess_vessel(mob/living/carbon/human/vessel, trait_source = TRAIT_GENERIC, remove_spells = TRUE, vessel_skills = FALSE)
	if(!vessel || QDELING(vessel) || HAS_TRAIT(vessel, TRAIT_POSSESSED)) // we want to make EXTRA sure nobody does anything stupid, here
		return FALSE
	var/datum/mind/vessel_orig_mind = vessel.mind // save this reference early incase make_observer fucks with it
	vessel.mind.current = null // don't do anything funky while we execute
	// before ANYTHING else we need to clear the mob's spells so the hag won't have access to them. they'll get re-added when the hag
	// goes back to their original body and the vessel's original mind transfers back in
	if(remove_spells)
		for(var/X in vessel.mind.spell_list)
			// New action-based spells ARE actions — grant them directly
			if(istype(X, /datum/action/cooldown/spell))
				var/datum/action/cooldown/spell/action_spell = X
				action_spell.Remove(vessel)
			// Old proc_holder spells have a separate action wrapper
			else if(istype(X, /obj/effect/proc_holder/spell))
				var/obj/effect/proc_holder/spell/S = X
				S.action?.Remove(vessel)

	// ok so here's how this works. first, we ghostize the vessel and force them to orbit their old body.
	// we store a copy of the things that change (voice color and descriptor) using the namesteal datum, then transfer over the hag's.
	// we also move the hag curio tracker to the vessel, and add all the hag spells, then transfer the hag player into the vessel
	// when the ghost mob talks, the hag hears it as a psychic message, but nobody else can. they also can't move around or stop orbiting
	// when the hag relinquishes control, we remove the hag spells, transfer the hag curio tracker back, reset the name and voice colors
	// then transfer the hag back into the original mob, then move the ghostmob back into the vessel. i sincerely hope nothing breaks in that.
	// update 2026-08-25: how very glib. things did, in fact, break in that.
	var/mob/dead/observer/eye/screye/displaced_soul/dsoul = vessel.make_observer(/mob/dead/observer/eye/screye/displaced_soul, FALSE)
	if(!dsoul)
		return FALSE
	dsoul.vessel_devotion = vessel.devotion
	dsoul.vessel_patron = vessel.patron
	vessel.patron = src.patron
	if(devotion)					// this is nigh-useless for the case of hags specifically. however, given that this is a generic proc...
		devotion.holder = vessel
		vessel.devotion = devotion
		devotion = null
	dsoul.ManualFollow(vessel)
	dsoul.vessel = vessel
	dsoul.archived_skills = vessel_skills ? skills : vessel.skills	// if vessel_skills is false: possessor's skills → vessel.skills, vessel.skills → archived_skills
	dsoul.vessel_skills = vessel_skills								// else: possessor's skills → archived_skills, vessel skills → vessel skills (after mind transfer tries to undo that)
	var/datum/skill_holder/vskills = vessel.skills
	dsoul.vessel_orig_mind = vessel_orig_mind
	dsoul.possessor = src
	dsoul.original_identity = vessel.make_hag_identity() // this is safe to use for more than just hags; it's just a datum primarily used to store identity for hag stuff
	dsoul.key = vessel.key
	// we've already archived the original identity, so it's safe to make destructive changes here. something something yuri
	vessel.voice_color = voice_color
	vessel.remove_mob_descriptor(vessel.get_descriptor_of_slot(MOB_DESCRIPTOR_SLOT_VOICE, vessel.mob_descriptors))
	vessel.custom_descriptors[9] = custom_descriptors[9] // this is the voice. i hate that custom descriptor code uses magic numbers
	vessel.add_mob_descriptor(get_descriptor_of_slot(MOB_DESCRIPTOR_SLOT_VOICE, mob_descriptors))
	mind.transfer_to(vessel)
	if(vessel_skills)
		vskills.set_current(vessel)
	vessel.reset_perspective() // needed for revs and such
	ADD_TRAIT(vessel, TRAIT_POSSESSED, trait_source)
	SEND_SIGNAL(vessel, COMSIG_MOB_POSSESS, dsoul, src)
	return dsoul

/// removes all actions not belonging to a spell in the mind's spell list. good way to 'reset' actionlists after mind transfers
/mob/proc/clear_orphaned_actions()
	if(!mind || !length(mind.spell_list))
		return
	outer:
		for(var/datum/action/X in actions)
			for(var/spell in mind.spell_list)
				if(istype(spell, /datum/action/cooldown/spell))
					if(spell == X)
						continue outer
				else if(istype(spell, /obj/effect/proc_holder/spell))
					var/obj/effect/proc_holder/spell/S = spell
					if(X == S.action)
						continue outer
			X.Remove(src)
