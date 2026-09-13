#define QUIRK_LANGUAGE		(1<<0)
#define QUIRK_BEHAVIOR		(1<<1)
#define QUIRK_ENVIRONMENT	(1<<2)
#define QUIRK_INTERACT		(1<<3)

GLOBAL_LIST_EMPTY(all_flesh_aspects)
GLOBAL_LIST_EMPTY(all_flesh_archetypes)
GLOBAL_LIST_EMPTY(all_flesh_traits)
GLOBAL_LIST_EMPTY(all_flesh_quirks)

/proc/get_global_aspects()
	if(!GLOB.all_flesh_aspects || !GLOB.all_flesh_aspects.len)
		initialize_global_aspects()
	return GLOB.all_flesh_aspects

/proc/get_global_archetypes()
	if(!GLOB.all_flesh_archetypes || !GLOB.all_flesh_archetypes.len)
		initialize_global_aspects()
	return GLOB.all_flesh_archetypes

/proc/get_global_traits()
	if(!GLOB.all_flesh_traits || !GLOB.all_flesh_traits.len)
		initialize_global_aspects()
	return GLOB.all_flesh_traits

/proc/get_global_quirks()
	if(!GLOB.all_flesh_quirks || !GLOB.all_flesh_quirks.len)
		initialize_global_aspects()
	return GLOB.all_flesh_quirks

/proc/initialize_global_aspects()
	var/list/archetype_types = list(
		/datum/flesh_archetype/fearful,
		/datum/flesh_archetype/authoritarian,
		/datum/flesh_archetype/aggressive,
		/datum/flesh_archetype/arbitrary,
		/datum/flesh_archetype/inquisitive,
		/datum/flesh_archetype/split_personality
	)

	for(var/atype in archetype_types)
		var/datum/flesh_archetype/archetype = new atype()
		GLOB.all_flesh_aspects[atype] = archetype
		GLOB.all_flesh_archetypes[atype] = archetype

	var/list/trait_types = list(
		/datum/flesh_trait/deception,
		/datum/flesh_trait/violent,
		/datum/flesh_trait/cautious,
		/datum/flesh_trait/observant,
		/datum/flesh_trait/peaceful,
		/datum/flesh_trait/creative,
		/datum/flesh_trait/curious,
		/datum/flesh_trait/ambitious,
		/datum/flesh_trait/logical,
		/datum/flesh_trait/honest,
		/datum/flesh_trait/orderly,
		/datum/flesh_trait/impulsive,
		/datum/flesh_trait/territorial,
		/datum/flesh_trait/dominant,
		/datum/flesh_trait/destructive,
		/datum/flesh_trait/playful,
		/datum/flesh_trait/chaotic,
		/datum/flesh_trait/philosophical,
		/datum/flesh_trait/analytical,
	)

	for(var/ttype in trait_types)
		var/datum/flesh_trait/trait = new ttype()
		GLOB.all_flesh_aspects[ttype] = trait
		GLOB.all_flesh_traits[ttype] = trait

	var/list/quirk_types = list(
		/datum/flesh_quirk/obedient,
		/datum/flesh_quirk/curious,
		/datum/flesh_quirk/impatient,
		/datum/flesh_quirk/royal,
		/datum/flesh_quirk/discharge,
		/datum/flesh_quirk/repetitive,
		/datum/flesh_quirk/timid,
		/datum/flesh_quirk/ambitious,
		/datum/flesh_quirk/forgetful,
		/datum/flesh_quirk/affectionate,
		/datum/flesh_quirk/territorial,
		/datum/flesh_quirk/mimic,
		/datum/flesh_quirk/stubborn,
		/datum/flesh_quirk/patient,
		/datum/flesh_quirk/hoarder,
	)

	for(var/qtype in quirk_types)
		var/datum/flesh_quirk/quirk = new qtype()
		GLOB.all_flesh_aspects[qtype] = quirk
		GLOB.all_flesh_quirks[qtype] = quirk
