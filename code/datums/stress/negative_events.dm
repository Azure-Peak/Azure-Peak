/datum/stressevent/vice
	timer = 5 MINUTES
	stressadd = 5
	desc = list(span_boldred("I don't indulge my vice."),span_boldred("I need to sate my vice."))

/datum/stressevent/miasmagas
	timer = 10 SECONDS
	stressadd = 2
	desc = span_red("It smells like death here.")

/datum/stressevent/peckish
	timer = 10 MINUTES
	stressadd = 1
	desc = span_red("I'm peckish.")

/datum/stressevent/hungry
	timer = 10 MINUTES
	stressadd = 3
	desc = span_red("I'm hungry.")

/datum/stressevent/starving
	timer = 10 MINUTES
	stressadd = 5
	desc = span_boldred("I'm starving.")

/datum/stressevent/drym
	timer = 10 MINUTES
	stressadd = 1
	desc = span_red("I'm a little thirsty.")

/datum/stressevent/thirst
	timer = 10 MINUTES
	stressadd = 3
	desc = span_red("I'm thirsty.")

/datum/stressevent/parched
	timer = 10 MINUTES
	stressadd = 5
	desc = span_boldred("I'm going to die of thirst!")

/datum/stressevent/dismembered
	timer = 40 MINUTES
	stressadd = 5
	desc = span_boldred("I've lost a limb!")

/datum/stressevent/dwarfshaved
	timer = 40 MINUTES
	stressadd = 6
	desc = span_boldred("I'd rather have cut my own throat than my beard! This is an outrage!")

/datum/stressevent/viewdismember
	timer = 15 MINUTES
	max_stacks = 5
	stressadd = 2
	stressadd_per_extra_stack = 2
	desc = span_red("I witnessed someone's dismemberment. What a terrible sight!")

/datum/stressevent/fviewdismember
	timer = 1 MINUTES
	max_stacks = 10
	stressadd = 1
	stressadd_per_extra_stack = 1
	desc = span_red("I saw something horrible!")

/datum/stressevent/viewgib
	timer = 5 MINUTES
	stressadd = 2
	desc = span_red("I saw something ghastly.")

/datum/stressevent/bleeding
	timer = 2 MINUTES
	stressadd = 2
	desc = list(span_red("I think I'm bleeding."),span_red("I'm bleeding."))

/datum/stressevent/bleeding/can_apply(mob/living/user)
	if(user.has_flaw(/datum/charflaw/addiction/masochist))
		return FALSE
	return TRUE

/datum/stressevent/painmax
	timer = 1 MINUTES
	stressadd = 2
	desc = span_red("THE PAIN!")

/datum/stressevent/painmax/can_apply(mob/living/user)
	if(user.has_flaw(/datum/charflaw/addiction/masochist))
		return FALSE
	return TRUE

/datum/stressevent/freakout
	timer = 15 SECONDS
	stressadd = 2
	desc = span_red("I'm panicking!")

/datum/stressevent/felldown
	timer = 1 MINUTES
	stressadd = 1
	desc = span_red("I fell. I'm a fool.")

/datum/stressevent/burntmeal
	timer = 2 MINUTES
	stressadd = 2
	desc = span_red("YUCK!")

/datum/stressevent/rotfood
	timer = 2 MINUTES
	stressadd = 4
	desc = span_red("YUCK!")

/datum/stressevent/psycurse
	timer = 5 MINUTES
	stressadd = 5
	desc = span_boldred("Oh no! I've received divine punishment!")

/datum/stressevent/virginchurch
	timer = 999 MINUTES
	stressadd = 10
	desc = span_boldred("I have broken my oath of chastity to the Gods!")

/datum/stressevent/badmeal
	timer = 3 MINUTES
	stressadd = 2
	desc = span_red("That tasted VILE!")

/datum/stressevent/vomit
	timer = 3 MINUTES
	stressadd = 2
	max_stacks = 3
	stressadd_per_extra_stack = 2
	desc = span_red("I puked!")

/datum/stressevent/vomitself
	timer = 3 MINUTES
	stressadd = 2
	max_stacks = 3
	stressadd_per_extra_stack = 2
	desc = span_red("I puked on myself!")

/datum/stressevent/vomitother
	timer = 3 MINUTES
	stressadd = 3
	max_stacks = 3
	stressadd_per_extra_stack = 3
	desc = span_red("Someone puked on me! Gross!")

/datum/stressevent/vomitedonother
	timer = 3 MINUTES
	stressadd = 2
	max_stacks = 3
	stressadd_per_extra_stack = 2
	desc = span_red("I puked on someone!")

/datum/stressevent/paracrowd
	timer = 2 MINUTES
	stressadd = 3
	desc = span_red("There's too many strangers here. Where are my own people?")

/datum/stressevent/parablood
	timer = 15 SECONDS
	stressadd = 3
	desc = span_red("There is far too much blood here! Iron stings my nostrils!")

/datum/stressevent/parastr
	timer = 2 MINUTES
	stressadd = 2
	desc = span_red("That beast there is stronger than I, and could quite easily kill me...")

