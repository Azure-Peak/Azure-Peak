/datum/customizer/organ/ears
	name = "Ears"
	abstract_type = /datum/customizer/organ/ears

/datum/customizer_choice/organ/ears
	name = "Ears"
	organ_type = /obj/item/organ/ears
	organ_slot = ORGAN_SLOT_EARS
	abstract_type = /datum/customizer_choice/organ/ears

// ---- Vulpkanin
/datum/customizer/organ/ears/vulpkanin
	customizer_choices = list(/datum/customizer_choice/organ/ears/vulpkanin)

/datum/customizer_choice/organ/ears/vulpkanin
	name = "Vulpkian Ears"
	organ_type = /obj/item/organ/ears/vulpkanin
	sprite_accessories = list(
		/datum/sprite_accessory/ears/fox,
		/datum/sprite_accessory/ears/vulp,
		/datum/sprite_accessory/ears/big/sandfox_large,
		/datum/sprite_accessory/ears/bigwolf,
		/datum/sprite_accessory/ears/bigwolf_inner,
		/datum/sprite_accessory/ears/fox,
		/datum/sprite_accessory/ears/husky,
		/datum/sprite_accessory/ears/otie,
		/datum/sprite_accessory/ears/wolf
		)

// ---- Lupian
/datum/customizer/organ/ears/lupian
	customizer_choices = list(/datum/customizer_choice/organ/ears/lupian)

/datum/customizer_choice/organ/ears/lupian
	name = "Lupian Ears"
	organ_type = /obj/item/organ/ears/lupian
	sprite_accessories = list(
		/datum/sprite_accessory/ears/bigwolf,
		/datum/sprite_accessory/ears/bigwolf_inner,
		/datum/sprite_accessory/ears/fox,
		/datum/sprite_accessory/ears/husky,
		/datum/sprite_accessory/ears/otie,
		/datum/sprite_accessory/ears/wolf,
		/datum/sprite_accessory/ears/lab
	)

// ---- Tajaran
/datum/customizer/organ/ears/tajaran
	customizer_choices = list(/datum/customizer_choice/organ/ears/tajaran)

/datum/customizer_choice/organ/ears/tajaran
	name = "Tabaxi Ears"
	organ_type = /obj/item/organ/ears/tajaran         // Renamed them IN GAME but in-code they're still 'tajaran' because im afraid of breaking shit
	sprite_accessories = list(
		/datum/sprite_accessory/ears/cat_big,
		/datum/sprite_accessory/ears/cat_normal,
		/datum/sprite_accessory/ears/miqote,
		/datum/sprite_accessory/ears/lynx,
		)

// ---- Axian
/datum/customizer/organ/ears/axian
	customizer_choices = list(/datum/customizer_choice/organ/ears/axian)

/datum/customizer_choice/organ/ears/axian
	name = "Axian Ears"
	organ_type = /obj/item/organ/ears/akula
	sprite_accessories = list(
		/datum/sprite_accessory/ears/shark,
		/datum/sprite_accessory/ears/sergal,
		)

// ---- Cat(?) no other mentions in the codebase
/datum/customizer/organ/ears/cat
	customizer_choices = list(/datum/customizer_choice/organ/ears/cat)

/datum/customizer_choice/organ/ears/cat
	name = "Cat Ears"
	organ_type = /obj/item/organ/ears/cat
	sprite_accessories = list(/datum/sprite_accessory/ears/cat)

// --- Elf
/datum/customizer_choice/organ/ears/elf
	name = "Elf Ears"
	organ_type = /obj/item/organ/ears
	sprite_accessories = list(
		/datum/sprite_accessory/ears/elf,
		/datum/sprite_accessory/ears/elfw,
		/datum/sprite_accessory/ears/elf_short)

/datum/customizer/organ/ears/elf
	customizer_choices = list(/datum/customizer_choice/organ/ears/elf)
	allows_disabling = TRUE

// ---- Goblin
/datum/customizer_choice/organ/ears/goblin
	name = "Goblin Ears"
	organ_type = /obj/item/organ/ears
	sprite_accessories = list(
		/datum/sprite_accessory/ears/goblin,
		/datum/sprite_accessory/ears/goblin_alt,
		/datum/sprite_accessory/ears/goblin_small,
		/datum/sprite_accessory/ears/halforc)

/datum/customizer/organ/ears/goblin 
	customizer_choices = list(/datum/customizer_choice/organ/ears/goblin)
	allows_disabling = FALSE

// ---- Half-Orc
/datum/customizer_choice/organ/ears/halforc
	name = "Half-Orc Ears"
	organ_type = /obj/item/organ/ears
	sprite_accessories = list(
		/datum/sprite_accessory/ears/goblin,
		/datum/sprite_accessory/ears/goblin_alt,
		/datum/sprite_accessory/ears/goblin_small,
		/datum/sprite_accessory/ears/halforc,
		/datum/sprite_accessory/ears/elf,
		/datum/sprite_accessory/ears/elfw)

/datum/customizer/organ/ears/halforc
	customizer_choices = list(/datum/customizer_choice/organ/ears/halforc)
	allows_disabling = FALSE

