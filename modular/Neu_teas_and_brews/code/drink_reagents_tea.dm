
// basic tea, utilises adjusted soup code
// PORT TO AZURE COMMENT: When I originally added this to vanderlin, I had to axe existing teas, In good conciousness I refuse to touch it here because it doest conflict and I refuse to refactor entire thing. Goodluck to whoever does tho.
/datum/reagent/consumable/tea/
	name = "Generic tea"
	description = "A common concept of a generic tea made from whatever, by whoever."
	reagent_state = LIQUID
	color = "#c38553"
	nutriment_factor = 2
	metabolization_rate = 0.3 // 33% of normal metab
	taste_description = "grass"
	taste_mult = 3
	nutriment_factor = 1
	hydration_factor = 1
	quality = 1
	alpha = 153

/datum/reagent/consumable/tea/on_mob_life(mob/living/carbon/M)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+2, BLOOD_VOLUME_NORMAL)
	..()

/datum/reagent/consumable/tea/taraxamint
	name = "Taraxacum-Mentha tea"
	description = "Soothing herbal green tea, rumored to help ease burns, liver issues and help with head traumas"
	color = "#acaf01"
	nutriment_factor = 2
	metabolization_rate = 0.3 // 33% of normal metab
	taste_description = "relaxing texture, minty aftertaste"
	taste_mult = 3
	quality = 1

/datum/reagent/consumable/tea/taraxamint/on_mob_life(mob/living/carbon/M)
	if(volume >= 20)
		M.reagents.remove_reagent(/datum/reagent/consumable/tea/taraxamint, 2) //No overhealing.
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(0.4) // Equals to 24 woundhealing distributed when you drink entire 20 units. Slow and not too much, but just enough to give you time to crawl to somewhere safe (lets be real, even the streets are a gamble)
	if(volume > 0.99)
		M.adjustFireLoss(-0.75*REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1*REAGENTS_EFFECT_MULTIPLIER)
		M.adjustToxLoss(-1, 0)
	..()

/datum/reagent/consumable/tea/utricasalvia
	name = "Urtica-Salvia tea"
	description = "Deep, velvet tea. Taste of tingling sour fruits. Used by a traditional remedy by common folk to recover from bruises and burns. Some even say it can heal wounds."
	color = "#451853"
	nutriment_factor = 2
	metabolization_rate = 1
	taste_description = "tingling, sour fruits"
	taste_mult = 2
	quality = 3

/datum/reagent/consumable/tea/utricasalvia/on_mob_life(mob/living/carbon/M)
	if(volume >= 20)
		M.reagents.remove_reagent(/datum/reagent/consumable/tea/utricasalvia, 2)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(2) // 40 woundhealing distributed on all wounds, not too much to balance innate healing below, but works faster
		M.adjustBruteLoss(-1*REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-1*REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/tea/badidea
	name = "westleach tar tea"
	description = "Refined westleach resin, made by boiling leafs in water. Nay good for consumption in this state, but widely used by naledian nomads to be made into portable smoke paste."
	color = "#490100"
	nutriment_factor = 2
	metabolization_rate = 2 // ye be fucked my guy
	taste_description = "HEROIC, amounts of westleach tar"
	taste_mult = 4
	hydration_factor = 0
	quality = 0

/datum/reagent/consumable/tea/badidea/on_mob_life(mob/living/carbon/M)
	if(volume > 1)

		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
			M.sate_addiction(/datum/charflaw/addiction/masochist)
		else
			M.add_nausea(2) // You didn't think it was a good idea, did you?
			M.adjustToxLoss(3) //its not as poisonous as it is absolutely digsusting
			M.sate_addiction(/datum/charflaw/addiction/masochist)
			M.apply_status_effect(/datum/status_effect/debuff/rotfood)
	return ..()

/datum/reagent/consumable/tea/fourtwenty
	name = "swampweed brew"
	description = "Swampweed leaf brewed into a drink. Used by shamans and other spiritual guides. Its gemerald color hides its true earhty taste. "
	color = "#04750a"
	nutriment_factor = 2
	metabolization_rate = 1
	taste_description = "dirt, colors, future"
	taste_mult = 3
	hydration_factor = 2
	quality = 1

/datum/reagent/consumable/tea/fourtwenty/on_mob_life(mob/living/carbon/M)
	if(volume > 10)
		M.apply_status_effect(/datum/status_effect/buff/weed)
		M.sate_addiction(/datum/charflaw/addiction/junkie)
	return ..()

/datum/reagent/consumable/tea/manabloom
	name = "Manabloom tea"
	description = "Manabloom flower is tossed into hot, boiling water. A crude, inefficient but cheap method to extract its properties."
	color = "#5986b1"
	nutriment_factor = 2
	metabolization_rate = 0.2 // 20% of normal metab
	taste_description = "stinging, floral tones. Did it just cast something in your mouth?..."
	taste_mult = 2
	hydration_factor = 1
	overdose_threshold = 20

/datum/reagent/consumable/tea/manabloom/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.energy_add(3) // 6.3 times weaker than normal manapot
	..()

/datum/reagent/consumable/tea/manabloom/overdose_process(mob/living/M)
	M.adjustToxLoss(1, 0)
	M.reagents.remove_reagent(/datum/reagent/consumable/tea/manabloom, 2) //No powerchuging for you, mage lad.
	to_chat(M, span_danger("My stomach BURNS."))
	..()
	. = 1

/datum/reagent/consumable/tea/compot
	name = "Compot"
	description = "Drink of Gronnic origin, dried fruit is made into nutritious sweet delicacy they partake regardless of status."
	color = "#cca358"
	nutriment_factor = 2
	metabolization_rate = 0.2 // 20% of normal metab
	taste_description = "strong berry taste, its very sweet"
	taste_mult = 4
	hydration_factor = 3 //a hydrating, nutritious and convinient drink made of raisins
	nutriment_factor = 2
	quality = 2

/datum/reagent/consumable/tea/compot/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/atom/movable/screen/alert/status_effect/buff/sweet)
	..()

/datum/reagent/consumable/tea/sbiten
	name = "Sbiten" //not a typo
	description = "Marvel of Gronnic cuisine, rivals even well aged liquors in how enjoyable it is. Honey is infused with spices and then diluted in hot water. Highly luxurious item in the North."
	reagent_state = LIQUID
	color = "#f0dba3"
	nutriment_factor = 2
	metabolization_rate = 0.3 // 33% of normal metab
	taste_description = "delectable spiced honey"
	taste_mult = 3
	nutriment_factor = 1
	hydration_factor = 2
	quality = 4
	alpha = 153

/datum/reagent/consumable/tea/sbiten/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/atom/movable/screen/alert/status_effect/buff/sweet)
	..()
