/datum/descriptor_choice
	abstract_type = /datum/descriptor_choice
	var/name = "Descriptor"
	var/default_descriptor
	var/list/descriptors = list()

/datum/descriptor_choice/face
	name = "Face"
	default_descriptor = /datum/mob_descriptor/face/unremarkable
	descriptors = list(
		/datum/mob_descriptor/face/unremarkable,
		/datum/mob_descriptor/face/smooth,
		/datum/mob_descriptor/face/rough,
		/datum/mob_descriptor/face/chiseled,
		/datum/mob_descriptor/face/scarred,
		/datum/mob_descriptor/face/angular,
		/datum/mob_descriptor/face/gaunt,
		/datum/mob_descriptor/face/round,
		/datum/mob_descriptor/face/delicate,
		/datum/mob_descriptor/face/soft,
		/datum/mob_descriptor/face/sharp,
		/datum/mob_descriptor/face/sleek,
		/datum/mob_descriptor/face/broad,
		/datum/mob_descriptor/face/disfigured,
		/datum/mob_descriptor/face/tall,
		/datum/mob_descriptor/face/chubby,
		/datum/mob_descriptor/face/mousy,
		/datum/mob_descriptor/face/full,
	)

/datum/descriptor_choice/face_exp
	name = "Resting Expression"
	descriptors = list(
		/datum/mob_descriptor/face_exp/refined,
		/datum/mob_descriptor/face_exp/disinterested,
		/datum/mob_descriptor/face_exp/sour,
		/datum/mob_descriptor/face_exp/bright,
		/datum/mob_descriptor/face_exp/starry_eyed,
		/datum/mob_descriptor/face_exp/cold,
		/datum/mob_descriptor/face_exp/haggard,
		/datum/mob_descriptor/face_exp/fake,
		/datum/mob_descriptor/face_exp/bitchy,
		/datum/mob_descriptor/face_exp/spiteful,
		/datum/mob_descriptor/face_exp/warm,
		/datum/mob_descriptor/face_exp/salacious,
		/datum/mob_descriptor/face_exp/contemptous,
		/datum/mob_descriptor/face_exp/mocking,
		/datum/mob_descriptor/face_exp/knowing,
		/datum/mob_descriptor/face_exp/cocky,
		/datum/mob_descriptor/face_exp/coy,
		/datum/mob_descriptor/face_exp/frustrated,
		/datum/mob_descriptor/face_exp/stern,
		/datum/mob_descriptor/face_exp/genuine,
		/datum/mob_descriptor/face_exp/jaded,
		/datum/mob_descriptor/face_exp/inquisitive,
		/datum/mob_descriptor/face_exp/suspicious,
		/datum/mob_descriptor/face_exp/tender,
		/datum/mob_descriptor/face_exp/affectionate,
		/datum/mob_descriptor/face_exp/calm,
		/datum/mob_descriptor/face_exp/cutthroat,
		/datum/mob_descriptor/face_exp/suave,
		/datum/mob_descriptor/face_exp/humble,
		/datum/mob_descriptor/face_exp/smug,
	)

/datum/descriptor_choice/body
	name = "Body"
	default_descriptor = /datum/mob_descriptor/body/average
	descriptors = list(
		/datum/mob_descriptor/body/average,
		/datum/mob_descriptor/body/athletic,
		/datum/mob_descriptor/body/muscular,
		/datum/mob_descriptor/body/herculean,
		/datum/mob_descriptor/body/plump,
		/datum/mob_descriptor/body/pearshaped,
		/datum/mob_descriptor/body/pudgy,
		/datum/mob_descriptor/body/strongfat,
		/datum/mob_descriptor/body/round,
		/datum/mob_descriptor/body/heavy,
		/datum/mob_descriptor/body/topheavy,
		/datum/mob_descriptor/body/bottomheavy,
		/datum/mob_descriptor/body/curvy,
		/datum/mob_descriptor/body/voluptuous,
		/datum/mob_descriptor/body/decrepit,
		/datum/mob_descriptor/body/thin,
		/datum/mob_descriptor/body/bulky,
		/datum/mob_descriptor/body/slender,
		/datum/mob_descriptor/body/lissome,
		/datum/mob_descriptor/body/lanky,
		/datum/mob_descriptor/body/twiggy,
		/datum/mob_descriptor/body/dainty,
		/datum/mob_descriptor/body/petite,
		/datum/mob_descriptor/body/gaunt,
		/datum/mob_descriptor/body/lean,
		/datum/mob_descriptor/body/skeletal,
		/datum/mob_descriptor/body/broadshoulder,
		/datum/mob_descriptor/body/waspwaist,
		/datum/mob_descriptor/body/burly,
	)

