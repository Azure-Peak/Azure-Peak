#define TRAIT_SOURCE_POTION "traitpotion"
#define REPAIR_ELIXIR_STRENGTH 3 // 3 pts per dram means a vial will repair about a third of an arming sword over time; a full bottle will repair about half of a decent mage staff

//Potions
/datum/reagent/medicine/healthpot
	name = "Health Potion"
	description = "Gradually regenerates all types of damage."
	reagent_state = LIQUID
	color = "#ff0000"
	taste_description = "lifeblood"
	scent_description = "metal"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	conflicting_reagent_types = list(/datum/reagent/medicine/stronghealth, /datum/reagent/medicine/restoration)

/datum/reagent/medicine/healthpot/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_NOREGEN) || HAS_TRAIT(M, TRAIT_BLACKBLOOD))
		return ..()
	if(volume >= 60)
		M.reagents.remove_reagent(/datum/reagent/medicine/healthpot, 2) //No overhealing.
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(3) //at a metabolism of .5 U a tick this translates to 120WHP healing with 20 U Most wounds are unsewn 15-100. This is powerful on single wounds but rapidly weakens at multi wounds.
	if(volume > 0.99)
		M.adjustBruteLoss(-1.75  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-1.75  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-1.25, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-1.75  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOrganLoss(ORGAN_SLOT_EYES, -1 * REAGENTS_EFFECT_MULTIPLIER)
	..()

/datum/reagent/medicine/healthpot/zarum/blood
	name = "Blackened Sludge"
	description = "A fairly disgusting, bubbling mess of an unknown origin that seems to be constantly fermenting onto itself, exhuding a foul smell."
	color = "#241a1a"
	taste_description = "sins of Otava"
	scent_description = "dark darker yet darker"

/datum/reagent/medicine/healthpot/zarum/bog // no changes, it's just more palatable :>
	name = "Honeyed Zarum"
	description = "A fermented sauce of fish innards, vinegar and honey, which gradually regenerates all types of damage while remaining surprisingly pleasant to the tastebuds."
	color = "#dd9700"
	taste_description = "sweet-sour fish-glazed honey"
	scent_description = "sweet fermented pungence"

/datum/reagent/medicine/healthpot/zarum
	name = "Zarum"
	description = "A fermented sauce of fish innards and vinegar, which gradually regenerates all types of damage."
	reagent_state = LIQUID
	color = "#891305"
	var/nutriment_factor = 16
	metabolization_rate = 0.4
	taste_description = "lip-puckeringly rich fishiness"
	scent_description = "fermented pungence"
	taste_mult = 8
	var/hydration = 4

/datum/reagent/medicine/healthpot/zarum/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_NOREGEN))
		return ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			H.adjust_hydration(hydration)
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+10, BLOOD_VOLUME_NORMAL)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(4) //Better than traditional lifeblood at sealing open wounds. Slightly weaker healing potency, in turn.
	if(volume > 0.99)
		M.adjustBruteLoss(-1.5  * REAGENTS_EFFECT_MULTIPLIER, 0) //Minor reduction of ~15%-ish potency.
		M.adjustFireLoss(-1.5  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-1.25, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-1.5  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOrganLoss(ORGAN_SLOT_EYES, -1 * REAGENTS_EFFECT_MULTIPLIER)
	..()

/datum/reagent/medicine/stronghealth
	name = "Strong Health Potion"
	description = "Quickly regenerates all types of damage."
	color = "#820000be"
	taste_description = "rich lifeblood"
	scent_description = "metal"
	metabolization_rate = REAGENTS_METABOLISM * 2
	conflicting_reagent_types = list(/datum/reagent/medicine/healthpot, /datum/reagent/medicine/restoration)

/datum/reagent/medicine/stronghealth/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_NOREGEN) || HAS_TRAIT(M, TRAIT_BLACKBLOOD))
		return ..()
	if(volume >= 60)
		M.reagents.remove_reagent(/datum/reagent/medicine/stronghealth, 2) //No overhealing.
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(4)
	if(volume > 0.99)
		M.adjustBruteLoss(-5  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-5  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-5, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-5  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOrganLoss(ORGAN_SLOT_EYES, -2.5 * REAGENTS_EFFECT_MULTIPLIER)
	..()
	. = 1

/datum/reagent/medicine/manapot
	name = "Mana Potion"
	description = "Gradually regenerates energy."
	reagent_state = LIQUID
	color = "#000042"
	taste_description = "sweet mana"
	scent_description = "berries"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	conflicting_reagent_types = list(/datum/reagent/medicine/strongmana, /datum/reagent/medicine/restoration)

/datum/reagent/medicine/manapot/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(30)
	..()

/datum/reagent/medicine/strongmana
	name = "Strong Mana Potion"
	description = "Rapidly regenerates energy."
	color = "#0000ff"
	taste_description = "raw power"
	scent_description = "berries"
	metabolization_rate = REAGENTS_METABOLISM * 3
	conflicting_reagent_types = list(/datum/reagent/medicine/manapot, /datum/reagent/medicine/restoration)

/datum/reagent/medicine/strongmana/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(120)
	..()

/datum/reagent/medicine/restoration
	name = "Restoration Potion"
	description = "Simultaneously regenerates health and energy. Inherits a higher potency than common lifeblood and manna, but remains inferior to stronger brews."
	color = "#ff8da1"
	taste_description = "reinvigorative creaminess"
	scent_description = "strawberries in liqour"
	metabolization_rate = REAGENTS_METABOLISM * 2
	// Restoration is a hybrid of the health and mana families, so it conflicts with both.
	conflicting_reagent_types = list(/datum/reagent/medicine/healthpot, /datum/reagent/medicine/stronghealth, /datum/reagent/medicine/manapot, /datum/reagent/medicine/strongmana)

/datum/reagent/medicine/restoration/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_NOREGEN) || HAS_TRAIT(M, TRAIT_BLACKBLOOD))
		return ..()
	if(volume >= 60)
		M.reagents.remove_reagent(/datum/reagent/medicine/restoration, 2) //No overhealing.
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(3)
	if(volume > 0.99)
		M.adjustBruteLoss(-3  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-3  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-3, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-3  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOrganLoss(ORGAN_SLOT_EYES, -1.75 * REAGENTS_EFFECT_MULTIPLIER)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(60)
	..()

// Stamina potion no longer grant green bar directly which led to it being far too powerful when abused
/datum/reagent/medicine/stampot
	name = "Fortitude Potion"
	description = "Hardens the humors against fatigue, granting Fortitude for a short while."
	reagent_state = LIQUID
	color = "#129c00"
	taste_description = "sweet tea"
	scent_description = "grass"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	conflicting_reagent_types = list(/datum/reagent/medicine/strongstam)

/datum/reagent/medicine/stampot/on_mob_life(mob/living/carbon/M)
	if(volume > 0)
		M.apply_status_effect(/datum/status_effect/buff/alch/statbuff/fortitude, volume * 20 SECONDS)
		holder.remove_reagent(type, volume)
	return TRUE

/datum/reagent/medicine/strongstam
	name = "Strong Fortitude Potion"
	description = "Rapidly hardens the humors against fatigue, granting Fortitude for a short while."
	color = "#13df00"
	taste_description = "sparkly static"
	scent_description = "grass"
	metabolization_rate = REAGENTS_METABOLISM
	conflicting_reagent_types = list(/datum/reagent/medicine/stampot)

/datum/reagent/medicine/strongstam/on_mob_life(mob/living/carbon/M)
	if(volume > 0)
		M.apply_status_effect(/datum/status_effect/buff/alch/statbuff/fortitude, volume * 40 SECONDS)
		holder.remove_reagent(type, volume)
	return TRUE

/** Design Note: Antidotes are meant to last as long as the poison, and purge them much quicker
 Having a 1 to 1 antidote to poison where you have to tailor defense to an increasing amount of attack
 is a bad idea, since that just means no one will use antidotes and the weapon win the race vs defense.
 This means pre ingesting antidote when expecting poison is a viable strategy.
 Previously, antidote did not have a dylovene-like effect and just purged toxin damage while poison will outlast them.
**/
/datum/reagent/medicine/antidote
	name = "Antidote"
	description = "Gradually purges any imbalanced humors and poisons within the bloodstream."
	reagent_state = LIQUID
	color = "#00ff00"
	taste_description = "sickly sweet"
	scent_description = "medicine"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	conflicting_reagent_types = list(/datum/reagent/medicine/strong_antidote)

/datum/reagent/medicine/antidote/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.adjustToxLoss(-4, 0)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R.harmful)
			holder.remove_reagent(R.type, 1)

	..()
	. = 1

