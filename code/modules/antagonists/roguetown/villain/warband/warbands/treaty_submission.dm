/obj/item/treaty/burn()
	// if(GLOB.tod == "dawn") FIXNOTE: uncommented 4 Ease Of Testing, don't leave this uncommented
	treaty_submission()

// uses the target name provided by the treaty to return a mob
/obj/item/treaty/proc/text_to_mob(target_name) 
	if(!target_name)
		return
	for(var/mob/living/found_mob in GLOB.player_list)
		if(found_mob.real_name == target_name)
			return found_mob
	return

// uses the target name provided by the treaty to return a faction
/obj/item/treaty/proc/text_to_faction(target_name)
	if(!target_name)
		return
	for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
		if(faction.name == target_name)
			return faction
	return

// uses the target name provided by the treaty to return a territory
/obj/item/treaty/proc/text_to_territory(territory_name)
	if(!territory_name)
		return
	for(var/datum/territory/land in SSwarbands.territory)
		if(land.name == territory_name)
			return land
	return

// when we edit or create a new term, we want to be absolutely sure it isn't a duplicate
/obj/item/treaty/proc/check_duplicate_term(datum/treaty/terms/new_term, skip_index) 
	for(var/i = 1 to src.active_terms.len) 
		if(skip_index && i == skip_index) // skip the term we're editing
			continue
			
		var/datum/treaty/terms/existing = src.active_terms[i]
		
		// same territory can't be ceded twice
		if(istype(new_term, /datum/treaty/terms/territory_loss) && istype(existing, /datum/treaty/terms/territory_loss))
			if(new_term.obj_target == existing.obj_target)
				return TRUE // return true on duplicate terms
		
		// same source+receiver combination can't exist twice
		else if(istype(new_term, /datum/treaty/terms/cointribute) && istype(existing, /datum/treaty/terms/cointribute))
			if(new_term.target == existing.target && new_term.receiver == existing.receiver)
				return TRUE
		
		// same person can't be exiled twice
		else if(istype(new_term, /datum/treaty/terms/exile) && istype(existing, /datum/treaty/terms/exile))
			if(new_term.target == existing.target)
				return TRUE
		
		// same law can't be abolished twice
		else if(istype(new_term, /datum/treaty/terms/remove_law) && istype(existing, /datum/treaty/terms/remove_law))
			if(new_term.number == existing.number)
				return TRUE
		
		// same law text can't be codified twice
		else if(istype(new_term, /datum/treaty/terms/codify_law) && istype(existing, /datum/treaty/terms/codify_law))
			if(new_term.text == existing.text)
				return TRUE
		
		// same tax category can't be adjusted twice
		else if(istype(new_term, /datum/treaty/terms/set_tax) && istype(existing, /datum/treaty/terms/set_tax))
			if(new_term.type == existing.type)
				return TRUE

		else if(istype(new_term, /datum/treaty/terms/unique/wizard) && istype(existing, /datum/treaty/terms/unique/wizard))
			if(new_term.type == existing.type)
				return TRUE
	
	return FALSE