/datum/descriptor_choice/stature
	name = "Stature"
	default_descriptor = /datum/mob_descriptor/stature/man
	descriptors = list(
		/datum/mob_descriptor/stature/man,
		/datum/mob_descriptor/stature/gentleman,
		/datum/mob_descriptor/stature/hag,
		/datum/mob_descriptor/stature/patriarch,
		/datum/mob_descriptor/stature/villain,
		/datum/mob_descriptor/stature/thug,
		/datum/mob_descriptor/stature/knave,
		/datum/mob_descriptor/stature/wench,
		/datum/mob_descriptor/stature/snob,
		/datum/mob_descriptor/stature/slob,
		/datum/mob_descriptor/stature/brute,
		/datum/mob_descriptor/stature/highbrow,
		/datum/mob_descriptor/stature/scholar,
		/datum/mob_descriptor/stature/rogue,
		/datum/mob_descriptor/stature/hermit,
		/datum/mob_descriptor/stature/pushover,
		/datum/mob_descriptor/stature/beguiler,
		/datum/mob_descriptor/stature/fiend,
		/datum/mob_descriptor/stature/adventurer,
		/datum/mob_descriptor/stature/valiant,
		/datum/mob_descriptor/stature/plump,
		/datum/mob_descriptor/stature/daredevil,
		/datum/mob_descriptor/stature/stoic,
		/datum/mob_descriptor/stature/stooge,
		/datum/mob_descriptor/stature/fool,
		/datum/mob_descriptor/stature/bookworm,
		/datum/mob_descriptor/stature/lowlife,
		/datum/mob_descriptor/stature/dignitary,
		/datum/mob_descriptor/stature/degenerate,
		/datum/mob_descriptor/stature/zealot,
		/datum/mob_descriptor/stature/churl,
		/datum/mob_descriptor/stature/archon,
		/datum/mob_descriptor/stature/vizier,
		/datum/mob_descriptor/stature/blaggard,
		/datum/mob_descriptor/stature/creep,
		/datum/mob_descriptor/stature/freek,
		/datum/mob_descriptor/stature/weerdoe,
		/datum/mob_descriptor/stature/socialite,
		/datum/mob_descriptor/stature/recluse,
		/datum/mob_descriptor/stature/soldier,
		/datum/mob_descriptor/stature/pupil,
		/datum/mob_descriptor/stature/samaritan,
		/datum/mob_descriptor/stature/hustler,
		/datum/mob_descriptor/stature/wanderer,
		/datum/mob_descriptor/stature/savant,
		/datum/mob_descriptor/stature/shitheel,
		/datum/mob_descriptor/stature/critter,
		/datum/mob_descriptor/stature/creacher,
		/datum/mob_descriptor/stature/cur,
		/datum/mob_descriptor/stature/wretch,
		/datum/mob_descriptor/stature/dullard,
		/datum/mob_descriptor/stature/basterd,
	)

/datum/descriptor_choice/voice
	name = "Voice"
	default_descriptor = /datum/mob_descriptor/voice/ordinary
	descriptors = list(
		/datum/mob_descriptor/voice/ordinary,
		/datum/mob_descriptor/voice/monotone,
		/datum/mob_descriptor/voice/deep,
		/datum/mob_descriptor/voice/soft,
		/datum/mob_descriptor/voice/shrill,
		/datum/mob_descriptor/voice/sleepy,
		/datum/mob_descriptor/voice/commanding,
		/datum/mob_descriptor/voice/kind,
		/datum/mob_descriptor/voice/growly,
		/datum/mob_descriptor/voice/androgynous,
		/datum/mob_descriptor/voice/nasal,
		/datum/mob_descriptor/voice/refined,
		/datum/mob_descriptor/voice/cheery,
		/datum/mob_descriptor/voice/dispassionate,
		/datum/mob_descriptor/voice/gravelly,
		/datum/mob_descriptor/voice/whiny,
		/datum/mob_descriptor/voice/melodic,
		/datum/mob_descriptor/voice/drawling,
		/datum/mob_descriptor/voice/stilted,
		/datum/mob_descriptor/voice/grave,
		/datum/mob_descriptor/voice/doting,
		/datum/mob_descriptor/voice/booming,
		/datum/mob_descriptor/voice/lisping,
		/datum/mob_descriptor/voice/honeyed,
		/datum/mob_descriptor/voice/facetious,
		/datum/mob_descriptor/voice/snide,
		/datum/mob_descriptor/voice/smoker,
		/datum/mob_descriptor/voice/venomous,
	)