// About 3 time as potent as antidote
/datum/reagent/medicine/strong_antidote
	name = "Strong Antidote"
	description = "Rapidly purges any imbalanced humors and poisons within the bloodstream."
	reagent_state = LIQUID
	color = "#004200"
	taste_description = "dirt"
	scent_description = "medicine"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	conflicting_reagent_types = list(/datum/reagent/medicine/antidote)

/datum/reagent/medicine/strong_antidote/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.adjustToxLoss(-12, 0)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R.harmful)
			holder.remove_reagent(R, 3)
	..()
	. = 1

/datum/reagent/buff
	description = ""
	reagent_state = LIQUID
	metabolization_rate = REAGENTS_METABOLISM * 0.1
	overdose_threshold = 33
	// All stat buffs conflict with each other: only one buff potion's effect can be active at a time.
	// (Self is excluded by the purge logic, so a buff never purges itself despite matching its own parent type.)
	conflicting_reagent_types = list(/datum/reagent/buff)
	var/buff_type
	var/duration_per_unit = 1 MINUTES

/datum/reagent/buff/on_mob_life(mob/living/carbon/M)
	if(!buff_type)
		return ..()
	if(volume > 0)
		M.apply_status_effect(buff_type, volume * duration_per_unit)
		holder.remove_reagent(type, volume)
	return TRUE

