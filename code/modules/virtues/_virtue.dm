GLOBAL_LIST_EMPTY(virtues)

/datum/virtue
	/// What the virtue's called.
	var/name
	/// A brief, in-character description of what the virtue does.
	var/desc
	/// Description for origins, allowed to be a bit wordy.
	var/origin_desc
	/// Name for origins - used for the nation's name, not a denonym!
	var/origin_name = "Unknown"
	/// A list containing any traits we need to add to the mob.
	var/list/added_traits = list()
	/// An associative list containing any skills we want to adjust. You can also pass list objects into this in the following format: list(SKILL_TYPE, SKILL_INCREASE, SKILL_MAXIMUM) as needed.
	var/list/added_skills = list()
	/// An associative list containing any items we want to add to our stash.
	var/list/added_stashed_items = list()
	/// A list containing any extra languages we need to add to the mob.
	var/list/added_languages = list()
	/// An associative list containing any extra stats we need to add to the mob. NOTE: virtues should GENERALLY NOT add stats unless they impose serious downsides.
	var/list/added_stats = list()
	/// Whether the virtue uses racial restrictions
	var/restricted = FALSE
	/// Whether the origin lets you choose a language freely.
	var/extra_language = FALSE
	/// For use in outfits applying origins.
	var/job_origin
	/// For use in outfits applying origins.
	var/datum/virtue/last_origin
	/// A list of races restricted.
	var/list/races = list()
	/// The cost of the virtue to apply in TRIUMPH points, if any.
	var/triumph_cost = 0
	/// A custom addendum that explains what the virtue does outside of the traits / skill adjustments.
	var/custom_text
	// If a virtue hits the soft cap we give them a 1 skill point boost
	var/softcap = FALSE
	/// Whether a virtue should show up in regular selection
	var/unlisted = FALSE
	/// Whether the virtue is only available as a second virtue choice (so only available to virtuous / fated)
	var/virtuous_only = FALSE

	///The max amount of choices we can make. choice_costs must have a length that matches or exceeds this.
	var/max_choices = 0

	///The actual choices, should not be shorter in length than max_choices.
	var/list/extra_choices = list()

	///A dynamic list that we actually add and remove to. This is the key part that is saved / loaded.
	var/list/picked_choices = list()

	///The costs of each choice. Should match max_choices in length, "free" entries should just have a cost of 0.
	///IE list(0, 0, 3) -> 2 free choices, 3rd choice costs 3 TRI
	var/list/choice_costs = list()

	///Tooltips that will appear as a (?) next to the option, to explain what they do. Will look for matching indeces from extra_choice list.
	var/list/choice_tooltips = list()

	/// Whether we can have multiple of the same virtue. Be very aware of what exactly the virtue does / how many options it allows for this to make sense.
	var/stackable = FALSE

/datum/virtue/New()
	. = ..()
	if (triumph_cost)
		desc += " <b>Costs [triumph_cost] TRIUMPH[triumph_cost?"S":""].</b>"
	
	if(max_choices || length(extra_choices) || length(choice_costs) || length(choice_tooltips))
		if(max_choices > length(extra_choices))
			CRASH("[src] has fewer extra_choices than there can be max_choices! Very bad!")
		if(max_choices > length(choice_costs))
			CRASH("[src] has more max choices than there are cost entries. Very bad! We can't pay 'null' triumphs!")
		if(length(choice_tooltips) > length(extra_choices))
			CRASH("[src] has more tooltips than there are extra_choices. A deleted extra_choice entry was likely not cleaned up properly.")

/datum/virtue/proc/on_load()
	return

/datum/virtue/proc/triumph_check(mob/living/carbon/human/recipient)
	if(length(extra_choices))
		var/total_cost
		for(var/i in 1 to length(picked_choices))
			if(choice_costs[i] > 0)
				total_cost += choice_costs[i]
		if(recipient.get_triumphs() > total_cost)
			recipient.adjust_triumphs(-total_cost)
		else
			to_chat(recipient, span_notice("Not enough Triumphs for a virtue. It has not been applied."))
			return FALSE
	for(var/choice in picked_choices)
		record_featured_object_stat(FEATURED_STATS_SUBVIRTUES, choice)
	return TRUE

