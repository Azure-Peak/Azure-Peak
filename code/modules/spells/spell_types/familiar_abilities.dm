/datum/action/cooldown/spell/message_familiar
	name = "Message Familiar"
	desc = "Whisper a message in your Familiar's head."
	button_icon_state = "message"

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/message_familiar/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	var/mob/living/simple_animal/pet/familiar/familiar
	for(var/mob/living/simple_animal/pet/familiar/familiar_check in GLOB.player_list)
		if(familiar_check.familiar_summoner == user)
			familiar = familiar_check
	if(!familiar || !familiar.mind)
		to_chat(user, "You cannot sense your familiar's mind.")
		return FALSE
	var/message = input(user, "You make a connection. What are you trying to say?")
	if(!message)
		return FALSE
	to_chat_immediate(familiar, "Arcane whispers fill the back of my head, resolving into [user]'s voice: <font color=#7246ff>[message]</font>")
	user.visible_message("[user] mutters an incantation and their mouth briefly flashes white.")
	user.whisper(message)
	log_game("[key_name(user)] sent a message to [key_name(familiar)] with contents [message]")
	return TRUE

/datum/action/cooldown/spell/message_summoner
	name = "Message Summoner"
	desc = "Whisper a message in your Summoner's head."
	button_icon_state = "message"

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/message_summoner/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/pet/familiar/user = owner
	if(!istype(user))
		return FALSE

	var/mob/living/summoner = user.familiar_summoner

	if(!summoner || !isliving(summoner) || !summoner.mind)
		to_chat(user, span_warning("You cannot sense your summoner's mind."))
		return FALSE

	var/message = input(user, "You make a connection. What are you trying to say?")
	if(!message)
		return FALSE
	to_chat_immediate(summoner, "Arcane whispers fill the back of my head, resolving into [user.real_name]'s voice: <font color=#7246ff>[message]</font>")
	user.visible_message("[user.name] mutters an incantation and their mouth briefly flashes white.")
	user.whisper(message)
	log_game("[key_name(user)] sent a message to [key_name(summoner)] with contents [message]")
	return TRUE

/obj/effect/proc_holder/spell/invoked/reagent_bite
	name = "Alchemical Bite" // placeholder
	desc = "Bite a target, delivering a 5-dram dose of whatever is in your stomach."
	range = 1
	recharge_time = 10 SECONDS

/obj/effect/proc_holder/spell/invoked/reagent_bite/cast(list/targets, mob/living/simple_animal/pet/familiar/fae/user)
	. = ..()
	if(!user) // literally how
		revert_cast()
		return FALSE
	if(!targets.len || !(isliving(targets[1]) || targets[1].is_refillable()) || !targets[1].reagents)
		to_chat(user, span_notice("I need to select a valid target to bite!"))
		revert_cast()
		return FALSE
	if(!user.reagents || user.reagents.total_volume == 0)
		to_chat(user, span_notice("I need to have a potion in my stomach to inject!"))
		revert_cast()
		return FALSE
	if(!isliving(targets[1]))
		user.visible_message(
			span_notice("[user.name] gently bites the top of [targets[1]], filling it with an alchemical cocktail..."),
			span_notice("You gently bite the top of [targets[1]], filling it with your alchemical cocktail...")
		)
		// we're not biting a mob, so we can loop for convenience 
		while(do_after_mob(user, targets, 1 SECONDS) && user.reagents.trans_to(targets[1], 5, transfered_by = user))
			user.visible_message(
				span_notice("[user.name] fills [targets[1]] with more of [user.p_their()] alchemical cocktail..."),
				span_notice("You fill [targets[1]] with more of your alchemical cocktail...")
			)
		user.visible_message(
			span_notice("[user.name] lets go of [targets[1]]."),
			span_notice("You let go of [targets[1]].")
		)
		return TRUE
	var/mob/living/target = targets[1]
	user.visible_message(
		span_notice("[user.name] attempts to bite [target.name]!"),
		span_notice("You attempt to bite [target.name]...")
	)
	if(do_after_mob(user, target, time = 1 SECONDS) && user.reagents.trans_to(target, 5, transfered_by = user))
		user.visible_message(
			span_notice("[user.name] bites [target.name], delivering a dose of an alchemical cocktail!"),
			span_notice("You bite [target.name], delivering a dose of your alchemical cocktail!")
		)
		return TRUE

/obj/effect/proc_holder/spell/invoked/incendiary_bite
	name = "Incendiary Bite"
	desc = "Bite a target, engulfing them in infernal flame."
	range = 1
	recharge_time = 10 SECONDS

/obj/effect/proc_holder/spell/invoked/incendiary_bite/cast(list/targets, mob/living/simple_animal/pet/familiar/fae/user)
	. = ..()
	if(!user) // literally how
		revert_cast()
		return FALSE
	if(!targets.len)
		to_chat(user, span_notice("I need to select a valid target to bite!"))
		revert_cast()
		return FALSE
	targets[1].fire_act(1,10) // shouldn't be oppressive by any means it's 1 stack every 10 seconds

