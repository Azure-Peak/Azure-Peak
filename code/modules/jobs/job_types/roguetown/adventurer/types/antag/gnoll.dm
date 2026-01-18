/datum/job/roguetown/gnoll
	title = "Gnoll"
	flag = GNOLL
	department_flag = ANTAGONIST
	antag_job = TRUE // whoever wrote this, I'm- gghrhhah!
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = RACES_NO_CONSTRUCT
	tutorial = "You have proven yourself worthy to Graggar, and he's granted you his blessing most divine. Now you hunt for worthy opponents, seeking out those strong enough to make you bleed."
	outfit = null
	outfit_female = null
	display_order = JDO_GNOLL
	show_in_credits = TRUE
	min_pq = 10
	max_pq = null
	allowed_patrons = list(/datum/patron/inhumen/graggar)

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_GNOLL = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/utility/noble) //Are you for real?
	job_subclasses = list(
		/datum/advclass/gnoll/berserker,
		/datum/advclass/gnoll/knight,
		/datum/advclass/gnoll/templar,
		/datum/advclass/gnoll/shaman,
	)

/datum/job/roguetown/gnoll/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Assign wretch antagonist datum so wretches appear in antag list
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/gnoll))
			var/datum/antagonist/new_antag = new /datum/antagonist/gnoll()
			H.mind.add_antag_datum(new_antag)
			H.verbs |= /mob/living/carbon/human/proc/gnoll_inspect_skin

/datum/outfit/job/roguetown/gnoll/proc/don_pelt(mob/living/carbon/human/H)
	if(H.mind)
		var/pelts = list("firepelt", "rotpelt", "whitepelt", "bloodpelt", "nightpelt", "darkpelt")
		var/pelt_choice = input(H, "Choose your pelt.", "SPILL THEIR ENTRAILS.") as anything in pelts
		H.set_blindness(0)
		H.icon_state = "[pelt_choice]"
		H.dna?.species?.custom_base_icon = "[pelt_choice]"
		H.regenerate_icons()
		H.AddSpell(new /obj/effect/proc_holder/spell/self/claws/gnoll)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/howl/gnoll)
		H.AddComponent(/datum/component/gnoll_combat_tracker)

		var/obj/effect/proc_holder/spell/invoked/gnoll_sniff/F = new()
		var/obj/effect/proc_holder/spell/invoked/invisibility/gnoll/I = new()
		I.sniff_spell = F // Link them

		var/obj/effect/proc_holder/spell/invoked/abduct/S = new /obj/effect/proc_holder/spell/invoked/abduct()
		S.destination_turf = get_turf(H) // Set the anchor to where they spawn/don the outfit
		H.AddSpell(S)
		H.AddSpell(F)
		H.AddSpell(I)

		var/mode = get_gnoll_scaling()
		if(mode == GNOLL_SCALING_DYNAMIC)
			to_chat(H, span_bignotice("I can expect to be joined by my pack this week. I should wait for them and group up."))
		else
			to_chat(H, span_bignotice("Isolated from my pack, I am likely a lone soul this week. I should especially avoid getting killed, and look for my pack next week."))
		to_chat(H, span_bignotice("Graggar is patient, and values good strategy. I mustn't be hasty, especially if my marks prove difficult to isolate.\n Perhaps there is merit in forging alliances, or setting up camp."))
		spawn(50)
			var/name_choice = alert(H, "What name do you want?", "MY NAME IS [H.real_name]", "Pick New Name", "Random Gnoll Name", "Keep Current Name")
			switch(name_choice)
				if("Pick New Name")
					H.choose_name_popup("GNOLL")
					to_chat(H, span_notice("Your name is now [H.real_name]."))
				if("Random Gnoll Name")
					H.real_name = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"
					to_chat(H, span_notice("Your name is now [H.real_name]."))
				if("Keep Current Name")
					to_chat(H, span_notice("You keep your name as [H.real_name]."))

/mob/living/carbon/human/proc/gnoll_inspect_skin()
	set name = "Inspect Pelt"
	set category = "Gnoll"
	set desc = "Examine your gnoll skin armor"
	if(!istype(skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor))
		to_chat(src, span_warning("You don't have any gnoll skin armor to inspect!"))
		return
	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/GA = skin_armor
	GA.Topic(null, list("inspect" = "1"), src)
