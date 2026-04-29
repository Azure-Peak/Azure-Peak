#ifndef RESIDENT_DOCUMENT_SEALS_INCLUDED
#define RESIDENT_DOCUMENT_SEALS_INCLUDED

/// Authority rules for the Resident Manuscript seal stamps.
///
/// Each rule binds a seal `key` (matching the keys used in document profiles
/// and on TGUI side) to:
///   - human-readable `title` / `stamper` (used as fallback display, the
///     frontend can override per-locale via texts.seals[key]);
///   - the `job_types` / `advclass_types` that are allowed to stamp it;
///   - a `priority` value that defines the seal hierarchy (higher = stronger);
///   - an optional `allowed_statuses` list that restricts which document
///     owner statuses the seal can be applied to (e.g. the Duke seal is only
///     valid on noble documents).
///
/// Downstream modules add new seals by defining a new subtype: the registry
/// below is built from `subtypesof()` and picks up new rules automatically.

/datum/resident_manuscript_seal_rule
	var/key
	var/title
	var/stamper
	var/list/job_types
	var/list/advclass_types
	var/priority = 0
	/// If set, the seal can only be applied to documents whose owner_status_key
	/// matches one of the listed statuses. null/empty = any status.
	var/list/allowed_statuses

/datum/resident_manuscript_seal_rule/proc/can_stamp(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	var/datum/job/job = SSjob.GetJob(user.mind?.assigned_role)
	for(var/job_type in job_types)
		if(istype(job, job_type))
			return TRUE
	var/datum/advclass/advclass
	if(user.advjob)
		advclass = SSrole_class_handler.get_advclass_by_name(user.advjob)
	for(var/advclass_type in advclass_types)
		if(istype(advclass, advclass_type))
			return TRUE
	return FALSE

/datum/resident_manuscript_seal_rule/proc/can_apply_to_status(status_key)
	if(!LAZYLEN(allowed_statuses))
		return TRUE
	return status_key in allowed_statuses

/datum/resident_manuscript_seal_rule/elder
	key = "elder"
	title = "Elder"
	stamper = "Elder"
	advclass_types = list(/datum/advclass/elder)
	priority = RESIDENT_SEAL_PRIORITY_ELDER

/datum/resident_manuscript_seal_rule/chancellor
	key = "chancellor"
	title = "Chancellor"
	stamper = "Chancellor"
	job_types = list(/datum/job/roguetown/councillor)
	priority = RESIDENT_SEAL_PRIORITY_CHANCELLOR

/datum/resident_manuscript_seal_rule/hand
	key = "hand"
	title = "Hand"
	stamper = "Hand"
	job_types = list(/datum/job/roguetown/hand)
	priority = RESIDENT_SEAL_PRIORITY_HAND

/datum/resident_manuscript_seal_rule/ruler
	key = "ruler"
	title = "Duke"
	stamper = "Duke"
	job_types = list(/datum/job/roguetown/lord)
	priority = RESIDENT_SEAL_PRIORITY_RULER
	allowed_statuses = list(RESIDENT_MANUSCRIPT_STATUS_NOBLE)

/datum/resident_manuscript_seal_rule/sergeant
	key = "sergeant"
	title = "Sergeant"
	stamper = "Sergeant of the Watch"
	job_types = list(/datum/job/roguetown/sergeant)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_LOW

/datum/resident_manuscript_seal_rule/marshal
	key = "marshal"
	title = "Marshal"
	stamper = "Marshal"
	job_types = list(/datum/job/roguetown/marshal)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/bishop
	key = "bishop"
	title = "Bishop"
	stamper = "Bishop"
	job_types = list(/datum/job/roguetown/priest)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/guild_leader
	key = "guild_leader"
	title = "Guild Leader"
	stamper = "Guild Leader"
	advclass_types = list(/datum/advclass/guildmaster)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/inquisitor
	key = "inquisitor"
	title = "Inquisitor"
	stamper = "Inquisitor"
	job_types = list(/datum/job/roguetown/inquisitor)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/court_magician
	key = "court_magician"
	title = "Court Magician"
	stamper = "Court Magician"
	job_types = list(/datum/job/roguetown/magician)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/merchant_master
	key = "merchant_master"
	title = "Merchant Master"
	stamper = "Merchant Master"
	job_types = list(/datum/job/roguetown/merchant)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/innkeeper
	key = "innkeeper"
	title = "Innkeep"
	stamper = "Innkeep"
	job_types = list(/datum/job/roguetown/innkeeper)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_LOW

/datum/resident_manuscript_seal_rule/bathmaster
	key = "bathmaster"
	title = "Bathmaster"
	stamper = "Bathmaster"
	job_types = list(/datum/job/roguetown/bathmaster)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_LOW

/proc/get_resident_manuscript_seal_rules()
	var/static/list/seal_rules
	if(!seal_rules)
		seal_rules = list()
		for(var/rule_type in subtypesof(/datum/resident_manuscript_seal_rule))
			var/datum/resident_manuscript_seal_rule/rule = rule_type
			var/key = initial(rule.key)
			if(!key)
				continue
			seal_rules[key] = rule_type
	return seal_rules

#endif
