//A skill to help hunters scare away woodland threats
/obj/effect/proc_holder/spell/invoked/huntersyell
	name = "Hunter's Yell"
	desc = "I yell out, driving away forest animals! This won't work on more intelligent creachers."
	overlay_state = "tamebeast"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 17 MINUTES //useful for driving away beasts but can't be spammed or over used, more of an emergency skill
	antimagic_allowed = TRUE
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg' //I'd like a shout of some kind to add here.
	range = 5
	var/scareable_factions = list("saiga", "chickens", "cows", "goats", "wolfs", "spiders", "rats", "fae", "trolls")

/obj/effect/proc_holder/spell/invoked/huntersyell/cast(list/targets, mob/living/user)
	. = ..()
	visible_message(span_green("[usr] lets out a mighty yelp, driving away nearby animals!"))
	var/scared = FALSE
	for(var/mob/living/simple_animal/hostile/retaliate/animal in get_hearers_in_view(7, usr))
		//if((animal.mob_biotypes & MOB_UNDEAD))
		//	continue
		if(faction_check(animal.faction, scareable_factions))
			animal.aggressive = FALSE
			if(animal.ai_controller)
				animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
				animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
				animal.ai_controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, TRUE)
				animal.ai_controller.set_blackboard_key(BB_BASIC_MOB_NEXT_FLEEING, world.time + 10 SECONDS)
			user.emote("warcry")
			to_chat(usr, "The [animal.name] flees from your bellow!")
	return scared
