/mob/var/tmp/busy_summoning_familiar = FALSE

/obj/effect/proc_holder/spell/self/findfamiliar
	name = "Find Familiar"
	desc = "Summon a loyal magical companion to aid you in your adventures. Reusing the spell with an active familiar can awaken its sentience."
	overlay_state = "null"
	sound = list('sound/magic/whiteflame.ogg')
	active = FALSE

	recharge_time = 5 SECONDS
	chargetime = 2 SECONDS

	warnie = "spellwarning"

	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

	xp_gain = TRUE
	spell_tier = 1
	cost = 0

	invocations = list("Appare, spiritus fidus.")
	invocation_type = "whisper"

	var/mob/living/simple_animal/pet/familiar/fam
	var/familiars = list()

/obj/effect/proc_holder/spell/self/findfamiliar/Initialize()
	. = ..()
	familiars = GLOB.familiar_types.Copy()


/obj/effect/proc_holder/spell/self/findfamiliar/cast(list/targets, mob/living/carbon/user)
	if (!user)
		return FALSE

	// Prevent multiple simultaneous summon attempts
	if (user.busy_summoning_familiar)
		to_chat(user, span_warning("You are already attempting to summon a familiar! Please wait for your current summon to resolve."))
		return FALSE

	user.busy_summoning_familiar = TRUE

	. = ..()

	// Check if user already has a familiar
	for (var/mob/living/simple_animal/pet/familiar/fam in GLOB.alive_mob_list + GLOB.dead_mob_list)
		if (fam.familiar_summoner == user)
			if(fam.health <= 0)
				var/choice = input(user, "Your familiar is dead. What do you want to do?") as null|anything in list("Revive with magic stone", "Free them")
				if(choice == "Revive with magic stone")
					to_chat(user, span_notice("You will need a magical stone in your active hand to attempt resurrection."))
					var/obj/item/natural/stone/magic_stone = user.get_active_held_item()
					if(!istype(magic_stone, /obj/item/natural/stone) || magic_stone.magic_power < 1)
						to_chat(user, span_warning("You need to be holding a magical stone in your active hand!"))
						user.busy_summoning_familiar = FALSE
						revert_cast()
						return FALSE
					else
						revive_familiar(magic_stone, fam, user)
						if (fam.buff_given)
							user.apply_status_effect(fam.buff_given)
						user.busy_summoning_familiar = FALSE
						return TRUE
				else if(choice == "Free them")
					free_familiar(fam, user)
					if(!fam?.mind)
						log_game("[key_name(user)] has released their familiar: [fam.name] ([fam.type])")
					else
						log_game("[key_name(user)] released sentient familiar [key_name(fam)] ([fam.type])")
					user.busy_summoning_familiar = FALSE
					revert_cast()
					return FALSE
				else // Cancel
					user.busy_summoning_familiar = FALSE
					revert_cast()
					return FALSE
			else
				var/choice = input(user, "You already have a familiar. Do you want to free them?") as null|anything in list("Yes", "No")
				if (choice != "Yes")
					user.busy_summoning_familiar = FALSE
					revert_cast()
					return FALSE
				free_familiar(fam, user)
				if(!fam?.mind)
					log_game("[key_name(user)] has released their familiar: [fam.name] ([fam.type])")
				else
					log_game("[key_name(user)] released sentient familiar [key_name(fam)] ([fam.type])")
				user.busy_summoning_familiar = FALSE
				revert_cast()
				return FALSE

	// Check for valid spawn turf before spawning familiar
	var/turf/spawn_turf = get_step(user, user.dir)
	if (!isturf(spawn_turf) || !isopenturf(spawn_turf))
		to_chat(user, span_warning("There is not enough space to summon your familiar."))
		revert_cast()
		user.busy_summoning_familiar = FALSE
		return FALSE

	// Ask how the user wants to summon
	var/path_choice = input(user, "How do you want to summon your familiar?") as null|anything in list(
		"Summon from registered familiars",
		"Summon a non-sentient familiar"
	)

	if (path_choice == "Summon from registered familiars")
		var/list/candidates = list()

		// Build list of valid candidate clients
		for (var/client/c_client in GLOB.familiar_queue)
			var/datum/familiar_prefs/pref = c_client.prefs?.familiar_prefs
			if (pref && familiars)
				for (var/fam_type in familiars)
					if (ispath(pref.familiar_specie, familiars[fam_type]))
						candidates += c_client
						break

		if (!candidates.len)
			to_chat(user, span_notice("There is no familiar candidate you could summon."))
			user.busy_summoning_familiar = FALSE
			revert_cast()
			return FALSE

		while (TRUE)
			var/list/name_map = list()
			for (var/client/c_candidate in candidates)
				var/datum/familiar_prefs/pref = c_candidate.prefs?.familiar_prefs
				if (pref?.familiar_name)
					name_map[pref.familiar_name] = list("client" = c_candidate, "pref" = pref)

			var/choice = input(user, "Choose a registered familiar to inspect:") as null|anything in name_map
			if (!choice)
				user.busy_summoning_familiar = FALSE
				revert_cast()
				return FALSE

			var/entry = name_map[choice]
			var/client/target = entry["client"]
			var/datum/familiar_prefs/pref = entry["pref"]

			if (!pref)
				to_chat(user, span_warning("That familiar is no longer available."))
				GLOB.familiar_queue -= target
				continue

			show_familiar_preview(user, pref)

			var/confirm = input(user, "Summon this familiar?") as null|anything in list("Yes", "No")
			if (confirm != "Yes")
				winset(user.client, "Familiar Inspect", "is-visible=false")
				continue

			// Check that target is valid
			if (!target || (!isobserver(target.mob) && !isnewplayer(target.mob)))
				to_chat(user, span_warning("That familiar is no longer available."))
				user.busy_summoning_familiar = FALSE
				GLOB.familiar_queue -= target
				revert_cast()
				return FALSE

			switch(askuser(target.mob, "[user.real_name] is trying to summon you as a familiar. Do you accept?", "Please answer in [DisplayTimeText(200)]!", "Yes", "No", StealFocus=0, Timeout=200))
				if(1)
					to_chat(target.mob, span_notice("You are [user.real_name]'s magical familiar, you are magically contracted to help them, yet you still have a self preservation instinct."))
					GLOB.familiar_queue -= target
					spawn_familiar_for_player(target.mob, user)
					log_game("[user.ckey] summoned [pref.familiar_name] ([pref.familiar_specie]) controlled by [target.ckey]")
					if(target && target.mob)
						winset(target.mob, "Be a Familiar", "is-visible=false")
					user.busy_summoning_familiar = FALSE
					return TRUE
				if(2)
					to_chat(target.mob, span_notice("Choice registered: No."))
					to_chat(user, span_notice("The familiar resisted your summon."))
					user.busy_summoning_familiar = FALSE
					revert_cast()
					return FALSE
				else
					to_chat(user, span_notice("The familiar took too long to answer your summon, the magic is spent."))
					user.busy_summoning_familiar = FALSE
					revert_cast()
					return FALSE

	if(path_choice == "Summon a non-sentient familiar")
		// Non-sentient familiar summoning
		var/familiarchoice = input("Choose your familiar", "Available familiars") as anything in familiars
		var/mob/living/simple_animal/pet/familiar/familiar_type = familiars[familiarchoice]
		var/mob/living/simple_animal/pet/familiar/fam = new familiar_type(spawn_turf)
		fam.familiar_summoner = user
		user.visible_message(span_notice("[fam.summoning_emote]"))
		fam.fully_replace_character_name(null, "[user.real_name]'s familiar")
		var/faction_to_add = "[user.mind.current.real_name]_faction" //Should stop necromancer's skellies from murdering the necromancer's pet.
		fam.faction |= faction_to_add
		log_game("[key_name(user)] summoned non-sentient familiar of type [familiar_type]")
		user.busy_summoning_familiar = FALSE
		if (fam.buff_given)
			user.apply_status_effect(fam.buff_given)
		return TRUE
	else
		user.busy_summoning_familiar = FALSE
		revert_cast()
		return FALSE

