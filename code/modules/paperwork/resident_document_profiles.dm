/// Profile metadata for the Resident Manuscript framework.
/// One TGUI, one DM lifecycle. Profiles only carry id, theme colors, the
/// list of seal keys that are valid for this faction document, and policy
/// flags such as whether the document grants residency-claim rights.
/// Display strings are resolved on the frontend through `texts.profiles[id]`;
/// the DM-side raw values act as default labels for examine and admin spawn.

/// Role-to-document mapping for the Resident Manuscript framework.
///
/// Each rule binds a role-shape (job titles / job paths / advclasses / custom
/// `matches()` proc) to the document subtype that role should receive at
/// roundstart. Rules are evaluated in descending `priority` order; the first
/// rule whose `matches()` returns TRUE wins. Negative priority values make
/// good catch-all fallbacks.
///
/// Adding a new role document = adding a new subtype here. No editing of the
/// resolver chain required.

/datum/resident_document_role_rule
	var/document_type
	var/list/job_titles
	var/list/job_types
	var/list/advclass_types
	var/priority = 0

/datum/resident_document_role_rule/proc/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	if(!job_title)
		return FALSE
	if(LAZYLEN(job_titles) && (job_title in job_titles))
		return TRUE
	if(LAZYLEN(job_types))
		var/datum/job/job = SSjob.GetJob(job_title)
		for(var/job_type in job_types)
			if(istype(job, job_type))
				return TRUE
	if(LAZYLEN(advclass_types) && user.advjob)
		var/datum/advclass/advclass = SSrole_class_handler.get_advclass_by_name(user.advjob)
		for(var/advclass_type in advclass_types)
			if(istype(advclass, advclass_type))
				return TRUE
	return FALSE

/datum/resident_document_role_rule/merchant
	document_type = /obj/item/book/granter/resident_manuscript/merchant
	job_titles = list("Merchant")
	priority = 100

/datum/resident_document_role_rule/innkeeper
	document_type = /obj/item/book/granter/resident_manuscript/inn
	job_titles = list("Innkeeper")
	priority = 100

/datum/resident_document_role_rule/bathmaster
	document_type = /obj/item/book/granter/resident_manuscript/bathhouse
	job_titles = list("Bathmaster")
	priority = 100

/datum/resident_document_role_rule/mages
	document_type = /obj/item/book/granter/resident_manuscript/mages
	job_titles = list("Court Magician", "Magicians Associate")
	priority = 100

/datum/resident_document_role_rule/mercenary
	document_type = /obj/item/book/granter/resident_manuscript/mercenary
	job_titles = list("Mercenary")
	priority = 100

/datum/resident_document_role_rule/garrison
	document_type = /obj/item/book/granter/resident_manuscript/guards
	priority = 50

/datum/resident_document_role_rule/garrison/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	return job_title && (job_title in GLOB.garrison_positions)

/datum/resident_document_role_rule/church
	document_type = /obj/item/book/granter/resident_manuscript/church
	priority = 50

/datum/resident_document_role_rule/church/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	return job_title && (job_title in GLOB.church_positions)

/datum/resident_document_role_rule/inquisition
	document_type = /obj/item/book/granter/resident_manuscript/otava
	priority = 50

/datum/resident_document_role_rule/inquisition/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	return job_title && (job_title in GLOB.inquisition_positions)

/datum/resident_document_role_rule/craftsmen
	document_type = /obj/item/book/granter/resident_manuscript/craftsmen
	priority = 50

/datum/resident_document_role_rule/craftsmen/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	return job_title && (job_title in GLOB.burgher_positions)

/datum/resident_document_role_rule/noble_fallback
	document_type = /obj/item/book/granter/resident_manuscript/roundstart
	priority = -10

/datum/resident_document_role_rule/noble_fallback/matches(mob/living/carbon/human/user)
	return ishuman(user) && HAS_TRAIT(user, TRAIT_NOBLE)

/datum/resident_document_role_rule/commoner_fallback
	document_type = /obj/item/book/granter/resident_manuscript/commoner
	priority = -100

/datum/resident_document_role_rule/commoner_fallback/matches(mob/living/carbon/human/user)
	return ishuman(user) && user.mind

