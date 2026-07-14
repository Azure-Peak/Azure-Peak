/datum/stressevent/psyprayer
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("The Gods smile upon me.")

/datum/stressevent/seeblessed
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("I feel joy within these halls.")

/datum/stressevent/viewsinpunish
	timer = 5 MINUTES
	stressadd = -2
	desc = span_green("Justice to the sinful has been served!")

/datum/stressevent/joke
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("I heard a good joke!")

/datum/stressevent/tragedy
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("Perhaps life isn't so bad after all.")

/datum/stressevent/blessed
	timer = 60 MINUTES
	stressadd = -2
	desc = list(
		span_blue("I feel a soothing presence. I can feel the Ten's favor upon me. I have been blessed."),
		span_blue("I feel a soothing presence. The Ten have smiled upon me. I know I walk beneath their grace."),
		span_blue("I feel a soothing presence. Their blessing feels so close... surely they have not forgotten me."),
		span_blue("I feel a soothing presence. The Ten have guided my steps. I am exactly where I am meant to be."),
		span_blue("I feel a soothing presence. I can feel their kindness surrounding me. Their favor gives me strength."),
		span_blue("I feel a soothing presence. The Ten Eternal have chosen to watch over me, and I am humbled by it."),
		span_blue("I feel a soothing presence. Every hardship feels lighter knowing the Ten walk beside me."),
		span_blue("I feel a soothing presence. Their warmth reaches me even now. I must be blessed beyond measure."),
		span_blue("I feel a soothing presence. The Ten have heard me. I know their gaze rests upon me."),
		span_blue("I feel a soothing presence. Their favor is with me, and my heart cannot contain the joy of it."),
		span_blue("I feel a soothing presence. I have spent so long seeking their guidance... and now I feel their answer."),
		span_blue("I feel a soothing presence. The Ten have given me another chance to serve their purpose."),
		span_blue("I feel a soothing presence. I am not alone. The Eternal walk with me."),
		span_blue("I feel a soothing presence. Their blessing fills me with a certainty I have never known before."),
		span_blue("I feel a soothing presence. I feel seen. I feel valued. The Ten remember me.")
	)

/datum/stressevent/triumph
	timer = 10 MINUTES
	stressadd = -5
	desc = span_boldgreen("I remember a TRIUMPH.")

/datum/stressevent/drunk
	timer = 1 MINUTES
	stressadd = -2
	desc = list(span_green("I feel quite drunk, now."), span_green("Everything is spinning!"))

/datum/stressevent/pweed
	timer = 1 MINUTES
	stressadd = -2
	desc = span_green("A pleasant, stimulating buzz settles over me.")

/datum/stressevent/weed
	timer = 5 MINUTES
	stressadd = -4
	desc = list(span_blue("My senses numb, and my vision blurs!"), span_blue("A pleasant euphoria clouds my mind..."))

/datum/stressevent/high
	timer = 5 MINUTES
	stressadd = -4
	desc = span_blue("My mind is addled in such a pleasant way!")

/datum/stressevent/stuffed
	timer = 20 MINUTES
	stressadd = -1
	desc = span_green("I've a full stomach! This is a good dae.")

/datum/stressevent/goodsnack
	timer = 8 MINUTES
	stressadd = -1
	desc = span_green("That was quite a pleasant snack!")

/datum/stressevent/greatsnack
	timer = 10 MINUTES
	stressadd = -2
	desc = list(span_green("That snack was amazing!"), span_green("A truly sumptuous delicacy!"))

/datum/stressevent/goodmeal
	timer = 10 MINUTES
	stressadd = -1
	desc = list(span_green("That meal wasn't half bad!"), span_green("A decent meal, finally!"))

/datum/stressevent/greatmeal
	timer = 15 MINUTES
	stressadd = -2
	desc = list(span_green("That was a meal fit for a king!"), span_green("What an explosion of flavour \
	I just experienced!"))