/datum/reagent/buff/overdose_process(mob/living/carbon/M)
	. = ..()
	M.Jitter(2)
	if(!HAS_TRAIT(M, TRAIT_CRACKHEAD)) // Baothan get to stack more of one potion in their body, but not multiple
		M.adjustToxLoss(3)

/datum/reagent/buff/strength
	name = STATKEY_STR
	color = "#ff9000"
	taste_description = "old meat"
	scent_description = "meat"
	buff_type = /datum/status_effect/buff/alch/statbuff/strengthpot

/datum/reagent/buff/perception
	name = STATKEY_PER
	color = "#ffff00"
	taste_description = "cat piss"
	scent_description = "urine"
	buff_type = /datum/status_effect/buff/alch/statbuff/perceptionpot

/datum/reagent/buff/intelligence
	name = STATKEY_INT
	color = "#438127"
	taste_description = "bog water"
	scent_description = "moss"
	buff_type = /datum/status_effect/buff/alch/statbuff/intelligencepot

/datum/reagent/buff/constitution
	name = STATKEY_CON
	color = "#130604"
	taste_description = "bile"
	scent_description = "vomit"
	buff_type = /datum/status_effect/buff/alch/statbuff/constitutionpot

/datum/reagent/buff/endurance
	name = STATKEY_WIL
	color = "#ffff00"
	taste_description = "oversweetened milk"
	buff_type = /datum/status_effect/buff/alch/statbuff/endurancepot

/datum/reagent/buff/speed
	name = STATKEY_SPD
	color = "#ffff00"
	taste_description = "raw egg yolk"
	scent_description = "sweat"
	buff_type = /datum/status_effect/buff/alch/statbuff/speedpot

/datum/reagent/buff/fortune
	name = STATKEY_LCK
	color = "#ffff00"
	taste_description = "sour lemons"
	scent_description = "citrus"
	buff_type = /datum/status_effect/buff/alch/statbuff/fortunepot

/* Ruined Potion
	When two conflicting potions end up in the same container (or the same body),
	they neutralize each other into this useless sludge.
*/
/datum/reagent/ruined_potion
	name = "Odd water"
	description = "A foul mess of conflicting alchemical essences that tried to push nature too far. Utterly useless."
	reagent_state = LIQUID
	color = "#6b5d4f" // muddy brownish-green
	taste_description = "bitter failure"
	scent_description = "rancid alchemical waste"
	metabolization_rate = REAGENTS_METABOLISM
	overdose_threshold = 0
	can_synth = FALSE

