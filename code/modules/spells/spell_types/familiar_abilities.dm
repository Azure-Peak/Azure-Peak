/datum/action/cooldown/spell/message_familiar
	name = "Message Familiar"
	desc = "Whisper a message in your Familiar's head, or track their vestige if they lie slain."
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
	if(familiar.health<=0)
		// they're dead; track the vestige
		return track_vestige(user,familiar)
	var/message = input(user, "You make a connection. What are you trying to say?")
	if(!message)
		return FALSE
	to_chat_immediate(familiar, "Arcane whispers fill the back of my head, resolving into [user]'s voice: <font color=#7246ff>[message]</font>")
	user.visible_message("[user] mutters an incantation and their mouth briefly flashes white.")
	user.whisper(message, language = /datum/language/common)
	log_game("[key_name(user)] sent a message to [key_name(familiar)] with contents [message]")
	return TRUE

/datum/action/cooldown/spell/message_familiar/proc/track_vestige(mob/living/user, mob/living/simple_animal/pet/familiar/fam)
	user.visible_message(span_notice("[user] closes [user.p_their()] eyes and reaches out through the veil..."), span_notice("I close my eyes and attune to the flow of the veil..."))
	if(!do_after(user, 2 SECONDS, target = user))
		to_chat(user, span_warning("Your concentration breaks."))
		return FALSE

	var/user_z = user.z
	var/obj/item/magic/familiar_vestige/vestige = fam.loc
	if(!istype(vestige))
		to_chat(user, span_warning("The familiar is not within their vestige. This should not happen!"))
	var/dist = get_dist(user, vestige)
	var/direction = dir2text(get_dir(user, vestige))
	var/same_z = vestige.z==user.z
	if(!direction)
		direction = "beneath you"
	else
		direction = "to the [direction]"
	if(!same_z)
		if(vestige.z > user_z)
			direction += ", above you"
		else
			direction += ", below you"
	if(dist <= 3)
		to_chat(user, span_info("You sense your familiar's vestige - right beside you."))
	else if(dist <= 30)
		to_chat(user, span_info("You sense your familiar's vestige - [direction], not far."))
	else if(dist <= 100)
		to_chat(user, span_info("You sense your familiar's vestige - [direction], some distance away."))
	else
		to_chat(user, span_info("You sense your familiar's vestige - [direction], far away."))
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
	user.whisper(message, language = /datum/language/common)
	log_game("[key_name(user)] sent a message to [key_name(summoner)] with contents [message]")
	return TRUE

/datum/action/cooldown/spell/familiar_transform
	name = "Spirit Transformation"
	desc = "Draw your form into itself, becoming a small orb that is wearable as a pendant, or revert to your original form."
	button_icon_state = "rune2"

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/familiar_transform/cast(mob/living/simple_animal/pet/familiar/user)
	. = ..()
	if(!istype(user))
		return FALSE
	if(isturf(user.loc))
		// we're on the ground somewhere, so we should become orb
		var/obj/item/magic/familiar_spirit/spirit = new /obj/item/magic/familiar_spirit(user.loc)
		spirit.icon = user.icon
		spirit.icon_state = user.icon_living
		spirit.name = user.name
		spirit.desc = "A small orb, containing the spirit of [user.name]."
		user.loc = spirit
		return TRUE
	else
		if(user.health<=0) // you shouldn't be able to cast this while dead, but just in case
			return FALSE
		var/obj/item/magic/familiar_spirit/spirit = user.loc
		if(!istype(spirit)) // we might be inside another item like warden tools
			return FALSE
		user.loc = get_turf(user)
		qdel(spirit)
		return TRUE

/datum/action/cooldown/spell/fae_brew
	name = "Alchemical Stomach"
	desc = "Toggle your brewing ability; while enabled, and you have a stock of reagents inside yourself, you will attempt to brew them into a potion using your summoner's alchemical skill."
	button_icon_state = "create_campfire"

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/fae_brew/cast(mob/living/simple_animal/pet/familiar/fae/user)
	. = ..()
	if(!istype(user))
		return FALSE
	user.should_brew = !user.should_brew
	return TRUE