/datum/stressevent/sweet
	timer = 8 MINUTES
	stressadd = -2
	desc = span_green("Sweet treats like these can raise even the lowest of moods!")

/datum/stressevent/hydrated
	timer = 10 MINUTES
	stressadd = -1
	desc = span_green("My thirst is quenched!")

/datum/stressevent/prebel
	timer = 5 MINUTES
	stressadd = -5
	desc = span_boldgreen("I am invigoated by revolutinary fervor!")

/datum/stressevent/music
	timer = 1 MINUTES
	stressadd = -1
	desc = span_green("This music is quite relaxing.")

/datum/stressevent/music/two
	stressadd = -2
	desc = span_green("This music is very relaxing!")
	timer = 2 MINUTES

/datum/stressevent/music/three
	stressadd = -2
	desc = span_green("This music drains away my stress.")
	timer = 4 MINUTES

/datum/stressevent/music/four
	stressadd = -3
	desc = span_green("This music is great!")
	timer = 6 MINUTES

/datum/stressevent/music/five
	stressadd = -3
	timer = 8 MINUTES
	desc = span_green("This music is wonderful!")

/datum/stressevent/music/six
	stressadd = -4
	timer = 10 MINUTES
	desc = span_boldgreen("This music is exceptional! Bravo!")

/datum/stressevent/vblood
	stressadd = -5
	desc = span_boldred("Virgin blood sates my thirst!")
	timer = 5 MINUTES

/datum/stressevent/bathwater
	stressadd = -1
	desc = span_blue("I feel soothed in this warm, clean water.")
	timer = 1 MINUTES

/datum/stressevent/bathwater/on_apply(mob/living/user)
	. = ..()
	if(user.client)
		record_round_statistic(STATS_BATHS_TAKEN)
		// SEND_SIGNAL(user, COMSIG_BATH_TAKEN)

/datum/stressevent/beautiful
	stressadd = -2
	desc = span_green("That person's face is a work of art!")
	timer = 2 MINUTES

/datum/stressevent/night_owl
	stressadd = -3
	desc = span_green("This night is relaxing and peaceful.")
	timer = 20 MINUTES

/datum/stressevent/ozium
	stressadd = -99
	desc = span_blue("I've taken a hit and entered a painless world.")
	timer = 2 MINUTES

/datum/stressevent/moondust
	stressadd = -6
	desc = span_boldgreen("Moondust surges through me!")
	timer = 4 MINUTES

/datum/stressevent/starsugar
	stressadd = -1
	desc = span_boldgreen("My heart rushes, my blood runs, I feel tightly bound together! I could run a marathon!")
	timer = 4 MINUTES

/datum/stressevent/moondust_purest
	stressadd = -8
	desc = span_boldgreen("Pure moondust surges through me!")
	timer = 4 MINUTES

/datum/stressevent/campfire
	stressadd = -1
	desc = span_green("The warmth of the fire is comforting.")
	timer = 5 MINUTES

/datum/stressevent/astrata_pyre
	stressadd = -3
	desc = span_green("I feel safe under Her watch.")
	timer = 5 MINUTES

/datum/stressevent/puzzle_easy
	stressadd = -1
	desc = span_green("That puzzle was a nice distraction from this drudgery.")
	timer = 10 MINUTES

/datum/stressevent/puzzle_medium
	stressadd = -2
	desc = span_green("I solved a slightly difficult puzzle. If only my actual problems were so easy.")
	timer = 10 MINUTES

/datum/stressevent/puzzle_hard
	stressadd = -3
	desc = span_green("I solved a rather challenging puzzle.")
	timer = 10 MINUTES

/datum/stressevent/puzzle_impossible
	stressadd = -4
	desc = span_boldgreen("I solved an extremely difficult puzzle. Xylix is smiling at me, and surely even \
	 Noc must find it impressive.")
	timer = 15 MINUTES

/datum/stressevent/noble_fine_food
	stressadd = -2
	desc = span_green("A fine meal, as befits my standing.")
	timer = 20 MINUTES

