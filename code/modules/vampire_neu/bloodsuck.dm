/mob/living/carbon/human/proc/add_bite_animation()
	remove_overlay(SUNDER_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('icons/effects/clan.dmi', "bite", -SUNDER_LAYER)
	overlays_standing[SUNDER_LAYER] = bite_overlay
	apply_overlay(SUNDER_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_bite)), 1.5 SECONDS)

/mob/living/carbon/human/proc/remove_bite()
	remove_overlay(SUNDER_LAYER)

/mob/living/proc/drinksomeblood(mob/living/carbon/victim, sublimb_grabbed)
	if(world.time <= next_move)
		return
	if(world.time < last_drinkblood_use + 2 SECONDS)
		return
	if(!istype(victim))
		to_chat(src, span_warning("I can only drink blood from living, intelligent beings!"))
		return
	if(victim.dna?.species && (NOBLOOD in victim.dna.species.species_traits))
		to_chat(src, span_warning("Sigh. No blood."))
		return
	if(victim.blood_volume <= 0)
		to_chat(src, span_warning("Sigh. No blood."))
		return

	var/datum/antagonist/vampire/VDrinker = mind.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/vampire/VVictim = victim.mind?.has_antag_datum(/datum/antagonist/vampire)

	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(VDrinker && istype(human_victim.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
			to_chat(src, span_userdanger("SILVER! HISSS!!!"))
			return
		if(VDrinker && HAS_TRAIT(human_victim, TRAIT_SILVER_BLESSED))
			to_chat(src, span_userdanger("SILVER IN THE BLOOD! HISSS!!!"))
			return
		human_victim.add_bite_animation()

	last_drinkblood_use = world.time
	changeNext_move(CLICK_CD_MELEE)

	victim.blood_volume = max(victim.blood_volume - 5, 0)
	victim.handle_blood()

	playsound(loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)

	SEND_SIGNAL(src, COMSIG_LIVING_DRINKED_LIMB_BLOOD, victim)
	victim.visible_message(span_danger("[src] drinks from [victim]'s [parse_zone(sublimb_grabbed)]!"), \
					span_userdanger("[src] drinks from my [parse_zone(sublimb_grabbed)]!"), span_hear("..."), COMBAT_MESSAGE_RANGE, src)
	to_chat(src, span_warning("I drink from [victim]'s [parse_zone(sublimb_grabbed)]."))
	log_combat(src, victim, "drank blood from ")

	if(!VDrinker)
		if(!HAS_TRAIT(src, TRAIT_HORDE) && !HAS_TRAIT(src, TRAIT_NASTY_EATER))
			to_chat(src, span_warning("I'm going to puke..."))
			addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))
		return

	if(victim.mind?.has_antag_datum(/datum/antagonist/werewolf) || (victim.stat != DEAD && victim.mind?.has_antag_datum(/datum/antagonist/zombie)))
		to_chat(src, span_danger("I'm going to puke..."))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))
		return

	if(VVictim)
		to_chat(src, span_userdanger("<b>YOU TRY TO COMMIT DIABLERIE ON [victim].</b>"))

	var/blood_handle
	if(victim.stat == DEAD)
		blood_handle |= BLOOD_PREFERENCE_DEAD
	else
		blood_handle |= BLOOD_PREFERENCE_LIVING

	if(HAS_TRAIT(victim, TRAIT_CLERGY) || HAS_TRAIT(victim, TRAIT_INQUISITION))
		blood_handle |= BLOOD_PREFERENCE_HOLY
	if(VVictim)
		blood_handle |= BLOOD_PREFERENCE_KIN
		blood_handle  &= ~BLOOD_PREFERENCE_LIVING

	clan.handle_bloodsuck(src, blood_handle)

	if(victim.bloodpool > 0)
		var/used_vitae = 150
		victim.blood_volume = max(victim.blood_volume - 45, 0)
		if(victim.bloodpool < used_vitae)  // We assume they're left with 250 vitae or less, so we take it all
			used_vitae = victim.bloodpool
			to_chat(src, span_warning("...But alas, only leftovers..."))
		victim.adjust_bloodpool(-used_vitae)
		victim.adjust_hydration(- used_vitae * 0.1)
		if(victim.mind && !victim.clan)
			used_vitae = used_vitae * CLIENT_VITAE_MULTIPLIER
		adjust_bloodpool(used_vitae)
		adjust_hydration(used_vitae * 0.1)
	else // Successful diablerie, yes, you can become a vampire lord by sucking him dry. Intentional!
		if(VVictim)
			AdjustMasquerade(-1)
			message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
			log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")
			to_chat(src, span_danger("I have... Consumed my kindred!"))
			if(VVictim.generation > VDrinker.generation)
				VDrinker.generation = VVictim.generation
			VDrinker.research_points += VVictim.research_points
			victim.death()
			victim.adjustBruteLoss(-50, TRUE)
			victim.adjustFireLoss(-50, TRUE)
			return
		else if(victim.blood_volume < BLOOD_VOLUME_SURVIVE && victim.stat != DEAD)
			to_chat(src, span_warning("This sad sacrifice for your own pleasure affects something deep in your mind."))
			AdjustMasquerade(-1)
			victim.death()
			return

	if(!victim.clan && victim.mind && ishuman(victim) && VDrinker.generation > GENERATION_THINBLOOD && victim.blood_volume <= BLOOD_VOLUME_BAD)
		var/datum/antagonist/vampire/vdrinker = mind?.has_antag_datum(/datum/antagonist/vampire)
		if((vdrinker.max_thralls <= 0) || (isnull(vdrinker.max_thralls))) //thin bloods or low level vampires can't make thralls, incase they get past the last check by leveling up off others
			to_chat(src, span_warning("I cannot sire thralls, my blood is too weak!"))
		else
			if(vdrinker.thrall_count >= vdrinker.max_thralls) //you've hit your max
				to_chat(src, span_warning("I cannot sire anymore thralls.."))
			else
				if(alert(src, "Would you like to sire a new spawn?", "THE CURSE OF KAIN", "MAKE IT SO", "I RESCIND") != "MAKE IT SO")
					to_chat(src, span_warning("I decide [victim] is unworthy."))
				else
					visible_message(span_danger("[src] begins channeling their energies to [victim]!"))
					if(!do_mob(src, victim, 7 SECONDS, double_progress = TRUE, can_move = FALSE))
						to_chat(src, span_warning("I was interrupted during my siring!"))
						return
					INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living/carbon/human, vampire_conversion_prompt), src)