/datum/stressevent/paratalk
	timer = 2 MINUTES
	stressadd = 2
	desc = span_red("They are plotting against me in evil tongues...")

/datum/stressevent/crowd
	timer = 2 MINUTES
	stressadd = 3
	desc = span_red("There's too many people here. It's making me nervous.")

/datum/stressevent/averse
	timer = 5 MINUTES
	stressadd = 5
	desc = span_red("<u>They</u> are here.")

/datum/stressevent/nocrowd
	timer = 2 MINUTES
	stressadd = 3
	desc = span_red("There's nobody here. It's making me nervous...")

/datum/stressevent/lonely_one
	timer = 2 MINUTES
	stressadd = 3
	desc = span_red("I'm lonely. I need to see another face.")

/datum/stressevent/lonely_two
	timer = 4 MINUTES
	stressadd = 5
	desc = span_red("Am I truly alone? They abandoned me...")

/datum/stressevent/lonely_three
	timer = 6 MINUTES
	stressadd = 7
	desc = span_red("Please! Anyone! I just need anyone! The thoughts are coming back...")

/datum/stressevent/lonely_max
	timer = 10 MINUTES
	stressadd = 15
	desc = span_red("I'm worthless. I'm abandoned. Nobody likes me. Nobody wants to be around me. \
	Nobody. Nobody. Nobody. Nobody.")

/datum/stressevent/nopeople
	timer = 3 MINUTES
	stressadd = 3
	desc = span_red("Why is everyone so far away?! Come closer! I don't bite!")

/datum/stressevent/jesterphobia
	timer = 4 MINUTES
	stressadd = 5
	desc = span_boldred("No! Get the Jester away from me!")

/datum/stressevent/coldhead
	timer = 60 SECONDS
	stressadd = 1
	desc = span_red("My head and neck feel uncomfortably cold.")

/datum/stressevent/sleepytime
	timer = 40 MINUTES
	stressadd = 2
	desc = span_red("I'm tired.")

/datum/stressevent/tortured
	stressadd = 3
	max_stacks = 5
	stressadd_per_extra_stack = 2
	desc = span_boldred("I'm broken.")
	timer = 60 SECONDS

/datum/stressevent/tortured/on_apply(mob/living/user)
	. = ..()
	if(user.client)
		record_round_statistic(STATS_TORTURES)

/datum/stressevent/confessed
	stressadd = 3
	desc = span_red("I've confessed to my sins.")
	timer = 15 MINUTES

/datum/stressevent/confessedgood
	stressadd = 1
	desc = span_red("I've confessed to my sins. Perhaps my path to redemption begins here?")
	timer = 15 MINUTES

/datum/stressevent/saw_wonder
	stressadd = 4
	desc = span_boldred("<B>I have seen something nightmarish, and I fear for my life!</B>")
	timer = 999 MINUTES

/datum/stressevent/maniac_woke_up
	stressadd = 10
	desc = span_boldred("No! I want to go back...")
	timer = 999 MINUTES

/datum/stressevent/drankrat
	stressadd = 1
	desc = span_red("I drank from a lesser creature. Stale, mindless blood laps at my tongue.")
	timer = 1 MINUTES

/datum/stressevent/oziumoff
	stressadd = 10
	desc = span_blue("I need another hit.")
	timer = 1 MINUTES

/datum/stressevent/puzzle_fail
	stressadd = 1
	desc = list(span_red("I wasted my time on that foolish box."),span_red("Damned jester-box."))
	timer = 5 MINUTES

/datum/stressevent/noble_impoverished_food
	stressadd = 2
	desc = span_boldred("This is disgusting. How can anyone eat this?")
	timer = 10 MINUTES

/datum/stressevent/noble_desperate
	stressadd = 6
	desc = span_boldred("What level of desperation have I fallen to that I would eat such a thing?")
	timer = 60 MINUTES

/datum/stressevent/noble_bland_food
	stressadd = 1
	desc = span_red("This fare is really beneath me. I deserve better than this...")
	timer = 5 MINUTES

/datum/stressevent/noble_bad_manners
	stressadd = 1
	desc = span_red("It would have been more proper to have used a spoon, there. I hope \
	my fellows do not think less of me...")
	timer = 5 MINUTES

/datum/stressevent/noble_ate_without_table
	stressadd = 1
	desc = span_red("Eating such a meal without a table? How churlish!")
	timer = 2 MINUTES

/datum/stressevent/graggar_culling_unfinished
	stressadd = 1
	desc = span_red("I must eat my opponent's heart before they eat MINE!")
	timer = INFINITY

/datum/stressevent/soulchurnerhorror
	timer = 10 SECONDS
	stressadd = 50
	desc = span_red("The horrid wails of the dead call for relief! WHAT HAVE I DONE?!")

/datum/stressevent/soulchurner
	timer = 1 MINUTES
	stressadd = 30
	desc = span_red("The horrid wails of the dead call for relief!")

/datum/stressevent/soulchurnerpsydon
	timer = 1 MINUTES
	stressadd = 1
	desc = span_red("The horrid wails of the dead call for relief! I can ENDURE such calls...")

