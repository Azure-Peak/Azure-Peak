/mob/var/tmp/busy_summoning_familiar = FALSE

/datum/action/cooldown/spell/find_familiar
	name = "Find Familiar"
	desc = "Summon a loyal magical companion to aid you in your adventures. Reusing the spell with an active familiar can awaken its sentience."
	button_icon_state = "null"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Appare, spiritus fidus.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 0

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/mob/living/simple_animal/pet/familiar/fam
	var/familiars = list()

/datum/action/cooldown/spell/find_familiar/New(Target)
	. = ..()
	familiars = GLOB.familiar_types.Copy()

/datum/action/cooldown/spell/find_familiar/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/user = owner
	if(!istype(user))
		return FALSE

	if(istype(get_area(user), /area/rogue/indoors/ravoxarena))
		to_chat(user, span_userdanger("I reach for outer help, but something rebukes me! This challenge is only for me to overcome!"))
		return FALSE

	if(user.busy_summoning_familiar)
		to_chat(user, span_warning("You are already attempting to summon a familiar! Please wait for your current summon to resolve."))
		return FALSE

	user.busy_summoning_familiar = TRUE

	for(var/mob/living/simple_animal/pet/familiar/existing_fam in GLOB.alive_mob_list + GLOB.dead_mob_list)
		if(existing_fam.familiar_summoner == user)
			if(existing_fam.health <= 0)
				var/choice = input(user, "Your familiar is dead. What do you want to do?") as null|anything in list("Revive with magic stone", "Free them")
				if(choice == "Revive with magic stone")
					to_chat(user, span_notice("You will need a magical stone in your active hand to attempt resurrection."))
					var/obj/item/natural/stone/magic_stone = user.get_active_held_item()
					if(!istype(magic_stone, /obj/item/natural/stone) || magic_stone.magic_power < 1)
						to_chat(user, span_warning("You need to be holding a magical stone in your active hand!"))
						user.busy_summoning_familiar = FALSE
						return FALSE
					else
						revive_familiar(magic_stone, existing_fam, user)
						if(existing_fam.buff_given)
							user.apply_status_effect(existing_fam.buff_given)
						user.busy_summoning_familiar = FALSE
						return TRUE
				else if(choice == "Free them")
					free_familiar(existing_fam, user)
					if(!existing_fam?.mind)
						log_game("[key_name(user)] has released their familiar: [existing_fam.name] ([existing_fam.type])")
					else
						log_game("[key_name(user)] released sentient familiar [key_name(existing_fam)] ([existing_fam.type])")
					user.busy_summoning_familiar = FALSE
					return FALSE
				else
					user.busy_summoning_familiar = FALSE
					return FALSE
			else
				var/choice = input(user, "You already have a familiar. Do you want to free them?") as null|anything in list("Yes", "No")
				if(choice != "Yes")
					user.busy_summoning_familiar = FALSE
					return FALSE
				free_familiar(existing_fam, user)
				if(!existing_fam?.mind)
					log_game("[key_name(user)] has released their familiar: [existing_fam.name] ([existing_fam.type])")
				else
					log_game("[key_name(user)] released sentient familiar [key_name(existing_fam)] ([existing_fam.type])")
				user.busy_summoning_familiar = FALSE
				return FALSE

	var/turf/spawn_turf = get_step(user, user.dir)
	if(!isturf(spawn_turf) || !isopenturf(spawn_turf))
		to_chat(user, span_warning("There is not enough space to summon your familiar."))
		user.busy_summoning_familiar = FALSE
		return FALSE

	var/path_choice = input(user, "How do you want to summon your familiar?") as null|anything in list(
		"Summon from registered familiars",
		"Summon a non-sentient familiar"
	)

	if(path_choice == "Summon from registered familiars")
		var/list/candidates = list()

		for(var/client/c_client in GLOB.familiar_queue)
			var/datum/familiar_prefs/pref = c_client.prefs?.familiar_prefs
			if(pref && familiars)
				for(var/fam_type in familiars)
					if(ispath(pref.familiar_specie, familiars[fam_type]))
						candidates += c_client
						break

		if(!candidates.len)
			to_chat(user, span_notice("There is no familiar candidate you could summon."))
			user.busy_summoning_familiar = FALSE
			return FALSE

		while(TRUE)
			var/list/name_map = list()
			for(var/client/c_candidate in candidates)
				var/datum/familiar_prefs/pref = c_candidate.prefs?.familiar_prefs
				if(pref?.familiar_name)
					name_map[pref.familiar_name] = list("client" = c_candidate, "pref" = pref)

			var/choice = input(user, "Choose a registered familiar to inspect:") as null|anything in name_map
			if(!choice)
				user.busy_summoning_familiar = FALSE
				return FALSE

			var/entry = name_map[choice]
			var/client/target = entry["client"]
			var/datum/familiar_prefs/pref = entry["pref"]

			if(!pref)
				to_chat(user, span_warning("That familiar is no longer available."))
				GLOB.familiar_queue -= target
				continue

			show_familiar_preview(user, pref)

			var/confirm = input(user, "Summon this familiar?") as null|anything in list("Yes", "No")
			if(confirm != "Yes")
				winset(user.client, "Familiar Inspect", "is-visible=false")
				continue

			if(!target || (!isobserver(target.mob) && !isnewplayer(target.mob)))
				to_chat(user, span_warning("That familiar is no longer available."))
				user.busy_summoning_familiar = FALSE
				GLOB.familiar_queue -= target
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
					return FALSE
				else
					to_chat(user, span_notice("The familiar took too long to answer your summon, the magic is spent."))
					user.busy_summoning_familiar = FALSE
					return FALSE

	if(path_choice == "Summon a non-sentient familiar")
		var/familiarchoice = input("Choose your familiar", "Available familiars") as anything in familiars
		var/mob/living/simple_animal/pet/familiar/familiar_type = familiars[familiarchoice]
		var/mob/living/simple_animal/pet/familiar/new_fam = new familiar_type(spawn_turf)
		new_fam.familiar_summoner = user
		user.visible_message(span_notice("[new_fam.summoning_emote]"))
		new_fam.fully_replace_character_name(null, "[user.real_name]'s familiar")
		var/faction_to_add = "[user.mind.current.real_name]_faction"
		new_fam.faction |= faction_to_add
		log_game("[key_name(user)] summoned non-sentient familiar of type [familiar_type]")
		user.busy_summoning_familiar = FALSE
		if(new_fam.buff_given)
			user.apply_status_effect(new_fam.buff_given)
		return TRUE
	else
		user.busy_summoning_familiar = FALSE
		return FALSE

