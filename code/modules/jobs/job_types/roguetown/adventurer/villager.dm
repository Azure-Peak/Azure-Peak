/datum/job/roguetown/villager
	title = "Towner"
	flag = VILLAGER
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 75
	spawn_positions = 75
	allowed_races = ACCEPTED_RACES
	tutorial = "You've lived in this shithole for effectively all your life. You are not an explorer, nor exactly a warrior in many cases. You're just some average poor bastard who thinks they'll be something someday. Respect the nobles and yeomen alike for they are your superiors - should you find yourself in trouble your Elder is your best hope."
	advclass_cat_rolls = list(CTAG_TOWNER = 20)
	outfit = null
	outfit_female = null
	bypass_lastclass = TRUE
	bypass_jobban = FALSE
	display_order = JDO_VILLAGER
	give_bank_account = TRUE
	min_pq = -15
	max_pq = null
	round_contrib_points = 2
	wanderer_examine = FALSE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	same_job_respawn_delay = 0
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'
	job_subclasses = list(
		/datum/advclass/barbersurgeon,
		/datum/advclass/blacksmith,
		/datum/advclass/cheesemaker,
		/datum/advclass/drunkard,
		/datum/advclass/fisher,
		/datum/advclass/homesteader,
		/datum/advclass/hunter,
		/datum/advclass/hunter/spear,
		/datum/advclass/miner,
		/datum/advclass/minstrel,
		/datum/advclass/peasant,
		/datum/advclass/potter,
		/datum/advclass/seamstress,
		/datum/advclass/thug,
		/datum/advclass/witch,
		/datum/advclass/woodworker
	)