/datum/reagent/ruined_potion/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_NASTY_EATER))
		return
	if(volume > 0.99)
		M.add_nausea(2) // Drinking ruined potions is unpleasant but not dangerous.
	return ..()

//Poisons
/* Tested this quite a bit. Heres the deal. Metabolism REAGENTS_SLOW_METABOLISM is 0.1 and needs to be that so poison isnt too fast working but
still is dangerous. Toxloss of 3 at metabolism 0.1 puts you in dying early stage then stops for reference of these values.
A dose of ingested potion is defined as 5u, projectile deliver at most 2u, you already do damage with projectile, a bolt can only feasible hold a tiny amount of poison, so much easier to deliver than ingested and so on.
If you want to expand on poisons theres tons of fun effects TG chemistry has that could be added, randomzied damage values for more unpredictable poison, add trait based resists instead of the clunky race check etc.*/

/datum/reagent/berrypoison	// Weaker poison, balanced to make you wish for death and incapacitate but not kill
	name = "Berry Poison"
	description = ""
	reagent_state = LIQUID
	color = "#47b2e0"
	taste_description = "bitterness"
	scent_description = "berries"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	harmful = TRUE

/datum/reagent/berrypoison/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3) // so one berry or one dose (one clunk of extracted poison, 5u) will make you really sick and a hair away from crit.
			M.adjustToxLoss(2)
	return ..()


/datum/reagent/strongpoison		// Strong poison, meant to be somewhat difficult to produce using alchemy or spawned with select antags. Designed to kill in one full dose (5u) better drink antidote fast
	name = "Strong Poison"
	description = ""
	reagent_state = LIQUID
	color = "#1a1616"
	taste_description = "burning"
	scent_description = "something spicy"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	harmful = TRUE

/datum/reagent/strongpoison/on_mob_life(mob/living/carbon/M)

	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(2.3)  // will put you just above dying crit treshold
		else
			M.add_nausea(6) //So a poison bolt (2u) will eventually cause puking at least once
			M.adjustToxLoss(4.5) // just enough so 5u will kill you dead with no help
	return ..()

/datum/reagent/bloodacid // Quietus Poison for Vampires
	name = "Vitae Acid"
	description = ""
	reagent_state = LIQUID
	color = "#ff3300"
	taste_description = "burning"
	scent_description = "something spicy"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	harmful = TRUE

/datum/reagent/bloodacid/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(5.5)
			M.adjustToxLoss(7.5)
			to_chat(M, span_userdanger("MY HEART! I'VE BEEN POISONED."))
			M.playsound_local('sound/magic/heartbeat.ogg', 50)
		else
			M.add_nausea(6.5)
			M.adjustToxLoss(8.5)
			to_chat(M, span_userdanger("MY HEART! I'VE BEEN POISONED."))
			M.playsound_local('sound/magic/heartbeat.ogg', 50)
	return ..()

/datum/reagent/organpoison
	name = "Organ Poison"
	description = ""
	reagent_state = LIQUID
	color = "#2c1818"
	taste_description = "sour meat"
	scent_description = "rancid meat"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	harmful = TRUE