/datum/descriptor_choice/skin
	name = "Skin"
	default_descriptor = /datum/mob_descriptor/skin/normal
	descriptors = list(
		/datum/mob_descriptor/skin/normal,
		/datum/mob_descriptor/skin/hairy,
		/datum/mob_descriptor/skin/soft,
		/datum/mob_descriptor/skin/rugged,
		/datum/mob_descriptor/skin/diseased,
		/datum/mob_descriptor/skin/dry,
		/datum/mob_descriptor/skin/fine,
		/datum/mob_descriptor/skin/wrinkled,
		/datum/mob_descriptor/skin/sunkissed,
		/datum/mob_descriptor/skin/aged,
		/datum/mob_descriptor/skin/pockmarked,
		/datum/mob_descriptor/skin/dusky,
		/datum/mob_descriptor/skin/irritated,
		/datum/mob_descriptor/skin/ashen,
	)

/datum/descriptor_choice/scales
	name = "Scales"
	default_descriptor = /datum/mob_descriptor/scales/plain
	descriptors = list(
		/datum/mob_descriptor/scales/plain,
		/datum/mob_descriptor/scales/rough,
		/datum/mob_descriptor/scales/smooth,
		/datum/mob_descriptor/scales/plated,
		/datum/mob_descriptor/scales/peeling,
	)

/datum/descriptor_choice/fur
	name = "Fur"
	default_descriptor = /datum/mob_descriptor/fur/plain
	descriptors = list(
		/datum/mob_descriptor/fur/plain,
		/datum/mob_descriptor/fur/short,
		/datum/mob_descriptor/fur/coarse,
		/datum/mob_descriptor/fur/bristly,
		/datum/mob_descriptor/fur/fluffy,
		/datum/mob_descriptor/fur/shaggy,
		/datum/mob_descriptor/fur/silky,
		/datum/mob_descriptor/fur/lank,
		/datum/mob_descriptor/fur/mangy,
		/datum/mob_descriptor/fur/velvety,
		/datum/mob_descriptor/fur/dense,
		/datum/mob_descriptor/fur/matted,
	)

/datum/descriptor_choice/feathers
	name = "Feathers"
	descriptors = list(
		/datum/mob_descriptor/feathers/fine,
		/datum/mob_descriptor/feathers/stiff,
		/datum/mob_descriptor/feathers/frayed,
		/datum/mob_descriptor/feathers/delicate,
		/datum/mob_descriptor/feathers/soft,
	)

/datum/descriptor_choice/chitin
	name = "Chitin"
	descriptors = list(
		/datum/mob_descriptor/chitin/smooth,
		/datum/mob_descriptor/chitin/hard,
		/datum/mob_descriptor/chitin/fine,
	)
/datum/descriptor_choice/height
	name = "Height"
	default_descriptor = /datum/mob_descriptor/height/moderate
	descriptors = list(
		/datum/mob_descriptor/height/moderate,
		/datum/mob_descriptor/height/middling,
		/datum/mob_descriptor/height/tall,
		/datum/mob_descriptor/height/short,
		/datum/mob_descriptor/height/towering,
		/datum/mob_descriptor/height/giant,
		/datum/mob_descriptor/height/tiny,
	)
/datum/descriptor_choice/trait
	name = "Physical Descriptor"
	default_descriptor = /datum/mob_descriptor/trait/moderate
	descriptors = list(
		/datum/mob_descriptor/trait/moderate,
		/datum/mob_descriptor/trait/mundane,
		/datum/mob_descriptor/trait/middling,
		/datum/mob_descriptor/trait/tall,
		/datum/mob_descriptor/trait/short,
		/datum/mob_descriptor/trait/dainty,
		/datum/mob_descriptor/trait/towering,
		/datum/mob_descriptor/trait/giant,
		/datum/mob_descriptor/trait/tiny,
		/datum/mob_descriptor/trait/stout,
		/datum/mob_descriptor/trait/cadaverous,
		/datum/mob_descriptor/trait/lanky,
		/datum/mob_descriptor/trait/wide,
		/datum/mob_descriptor/trait/thin,
		/datum/mob_descriptor/trait/zardish,
		/datum/mob_descriptor/trait/lupian,
		/datum/mob_descriptor/trait/venardic,
		/datum/mob_descriptor/trait/feline,
		/datum/mob_descriptor/trait/elven,
		/datum/mob_descriptor/trait/rousley,
		/datum/mob_descriptor/trait/blessed,
		/datum/mob_descriptor/trait/accursed,
		/datum/mob_descriptor/trait/aquatic,
		/datum/mob_descriptor/trait/horned,
		/datum/mob_descriptor/trait/snoutly,
		/datum/mob_descriptor/trait/tailed,
		/datum/mob_descriptor/trait/fanged,
		/datum/mob_descriptor/trait/clawed,
		/datum/mob_descriptor/trait/tusked,
		/datum/mob_descriptor/trait/furred,
		/datum/mob_descriptor/trait/feathered,
		/datum/mob_descriptor/trait/scaly,
		/datum/mob_descriptor/trait/crimson,
		/datum/mob_descriptor/trait/cerulean,
		/datum/mob_descriptor/trait/emerald,
		/datum/mob_descriptor/trait/amber,
		/datum/mob_descriptor/trait/disfigured,
		/datum/mob_descriptor/trait/loutish,
		/datum/mob_descriptor/trait/limping,
		/datum/mob_descriptor/trait/foreign,
	)

