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
	var/taints_loot = FALSE
	/// Whether this character has spent their one-time natural-claw appearance choice.
	var/cosmetic_claws_configured = FALSE
	/// Cosmetic claw presentation copied onto an ordinary punch intent. Keeping INTENT_HARM's exact type to safekeep every hand interaction.
	var/cosmetic_claw_intent
	/// Selected hit and miss sounds for the cosmetic claw-punch intent.
	var/cosmetic_claw_hitsound = "bluntwooshmed"
	var/cosmetic_claw_miss_sound = "bluntwooshmed"

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

	var/voice_color = "#a0a0a0"
	var/nickname = "Please Change Me"
	var/highlight_color = "#FF0000"
	var/detail_color = "000"

	/// This is your skin tone, uses words such as 'caucasian1', but also accepts hexcode strings (without #).
	var/skin_tone = "caucasian1"
	/// This is an adaptable backup of skin_tone, because rotting was bugging out. Default value should be null, and only filled if we are rotted.
	var/original_skin_tone

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = "white"

	var/age = "Adult"		//Player's age

	var/shavelevel = 0
	var/breathe_tick = 0 // Used for gas mask delays.
	var/socks = "Nude" //Which socks the player wants

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

	var/cached_worn_ac = ARMOR_CLASS_NONE
	var/cached_head_ac = ARMOR_CLASS_NONE
	var/cached_hands_ac = ARMOR_CLASS_NONE
	var/cached_body_ac = ARMOR_CLASS_NONE
	var/worn_ac_dirty = TRUE

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/name_override //For temporary visible name changes

	var/merctype = 0 // Used for mercenary backgrounds - check mail.dm
	var/tokenclaimed = FALSE // Check for having received my medal. FUTURE: Persistent medals.

	var/datum/physiology/physiology

	var/list/datum/bioware = list()

	var/static/list/can_ride_typecache = typecacheof(list(/mob/living/carbon/human))
	var/lastpuke = 0
	var/last_fire_update

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
	var/headshot_artist_credit = null
	var/headshot_artist_link = null
	var/standard_headshot_link = null //used to store headshots when swapping for antag ones
	var/flavortext = null
	/// For setpose
	var/pose_text = ""
	var/ooc_notes = null
	var/ooc_extra
	var/rumour = null
	var/noble_gossip = null
	var/song_title
	var/song_artist
	var/received_resident_key = FALSE
	var/nsfwflavortext = null
	var/erpprefs = null

	// Cached version
	var/flavortext_cached = ""
	var/nsfwflavortext_cached = ""
	var/ooc_notes_cached = ""
	var/erpprefs_cached = ""
	var/rumour_cached = ""
	var/noble_gossip_cached = ""

	/// Per-character theme override for examine panel viewers
	var/examine_theme
	var/list/img_gallery = list()
	var/list/nsfw_img_gallery = list()

	var/ooc_extra_img
	var/nsfw_ooc_extra_img

	possible_rmb_intents = list(/datum/rmb_intent/feint,\
	/datum/rmb_intent/aimed,\
	/datum/rmb_intent/strong,\
	/datum/rmb_intent/swift,\
	/datum/rmb_intent/riposte,\
	/datum/rmb_intent/weak)

	rot_type = /datum/component/rot/corpse

	var/voice_type = null // LETHALSTONE EDIT: defines what sound pack we use. keep this null so mobs resort to their typical gender typing - preferences set this
	var/datum/statpack/statpack = null // Lethalstone Port - statpacks for greater customization
	//setting up vars for vampire color values
	var/vampire_skin = null
	var/vampire_eyes = null
	var/vampire_hair = null
	var/vampire_ears = null
	///An alternative headshot link that can be used when users want to use it for a special role like while a vampire, werewolf, bandit, etc.
	var/vampire_headshot_link
	var/vampire_headshot_artist_credit
	var/vampire_headshot_artist_link
	var/lich_headshot_link
	var/lich_headshot_artist_credit
	var/lich_headshot_artist_link
	//setting up the hooks for this, but not shown yet
	var/werewolf_headshot_link
	var/werewolf_headshot_artist_credit
	var/werewolf_headshot_artist_link

	/// Whether our FOV cone is overridden to be hidden. Simple bool.
	var/viewcone_override

	/// Whether our job title is adaptive to our skills.
	var/adaptive_name
	/// Fixed title to show instead of composing every expert skill into the adaptive name. Resulting into a MESS.
	var/adaptive_name_title
	/// Next world.time where Homesteaders can change their chosen title.
	var/next_homesteader_title_change = 0

	/// Ref to orison-like sunder object
	var/sunder_light_obj = null

	var/favorite_cuisine = NONE
	var/favorite_dish = NONE
	var/favorite_drink = NONE

	/// List of mobs that have attacked us. Only relevant to someone with TRAIT_TEMPO.
	var/list/tempo_attackers = list()

	var/next_tempo_cull


	var/list/charflaws = list()

	var/list/feint_list = list()

	/// curse list and cooldown
	var/list/curses = list()
	COOLDOWN_DECLARE(priest_announcement)
	COOLDOWN_DECLARE(guildmaster_announcement) //This is not for priest but if you are looking for GUILDMASTER announcements it's here, more so convinence than anything.
	COOLDOWN_DECLARE(priest_sermon)
	COOLDOWN_DECLARE(priest_apostasy)
	COOLDOWN_DECLARE(priest_excommunicate)
	COOLDOWN_DECLARE(priest_curse)
	COOLDOWN_DECLARE(priest_change_miracles)
	COOLDOWN_DECLARE(hag_transform_lockout)

	/// bait stacks for aimed intent
	var/bait_stacks

	/// werewolf mob storage (this is bad and probably causes hard dels)
	var/mob/stored_mob = null

	var/mob/living/carbon/human/hostagetaker //Stores the person that took us hostage in a var, allows us to force them to attack the mob and such
	var/mob/living/carbon/human/hostage //What hostage we have

	/// Boolean. Usually set only to TRUE for non-Eoran church roles.
	var/virginity = FALSE
	/// Used to prevent certain antag from having sex
	var/can_do_sex = TRUE
	/// For vision cone, check out mobs.dm defines for values
	fovangle = FOV_DEFAULT

	/// Guarded Virtue (TRAIT_DECEIVING_MEEKNESS) exclusive variable for filtering out our descriptors from examine.
	var/show_descriptors = TRUE

