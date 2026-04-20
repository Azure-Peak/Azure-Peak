#define CHOICE_POISON_BLADE "poison & knife"
#define CHOICE_SKILLS "skills"
#define CHOICE_SWORDSMANSHIP "swordsmanship"
#define CHOICE_MONEY "money"

/datum/antagonist/aspirant
	name = "Aspirant"
	roundend_category = "aspirant"
	antagpanel_category = "Aspirant"
	job_rank = ROLE_ASPIRANT
	show_in_roundend = FALSE
	confess_lines = list(
		"THE CHOSEN MUST TAKE THE THRONE!",
	)
	increase_votepwr = FALSE
	rogue_enabled = TRUE
	antag_flags = FLAG_FAKE_ANTAG

	var/static/list/equipment_selection = list(
		"Cloak & Dagger (Poison & Knife)" = CHOICE_POISON_BLADE,
		"Mace & Lockpicking Skill" = CHOICE_SKILLS,
		"Swordsmanship" = CHOICE_SWORDSMANSHIP,
		"Deep Pockets (Extra Money)" = CHOICE_MONEY,
	)
	has_tempo = TRUE

/datum/antagonist/aspirant/proc/give_equipment_prompt()
	var/chosen = input(owner.current, "How shall I rise to power?", "YOUR ADVANTAGE") as anything in equipment_selection
	var/mob/aspirant_mob = owner.current
	chosen = LAZYACCESS(equipment_selection, chosen)
	// Every Aspirant gets bribe money regardless of choice
	owner.special_items["War Chest"] = /obj/item/storage/belt/rogue/pouch/coins/aspirantpouch
	owner.special_items["Slush Fund"] = /obj/item/storage/belt/rogue/pouch/coins/aspirantpouch
	switch(chosen)
		if(CHOICE_POISON_BLADE)
			owner.special_items["Poison"] = /obj/item/reagent_containers/glass/bottle/rogue/poison
			owner.special_items["Killer's Knife"] = /obj/item/rogueweapon/huntingknife/idagger/steel/corroded
			aspirant_mob.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
		if(CHOICE_SKILLS)
			owner.special_items["Mace"] = /obj/item/rogueweapon/mace/cudgel
			owner.special_items["Chains"] = /obj/item/rope/chain
			owner.special_items["Lockpicks"] = /obj/item/lockpickring/mundane
			aspirant_mob.adjust_skillrank_up_to(/datum/skill/combat/maces, 5)
			aspirant_mob.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 5)
		if(CHOICE_SWORDSMANSHIP)
			var/static/list/swordsmanship_flavors = list(
				"I have become a master of Contemporary Grenzelhoftian Swordsmanship, having studied the original copy of Emich von Apfelweinheim's 1491 Manual - all seven volumes.",
				"I have travelled to the city-state of Szöréndnížina, duelling a thousand times until I have mastered their unique art of swordplay.",
				"While others studied stewardship, I studied the blade under the watchful gaze of a Lingyuese swordmaster in the bamboo forest of the east.",
			)
			aspirant_mob.adjust_skillrank_up_to(/datum/skill/combat/swords, 5)
			to_chat(owner, span_notice(pick(swordsmanship_flavors)))
		if(CHOICE_MONEY)
			var/static/list/money_flavors = list(
				"I have persuaded a mysterious hooded Lirvassian Drakian to fund my rise to power in exchange for an undisclosed favor. Oh, let the mammons rain!",
				"I have received a massive windfall from betting against the price of tulip bulbs against the Etruscan Trading Company. The people love a savvy investor, and I have the cash to prove it.",
				"I have received a hefty inheritance after the mysterious and unexplained death of one of my distant relatives in Otava. The vineyard was sold for a large sum, and I have the money to fund my ambitions.",
			)
			owner.special_items["Savvy Investment"] = /obj/item/storage/belt/rogue/pouch/coins/bigandfat
			owner.special_items["Ill-Gotten Gains"] = /obj/item/storage/belt/rogue/pouch/coins/bigandfat
			to_chat(owner, span_notice(pick(money_flavors)))
	to_chat(owner, span_notice("I can retrieve my items from a statue, tree or clock by right clicking it."))


/datum/antagonist/aspirant/supporter
	name = "Supporter"

/datum/antagonist/aspirant/ruler
	name = "Ruler"

/datum/antagonist/aspirant/greet()
	to_chat(owner, span_danger("I have grown weary of being near the throne, but never on it. It is time to seize destiny in myne own hands."))
	..()

/datum/antagonist/aspirant/supporter/greet()
	var/aspirant_name = "an Aspirant"
	var/aspirant_job = ""
	for(var/datum/mind/aspirant_mind in SSmapping.retainer.aspirants)
		if(aspirant_mind.special_role == "Aspirant")
			aspirant_name = aspirant_mind.current?.real_name || "an Aspirant"
			aspirant_job = aspirant_mind.assigned_role ? " the [aspirant_mind.assigned_role]" : ""
			break
	to_chat(owner, span_danger("Long live the [SSticker.rulertype]! But not this one. I have been approached by [aspirant_name][aspirant_job] and swayed to their cause. I must ensure they take the throne."))

