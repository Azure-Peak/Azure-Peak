/datum/stressevent/psyprayer
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("The Gods smile upon me.")

/datum/stressevent/seeblessed
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("Regular visits to Church center my spirit.")

/datum/stressevent/viewsinpunish
	timer = 5 MINUTES
	stressadd = -2
	desc = span_green("I saw a sinner get punished!")

/datum/stressevent/joke
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("I heard a good joke.")

/datum/stressevent/tragedy
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("Life isn't so bad after all.")

/datum/stressevent/blessed
	timer = 60 MINUTES
	stressadd = -2
	desc = span_green("I feel a soothing presence.")

/datum/stressevent/triumph
	timer = 10 MINUTES
	stressadd = -5
	desc = span_boldgreen("I remember a TRIUMPH.")

/datum/stressevent/drunk
	timer = 1 MINUTES
	stressadd = -2
	desc = list(span_green("Alcohol eases the pain."),span_green("Alcohol, my true friend."))

/datum/stressevent/pweed
	timer = 1 MINUTES
	stressadd = -2
	desc = list(span_green("A relaxing smoke."),span_green("A flavorful smoke."))

/datum/stressevent/weed
	timer = 5 MINUTES
	stressadd = -4
	desc = span_blue("I love you sweet leaf.")

/datum/stressevent/high
	timer = 5 MINUTES
	stressadd = -4
	desc = span_blue("I'm so high, don't take away my sky.")

/datum/stressevent/stuffed
	timer = 20 MINUTES
	stressadd = -1
	desc = span_green("I'm stuffed! Feels good.")

/datum/stressevent/goodsnack
	timer = 8 MINUTES
	stressadd = -1
	desc = list(span_green("That snack tastes pretty good"), span_green("Tasty snack."))

/datum/stressevent/greatsnack
	timer = 10 MINUTES
	stressadd = -2
	desc = list(span_green("That snack was amazing! Can't wait for the next."), span_green("Great snack! I should get another one later."))

/datum/stressevent/goodmeal
	timer = 10 MINUTES
	stressadd = -1
	desc = list(span_green("That meal wasn't half bad"), span_green("A decent meal, finally"))

/datum/stressevent/greatmeal
	timer = 15 MINUTES
	stressadd = -2
	desc = list(span_green("That meal tasted great!"), span_green("I ate like a noble, it was great!"))

/datum/stressevent/sweet
	timer = 8 MINUTES
	stressadd = -2
	desc = list(span_green("Sweets always bring your spirits up"), span_green("Sweet embrace"))

/datum/stressevent/hydrated
	timer = 10 MINUTES
	stressadd = -1
	desc = span_green("My thirst is quenched. Invigorating.")

/datum/stressevent/prebel
	timer = 5 MINUTES
	stressadd = -5
	desc = span_boldgreen("Down with the tyranny!")

/datum/stressevent/music
	timer = 1 MINUTES
	stressadd = -1
	desc = span_green("This music is relaxing.")

/datum/stressevent/music/two
	stressadd = -2
	desc = span_green("This music is very relaxing.")
	timer = 2 MINUTES

/datum/stressevent/music/three
	stressadd = -2
	desc = span_green("This music drains away my stress.")
	timer = 4 MINUTES

/datum/stressevent/music/four
	stressadd = -3
	desc = span_green("This music is great.")
	timer = 6 MINUTES

/datum/stressevent/music/five
	stressadd = -3
	timer = 8 MINUTES
	desc = span_green("This music is wonderful!")

/datum/stressevent/music/six
	stressadd = -4
	timer = 10 MINUTES
	desc = span_boldgreen("This music is exceptional!")

/datum/stressevent/vblood
	stressadd = -5
	desc = span_boldred("Virgin blood!")
	timer = 5 MINUTES

/datum/stressevent/bathwater
	stressadd = -1
	desc = span_blue("Relaxing.")
	timer = 1 MINUTES

/datum/stressevent/bathwater/on_apply(mob/living/user)
	. = ..()
	if(user.client)
		record_round_statistic(STATS_BATHS_TAKEN)
		// SEND_SIGNAL(user, COMSIG_BATH_TAKEN)

/datum/stressevent/beautiful
	stressadd = -2
	desc = span_green("Their face is a work of art!")
	timer = 2 MINUTES

/datum/stressevent/night_owl
	stressadd = -3
	desc = span_green("The night is so relaxing and peaceful.")
	timer = 20 MINUTES

/datum/stressevent/ozium
	stressadd = -99
	desc = span_blue("I've taken a hit and entered a painless world.")
	timer = 2 MINUTES

/datum/stressevent/moondust
	stressadd = -6
	desc = span_boldgreen("Moondust surges through me.")
	timer = 4 MINUTES

/datum/stressevent/starsugar
	stressadd = -1
	desc = span_boldgreen("My heart rushes, my blood runs, I feel tightly bound together. I could run a marathon.")
	timer = 4 MINUTES

/datum/stressevent/moondust_purest
	stressadd = -8
	desc = span_boldgreen("PURE moondust surges through me!")
	timer = 4 MINUTES

/datum/stressevent/campfire
	stressadd = -1
	desc = span_green("The warmth of the fire is comforting.")
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
	desc = span_boldgreen("I solved an extremely difficult puzzle. Xylix is smiling at me, and surely even Noc must find it impressive.")
	timer = 15 MINUTES

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
	desc = span_green("I had my favourite drink!")
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
	desc = span_red("I had to eat my most hated food!")
	timer = 10 MINUTES

/datum/stressevent/hated_food/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_event(/datum/stressevent/hated_food))
		return FALSE

/datum/stressevent/hated_drink
	stressadd = 1
	desc = span_red("I had to consume my most hated drink!")
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
	desc = span_green("Someone showed me the respect I deserve as a noble.")

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
	desc = span_green("I have prevailed over my rival! Graggar favours me now!")
	timer = INFINITY

/datum/stressevent/eoran_blessing
	stressadd = -1
	desc = span_info("An Eoran shone their brightness upon me.")
	timer = 5 MINUTES

/datum/stressevent/eoran_blessing_greater
	stressadd = -2
	desc = span_info("A Devout Eoran shone their brightness upon me.")
	timer = 10 MINUTES

/datum/stressevent/sermon
	stressadd = -5
	desc = span_green("I feel inspired by the sermon.")
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
	desc = span_green("That fermented crab was not the most pleasant dish ever, but youthful vigor in my body was worth the sacrifice!")
	timer = 3 MINUTES

/datum/stressevent/vampiric_nostalgia
	stressadd = -2
	desc = span_green("Astrata and her gaze may burn you now, but you distantly remember when it was pleasant to your skin.")
	timer = 20 SECONDS

/datum/stressevent/xylixian_fate
	timer = 10 MINUTES
	stressadd = -2
	desc = span_green("Xylix spun the thread of fate in my favour! Truly, I am blessed!")