/datum/stressevent/sewertouched
	timer = 5 MINUTES
	stressadd = 2
	desc = span_red("Putrid stinking water!")

/datum/stressevent/unseemly
	stressadd = 3
	desc = span_red("Their face is unbearable!")
	timer = 3 MINUTES

/datum/stressevent/leprosy
	stressadd = 1
	desc = span_red("A disgusting leper. Better keep my distance.")
	timer = 3 MINUTES

/datum/stressevent/uncanny
	stressadd = 2
	desc = span_red("Their face is somehow wrong...")
	timer = 3 MINUTES

/datum/stressevent/syoncalamity
	stressadd = 15
	desc = span_boldred("By Psydon, the great comet's shard is no more! What will we do now!?")
	timer = 15 MINUTES

/datum/stressevent/hithead
	timer = 2 MINUTES
	stressadd = 2
	desc = span_red("Oww, my head...")

/datum/stressevent/psycurse
	stressadd = 3
	desc = span_boldred("Oh no! I've received divine punishment!")
	timer = 999 MINUTES

/datum/stressevent/excommunicated
	stressadd = 5
	desc = span_boldred("The Ten have forsaken me!")
	timer = 999 MINUTES

/datum/stressevent/apostasy
	stressadd = 3
	desc = span_boldred("The apostasy's mark is upon me!")
	timer = 999 MINUTES

/datum/stressevent/heretic_on_sermon
	stressadd = 5
	desc = span_red("My PATRON is NOT PROUD of ME!")
	timer = 20 MINUTES

/datum/stressevent/lostchampion
	stressadd = 8
	desc = span_red("I feel I have lost my champion! Oh, my stricken heart!")
	timer = 25 MINUTES

/datum/stressevent/lostward
	stressadd = 8
	desc = span_red("I have failed my ward! My ribbon fades in color!")
	timer = 25 MINUTES

/datum/stressevent/necrarevive
	stressadd = 15
	desc = span_boldred("SO CLOSE TO BEING GRASPED, SO COLD!")
	timer = 15 MINUTES

/datum/stressevent/blessed_weapon
	stressadd = -3
	timer = 999 MINUTES
	desc = span_green("I'm wielding a BLESSED weapon!")

/datum/stressevent/naledimasklost
	stressadd = 3
	desc = span_boldred("I have lost my mask! Anyone here could be a djinn! I'm dangerously exposed!")
	timer = 999 MINUTES

/datum/stressevent/shamanhoodlost
	stressadd = 3
	desc = span_boldred("I have lost my hood! My faith wavers without it. I feel ashamed.")
	timer = 999 MINUTES

/datum/stressevent/dungeoneerhoodlost
	stressadd = 3
	desc = span_boldred("I have lost my hood! It's not right. I feel ashamed.")
	timer = 999 MINUTES

/datum/stressevent/headless
	stressadd = 3
	desc = span_red("Where is their head? What is that flame?!")
	timer = 5 MINUTES

/datum/stressevent/hunted // When a hunted character sees someone in a mask
	timer = 2 MINUTES
	stressadd = 3
	desc = span_boldred("I can't see their face! Have they found me? Is this the end?")

/datum/stressevent/profane // When a non-assassin touches a profane dagger
	timer = 3 MINUTES
	stressadd = 4
	desc = span_boldred("I hear the voices of the damned from this cursed blade!")

/datum/stressevent/fermented_crab_bad
	stressadd = 2
	desc = span_red("That fermented crab was truly rancid, abhorrent and disgusting.")
	timer = 3 MINUTES

/datum/stressevent/vampiric_reality
	stressadd = 3
	desc = span_boldred("The holy sun returns, and it's only a matter of time until I turn to ash. I wish \
	to be mortal again.")
	timer = 30 SECONDS

/datum/stressevent/dimwitted
	timer = 10 MINUTES
	stressadd = -4
	desc = span_green("Everything is nice and simple...")

/datum/stressevent/feebleminded
	timer = 10 MINUTES
	stressadd = -10
	desc = span_green("Heeh...")

/datum/stressevent/arcane_high
	timer = 10 MINUTES
	stressadd = -2
	desc = span_green("Since my magical accident, everything just seems so funny!")

/datum/stressevent/archivist_shushed
	timer = 1 MINUTES
	stressadd = 4
	desc = span_red("I was shushed by the archivist!")

// this generally only happens if you're below 10 FOR, this is a little nudge to work on your luck stat
/datum/stressevent/xylixian_pity
	timer = 5 MINUTES
	stressadd = 1
	desc = span_red("Xylix took pity upon me and saved me from the consequences of bad luck. I must do better!")

/datum/stressevent/debt
	timer = 25 MINUTES
	stressadd = 3
	desc = span_red("I couldn't pay my debts in time.")

/datum/stressevent/revenant_cross // When a revenant looks at a necran cross that's blessed.
	timer = 2 MINUTES
	stressadd = 3
	desc = span_boldred("The undermaiden is watching me with disgust!")

/datum/stressevent/something_stirs // Psydonites can pray in blood rain. For a price.
	timer = 5 MINUTES
	stressadd = 4
	desc = span_boldred("I feel watched... did something *hear* me?")