/datum/descriptor_choice/skin_all
	name = "Skin/Fur/Scales"
	default_descriptor = /datum/mob_descriptor/fur/plain
	descriptors = list(
		/datum/mob_descriptor/skin/normal,
		/datum/mob_descriptor/skin/hairy,
		/datum/mob_descriptor/skin/soft,
		/datum/mob_descriptor/skin/rugged,
		/datum/mob_descriptor/skin/diseased,
		/datum/mob_descriptor/skin/dry,
		/datum/mob_descriptor/skin/fine,
		/datum/mob_descriptor/skin/wrinkled,
		/datum/mob_descriptor/skin/sunkissed,
		/datum/mob_descriptor/skin/aged,
		/datum/mob_descriptor/skin/pockmarked,
		/datum/mob_descriptor/skin/dusky,
		/datum/mob_descriptor/skin/irritated,
		/datum/mob_descriptor/skin/ashen,
		/datum/mob_descriptor/scales/plain,
		/datum/mob_descriptor/scales/rough,
		/datum/mob_descriptor/scales/smooth,
		/datum/mob_descriptor/scales/plated,
		/datum/mob_descriptor/scales/peeling,
		/datum/mob_descriptor/fur/plain,
		/datum/mob_descriptor/fur/short,
		/datum/mob_descriptor/fur/coarse,
		/datum/mob_descriptor/fur/bristly,
		/datum/mob_descriptor/fur/fluffy,
		/datum/mob_descriptor/fur/shaggy,
		/datum/mob_descriptor/fur/silky,
		/datum/mob_descriptor/fur/lank,
		/datum/mob_descriptor/fur/mangy,
		/datum/mob_descriptor/fur/velvety,
		/datum/mob_descriptor/fur/dense,
		/datum/mob_descriptor/fur/matted,
		/datum/mob_descriptor/feathers/fine,
		/datum/mob_descriptor/feathers/stiff,
		/datum/mob_descriptor/feathers/frayed,
		/datum/mob_descriptor/feathers/delicate,
		/datum/mob_descriptor/feathers/soft,
	)

#define PROMINENT_DESCRIPTORS \
	/datum/mob_descriptor/prominent/hunched_over,\
	/datum/mob_descriptor/prominent/drooling,\
	/datum/mob_descriptor/prominent/lazy_eye,\
	/datum/mob_descriptor/prominent/bloodshot_eye,\
	/datum/mob_descriptor/prominent/baggy_eye,\
	/datum/mob_descriptor/prominent/twitchy,\
	/datum/mob_descriptor/prominent/clumsy,\
	/datum/mob_descriptor/prominent/unkempt,\
	/datum/mob_descriptor/prominent/tidy,\
	/datum/mob_descriptor/prominent/eloquent,\
	/datum/mob_descriptor/prominent/thick_tail,\
	/datum/mob_descriptor/prominent/cleft_lip,\
	/datum/mob_descriptor/prominent/physically_deformed,\
	/datum/mob_descriptor/prominent/extensive_scars,\
	/datum/mob_descriptor/prominent/move_strange,\
	/datum/mob_descriptor/prominent/ghoulish_appearance,\
	/datum/mob_descriptor/prominent/prominent_chest,\
	/datum/mob_descriptor/prominent/prominent_thighs,\
	/datum/mob_descriptor/prominent/prominent_shoulders,\
	/datum/mob_descriptor/prominent/prominent_jawline,\
	/datum/mob_descriptor/prominent/prominent_bottom,\
	/datum/mob_descriptor/prominent/prominent_potbelly,\
	/datum/mob_descriptor/prominent/cold_gaze,\
	/datum/mob_descriptor/prominent/piercing_gaze,\
	/datum/mob_descriptor/prominent/innocent_gaze,\
	/datum/mob_descriptor/prominent/promiscuous_mannerisms,\
	/datum/mob_descriptor/prominent/intimidating_presence,\
	/datum/mob_descriptor/prominent/meek_presence,\
	/datum/mob_descriptor/prominent/adorable_presence,\
	/datum/mob_descriptor/prominent/lordly_presence,\
	/datum/mob_descriptor/prominent/doting_presence,\
	/datum/mob_descriptor/prominent/aristocratic_haughtiness,\
	/datum/mob_descriptor/prominent/ghastly_pale,\
	/datum/mob_descriptor/prominent/elaborate_tattoos,\
	/datum/mob_descriptor/prominent/ritual_tattoos,\
	/datum/mob_descriptor/prominent/tribal_tattoos,\
	/datum/mob_descriptor/prominent/slave_tattoos,\
	/datum/mob_descriptor/prominent/enigmatic_tattoos,\
	/datum/mob_descriptor/prominent/mean_look,\
	/datum/mob_descriptor/prominent/haughty_atmosphere,\
	/datum/mob_descriptor/prominent/untrustworthy,\
	/datum/mob_descriptor/prominent/ratty_hair,\
	/datum/mob_descriptor/prominent/predatory_look,\
	/datum/mob_descriptor/prominent/chaste_mannerism,\
	/datum/mob_descriptor/prominent/whimsy,\
	/datum/mob_descriptor/prominent/dim_look,\
	/datum/mob_descriptor/prominent/custom/one,\
	/datum/mob_descriptor/prominent/custom/two

