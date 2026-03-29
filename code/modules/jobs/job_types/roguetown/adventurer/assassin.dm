// This is the loadout datum for the actual equipment behind the assassin antag. 
// TL;DR: you get both the benefits of the assassin antag datum and this loadout. Why? I dont know.
/datum/job/roguetown/assassin
	title = "Assassin"
	flag = ASSASSIN
	department_flag = ANTAGONIST
	selection_color = JCOLOR_ANTAGONIST
	faction = "Station"
	total_positions = 1 // debug
	spawn_positions = 0
	min_pq = 10		// was going to put this higher but realized bandit's only 3 pq and wretch is fucking 10 so whatever
	max_pq = null
	antag_job = TRUE
	allowed_races = RACES_ALL_KINDS
	tutorial = "\"...about time.\", your dagger whispers. The gleaming steel shimmers beautifully in the light-- amythortz inlaid prepared to trap another soul within. Be swift. Be deadly. Use the environment to your advantage. They can't kill what they can't catch. \
	You are an apex predator."

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE
	give_bank_account = FALSE

	display_order = JDO_ASSASSIN
	announce_latejoin = FALSE
	round_contrib_points = 5

	advclass_cat_rolls = list(CTAG_ASSASSIN = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = FALSE	//We don't want anyone knowing what type of assassin you are.
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE

	// Base job traits, we give one-specialty trait per role.
	job_traits = list(
		// no_stink granted by antag datum
		TRAIT_ASSASSIN, // ditto
		TRAIT_DODGEEXPERT, // ditto
		TRAIT_STEELHEARTED, // ditto
		TRAIT_HERESIARCH,	//Just so they can use the Zurch.
		TRAIT_ANTISCRYING,
		// if everything goes well, they'll gain more traits by killing.
	)
	cmode_music = 'sound/music/cmode/antag/combat_assassin.ogg'
	// TODO:
	// SUBCLASS REDESIGNS

	// ASSASSIN -- MAINSTAY
	// GET DECENT DAGGER SKILL, DECENT CROSSBOW SKILL, HIGH CLIMBING, WHATEVER.
	// LOWER STATS AND WHATNOT.
	// CHOICES: SLURBOW(?), POISON, MAYBE ACTUALLY AN ENCHANTED SCROLL OF SOME KIND TO APPLY TO DAGGER OR BACKPACK

	// FACELESS -- EQUIVALENT OF PUTTING ON THE VALID ARMOR
	// POTENTIALLY, NAB SPRITES/ARMOR FROM VANDERLIN/CRE. NOT SURE IF I NEED PERM FOR THAT KIND OF THING.
	// AS YOU HAVE PUT ON [THE VALID] AND ARE PERMANENTLY EVIL. IDK. GIVE THEM BETTER STATS I GUESS.
	// ENSURE NAME DOES NOT GET PICKED IN THE PICK NAME DOOHICKEY.

	// OTHERS? FRANKLY ASSSASSIN DOESNT REALLY *NEED* SUBCLASSES BEYOND THAT. VANDERLIN'S WAY OF DOING IT CAUSED THEM
	// TO JOIN UP AS DISGUISED XYZ BUT HONESTLY A TOWNER HERE IS MORE SUSPICIOUS THAN A GUY IN ALL BLACK AND LEATHER SOO...

	// FETCH LAUGH FROM:
	// https://github.com/Darkrp-community/OpenKeep
	job_subclasses = list(
		/datum/advclass/assassin/
	)

/datum/outfit/job/roguetown/assassin
	var/static/alist/disguises = alist(
	"Naked" = /datum/outfit/job/roguetown/assassin/assassin_disguise,
	"Assassin" = /datum/outfit/job/roguetown/assassin/assassin_disguise/assassin,
	"Beggar" = /datum/outfit/job/roguetown/assassin/assassin_disguise/beggar,
	)

/datum/job/roguetown/assassin/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.ambushable = FALSE

/datum/outfit/job/roguetown/assassin/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/assassin()
		H.mind.add_antag_datum(new_antag)
		H.grant_language(/datum/language/thievescant)
		// TODO: grant name IF not faceless