/obj/effect/proc_holder/spell/self/infernal_surge
	name = "Infernal Surge"
	desc = "Let loose the flame of the hells in a small radius around you."
	recharge_time = 15 SECONDS

/obj/effect/proc_holder/spell/self/infernal_surge/cast(list/targets, mob/user)
	. = ..()
	var/turf/center = user.loc
	for(var/turf/T in range(1, center)) // 2  turned out to be too much lol
		new /obj/effect/hotspot(T, null, null, 10)
		new /obj/effect/temp_visual/fire(T)

/datum/action/cooldown/spell/arcyne_forge/elemental
	name = "Earthen Forge"
	desc = "Shape a tool of your choice out of raw earth. Limited selection. Conjured items have halved durability.\n\
	Only one conjured item can exist at a time - conjuring a new one destroys the old."
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z
	conjure_options = list(
		"Dagger" = /obj/item/rogueweapon/huntingknife/idagger,
		"Axe" = /obj/item/rogueweapon/stoneaxe/woodcut,
		// Tools
		"Pickaxe" = /obj/item/rogueweapon/pick,
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Thresher" = /obj/item/rogueweapon/thresher,
		"Sickle" = /obj/item/rogueweapon/sickle,
		"Pitchfork" = /obj/item/rogueweapon/pitchfork,
		"Tongs" = /obj/item/rogueweapon/tongs,
		"Shovel" = /obj/item/rogueweapon/shovel,
		"Handsaw" = /obj/item/rogueweapon/handsaw,
		"Fishing Rod" = /obj/item/fishingrod,
		"Frying Pan" = /obj/item/cooking/pan,
		"Pot" = /obj/item/reagent_containers/glass/bucket/pot,
		"Bowl" = /obj/item/reagent_containers/glass/bowl,
		"Fork" = /obj/item/kitchen/fork/iron,
		"Spoon" = /obj/item/kitchen/spoon/iron,
	)

/datum/action/cooldown/spell/arcyne_forge/elemental/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/pet/familiar/elemental/H = owner
	if(!istype(H))
		return FALSE

	var/choice = tgui_input_list(H, "Choose what to conjure", "Earthen Forge", conjure_options)
	if(!choice)
		return FALSE

	// Destroy previous conjured item
	if(conjured_item && !QDELETED(conjured_item))
		conjured_item.visible_message(span_warning("[conjured_item] shimmers and fades away!"))
		qdel(conjured_item)

	var/item_path = conjure_options[choice]
	var/obj/item/R = new item_path(H.drop_location())

	// Halve durability
	R.max_integrity = round(R.max_integrity * 0.5)
	R.obj_integrity = R.max_integrity

	// Mark as conjured — no salvage, no smelting
	R.smeltresult = null
	R.salvage_result = null
	R.fiber_salvage = FALSE

	// Conjured glow
	R.AddComponent(/datum/component/conjured_item, GLOW_COLOR_EARTHEN)

	H.put_in_hands(R)
	conjured_item = R
	return TRUE

// the difference is that this one can conjure hammers and needles to repair your gear, as well as weapons
/datum/action/cooldown/spell/arcyne_forge/elemental/t2
	name = "Greater Earthen Shaping"
	desc = "Shape a weapon or tool of your choice out of raw earth. Conjured items have halved durability.\n\
	Only one conjured item can exist at a time - conjuring a new one destroys the old."
	conjure_options = list(
		// Weapons
		"Short Sword" = /obj/item/rogueweapon/sword/short/iron,
		"Hunting Sword" = /obj/item/rogueweapon/sword/short/messer/iron,
		"Arming Sword" = /obj/item/rogueweapon/sword/iron,
		"Cudgel" = /obj/item/rogueweapon/mace/cudgel,
		"Warhammer" = /obj/item/rogueweapon/mace/warhammer,
		"Dagger" = /obj/item/rogueweapon/huntingknife/idagger,
		"Axe" = /obj/item/rogueweapon/stoneaxe/woodcut,
		"Flail" = /obj/item/rogueweapon/flail,
		"Whip" = /obj/item/rogueweapon/whip,
		"Wooden Shield" = /obj/item/rogueweapon/shield/wood,
		// Tools
		"Pickaxe" = /obj/item/rogueweapon/pick,
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Thresher" = /obj/item/rogueweapon/thresher,
		"Sickle" = /obj/item/rogueweapon/sickle,
		"Pitchfork" = /obj/item/rogueweapon/pitchfork,
		"Tongs" = /obj/item/rogueweapon/tongs,
		"Hammer" = /obj/item/rogueweapon/hammer/iron,
		"Shovel" = /obj/item/rogueweapon/shovel,
		"Handsaw" = /obj/item/rogueweapon/handsaw,
		"Fishing Rod" = /obj/item/fishingrod,
		"Frying Pan" = /obj/item/cooking/pan,
		"Pot" = /obj/item/reagent_containers/glass/bucket/pot,
		"Bowl" = /obj/item/reagent_containers/glass/bowl,
		"Fork" = /obj/item/kitchen/fork/iron,
		"Spoon" = /obj/item/kitchen/spoon/iron,
		"Needle" = /obj/item/needle/thorn
	)