/proc/show_familiar_preview(mob/user, datum/familiar_prefs/pref)
	if(!pref)
		return

	var/list/dat = list()
	var/title = pref.familiar_name ? pref.familiar_name : "Unnamed Familiar"

	dat += "<div align='center'><font size=5 color='#dddddd'><b>[title]</b></font></div>"

	var/specie_type = GLOB.familiar_display_names[pref.familiar_specie]
	dat += "<div align='center'><font size=4 color='#bbbbbb'>[specie_type]</font></div>"

	var/list/pronoun_display = list(
		HE_HIM = "he/him",
		SHE_HER = "she/her",
		THEY_THEM = "they/them",
		IT_ITS = "it/its"
	)
	var/selected_pronoun = pronoun_display[pref.familiar_pronouns] ? pronoun_display[pref.familiar_pronouns] : "they/them"
	dat += "<div align='center'><font size=3 color='#bbbbbb'>[selected_pronoun]</font></div>"

	if(valid_headshot_link(null, pref.familiar_headshot_link, TRUE))
		dat += "<div align='center'><img src='[pref.familiar_headshot_link]' width='325px' height='325px'></div>"

	if(pref.familiar_flavortext_display)
		dat += "<div align='left'>[pref.familiar_flavortext_display]</div>"

	if(pref.familiar_ooc_notes_display)
		dat += "<br><div align='center'><b>OOC notes</b></div>"
		dat += "<div align='left'>[pref.familiar_ooc_notes_display]</div>"

	if(pref.familiar_ooc_extra)
		dat += pref.familiar_ooc_extra

	var/datum/browser/popup = new(user, "Familiar Inspect", nwidth = 600, nheight = 800)
	popup.set_content(dat.Join("\n"))
	popup.open(FALSE)

/proc/free_familiar(mob/living/simple_animal/pet/familiar/fam, mob/living/carbon/user)
	if(QDELETED(fam))
		to_chat(user, span_warning("The familiar is already gone."))
		return
	to_chat(user, span_warning("You feel your link with [fam.name] break."))
	to_chat(fam, span_warning("You feel your link with [user.name] break, you are free."))

	fam.familiar_summoner = null
	if(fam.buff_given)
		user.remove_status_effect(fam.buff_given)

	user.mind?.RemoveSpell(/datum/action/cooldown/spell/message_familiar)
	fam.mind?.RemoveSpell(/datum/action/cooldown/spell/message_summoner)

	if(!fam.mind)
		var/exit_msg
		if(isdead(fam))
			exit_msg = "[fam.name]'s corpse vanishes in a puff of smoke."
		else
			exit_msg = "[fam.name] looks in the direction of [user.name] one last time, before opening a portal and vanishing into it."

		fam.visible_message(span_warning(exit_msg))
		qdel(fam)