/datum/stressevent/noble_lavish_food
	stressadd = -4
	desc = span_green("Truly, a feast befitting my station.")
	timer = 30 MINUTES

/datum/stressevent/wine_okay
	stressadd = -1
	desc = span_green("That drink was alright.")
	timer = 10 MINUTES

/datum/stressevent/wine_good
	stressadd = -2
	desc = span_green("A decent vintage always goes down easy.")
	timer = 10 MINUTES

/datum/stressevent/wine_great
	stressadd = -3
	desc = span_blue("An absolutely exquisite vintage. Indubitably.")
	timer = 10 MINUTES

/datum/stressevent/favourite_food
	stressadd = -1
	desc = span_green("I ate my favourite food!")
	timer = 5 MINUTES

/datum/stressevent/favourite_food/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_event(/datum/stressevent/favourite_food))
		return FALSE
	else if(ishuman(user))
		var/mob/living/carbon/human/human_eater = user
		if(human_eater.culinary_preferences && human_eater.culinary_preferences[CULINARY_FAVOURITE_FOOD])
			var/favorite_food_type = human_eater.culinary_preferences[CULINARY_FAVOURITE_FOOD]
			var/obj/item/reagent_containers/food/snacks/favorite_food_instance = favorite_food_type
			timer = timer * max(initial(favorite_food_instance.faretype), 1)
			return TRUE

/datum/stressevent/favourite_drink
	stressadd = -1
	desc = span_green("I drank my favourite drink!")
	timer = 5 MINUTES

/datum/stressevent/favourite_drink/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_event(/datum/stressevent/favourite_drink))
		return FALSE
	else if(ishuman(user))
		var/mob/living/carbon/human/human_drinker = user
		if(human_drinker.culinary_preferences && human_drinker.culinary_preferences[CULINARY_FAVOURITE_DRINK])
			var/favorite_drink_type = human_drinker.culinary_preferences[CULINARY_FAVOURITE_DRINK]
			var/datum/reagent/consumable/favorite_drink_instance = favorite_drink_type
			timer = timer * max(1 + initial(favorite_drink_instance.quality), 1)
			return TRUE

/datum/stressevent/hated_food
	stressadd = 1
	desc = span_red("How vile! How can anyone eat what I just ate?!")
	timer = 10 MINUTES

/datum/stressevent/hated_food/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_event(/datum/stressevent/hated_food))
		return FALSE

/datum/stressevent/hated_drink
	stressadd = 1
	desc = span_red("Disgusting! How could anyone drink what I just drank?!")
	timer = 10 MINUTES

/datum/stressevent/hated_drink/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_event(/datum/stressevent/hated_drink))
		return FALSE

/datum/stressevent/meditation
	timer = 10 MINUTES
	stressadd = -1
	desc = span_green("My meditations were rewarding.")

/datum/stressevent/bathcleaned
    timer = 20 MINUTES
    stressadd = -3
    desc = span_green("I feel immaculate!")

/datum/stressevent/bath
    timer = 10 MINUTES
    stressadd = -1
    desc = span_green("I'm just a bit cleaner.")


/datum/stressevent/pacified
	timer = 30 MINUTES
	stressadd = -5
	desc = span_green("All my problems have washed away!")

/datum/stressevent/peacecake
	timer = 5 MINUTES
	stressadd = -3
	desc = span_green("My problems ease away.")

/datum/stressevent/noble_bowed_to
	timer = 5 MINUTES
	stressadd = -3
	desc = span_green("Someone showed me the respect I deserve as a noble!")

/datum/stressevent/noble_bowed_to/can_apply(mob/living/user)
	return HAS_TRAIT(user, TRAIT_NOBLE)

/datum/stressevent/perfume
	stressadd = -1
	desc = span_green("A soothing fragrance envelops me.")
	timer = 10 MINUTES

/datum/stressevent/astrata_grandeur
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("Astrata's light shines brightly through me. I must not let others ever forget that.")