// ---- Demihuman
/datum/customizer/organ/ears/demihuman
	customizer_choices = list(/datum/customizer_choice/organ/ears/demihuman)
	allows_disabling = TRUE

/datum/customizer_choice/organ/ears/demihuman
	name = "Half-Kinhuman Ears"
	organ_type = /obj/item/organ/ears
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/ears/cat,
		/datum/sprite_accessory/ears/axolotl,
		/datum/sprite_accessory/ears/bat,
		/datum/sprite_accessory/ears/bear,
		/datum/sprite_accessory/ears/bigwolf,
		/datum/sprite_accessory/ears/bigwolf_inner,
		/datum/sprite_accessory/ears/rabbit,
		/datum/sprite_accessory/ears/bunny,
		/datum/sprite_accessory/ears/bunny_perky,
		/datum/sprite_accessory/ears/bunny_long,
		/datum/sprite_accessory/ears/big/rabbit_large,
		/datum/sprite_accessory/ears/cat_big,
		/datum/sprite_accessory/ears/cat_normal,
		/datum/sprite_accessory/ears/cow,
		/datum/sprite_accessory/ears/curled,
		/datum/sprite_accessory/ears/deer,
		/datum/sprite_accessory/ears/eevee,
		/datum/sprite_accessory/ears/elf,
		/datum/sprite_accessory/ears/elfw,
		/datum/sprite_accessory/ears/elephant,
		/datum/sprite_accessory/ears/fennec,
		/datum/sprite_accessory/ears/fish,
		/datum/sprite_accessory/ears/fox,
		/datum/sprite_accessory/ears/vulp,
		/datum/sprite_accessory/ears/husky,
		/datum/sprite_accessory/ears/jellyfish,
		/datum/sprite_accessory/ears/kangaroo,
		/datum/sprite_accessory/ears/lab,
		/datum/sprite_accessory/ears/murid,
		/datum/sprite_accessory/ears/otie,
		/datum/sprite_accessory/ears/pede,
		/datum/sprite_accessory/ears/sergal,
		/datum/sprite_accessory/ears/shark,
		/datum/sprite_accessory/ears/skunk,
		/datum/sprite_accessory/ears/squirrel,
		/datum/sprite_accessory/ears/wolf,
		/datum/sprite_accessory/ears/perky,
		/datum/sprite_accessory/ears/miqote,
		/datum/sprite_accessory/ears/lunasune,
		/datum/sprite_accessory/ears/sabresune,
		/datum/sprite_accessory/ears/possum,
		/datum/sprite_accessory/ears/raccoon,
		/datum/sprite_accessory/ears/mouse,
		/datum/sprite_accessory/ears/big/acrador_long,
		/datum/sprite_accessory/ears/big/acrador_short,
		/datum/sprite_accessory/ears/big/sandfox_large,
		/datum/sprite_accessory/ears/lynx,
		/datum/sprite_accessory/ears/zorzor
		)

// ---- Anthro
/datum/customizer/organ/ears/anthro
	customizer_choices = list(/datum/customizer_choice/organ/ears/anthro)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/ears/anthro
	name = "Wild-Kin Ears"
	organ_type = /obj/item/organ/ears/anthro
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/ears/cat,
		/datum/sprite_accessory/ears/axolotl,
		/datum/sprite_accessory/ears/bat,
		/datum/sprite_accessory/ears/bear,
		/datum/sprite_accessory/ears/bigwolf,
		/datum/sprite_accessory/ears/bigwolf_inner,
		/datum/sprite_accessory/ears/rabbit,
		/datum/sprite_accessory/ears/bunny,
		/datum/sprite_accessory/ears/big/rabbit_large,
		/datum/sprite_accessory/ears/bunny_perky,
		/datum/sprite_accessory/ears/bunny_long,
		/datum/sprite_accessory/ears/cat_big,
		/datum/sprite_accessory/ears/cat_normal,
		/datum/sprite_accessory/ears/cow,
		/datum/sprite_accessory/ears/curled,
		/datum/sprite_accessory/ears/deer,
		/datum/sprite_accessory/ears/eevee,
		/datum/sprite_accessory/ears/elf,
		/datum/sprite_accessory/ears/elfw,
		/datum/sprite_accessory/ears/elephant,
		/datum/sprite_accessory/ears/fennec,
		/datum/sprite_accessory/ears/fish,
		/datum/sprite_accessory/ears/fox,
		/datum/sprite_accessory/ears/vulp,
		/datum/sprite_accessory/ears/husky,
		/datum/sprite_accessory/ears/jellyfish,
		/datum/sprite_accessory/ears/kangaroo,
		/datum/sprite_accessory/ears/lab,
		/datum/sprite_accessory/ears/murid,
		/datum/sprite_accessory/ears/otie,
		/datum/sprite_accessory/ears/pede,
		/datum/sprite_accessory/ears/sergal,
		/datum/sprite_accessory/ears/shark,
		/datum/sprite_accessory/ears/skunk,
		/datum/sprite_accessory/ears/squirrel,
		/datum/sprite_accessory/ears/wolf,
		/datum/sprite_accessory/ears/perky,
		/datum/sprite_accessory/ears/antenna_simple1,
		/datum/sprite_accessory/ears/antenna_simple2,
		/datum/sprite_accessory/ears/antenna_simple3,
		/datum/sprite_accessory/ears/antenna_fuzzball1,
		/datum/sprite_accessory/ears/antenna_fuzzball2,
		/datum/sprite_accessory/ears/cobrahood,
		/datum/sprite_accessory/ears/cobrahoodears,
		/datum/sprite_accessory/ears/miqote,
		/datum/sprite_accessory/ears/lunasune,
		/datum/sprite_accessory/ears/sabresune,
		/datum/sprite_accessory/ears/possum,
		/datum/sprite_accessory/ears/raccoon,
		/datum/sprite_accessory/ears/mouse,
		/datum/sprite_accessory/ears/big/acrador_long,
		/datum/sprite_accessory/ears/big/acrador_short,
		/datum/sprite_accessory/ears/big/sandfox_large,
		/datum/sprite_accessory/ears/lynx,
		/datum/sprite_accessory/ears/zorzor
		)

