/mob/living/carbon/human/species/elf/sun
	race = /datum/species/elf/sun

/datum/species/elf/sun
	name = "Sun Elf"
	id = "elfc"
	is_subrace = TRUE
	origin_default = /datum/virtue/origin/raneshen
	origin = "Raneshen"
	base_name = "Elf"
	sub_name = "Sun Elf"

	desc = "<b>Sun Elf</b><br>\
	Native to the vast region of Raneshen, Sun Elves are an elven subspecies descended \
	from the followers of the Günayan Crusade who settled in the region a millenium \
	ago. Tradition holds that Astrata guided their ancestors on a holy mission to carve out \
	a divine Dominion of the Sun, one that would purge all darkness with Astrata's holy light.<br><br>\
	For most of their history, Sun Elves ruled over Raneshen's Nshkormh region as a deeply-hierarchical \
	slaver state, with brutal and oft-controversial Astratan worship, comprised of odd, bespoke rituals that came at the cost of the chosen enslaved. \
	The See had never acknowledged such practices, however it is suspected that due to them the thinly-numbered race had received their 'blessings'.<br><br> \
	The past half-century has seen an eruption of religious warfare, spurred on by the inevitable anger from other faiths as well as the enslaved themselves, \
	with a massive Psydonian rebellion ultimately shattering the Solar Dominion. Since \
	then, many Sun Elf refugees have traveled from the East. Some bring their Crusade \
	along with them, while others yearn for sanctuary from the ever-encroaching \
	Darkness — and many more seek only to selfish enrich themselves in this foreign land.<br><br>\
	Sun Elves are often deeply concerned with social order, castes, and superiority. Many \
	are vain or power-hungry, and they tend to have imperious and assertive personalities. \
	It is a common sentiment among Sun Elves that they are the 'chosen' of Astrata, leading \
	to a great deal of condescension or disdain toward those faiths deemed 'lesser'.<br>\
	<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>+1 Stat of their choice, Silver-blooded, Rot immune. <br>Astratan Affinity grants a devotion bonus if the selected patron is Astrata.</b></span><br>"

	custom_selection = list(
		"+1 FOR" = STATKEY_LCK,
		"+1 INT" = STATKEY_INT,
		"+1 CON" = STATKEY_CON,
		"+1 WIL" = STATKEY_WIL,
		"+1 PER" = STATKEY_PER,
		"+1 STR, -1 CON" = list(STATKEY_STR = 1, STATKEY_CON = -1),
		"Astratan Affinity" = list(TRAIT_ASTRATAN_AFFINITY, /datum/virtue/combat/devotee/astratan_affinity)
	)

	skin_tone_wording = "Skintone"
	use_skin_tone_wording_for_examine = FALSE

	inherent_traits = list(TRAIT_SILVER_BLESSED, TRAIT_ZOMBIE_IMMUNE, TRAIT_UNLYCKERABLE)
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,OLDGREY)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = 1
	disliked_food = NONE
	liked_food = NONE
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mem.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	use_f = TRUE
	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf
	offset_features = list(
		OFFSET_ID = list(0,0), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1), OFFSET_HANDS = list(0,0), \
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,0), OFFSET_HEAD = list(0,0), \
		OFFSET_FACE = list(0,0), OFFSET_BELT_F = list(0,0), OFFSET_BACK = list(0,0), \
		OFFSET_NECK = list(0,0), OFFSET_MOUTH = list(0,0), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_UNDIES = list(0,1),\
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,-1), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	race_bonus = list()
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/elf,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
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
		/datum/customizer/organ/ears/elf,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
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
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
	)


	gender_swapping = TRUE

/datum/species/elf/sun/get_span_language(datum/language/message_language)
	if(!message_language)
		return
	if(message_language.type == /datum/language/celestial)
		return list(SPAN_SAND)
	return message_language.spans

/datum/species/elf/sun/get_skin_list()
	return list(
		"Dawn" = SKIN_COLOR_DAWN,
		"Morning" = SKIN_COLOR_MORNING,
		"Noon" = SKIN_COLOR_NOON,
		"Evening" = SKIN_COLOR_EVENING,
		"Sunset" = SKIN_COLOR_SUNSET,
		"Dusk" = SKIN_COLOR_DUSK,
		"Gilded" = SKIN_COLOR_GILDED,
		"Brass" = SKIN_COLOR_SELFBRASS,
	)

/datum/species/elf/sun/get_hairc_list()
	return sortList(list(
	"blond - pale" = "9d8d6e",
	"blond - dirty" = "88754f",
	"blond - drywheat" = "d5ba7b",
	"blond - strawberry" = "c69b71",

	"brown - mud" = "362e25",
	"brown - oats" = "584a3b",
	"brown - grain" = "58433b",
	"brown - soil" = "48322a",

	"red - berry" = "48322a",
	"red - wine" = "82534c",
	"red - sunset" = "82462b",
	"red - blood" = "822b2b",

	))

/datum/species/elf/sun/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/elf/elfwm.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/elf/elfwf.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/elf/elfwm.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/elf/elfwf.txt") )
	return randname

/datum/species/elf/sun/random_surname()
	return " [pick(world.file2list("strings/rt/names/elf/elfwlast.txt"))]"
