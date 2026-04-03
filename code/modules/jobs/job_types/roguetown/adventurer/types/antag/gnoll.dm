/datum/job/roguetown/gnoll
	title = "Gnoll"
	flag = GNOLL
	department_flag = ANTAGONIST
	antag_job = TRUE // whoever wrote this, I'm- gghrhhah!
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	allowed_races = RACES_SHUNNED_UP
	tutorial = "You have proven yourself worthy to Graggar, and he's granted you his blessing most divine. Now you hunt for worthy opponents, seeking out those strong enough to make you bleed."
	outfit = null
	outfit_female = null
	display_order = JDO_GNOLL
	show_in_credits = TRUE
	min_pq = 10
	max_pq = null
	storyteller_antag_flags = STORYTELLER_ANTAG_SOFT
	storyteller_favor_flags = STORYTELLER_FAVOR_GNOLL
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
	virtue_restrictions = list(
		/datum/virtue/utility/noble,
		/datum/virtue/combat/dualwielder, //Claws are too powerful, abusable
		/datum/virtue/combat/combat_virtue, //They do not need shield skills or anything in here
		/datum/virtue/utility/notable, //No resident (????) or free-money-stash gnolls
		/datum/virtue/utility/bronzelimbs, //They should feel pain in their limbs given their state
		/datum/virtue/movement/acrobatic, //This should be given to them when they are actually after a Hunted
		/datum/virtue/utility/woodwalker, //This should be given to them when they are actually after a Hunted
		/datum/virtue/combat/crossbowman,	//Absolutely not on a class like this
		/datum/virtue/combat/bowman
		)
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

		if(SSgamemode.story_antag_slot_cap(/datum/antagonist/gnoll, TRUE) > 1)
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

/proc/gnollslot_calc(override_player_count)
	var/list/result = list()
	var/player_count = override_player_count || length(GLOB.joined_player_list)
	result["player_count"] = player_count
	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	var/roundstart = !(SSticker?.HasRoundStarted())
	if(SSgamemode.storyteller_blocks_antag(gnoll_job?.storyteller_antag_flags, roundstart, storyteller_midround_antag_flags = gnoll_job?.storyteller_midround_antag_flags) || SSgamemode.storyteller_blocks_type(gnoll_job?.storyteller_favor_flags, roundstart = roundstart))
		result["max_slots"] = 0
		result["final_slots"] = 0
		return result
	if(!SSgamemode.storyteller_unlocks_scaled_antag_slots(/datum/antagonist/gnoll))
		result["max_slots"] = 0
		result["final_slots"] = 0
		return result
	var/max_slots = SSgamemode.story_antag_slot_cap(/datum/antagonist/gnoll, roundstart)
	result["max_slots"] = max_slots
	result["garrison"] = SSgamemode.garrison
	result["holy_warrior"] = SSgamemode.holy_warrior
	result["acolyte"] = SSgamemode.half_combatant
	result["combat_total"] = SSgamemode.story_combat_pop()
	result["final_slots"] = SSgamemode.story_antag_slots(SSgamemode.storyteller_scale_slots(max_slots, player_count, TRUE, SSgamemode.story_antag_scaling_step(/datum/antagonist/gnoll), SSgamemode.story_antag_min_players(/datum/antagonist/gnoll)), /datum/antagonist/gnoll, player_count)
	return result

/proc/gnollslot_update(override_player_count)
	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	if(!gnoll_job)
		return
	var/list/scaling = gnollslot_calc(override_player_count)
	var/player_count = scaling["player_count"]
	var/slots = max(0, scaling["final_slots"])
	var/old_total = gnoll_job.total_positions
	var/final_slots = max(gnoll_job.current_positions, slots)
	gnoll_job.total_positions = final_slots
	gnoll_job.spawn_positions = final_slots
	SSgamemode.log_antag_slot_scaling("Gnolls", old_total, final_slots, player_count, SSticker?.HasRoundStarted() ? "live slot update" : "roundstart slot update")
	if(!SSticker?.HasRoundStarted() || final_slots <= old_total)
		return
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player.client)
			to_chat(player, span_alert("Graggar demands blood, gnolls flock to Azuria."))

/mob/living/carbon/human/proc/gnoll_inspect_skin()
	set name = "Inspect Pelt"
	set category = "Gnoll"
	set desc = "Examine your gnoll skin armor"
	if(!istype(skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor))
		to_chat(src, span_warning("You don't have any gnoll skin armor to inspect!"))
		return
	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/GA = skin_armor
	GA.Topic(null, list("inspect" = "1"), src)
