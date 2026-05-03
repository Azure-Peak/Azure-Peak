/datum/magic_aspect
	var/name = "Aspect"
	var/latin_name = ""
	var/desc = "An arcyne discipline."
	var/aspect_type = ASPECT_MAJOR
	/// Appended to implements when attuned: "Fire" -> "Staff of Fire"
	var/attuned_name = ""
	// Always granted spells
	var/list/fixed_spells = list()
	/// Choice spells - pick exactly one. Granted FIRST (before fixed) so they appear first on the action bar.
	var/list/choice_spells = list()
	/// Pointbuy are optionals - for point buy aspect
	var/list/pointbuy_spells = list()
	var/pointbuy_budget = 0
	/// Named variant spell swaps. Assoc list: variant_name = list(base_path = replacement_path, ...)
	/// "mastery" is automatically applied for T4 casters.
	/// Other variants (e.g. "grenzelhoftian") are passed in via attune_aspect().
	var/list/variants = list()
	var/school_color
	/// Major: Latin, English, Latin. Minor: Latin, English.
	var/list/binding_chants = list()
	var/list/unbinding_chants = list()
	/// The choice spell that was actually picked during attunement. Set by grant_choice_spell().
	var/chosen_spell

/datum/magic_aspect/proc/get_implement_name(base_name)
	if(!attuned_name)
		return base_name
	return "[base_name] of [attuned_name]"

/// Grant a single choice spell. Called before grant_spells() so it appears first on the action bar.
/datum/magic_aspect/proc/grant_choice_spell(datum/mind/target, spell_path)
	if(!spell_path || !(spell_path in choice_spells))
		return
	chosen_spell = spell_path
	if(target.has_spell(spell_path))
		return
	var/datum/new_spell = new spell_path
	mark_aspect_spell(new_spell)
	target.AddSpell(new_spell)

/datum/magic_aspect/proc/grant_spells(datum/mind/target)
	var/list/granted = list()
	for(var/spell_path in fixed_spells)
		if(target.has_spell(spell_path))
			continue
		var/datum/new_spell = new spell_path
		mark_aspect_spell(new_spell)
		target.AddSpell(new_spell)
		granted += new_spell
	return granted

/// Apply a named variant's spell swaps. T4 casters automatically get "mastery".
/datum/magic_aspect/proc/apply_variant(datum/mind/target, variant_name)
	if(!variant_name || !length(variants) || !(variant_name in variants))
		return
	var/list/swaps = variants[variant_name]
	if(!length(swaps))
		return
	for(var/base_path in swaps)
		var/upgrade_path = swaps[base_path]
		if(base_path == VARIANT_ADDITIVE)
			// Additive mastery - grant new spell without removing anything
			var/datum/added = new upgrade_path
			mark_aspect_spell(added)
			target.AddSpell(added)
			continue
		var/datum/existing = target.get_spell(base_path)
		if(existing)
			// Find position in spell_list to preserve order
			var/spell_index = target.spell_list.Find(existing)
			target.RemoveSpell(existing)
			var/datum/upgraded = new upgrade_path
			// Tag the spell desc with variant name for display — don't change the name
			if(istype(upgraded, /datum/action/cooldown/spell))
				var/datum/action/cooldown/spell/S = upgraded
				S.desc = "[S.desc]\n<b>Variant:</b> [capitalize(variant_name)]"
			mark_aspect_spell(upgraded)
			// Insert at original position instead of appending
			if(spell_index && spell_index <= length(target.spell_list) + 1)
				target.spell_list.Insert(spell_index, upgraded)
				if(istype(upgraded, /datum/action/cooldown/spell))
					var/datum/action/cooldown/spell/S = upgraded
					S.Grant(target.current)
				else if(istype(upgraded, /obj/effect/proc_holder/spell))
					var/obj/effect/proc_holder/spell/S = upgraded
					S.action.Grant(target.current)
			else
				target.AddSpell(upgraded)

/// Revoke all spells granted by this aspect.
/// skip_spells: flat list of spell paths that should NOT be removed (granted by another source).
/datum/magic_aspect/proc/revoke_spells(datum/mind/target, list/skip_spells)
	for(var/spell_path in choice_spells)
		if(LAZYLEN(skip_spells) && (spell_path in skip_spells))
			continue
		var/datum/existing = target.get_spell(spell_path)
		if(existing)
			target.RemoveSpell(existing)
	for(var/spell_path in fixed_spells)
		if(LAZYLEN(skip_spells) && (spell_path in skip_spells))
			continue
		var/datum/existing = target.get_spell(spell_path)
		if(existing)
			target.RemoveSpell(existing)
	for(var/variant_name in variants)
		var/list/swaps = variants[variant_name]
		for(var/base_path in swaps)
			var/upgrade_path = swaps[base_path]
			if(LAZYLEN(skip_spells) && (upgrade_path in skip_spells))
				continue
			var/datum/existing = target.get_spell(upgrade_path)
			if(existing)
				target.RemoveSpell(existing)
	for(var/spell_path in pointbuy_spells)
		if(LAZYLEN(skip_spells) && (spell_path in skip_spells))
			continue
		var/datum/existing = target.get_spell(spell_path)
		if(existing)
			target.RemoveSpell(existing)

/datum/magic_aspect/proc/mark_aspect_spell(datum/spell_instance)
	if(istype(spell_instance, /obj/effect/proc_holder/spell))
		var/obj/effect/proc_holder/spell/S = spell_instance
		S.refundable = FALSE
		S.source_aspect = type
	else if(istype(spell_instance, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_instance
		S.refundable = FALSE
		S.source_aspect = type

/// Perform the binding or unbinding chant. Returns TRUE if completed, FALSE if interrupted.
/// Each line is spoken aloud with a 2-second do_after between them.
/datum/magic_aspect/proc/perform_chant(mob/living/chanter, binding = TRUE)
	var/list/chant_lines = binding ? binding_chants : unbinding_chants
	if(!length(chant_lines) || chant_lines[1] == "TODO")
		return TRUE
	for(var/line in chant_lines)
		chanter.say(line, forced = "spell", language = /datum/language/common)
		if(!do_after(chanter, 2 SECONDS, target = chanter))
			return FALSE
	return TRUE

GLOBAL_LIST_INIT(magic_aspects_major, init_magic_aspects(ASPECT_MAJOR))
GLOBAL_LIST_INIT(magic_aspects_minor, init_magic_aspects(ASPECT_MINOR))

/proc/init_magic_aspects(filter_type)
	var/list/result = list()
	for(var/path in subtypesof(/datum/magic_aspect))
		var/datum/magic_aspect/A = path
		if(initial(A.aspect_type) == filter_type)
			result += path
	return result