/datum/virtue/proc/apply_to_human(mob/living/carbon/human/recipient)
	return

/datum/virtue/proc/handle_traits(mob/living/carbon/human/recipient)
	if (!LAZYLEN(added_traits))
		return
	for(var/trait in added_traits)
		ADD_TRAIT(recipient, trait, TRAIT_VIRTUE)

/datum/virtue/proc/handle_skills(mob/living/carbon/human/recipient)
	if (!recipient?.mind || !LAZYLEN(added_skills))
		return

	for (var/entry in added_skills)
		var/datum/skill/S
		var/inc
		var/max = null

		if (islist(entry))
			S   = entry[1]
			inc = entry[2]
			max = entry[3]
		else
			S   = entry
			inc = added_skills[entry]

		if (!S || !inc)
			continue

		var/current = recipient.get_skill_level(S)
		var/increase_amount = 0
		var/virtue_limit = 6
		if (max)
			virtue_limit = min(max, 6)

		if (current < virtue_limit)
			var/space_left = virtue_limit - current
			increase_amount = min(inc, space_left)

		if (increase_amount == 0 && softcap && current < 6)
			increase_amount = 1

		if (increase_amount == 0)

			to_chat(recipient, span_notice("My Virtue cannot influence my skill with [lowertext(S.name)] any further."))
		else
			recipient.adjust_skillrank(S.type, increase_amount, TRUE)

			if (increase_amount == 1 && max && current >= max)
				to_chat(recipient, span_notice("My Virtue can only minorly influence my skill with [lowertext(S.name)]."))

/datum/virtue/proc/handle_stashed_items(mob/living/carbon/human/recipient)
	if (!recipient.mind || !LAZYLEN(added_stashed_items))
		return
	for(var/stashed_item in added_stashed_items)
		recipient.mind?.special_items[stashed_item] = added_stashed_items[stashed_item]

/datum/virtue/proc/handle_added_languages(mob/living/carbon/human/recipient)
	if (!LAZYLEN(added_languages))
		return

	for (var/language in added_languages)
		recipient.grant_language(language)

/datum/virtue/proc/handle_stats(mob/living/carbon/human/recipient)
	if (!LAZYLEN(added_stats))
		return

	for (var/stat in added_stats)
		var/value = added_stats[stat]
		recipient.change_stat(stat, value)

/datum/virtue/proc/check_triumphs(mob/living/carbon/human/recipient)
	if (!triumph_cost)
		return TRUE

	if (!recipient.mind)
		return FALSE

	// we should check to see if they have triumphs first but i can't be fucked
	recipient.adjust_triumphs(-triumph_cost, FALSE)
	return TRUE

/proc/apply_virtue(mob/living/carbon/human/recipient, datum/virtue/virtue_type)
	if (!virtue_type.check_triumphs(recipient))
		return
	virtue_type.apply_to_human(recipient)
	virtue_type.handle_traits(recipient)
	virtue_type.handle_skills(recipient)
	virtue_type.handle_stashed_items(recipient)
	virtue_type.handle_added_languages(recipient)
	virtue_type.handle_stats(recipient)
	if(HAS_TRAIT(recipient, TRAIT_RESIDENT))
		if(SStreasury.has_account(recipient))
			SStreasury.generate_money_account(20, recipient)
		else
			SStreasury.create_bank_account(recipient, 20)
	if(virtue_type.unlisted)
		return
	if(istype(virtue_type, /datum/virtue/origin))
		record_featured_object_stat(FEATURED_STATS_ORIGINS, virtue_type.name)
	else
		var/stacked = FALSE
		if(istype(recipient.client?.prefs?.virtue, recipient.client?.prefs?.virtuetwo))
			stacked = TRUE
		record_featured_object_stat(FEATURED_STATS_VIRTUES, (stacked ? "[virtue_type.name] (Stacked)" : virtue_type.name), stacked ? 0.5 : 1)
/datum/virtue/none
	name = "None"
	desc = "Without virtue."