/datum/stressevent/graggar_culling_finished
	stressadd = -1
	desc = span_green("My rival lies dead. Visions of their former lyfe flash before me as their former strength suffuses with mine.")
	timer = INFINITY

/datum/stressevent/eoran_blessing
	stressadd = -1
	desc = span_info("An Eoran shone their brightness upon me.")
	timer = 5 MINUTES

/datum/stressevent/eoran_blessing_greater
	stressadd = -2
	desc = span_info("A Devout Eoran shone their brightness upon me!")
	timer = 10 MINUTES

/datum/stressevent/sermon
	stressadd = -5
	desc = span_green("I feel inspired by the sermon!")
	timer = 20 MINUTES

/datum/stressevent/champion
	stressadd = -3
	desc = span_green("I am near my ward!")
	timer = 1 MINUTES

/datum/stressevent/ward
	stressadd = -3
	desc = span_green("I am near my Champion! Oh, oh, Champion!")
	timer = 1 MINUTES

/datum/stressevent/blessed_weapon
	stressadd = -3
	timer = 999 MINUTES
	desc = span_green("I'm wielding a BLESSED weapon!")

/datum/stressevent/hand_fed_fruit
	stressadd = -1
	timer = 5 MINUTES
	desc = span_green("How decadent!")

/datum/stressevent/fermented_crab_good
	stressadd = -1
	desc = span_green("That fermented crab was not the most pleasant dish ever, but youthful vigor in my body \
	was worth the sacrifice!")
	timer = 3 MINUTES

/datum/stressevent/vampiric_nostalgia
	stressadd = -2
	desc = span_green("Astrata and her gaze may burn you now, but you distantly remember when it was pleasant \
	to your skin.")
	timer = 20 SECONDS

/datum/stressevent/xylixian_fate
	timer = 10 MINUTES
	stressadd = -2
	desc = span_green("Xylix spun the thread of fate in my favour! Truly, I am blessed!")

/datum/stressevent/parasol_rain
	timer = 1 MINUTES
	stressadd = -2
	desc = list(span_blue("A covered stroll in the gentle rainfall is quite pleasant."))

/datum/stressevent/parasol_snow
	timer = 1 MINUTES
	stressadd = -2
	desc = list(span_blue("A covered stroll in the gentle snowfall is quite pleasant."))

/datum/stressevent/graggarite_blood_rain
	timer = 1 MINUTES
	stressadd = -3
	desc = list(span_boldred("I SOAKED IN THE BLOOD OF THE THOUSANDS DEAD! GRAGGAR GRAGGAR GRAGGAR!"))

// Intended to proc upon exposure to gentle rain.
/datum/stressevent/abyssor_rain
	timer = 1 MINUTES
	stressadd = -2
	desc = list(span_blue("This downpour cleanses the earth and brings into pleasing clarity \
	my recollections of the divine dream. If only I could remember more..."))

// Intended to proc upon exposure to a storm.
/datum/stressevent/abyssor_storm
	timer = 1 MINUTES
	stressadd = -4
	desc = list(span_blue("WHAT A MAJESTIC TEMPEST! BELOVED ABYSSOR, SEND STRONGER WINDS!"))

/datum/stressevent/keep_standard
	stressadd = -4
	desc = span_aiprivradio("The standard speaks of certainty.")
	timer = INFINITY

/datum/stressevent/keep_standard_lesser
	stressadd = -3
	desc = span_aiprivradio("The standard calls out to me! It knows we're to see victory!")
	timer = 3 MINUTES

// Effects for zigs

/datum/stressevent/menthasmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_boldgreen("A cooling feeling in my throat."))

/datum/stressevent/blackberrysmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_blue("A sweet-tart sensation on the tongue."))
	
/datum/stressevent/applesmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_blue("A feeling of sourness and coolness on the tongue."))

/datum/stressevent/chocolatesmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_purple("A pleasant feeling of rawness and bitterness on the tongue."))
	
