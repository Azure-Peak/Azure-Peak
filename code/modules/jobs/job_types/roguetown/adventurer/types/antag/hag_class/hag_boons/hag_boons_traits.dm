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
	desc = "Allows one to conduct the rituals of their patron."
	points = 30

/datum/hag_boon/trait/webwalk
	name = "Trait - Webwalk"
	trait_to_apply = TRAIT_WEBWALK
	desc = "Webs will not hinder the bearer."
	points = 10

/datum/hag_boon/trait/nightowl
	name = "Trait - Nightowl"
	trait_to_apply = TRAIT_NIGHT_OWL
	desc = "The bearer will be in a better mood at nite."
	points = 5

/datum/hag_boon/trait/beautiful
	name = "Trait - Beautiful"
	trait_to_apply = TRAIT_BEAUTIFUL
	desc = "Grants unearthly beauty."
	points = 5

/datum/hag_boon/trait/beautiful_uncanny
	name = "Trait - Angelic beauty"
	trait_to_apply = TRAIT_BEAUTIFUL_UNCANNY
	desc = "Causes the bearer to randomly appear either beautiful or repulsive."
	points = 25

/datum/hag_boon/trait/leaper
	name = "Trait - Leaper"
	trait_to_apply = TRAIT_LEAPER
	desc = "Allows one to jump exactly where they desire, even with a running start."
	points = 5

/datum/hag_boon/trait/ignoreslowdown
	name = "Trait - Unslowable"
	trait_to_apply = TRAIT_IGNORESLOWDOWN
	desc = "The bearer cannot be slowed down."
	points = 50

/datum/hag_boon/trait/battleready
	name = "Trait - Battle Ready"
	trait_to_apply = TRAIT_BREADY
	desc = "Prevents defensive stances from fatiguing the bearer; they will also passively regain energy over time."
	points = 30

/datum/hag_boon/trait/armor_medium
	name = "Trait - Medium Armor Training"
	trait_to_apply = TRAIT_MEDIUMARMOR
	desc = "Allows one to effectively wear medium armor."
	points = 30

/datum/hag_boon/trait/armor_heavy
	name = "Trait - Heavy Armor Training"
	trait_to_apply = TRAIT_HEAVYARMOR
	desc = "Allows one to effectively wear heavy armor."
	points = 60

/datum/hag_boon/trait/dodge_expert
	name = "Trait - Dodge Expert"
	trait_to_apply = TRAIT_DODGEEXPERT
	desc = "Enhances the bearer's abiliy to dodge, so long as they are not wearing medium or heavy armor."
	points = 30

/datum/hag_boon/trait/bleed_resistance
	name = "Trait - Bleeding Resistance"
	trait_to_apply = TRAIT_BLOOD_RESISTANCE
	desc = "Slows the rate at which one bleeds."
	points = 50

/datum/hag_boon/trait/grab_immunity
	name = "Trait - Too slippery to grab"
	trait_to_apply = TRAIT_GRABIMMUNE
	desc = "Prevents one from being grabbed."
	points = 60

/datum/hag_boon/trait/crackhead
	name = "Trait - Overdose Immunity"
	trait_to_apply = TRAIT_CRACKHEAD
	desc = "Overdoses will not harm the bearer."
	points = 60

/datum/hag_boon/trait/civil_barbarian
	name = "Trait - Unarmed Amplifier"
	trait_to_apply = TRAIT_CIVILIZEDBARBARIAN
	desc = "The bearer will parry far more effectively with bracers, knuckles, and bandages, strike harder with unarmed attacks, and be able to reach any limb with their fists and feet."
	points = 30

/datum/hag_boon/trait/water_breathing
	name = "Trait - Waterbreathing"
	trait_to_apply = TRAIT_WATERBREATHING
	desc = "Allows one to breathe in water."
	points = 5

/datum/hag_boon/trait/sharper_blades
	name = "Trait - Sharpness Maintenance"
	trait_to_apply = TRAIT_SHARPER_BLADES
	desc = "Slows the rate at which one's blades dull."
	points = 20

/datum/hag_boon/trait/guidance
	name = "Trait - Guidance"
	trait_to_apply = TRAIT_GUIDANCE
	desc = "Enhances the bearer's combat abilities, functioning as an extra level in their skill with whatever weapon they wield."
	points = 60

/datum/hag_boon/trait/good_trainer
	name = "Trait - Good Trainer"
	trait_to_apply = TRAIT_GOODTRAINER
	desc = "Grants an affinity for training others, allowing training up to equal level in weaponry skills."
	points = 75

// /datum/hag_boon/trait/counter_counterspell
// 	name = "Trait - Counter Counterspell"
// 	trait_to_apply = TRAIT_COUNTERCOUNTERSPELL
// 	desc = "Prevents Counterspells from affecting the bearer."
// 	points = 40

/datum/hag_boon/trait/keen_ears
	name = "Trait - Keen Ears"
	trait_to_apply = TRAIT_KEENEARS
	desc = "Enhances the bearer's hearing, allowing them to recognize voices from afar and hear whispers from further away."
	points = 10

/datum/hag_boon/trait/hard_dismember
	name = "Trait - Difficult To Dismember"
	trait_to_apply = TRAIT_HARDDISMEMBER
	desc = "Causes the bearer's limbs to be more difficult to remove."
	points = 30