/proc/spawn_familiar_for_player(mob/chosen_one, mob/living/carbon/user)
	if(!chosen_one || !user)
		return

	if(isnewplayer(chosen_one))
		var/mob/dead/new_player/new_chosen = chosen_one
		new_chosen.close_spawn_windows()

	var/client/client_ref = chosen_one.client
	if(!client_ref || !client_ref.prefs)
		to_chat(user, span_warning("Familiar summoning failed: The target has no preferences or is invalid."))
		return

	var/datum/familiar_prefs/prefs = client_ref.prefs.familiar_prefs
	if(!prefs || !prefs.familiar_specie)
		to_chat(user, span_warning("Familiar summoning failed: The target has no valid familiar form."))
		return

	var/turf/spawn_turf = get_step(user, user.dir)
	var/mob/living/simple_animal/pet/familiar/awakener = new prefs.familiar_specie(spawn_turf)
	if(!awakener)
		to_chat(user, span_warning("Familiar summoning failed: Could not create familiar."))
		return

	awakener.familiar_summoner = user
	awakener.fully_replace_character_name(null, prefs.familiar_name)
	awakener.pronouns = prefs.familiar_pronouns

	user.visible_message(span_notice("[awakener.summoning_emote]"))

	if(awakener.buff_given)
		user.apply_status_effect(awakener.buff_given)

	if(!chosen_one.mind)
		to_chat(user, span_warning("Familiar summoning failed: Target has no mind to transfer."))
		qdel(awakener)
		return

	if(chosen_one.ckey)
		awakener.ckey = chosen_one.ckey

	var/datum/mind/mind_datum = awakener.mind
	if(!mind_datum)
		to_chat(user, span_warning("Familiar summoning failed: Mind transfer failed."))
		qdel(awakener)
		return

	mind_datum.RemoveAllSpells()
	mind_datum.AddSpell(new /datum/action/cooldown/spell/message_summoner())
	user.mind?.AddSpell(new /datum/action/cooldown/spell/message_familiar())

	if(awakener.inherent_spell)
		for(var/spell_path in awakener.inherent_spell)
			if(ispath(spell_path))
				var/obj/effect/proc_holder/spell/spell_instance = new spell_path
				if(spell_instance)
					mind_datum.AddSpell(spell_instance)

	awakener.can_have_ai = FALSE
	awakener.AIStatus = AI_OFF
	awakener.stop_automated_movement = TRUE
	awakener.stop_automated_movement_when_pulled = TRUE
	awakener.wander = FALSE

	var/faction_to_add = "[user.mind.current.real_name]_faction"
	awakener.faction |= faction_to_add

	log_game("[key_name(user)] has summoned [key_name(chosen_one)] as familiar '[awakener.name]' ([awakener.type]).")

/datum/action/cooldown/spell/message_familiar
	name = "Message Familiar"
	desc = "Whisper a message in your Familiar's head."
	button_icon_state = "message"

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/message_familiar/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	var/mob/living/simple_animal/pet/familiar/familiar
	for(var/mob/living/simple_animal/pet/familiar/familiar_check in GLOB.player_list)
		if(familiar_check.familiar_summoner == user)
			familiar = familiar_check
	if(!familiar || !familiar.mind)
		to_chat(user, "You cannot sense your familiar's mind.")
		return FALSE
	var/message = input(user, "You make a connection. What are you trying to say?")
	if(!message)
		return FALSE
	to_chat_immediate(familiar, "Arcane whispers fill the back of my head, resolving into [user]'s voice: <font color=#7246ff>[message]</font>")
	user.visible_message("[user] mutters an incantation and their mouth briefly flashes white.")
	user.whisper(message)
	log_game("[key_name(user)] sent a message to [key_name(familiar)] with contents [message]")
	return TRUE

/proc/revive_familiar(obj/item/natural/stone/magic_stone, mob/living/simple_animal/pet/familiar/fam, mob/living/carbon/user)
	if(fam.revive(full_heal = TRUE, admin_revive = TRUE))
		to_chat(user, span_notice("You channel the stone's magic into [fam.name], reviving them!"))
		qdel(magic_stone)
		fam.grab_ghost(force = TRUE)
		fam.familiar_summoner = user
		fam.visible_message(span_notice("[fam.name] is restored to life by [user]'s magic!"))
		return TRUE
