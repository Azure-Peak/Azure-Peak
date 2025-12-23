/datum/customizer/organ/snout
	abstract_type = /datum/customizer/organ/snout
	name = "Snout"

/datum/customizer_choice/organ/snout
	abstract_type = /datum/customizer_choice/organ/snout
	name = "Snout"
	organ_type = /obj/item/organ/snout
	organ_slot = ORGAN_SLOT_SNOUT

/datum/customizer/organ/snout/lizard
	customizer_choices = list(/datum/customizer_choice/organ/snout/lizard)

/datum/customizer_choice/organ/snout/lizard
	name = "Lizard Snout"
	organ_type = /obj/item/organ/snout/lizard
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/snout/sharp,
		/datum/sprite_accessory/snout/sharpdualcolor,
		/datum/sprite_accessory/snout/round,
		/datum/sprite_accessory/snout/rounddualcolor,
		/datum/sprite_accessory/snout/sharplight,
		/datum/sprite_accessory/snout/sharplightdualcolor,
		/datum/sprite_accessory/snout/roundlight,
		/datum/sprite_accessory/snout/roundlightdualcolor,
		/datum/sprite_accessory/snout/front/sharp,
		/datum/sprite_accessory/snout/front/round,
		/datum/sprite_accessory/snout/front/sharplight,
		/datum/sprite_accessory/snout/front/roundlight,
		/datum/sprite_accessory/snout/stubby,
		/datum/sprite_accessory/snout/stubbyalt,
		)

/datum/customizer/organ/snout/vulpkanin
	customizer_choices = list(/datum/customizer_choice/organ/snout/vulpkanin)

/datum/customizer_choice/organ/snout/vulpkanin
	name = "Vulpkian Snout"
	organ_type = /obj/item/organ/snout/vulpkanin
	sprite_accessories = list(
		/datum/sprite_accessory/snout/lcanid,
		/datum/sprite_accessory/snout/lcanidalt,
		/datum/sprite_accessory/snout/lcanidstriped,
		/datum/sprite_accessory/snout/lcanidstripedalt,
		/datum/sprite_accessory/snout/vulp,
		/datum/sprite_accessory/snout/hjackal,
		/datum/sprite_accessory/snout/front/husky,
		/datum/sprite_accessory/snout/front/lcanid,
		/datum/sprite_accessory/snout/front/lcanidalt,
		/datum/sprite_accessory/snout/front/lcanidstriped,
		/datum/sprite_accessory/snout/front/lcanidstripedalt,
		/datum/sprite_accessory/snout/front/scanid,
		/datum/sprite_accessory/snout/front/scanidalt,
		/datum/sprite_accessory/snout/front/scanidalt2,
		/datum/sprite_accessory/snout/front/scanidalt3,
		/datum/sprite_accessory/snout/front/wolf,
		/datum/sprite_accessory/snout/front/wolfalt
		)

/datum/customizer/organ/snout/lupian
	customizer_choices = list(/datum/customizer_choice/organ/snout/lupian)

/datum/customizer_choice/organ/snout/lupian
	name = "Lupian Snout"
	organ_type = /obj/item/organ/snout/lupian
	sprite_accessories = list(
		/datum/sprite_accessory/snout/husky,
		/datum/sprite_accessory/snout/lcanid,
		/datum/sprite_accessory/snout/lcanidalt,
		/datum/sprite_accessory/snout/scanid,
		/datum/sprite_accessory/snout/scanidalt,
		/datum/sprite_accessory/snout/scanidalt2,
		/datum/sprite_accessory/snout/scanidalt3,
		/datum/sprite_accessory/snout/wolf,
		/datum/sprite_accessory/snout/wolfalt,
		/datum/sprite_accessory/snout/otie,
		/datum/sprite_accessory/snout/hjackal,
		/datum/sprite_accessory/snout/front/husky,
		/datum/sprite_accessory/snout/front/lcanid,
		/datum/sprite_accessory/snout/front/lcanidalt,
		/datum/sprite_accessory/snout/front/lcanidstriped,
		/datum/sprite_accessory/snout/front/lcanidstripedalt,
		/datum/sprite_accessory/snout/front/scanid,
		/datum/sprite_accessory/snout/front/scanidalt,
		/datum/sprite_accessory/snout/front/scanidalt2,
		/datum/sprite_accessory/snout/front/scanidalt3,
		/datum/sprite_accessory/snout/front/wolf,
		/datum/sprite_accessory/snout/front/wolfalt,
		/datum/sprite_accessory/snout/front/otie,
		/datum/sprite_accessory/snout/hpanda,
		/datum/sprite_accessory/snout/vulp
		)

/datum/customizer/organ/snout/tajaran
	customizer_choices = list(/datum/customizer_choice/organ/snout/tajaran)

