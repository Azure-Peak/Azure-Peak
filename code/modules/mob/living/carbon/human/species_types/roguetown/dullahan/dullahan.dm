// Base config was lifted from Tieflings, however changed to cursed humen based on programmer lore.
// Supposed to be temporary, needless to say.

/mob/living/carbon/human/species/dullahan
	race = /datum/species/dullahan

/datum/species/dullahan
	name = "Revenant"
	id = "revenant"
	desc = "<b>Revenant</b><br>\
	Revenants are those that have died, returning from death to continue 'living' in a manner to speak. Their origins are not entirely known, yet many strongly believe them to have originated from the rot and decay of Psydonia. \
	Unable to truly rest, yet entirely sane of mind. Capable of detaching their heads through unknown arcyne means, they are oft wanderers due to their unknown origins and being ostracized by both the Church and many of the common masses around the lands."
	// Stat balancing. Per-server decision. Preferably keep neutral until analysis post testmerges.
	//race_bonus = list(STAT_INTELLIGENCE = 1, STAT_CONSTITUTION = 1)
	skin_tone_wording = "Catalyst"
	max_age = "???"

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY,MUTCOLORS)
	default_features = MANDATORY_FEATURE_LIST
	inherent_traits = list(TRAIT_EASYDECAPITATION, TRAIT_NOHUNGER, TRAIT_NOBREATH, TRAIT_ZOMBIE_IMMUNE) //Given the deathless traits inherently as part of their nature as pseudo-undead.
	use_skintones = TRUE
	disliked_food = NONE
	liked_food = NONE
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	enflamed_icon = "widefire"
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/dullahan,
	)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/dullahan,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		// Customizable eyes means overriden eyes get thrown out.
		// HUD organ deals with less parenting problems aswell.
		ORGAN_SLOT_HUD = /obj/item/organ/dullahan_vision,
		)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/snout/anthro/dullahan,
		/datum/customizer/organ/horns/demihuman,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/horns/tusks,
		/datum/customizer/organ/soul/fire,
		/datum/customizer/organ/tail/dullahan,
		/datum/customizer/organ/ears/dullahan,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/animal,
		/datum/customizer/organ/vagina/animal,

		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/plain,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/butt,
		/datum/body_marking/sock,
		/datum/body_marking/socklonger,
		/datum/body_marking/tips,
		/datum/body_marking/backspots,
		/datum/body_marking/front,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/harlequin,
		/datum/body_marking/harlequinreversed,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
		/datum/body_marking/gradient,
	)
	descriptor_choices = list(
		/datum/descriptor_choice/trait,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)
	languages = list(
		/datum/language/common,
	)

	restricted_virtues = list(/datum/virtue/utility/noble, /datum/virtue/utility/deathless, /datum/virtue/utility/resident)

	stress_examine = TRUE
	stress_desc = span_red("Accursed. I should keep my distance...")
	// Faster to check the head directly than looping through with get_bodypart.
	var/headless = FALSE
	var/obj/item/bodypart/head/dullahan/my_head
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj

/datum/species/dullahan/check_roundstart_eligible()
	return TRUE

/datum/species/dullahan/qualifies_for_rank(rank, list/features)
	return TRUE


/datum/species/demihuman/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/random = rand(1,8)
	//Choose from a variety of mostly brightish, animal, matching colors
	switch(random)
		if(1)
			main_color = ORANGE_FUR
		if(2)
			main_color = LIGHTGREY_FUR
		if(3)
			main_color = DARKGREY_FUR
		if(4)
			main_color = LIGHTORANGE_FUR
		if(5)
			main_color = LIGHTBROWN_FUR
		if(6)
			main_color = WHITEBROWN_FUR
		if(7)
			main_color = DARKBROWN_FUR
		if(8)
			main_color = BLACK_FUR
	returned["mcolor"] = main_color
	returned["mcolor2"] = main_color
	returned["mcolor3"] = main_color
	return returned