// ---- Lizard
/datum/customizer/organ/ears/lizard
	name = "Hood"
	customizer_choices = list(/datum/customizer_choice/organ/ears/lizard)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/ears/lizard
	name = "Zardman Hood"
	organ_type = /obj/item/organ/ears/anthro
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/ears/cobrahood,
		/datum/sprite_accessory/ears/cobrahoodears,
		)

// ---- Tiefling
/datum/customizer/organ/ears/tiefling
	customizer_choices = list(/datum/customizer_choice/organ/ears/tiefling)
	allows_disabling = FALSE

/datum/customizer_choice/organ/ears/tiefling
	name = "Tiefling Ears"
	organ_type = /obj/item/organ/ears
	sprite_accessories = list(
		/datum/sprite_accessory/ears/elf,
		/datum/sprite_accessory/ears/elfw,
		/datum/sprite_accessory/ears/elf_short
		)

// ---- Dullahan
/datum/customizer/organ/ears/dullahan
	customizer_choices = list(/datum/customizer_choice/organ/ears/dullahan)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/ears/dullahan
	name = "Revenant Ears"
	organ_type = /obj/item/organ/ears
	sprite_accessories = list(
		/datum/sprite_accessory/ears/cat,
		/datum/sprite_accessory/ears/axolotl,
		/datum/sprite_accessory/ears/bat,
		/datum/sprite_accessory/ears/bear,
		/datum/sprite_accessory/ears/bigwolf,
		/datum/sprite_accessory/ears/bigwolf_inner,
		/datum/sprite_accessory/ears/rabbit,
		/datum/sprite_accessory/ears/bunny,
		/datum/sprite_accessory/ears/bunny_perky,
		/datum/sprite_accessory/ears/big/rabbit_large,
		/datum/sprite_accessory/ears/cat_big,
		/datum/sprite_accessory/ears/cat_normal,
		/datum/sprite_accessory/ears/cow,
		/datum/sprite_accessory/ears/curled,
		/datum/sprite_accessory/ears/deer,
		/datum/sprite_accessory/ears/eevee,
		/datum/sprite_accessory/ears/elf,
		/datum/sprite_accessory/ears/elfw,
		/datum/sprite_accessory/ears/elephant,
		/datum/sprite_accessory/ears/fennec,
		/datum/sprite_accessory/ears/fish,
		/datum/sprite_accessory/ears/fox,
		/datum/sprite_accessory/ears/vulp,
		/datum/sprite_accessory/ears/husky,
		/datum/sprite_accessory/ears/jellyfish,
		/datum/sprite_accessory/ears/kangaroo,
		/datum/sprite_accessory/ears/lab,
		/datum/sprite_accessory/ears/murid,
		/datum/sprite_accessory/ears/otie,
		/datum/sprite_accessory/ears/pede,
		/datum/sprite_accessory/ears/sergal,
		/datum/sprite_accessory/ears/shark,
		/datum/sprite_accessory/ears/skunk,
		/datum/sprite_accessory/ears/squirrel,
		/datum/sprite_accessory/ears/wolf,
		/datum/sprite_accessory/ears/perky,
		/datum/sprite_accessory/ears/antenna_simple1,
		/datum/sprite_accessory/ears/antenna_simple2,
		/datum/sprite_accessory/ears/antenna_simple3,
		/datum/sprite_accessory/ears/antenna_fuzzball1,
		/datum/sprite_accessory/ears/antenna_fuzzball2,
		/datum/sprite_accessory/ears/miqote,
		/datum/sprite_accessory/ears/lunasune,
		/datum/sprite_accessory/ears/sabresune,
		/datum/sprite_accessory/ears/possum,
		/datum/sprite_accessory/ears/raccoon,
		/datum/sprite_accessory/ears/mouse,
		/datum/sprite_accessory/ears/big/acrador_long,
		/datum/sprite_accessory/ears/big/acrador_short,
		/datum/sprite_accessory/ears/big/sandfox_large,
		/datum/sprite_accessory/ears/lynx,
		)