/datum/reagent/organpoison/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.energy_add(10) //Slowly add energy back.
	if(!HAS_TRAIT(M, TRAIT_NASTY_EATER) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.add_nausea(9)
		M.adjustToxLoss(2)
	return ..()

/datum/reagent/sleep_powder
	name = "Sleep Poison"
	description = ""
	color = "#ddd3df" // rgb: 96, 165, 132
	metabolization_rate = 1
	taste_description = "numbing mintiness"

/datum/reagent/sleep_powder/on_mob_metabolize(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/debuff/knockout)
	..()

/datum/reagent/stampoison
	name = "Stamina Poison"
	description = ""
	reagent_state = LIQUID
	color = "#083b1c"
	taste_description = "breathlessness"
	scent_description = "dust"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM * 3
	harmful = TRUE


/datum/reagent/stampoison/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(-45) //Slowly leech energy
	return ..()

/datum/reagent/strongstampoison
	name = "Strong Stamina Poison"
	description = ""
	reagent_state = LIQUID
	color = "#041d0e"
	taste_description = "frozen air"
	scent_description = "mint"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM * 9
	harmful = TRUE


/datum/reagent/strongstampoison/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(-180) //Rapidly leech energy
	return ..()

/datum/reagent/toxin/killersice
	name = "Killer's Ice"
	description = "c8c9e9"
	reagent_state = LIQUID
	color = "#FFFFFF"
	taste_description = "cold needles"
	scent_description = "mint"
	metabolization_rate = 0.1
	toxpwr = 0
	harmful = TRUE

/datum/reagent/toxin/killersice/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(10, 0)
	return ..()

/datum/chemical_reaction/alch/vitae_essence
	name = "Vitae Decoction"
	id = /datum/reagent/medicine/vitae_essence
	results = list(/datum/reagent/medicine/vitae_essence = 1)
	required_reagents = list(/datum/reagent/vitae = 1, /datum/reagent/toxin/fyritiusnectar = 5)
	mix_message = "The cauldron glows for a moment."

/*----------\
|Ingredients|
\----------*/
/datum/reagent/undeadash
	name = "Spectral Powder"
	description = ""
	reagent_state = SOLID
	color = "#330066"
	taste_description = "tombstones"
	metabolization_rate = 0.1

/datum/reagent/toxin/fyritiusnectar
	name = "fyritius nectar"
	description = "oh no"
	reagent_state = LIQUID
	color = "#ffc400"
	metabolization_rate = 0.5
	harmful = TRUE

/datum/reagent/toxin/fyritiusnectar/on_mob_life(mob/living/carbon/M)
	if(volume > 0.49)
		M.add_nausea(9)
		M.adjustFireLoss(2, 0)
		M.adjust_fire_stacks(1)
		M.ignite_mob()
	return ..()
//I'm stapling our infection reagents on the bottom, because IDEK where else to put them.

/datum/reagent/infection
	name = "excess choleric humour"
	description = "Red-yellow pustulence - the carrier of disease, the enemy of all Pestrans."
	reagent_state = LIQUID
	color = "#dfe36f"
	metabolization_rate = 0.1
	var/damage_tick = 0.3
	var/lethal_fever = FALSE
	var/fever_multiplier = 1

/datum/reagent/infection/on_mob_life(mob/living/carbon/M)
	var/heat = (BODYTEMP_AUTORECOVERY_MINIMUM + clamp(volume, 3, 15)) * fever_multiplier
	M.adjustToxLoss(damage_tick, 0)
	if (lethal_fever)
		M.adjust_bodytemperature(heat, 0)
		if (prob(5))
			to_chat(M, span_warning("A wicked heat settles within me... I feel ill. Very ill."))
	else
		M.adjust_bodytemperature(heat, 0, BODYTEMP_HEAT_DAMAGE_LIMIT - 1)
		if (prob(5))
			to_chat(M, span_warning("I feel a horrible chill despite the sweat rolling from my brow..."))
	return ..()

/datum/reagent/infection/minor
	name = "disrupted choleric humor"
	description = "Symptomatic of disrupted humours."
	damage_tick = 0.1
	lethal_fever = FALSE

/datum/reagent/infection/major
	name = "excess melancholic humour"
	description = "Kingsfield's Bane. Excess melancholic has killed thousands, and even Pestra's greatest struggle against its insidious advance."
	damage_tick = 1
	lethal_fever = TRUE
	fever_multiplier = 3

/datum/reagent/infection/major/on_mob_life(mob/living/carbon/M)
	if (M.badluck(1))
		M.reagents.add_reagent(src, rand(1,3))
		to_chat(M, span_small("I feel even worse..."))
	return ..()


/datum/reagent/medicine/vitae_essence
	name = "Vitae Decoction"
	description = "Decoction of essence of lyfe, used to restore one's lux humours."
	color = "#67c7ff" // rgb: 96, 165, 132
	overdose_threshold = 10
	metabolization_rate = 0.1

/datum/reagent/medicine/vitae_essence/on_mob_life(mob/living/carbon/M)
	M.sate_addiction(/datum/charflaw/addiction/junkie)
	if(M.has_status_effect(/datum/status_effect/debuff/ritualdefiled))
		M.remove_status_effect(/datum/status_effect/debuff/ritualdefiled)
	return ..()

/datum/reagent/fire_resist
	name = "Fire Resistance"
	color = "#ff7300"
	taste_description = "burning coal"

/datum/reagent/fire_resist/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/alch/fire_resist)
	return ..()

