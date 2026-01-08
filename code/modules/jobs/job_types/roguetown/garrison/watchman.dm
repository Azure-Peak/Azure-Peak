/datum/job/roguetown/watchman //This exists PURELY so the convert verb has something TO convert to
	title = "Watchman"
	flag = WATCHMAN
	department_flag = GARRISON
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES // same as town guard
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	tutorial = "Responsible for the safety of the town and the enforcement of the Grand Duke's law, you are the vanguard of the city faced with punishing those who defy his Royal Majesty. Though you've many lords to obey, as both the Church and the Bailiff have great sway over your life."
	display_order = JDO_WATCHMAN
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/watchman
	advclass_cat_rolls = list(CTAG_WATCH = 20)

	give_bank_account = 16
	min_pq = 1 //Introductory guard role, but still requires knowledge of escalation.
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/combat_ManAtArms.ogg'

/datum/outfit/job/roguetown/watchman
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/watchman/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/stabard/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "watchman tabard ([index])"

/datum/outfit/job/roguetown/watchman
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/tabard/stabard/guard
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shoes = /obj/item/clothing/shoes/roguetown/boots
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	belt = /obj/item/storage/belt/rogue/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers		//Would seperate to leather bracers for archer for dodge but - funnily, armor class doesn't exist on bracers.
	backr = /obj/item/storage/backpack/rogue/satchel/black