/mob/living/carbon/human/proc/vampire_conversion_prompt(mob/living/carbon/sire)
	if(!mind)
		return

	var/datum/antagonist/vampire/VDrinker = sire?.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(!istype(VDrinker))
		return

	var/datum/mind/original_mind = mind

	if(alert(src, "Would you like to rise as a vampire spawn? Warning: refusal may or may not mortally wound you.", "THE CURSE OF KAIN", "MAKE IT SO", "I RESCIND") != "MAKE IT SO")
		to_chat(sire, span_danger("Your victim twitches, yet the curse fails to take over. As if something otherworldly intervenes..."))
		if(HAS_TRAIT_FROM(src, TRAIT_REFUSED_VAMP_CONVERT, REF(sire)))
			return

		to_chat(sire, span_danger("The curse fails to take hold of [src], yet you still manage to squeeze the last drop of vitae out of them."))
		sire.adjust_bloodpool(VITAE_PER_UNIQUE_CONVERSION_REJECT)
		ADD_TRAIT(src, TRAIT_REFUSED_VAMP_CONVERT, REF(sire))
		return

	fully_heal(TRUE, FALSE)
	visible_message(span_danger("Some dark energy begins to flow from [sire] into [src]..."))
	visible_message(span_red("[src] rises as a new spawn!"))
	original_mind?.transfer_to(src, TRUE)
	var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = sire.clan, forced_clan = TRUE, generation = VDrinker.generation-1)
	mind?.add_antag_datum(new_antag)
	VDrinker.thrall_count++
	adjust_bloodpool(500)