/datum/customizer_choice/organ/snout/tajaran
	name = "Tajaran Snout"
	organ_type = /obj/item/organ/snout/tajaran
	sprite_accessories = list(
		/datum/sprite_accessory/snout/tajaran,
		/datum/sprite_accessory/snout/scanid,
		/datum/sprite_accessory/snout/scanidalt,
		/datum/sprite_accessory/snout/scanidalt2,
		/datum/sprite_accessory/snout/scanidalt3,
		/datum/sprite_accessory/snout/front/scanid,
		/datum/sprite_accessory/snout/front/scanidalt,
		/datum/sprite_accessory/snout/front/scanidalt2,
		/datum/sprite_accessory/snout/front/scanidalt3,
		/datum/sprite_accessory/snout/sharp,
		/datum/sprite_accessory/snout/round,
		/datum/sprite_accessory/snout/sharplight,
		/datum/sprite_accessory/snout/roundlight,
		/datum/sprite_accessory/snout/front/sharp,
		/datum/sprite_accessory/snout/front/round,
		/datum/sprite_accessory/snout/front/sharplight,
		/datum/sprite_accessory/snout/front/roundlight,
		/datum/sprite_accessory/snout/stubby,
		/datum/sprite_accessory/snout/stubbyalt,
		)

/datum/customizer/organ/snout/anthro
	allows_disabling = TRUE
	default_disabled = TRUE
	customizer_choices = list(/datum/customizer_choice/organ/snout/anthro)

/datum/customizer/organ/snout/anthrosmall
	allows_disabling = TRUE
	default_disabled = FALSE
	customizer_choices = list(/datum/customizer_choice/organ/snout/anthro)

/datum/customizer/organ/snout/anthro/dullahan
	allows_disabling = TRUE
	default_disabled = TRUE
	customizer_choices = list(/datum/customizer_choice/organ/snout/anthro/dullahan)

/datum/customizer_choice/organ/snout/anthro
	name = "Wild-Kin Snout"
	organ_type = /obj/item/organ/snout/anthro
	sprite_accessories = list(
		/datum/sprite_accessory/snout/bird,
		/datum/sprite_accessory/snout/bigbeak,
		/datum/sprite_accessory/snout/bigbeakshort,
		/datum/sprite_accessory/snout/skulldog,
		/datum/sprite_accessory/snout/slimbeak,
		/datum/sprite_accessory/snout/slimbeakshort,
		/datum/sprite_accessory/snout/slimbeakalt,
		/datum/sprite_accessory/snout/hookbeak,
		/datum/sprite_accessory/snout/hookbeakbig,
		/datum/sprite_accessory/snout/bug,
		/datum/sprite_accessory/snout/bugna,
		/datum/sprite_accessory/snout/elephant,
		/datum/sprite_accessory/snout/husky,
		/datum/sprite_accessory/snout/rhino,
		/datum/sprite_accessory/snout/bovine,
		/datum/sprite_accessory/snout/rodent,
		/datum/sprite_accessory/snout/lcanid,
		/datum/sprite_accessory/snout/lcanidalt,
		/datum/sprite_accessory/snout/lcanidstriped,
		/datum/sprite_accessory/snout/lcanidstripedalt,
		/datum/sprite_accessory/snout/scanid,
		/datum/sprite_accessory/snout/scanidalt,
		/datum/sprite_accessory/snout/scanidalt2,
		/datum/sprite_accessory/snout/scanidalt3,
		/datum/sprite_accessory/snout/tajaran,
		/datum/sprite_accessory/snout/wolf,
		/datum/sprite_accessory/snout/wolfalt,
		/datum/sprite_accessory/snout/otie,
		/datum/sprite_accessory/snout/otiesmile,
		/datum/sprite_accessory/snout/pede,
		/datum/sprite_accessory/snout/sergal,
		/datum/sprite_accessory/snout/shark,
		/datum/sprite_accessory/snout/toucan,
		/datum/sprite_accessory/snout/redpanda,
		/datum/sprite_accessory/snout/redpandaalt,
		/datum/sprite_accessory/snout/sbeak,
		/datum/sprite_accessory/snout/rat,
		/datum/sprite_accessory/snout/stubby,
		/datum/sprite_accessory/snout/alienlizard,
		/datum/sprite_accessory/snout/alienlizardteeth,
		/datum/sprite_accessory/snout/hanubus,
		/datum/sprite_accessory/snout/hpanda,
		/datum/sprite_accessory/snout/hjackal,
		/datum/sprite_accessory/snout/hspots,
		/datum/sprite_accessory/snout/hhorse,
		/datum/sprite_accessory/snout/hzebra,
		/datum/sprite_accessory/snout/front/bird,
		/datum/sprite_accessory/snout/front/bigbeak,
		/datum/sprite_accessory/snout/front/bug,
		/datum/sprite_accessory/snout/front/bugna,
		/datum/sprite_accessory/snout/front/elephant,
		/datum/sprite_accessory/snout/front/rhino,
		/datum/sprite_accessory/snout/front/bovine,
		/datum/sprite_accessory/snout/front/husky,
		/datum/sprite_accessory/snout/front/lcanid,
		/datum/sprite_accessory/snout/front/lcanidalt,
		/datum/sprite_accessory/snout/front/lcanidstriped,
		/datum/sprite_accessory/snout/front/lcanidstripedalt,
		/datum/sprite_accessory/snout/front/scanid,
		/datum/sprite_accessory/snout/front/scanidalt,
		/datum/sprite_accessory/snout/front/scanidalt2,
		/datum/sprite_accessory/snout/front/scanidalt3,
		/datum/sprite_accessory/snout/front/wolf,
		/datum/sprite_accessory/snout/front/wolfalt,
		/datum/sprite_accessory/snout/front/otie,
		/datum/sprite_accessory/snout/front/otiesmile,
		/datum/sprite_accessory/snout/front/rodent,
		/datum/sprite_accessory/snout/front/pede,
		/datum/sprite_accessory/snout/front/sergal,
		/datum/sprite_accessory/snout/front/toucan,
		/datum/sprite_accessory/snout/front/redpanda,
		/datum/sprite_accessory/snout/front/redpandaalt,
		/datum/sprite_accessory/snout/sharp,
		/datum/sprite_accessory/snout/round,
		/datum/sprite_accessory/snout/sharplight,
		/datum/sprite_accessory/snout/roundlight,
		/datum/sprite_accessory/snout/vulp,
		/datum/sprite_accessory/snout/front/sharp,
		/datum/sprite_accessory/snout/front/round,
		/datum/sprite_accessory/snout/front/sharplight,
		/datum/sprite_accessory/snout/front/roundlight,
		/datum/sprite_accessory/snout/shortnosed,
		/datum/sprite_accessory/snout/stubby,
		/datum/sprite_accessory/snout/stubbyalt,
		)

