// Catalyst. This reagent combined with normal potion reagent makes the strong potion reagent. Reactions defined by the end of this doccument
/datum/reagent/additive
	name = "additive"
	reagent_state = LIQUID

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

/datum/reagent/medicine/healthpot/on_mob_life(mob/living/carbon/M)
	if(volume >= 60)
		M.reagents.remove_reagent(/datum/reagent/medicine/healthpot, 2) //No overhealing.
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+15, BLOOD_VOLUME_NORMAL)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(3) //at a motabalism of .5 U a tick this translates to 120WHP healing with 20 U Most wounds are unsewn 15-100. This is powerful on single wounds but rapidly weakens at multi wounds.
	if(volume > 0.99)
		M.adjustBruteLoss(-1.75  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-1.75  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-1.25, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-1.75  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/medicine/stronghealth
	name = "Strong Health Potion"
	description = "Quickly regenerates all types of damage."
	color = "#820000be"
	taste_description = "rich lifeblood"
	scent_description = "metal"
	metabolization_rate = REAGENTS_METABOLISM * 3

/datum/reagent/medicine/stronghealth/on_mob_life(mob/living/carbon/M)
	if(volume >= 60)
		M.reagents.remove_reagent(/datum/reagent/medicine/healthpot, 2) //No overhealing.
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+20, BLOOD_VOLUME_NORMAL)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(6) //at a motabalism of .5 U a tick this translates to 240WHP healing with 20 U Most wounds are unsewn 15-100.
	if(volume > 0.99)
		M.adjustBruteLoss(-7  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-7  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-5, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-7  * REAGENTS_EFFECT_MULTIPLIER, 0)
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

/datum/reagent/medicine/strongmana/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(120)
	..()

/datum/reagent/medicine/stampot
	name = "Stamina Potion"
	description = "Gradually regenerates stamina."
	reagent_state = LIQUID
	color = "#129c00"
	taste_description = "sweet tea"
	scent_description = "grass"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/medicine/stampot/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.stamina_add(-20)
	..()
	. = 1

/datum/reagent/medicine/strongstam
	name = "Strong Stamina Potion"
	description = "Rapidly regenerates stamina."
	color = "#13df00"
	taste_description = "sparkly static"
	scent_description = "grass"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/strongstam/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.stamina_add(-50)
	..()
	. = 1

/** Design Note: Antidotes are meant to last as long as the poison, and purge them much quicker
 Having a 1 to 1 antidote to poison where you have to tailor defense to an increasing amount of attack
 is a bad idea, since that just means no one will use antidotes and the weapon win the race vs defense.
 This means pre ingesting antidote when expecting poison is a viable strategy.
 Previously, antidote did not have a dylovene-like effect and just purged toxin damage while poison will outlast them.
**/
/datum/reagent/medicine/antidote
	name = "Antidote"
	description = ""
	reagent_state = LIQUID
	color = "#00ff00"
	taste_description = "sickly sweet"
	scent_description = "medicine"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM

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
	description = ""
	reagent_state = LIQUID
	color = "#004200"
	taste_description = "dirt"
	scent_description = "medicine"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM

/datum/reagent/medicine/strong_antidote/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.adjustToxLoss(-12, 0)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R.harmful)
			holder.remove_reagent(R, 3)
	..()
	. = 1

/* Buff potions
	Previously, it would apply a status effect to the mob lasting for 93 / 300 seconds and remove everything
	However it meant that putting it in an alchemical vial was a trap as it sipped 9 units instead of 5 units that is the required minimum.
	And removed any excessive potion inside the body. This has been changed to apply a 3 seconds buff to the mob, but have much lower
	metabolization rate, so that the duration of the buff depends on how long you last.
	Roughly tested. At Metabolization Rate 1. 10 units sip (1/3 of a vial) last 20 seconds.
	To make this somewhat equal to the old system, base metabolization rate is 0.1 - making it last 200 seconds - 600 seconds if you sip an entire vial.
	This is 2x on weaker potions (Intelligence, Fortune). However, overdose threshold is now 30 units so you can only drink one vial at once.
	And potion stacking is not possible without neutralizing itself.
*/
/datum/reagent/buff
	description = ""
	reagent_state = LIQUID
	metabolization_rate = REAGENTS_METABOLISM * 0.1
	overdose_threshold = 33