/obj/item/treaty/proc/compare_law_terms_descending(datum/treaty/terms/remove_law/first_term, datum/treaty/terms/remove_law/second_term)
	return second_term.number - first_term.number

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// TREATY SUBMISSION
/*
	burning a Treaty at dawn will activate it
	every term loaded onto a treaty takes effect
	if a single term is unsigned, the entire treaty will fizzle out
*/
/obj/item/treaty/proc/treaty_submission()
	for(var/datum/treaty/terms/term in src.active_terms)
		if(!term.signed && term.name != "Freeform") // fail if anything (aside from a freeform term) is unsigned
			visible_message(span_warning("The treaty crumbles. One or more terms were unsigned."))
			SSwarbands.treaties -= src
			qdel(src)
			return FALSE

	visible_message(span_danger("The treaty evaporates in a flash of divine flame! Summer winds ferry its ashes to the heavens above."))
	var/list/law_changes = list()
	var/list/tax_changes = list()
	var/list/exile_announcements = list()
	
	// first, process any law removals
	// we need to process law removals in DESCENDING order to avoid index shifting conflicts
	var/list/law_removal_terms = list()
	for(var/datum/treaty/terms/term in src.active_terms)
		if(istype(term, /datum/treaty/terms/remove_law))
			law_removal_terms += term

	// sort by law number in descending order (highest first)
	law_removal_terms = sortTim(law_removal_terms, CALLBACK(src, PROC_REF(compare_law_terms_descending)))

	// process them from highest to lowest
	for(var/datum/treaty/terms/term in law_removal_terms)
		if(GLOB.laws_frozen)
			continue
		if(term.number in GLOB.codified_laws)
			continue
		if(term.number >= 1 && term.number <= length(GLOB.laws_of_the_land) && GLOB.laws_of_the_land[term.number])
			var/law_text = remove_law(term.number, silent = TRUE)
			if(law_text)
				law_changes += "Law [term.number] abolished: [law_text]"
		else
			visible_message(span_warning("...but one of the terms yet remains in the flame. It seems law [term.number] doesn't exist, and thus cannot be abolished."))
	
	// next, do everything else
	for(var/datum/treaty/terms/term in src.active_terms)
		// codify law
		if(istype(term, /datum/treaty/terms/codify_law))
			if(GLOB.laws_frozen)
				continue
			var/new_law_index = length(GLOB.laws_of_the_land) + 1
			make_law(term.text, silent = TRUE)
			GLOB.codified_laws += new_law_index
			law_changes += "Law [new_law_index] codified: [term.text]"
		
		// freeze laws
		else if(istype(term, /datum/treaty/terms/freeze_laws))
			GLOB.laws_frozen = TRUE
			law_changes += "In our ruler's infinite wisdom, all present laws have been frozen. So long as the Sun rises, no change shall be permitted."
		
		// tax terms
		else if(istype(term, /datum/treaty/terms/set_tax))
			var/category_name
			if(istype(term, /datum/treaty/terms/set_tax/noble))
				category_name = "Nobility"
			else if(istype(term, /datum/treaty/terms/set_tax/yeoman))
				category_name = "Yeomanry"
			else if(istype(term, /datum/treaty/terms/set_tax/peasant))
				category_name = "Peasantry"
			else if(istype(term, /datum/treaty/terms/set_tax/church))
				category_name = "Clergy"
			if(category_name)
				if(category_name in GLOB.locked_tax_categories)
					continue
				if(category_name in SStreasury.taxation_cat_settings)
					SStreasury.taxation_cat_settings[category_name]["taxAmount"] = term.number
					GLOB.locked_tax_categories += category_name
					tax_changes += "[category_name] tax set to [term.number]% and locked!"
					SStreasury.log_to_steward("[category_name] tax set to [term.number]% and locked, as demanded by a treaty.")

		// territory transfers
		else if(istype(term, /datum/treaty/terms/territory_loss))
			if(term.obj_target && term.receiver)
				var/datum/territory/estate = text_to_territory(term.obj_target)
				var/datum/territory_faction/new_faction = text_to_faction(term.receiver)
				
				if(!estate)
					visible_message(span_danger("...but one of the terms yet remains in the flame. It seems [term.obj_target] is owed elsewhere."))
					continue
				
				if(!new_faction)
					visible_message(span_danger("...but one of the terms yet remains in the flame. It seems [term.receiver] is too fractured to declare ownership of [term.obj_target]."))
					continue

				// take it from the old faction
				var/datum/territory_faction/old_faction = estate.associated_faction
				if(old_faction)
					old_faction.territories -= estate
				
				// give it to the new faction
				estate.associated_faction = new_faction
				if(!(estate in new_faction.territories))
					new_faction.territories += estate

		// coin transfers
		// note: coin transfers involving the duchy directly give or take from its treasury
		else if(istype(term, /datum/treaty/terms/cointribute))
			if(term.target && term.receiver && term.number)
				if(term.target == term.receiver)
					visible_message(span_danger("...but one of the terms yet remains in the flame. A faction cannot pay tribute to itself."))
					continue
					
				var/datum/territory_faction/source_faction = text_to_faction(term.target)
				var/datum/territory_faction/dest_faction = text_to_faction(term.receiver)
				
				if(!source_faction || !dest_faction)
					visible_message(span_danger("...but one of the terms yet remains in the flame. \
					A faction expected to be involved in tribute either dissolved before said tribute could be made, or never existed to begin with."))
					continue
	
				if(source_faction.name == "The Crown")
					if(SStreasury.treasury_value >= term.number)
						SStreasury.withdraw_money_treasury(term.number, "Treaty Tribute")
						if(dest_faction.name == "The Crown")
							SStreasury.give_money_treasury(term.number, "Treaty Tribute")
						else
							dest_faction.vault += term.number
					else
						var/amount_available = SStreasury.treasury_value
						var/deficit = term.number - amount_available
						SStreasury.withdraw_money_treasury(amount_available, "Treaty Tribute")
						if(dest_faction.name == "The Crown")
							SStreasury.give_money_treasury(amount_available, "Treaty Tribute")
						else
							dest_faction.vault += amount_available
						SStreasury.treasury_value = -deficit
						SStreasury.log_to_steward("-[deficit] deficit from excess Treaty demands.")
				else
					var/amount_to_transfer = max(0, source_faction.vault)
					if(dest_faction.name == "The Crown")
						SStreasury.give_money_treasury(amount_to_transfer, "Treaty Tribute")
					else
						dest_faction.vault += amount_to_transfer
					source_faction.vault -= term.number
		
		// exiles
		else if(istype(term, /datum/treaty/terms/exile))
			if(term.target)
				var/mob/living/exile = text_to_mob(term.target)
				if(exile)
					exile.AddComponent(/datum/component/sunlight_vulnerability/exile)
					exile_announcements += "[term.target] has been exiled from the city."
				else
					visible_message(span_danger("...but one of the terms yet remains in the flame. \
					It seems [term.target] has done you the favor of exiling themselves. Or perhaps, '[term.target]' never existed to begin with."))

		// wizard
		else if(istype(term, /datum/treaty/terms/unique/wizard))
			if(term.signatures.len)
				var/signatory_name = term.signatures[1]
				var/mob/living/subpar_mage = text_to_mob(signatory_name)
				if(subpar_mage)
					to_chat(subpar_mage, span_warning("I truly signed that? Yils of studies, and to what end? My heart sinks..."))
					subpar_mage.add_stress(/datum/stressevent/wizardterm)
					subpar_mage.playsound_local(subpar_mage, 'sound/ddstress.ogg', 100, FALSE)


	// final announcement
	if(law_changes.len || tax_changes.len)
		var/list/all_changes = list()
		if(law_changes.len)
			all_changes += law_changes
		if(tax_changes.len)
			all_changes += tax_changes
		if(exile_announcements.len)
			all_changes += exile_announcements
		var/full_announcement = all_changes.Join("\n")
		priority_announce(full_announcement, "AS DEMANDED BY TREATY", ('sound/misc/royal_decree.ogg'))
	check_treaty_objectives()	
	SSwarbands.treaties -= src
	src.moveToNullspace() // don't destroy it. send it into The Great Nowhere
	SSwarbands.submitted_treaties += src // for posterity
	return


/////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CHECK LIEUTENANT OBJECTIVES
/*
	objectiveslop
	if a treaty meets certain conditions for an antagonist, this Greentexts them
*/
/obj/item/treaty/proc/check_treaty_objectives()
	for(var/datum/treaty/terms/term in src.active_terms)
		if(term.author) // if something they wrote is submitted, the 'standard' objective is complete
			var/is_lieutenant = (term.author.special_role == "Lieutenant" || term.author.special_role == "Aspirant Lieutenant")
			var/is_warlord = (term.author.special_role == "Warlord")
			if(is_lieutenant)
				for(var/datum/objective/obj in term.author.get_all_objectives())
					if(istype(obj, /datum/objective/warband/aspirant/standard))
						obj.completed = TRUE
						to_chat(term.author.current, span_notice("One of my objectives has been fulfilled!"))
						break
			if(is_warlord)
				for(var/datum/objective/obj in term.author.get_all_objectives())
					if(istype(obj, /datum/objective/warband/warlord))
						obj.completed = TRUE
						to_chat(term.author.current, span_notice("My objective has been fulfilled!"))
						break
