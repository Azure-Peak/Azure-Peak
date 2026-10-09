/datum/reagent/consumable/caffeine/raneshenbitter
	cuisine = CUISINE_RANESHENI
	quality = DRINK_GOOD
	name = "Raneshen Bitter Tea"
	description = "Dark and foreboding, a bitter reminder of the loss of PSYDON, to be followed by sweet exaltation of HIS sacrifice."
	reagent_state = LIQUID
	color = "#663854"
	taste_description = "smooth, intense bitterness"

/datum/reagent/consumable/brew/eorasgracetea
	name = "Eora's Grace"
	description = "And she held my hand gently and she smiled. I cried, for I remembered my mother. How I miss her so."
	color = "#fbaed2"
	taste_description = "fruity herbaceousness"

/datum/reagent/consumable/brew/eorasgracetea/on_mob_life(mob/living/carbon/M)
	. = ..()
	brew_mend(M, 0.2, 0.1)

/datum/reagent/consumable/brew/eorasloveteafake
	cuisine = CUISINE_SOUTH_IMPERIAL|CUISINE_OTAVAIS
	quality = DRINK_GOOD
	name = "Faked Eora's Love"
	description = "A testament that humankind can never reach the perfection of the gods. Is this love? Or just a really sweet tea?"
	color = "#fba0e3"
	taste_description = "saccharine fruitiness"

/datum/reagent/consumable/brew/eorasloveteafake/on_mob_life(mob/living/carbon/M)
	. = ..()
	brew_mend(M, 0.3, 0.1)

/datum/reagent/consumable/brew/eorasloveteatrue
	cuisine = CUISINE_NORTH_IMPERIAL|CUISINE_SOUTH_IMPERIAL|CUISINE_OTAVAIS|CUISINE_NORTHERN|CUISINE_ETRUSCAN|CUISINE_SOUTHEASTERN|CUISINE_RANESHENI
	quality = DRINK_VERYGOOD
	name = "Eora's Love"
	description = "Humenkind cannot love like the gods, but they do not need to. They have each other and this bond is Eora's most cherished fact of the world."
	color = "#fba0e3"
	taste_description = "affection"

/datum/reagent/consumable/brew/eorasloveteatrue/on_mob_life(mob/living/carbon/M)
	. = ..()
	brew_mend(M, 0.45, 0.15, 1.5)

/datum/reagent/consumable/caffeine/ravoxtea
	cuisine = CUISINE_ETRUSCAN
	quality = DRINK_GOOD
	name = "Ravox's Calm"
	description = "Brew this and drink deep. Feel the focus. Draw your blade with an unclouded mind and let justice speak where mercy was ignored."
	reagent_state = LIQUID
	color = "#482000"
	taste_description = "mind-clearing bitterness"
	brew_buff = /datum/status_effect/buff/brew/ravox_calm

/datum/reagent/consumable/caffeine/mocha
	cuisine = CUISINE_RANESHENI
	quality = DRINK_GOOD
	name = "Veranda Coffee"
	description = "I make this pot in the name of the Allfather, stranger. Sit down and drink. As long the brew remains, we shall be brothers. When it is empty, we will depart and maybe see each other again."
	reagent_state = LIQUID
	color = "#482000"
	taste_description = "bitter chocolate"

/datum/reagent/consumable/caffeine/mocha/on_mob_life(mob/living/carbon/M)
	. = ..()
	brew_mend(M, 0.3, 0.15, 1, -0.1)

/datum/reagent/consumable/brew/gerevine
	cuisine = CUISINE_OTAVAIS
	quality = DRINK_GOOD
	name = "Gerevine Brew"
	description = "It is said that this drink was the first offered to the Saints, when they descended and walked among the faithful. They wept, for it reminded them of the Allfather."
	color = "#fdbcb4"
	taste_description = "nostalgic homesickness"
	brew_buff = /datum/status_effect/buff/brew/willpower

/datum/reagent/consumable/brew/gerevine/on_mob_life(mob/living/carbon/M)
	. = ..()
	brew_mend(M, 0.1, 0.1)
	if(!(M.mob_biotypes & MOB_BEAST))
		M.adjustToxLoss(-1, 0)

/datum/reagent/consumable/caffeine/schorle
	cuisine = CUISINE_NORTH_IMPERIAL
	quality = DRINK_GOOD
	name = "Apfelschorle"
	description = "Come! Watch me drink the orchard's finest nectar! Ah, lyfe can be so wonderful."
	reagent_state = LIQUID
	color = "#d0f0c0"
	taste_description = "pearly tartness"

/datum/reagent/consumable/caffeine/schorle/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(5)