/datum/reagent/fermented_crab
	name = "Fermented Crab"
	description = ""
	color = "#abaa7c"
	overdose_threshold = 15
	metabolization_rate = 0.2
	taste_description = "randcid, putrid crab"

/datum/reagent/fermented_crab/overdose_process(mob/living/M)
	M.adjustToxLoss(1, FALSE)
	if(iscarbon(M) && prob(1))
		var/mob/living/carbon/carbon_consumer = M
		carbon_consumer.vomit(1)
	return ..()

/datum/reagent/fermented_crab/on_mob_metabolize(mob/living/M)
	var/mob/living/carbon/carbon_consumer = M
	if(!istype(carbon_consumer))
		return ..()
	to_chat(M, span_userdanger("That fermented crab was truly rancid... You feel..."))
	// Default chance to vomit with WIL 12 - 40%
	// With WIL 10 - 48%; With WIL 14 - 32% and so on.
	if(prob(40 - ((M.STAWIL - 12) * 4)))
		to_chat(M, span_userdanger("You suddenly feel very sick... Mayhaps, eating the fermented crab wasn't the best idea..."))
		carbon_consumer.vomit(5, blood = FALSE, stun = TRUE)
		M.add_stress(/datum/stressevent/fermented_crab_bad)
	else
		to_chat(M, span_userdanger("You feel a bit queasy, but otherwise okay. And even greatly invigorated!"))
		M.add_stress(/datum/stressevent/fermented_crab_good)
	M.apply_status_effect(/datum/status_effect/buff/fermented_crab)
	return ..()

/datum/reagent/fermented_crab/overdose_start(mob/living/M)
	M.playsound_local(M, 'sound/magic/heartbeat.ogg', 100, FALSE)
	M.visible_message(span_warning("Blood runs from [M]'s nose."))

/datum/reagent/medicine/trait
	var/trait	// applied on ingest, removed when the reagent clears the system
	var/addmsg	// ex. "my body feels lighter", displayed to the imbiber on effect start
	var/delmsg	// ex. "the weight of the world rests upon my shoulders once more", displayed to the imbiber on effect end

/datum/reagent/medicine/trait/on_mob_metabolize(mob/living/L)
	. = ..()
	if(trait && !HAS_TRAIT(L, trait))
		ADD_TRAIT(L, trait, TRAIT_SOURCE_POTION)
		if(addmsg)
			to_chat(L, span_warning(addmsg)) // standard style for buff add/remove messages

/datum/reagent/medicine/trait/on_mob_end_metabolize(mob/living/L)
	. = ..()
	if(trait && HAS_TRAIT_FROM(L, trait, TRAIT_SOURCE_POTION))
		REMOVE_TRAIT(L, trait, TRAIT_SOURCE_POTION)
		if(delmsg)
			to_chat(L, span_warning(delmsg)) // ditto

/mob/living/carbon/human/proc/debug_trait_pots()
	var/list/types = typesof(/datum/reagent/medicine/trait)
	types += /datum/reagent/repairelixir
	var/inp = input("CHOOSE THE REAGENT THAT YOU PREFER", "ANOTHER HER", /datum/reagent/medicine/trait/nitevision) as anything in types
	var/obj/item/reagent_containers/glass/bottle/alchemical/vial = new /obj/item/reagent_containers/glass/bottle/alchemical(loc)
	vial.reagents.add_reagent(inp, 30)
	put_in_hands(vial)

/datum/reagent/medicine/trait/nitevision
	name = "Nocsight Elixir"
	description = "Grants the eyes a silvery glow, Noc's light guiding one's gaze even in the darkest nites."
	taste_description = "shimmering moonlight"
	scent_description = "crisp nite air"
	trait = TRAIT_NITEVISION
	color = "#ccd0fe"
	addmsg = "My eyes take on a silvery hue as the veil of darkness parts before me."
	delmsg = "My nite-sight fades; darkness falls once more."