/mob/living/carbon/human/proc/arcyne_fluidity()
	set name = "Spirit Fluidity"
	set category = "RoleUnique.Quirk"

	var/list/choices = list("Hairstyle", "Breast Size", "Penis", "Testicles", "Vagina")
	var/choice = input(src, "What would you like to change?", "Spirit Fluidity") as null|anything in choices

	if(!choice || QDELETED(src))
		return

	switch(choice)
		if("Hairstyle")
			var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
			if(!head || !head.bodypart_features)
				return
			var/datum/bodypart_feature/hair/head/current_hair
			for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
				current_hair = hair_feature
				break
			if(!current_hair)
				return
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			if(!hair_choice || !length(hair_choice.sprite_accessories))
				return
			var/list/valid_hairstyles = list("Default")
			for(var/hair_type in hair_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/head/hair = new hair_type()
				if(!hair)
					continue
				valid_hairstyles[hair.name] = hair_type
				qdel(hair)
			var/new_style = input(src, "Choose your hairstyle", "Spirit Fluidity") as null|anything in valid_hairstyles
			if(!new_style || QDELETED(src))
				return
			var/datum/customizer_entry/hair/hair_entry = new()
			hair_entry.hair_color = current_hair.hair_color
			hair_entry.natural_gradient = current_hair.natural_gradient
			hair_entry.natural_color = current_hair.natural_color
			hair_entry.dye_gradient = current_hair.hair_dye_gradient
			hair_entry.dye_color = current_hair.hair_dye_color
			var/datum/bodypart_feature/hair/head/new_hair = new()
			var/new_hair_type = new_style == "Default" ? initial(current_hair.accessory_type) : valid_hairstyles[new_style]
			if(!new_hair_type)
				qdel(new_hair)
				qdel(hair_entry)
				return
			new_hair.set_accessory_type(new_hair_type, hair_entry.hair_color, src)
			hair_choice.customize_feature(new_hair, src, null, hair_entry)
			head.remove_bodypart_feature(current_hair)
			head.add_bodypart_feature(new_hair)
			update_hair()
			update_body()
			update_body_parts()
			visible_message(span_warning("[src]'s hair briefly shimmers and settles into a different style."), span_warning("A faint, warm sensation passes over your scalp as your hair shifts into a new style."))

		if("Breast Size")
			var/obj/item/organ/breasts/breasts = getorganslot(ORGAN_SLOT_BREASTS)
			if(!breasts)
				to_chat(src, span_warning("You have no breasts to alter."))
				return
			var/list/breast_sizes = list("Flat", "Very Small", "Small", "Normal", "Large", "Enormous")
			var/new_size = input(src, "Choose your breast size", "Spirit Fluidity") as null|anything in breast_sizes
			if(!new_size || QDELETED(src))
				return
			var/size_index = breast_sizes.Find(new_size)
			if(!size_index)
				return
			breasts.breast_size = size_index - 1
			update_body()
			update_body_parts()
			visible_message(span_warning("[src]'s upper silhouette subtly shifts..."), span_warning("A gentle warmth spreads across your chest as your breasts change in size."))
		if("Penis")
			arcyne_toggle_organ(ORGAN_SLOT_PENIS)
		if("Testicles")
			arcyne_toggle_organ(ORGAN_SLOT_TESTICLES)
		if("Vagina")
			arcyne_toggle_organ(ORGAN_SLOT_VAGINA)

/mob/living/carbon/human/proc/arcyne_toggle_organ(organ_slot)
	var/obj/item/organ/existing_organ = getorganslot(organ_slot)
	if(existing_organ)
		existing_organ.Remove(src)
		if(QDELETED(src))
			return
		update_body()
		update_body_parts()
		switch(organ_slot)
			if(ORGAN_SLOT_PENIS)
				visible_message(span_warning("[src]'s lower silhouette loses some volume."), span_red("A soft pulse passes through your groin. Your tool vanishes, leaving your body different beneath your clothes."))
			if(ORGAN_SLOT_TESTICLES)
				visible_message(span_warning("[src]'s lower silhouette loses some more volume."), span_red("A soft pulse passes through your groin. Your reserves vanish, leaving your body different beneath your clothes."))
			if(ORGAN_SLOT_VAGINA)
				visible_message(span_warning("[src] shifts a little uncomfortably."), span_red("A soft pulse passes through your groin. Your spot vanishes, leaving your body different beneath your clothes."))
		return

	var/datum/organ_dna/organ_template = dna?.organ_dna?[organ_slot]
	if(!organ_template || !organ_template.can_create_organ())
		to_chat(src, span_warning("Your body refuses to take that shape. You should probably panic, like. Enough to AHELP this!"))
		return

	var/obj/item/organ/organ_to_add = organ_template.create_organ(src)
	if(!organ_to_add)
		return

	organ_to_add.Insert(src)

	if(getorganslot(organ_slot) != organ_to_add)
		if(!QDELETED(organ_to_add))
			qdel(organ_to_add)
		to_chat(src, span_warning("The change fails to take hold. You should probably panic, like. Enough to AHELP this!"))
		return

	update_body()
	update_body_parts()

	switch(organ_slot)
		if(ORGAN_SLOT_PENIS)
			visible_message(span_warning("[src]'s lower silhouette gains some volume."), span_green("A soft pulse passes through your groin. A tool shapes up, leaving your body different beneath your clothes."))
		if(ORGAN_SLOT_TESTICLES)
			visible_message(span_warning("[src]'s lower silhouette gains some more volume."), span_green("A soft pulse passes through your groin. Reserves shape up, leaving your body different beneath your clothes."))
		if(ORGAN_SLOT_VAGINA)
			visible_message(span_warning("[src] shifts a little comfortably."), span_green("A soft pulse passes through your groin. A spot opens up, leaving your body different beneath your clothes."))