/proc/get_resident_document_role_rules()
	var/static/list/cached
	if(!cached)
		cached = list()
		for(var/rule_type in subtypesof(/datum/resident_document_role_rule))
			cached += new rule_type
		sortTim(cached, GLOBAL_PROC_REF(cmp_resident_document_role_rule_priority))
	return cached

/proc/cmp_resident_document_role_rule_priority(datum/resident_document_role_rule/a, datum/resident_document_role_rule/b)
	return b.priority - a.priority

/// Maps a recipient's assigned role to the faction-default manuscript subtype
/// by walking the role rule registry in priority order. Returns null when no
/// rule matches -- callers (admin, cargo) supply their own type.
/proc/get_default_manuscript_type_for_job(mob/living/carbon/human/recipient)
	if(!recipient || !recipient.mind)
		return null
	for(var/datum/resident_document_role_rule/rule as anything in get_resident_document_role_rules())
		if(rule.matches(recipient))
			return rule.document_type
	return null

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

/datum/resident_document_profile
	var/id
	var/display_name
	var/subtitle
	var/description
	var/list/allowed_seals
	/// Seals auto-stamped when the document is issued ready (auto_stamp_seals).
	/// When null, falls back to allowed_seals -- preserves the original PR
	/// behaviour where every faction profile pre-stamped all of its seals.
	var/list/default_seal_keys
	var/paper_color
	var/ink_color
	var/accent_color
	var/seal_color
	var/requires_seal_for_claim = TRUE
	var/grants_residence_claim = FALSE

/datum/resident_document_profile/proc/has_seal(seal_key)
	return seal_key && (seal_key in allowed_seals)

/datum/resident_document_profile/proc/get_default_seal_keys()
	return default_seal_keys || allowed_seals

/datum/resident_document_profile/resident
	id = "resident"
	display_name = "Resident Manuscript"
	subtitle = "Under the Crown's Hand"
	allowed_seals = list("chancellor", "elder", "ruler", "hand")
	paper_color = "#e3d2ad"
	ink_color = "#3a2518"
	accent_color = "#8b5e2f"
	seal_color = "#8b2a22"
	grants_residence_claim = TRUE

/datum/resident_document_profile/guards
	id = "guards"
	display_name = "Azurian Warden Mandate"
	subtitle = "By the Watch and the Crown"
	description = "Let it be known: the bearer is a sworn warden of Azuria, charged with the keeping of city order, the law of the Crown, and the silver discipline of the watch."
	allowed_seals = list("sergeant", "marshal", "elder")
	paper_color = "#d9cfb0"
	ink_color = "#2f3028"
	accent_color = "#4c6f79"
	seal_color = "#6d2a24"

/datum/resident_document_profile/church
	id = "church"
	display_name = "Ecclesiastical Writ of Faith"
	subtitle = "Beneath the Tenfold Light"
	description = "Let it be known: the bearer is a recognized child of the Church, walking under the protection of the Tenfold Light, and is to be received as a faithful soul in matters of doctrine and rite."
	allowed_seals = list("bishop")
	paper_color = "#ead8ad"
	ink_color = "#322414"
	accent_color = "#9c7440"
	seal_color = "#8d5b35"

/datum/resident_document_profile/craftsmen
	id = "craftsmen"
	display_name = "Artisan Guild Charter"
	subtitle = "By Honest Hand and Bronze"
	description = "Let it be known: the bearer is a recognized artisan of the city guilds, holding the right to honest work, fair price, and the standing of the masterly estate."
	allowed_seals = list("guild_leader", "chancellor", "elder")
	paper_color = "#ded1a9"
	ink_color = "#2f2b19"
	accent_color = "#7b7f4a"
	seal_color = "#7a432a"

/datum/resident_document_profile/commoner
	id = "commoner"
	display_name = "Townsfolk Manuscript"
	subtitle = "By the Towner Elder's mark"
	description = "Let it be known: the bearer is a known face among the townsfolk, vouched for by the Elder of the taun. No high authority is invoked here -- only the modest standing of those who live and labour beneath the common law."
	allowed_seals = list("elder", "chancellor", "hand")
	default_seal_keys = list("elder")
	paper_color = "#c4ad81"
	ink_color = "#352618"
	accent_color = "#6f5840"
	seal_color = "#5e3826"
	requires_seal_for_claim = FALSE