/datum/component/eye_color_change // literally only exists to store the mob's original eye color
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/old_color

/datum/component/eye_color_change/Initialize(eye_color)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	old_color = eye_color

/datum/reagent/medicine/trait/nitevision/on_mob_metabolize(mob/living/L) // yes, it actually turns your eyes silver visually
	. = ..()
	var/mob/living/carbon/human/H = L
	if(!istype(H) || !H.getorganslot(ORGAN_SLOT_EYES))
		return
	H.AddComponent(/datum/component/eye_color_change, H.get_eye_color())
	H.set_eye_color("#ccd0fe")

/datum/reagent/medicine/trait/nitevision/on_mob_end_metabolize(mob/living/L)
	. = ..()
	var/mob/living/carbon/human/H = L
	if(!istype(H))
		return
	var/datum/component/eye_color_change/eye_color = H.GetComponent(/datum/component/eye_color_change)
	if(eye_color)
		H.set_eye_color(eye_color.old_color)

/datum/reagent/medicine/trait/sleepdraught
	name = "Restful Draught"
	description = "Calms yet invigorates the mind, maximizing the benefits of the next rest."
	taste_description = "chamomilesque herbs"
	scent_description = "calming florescence"
	trait = TRAIT_GOODSLEEP
	color = "#8300ee"
	addmsg = "I feel calm, yet my mind races. I will surely dream furiously."
	delmsg = "The surge of nocturnal inspiration fades."

/datum/reagent/medicine/trait/waterbreathing
	name = "Elixir of Hadal Grace"
	description = "Draws upon Abyssor's blessing, allowing one to persist without breath - for a time."
	taste_description = "abyssal saltiness"
	scent_description = "the sea"
	trait = TRAIT_NOBREATH
	color = "#00255eff"
	metabolization_rate = 2 * REAGENTS_METABOLISM // don't gamer too hard with this one please
	addmsg = "I choke momentarily as my lungs adjust; then, suddenly, I stop breathing entirely."
	delmsg = "With a gasp, air floods my lungs once more."

/datum/reagent/medicine/trait/waterbreathing/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.emote("gasp", forced = TRUE)

/datum/reagent/medicine/trait/nutrientslurry // loser mage meal replacement shake
	name = "Nourishing Draught"
	description = "Slows the metabolism, allaying hunger and thirst."
	taste_description = "frozen bird meat, inexplicably"
	scent_description = "frosty meatiness"
	trait = TRAIT_NOHUNGER
	color = "#5f3e00"
	addmsg = "Hunger and thirst fade away, my focus shifts to more important things."
	delmsg = "My hunger and thirst return; this reprieve just as temporary as every other."

/datum/reagent/medicine/trait/ravenous
	name = "Ravenous Elixir"
	description = "Taps into Dendor's feral nature, granting the ability to safely digest even the most dubious of foods. Won't save you from poisons, though."
	taste_description = "viscera and marrow"
	scent_description = "raw meat"
	trait = TRAIT_NASTY_EATER
	color = "#d61d6a"
	addmsg = "I feel a ravenous hunger overtake me. After a mote, it fades to a manageable level."
	delmsg = "My wyld hunger fades completely."

/datum/reagent/medicine/trait/antidepressants
	name = "Draught of Numbness"
	description = "Deadens the heart, protecting one from the ravages of stress - but dulling the joys of lyfe just as much."
	taste_description = "rapidly-fading melancholy"
	scent_description = "tingly absence"
	trait = TRAIT_NOMOOD
	color = "#4d008b"
	addmsg = "I feel my stress drain away as all emotion dulls and fades."
	delmsg = "The stresses - and joys - of the world return to me."

