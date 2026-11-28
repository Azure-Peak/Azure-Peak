// Base config was lifted from Tieflings, however changed to cursed humen based on programmer lore.
// Supposed to be temporary, needless to say.

/mob/living/carbon/human/species/dullahan
	race = /datum/species/dullahan

/datum/species/dullahan
	name = "Revenant"
	id = "revenant"
	desc_title = "Revenant"
	desc = "Revenants are those that have died, returning from death to continue 'living' in a manner to speak. Their origins are not entirely known, yet many strongly believe them to have originated from the rot and decay of Psydonia. \
	Unable to truly rest, yet entirely sane of mind. They are oft wanderers due to their unknown origins and being ostracized by both the Church and many of the common masses around the lands."
	// Stat balancing. Per-server decision. Preferably keep neutral until analysis post testmerges.
	//race_bonus = list(STAT_INTELLIGENCE = 1, STAT_CONSTITUTION = 1)
	skin_tone_wording = "Catalyst"
	use_skin_tone_wording_for_examine = FALSE
	max_age = "???"

	allowed_taur_types = list(
		/obj/item/bodypart/taur/lamia,
		/obj/item/bodypart/taur/spider,
		/obj/item/bodypart/taur/horse,
		/obj/item/bodypart/taur/goat,
	)
	base_name = "Godtouched"
	is_subrace = TRUE
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY,MUTCOLORS)
	default_features = MANDATORY_FEATURE_LIST
	inherent_traits = list(TRAIT_NOHUNGER, TRAIT_NOBREATH, TRAIT_DEATHLESS, TRAIT_ZOMBIE_IMMUNE) //Given the deathless traits inherently as part of their nature as pseudo-undead.
	use_skintones = TRUE
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	allowed_body_builds = STANDARD_BODY_BUILDS
	default_body_build_m = BODY_BUILD_BULKY
	default_body_build_f = BODY_BUILD_SLIM
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
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
		/datum/customizer/bodypart_feature/piercing,
		/datum/customizer/organ/snout/anthro/dullahan,
		/datum/customizer/organ/horns/demihuman,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/horns/tusks,
		/datum/customizer/organ/tail/dullahan,
		/datum/customizer/organ/ears/dullahan,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/animal,
		/datum/customizer/organ/vagina/animal,
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/bodypart_feature/pits,

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
		/datum/body_marking/spotted,
		/datum/body_marking/backspots,
		/datum/body_marking/front,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/harlequin,
		/datum/body_marking/harlequinreversed,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
		/datum/body_marking/gradient,
		/datum/body_marking/waist,
		/datum/body_marking/womb_tattoo,
		/datum/body_marking/butterfly
	)
	descriptor_choices = list(
		/datum/descriptor_choice/trait,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin/rev,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)
	languages = list(
		/datum/language/common,
	)

	restricted_virtues = list(/datum/virtue/utility/noble, /datum/virtue/utility/hollow)

	stress_examine = TRUE
	stress_desc = span_red("Accursed. I should keep my distance...")

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

