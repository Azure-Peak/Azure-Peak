/datum/hag_boon/trait
	name = "Granted Trait"
	var/trait_to_apply
	points = 5
	transmutable = TRUE
	hag_trait = TRUE

/datum/hag_boon/trait/apply_boon_effect(mob/living/L)
	if(trait_to_apply)
		ADD_TRAIT(L, trait_to_apply, TRAIT_HAG_BOON)
		to_chat(L, span_notice("You feel like you've gained a new trait."))
	. = ..()

/datum/hag_boon/trait/remove_boon_effect(mob/living/L)
	if(trait_to_apply)
		REMOVE_TRAIT(L, trait_to_apply, TRAIT_HAG_BOON)
	. = ..()

/datum/hag_boon/trait/ritualist
	name = "Trait - Ritualist"
	trait_to_apply = TRAIT_RITUALIST
	points = 30

/datum/hag_boon/trait/webwalk
	name = "Trait - Webwalk"
	trait_to_apply = TRAIT_WEBWALK
	points = 10

/datum/hag_boon/trait/nightowl
	name = "Trait - Nightowl"
	trait_to_apply = TRAIT_NIGHT_OWL
	points = 5

/datum/hag_boon/trait/beautiful
	name = "Trait - Beautiful"
	trait_to_apply = TRAIT_BEAUTIFUL
	points = 5

/datum/hag_boon/trait/beautiful_uncanny
	name = "Trait - Angelic beauty"
	trait_to_apply = TRAIT_BEAUTIFUL_UNCANNY
	points = 25

/datum/hag_boon/trait/leaper
	name = "Trait - Leaper"
	trait_to_apply = TRAIT_LEAPER
	points = 5

/datum/hag_boon/trait/ignoreslowdown
	name = "Trait - Unslowable"
	trait_to_apply = TRAIT_IGNORESLOWDOWN
	points = 50

/datum/hag_boon/trait/battleready
	name = "Trait - Battle Ready"
	trait_to_apply = TRAIT_BREADY
	points = 30

/datum/hag_boon/trait/armor_medium
	name = "Trait - Medium Armor Training"
	trait_to_apply = TRAIT_MEDIUMARMOR
	points = 30

/datum/hag_boon/trait/armor_heavy
	name = "Trait - Heavy Armor Training"
	trait_to_apply = TRAIT_HEAVYARMOR
	points = 60

/datum/hag_boon/trait/dodge_expert
	name = "Trait - Dodge Expert"
	trait_to_apply = TRAIT_DODGEEXPERT
	points = 30

/datum/hag_boon/trait/bleed_resistance
	name = "Trait - Bleeding Resistance"
	trait_to_apply = TRAIT_BLOOD_RESISTANCE
	points = 50

/datum/hag_boon/trait/grab_immunity
	name = "Trait - Too slippery to grab"
	trait_to_apply = TRAIT_GRABIMMUNE
	points = 60

/datum/hag_boon/trait/crackhead
	name = "Trait - Overdose Immunity"
	trait_to_apply = TRAIT_CRACKHEAD
	points = 60

/datum/hag_boon/trait/civil_barbarian
	name = "Trait - Unarmed Amplifier"
	trait_to_apply = TRAIT_CIVILIZEDBARBARIAN
	points = 30

/datum/hag_boon/trait/water_breathing
	name = "Trait - Waterbreathing"
	trait_to_apply = TRAIT_WATERBREATHING
	points = 5

/datum/hag_boon/trait/sharper_blades
	name = "Trait - Sharpness Maintenance"
	trait_to_apply = TRAIT_SHARPER_BLADES
	points = 20

/datum/hag_boon/trait/guidance
	name = "Trait - Guidance"
	trait_to_apply = TRAIT_GUIDANCE
	points = 60

/datum/hag_boon/trait/good_trainer
	name = "Trait - Good Trainer"
	trait_to_apply = TRAIT_GOODTRAINER
	points = 75

/datum/hag_boon/trait/counter_counterspell
	name = "Trait - Counter Counterspell"
	trait_to_apply = TRAIT_COUNTERCOUNTERSPELL
	points = 40

/datum/hag_boon/trait/keen_ears
	name = "Trait - Keen Ears"
	trait_to_apply = TRAIT_KEENEARS
	points = 10

/datum/hag_boon/trait/hard_dismember
	name = "Trait - Difficult To Dismember"
	trait_to_apply = TRAIT_HARDDISMEMBER
	points = 30

/datum/hag_boon/trait/no_pain
	name = "Trait - Numb To Pain"
	trait_to_apply = TRAIT_NOPAIN
	points = 85

/datum/hag_boon/trait/dark_vision
	name = "Trait - Darksight"
	trait_to_apply = TRAIT_DARKVISION
	points = 10

/datum/hag_boon/trait/azure_native
	name = "Trait - Hard To Ambush"
	trait_to_apply = TRAIT_AZURENATIVE
	points = 50

/datum/hag_boon/trait/matthios_eyes
	name = "Trait - Eye for treasure"
	trait_to_apply = TRAIT_MATTHIOS_EYES
	points = 5

/datum/hag_boon/trait/wood_walker
	name = "Trait - Leaf Walk"
	trait_to_apply = TRAIT_WOODWALKER
	points = 50

// Disabled for now, they have a blessing for stamina.
// /datum/hag_boon/trait/infinite_energy
// 	name = "Trait - No Fatigue"
// 	trait_to_apply = TRAIT_INFINITE_ENERGY
// 	points = 100

/datum/hag_boon/trait/unbound_strength
	name = "Trait - Unbound Strength"
	trait_to_apply = TRAIT_STRENGTH_UNCAPPED
	points = 40

/datum/hag_boon/trait/jack_of_all_trades
	name = "Trait - Quick Skill Learner"
	trait_to_apply = TRAIT_JACKOFALLTRADES
	points = 25

// Different wording to make it clear it's about the skillcap traits...
/datum/hag_boon/trait/expert_medicine
	name = "Boon of the Physician"
	trait_to_apply = TRAIT_MEDICINE_EXPERT
	points = 10

/datum/hag_boon/trait/expert_alchemy
	name = "Boon of the Alchemist"
	trait_to_apply = TRAIT_ALCHEMY_EXPERT
	points = 10

/datum/hag_boon/trait/expert_smithing
	name = "Boon of the Smith"
	trait_to_apply = TRAIT_SMITHING_EXPERT
	points = 10

/datum/hag_boon/trait/expert_sewing
	name = "Boon of the Tailor"
	trait_to_apply = TRAIT_SEWING_EXPERT
	points = 10

/datum/hag_boon/trait/expert_survival
	name = "Boon of the Survivor"
	trait_to_apply = TRAIT_SURVIVAL_EXPERT
	points = 10

/datum/hag_boon/trait/expert_homestead
	name = "Boon of the Homesteader"
	trait_to_apply = TRAIT_HOMESTEAD_EXPERT
	points = 10

/datum/hag_boon/trait/self_sustenance
	name = "Boon of Self-Sustenance"
	trait_to_apply = TRAIT_SELF_SUSTENANCE
	points = 10

/datum/hag_boon/trait/combat_aware
	name = "Trait - Combat Awareness"
	trait_to_apply = TRAIT_COMBAT_AWARE
	points = 15

/datum/hag_boon/trait/wyrd_labourer
	name = "Wyrd Labourer"
	trait_to_apply = TRAIT_WYRD_LABOURER
	points = 20

/datum/hag_boon/trait/mirror_magic
	name = "Wyrd Mirror Magic"
	trait_to_apply = TRAIT_EDIT_DESCRIPTORS
	points = 40
