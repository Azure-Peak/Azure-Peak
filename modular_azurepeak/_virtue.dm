GLOBAL_LIST_EMPTY(virtues)

/datum/virtue
	/// What the virtue's called.
	var/name
	/// A brief, in-character description of what the virtue does.
	var/desc
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
	/// The cost of the virtue to apply in TRIUMPH points, if any.
	var/triumph_cost = 0
	/// A custom addendum that explains what the virtue does outside of the traits / skill adjustments.
	var/custom_text
	//if a virtue hits the soft cap we give them a 1 skill point boost
	var/softcap = FALSE

/datum/virtue/New()
	. = ..()
	if (triumph_cost)
		desc += "<b>Costs [triumph_cost] TRIUMPH.</b>"

/datum/virtue/proc/apply_to_human(mob/living/carbon/human/recipient)
	return

/datum/virtue/proc/handle_traits(mob/living/carbon/human/recipient)
	if (!LAZYLEN(added_traits))
		return
	for(var/trait in added_traits)
		ADD_TRAIT(recipient, trait, TRAIT_VIRTUE)

/datum/virtue/proc/handle_skills(mob/living/carbon/human/recipient)
	if (!recipient.mind || !LAZYLEN(added_skills))
		return
	for(var/skill in added_skills)
		if (!islist(skill))
			recipient.adjust_skillrank(skill, added_skills[skill], TRUE)
		else
			var/list/skill_block = skill
			var/datum/skill/the_skill = skill_block[1]
			var/increase_by = skill_block[2]
			var/maximum_skill = skill_block[3]
			var/our_skill = recipient.get_skill_level(the_skill)
			if (our_skill < maximum_skill)
				if ((our_skill + increase_by) > maximum_skill) // we'll be pushing it higher than our max with 1 addition, so lower increase_by
					increase_by = (maximum_skill - our_skill)
				recipient.adjust_skillrank(the_skill.type, increase_by, TRUE)
			else if (softcap) //
				increase_by = 1
				if ((our_skill + increase_by) > 6) // we can't go above legendary
					increase_by = (maximum_skill - our_skill)
				recipient.adjust_skillrank(the_skill.type, increase_by, TRUE)
				to_chat(recipient, span_notice("My Virtue can only minorly influence my skill with [lowertext(the_skill.name)]."))
			else
				to_chat(recipient, span_notice("My Virtue cannot influence my skill with [lowertext(the_skill.name)] any further."))
				

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
		if(recipient in SStreasury.bank_accounts)
			SStreasury.generate_money_account(20, recipient)
		else
			SStreasury.create_bank_account(recipient, 20)
	record_featured_object_stat(FEATURED_STATS_VIRTUES, virtue_type.name)
/datum/virtue/none
	name = "None"
	desc = "Without virtue."
