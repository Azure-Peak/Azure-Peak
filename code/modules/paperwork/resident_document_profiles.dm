/// Profile metadata for the Resident Manuscript framework.
/// One TGUI, one DM lifecycle. Profiles only carry id, theme colors, the
/// list of seal keys that are valid for this faction document, and policy
/// flags such as whether the document grants residency-claim rights.
/// Display strings are resolved on the frontend through `texts.profiles[id]`;
/// the DM-side raw values act as default labels for examine and admin spawn.

/datum/resident_document_profile
	var/id
	var/display_name
	var/subtitle
	var/description
	var/list/allowed_seals
	var/paper_color
	var/ink_color
	var/accent_color
	var/seal_color
	var/requires_seal_for_claim = TRUE
	var/grants_residence_claim = FALSE

/datum/resident_document_profile/proc/has_seal(seal_key)
	return seal_key && (seal_key in allowed_seals)

/datum/resident_document_profile/resident
	id = "resident"
	display_name = "Resident Manuscript"
	subtitle = "Under the Crown's Hand"
	allowed_seals = list("chancellor", "elder", "ruler", "hand")
	paper_color = "#ead4de"
	ink_color = "#2a1422"
	accent_color = "#a85c8a"
	seal_color = "#6e1a4a"
	grants_residence_claim = TRUE

/datum/resident_document_profile/guards
	id = "guards"
	display_name = "Azurian Warden Mandate"
	subtitle = "By the Watch and the Crown"
	description = "Let it be known: the bearer is a sworn warden of Azuria, charged with the keeping of city order, the law of the Crown, and the silver discipline of the watch."
	allowed_seals = list("sergeant", "marshal", "elder")
	paper_color = "#c8dcec"
	ink_color = "#102140"
	accent_color = "#5d8ab8"
	seal_color = "#1e3a6e"

/datum/resident_document_profile/church
	id = "church"
	display_name = "Ecclesiastical Writ of Faith"
	subtitle = "Beneath the Tenfold Light"
	description = "Let it be known: the bearer is a recognized child of the Church, walking under the protection of the Tenfold Light, and is to be received as a faithful soul in matters of doctrine and rite."
	allowed_seals = list("bishop")
	paper_color = "#f5edd5"
	ink_color = "#302410"
	accent_color = "#c9a14b"
	seal_color = "#9b3025"

/datum/resident_document_profile/craftsmen
	id = "craftsmen"
	display_name = "Artisan Guild Charter"
	subtitle = "By Honest Hand and Bronze"
	description = "Let it be known: the bearer is a recognized artisan of the city guilds, holding the right to honest work, fair price, and the standing of the masterly estate."
	allowed_seals = list("guild_leader", "chancellor", "elder")
	paper_color = "#dde5c0"
	ink_color = "#1f2a14"
	accent_color = "#869c4a"
	seal_color = "#4a6328"

/datum/resident_document_profile/commoner
	id = "commoner"
	display_name = "Commoner Manuscript"
	subtitle = "Under the Common Law"
	description = "Let it be known: the bearer is recognized as a lawful commoner of these lands, neither titled nor accused. No high authority is invoked — only the shelter of the common law."
	allowed_seals = list("court_magician")
	paper_color = "#d8c4a4"
	ink_color = "#2a1f14"
	accent_color = "#866a44"
	seal_color = "#4a3520"
	requires_seal_for_claim = FALSE

/datum/resident_document_profile/mercenary
	id = "mercenary"
	display_name = "Mercenary Compact"
	subtitle = "By the Coin, the Steel, and the Word"
	description = "Let it be known: the bearer is a free blade of recognized standing, bound by the compact of coin and steel, sworn to the company that brought them to these lands."
	allowed_seals = list("elder", "chancellor", "hand")
	paper_color = "#dcb89c"
	ink_color = "#2a1810"
	accent_color = "#b85c30"
	seal_color = "#6e2818"

/datum/resident_document_profile/otava
	id = "otava"
	display_name = "Inquisitorial Edict"
	subtitle = "By Truth, Inquest, and the Cleansing Flame"
	description = "Let it be known: by the silver edict of Otava, the bearer is empowered to act in the name of truth, to question and to seek, and to call forth the cleansing flame against heresy."
	allowed_seals = list("inquisitor")
	paper_color = "#d8d6d3"
	ink_color = "#0c0a07"
	accent_color = "#c9a14b"
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
