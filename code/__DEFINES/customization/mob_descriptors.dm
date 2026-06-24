#define MOB_DESCRIPTOR_SLOT_NOTHING 1
#define MOB_DESCRIPTOR_SLOT_FACE_SHAPE 2
#define MOB_DESCRIPTOR_SLOT_FACE_EXPRESSION 3
#define MOB_DESCRIPTOR_SLOT_BODY 4
#define MOB_DESCRIPTOR_SLOT_SKIN 5
#define MOB_DESCRIPTOR_SLOT_VOICE 6
#define MOB_DESCRIPTOR_SLOT_STATURE 7
#define MOB_DESCRIPTOR_SLOT_PROMINENT 8
#define MOB_DESCRIPTOR_SLOT_AGE 9
#define MOB_DESCRIPTOR_SLOT_PENIS 10
#define MOB_DESCRIPTOR_SLOT_TESTICLES 11
#define MOB_DESCRIPTOR_SLOT_BREASTS 12
#define MOB_DESCRIPTOR_SLOT_VAGINA 13
#define MOB_DESCRIPTOR_SLOT_HEIGHT 14
#define MOB_DESCRIPTOR_SLOT_TRAIT 15

#define CUSTOM_DESCRIPTOR_AMOUNT 12
#define CUSTOM_DESCRIPTOR_TEXT_LENGTH 32

#define CUSTOM_DESCRIPTOR_TYPE_LIST list(\
	/datum/mob_descriptor/prominent/custom/one,\
	/datum/mob_descriptor/prominent/custom/two,\
	/datum/mob_descriptor/prominent/custom/three,\
	/datum/mob_descriptor/prominent/custom/four,\
	/datum/mob_descriptor/face/custom/five,\
	/datum/mob_descriptor/face_exp/custom/six,\
	/datum/mob_descriptor/body/custom/seven,\
	/datum/mob_descriptor/skin/custom/eight,\
	/datum/mob_descriptor/voice/custom/nine,\
	/datum/mob_descriptor/stature/custom/ten,\
	/datum/mob_descriptor/height/custom/eleven,\
	/datum/mob_descriptor/trait/custom/twelve\
)

#define CUSTOM_DESCRIPTOR_SHOWS_PREFIX list(\
	/datum/mob_descriptor/prominent/custom/one,\
	/datum/mob_descriptor/prominent/custom/two,\
	/datum/mob_descriptor/prominent/custom/three,\
	/datum/mob_descriptor/prominent/custom/four,\
	/datum/mob_descriptor/face/custom/five,\
	/datum/mob_descriptor/voice/custom/nine,\
	/datum/mob_descriptor/height/custom/eleven\
)

#define CUSTOM_DESCRIPTOR_ARTICLE_ONLY list(\
	/datum/mob_descriptor/face/custom/five,\
	/datum/mob_descriptor/voice/custom/nine,\
	/datum/mob_descriptor/height/custom/eleven\
)

#define CUSTOM_ARTICLE_INPUT_LIST list(\
	"a" = CUSTOM_PREFIX_HAS_A,\
	"an" = CUSTOM_PREFIX_HAS_AN\
)

#define CUSTOM_ARTICLE_TRANSLATION_LIST list(\
	"[CUSTOM_PREFIX_HAS_A]" = "a",\
	"[CUSTOM_PREFIX_HAS_AN]" = "an"\
)

#define CUSTOM_PREFIX_HAS_A 1
#define CUSTOM_PREFIX_HAS_AN 2
#define CUSTOM_PREFIX_IS 3
#define CUSTOM_PREFIX_LOOKS 4
#define CUSTOM_PREFIX_HAS 5

#define CUSTOM_PREFIX_AMOUNT 5 //Keep this to match the max

#define CUSTOM_PREFIX_INPUT_LIST list(\
	"Has a" = CUSTOM_PREFIX_HAS_A,\
	"Has an" = CUSTOM_PREFIX_HAS_AN,\
	"Is" = CUSTOM_PREFIX_IS,\
	"Looks" = CUSTOM_PREFIX_LOOKS,\
	"Has" = CUSTOM_PREFIX_HAS\
)

#define CUSTOM_PREFIX_TRANSLATION_LIST list(\
	"[CUSTOM_PREFIX_HAS_A]" = "Has a",\
	"[CUSTOM_PREFIX_HAS_AN]" = "Has an",\
	"[CUSTOM_PREFIX_IS]" = "Is",\
	"[CUSTOM_PREFIX_LOOKS]" = "Looks",\
	"[CUSTOM_PREFIX_HAS]" = "Has"\
)

#define MOB_DESCRIPTOR(descriptor_type) GLOB.mob_descriptors[descriptor_type]

GLOBAL_LIST_INIT(mob_descriptors, build_descriptor_types())

/proc/build_descriptor_types()
	. = list()
	for(var/type in typesof(/datum/mob_descriptor))
		if(is_abstract(type))
			continue
		.[type] = new type()
	return .

#define DESCRIPTOR_CHOICE(choice_type) GLOB.descriptor_choices[choice_type]
GLOBAL_LIST_INIT(descriptor_choices, build_descriptor_choices())

/proc/build_descriptor_choices()
	. = list()
	for(var/type in typesof(/datum/descriptor_choice))
		if(is_abstract(type))
			continue
		.[type] = new type()
	return .