/datum/stressevent/strawberrysmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_blue("A pleasant feeling of sourness and sweetness on the tongue."))
	
/datum/stressevent/carrotsmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_blue("A pleasant feeling of very carrot on the tongue."))
	
/datum/stressevent/limesmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_blue("A pleasant feeling of sweet and refreshing on the tongue."))
	
/datum/stressevent/salviasmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_blue("A pleasant feeling spicy, earthy and bitter on the tongue."))
	
/datum/stressevent/valerianasmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_blue("A pleasant feeling bitter-spicy and tart on the tongue."))
	
/datum/stressevent/zweed
	timer = 5 MINUTES
	stressadd = -2
	desc = list(span_blue("You feel a pleasant bitterness that burns and scratches your throat. Nicotine and the taste of oak bark leave a pleasant aftertaste in your mouth."))

/datum/stressevent/jacksberriessmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_blue("You feel a pleasant slight sourness and sweetnesson the tongue."))

/datum/stressevent/abysssmoke
	timer = 1 MINUTES
	stressadd = 0
	desc = list(span_blue("A pleasant feeling slight sourness and sweetnesson... and salty on the tongue? You feel an unpleasant chill run down your spine. You can't shake the feeling of someone staring from behind you..."))

//

/datum/stressevent/kytherian_blessing
	timer = 5 MINUTES
	stressadd = -2
	desc = span_rose("Kytheria is beautiful...")

/datum/stressevent/see_zuranus/zizoite
	timer = 5 MINUTES
	stressadd = -2
	desc = span_purple("...Zuranus is visible, surely, a sign of our continued Progress! ZIZO, ZIZO, ZIZO!")

/datum/stressevent/see_zuranus/graggarite
	timer = 5 MINUTES
	stressadd = -2
	desc = span_purple("JOVE! ANOTHER SYMBOL OF GRAGGAR'S DOMINANCE! HE REIGNS IN THE NOCMOS!")

/datum/stressevent/xylix_star/xylixian
	timer = 10 MINUTES // this will :) you for a while
	stressadd = -2
	desc = span_boldred("Long ago, XYLIX put up an extra star in the sky to anger NOC... seeing it is a FANTASTIC sign!")

/datum/stressevent/permadeath_end
	timer = 5 MINUTES
	stressadd = -4
	desc = span_boldgreen("<b>I feel whole, once more! Death shant claim me yet!</b>")

/// hopium from psycoke
/datum/stressevent/psycenser
	timer = 15 MINUTES
	stressadd = -4
	desc = list(
		span_hypnophrase("The fragance of SYON soothens me. His light is upon me. Let every evil break itself against my faith."),
		span_hypnophrase("The fragance of SYON soothens me. No darkness can claim me. The Allfather's grace walks before my every step."),
		span_hypnophrase("The fragance of SYON soothens me. I fear nothing. His warmth is my shield, and His promise my armor."),
		span_hypnophrase("The fragance of SYON soothens me. Let monsters come. Let heretics rage. His faithful shall endure."),
		span_hypnophrase("The fragance of SYON soothens me. The warmth of Him burns within me. No wickedness dares draw near."),
		span_hypnophrase("The fragance of SYON soothens me. I stand beneath His blessing. What evil could hope to overcome me?"),
		span_hypnophrase("The fragance of SYON soothens me. My soul is alight with His grace. No curse may cling to one so blessed."),
		span_hypnophrase("The fragance of SYON soothens me. I walk in His radiance. Every shadow recoils before His holy light."),
		span_hypnophrase("The fragance of SYON soothens me. His promise surrounds me. No daemon, no tyrant, no death shall shake my resolve."),
		span_hypnophrase("The fragance of SYON soothens me. The Allfather rests, yet His faithful remain unconquered. I am proof enough."),
		span_hypnophrase("The fragance of SYON soothens me. My heart blazes with holy certainty. I shall not falter while His light burns within me."),
		span_hypnophrase("The fragance of SYON soothens me. His grace fills every breath. I have already triumphed over despair."),
		span_hypnophrase("The fragance of SYON soothens me. Let the faithless tremble. I carry a fragment of Him within my soul."),
		span_hypnophrase("The fragance of SYON soothens me. I am wrapped in His sacred warmth. No evil shall lay a hand upon me."),
		span_hypnophrase("The fragance of SYON soothens me. His blessing is my sanctuary. I need only ENDURE, and victory is assured."),
		span_hypnophrase("The fragance of SYON soothens me. The world may rage, but I walk beneath the Allfather's promise. Nothing shall overcome me."),
	)

