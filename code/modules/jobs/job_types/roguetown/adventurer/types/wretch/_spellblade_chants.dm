GLOBAL_LIST_INIT_TYPED(spellblade_chants, /datum/spellblade_chant, build_spellblade_chants())
GLOBAL_LIST_INIT_TYPED(npc_spellblade_chants, /datum/spellblade_chant, build_spellblade_chants(TRUE))
/proc/build_spellblade_chants(include_npc_only = FALSE)
	. = list()
	for(var/path in subtypesof(/datum/spellblade_chant))
		if(is_abstract(path))
			continue
		var/datum/spellblade_chant/new_chant = new path
		if(new_chant.npc_only && !include_npc_only)
			continue
		.[new_chant.name] = new_chant

/datum/spellblade_chant
	abstract_type = /datum/spellblade_chant
	var/name
	var/npc_only = FALSE
	var/static/list/base_spells = list(
		/datum/action/cooldown/spell/recall_weapon,
		/datum/action/cooldown/spell/empower_weapon,
		/datum/action/cooldown/spell/bind_weapon,
		/datum/action/cooldown/spell/mending,
	)
	var/list/subclass_spells = list()

/datum/spellblade_chant/proc/chant_spells()
	return subclass_spells + base_spells

/datum/spellblade_chant/proc/add_spells(datum/mind/mind)
	for(var/spell in chant_spells())
		mind.AddSpell(new spell())

/datum/spellblade_chant/proc/apply_chant(mob/living/carbon/human/H)
	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = name
	if(H.mind)
		add_spells(H.mind)

/datum/spellblade_chant/blade
	name = "blade"
	subclass_spells = list(
		/datum/action/cooldown/spell/caedo,
		/datum/action/cooldown/spell/air_strike,
		/datum/action/cooldown/spell/leyline_anchor,
		/datum/action/cooldown/spell/blade_storm
	)

/datum/spellblade_chant/phalangite
	name = "phalangite"
	subclass_spells = list(
		/datum/action/cooldown/spell/azurean_phalanx,
		/datum/action/cooldown/spell/projectile/azurean_pilum,
		/datum/action/cooldown/spell/advance,
		/datum/action/cooldown/spell/gate_of_reckoning
	)

/datum/spellblade_chant/macebearer
	name = "macebearer"
	subclass_spells = list(
		/datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter,
		/datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor,
		/datum/action/cooldown/spell/charge,
		/datum/action/cooldown/spell/cataclysm
	)