///Used to show a preview of the prospective familiar's inspect window to the summoner.
/proc/show_familiar_preview(mob/user, datum/familiar_prefs/pref)
	if (!pref)
		return

	var/list/dat = list()
	var/title = pref.familiar_name ? pref.familiar_name : "Unnamed Familiar"

	dat += "<div align='center'><font size=5 color='#dddddd'><b>[title]</b></font></div>"

	// Add species name below the title, centered
	var/specie_type = GLOB.familiar_display_names[pref.familiar_specie]
	dat += "<div align='center'><font size=4 color='#bbbbbb'>[specie_type]</font></div>"

	// Add pronouns below species name
	var/list/pronoun_display = list(
		HE_HIM = "he/him",
		SHE_HER = "she/her",
		THEY_THEM = "they/them",
		IT_ITS = "it/its"
	)
	var/selected_pronoun = pronoun_display[pref.familiar_pronouns] ? pronoun_display[pref.familiar_pronouns] : "they/them"
	dat += "<div align='center'><font size=3 color='#bbbbbb'>[selected_pronoun]</font></div>"

	if (valid_headshot_link(null, pref.familiar_headshot_link, TRUE))
		dat += "<div align='center'><img src='[pref.familiar_headshot_link]' width='325px' height='325px'></div>"

	if (pref.familiar_flavortext_display)
		dat += "<div align='left'>[pref.familiar_flavortext_display]</div>"

	if (pref.familiar_ooc_notes_display)
		dat += "<br><div align='center'><b>OOC notes</b></div>"
		dat += "<div align='left'>[pref.familiar_ooc_notes_display]</div>"

	if (pref.familiar_ooc_extra)
		dat += pref.familiar_ooc_extra

	var/datum/browser/popup = new(user, "Familiar Inspect", nwidth = 600, nheight = 800)
	popup.set_content(dat.Join("\n"))
	popup.open(FALSE)

