/mob/living/carbon/human
	name = "Unknown"
	real_name = "Unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "human_basic"
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE
	hud_possible = list(ANTAG_HUD)
	hud_type = /datum/hud/human
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	possible_mmb_intents = list(INTENT_SPECIAL, INTENT_JUMP, INTENT_KICK, INTENT_BITE, INTENT_GIVE)
	can_buckle = TRUE
	buckle_lying = FALSE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID

	ambushable = 1

	voice_pitch = 1

	var/footstep_type = FOOTSTEP_MOB_HUMAN

	var/last_sound //last emote so we have no doubles

	//Hair colour and style
	var/hair_color = "000"
	var/hairstyle = "Bald"

	//Facial hair colour and style
	var/facial_hair_color = "000"
	var/facial_hairstyle = "Shaved"

	//Eye colour
	var/eye_color = "000"

	var/voice_color = "a0a0a0"
	var/nickname = "Please Change Me"
	var/highlight_color = "#FF0000"
	var/detail_color = "000"

	var/skin_tone = "caucasian1"	//Skin tone

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = "white"

	var/age = "Adult"		//Player's age

	var/accessory = "None"
	var/detail = "None"
	var/marking = "None"
	
	var/shavelevel = 0
	var/breathe_tick = 0 // Used for gas mask delays.
	var/socks = "Nude" //Which socks the player wants
	var/backpack = DBACKPACK		//Which backpack type the player has chosen.
	var/jumpsuit_style = PREF_SUIT		//suit/skirt

	//Equipment slots
	var/obj/item/clothing/skin_armor = null
	var/obj/item/clothing/wear_armor = null
	var/obj/item/clothing/wear_pants = null
	var/obj/item/belt = null
	var/obj/item/beltl = null
	var/obj/item/beltr = null
	var/obj/item/clothing/wear_ring = null
	var/obj/item/clothing/wear_wrists = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null
	var/obj/item/cloak = null
	var/obj/item/clothing/wear_shirt = null

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/name_override //For temporary visible name changes

	var/merctype = 0 // Used for mercenary backgrounds - check mail.dm
	var/tokenclaimed = FALSE // Check for having received my medal. FUTURE: Persistent medals.

	var/datum/physiology/physiology

	var/list/datum/bioware = list()

	var/static/list/can_ride_typecache = typecacheof(list(/mob/living/carbon/human))
	var/lastpuke = 0
	var/last_fire_update
	var/account_id

	canparry = TRUE
	candodge = TRUE

	dodgecd = FALSE
	dodgetime = 0

	var/list/possibleclass
	var/advsetup = 0


//	var/alignment = ALIGNMENT_TN

	var/canseebandits = FALSE

	var/marriedto

	var/has_stubble = TRUE

	var/original_name = null

	var/buried = FALSE // Whether the body is buried or not.
	var/funeral = FALSE // Whether the body has received rites or not.

	var/datum/devotion/devotion = null // Used for cleric_holder for priests
	var/datum/inspiration/inspiration = null

	var/headshot_link = null
	var/standard_headshot_link = null //used to store headshots when swapping for antag ones
	var/flavortext = null
	var/ooc_notes = null
	var/ooc_extra
	var/rumour = null
	var/noble_gossip = null
	var/song_title
	var/song_artist
	var/received_resident_key = FALSE
	var/nsfwflavortext = null
	var/erpprefs = null

	var/list/img_gallery = list()
	

	possible_rmb_intents = list(/datum/rmb_intent/feint,\
	/datum/rmb_intent/aimed,\
	/datum/rmb_intent/strong,\
	/datum/rmb_intent/swift,\
	/datum/rmb_intent/riposte,\
	/datum/rmb_intent/weak)

	rot_type = /datum/component/rot/corpse

	var/voice_type = null // LETHALSTONE EDIT: defines what sound pack we use. keep this null so mobs resort to their typical gender typing - preferences set this
	var/datum/statpack/statpack = null // Lethalstone Port - statpacks for greater customization
	var/second_voice	// Virtue-specific. Can be swapped to / from and changed.
	var/original_voice
	//setting up vars for vampire color values
	var/vampire_skin = null
	var/vampire_eyes = null
	var/vampire_hair = null
	//An alternative headshot link that can be used when users want to use it for a special role like while a vampire, werewolf, bandit, etc.
	var/vampire_headshot_link
	var/lich_headshot_link
	//setting up the hooks for this, but not shown yet
	var/werewolf_headshot_link

	/// Whether our FOV cone is overridden to be hidden. Simple bool.
	var/viewcone_override

	/// Whether our job title is adaptive to our skills.
	var/adaptive_name

	/// Ref to orison-like sunder object
	var/sunder_light_obj = null

	/// Assoc list of culinary preferences of the mob
	var/list/culinary_preferences = list()

	/// List of mobs that have attacked us. Only relevant to someone with TRAIT_TEMPO.
	var/list/tempo_attackers = list()

	var/next_tempo_cull


	var/datum/charflaw/charflaw

	// curse list and cooldown
	var/list/curses = list()
	COOLDOWN_DECLARE(priest_announcement)
	COOLDOWN_DECLARE(guildmaster_announcement) //This is not for priest but if you are looking for GUILDMASTER announcements it's here, more so convinence than anything.
	COOLDOWN_DECLARE(crier_announcement)
	COOLDOWN_DECLARE(priest_sermon)
	COOLDOWN_DECLARE(priest_apostasy)
	COOLDOWN_DECLARE(priest_excommunicate)
	COOLDOWN_DECLARE(priest_curse)
	COOLDOWN_DECLARE(priest_change_miracles)

	// bait stacks for aimed intent
	var/bait_stacks

	// werewolf mob storage (this is bad and probably causes hard dels)
	var/mob/stored_mob = null

	var/mob/living/carbon/human/hostagetaker //Stores the person that took us hostage in a var, allows us to force them to attack the mob and such
	var/mob/living/carbon/human/hostage //What hostage we have

	// Boolean. Usually set only to TRUE for non-Eoran church roles.
	var/virginity = FALSE
	// Used to prevent certain antag from having sex
	var/can_do_sex = TRUE

	fovangle = FOV_DEFAULT