/datum/hag_boon/trait/no_pain
	name = "Trait - Numb To Pain"
	trait_to_apply = TRAIT_NOPAIN
	desc = "Prevents the bearer from feeling any pain."
	points = 85

/datum/hag_boon/trait/dark_vision
	name = "Trait - Darksight"
	trait_to_apply = TRAIT_DARKVISION
	desc = "Allows one to see in the dark."
	points = 10

/datum/hag_boon/trait/azure_native
	name = "Trait - Hard To Ambush"
	trait_to_apply = TRAIT_AZURENATIVE
	desc = "Prevents the bearer from triggering ambushes unless sprinting."
	points = 50

/datum/hag_boon/trait/matthios_eyes
	name = "Trait - Eye for treasure"
	trait_to_apply = TRAIT_MATTHIOS_EYES
	desc = "Allows one to see the most valuable item anyone they look at has; they can also see if someone is hoarding mammons."
	points = 5

/datum/hag_boon/trait/wood_walker
	name = "Trait - Leaf Walk"
	trait_to_apply = TRAIT_WOODWALKER
	desc = "Allows the bearer to climb trees faster, train Climbing more easily, step safely on twigs and thorns, tread lightly on leaves, and find more of the forest's bounty when searching bushes."
	points = 50

// Disabled for now, they have a blessing for stamina.
// /datum/hag_boon/trait/infinite_energy
// 	name = "Trait - No Fatigue"
// 	trait_to_apply = TRAIT_INFINITE_ENERGY
// 	points = 100

/datum/hag_boon/trait/unbound_strength
	name = "Trait - Unbound Strength"
	trait_to_apply = TRAIT_STRENGTH_UNCAPPED
	desc = "Removes the limit on the bearer's strength, allowing them to benefit from higher levels than normally possible."
	points = 40

/datum/hag_boon/trait/jack_of_all_trades
	name = "Trait - Quick Skill Learner"
	trait_to_apply = TRAIT_JACKOFALLTRADES
	desc = "Enhances the bearer's diligence, allowing them to raise skills at nite for half the normal cost."
	points = 25

// Different wording to make it clear it's about the skillcap traits...
/datum/hag_boon/trait/expert_medicine
	name = "Boon of the Physician"
	trait_to_apply = TRAIT_MEDICINE_EXPERT
	desc = "Grants an affinity for the medical arts, allowing one's skills to progress to Legendary levels."
	points = 10

/datum/hag_boon/trait/expert_alchemy
	name = "Boon of the Alchemist"
	trait_to_apply = TRAIT_ALCHEMY_EXPERT
	desc = "Imparts knowledge of the alchemical arts, allowing one's skills to progress to Legendary levels."
	points = 10

/datum/hag_boon/trait/expert_smithing
	name = "Boon of the Smith"
	trait_to_apply = TRAIT_SMITHING_EXPERT
	desc = "Grants an affinity for the forge, allowing Smithing, Smelting, Engineering, Mining, Masonry and Pottery to progress to Legendary levels."
	points = 10

/datum/hag_boon/trait/expert_sewing
	name = "Boon of the Tailor"
	trait_to_apply = TRAIT_SEWING_EXPERT
	desc = "Grants an affinity for the arts of tailoring, allowing Sewing, Skincrafting and Butchering to progress to Legendary levels."
	points = 10

/datum/hag_boon/trait/expert_survival
	name = "Boon of the Survivor"
	trait_to_apply = TRAIT_SURVIVAL_EXPERT
	desc = "Imparts the primal urge to survive, allowing Cooking, Fishing, Butchering and Skincrafting to progress to Legendary levels, and Sewing to progress to Journeyman levels."
	points = 10

/datum/hag_boon/trait/expert_homestead
	name = "Boon of the Homesteader"
	trait_to_apply = TRAIT_HOMESTEAD_EXPERT
	desc = "Grants an affinity for the arts of homesteading, allowing Farming, Mining, Cooking, Fishing, Butchering, Lumberjacking, Masonry and Pottery to progress to Legendary levels, and Sewing and Skincrafting to progress to Journeyman levels."
	points = 10

/datum/hag_boon/trait/self_sustenance
	name = "Boon of Self-Sustenance"
	trait_to_apply = TRAIT_SELF_SUSTENANCE
	desc = "Extends the limits of the mind, allowing one to reach Journeyman levels in all crafting and labor skills."
	points = 10

/datum/hag_boon/trait/combat_aware
	name = "Trait - Combat Awareness"
	trait_to_apply = TRAIT_COMBAT_AWARE
	desc = "Expands one's awareness, granting more information while in combat."
	points = 15

/datum/hag_boon/trait/wyrd_labourer
	name = "Wyrd Labourer"
	trait_to_apply = TRAIT_WYRD_LABOURER
	desc = "Grants the strength of nature, allowing one to slice through rocks and trees with ease."
	points = 20

/datum/hag_boon/trait/mirror_magic
	name = "Wyrd Mirror Magic"
	trait_to_apply = TRAIT_EDIT_DESCRIPTORS
	desc = "Allows one to change their appearance at a mirror."
	points = 40

/datum/hag_boon/trait/bogwalker
	name = "Bog's Blessing"
	desc = "A blessing of the bog, those marked by it will fear no ambush, leech, or kneestinger within your domain."
	trait_to_apply = TRAIT_BOGWALKER
	points = 20