/datum/reagent/buff/overdose_process(mob/living/carbon/M)
	. = ..()
	M.Jitter(2)
	if(!HAS_TRAIT(M, TRAIT_CRACKHEAD)) // Baothan get to stack more of one potion in their body, but not multiple
		M.adjustToxLoss(3)

/datum/reagent/buff/on_mob_life(mob/living/carbon/M)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(istype(R, /datum/reagent/buff) && R != src)
			holder.remove_reagent(R.type, 10)
			// Rapidly purge stacking buffs
	..()

/datum/reagent/buff/strength
	name = STATKEY_STR
	color = "#ff9000"
	taste_description = "old meat"
	scent_description = "meat"

/datum/reagent/buff/strength/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/alch/strengthpot)
	return ..()

/datum/reagent/buff/perception
	name = STATKEY_PER
	color = "#ffff00"
	taste_description = "cat piss"
	scent_description = "urine"
	metabolization_rate = REAGENTS_METABOLISM * 0.05

/datum/reagent/buff/perception/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/alch/perceptionpot)
	return ..()

/datum/reagent/buff/intelligence
	name = STATKEY_INT
	color = "#438127"
	taste_description = "bog water"
	scent_description = "moss"
	metabolization_rate = REAGENTS_METABOLISM * 0.05

/datum/reagent/buff/intelligence/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/alch/intelligencepot)
	return ..()

/datum/reagent/buff/constitution
	name = STATKEY_CON
	color = "#130604"
	taste_description = "bile"
	scent_description = "vomit"

/datum/reagent/buff/constitution/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/alch/constitutionpot)
	return ..()

/datum/reagent/buff/endurance
	name = STATKEY_WIL
	color = "#ffff00"
	taste_description = "oversweetened milk"

/datum/reagent/buff/endurance/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/alch/endurancepot)
	return ..()

/datum/reagent/buff/speed
	name = STATKEY_SPD
	color = "#ffff00"
	taste_description = "raw egg yolk"
	scent_description = "sweat"

/datum/reagent/buff/speed/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/alch/speedpot)
	return ..()

/datum/reagent/buff/fortune
	name = STATKEY_LCK
	color = "#ffff00"
	taste_description = "sour lemons"
	scent_description = "citrus"
	metabolization_rate = REAGENTS_METABOLISM * 0.05

/datum/reagent/buff/fortune/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/alch/fortunepot)
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
	if(!HAS_TRAIT(M, TRAIT_NASTY_EATER) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.add_nausea(9)
		M.adjustToxLoss(2)
	return ..()

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

//Potion reactions
/datum/chemical_reaction/alch/stronghealth
	name = "Strong Health Potion"
	id = /datum/reagent/medicine/stronghealth
	results = list(/datum/reagent/medicine/stronghealth = 1)
	required_reagents = list(/datum/reagent/medicine/healthpot = 1, /datum/reagent/additive = 1)
	mix_message = "The cauldron glows for a moment."

/datum/chemical_reaction/alch/strongmana
	name = "Strong Mana Potion"
	id = /datum/reagent/medicine/strongmana
	results = list(/datum/reagent/medicine/strongmana = 1)
	required_reagents = list(/datum/reagent/medicine/manapot = 1, /datum/reagent/additive = 1)
	mix_message = "The cauldron glows for a moment."

/datum/chemical_reaction/alch/strongstam
	name = "Strong Stamina Potion"
	id = /datum/reagent/medicine/strongstam
	results = list(/datum/reagent/medicine/strongstam = 1)
	required_reagents = list(/datum/reagent/medicine/stampot = 1, /datum/reagent/additive = 1)
	mix_message = "The cauldron glows for a moment."

/datum/chemical_reaction/alch/strongpoison
	name = "Strong Health Poison"
	id = /datum/reagent/strongpoison
	results = list(/datum/reagent/strongpoison = 1)
	required_reagents = list(/datum/reagent/berrypoison = 1, /datum/reagent/additive = 1)
	mix_message = "The cauldron glows for a moment."

/datum/chemical_reaction/alch/strongstampoison
	name = "Strong Stamina Leech Potion"
	id = /datum/reagent/strongstampoison
	results = list(/datum/reagent/strongstampoison = 1)
	required_reagents = list(/datum/reagent/stampoison = 1, /datum/reagent/additive = 1)
	mix_message = "The cauldron glows for a moment."

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
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction()
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