///Used to free a familiar from its summoner.
/proc/free_familiar(mob/living/simple_animal/pet/familiar/fam, mob/living/carbon/user)
	if (QDELETED(fam))
		to_chat(user, span_warning("The familiar is already gone."))
		return
	to_chat(user, span_warning("You feel your link with [fam.name] break."))
	to_chat(fam, span_warning("You feel your link with [user.name] break, you are free."))

	fam.familiar_summoner = null
	if (fam.buff_given)
		user.remove_status_effect(fam.buff_given)

	user.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/message_familiar)
	fam.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/message_summoner)

	if (!fam.mind)
		var/exit_msg
		if (isdead(fam))
			exit_msg = "[fam.name]'s corpse vanishes in a puff of smoke."
		else
			exit_msg = "[fam.name] looks in the direction of [user.name] one last time, before opening a portal and vanishing into it."

		fam.visible_message(span_warning(exit_msg))
		qdel(fam)


/proc/spawn_familiar_for_player(mob/chosen_one, mob/living/carbon/user)
	if (!chosen_one || !user)
		return

	// Handle if the chosen one is a new player lobby mob
	if (isnewplayer(chosen_one))
		var/mob/dead/new_player/new_chosen = chosen_one
		new_chosen.close_spawn_windows()

	// Ensure the chosen one has a valid client and preferences
	var/client/client_ref = chosen_one.client
	if (!client_ref || !client_ref.prefs)
		to_chat(user, span_warning("Familiar summoning failed: The target has no preferences or is invalid."))
		return

	var/datum/familiar_prefs/prefs = client_ref.prefs.familiar_prefs
	if (!prefs || !prefs.familiar_specie)
		to_chat(user, span_warning("Familiar summoning failed: The target has no valid familiar form."))
		return

	// Spawn the familiar mob near the summoner
	var/turf/spawn_turf = get_step(user, user.dir)
	var/mob/living/simple_animal/pet/familiar/awakener = new prefs.familiar_specie(spawn_turf)
	if (!awakener)
		to_chat(user, span_warning("Familiar summoning failed: Could not create familiar."))
		return

	// Set summoner and name
	awakener.familiar_summoner = user
	awakener.fully_replace_character_name(null, prefs.familiar_name)
	awakener.pronouns = prefs.familiar_pronouns

	// Display summoning emote
	user.visible_message(span_notice("[awakener.summoning_emote]"))

	// Apply summoner's familiar buff
	if (awakener.buff_given)
		user.apply_status_effect(awakener.buff_given)

	// Transfer player's mind to the familiar
	if (!chosen_one.mind)
		to_chat(user, span_warning("Familiar summoning failed: Target has no mind to transfer."))
		qdel(awakener)
		return

	if (chosen_one.ckey)
		awakener.ckey = chosen_one.ckey

	var/datum/mind/mind_datum = awakener.mind
	if (!mind_datum)
		to_chat(user, span_warning("Familiar summoning failed: Mind transfer failed."))
		qdel(awakener)
		return

	// Clear existing spells, then grant familiar communication
	mind_datum.RemoveAllSpells()
	mind_datum.AddSpell(new /obj/effect/proc_holder/spell/self/message_summoner)
	user.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/message_familiar)

	// Add familiar's inherent spells
	if (awakener.inherent_spell)
		for (var/spell_path in awakener.inherent_spell)
			if (ispath(spell_path))
				var/obj/effect/proc_holder/spell/spell_instance = new spell_path
				if (spell_instance)
					mind_datum.AddSpell(spell_instance)

	// Disable automated/AI features
	awakener.can_have_ai = FALSE
	awakener.AIStatus = AI_OFF
	awakener.stop_automated_movement = TRUE
	awakener.stop_automated_movement_when_pulled = TRUE
	awakener.wander = FALSE

	var/faction_to_add = "[user.mind.current.real_name]_faction" //Should stop necromancer's skellies from murdering the necromancer's pet.
	awakener.faction |= faction_to_add

	// Admin/game logging
	log_game("[key_name(user)] has summoned [key_name(chosen_one)] as familiar '[awakener.name]' ([awakener.type]).")