/datum/antagonist/aspirant/supporter/can_be_owned(datum/mind/new_owner)
	return TRUE // Supporters can be any role — skip the eligible positions check

/datum/antagonist/aspirant/ruler/can_be_owned(datum/mind/new_owner)
	return TRUE // Rulers can be any role — skip the eligible positions check

/datum/antagonist/aspirant/ruler/greet() // No alert for the ruler to always keep them guessing.

/datum/antagonist/aspirant/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		if(!((new_owner.assigned_role in GLOB.aspirant_eligible_positions)))
			return FALSE

/datum/antagonist/aspirant/on_gain()
	. = ..()
	owner.special_role = ROLE_ASPIRANT
	SSmapping.retainer.aspirants |= owner
	// Only the lead Aspirant gets equipment — not supporters or the ruler
	if(!istype(src, /datum/antagonist/aspirant/supporter) && !istype(src, /datum/antagonist/aspirant/ruler))
		addtimer(CALLBACK(src, PROC_REF(give_equipment_prompt)), 5 SECONDS)
	create_objectives()
	if(istype(src, /datum/antagonist/aspirant/ruler))
		return
	greet()
	owner.announce_objectives()

/datum/antagonist/aspirant/on_removal()
	remove_objectives()
	. = ..()

/datum/antagonist/aspirant/proc/create_objectives()
	if(istype(src, /datum/antagonist/aspirant/ruler))
		var/datum/objective/aspirant/loyal/one/G = new
		objectives += G
		return
	if(istype(src, /datum/antagonist/aspirant/supporter))
		var/datum/objective/aspirant/coup/three/G = new
		objectives += G
		for(var/datum/mind/aspirant in SSmapping.retainer.aspirants)
			if(aspirant.special_role == "Aspirant")
				G.aspirant = aspirant.current
				var/aspirant_name = aspirant.current?.real_name || "the Aspirant"
				var/aspirant_job = aspirant.assigned_role ? ", the [aspirant.assigned_role]" : ""
				G.explanation_text = "I must ensure that [aspirant_name][aspirant_job] takes the throne."
		return
	else
		var/datum/objective/aspirant/coup/one/G = new
		objectives += G
		if(prob(50))
			var/datum/objective/aspirant/coup/two/M = new
			objectives += M
			M.initialruler = SSticker.rulermob


/datum/antagonist/aspirant/proc/remove_objectives()

// OBJECTIVES
/datum/objective/aspirant/coup/one
	name = "Aspirant"
	explanation_text = "I must ensure that I am crowned as the Grand Duke."
	triumph_count = 5

/datum/objective/aspirant/coup/one/check_completion()
	if(!owner?.current || !SSticker.rulermob)
		return FALSE
	return owner.current == SSticker.rulermob

/datum/objective/aspirant/coup/two
	name = "Moral"
	explanation_text = "I am no kinslayer, I must make sure that the Grand Duke doesn't die."
	triumph_count = 10
	var/initialruler

/datum/objective/aspirant/coup/three
	name = "Hopeful"
	explanation_text = "I must ensure that the Aspirant takes the throne."
	var/aspirant

/datum/objective/aspirant/coup/two/check_completion()
	var/mob/living/carbon/human/kin = initialruler
	if(!initialruler)
		return FALSE
	if(!kin.stat)
		return TRUE
	else return FALSE

/datum/objective/aspirant/loyal/one
	name = "Ruler"
	explanation_text = "I must remain Grand Duke."
	triumph_count = 3

/datum/objective/aspirant/loyal/one/check_completion()
	if(!owner?.current || !SSticker.rulermob)
		return FALSE
	return owner.current == SSticker.rulermob

/datum/antagonist/aspirant/roundend_report()
	to_chat(world, span_header(" * [name] * "))

	if(objectives.len)
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(world, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
				owner.adjust_triumphs(objective.triumph_count)
			else
				to_chat(world, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>FAIL.</span>")
				win = FALSE
			objective_count++
		if(win)
			to_chat(world, span_greentext("The Aspirant has ascended! SUCCESS!"))
		else
			to_chat(world, span_redtext("The Aspirant was thwarted! FAIL!"))

/datum/antagonist/aspirant/ruler/roundend_report()
	to_chat(owner, span_header(" * [name] * "))

	if(objectives.len)
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(owner, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
				owner.adjust_triumphs(objective.triumph_count)
			else
				to_chat(owner, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>FAIL.</span>")
				win = FALSE
			objective_count++
		if(win)
			to_chat(owner, span_greentext("You defended your throne! SUCCESS!"))
		else
			to_chat(owner, span_redtext("You were deposed! FAIL!"))

/datum/antagonist/aspirant/supporter/roundend_report()
	to_chat(owner, span_header(" * [name] * "))

	if(objectives.len)
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(owner, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
				owner.adjust_triumphs(objective.triumph_count)
			else
				to_chat(owner, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>FAIL.</span>")
				win = FALSE
			objective_count++
		if(win)
			to_chat(owner, span_greentext("Your claimant took the throne! SUCCESS!"))
		else
			to_chat(owner, span_redtext("Your claimant failed! FAIL!"))

#undef CHOICE_POISON_BLADE
#undef CHOICE_SKILLS
#undef CHOICE_SWORDSMANSHIP
#undef CHOICE_MONEY