/datum/action/cooldown/spell/projectile/lesser_fetch/fae
	name = "Grasp of Nature"
	desc = "Shoot out a grasping vine that draws in a freestanding item towards the caster. Doesn't work on living targets."
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z
	invocations = list("Recolligere silva")

/obj/effect/proc_holder/spell/invoked/reagent_bite
	name = "Alchemical Bite" // placeholder
	desc = "Bite a target, delivering a 5-dram dose of whatever is in your stomach."
	range = 1
	recharge_time = 10 SECONDS
	overlay_icon = 'icons/mob/actions/mage_hex.dmi'
	overlay_icon_state = "wither"

/obj/effect/proc_holder/spell/invoked/reagent_bite/cast(list/targets, mob/living/simple_animal/pet/familiar/fae/user)
	. = ..()
	if(!user) // literally how
		revert_cast()
		return FALSE
	var/atom/target = targets.len?targets[1]:null
	if(!targets.len || !(isliving(target) || target.is_refillable()) || !target.reagents)
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
		while(do_mob(user, targets, 1 SECONDS) && user.reagents.trans_to(targets[1], 5, transfered_by = user))
			user.visible_message(
				span_notice("[user.name] fills [targets[1]] with more of [user.p_their()] alchemical cocktail..."),
				span_notice("You fill [targets[1]] with more of your alchemical cocktail...")
			)
		user.visible_message(
			span_notice("[user.name] lets go of [targets[1]]."),
			span_notice("You let go of [targets[1]].")
		)
		return TRUE
	var/mob/living/living_target = targets[1]
	user.visible_message(
		span_notice("[user.name] attempts to bite [living_target.name]!"),
		span_notice("You attempt to bite [living_target.name]...")
	)
	// same do_after time and transfer amount as just walking up with a bottle and feeding them
	if(do_mob(user, living_target, time = 5 SECONDS) && user.reagents.trans_to(living_target, 5, transfered_by = user))
		user.visible_message(
			span_notice("[user.name] bites [living_target.name], delivering a dose of an alchemical cocktail!"),
			span_notice("You bite [living_target.name], delivering a dose of your alchemical cocktail!")
		)
		if(living_target.show_redflash())
			living_target.flash_fullscreen("redflash3")
		playsound(living_target, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
		return TRUE

/obj/effect/proc_holder/spell/invoked/incendiary_bite
	name = "Incendiary Bite"
	desc = "Bite a target, engulfing them in infernal flame."
	range = 1
	recharge_time = 10 SECONDS
	overlay_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	overlay_icon_state = "spitfire"

/obj/effect/proc_holder/spell/invoked/incendiary_bite/cast(list/targets, mob/living/simple_animal/pet/familiar/infernal/user)
	. = ..()
	if(!user) // literally how
		revert_cast()
		return FALSE
	if(!targets.len)
		to_chat(user, span_notice("I need to select a valid target to bite!"))
		revert_cast()
		return FALSE
	var/atom/target = targets[1]
	if(!istype(target))
		revert_cast()
		return FALSE
	target.fire_act(1,10) // shouldn't be oppressive by any means it's 1 stack every 10 seconds

/obj/effect/proc_holder/spell/self/infernal_surge
	name = "Infernal Surge"
	desc = "Let loose the flame of the hells in a small radius around you."
	recharge_time = 15 SECONDS
	overlay_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	overlay_icon_state = "fire_curtain"

/obj/effect/proc_holder/spell/self/infernal_surge/cast(list/targets, mob/user)
	. = ..()
	var/turf/center = user.loc
	for(var/turf/T in range(1, center)) // 2  turned out to be too much lol
		new /obj/effect/hotspot(T, null, null, 10)
		new /obj/effect/temp_visual/fire(T)

/datum/action/cooldown/spell/magicians_stone/elemental
	name = "Create Stone"
	fluff_desc = ""
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/arcyne_forge/elemental
	name = "Earthen Forge"
	desc = "Shape your earthen form into a tool or weapon. Shaped items have halved durability. When the item breaks, you will revert to your original form. Cast again to manually revert."
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z
	conjure_options = list(
		// Weapons
		"Short Sword" = /obj/item/rogueweapon/sword/short/iron,
		"Hunting Sword" = /obj/item/rogueweapon/sword/short/messer/iron,
		"Arming Sword" = /obj/item/rogueweapon/sword/iron,
		"Cudgel" = /obj/item/rogueweapon/mace/cudgel,
		"Warhammer" = /obj/item/rogueweapon/mace/warhammer,
		"Dagger" = /obj/item/rogueweapon/huntingknife/idagger,
		"Flail" = /obj/item/rogueweapon/flail,
		"Whip" = /obj/item/rogueweapon/whip,
		"Wooden Shield" = /obj/item/rogueweapon/shield/wood,
		// Tools
		"Axe" = /obj/item/rogueweapon/stoneaxe/woodcut,
		"Pickaxe" = /obj/item/rogueweapon/pick,
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Thresher" = /obj/item/rogueweapon/thresher,
		"Sickle" = /obj/item/rogueweapon/sickle,
		"Pitchfork" = /obj/item/rogueweapon/pitchfork,
		"Tongs" = /obj/item/rogueweapon/tongs,
		"Hammer" = /obj/item/rogueweapon/hammer/iron,
		"Shovel" = /obj/item/rogueweapon/shovel,
		"Handsaw" = /obj/item/rogueweapon/handsaw,
		"Scissors" = /obj/item/rogueweapon/huntingknife/scissors,
		"Fishing Rod" = /obj/item/fishingrod,
		"Frying Pan" = /obj/item/cooking/pan,
		"Pot" = /obj/item/reagent_containers/glass/bucket/pot,
		"Bowl" = /obj/item/reagent_containers/glass/bowl,
		"Fork" = /obj/item/kitchen/fork/iron,
		"Spoon" = /obj/item/kitchen/spoon/iron,
		"Needle" = /obj/item/needle/thorn
	)

/datum/action/cooldown/spell/arcyne_forge/elemental/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/pet/familiar/elemental/H = owner
	if(!istype(H))
		return FALSE

	// We're an item. Stop being an item.
	if(conjured_item && !QDELETED(conjured_item))
		H.loc = get_turf(H)
		QDEL_NULL(conjured_item)
		return FALSE // we don't want to add a cooldown for this case

	var/choice = tgui_input_list(H, "Choose what to conjure", "Earthen Forge", conjure_options)
	if(!choice)
		return FALSE

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
	RegisterSignal(R, COMSIG_ITEM_BROKEN, PROC_REF(revert))
	H.loc = R
	conjured_item = R
	return TRUE

/datum/action/cooldown/spell/arcyne_forge/elemental/proc/revert()
	if(conjured_item)
		owner.loc = get_turf(owner)
		QDEL_NULL(conjured_item)

/datum/action/cooldown/spell/arcyne_forge/elemental/t2
	name = "Greater Earthen Shaping"
	desc = "Shape a weapon or tool of your choice out of raw earth. Conjured items have halved durability.\n\
	Only one conjured item can exist at a time - conjuring a new one destroys the old."


/datum/action/cooldown/spell/arcyne_forge/elemental/t2/cast(atom/cast_on)
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

/obj/effect/proc_holder/spell/invoked/consume
	name = "Consume"
	desc = "Devour a planar being, feasting on its essences. Eat, and grow strong."
	range = 1
	recharge_time = 10 SECONDS
	overlay_icon = 'icons/mob/actions/hagspells.dmi'
	overlay_icon_state = "hand_up"

/obj/effect/proc_holder/spell/invoked/consume/cast(list/targets, mob/living/simple_animal/pet/familiar/void/user)
	. = ..()
	if(!user) // literally how
		revert_cast()
		return FALSE
	if(!targets.len)
		to_chat(user, span_notice("I can't eat that... not yet, at least."))
		return FALSE
	var/mob/living/simple_animal/pet/familiar/target = targets[1]
	if(!istype(target))
		to_chat(user, span_notice("I can't eat that... not yet, at least."))
		return FALSE
	if(target.mind)
		to_chat(user, span_notice("This one is fully awakened... it will have too tight a grasp on its essence. I must find a mindless power, perhaps my creator can help?"))
		revert_cast()
		return FALSE
	if(target.planar_origin == "void")
		user.visible_message(
			span_warning("[user] reaches out towards [target]... suddenly, you feel a sense of foreboding!"),
			span_warning("I prepare to devour [target]... this seems like a bad idea, but I am oh so hungry...")
		)
	else
		user.visible_message(
			span_warning("[user] begins to devour [target]!"),
			span_warning("I begin to devour [target]!")
		)
	if(!do_mob(user,target,5 SECONDS))
		return FALSE
	// we have a mindless familiar: let's see if it's actually valid for us
	var/essence_to_grant = null
	if(istype(target, /mob/living/simple_animal/pet/familiar/fae))
		essence_to_grant = "fae"
	else if(istype(target, /mob/living/simple_animal/pet/familiar/infernal))
		essence_to_grant = "infernal"
	else if(istype(target, /mob/living/simple_animal/pet/familiar/elemental))
		essence_to_grant = "elemental"
	else
		// kin... hubris begets hubris, in the end
		for(var/obj/effect/decal/cleanable/roguerune/arcyne/binding/rune in range(target.loc))
			rune.summoned_mob = null
		user.visible_message(
			span_warningbig("[src] attempts to consume [target], but as soon as their essences commingle, they annihilate in a violent blast!"),
			span_warningbig("I attempt to consume [target], but as soon as I touch their essences, I am undone!")
		)
		new /obj/effect/temp_visual/dragon_swoop(target.loc)
		playsound(target.loc, 'sound/vo/mobs/vdragon/drgnroar.ogg', 50, TRUE, -1)
		for(var/mob/living/L in orange(1, target))
			if(L.ckey == user.ckey)
				continue // user will be qdel'd so don't throw them
			L.adjustBruteLoss(75) // this should never kill it's just an "oh fuck" moment
			if(L && !QDELETED(L)) // Some mobs are deleted on death
				var/throw_dir = get_dir(target, L)
				if(L.loc == target.loc)
					throw_dir = pick(GLOB.alldirs)
				L.throw_at(get_edge_target_turf(L,throw_dir), 3, 2)
				L.visible_message(span_warning("[L] is thrown clear of the blast!</span>"))
		for(var/mob/M in range(7, target))
			shake_camera(M, 15, 1)
		user.mind?.RemoveAllSpells()
		user.mind?.unknow_all_people()
		QDEL_NULL(target)
		QDEL_NULL(user)
		return TRUE
	playsound(user, 'sound/gore/flesh_eat_03.ogg', 100, FALSE)
	if(!user.essences_consumed.Find(essence_to_grant))
		user.visible_message(
			span_warning("[user] consumes [target], absorbing their essences!"),
			span_warning("I consume [target]'s essence! I am stronger for it, though I hunger still.")
		)
		user.essences_consumed += essence_to_grant
		user.grant_essence(essence_to_grant)
		if(LAZYLEN(user.essences_consumed) == 3)
			to_chat(user, span_notice("I have consumed the essences of the three planes. One dae, I will grow strong enough to consume yet greater beings, but for now, this appears to be my limit. My hunger is mostly sated, for the week."))
		for(var/obj/effect/decal/cleanable/roguerune/arcyne/binding/rune in range(target.loc))
			rune.summoned_mob = null
		QDEL_NULL(target)
		return TRUE
	else
		user.visible_message(
			span_warning("[user] consumes [target]... but [user.p_they()] [(user.pronouns == THEY_THEM) ? "don't" : "doesn't"] seem even slightly sated!"),
			span_warning("I consume [target]'s essence, but I have already tasted of it! This will not nourish me anymore, I must find something new to devour.")
		)
		for(var/obj/effect/decal/cleanable/roguerune/arcyne/binding/rune in range(target.loc))
			rune.summoned_mob = null
		QDEL_NULL(target)
		return TRUE

/obj/effect/proc_holder/spell/invoked/fire_obelisk_beam/drakeling
	name = "Abberant Beam"
	desc = "Show these fools the power of the void!"
	recharge_time = 30 SECONDS
	overlay_icon = 'icons/mob/actions/mage_shared.dmi'
	overlay_icon_state = "soulshot"
	range = 4

/obj/effect/obeliskbeam/drakeling
	name = "drakeling beam"

// nerfed damage down to one-fifth the original value - still fucks up simples though
/obj/effect/obeliskbeam/drakeling/damage(mob/living/hit_mob)
	if(issimple(hit_mob))
		hit_mob.apply_damage(damage = 10, damagetype = BURN)
	else
		hit_mob.apply_damage(damage = 3, damagetype = BURN)
	to_chat(hit_mob, span_danger("You're damaged by [src]!"))

/obj/effect/proc_holder/spell/invoked/fire_obelisk_beam/drakeling/cast(list/targets, mob/living/simple_animal/pet/familiar/void/user)
	user.face_atom(targets[1])
	user.move_resist = MOVE_FORCE_VERY_STRONG
	if(do_after(user,1 SECONDS, target=user))
		user.visible_message(span_danger("[user] fires an aberrant beam!"))
		playsound(user, 'sound/magic/obeliskbeam.ogg', 150, FALSE, 0, 3)
		var/turf/target_turf = get_ranged_target_turf(user, user.dir, 4) // nerfed range by _over_ half
		var/turf/origin_turf = get_turf(user)
		var/list/affected_turfs = get_line(origin_turf, target_turf) - origin_turf
		for(var/turf/affected_turf in affected_turfs)
			if(affected_turf.opacity)
				break
			var/blocked = FALSE
			for(var/obj/potential_block in affected_turf.contents)
				if(potential_block.opacity)
					blocked = TRUE
					break
			if(blocked)
				break
			var/obj/effect/obeliskbeam/drakeling/new_obeliskbeam = new(affected_turf)
			new_obeliskbeam.dir = user.dir
			user.beam_parts += new_obeliskbeam
			new_obeliskbeam.assign_creator(user)
			for(var/mob/living/hit_mob in affected_turf.contents)
				if(issimple(hit_mob))
					hit_mob.apply_damage(damage = 15, damagetype = BURN)
				else
					hit_mob.apply_damage(damage = 5, damagetype = BURN) // this is literally one-fifth of the normal abberant beam you will not be fragging with this
				to_chat(hit_mob, span_userdanger("You're blasted by [user]'s aberrant beam!"))
		if(!length(user.beam_parts))
			return FALSE
		var/atom/last_obeliskbeam = user.beam_parts[length(user.beam_parts)]
		last_obeliskbeam.icon_state = "obeliskbeam_end"
		var/atom/first_obeliskbeam = user.beam_parts[1]
		first_obeliskbeam.icon_state = "obeliskbeam_start"
		do_after(user, delay = 5 SECONDS, target = user)
		user.move_resist = initial(user.move_resist)
		for(var/obj/effect/obeliskbeam/drakeling/beam in user.beam_parts)
			beam.disperse()
		user.beam_parts = list()

/datum/action/cooldown/spell/projectile/lesser_fetch/fae/void
	name = "Grasp of the Void"
	desc = "Grasp a freestanding item with your arcyne power, drawing it towards you. Doesn't work on living targets."
	invocations = list("Nihilo, recolligere")


/datum/action/cooldown/spell/magicians_stone/elemental/void
	name = "Harvest Stone"
