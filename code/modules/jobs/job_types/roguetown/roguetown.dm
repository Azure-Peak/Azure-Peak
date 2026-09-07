/datum/job/roguetown
	display_order = JDO_LORD
	vice_restrictions = list(/datum/charflaw/wanted)

/datum/job/roguetown/New()
	. = ..()
	if(give_bank_account)
		for(var/X in GLOB.peasant_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.burgher_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.atc_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.church_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.retinue_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.garrison_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.noble_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.courtier_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.sidefolk_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.inquisition_positions)
			peopleiknow += X
			peopleknowme += X

/datum/outfit/job/roguetown
	uniform = null
	id = null
	ears = null
	belt = null
	back = null
	shoes = null
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	box = null
	/// List of patrons we are allowed to use
	var/list/allowed_patrons
	/// Default patron in case the patron is not allowed
	var/datum/patron/default_patron
	/// This is our bitflag for storyteller rolling.
	var/job_bitflag = NONE
	/// Can select equipment after you spawn in.
	var/has_loadout = FALSE

/datum/outfit/job/roguetown/proc/snouthelm_pick(mob/living/carbon/human/H, plain_path, snouted_path)
	if(!H || !H.mind)
		return plain_path
	var/list/visages = list("Standard" = plain_path, "Snouted" = snouted_path)
	var/choice = input(H, "Choose your helm's visage.", "TAKE UP HELMS") as anything in visages
	if(!choice)
		return plain_path
	return visages[choice]

/// applies the proper cleric combat mode music per patron. applies trait_heresiarch if ascendent patron. returns the proper amulet/psicross for the patron, which will be assigned to either neck or wrist depending on the class
/datum/outfit/job/roguetown/proc/apply_cleric_pre_equip(mob/living/carbon/human/H)
	var/amulet
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			amulet = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			amulet = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			amulet = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			amulet = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			amulet = /obj/item/clothing/neck/roguetown/psicross/abyssor
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/dendor)
			amulet = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			amulet = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			amulet = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			amulet = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			amulet = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			amulet = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			amulet = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			amulet = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			amulet = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			amulet = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			amulet = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'
	return amulet

/datum/outfit/job/roguetown/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(!visualsOnly && H.real_name && !H.ai_controller)
		H.faction |= "[H.real_name]_faction"
	var/datum/patron/old_patron = H.patron
	if(length(allowed_patrons) && (!old_patron || !(old_patron.type in allowed_patrons)))
		var/list/datum/patron/possiblegods = list()
		var/list/datum/patron/preferredgods = list()
		for(var/god in GLOB.patronlist)
			if(!(god in allowed_patrons))
				continue
			possiblegods |= god
			var/datum/patron/PA = GLOB.patronlist[god]
			if(PA.associated_faith == old_patron.associated_faith) // prefer to pick a patron within the same faith before apostatizing
				preferredgods |= god
		if(length(preferredgods))
			H.set_patron(default_patron || pick(preferredgods))
		else
			H.set_patron(default_patron || pick(possiblegods))
		var/change_message = span_warning("[old_patron] had not endorsed my practices in my younger years. I've since grown accustomed to [H.patron].")
		if(H.client)
			to_chat(H, change_message)
		else
			// Characters during round start are first equipped before clients are moved into them. This is a bandaid to give an important piece of information correctly to the client
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, change_message), 5 SECONDS)
	if(H.mind)
		if(H.dna)
			if(H.dna.species)
				if(H.dna.species.name in list("Elf", "Half-Elf"))
					H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
				if(H.dna.species.name in list("Metal Construct"))
					H.adjust_skillrank(/datum/skill/craft/engineering, 2, TRUE)
	H.update_body()

/datum/outfit/job/roguetown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H.mind)
		if(H.ckey)
			H.mind?.job_bitflag = job_bitflag
			if(check_crownlist(H.ckey))
				H.mind.special_items["Champion Circlet"] = /obj/item/clothing/head/roguetown/crown/sparrowcrown
			give_special_items(H)
		// Ensure Wretches are granted their antagonist datum at post-equip
		if(H.mind.assigned_role == "Wretch" && !H.mind.has_antag_datum(/datum/antagonist/wretch))
			H.mind.add_antag_datum(/datum/antagonist/wretch)

	for(var/list_key in SStriumphs.post_equip_calls)
		var/datum/triumph_buy/thing = SStriumphs.post_equip_calls[list_key]
		thing.on_activate(H)
	if(has_loadout && H.mind)
		addtimer(CALLBACK(src, PROC_REF(run_loadout_and_finalize), H), 50)
	return

/datum/outfit/job/roguetown/proc/run_loadout_and_finalize(mob/living/carbon/human/H)
	if(!H?.client)
		return
	choose_loadout(H)
	// Re-evaluate the readyup repair kit now that loadout-based armor traits (if any) have been applied.
	// Late joiners skip the readyup bonus entirely, so only refresh the kit when one was actually granted.
	if(H?.mind && (H.mind.special_items["Fabric Patch (Repair kit)"] || H.mind.special_items["Metal Scrap (Repair kit)"]))
		var/datum/job/J = SSjob.GetJob(H.mind.assigned_role)
		J?.set_readyup_repair_kit(H)

/datum/outfit/job/roguetown/proc/choose_loadout(mob/living/carbon/human/H)
	if(!has_loadout)
		return