/datum/species/dullahan/get_skin_list()
	return list(
		"Timber-Gronn" = SKIN_COLOR_TIMBER_GRONN,
		"Giza-Azure" = SKIN_COLOR_GIZA_AZURE,
		"Walnut-Stine" = SKIN_COLOR_WALNUT_STINE,
		"Etrustcan-Dandelion" = SKIN_COLOR_ETRUSTCAN_DANDELION,
		"Naledi-Born" = SKIN_COLOR_NALEDI_BORN,
		"Naledi-Southerner" = SKIN_COLOR_NALEDI_LIGHT,
		"Kaze-Lotus" = SKIN_COLOR_KAZE_LOTUS,
		"Grenzel-Azuria" = SKIN_COLOR_GRENZEL_WOODS,
		"Etrusca-Lirvas" = SKIN_COLOR_ETRUSCA_LIRVAS,
		"Free Roamers" = SKIN_COLOR_FREE_FOLK,
		"Aavnic"	= SKIN_COLOR_AVAR_BORNE,
		"Shalvine Roamer" = SKIN_COLOR_SHALVINE_AZURE,
		"Lalve-Steppes" = SKIN_COLOR_LALVE_NALEDI,
		"Naledi-Otava" = SKIN_COLOR_NALEDI_OTAVA,
		"Grezel-Aavnic" = SKIN_COLOR_GRENZEL_AVAR,
		"Hammer-Gronn" = SKIN_COLOR_HAMMER_GRONN,
		"Commorah" = SKIN_COLOR_COMMORAH,
		"Gloomhaven" = SKIN_COLOR_GLOOMHAVEN,
		"Darkpila" = SKIN_COLOR_DARKPILA,
		"Sshanntynlan" = SKIN_COLOR_SSHANNTYNLAN,
		"Llurth Dreir" = SKIN_COLOR_LLURTH_DREIR,
		"Tafravma" = SKIN_COLOR_TAFRAVMA,
		"Yuethindrynn" = SKIN_COLOR_YUETHINDRYNN,
		"Grenzelhoft" = SKIN_COLOR_PALE_GRENZELHOFT,
		"Hammerhold" = SKIN_COLOR_PALE_HAMMERHOLD,
		"Ebon" = SKIN_COLOR_PALE_EBON,
		"Kazengun" = SKIN_COLOR_PALE_KAZENGUN,
		"Vheslyn" = SKIN_COLOR_VHESLYN,
		"Arlenneth" = SKIN_COLOR_ARLENNETH,
		"Nessyss" = SKIN_COLOR_NESSYSS,
		"Helixia" = SKIN_COLOR_HELIXIA,
		"Nymsea" = SKIN_COLOR_NYMSEA
	)

/datum/species/dullahan/get_hairc_list()
	return sortList(list(
		"blond - pale" = "9d8d6e",
		"blond - dirty" = "88754f",
		"blond - drywheat" = "d5ba7b",
		"blond - strawberry" = "c69b71",

		"brown - mud" = "362e25",
		"brown - oats" = "584a3b",
		"brown - grain" = "58433b",
		"brown - soil" = "48322a",

		"black - oil" = "181a1d",
		"black - cave" = "201616",
		"black - rogue" = "2b201b",
		"black - midnight" = "1d1b2b",

		"red - berry" = "48322a",
		"red - wine" = "82534c",
		"red - sunset" = "82462b",
		"red - blood" = "822b2b"
	))

/obj/item/organ/brain/dullahan
	organ_flags = ORGAN_ORGANIC
	decoy_override = TRUE