/datum/customizer_choice/organ/snout/anthro/dullahan
	name = "Dullahan Snout"
	organ_type = /obj/item/organ/snout/anthro
	sprite_accessories = list(
		/datum/sprite_accessory/snout/bird,
		/datum/sprite_accessory/snout/bigbeak,
		/datum/sprite_accessory/snout/bigbeakshort,
		/datum/sprite_accessory/snout/slimbeak,
		/datum/sprite_accessory/snout/slimbeakshort,
		/datum/sprite_accessory/snout/slimbeakalt,
		/datum/sprite_accessory/snout/hookbeak,
		/datum/sprite_accessory/snout/hookbeakbig,
		/datum/sprite_accessory/snout/bug,
		/datum/sprite_accessory/snout/bugna,
		/datum/sprite_accessory/snout/elephant,
		/datum/sprite_accessory/snout/husky,
		/datum/sprite_accessory/snout/rhino,
		/datum/sprite_accessory/snout/bovine,
		/datum/sprite_accessory/snout/rodent,
		/datum/sprite_accessory/snout/lcanid,
		/datum/sprite_accessory/snout/lcanidalt,
		/datum/sprite_accessory/snout/lcanidstriped,
		/datum/sprite_accessory/snout/lcanidstripedalt,
		/datum/sprite_accessory/snout/scanid,
		/datum/sprite_accessory/snout/scanidalt,
		/datum/sprite_accessory/snout/scanidalt2,
		/datum/sprite_accessory/snout/scanidalt3,
		/datum/sprite_accessory/snout/tajaran,
		/datum/sprite_accessory/snout/wolf,
		/datum/sprite_accessory/snout/wolfalt,
		/datum/sprite_accessory/snout/otie,
		/datum/sprite_accessory/snout/otiesmile,
		/datum/sprite_accessory/snout/pede,
		/datum/sprite_accessory/snout/sergal,
		/datum/sprite_accessory/snout/shark,
		/datum/sprite_accessory/snout/toucan,
		/datum/sprite_accessory/snout/redpanda,
		/datum/sprite_accessory/snout/redpandaalt,
		/datum/sprite_accessory/snout/sbeak,
		/datum/sprite_accessory/snout/rat,
		/datum/sprite_accessory/snout/stubby,
		/datum/sprite_accessory/snout/alienlizard,
		/datum/sprite_accessory/snout/alienlizardteeth,
		/datum/sprite_accessory/snout/skulldog,
		/datum/sprite_accessory/snout/front/skulldog,
		/datum/sprite_accessory/snout/hanubus,
		/datum/sprite_accessory/snout/hpanda,
		/datum/sprite_accessory/snout/hjackal,
		/datum/sprite_accessory/snout/hspots,
		/datum/sprite_accessory/snout/hhorse,
		/datum/sprite_accessory/snout/hzebra,
		/datum/sprite_accessory/snout/front/bird,
		/datum/sprite_accessory/snout/front/bigbeak,
		/datum/sprite_accessory/snout/front/bug,
		/datum/sprite_accessory/snout/front/bugna,
		/datum/sprite_accessory/snout/front/elephant,
		/datum/sprite_accessory/snout/front/rhino,
		/datum/sprite_accessory/snout/front/bovine,
		/datum/sprite_accessory/snout/front/husky,
		/datum/sprite_accessory/snout/front/lcanid,
		/datum/sprite_accessory/snout/front/lcanidalt,
		/datum/sprite_accessory/snout/front/lcanidstriped,
		/datum/sprite_accessory/snout/front/lcanidstripedalt,
		/datum/sprite_accessory/snout/front/scanid,
		/datum/sprite_accessory/snout/front/scanidalt,
		/datum/sprite_accessory/snout/front/scanidalt2,
		/datum/sprite_accessory/snout/front/scanidalt3,
		/datum/sprite_accessory/snout/front/wolf,
		/datum/sprite_accessory/snout/front/wolfalt,
		/datum/sprite_accessory/snout/front/otie,
		/datum/sprite_accessory/snout/front/otiesmile,
		/datum/sprite_accessory/snout/front/rodent,
		/datum/sprite_accessory/snout/front/pede,
		/datum/sprite_accessory/snout/front/sergal,
		/datum/sprite_accessory/snout/front/toucan,
		/datum/sprite_accessory/snout/front/redpanda,
		/datum/sprite_accessory/snout/front/redpandaalt,
		/datum/sprite_accessory/snout/front/skulldog,
		/datum/sprite_accessory/snout/sharp,
		/datum/sprite_accessory/snout/round,
		/datum/sprite_accessory/snout/sharplight,
		/datum/sprite_accessory/snout/roundlight,
		/datum/sprite_accessory/snout/vulp,
		/datum/sprite_accessory/snout/front/sharp,
		/datum/sprite_accessory/snout/front/round,
		/datum/sprite_accessory/snout/front/sharplight,
		/datum/sprite_accessory/snout/front/roundlight,
		/datum/sprite_accessory/snout/shortnosed,
		/datum/sprite_accessory/snout/stubby,
		/datum/sprite_accessory/snout/stubbyalt,
		)

