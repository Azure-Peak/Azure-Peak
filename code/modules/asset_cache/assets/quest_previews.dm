/// Quest preview spritesheet � bundles all kill-quest mob icons into one PNG + CSS.
///
/// Architecture:
///   - Generated synchronously in contractledger/LateInitialize() at world start.
///   - Falls back to lazy generation on first send()/ensure_ready() if ledger missing.
///   - send()/ensure_ready() block parent if sprites aren't ready (prevents Division by zero).
///   - generation_in_progress mutex prevents parallel runs; stale locks auto-reset on retry.
///
/// Icon sources by mob type:
///   simple_animal � static DMI icon; falls back to temp mob + getFlatIcon if state missing.
///   carbon/human � temp mob + after_creation (equips outfit) + image/appearance + getFlatIcon.
///     Each mob subtype gets its own sprite with unique equipment (randomized per server restart).
///   generic mob � temp mob + getFlatIcon.
///
/// After all inserts, icon cache is refreshed to prevent BYOND FIFO eviction (Division by zero).
/// Icons validated for >0 dimensions before Insert(). State name auto-detected for queuedInsert.
/datum/asset/spritesheet/quest_previews
	name = "quest_previews"
	cross_round_cachable = FALSE
	var/sprites_generated = FALSE
	var/generation_in_progress = FALSE

/datum/asset/spritesheet/quest_previews/create_spritesheets()
	return

/datum/asset/spritesheet/quest_previews/send(client/client)
	if(!sprites_generated)
		generation_in_progress = FALSE
		generate_quest_sprites()
	if(!sprites_generated)
		return
	return ..()

/datum/asset/spritesheet/quest_previews/ensure_ready()
	if(!sprites_generated)
		generation_in_progress = FALSE
		generate_quest_sprites()
	if(!sprites_generated)
		return
	return ..()

/datum/asset/spritesheet/quest_previews/proc/generate_quest_sprites()
	if(sprites_generated || generation_in_progress)
		return
	generation_in_progress = TRUE

	var/obj/structure/roguemachine/contractledger/ledger_ref = locate() in world
	if(!ledger_ref)
		generation_in_progress = FALSE
		return

	var/list/seen_sources = list()
	var/list/seen_types = list()
	var/inserted_count = 0

	for(var/contract_group in GLOB.global_quest_contract_groups)
		var/list/group_contract_types = GLOB.global_quest_contract_groups[contract_group] || list()
		for(var/contract_type in group_contract_types)
			if(contract_type in seen_types)
				continue
			seen_types += contract_type
			if(!(contract_type in list(QUEST_HUNT, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOSS)))
				continue

			var/datum/quest/quest_template = ledger_ref.create_quest_for_type(contract_type)
			if(!istype(quest_template, /datum/quest/kill))
				if(quest_template)
					qdel(quest_template)
				continue

			var/datum/quest/kill/kill_template = quest_template
			var/list/tier_choices = kill_template.get_tier_choices()
			for(var/tier_label in tier_choices)
				var/tier_value = tier_choices[tier_label]
				kill_template.requested_tier = tier_value
				var/list/candidate_pool = kill_template.get_candidate_target_pool()
				for(var/mob_type in candidate_pool)
					var/source = ledger_ref.get_preview_icon_source_mob_type(mob_type)
					if(seen_sources[source])
						continue
					seen_sources[source] = TRUE
					if(insert_quest_preview_sprite(ledger_ref, source))
						inserted_count++
					CHECK_TICK

			qdel(kill_template)

	if(!inserted_count)
		generation_in_progress = FALSE
		return

	for(var/size_id in sizes)
		var/list/size = sizes[size_id]
		if(size[2])
			size[2] = icon(size[2])

	unregister()
	fully_generated = FALSE
	realize_spritesheets(yield = FALSE)
	sprites_generated = TRUE
	generation_in_progress = FALSE

/datum/asset/spritesheet/quest_previews/proc/insert_quest_preview_sprite(obj/structure/roguemachine/contractledger/ledger_ref, atom/mob_type)
	var/sprite_name = quest_preview_sprite_name(mob_type)
	if(!sprite_name)
		return FALSE

	var/icon/preview_icon

	if(ispath(mob_type, /mob/living/simple_animal))
		var/icon_file = initial(mob_type.icon)
		var/icon_state = ledger_ref.get_simple_animal_preview_icon_state(mob_type)
		if(icon_file && icon_state)
			var/list/available_states = ledger_ref.get_preview_icon_states(icon_file)
			if(islist(available_states) && (icon_state in available_states))
				preview_icon = ledger_ref.build_target_preview_icon(mob_type, icon_file, icon_state)
				if(!preview_icon)
					preview_icon = icon(icon_file, icon_state, SOUTH, 1)
		if(!preview_icon)
			var/turf/preview_turf = locate(1, 1, 1)
			if(!preview_turf)
				preview_turf = get_turf(ledger_ref)
			if(preview_turf)
				var/mob/temp_mob = new mob_type(preview_turf)
				if(temp_mob)
					temp_mob.setDir(SOUTH)
					var/icon/flattened = getFlatIcon(temp_mob, SOUTH, no_anim = TRUE)
					preview_icon = flattened ? icon(flattened, frame = 1) : null
					qdel(temp_mob)

	else if(ispath(mob_type, /mob/living/carbon/human))
		var/turf/preview_turf = locate(1, 1, 1)
		if(!preview_turf)
			preview_turf = get_turf(ledger_ref)
		if(!preview_turf)
			return FALSE
		var/mob/living/carbon/human/temp_mob = new mob_type(preview_turf)
		if(!temp_mob)
			return FALSE
		temp_mob.setDir(SOUTH)
		ledger_ref.finalize_outlaw_preview_mob(temp_mob)
		preview_icon = ledger_ref.build_outlaw_runtime_preview_icon(temp_mob)
		if(!preview_icon)
			// Appearance technique failed � try static DMI as fallback
			var/icon_file = initial(mob_type.icon)
			var/icon_state = initial(mob_type.icon_state)
			if(icon_file && icon_state)
				preview_icon = icon(icon_file, icon_state, SOUTH, 1)
		qdel(temp_mob)

	else if(ispath(mob_type, /mob))
		var/turf/preview_turf = locate(1, 1, 1)
		if(!preview_turf)
			preview_turf = get_turf(ledger_ref)
		if(!preview_turf)
			return FALSE
		var/mob/temp_mob = new mob_type(preview_turf)
		if(!temp_mob)
			return FALSE
		temp_mob.setDir(SOUTH)
		ledger_ref.finalize_preview_mob(temp_mob)
		var/icon/flattened = getFlatIcon(temp_mob, SOUTH, no_anim = TRUE)
		preview_icon = flattened ? icon(flattened, frame = 1) : null
		qdel(temp_mob)

	if(!preview_icon)
		return FALSE

	preview_icon = ledger_ref.fit_preview_icon_to_square(preview_icon, 64)
	if(!preview_icon)
		return FALSE
	if(preview_icon.Width() <= 0 || preview_icon.Height() <= 0)
		return FALSE

	var/list/preview_states = icon_states(preview_icon)
	var/insert_state = length(preview_states) ? preview_states[1] : ""
	Insert(sprite_name, preview_icon, insert_state)
	return TRUE

/proc/quest_preview_sprite_name(mob_type)
	if(!ispath(mob_type))
		return null
	return "quest_mob_[sanitize_css_class_name("[mob_type]")]"