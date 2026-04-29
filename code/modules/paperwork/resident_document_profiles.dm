/// Profile metadata for the Resident Manuscript framework.
/// One TGUI, one DM lifecycle. Profiles only carry id, theme colors, the
/// list of seal keys that are valid for this faction document, and policy
/// flags such as whether the document grants residency-claim rights.
/// Display strings are resolved on the frontend through `texts.profiles[id]`;
/// the DM-side raw values act as default labels for examine and admin spawn.

// Keep resident manuscript registries visible before granters.dm, without
// requiring roguetown.dme ordering edits.
#ifndef RESIDENT_DOCUMENT_RULES_INCLUDED
#include "resident_document_rules.dm"
#endif

#ifndef RESIDENT_DOCUMENT_SEALS_INCLUDED
#include "resident_document_seals.dm"
#endif

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