/datum/customizer/organ/snout/akula
	customizer_choices = list(/datum/customizer_choice/organ/snout/akula)

/datum/customizer_choice/organ/snout/akula
	name = "Axian Snout"
	organ_type = /obj/item/organ/snout/akula
	sprite_accessories = list(
		/datum/sprite_accessory/snout/shark,
		/datum/sprite_accessory/snout/sergal,
		/datum/sprite_accessory/snout/sharp,
		/datum/sprite_accessory/snout/round,
		/datum/sprite_accessory/snout/sharplight,
		/datum/sprite_accessory/snout/roundlight,
		/datum/sprite_accessory/snout/front/sharp,
		/datum/sprite_accessory/snout/front/round,
		/datum/sprite_accessory/snout/front/sharplight,
		/datum/sprite_accessory/snout/front/roundlight,
		/datum/sprite_accessory/snout/stubby,
		/datum/sprite_accessory/snout/stubbyalt,
		)

/datum/customizer/organ/snout/tabaxi
	customizer_choices = list(/datum/customizer_choice/organ/snout/tabaxi)

/datum/customizer_choice/organ/snout/tabaxi
	name = "Tabaxian Snout"
	organ_type = /obj/item/organ/snout/cat
	sprite_accessories = list(
	    /datum/sprite_accessory/snout/cat,
		/datum/sprite_accessory/snout/scanid,
		/datum/sprite_accessory/snout/scanidalt,
		/datum/sprite_accessory/snout/scanidalt2,
		/datum/sprite_accessory/snout/scanidalt3,
		/datum/sprite_accessory/snout/sharp,
		/datum/sprite_accessory/snout/round,
		/datum/sprite_accessory/snout/sharplight,
		/datum/sprite_accessory/snout/roundlight,
		/datum/sprite_accessory/snout/front/sharp,
		/datum/sprite_accessory/snout/front/round,
		/datum/sprite_accessory/snout/front/sharplight,
		/datum/sprite_accessory/snout/front/roundlight,
		/datum/sprite_accessory/snout/shortnosed,
		/datum/sprite_accessory/snout/stubby,
		/datum/sprite_accessory/snout/stubbyalt,
		)