/datum/reagent/consumable/brew/baothablend
	name = "Void's Embrace"
	description = "So dark it swallows the stars. Regret incarnate. Sup from it and forget."
	color = "#d00000"
	taste_description = "merciful oblivion"

/datum/reagent/consumable/brew/baothablend/on_mob_metabolize(mob/living/L)
	. = ..()
	to_chat(L, span_warning("As your lips touch the brew and you drink, you feel yourself cry. Pain surges through you, not physical, but within your heart. All the slights, the taunts, the hurts in your lyfe rush through your head as your body gives out.\n \
Your dreams are a confusing mess of visions of what you have to put up with, the great and the small anguishes of your lyfe and some more - memories you do not recognise. The smile of your sister, her tears when you are judged to die, his hands on your throat as they squeeze and squeeze-\n \
You wake up.\n \
What were you dreaming again? Wait… Where are you?\n \
Who are you?\n \
You have forgotten everything…"))
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.Sleeping(rand(30 SECONDS, 50 SECONDS))
		H.visible_message(span_warning("[H] suddenly collapses!"))
		H.apply_status_effect(/datum/status_effect/debuff/baothaforget)

/datum/reagent/consumable/brew/baothablend/on_mob_life(mob/living/carbon/M)
	. = ..()
	brew_mend(M, 0.75, 0.25, 2)

/datum/reagent/consumable/brew/forgottenlove
	name = "Tea of Sisters"
	description = "How can it be? Something so vile and something so pure combined brings forth something new and unprecedented."
	color = "#de6fa1"
	taste_description = "bittersweet nostalgia"

/datum/reagent/consumable/brew/forgottenlove/on_mob_metabolize(mob/living/L)
	. = ..()
	to_chat(L, span_warning("You remember something that you couldn't remember.\n\
Of staring into the night sky. \n\
Of wishing things could have been different.\n\
Of it not being too late.\n\
Regret weighs like a stone in your chest.\n\
How strange.\n\
You see the sky from a pit and a palace both."))

/datum/reagent/consumable/caffeine/chai
	cuisine = CUISINE_SOUTHEASTERN|CUISINE_RANESHENI
	quality = DRINK_GOOD
	name = "Chai"
	description = "And on we march to unite the Isles. Gleaming naginatas clash against wicker shields and in the nite we drink Aisata's favoured tea."
	reagent_state = LIQUID
	color = "#b78727"
	taste_description = "peppery-sweet grassiness"

/datum/reagent/consumable/caffeine/chai/on_mob_life(mob/living/carbon/M)
	. = ..()
	brew_mend(M, 0.3, 0.15, 1, -0.1)

/datum/reagent/consumable/brew/volfmilk
	cuisine = CUISINE_NORTHERN
	drink_type = DRINKTYPE_JUICE
	quality = DRINK_GOOD
	name = "Vargmjölk"
	description = "And we ring the fire, backs turned in snide to the cold. Volf-skinned, we thank you for snatching this brew from the teats of the world…"
	color = "#d3003f"
	taste_description = "warm, fruity sweetness"

/datum/reagent/consumable/brew/icetea
	cuisine = CUISINE_NORTHERN
	drink_type = DRINKTYPE_JUICE
	quality = DRINK_GOOD
	name = "Fruktte"
	description = "And in the mountains we tear the frozen tears of the moose, for we do not lose ourselves in bloodshed yet like it wants us to. Instead, we enjoy a good cup with friends and clan."
	color = "#0f4d92"
	taste_description = "cooled fruitiness"

/datum/reagent/consumable/brew/barleytea
	cuisine = CUISINE_NORTH_IMPERIAL
	quality = DRINK_GOOD
	name = "Barley Tea"
	description = "Reality is an affliction caused by the chronic lack of alcohol in the humours. This won't fix it, but at least it whets the tongue, lad."
	color = "#e08d3c"
	taste_description = "toasty bitterness"

/datum/reagent/consumable/brew/kvass
	cuisine = CUISINE_SOUTH_IMPERIAL
	quality = DRINK_GOOD
	name = "Kvass"
	description = "Tis the bread we drink. Mount the saigas then and let us ride. For the steppe waits for no one and our forefather gave us this so we don't have to chew our meal."
	color = "#b78727"
	taste_description = "astringent-sweet cereals"

/datum/reagent/consumable/brew/avantare
	cuisine = CUISINE_ETRUSCAN
	quality = DRINK_GOOD
	name = "Avantare"
	description = "Furl the sails, take down the mizzenmast. Drink our Avantare and hug your wife. We are home, finally home again."
	color = "#ffff66"
	taste_description = "freshening sourness"