// May bug out if you lose or gain species while in-game.
// I don't know if that is possible, may have some cases relating to eye signals.
/datum/species/dullahan/on_species_gain(mob/living/carbon/user, datum/species/old_species)
	..()
	RegisterSignal(user, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(user, COMSIG_MOB_SAY_POSTPROCESS, PROC_REF(on_say_postprocess))
	// TODO SEXCON2: Re-enable Dullahan detached head ERP support
	//RegisterSignal(user, COMSIG_ERP_LOCATION_ACCESSIBLE, PROC_REF(on_erp_location_accessible))
	RegisterSignal(user, COMSIG_LIVING_REVIVE, PROC_REF(on_aheal))
	my_head = user.get_bodypart(BODY_ZONE_HEAD)
	RegisterSignal(my_head, COMSIG_QDELETING, PROC_REF(on_head_destroyed))

/datum/species/dullahan/on_species_loss(mob/living/carbon/user)
	. = ..()

	UnregisterSignal(user, COMSIG_MOB_SAY)
	UnregisterSignal(user, COMSIG_MOB_SAY_POSTPROCESS)
	//UnregisterSignal(user, COMSIG_ERP_LOCATION_ACCESSIBLE) // TODO SEXCON2
	if(my_head.owner ~= user)
		// Give their head back instead?
		// In TG Dullahan heads are always off, thus they give back heads.
		// Warn that they're going to die?
		if(!(user.status_flags & GODMODE))
			user.death()

	UnregisterSignal(my_head, COMSIG_QDELETING)
	my_head = null
	soul_light_off()
	mob_light_obj = null

/datum/species/dullahan/proc/on_aheal(datum/source, full_heal, admin_revive)
	if(!admin_revive)
		return
	var/mob/living/carbon/user = my_head.original_owner
	if(!headless)
		return

	my_head.attach_limb(user)
	headless = FALSE

	var/obj/item/organ/dullahan_vision/vision = user.getorganslot(ORGAN_SLOT_HUD)
	vision.viewing_head = FALSE
	user.reset_perspective()

// Butchering a head permas their user as the organs don't drop, that is bad.
// I'll not fix that as it may be on purpose in some codebases.
/datum/species/dullahan/proc/on_head_destroyed()
	var/mob/living/carbon/user = my_head.original_owner
	if(!(user.status_flags & GODMODE))
		user.death()

	UnregisterSignal(my_head, COMSIG_QDELETING)
	my_head = null

/datum/species/dullahan/proc/soul_light_on(mob/living/carbon/human/user)
	var/obj/item/organ/soul/soul_accessory = user.getorganslot(ORGAN_SLOT_SOUL)
	if(soul_accessory && user.stat != DEAD)
		mob_light_obj = user.mob_light(soul_accessory.accessory_colors, 2, 2)

/datum/species/dullahan/proc/soul_light_off()
	QDEL_NULL(mob_light_obj)

/datum/species/dullahan/proc/on_say_postprocess(datum/source, list/speech_args)
	var/mob/living/carbon/human/human = my_head.original_owner

	if(!headless)
		return

	var/message_mode = speech_args[SPEECH_MODE]
	var/fullcrit = human.InFullCritical()
	var/message_range = 7
	if((human.InCritical() && !fullcrit) || message_mode == MODE_WHISPER)
		message_range = 1

	var/radio_return = human.radio(speech_args[SPEECH_MESSAGE], message_mode, speech_args[SPEECH_SPANS], speech_args[SPEECH_LANGUAGE])
	if(radio_return & REDUCE_RANGE)
		message_range = 1

	my_head.say(speech_args[SPEECH_MESSAGE], spans = speech_args[SPEECH_SPANS], sanitize = FALSE, message_range = message_range, message_mode = speech_args[SPEECH_MODE])
	speech_args[SPEECH_MESSAGE] = ""

// TODO SEXCON2: Reimplement for sexcon2 system
/*
/datum/species/dullahan/proc/on_erp_location_accessible(datum/source, list/check_args)
	// Allows Dullahan heads but not necro.
	var/obj/item/bodypart/bodypart = check_args[ERP_BODYPART]
	var/mob/living/carbon/human/target = check_args[ERP_TARGET]
	var/mob/living/carbon/human/user = check_args[ERP_USER]
	var/self_target = check_args[ERP_SELF_TARGET]
	var/datum/sex_action/action = check_args[ERP_ACTION]

	var/success_flags = 0
	// This datum is the user, get target's species.
	if(check_zone(check_args[ERP_LOCATION]) == BODY_ZONE_HEAD && !bodypart && isdullahan(target))
		var/datum/species/dullahan/dullahan = target.dna.species
		bodypart = dullahan.my_head

		// Not close to the bodypart they want to interact with.
		var/same_tile = (get_turf(bodypart) == get_turf(user))
		if(!same_tile && !user.is_holding(bodypart))
			return SIG_CHECK_FAIL
		success_flags |= SKIP_ADJACENCY_CHECK
	check_args[ERP_BODYPART] = bodypart

	if(action.check_same_tile && (user != target || self_target))
		var/same_tile = (get_turf(user) == get_turf(target))
		var/grab_bypass = (action.aggro_grab_instead_same_tile && user.get_highest_grab_state_on(target) == GRAB_AGGRESSIVE)
		var/same_tile_bodypart = (get_turf(bodypart) == get_turf(user)) || user.is_holding(bodypart)

		if(!same_tile && !grab_bypass && !same_tile_bodypart)
			return SIG_CHECK_FAIL
		success_flags |= SKIP_TILE_CHECK

	if(action.require_grab && (user != target || self_target))
		var/grabstate = user.get_highest_grab_state_on(target)

		if((grabstate == null || grabstate < action.required_grab_state) && !user.is_holding(bodypart))
			return SIG_CHECK_FAIL
		success_flags |= SKIP_GRAB_CHECK

	return success_flags
*/

/datum/species/dullahan/proc/get_nodrop_head()
	var/obj/item/bodypart/head/dullahan/head = my_head
	var/mob/living/carbon/human/user = head.original_owner
	for(var/obj/item/equipped_item in user.get_equipped_items(include_pockets = FALSE, include_beltslots = FALSE))
		if(HAS_TRAIT(equipped_item, TRAIT_NODROP))
			if(equipped_item.slot_flags & (ITEM_SLOT_MOUTH | ITEM_SLOT_HEAD | ITEM_SLOT_NECK | ITEM_SLOT_MASK))
				return equipped_item
	return FALSE

/datum/species/dullahan/can_equip(obj/item/item, slot, disable_warning, mob/living/carbon/human/user, bypass_equip_delay_self = FALSE)
	if(slot == SLOT_MOUTH && istype(item, /obj/item/grabbing/bite/))
		if(user.mouth)
			return FALSE
		return equip_delay_self_check(item, user, bypass_equip_delay_self)
	return ..()