/obj/effect/proc_holder/spell/self/message_familiar
	name = "Message Familiar"
	desc = "Whisper a message in your Familar's head."

/obj/effect/proc_holder/spell/self/message_familiar/cast(list/targets, mob/user)
	. = ..()
	var/mob/living/simple_animal/pet/familiar/familiar
	for(var/mob/living/simple_animal/pet/familiar/familiar_check in GLOB.player_list)
		if(familiar_check.familiar_summoner == user)
			familiar = familiar_check
	if(!familiar || !familiar.mind)
		revert_cast()
		to_chat(user, "You cannot sense your familiar's mind.")
		return
	var/message = input(user, "You make a connection. What are you trying to say?")
	if(!message)
		revert_cast()
		return
	to_chat_immediate(familiar, "Arcane whispers fill the back of my head, resolving into [user]'s voice: <font color=#7246ff>[message]</font>")
	user.visible_message("[user] mutters an incantation and their mouth briefly flashes white.")
	user.whisper(message)
	log_game("[key_name(user)] sent a message to [key_name(familiar)] with contents [message]")
	return TRUE

/proc/revive_familiar(obj/item/natural/stone/magic_stone, mob/living/simple_animal/pet/familiar/fam, mob/living/carbon/user)
    // Consume the stone
    to_chat(user, span_notice("You channel the stone's magic into [fam.name], reviving them!"))
    qdel(magic_stone)

    // Revive and fully heal the familiar
    fam.revive(full_heal = TRUE, admin_revive = TRUE)
    fam.familiar_summoner = user
    fam.visible_message(span_notice("[fam.name] is restored to life by [user]'s magic!"))

    return TRUE
