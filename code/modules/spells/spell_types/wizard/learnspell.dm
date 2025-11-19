//A spell to choose new spells, upon spawning or gaining levels
// TODO: Implement per patron spell lists
/obj/effect/proc_holder/spell/self/learnspell
	name = "Attempt to learn a new spell"
	desc = "Weave a new spell"
	school = "transmutation"
	overlay_state = "book1"
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/self/learnspell/cast(list/targets, mob/user = usr)
	. = ..()
	//list of spells you can learn, it may be good to move this somewhere else eventually
	var/list/choices = list()

	var/user_spell_tier = get_user_spell_tier(user)

	// Checks if the learner is evil to determine if they can learn this spell or not. Used for unique zizo-related spells.
	var/user_evil = get_user_evilness(user)

	var/list/spell_choices = GLOB.learnable_spells

	for(var/i = 1, i <= spell_choices.len, i++)
		var/obj/effect/proc_holder/spell/spell_item = spell_choices[i]
		if(spell_item.spell_tier > user_spell_tier)
			continue
		if(spell_item.zizo_spell > user_evil)
			continue
		choices["[spell_item.name]: [spell_item.cost]"] = spell_item

	choices = sortList(choices)

	var/choice = input("Choose a spell, points left: [user.mind.spell_points - user.mind.used_spell_points]") as null|anything in choices
	var/obj/effect/proc_holder/spell/item = choices[choice]

	if(!item)
		return     // user canceled;
	if(alert(user, "[item.desc]", "[item.name]", "Learn", "Cancel") == "Cancel") //gives a preview of the spell's description to let people know what a spell does
		return
	for(var/obj/effect/proc_holder/spell/knownspell in user.mind.spell_list)
		if(knownspell.type == item.type)
			to_chat(user,span_warning("You already know this one!"))
			return	//already know the spell
	if(item.cost > user.mind.spell_points - user.mind.used_spell_points)
		to_chat(user,span_warning("You do not have enough experience to create a new spell."))
		return		// not enough spell points
	else
		user.mind.used_spell_points += item.cost
		var/obj/effect/proc_holder/spell/new_spell = new item
		new_spell.refundable = TRUE
		user.mind.AddSpell(new_spell)
		addtimer(CALLBACK(user.mind, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS) //self remove if no points
		return TRUE