/datum/reagent/medicine/trait/wyrdlaborer
	name = "Laborer's Draught"
	description = "Deadens the heart, protecting one from the ravages of stress - but dulling the joys of lyfe just as much."
	taste_description = "strangely invigorating earthiness"
	scent_description = "earthiness"
	trait = TRAIT_WYRD_LABOURER
	color = "#ad4f10"
	addmsg = "I feel a strange strength growing. The world seems like parchment, or clay - as easily sculped as it is cleaved."
	delmsg = "The surge of strength fades."

/datum/reagent/medicine/trait/negative
	harmful = TRUE
	metabolization_rate = 0.1 * REAGENTS_METABOLISM

/datum/reagent/medicine/trait/negative/prodepressants
	name = "Stress Toxin"
	description = "Inflicts the mind with paranoia, enhancing any and all stresses for the duration."
	taste_description = "a metallic tang"
	scent_description = "a foreboding odor"
	trait = TRAIT_BAD_MOOD
	color = "#ff9f9f"
	addmsg = "What was in that? I feel awful, all my burdens weigh on me more heavily."
	delmsg = "My stress returns to a manageable level."

/datum/reagent/medicine/trait/negative/evilcaffiene
	name = "Restless Toxin"
	description = "Energizes the mind and body, preventing restful sleep."
	taste_description = "an energetic sourness"
	scent_description = "a sharp clarity"
	trait = TRAIT_NOSLEEP
	color = "#e9e9e9"
	addmsg = "I feel a sense of restlessness. I doubt I'll get much out of sleep, now."
	delmsg = "The restless feeling fades."

// nonfunctional since the removal of accent code
// /datum/reagent/medicine/trait/negative/funnyvoice
// 	name = "Xylix's Bane"
// 	description = "Alters the vocal chords, inflicting a silly voice on the imbiber."
// 	taste_description = "a slight sweetness"
// 	scent_description = "sweetness"
// 	trait = TRAIT_COMICSANS
// 	color = "#fff789"
// 	addmsg = "I feel something in my throat shift."
// 	delmsg = "My voice returns to normal."

// /datum/reagent/medicine/trait/negative/funnyvoice/on_mob_metabolize(mob/living/L)
// 	. = ..()
// 	RegisterSignal(L, COMSIG_MOB_SAY, PROC_REF(handle_speech))

// /datum/reagent/medicine/trait/negative/funnyvoice/on_mob_metabolize(mob/living/L)
// 	. = ..()
// 	UnregisterSignal(L, COMSIG_MOB_SAY)

// /datum/reagent/medicine/trait/negative/funnyvoice/proc/handle_speech(datum/source, list/speech_args)
// 	speech_args[SPEECH_SPANS] |= SPAN_SANS

/datum/reagent/medicine/trait/negative/singing
	name = "Xylix's Boon"
	description = "Alters the vocal chords, inflicting a compulsion to sing on the imbiber."
	taste_description = "a slight sweetness"
	scent_description = "sweetness"
	trait = TRAIT_MUSES_GRACE
	color = "#fff789"
	addmsg = "I feel something in my throat shift."
	delmsg = "My voice returns to normal."

/datum/reagent/repairelixir // moonstruck nectar real
	name = "Elixir of Restoring"
	description = "When poured over an object - anything from arms-and-armor to doors and walls - causes it to slowly repair itself for a short time. Items must be on the ground or a table. Larger quantities are more effective. Has no effect on lyving beings"
	taste_description = "sweet metal"
	scent_description = "cloying sweetness"
	color = "#70eaff"

/datum/reagent/repairelixir/reaction_obj(obj/O, volume)
	. = ..()
	O.visible_message(span_warning("[O] begins to knit itself back together under the effects of the elixir!"))
	spawn for(var/i in 1 to volume)
		if(isitem(O) && !isturf(O.loc))
			O.visible_message(span_warning("The mending elixir spills off of [O]. It needs to be on a stable surface to mend!"))
			break
		O.obj_integrity = min(O.max_integrity, O.obj_integrity + REPAIR_ELIXIR_STRENGTH)
		if(O.obj_integrity == O.max_integrity)
			if(O.obj_broken)
				O.obj_fix()
			break
		sleep(6) // a bottle will take a full 30 seconds to work so this shouldn't be super combat viable?

#undef TRAIT_SOURCE_POTION
#undef REPAIR_ELIXIR_STRENGTH