/datum/resident_document_profile/merchant
	id = "merchant"
	display_name = "Merchant Shop Charter"
	subtitle = "By the Coin and the Tusk"
	description = "Let it be known: the bearer is a sworn member of the Merchant Shop, recognized in matters of trade, contract and lawful sale, and is owed the courtesies of the burgher estate."
	allowed_seals = list("merchant_master", "chancellor")
	paper_color = "#e0c79a"
	ink_color = "#2a1a10"
	accent_color = "#a35c2a"
	seal_color = "#7e2418"

/datum/resident_document_profile/mages
	id = "mages"
	display_name = "Mage's Guild Patent"
	subtitle = "Under the Duchy's Light, by Star and Sigil"
	description = "Let it be known: by the Duchy's licence and the seal of the Mage's Guild, the bearer is a recognized practitioner of potionmaking, summoning, and the arts of the Guild, bound to its compact and protected by its accord."
	allowed_seals = list("court_magician")
	paper_color = "#dccdde"
	ink_color = "#1c1226"
	accent_color = "#6a4490"
	seal_color = "#3d1d5a"

/datum/resident_document_profile/inn
	id = "inn"
	display_name = "Innkeep's Writ"
	subtitle = "By the Hearth and the Tankard"
	description = "Let it be known: the bearer is recognized as the Innkeep of the city's central inn, charged with the keeping of the hearth, the lawful sale of board and drink, and the safety of those who lodge beneath this roof."
	allowed_seals = list("innkeeper")
	paper_color = "#e7caa0"
	ink_color = "#2a1a10"
	accent_color = "#b67b3a"
	seal_color = "#7c3920"

/datum/resident_document_profile/bathhouse
	id = "bathhouse"
	display_name = "Bathhouse Patent"
	subtitle = "Beneath Steam and Lily"
	description = "Let it be known: the bearer is a recognized proprietor of the Bathhouse, granted leave to keep the steam, scent, and trade of the basement under the Inn, and to gather such custom as the Matron permits."
	allowed_seals = list("bathmaster")
	paper_color = "#e6c9d6"
	ink_color = "#2a1626"
	accent_color = "#a85878"
	seal_color = "#6e2a48"

/datum/resident_document_profile/mercenary
	id = "mercenary"
	display_name = "Mercenary Compact"
	subtitle = "By the Coin, the Steel, and the Word"
	description = "Let it be known: the bearer is a free blade of recognized standing, bound by the compact of coin and steel, sworn to the company that brought them to these lands."
	allowed_seals = list("elder", "chancellor", "hand")
	paper_color = "#d7b88e"
	ink_color = "#2c1d16"
	accent_color = "#8c5b3a"
	seal_color = "#6f3327"

/datum/resident_document_profile/otava
	id = "otava"
	display_name = "Inquisitorial Edict"
	subtitle = "By Truth, Inquest, and the Cleansing Flame"
	description = "Let it be known: by the silver edict of Otava, the bearer is empowered to act in the name of truth, to question and to seek, and to call forth the cleansing flame against heresy."
	allowed_seals = list("inquisitor")
	paper_color = "#d8d1c0"
	ink_color = "#18130f"
	accent_color = "#8f7a48"
	seal_color = "#1f1a14"

/proc/get_resident_document_profiles()
	var/static/list/profiles
	if(!profiles)
		profiles = list()
		for(var/profile_type in subtypesof(/datum/resident_document_profile))
			var/datum/resident_document_profile/profile = profile_type
			var/profile_id = initial(profile.id)
			if(!profile_id)
				continue
			profiles[profile_id] = profile_type
	return profiles

/proc/get_resident_document_profile(profile_id)
	var/static/list/cache
	if(!cache)
		cache = list()
	if(cache[profile_id])
		return cache[profile_id]
	var/list/profiles = get_resident_document_profiles()
	var/profile_type = profiles[profile_id] || profiles["resident"]
	if(!profile_type)
		return null
	var/datum/resident_document_profile/profile = new profile_type
	cache[profile_id] = profile
	return profile
