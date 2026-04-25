/// Profile metadata for the Resident Manuscript framework.
/// One TGUI, one DM lifecycle. Profiles only carry id, theme colors, and
/// the list of seal keys that are valid for this faction document.
/// All flavor strings (display name, subtitle, description, seal labels)
/// are resolved on the frontend through `texts.profiles[id]`. The DM side
/// keeps an English fallback in `en_*` for non-localized callers (examine,
/// cargo pack labels, admin spawn).
/datum/resident_document_profile
	/// Profile identifier sent to the frontend (selects locale block).
	var/id
	/// English fallback display name (used in DM when no UI is open).
	var/en_display_name
	/// English fallback subtitle (one-line authority blurb).
	var/en_subtitle
	/// English fallback long-form flavor (replaces the default description).
	var/en_description
	/// Allowed seal-rule keys (subset of `get_resident_manuscript_seal_rules()`).
	/// Empty list = no seals on this document; commoner uses this.
	var/list/allowed_seals
	/// Hex color of the parchment body.
	var/paper_color
	/// Hex color of body text.
	var/ink_color
	/// Hex color of borders, fields, and section accents.
	var/accent_color
	/// Hex color of the wax seal.
	var/seal_color
	/// Whether `claim_residence` requires at least one seal. Commoners may
	/// claim without seals; everyone else must be properly stamped.
	var/requires_seal_for_claim = TRUE

/datum/resident_document_profile/proc/has_seal(seal_key)
	return seal_key && (seal_key in allowed_seals)

/// Default profile. The roundstart/blank/fake variants of the original
/// Resident Manuscript inherit this — no behavioral change vs. PR #6868.
/datum/resident_document_profile/resident
	id = "resident"
	en_display_name = "Resident Manuscript"
	en_subtitle = "Under the Crown's Hand"
	allowed_seals = list("chancellor", "elder", "ruler", "hand")
	paper_color = "#d8c190"
	ink_color = "#25180f"
	accent_color = "#8b5e2f"
	seal_color = "#7b1d18"

/datum/resident_document_profile/guards
	id = "guards"
	en_display_name = "Azurian Warden Mandate"
	en_subtitle = "By the Watch and the Crown"
	en_description = "Let it be known: the bearer is a sworn warden of Azuria, charged with the keeping of city order, the law of the Crown, and the silver discipline of the watch."
	allowed_seals = list("sergeant", "marshal", "elder")
	paper_color = "#c4d3e8"
	ink_color = "#102140"
	accent_color = "#d4af3a"
	seal_color = "#1e3a6e"

/datum/resident_document_profile/church
	id = "church"
	en_display_name = "Ecclesiastical Writ of Faith"
	en_subtitle = "Beneath the Tenfold Light"
	en_description = "Let it be known: the bearer is a recognized child of the Church, walking under the protection of the Tenfold Light, and is to be received as a faithful soul in matters of doctrine and rite."
	allowed_seals = list("bishop")
	paper_color = "#f4ead0"
	ink_color = "#302410"
	accent_color = "#c9a14b"
	seal_color = "#9b3025"

/datum/resident_document_profile/craftsmen
	id = "craftsmen"
	en_display_name = "Artisan Guild Charter"
	en_subtitle = "By Honest Hand and Bronze"
	en_description = "Let it be known: the bearer is a recognized artisan of the city guilds, holding the right to honest work, fair price, and the standing of the masterly estate."
	allowed_seals = list("guild_leader", "chancellor", "elder")
	paper_color = "#cbd6a8"
	ink_color = "#1f2a14"
	accent_color = "#a07332"
	seal_color = "#4a6328"

/datum/resident_document_profile/commoner
	id = "commoner"
	en_display_name = "Commoner Manuscript"
	en_subtitle = "Under the Common Law"
	en_description = "Let it be known: the bearer is recognized as a lawful commoner of these lands, neither titled nor accused. No high authority is invoked — only the shelter of the common law."
	allowed_seals = list()
	paper_color = "#c2bfb6"
	ink_color = "#2a2620"
	accent_color = "#6f6a5f"
	seal_color = "#3f3a32"
	requires_seal_for_claim = FALSE

/datum/resident_document_profile/mercenary
	id = "mercenary"
	en_display_name = "Mercenary Compact"
	en_subtitle = "By the Coin, the Steel, and the Word"
	en_description = "Let it be known: the bearer is a free blade of recognized standing, bound by the compact of coin and steel, sworn to the company that brought them to these lands."
	allowed_seals = list("elder", "chancellor", "hand")
	paper_color = "#b09cc6"
	ink_color = "#1c1024"
	accent_color = "#d6d2dc"
	seal_color = "#4a2466"

/datum/resident_document_profile/otava
	id = "otava"
	en_display_name = "Inquisitorial Edict"
	en_subtitle = "By Truth, Inquest, and the Cleansing Flame"
	en_description = "Let it be known: by the silver edict of Otava, the bearer is empowered to act in the name of truth, to question and to seek, and to call forth the cleansing flame against heresy."
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