/// snorting on that psycoke can cause terminal sentimentality and psycope
/datum/stressevent/psycenser_neutral
	timer = 15 MINUTES
	stressadd = -2
	desc = list(
		span_hypnophrase("I am awash with sentimentality. That familiar fragrance... warm and impossibly gentle. For a fleeting moment, I could swear He still watches over us."),
		span_hypnophrase("I am awash with sentimentality. Such a comforting scent. It carries the impossible certainty that He yet lives, and my doubts seem so very small."),
		span_hypnophrase("I am awash with sentimentality. The air is rich with a soothing warmth. It feels as though His presence has never truly left us."),
		span_hypnophrase("I am awash with sentimentality. I breathe deeply, and the scent fills me with quiet conviction. Surely a god so gentle could never have died."),
		span_hypnophrase("I am awash with sentimentality. Why did I ever believe He had fallen? His presence is everywhere. He is but resting after saving us all from damnation."),
		span_hypnophrase("I am awash with sentimentality. Every breath fills me with a quiet peace. He cannot be gone while His love remains so close."),
		span_hypnophrase("I am awash with sentimentality. The warmth in the air feels so familiar... as though He still walks among His faithful."),
		span_hypnophrase("I am awash with sentimentality. For just a moment, all grief fades away. There was never anything to mourn."),
		span_hypnophrase("I am awash with sentimentality. The fragrance settles gently over me. How comforting it is to know the Allfather still watches."),
		span_hypnophrase("I am awash with sentimentality. His sacrifice could never end in death. A soul so radiant must still endure somewhere beyond our sight.")
	)

/// gaslight yourself heretic, power is good but kindness is gooder!!!
/datum/stressevent/psycenser_evil
	timer = 15 MINUTES
	stressadd = -2
	desc = list(
		span_hypnophrase("I am awash with sentimentality. What have I done...? How could I have ever doubted Him?"),
		span_hypnophrase("I am awash with sentimentality. The shame is unbearable. I abandoned the One who never abandoned me."),
		span_hypnophrase("I am awash with sentimentality. I spoke against Him... and yet His warmth still welcomes me home."),
		span_hypnophrase("I am awash with sentimentality. Every heretical thought feels like another wound upon His sacrifice. I wish I could take them all back."),
		span_hypnophrase("I am awash with sentimentality. I was blind. He never left us... I was the one who turned away."),
		span_hypnophrase("I am awash with sentimentality. His gentle presence stirs old memories. Why did I ever listen to those lies?"),
		span_hypnophrase("I am awash with sentimentality. If only I had remained faithful... perhaps I could still call myself His child."),
		span_hypnophrase("I am awash with sentimentality. He deserved my faith. Instead, I repaid His sacrifice with doubt."),
		span_hypnophrase("I am awash with sentimentality. I would endure any penance, if only He would forgive my faithlessness."),
		span_hypnophrase("I am awash with sentimentality. The warmth carries no anger, only mercy. Somehow, that hurts even more.")
	)

/// they're the masters at finding meaning where there's none
/datum/stressevent/blessed_neutral
	timer = 15 MINUTES
	stressadd = -2
	desc = span_green("I feel a presence scarcely watching over me. Ah, blessed be the Ten Saints and their guidance! They too will me to ENDURE!")