#define PROMINENT_WILDKIN \
	/datum/mob_descriptor/prominent/canine_features,\
	/datum/mob_descriptor/prominent/feline_features,\
	/datum/mob_descriptor/prominent/hyaenidae_features,\
	/datum/mob_descriptor/prominent/equine_features,\
	/datum/mob_descriptor/prominent/bovine_features,\
	/datum/mob_descriptor/prominent/cervine_features,\
	/datum/mob_descriptor/prominent/lapine_features,\
	/datum/mob_descriptor/prominent/rodent_features,\
	/datum/mob_descriptor/prominent/primate_features,\
	/datum/mob_descriptor/prominent/marsupial_features,\
	/datum/mob_descriptor/prominent/lizard_features,\
	/datum/mob_descriptor/prominent/avian_features,\
	/datum/mob_descriptor/prominent/amphibian_features,\
	/datum/mob_descriptor/prominent/insectoid_features,\
	/datum/mob_descriptor/prominent/marine_features,\
	/datum/mob_descriptor/prominent/vulpine_features

/datum/descriptor_choice/prominent_one
	name = "Prominent #1"
	default_descriptor = /datum/mob_descriptor/prominent/unkempt
	descriptors = list(PROMINENT_DESCRIPTORS)

/datum/descriptor_choice/prominent_two
	name = "Prominent #2"
	default_descriptor = /datum/mob_descriptor/prominent/dim_look
	descriptors = list(PROMINENT_DESCRIPTORS)

/datum/descriptor_choice/prominent_three
	name = "Prominent #3"
	default_descriptor = /datum/mob_descriptor/prominent/none
	descriptors = list(/datum/mob_descriptor/prominent/none, PROMINENT_DESCRIPTORS)

/datum/descriptor_choice/prominent_four
	name = "Prominent #4"
	default_descriptor = /datum/mob_descriptor/prominent/none
	descriptors = list(/datum/mob_descriptor/prominent/none, PROMINENT_DESCRIPTORS)

/datum/descriptor_choice/prominent_one_wild
	name = "Prominent #1"
	default_descriptor = /datum/mob_descriptor/prominent/unkempt
	descriptors = list(PROMINENT_WILDKIN, PROMINENT_DESCRIPTORS)

/datum/descriptor_choice/prominent_two_wild
	name = "Prominent #2"
	default_descriptor = /datum/mob_descriptor/prominent/dim_look
	descriptors = list(PROMINENT_WILDKIN, PROMINENT_DESCRIPTORS)

/datum/descriptor_choice/prominent_three_wild
	name = "Prominent #3"
	default_descriptor = /datum/mob_descriptor/prominent/none
	descriptors = list(/datum/mob_descriptor/prominent/none, PROMINENT_WILDKIN, PROMINENT_DESCRIPTORS)

/datum/descriptor_choice/prominent_four_wild
	name = "Prominent #4"
	default_descriptor = /datum/mob_descriptor/prominent/none
	descriptors = list(/datum/mob_descriptor/prominent/none, PROMINENT_WILDKIN, PROMINENT_DESCRIPTORS)

#undef PROMINENT_DESCRIPTORS
#undef PROMINENT_WILDKIN
