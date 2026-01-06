#define MIRACLE_HEALING_FILTER "miracle_heal_glow"
#define CORPSE_SCENT_RANGE 30
#define STARSEERS_CRY_RANGE 7
#define SOOTHING_BLOOM_RANGE 5

/obj/effect/proc_holder/spell/self/message_summoner
	name = "Message Summoner"
	recharge_time = 1 SECONDS

/obj/effect/proc_holder/spell/self/message_summoner/cast(list/targets, mob/living/simple_animal/pet/familiar/user)
	. = ..()

	var/mob/living/summoner = user.familiar_summoner

	if(!summoner || !isliving(summoner) || !summoner.mind)
		to_chat(user, span_warning("You cannot sense your summoner's mind."))
		revert_cast()
		return FALSE

	var/message = input(user, "You make a connection. What are you trying to say?")
	if(!message)
		revert_cast()
		return FALSE
	to_chat_immediate(summoner, "Arcane whispers fill the back of my head, resolving into [user.real_name]'s voice: <font color=#7246ff>[message]</font>")
	user.visible_message("[user.name] mutters an incantation and their mouth briefly flashes white.")
	user.whisper(message)
	log_game("[key_name(user)] sent a message to [key_name(summoner)] with contents [message]")
	return TRUE

/obj/effect/proc_holder/spell/self/stillness_of_stone
	name = "Stillness of Stone"
	recharge_time = 1 SECONDS

/obj/effect/proc_holder/spell/self/stillness_of_stone/cast(list/targets, mob/living/simple_animal/pet/familiar/pondstone_toad/user)
	. = ..()
	if(!user)
		revert_cast()
		return FALSE
	if(user.stoneform)
		user.revert_from_stoneform()
	else
		// Save original state if not already saved
		if(!user.original_icon)
			user.original_icon = user.icon
			user.original_icon_state = user.icon_state
			user.original_icon_living = user.icon_living
			user.original_name = user.name

		 user.visible_message(
			span_notice("[user.name] becomes utterly still, their body taking on the appearance of a stone."),
			span_notice("You become utterly still, blending into your surroundings like a stone.")
		)

		user.icon = 'icons/roguetown/items/natural.dmi'
		user.icon_state = "stone1"
		user.icon_living = "stone1"
		user.name = "Stone"
		user.stoneform = TRUE
		user.regenerate_icons()
	return TRUE

/mob/living/simple_animal/pet/familiar/pondstone_toad/proc/revert_from_stoneform()
	if(!stoneform)
		return

	icon = original_icon
	icon_state = original_icon_state
	icon_living = original_icon_living
	name = original_name
	stoneform = FALSE

	visible_message(
		span_notice("[src] shifts back into a more animated, toad-like form."),
		span_notice("You shift back into your natural form.")
	)
	regenerate_icons()

/mob/living/simple_animal/pet/familiar/pondstone_toad/Move()
	if(stoneform)
		return FALSE
	return ..()

/mob/living/simple_animal/pet/familiar/pondstone_toad/death()
	. = ..()
	if(stoneform)
		revert_from_stoneform()

/mob/living/simple_animal/pet/familiar/hollow_antlerling/Move()
	. = ..()
	if (prob(60) && isturf(src.loc))
		var/obj/item/glow_petal/petal = new /obj/item/glow_petal(src.loc)
		spawn(rand(50, 60))
			qdel(petal)

/obj/item/glow_petal
	name = "Faint Petals"
	icon = 'icons/roguetown/mob/familiars.dmi'
	icon_state = "leaf_trail"
	anchored = TRUE
	mouse_opacity = 0

	light_outer_range = 2 
	light_power = 1 
	light_color = rgb(255, 120, 255) 
	light_on = TRUE

/obj/effect/proc_holder/spell/self/scent_of_the_grave
	name = "Scent of the Grave"
	recharge_time = 1 SECONDS

/obj/effect/proc_holder/spell/self/scent_of_the_grave/cast(list/targets, mob/living/simple_animal/pet/familiar/gravemoss_serpent/user)
	. = ..()

	user.visible_message(
		span_notice("[user.name] lifts its head, tongue flickering as it tastes the air..."),
		span_notice("You raise your head, tasting the air for the scent of the dead.")
	)

	var/list/trackable_corpses = list()
	for (var/mob/living/corpse in GLOB.dead_mob_list)
		if(corpse && get_dist(corpse, user) < CORPSE_SCENT_RANGE)
			trackable_corpses += corpse

	if(!trackable_corpses.len)
		to_chat(user,span_notice("You detect no nearby corpses."))
		return FALSE

	var/mob/living/selected_corpse = input(user, "Select a corpse to track", "Nearby corpses") as null|anything in trackable_corpses
	if(!selected_corpse)
		return FALSE
	if(QDELETED(selected_corpse))
		to_chat(user, span_notice("the scent dissipated."))
		return FALSE	
	var/direction_text = dir2text(get_dir(user.loc, selected_corpse.loc))

	user.visible_message(
		span_warning("[user.name]'s eyes narrows."),
		span_notice("The scent of the grave draws you to the [direction_text].")
	)
	return TRUE

/obj/effect/proc_holder/spell/invoked/blink/glimmer_hare
	invocations = list("") //"Natural" abilty, no incantation.
	chargetime = 0
	releasedrain = 0
	chargedrain = 0
	xp_gain = FALSE
	

/obj/effect/proc_holder/spell/self/inscription_cache
	name = "Inscription Cache"
	recharge_time = 5 SECONDS

/obj/effect/proc_holder/spell/self/inscription_cache/cast(mob/living/simple_animal/pet/familiar/rune_rat/user)
	. = ..()
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item)
		to_chat(user, span_notice("You must be holding something to store."))
		revert_cast()
		return FALSE
	if(!(istype(held_item, /obj/item/book) || istype(held_item, /obj/item/paper)))
		to_chat(user, span_notice("Only written materials can be stored."))
		revert_cast()
		return FALSE
	if(length(user.stored_books) >= user.storage_limit)
		to_chat(user, span_notice("Your cache is full. Recall something first."))
		revert_cast()
		return FALSE

	user.stored_books += held_item
	held_item.forceMove(user) // remove it from the world
	user.visible_message(span_notice("[user.name] vanishes [held_item.name] into a shimmer of runes."),span_notice("You vanish [held_item.name] into a shimmer of runes."))
	return TRUE

/obj/effect/proc_holder/spell/self/recall_cache
	name = "Recall cache"
	recharge_time = 5 SECONDS

/obj/effect/proc_holder/spell/self/recall_cache/cast(mob/living/simple_animal/pet/familiar/rune_rat/user)
	. = ..()
	if(!length(user.stored_books))
		to_chat(user, "<span class='notice'>Your cache is empty.</span>")
		revert_cast()
		return FALSE

	var/obj/item/selected_item = input(user, "Select an item to retrieve:", "Recall Cache") as null|anything in user.stored_books
	if(selected_item)
		if(QDELETED(selected_item))
			to_chat(user, span_warning("That item is no longer available."))
			user.stored_books -= selected_item
			revert_cast()
			return FALSE
		selected_item.forceMove(user.loc)
		user.stored_books -= selected_item
		user.visible_message(span_notice("[selected_item.name] shimmers into existence beside [user.name]"),span_notice("[selected_item.name] shimmers into existence beside you."))
		return TRUE
	else
		revert_cast()
		return FALSE

/mob/living/simple_animal/pet/familiar/rune_rat/death()
	. = ..()
	for (var/obj/item/stored_item in src.stored_books)
		stored_item.forceMove(src.loc)

/obj/effect/proc_holder/spell/self/smolder_shroud
	name = "Smolder Shroud"
	recharge_time = 5 MINUTES
	chargetime = 0

/obj/effect/proc_holder/spell/self/smolder_shroud/cast(list/targets, mob/user)
	. = ..()
	user.visible_message(
		span_warning("[user.name] exhales a thick, swirling shroud of smoke!"),
		span_warning("You exhale a thick, swirling shroud of smoke!")
	)
	var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread
	smoke.set_up(2, user)
	smoke.start()
	return TRUE

/obj/effect/proc_holder/spell/self/soothing_bloom
	name = "Soothing Bloom"
	recharge_time = 16 SECONDS

/obj/effect/proc_holder/spell/self/soothing_bloom/cast(list/targets, mob/living/simple_animal/pet/familiar/vaporroot_wisp/user)
	. = ..()

	user.visible_message(span_notice("[user.name] releases a soothing vapor"),span_notice("You release a soothing vapor"))
	for (var/mob/living/nearby_mob in view(SOOTHING_BLOOM_RANGE, user))
		if(nearby_mob == user || isdead(nearby_mob))
			continue
		nearby_mob.apply_status_effect(/datum/status_effect/regen/soothing_bloom)
		to_chat(nearby_mob, span_notice("A cool mist settles on your skin, and you feel your wounds slowly close."))
	return TRUE

/datum/status_effect/regen/soothing_bloom
	id = "soothing_bloom"
	tick_interval = 40 //This should give it two ticks of 1 healing per person in the radius.
	alert_type = /atom/movable/screen/alert/status_effect/regen/soothing_bloom
	duration = 8 SECONDS
	var/healing_on_tick = 1
	var/outline_colour = "#129160"

/atom/movable/screen/alert/status_effect/regen/soothing_bloom
	name = "Soothing Bloom"
	desc = "You are gently regenerating health over time."

/datum/status_effect/regen/soothing_bloom/on_apply()
	var/filter = owner.get_filter(MIRACLE_HEALING_FILTER)
	if (!filter)
		owner.add_filter(MIRACLE_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/regen/soothing_bloom/on_remove()
	var/filter = owner.get_filter(MIRACLE_HEALING_FILTER)
	if (filter)
		owner.remove_filter(MIRACLE_HEALING_FILTER)
	return TRUE

/datum/status_effect/regen/soothing_bloom/tick()
	var/obj/effect/temp_visual/heal/heal_effect = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	heal_effect.color = "#129160"
	var/list/wound_count = owner.get_wounds()
	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume+2, BLOOD_VOLUME_NORMAL) //Reduced blood replenishment compared to cleric miracle.
		if(wound_count.len > 0)
			owner.heal_wounds(healing_on_tick)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, 0)
		owner.adjustOxyLoss(-healing_on_tick, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)

/obj/effect/proc_holder/spell/self/starseers_cry
	name = "Starseer's Cry"
	desc = "Let out a piercing celestial call that disrupts all veils of shadow within sight."
	recharge_time = 30 SECONDS

/obj/effect/proc_holder/spell/self/starseers_cry/cast(list/targets, mob/living/simple_animal/pet/familiar/starfield_crow/user)
	. = ..()
	user.visible_message(span_danger("[user.name] lets out a soul-piercing cry, the stars shimmering in their eyes!"))

	for (var/mob/living/living_mob in range(STARSEERS_CRY_RANGE, user))
		if (living_mob == user)
			continue

		var/invis_active = living_mob.mob_timers[MT_INVISIBILITY] > world.time
		var/sneaking = living_mob.m_intent == MOVE_INTENT_SNEAK

		if (invis_active || sneaking)
			living_mob.update_sneak_invis(reset = TRUE)
			living_mob.visible_message(span_danger("[living_mob.name] is revealed by a cosmic pulse!"), span_notice("You feel your concealment burn away."))
			found_ping(get_turf(living_mob), user.client, "hidden")

	return TRUE

/obj/effect/proc_holder/spell/invoked/pyroclastic_puff
	name = "Pyroclastic_puff"
	recharge_time = 1 SECONDS
	sound = list('sound/magic/whiteflame.ogg')

/obj/effect/proc_holder/spell/invoked/pyroclastic_puff/cast(list/targets, mob/user)
	. = ..()
	if (!targets || !targets.len)
		to_chat(user, span_warning("No valid target selected."))
		revert_cast()
		return FALSE
	if (isturf(targets[1]))
		var/turf/front_turf = get_step(user, user.dir)
		var/datum/effect_system/spark_spread/spark_spread_effect = new()
		user.flash_fullscreen("whiteflash")
		flick("flintstrike", src)
		spark_spread_effect.set_up(1, 1, front_turf)
		spark_spread_effect.start()
		user.visible_message(span_notice("[user.name] exhales a flurry of glowing sparks!"), span_notice("You breathe out a tiny burst of emberlight."))
		return TRUE
	else
		var/atom/target_atom = targets[1]
		if (user.Adjacent(target_atom))
			user.flash_fullscreen("whiteflash")
			flick("flintstrike", src)
			target_atom.spark_act()
			user.visible_message(span_notice("[user.name] exhales a directed spark toward [target_atom]!"), span_notice("You release a pinpoint ember toward [target_atom]."))
			return TRUE
		else
			to_chat(user, span_warning("You're too far to spark that."))
			revert_cast()
			return FALSE

/obj/effect/proc_holder/spell/self/verdant_sprout
	name = "Verdant Sprout"
	recharge_time = 1 MINUTES

/obj/effect/proc_holder/spell/self/verdant_sprout/cast(list/targets, mob/user)
	. = ..()
	var/turf/target_turf = get_step(user, user.dir)

	if(!isturf(target_turf))
		to_chat(user, span_warning("You cannot grow plants on this."))
		revert_cast()
		return FALSE

	// Turn dirt to grass
	if(istype(target_turf, /turf/open/floor/rogue/dirt))
		target_turf.ChangeTurf(/turf/open/floor/rogue/grass)
		user.visible_message(span_notice("Vines creep forward in front of [user.name], coaxing new grass from the soil."), span_notice("Vines creep forward in front of you, coaxing new grass from the soil."))
		return TRUE

	// Add bush to existing grass tile if empty
	if(istype(target_turf, /turf/open/floor/rogue/grass))
		var/has_structures = FALSE
		for(var/obj/structure/structure_obj in target_turf)
			has_structures = TRUE
			break

		if(!has_structures)
			new /obj/structure/flora/roguegrass/bush(target_turf)
			to_chat(user, span_notice("A small bush rises gently from the grass."))
			return TRUE
		else
			to_chat(user, span_warning("That spot is already occupied."))
			return FALSE

	to_chat(user, span_warning("Nothing happens."))
	return FALSE

/obj/effect/proc_holder/spell/self/phantasm_fade
	name= "Phantasm Fade"
	recharge_time = 2 MINUTES

/obj/effect/proc_holder/spell/self/phantasm_fade/cast(list/targets, mob/living/simple_animal/pet/familiar/whisper_stoat/user)
	. = ..()
	user.visible_message(span_warning("[user.name] starts to fade into thin air!"), span_notice("You start to become invisible!"))
	animate(user, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
	user.mob_timers[MT_INVISIBILITY] = world.time + 15 SECONDS
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), 15 SECONDS)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[user.name] fades back into view."), span_notice("You become visible again.")), 15 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/self/phantom_flicker
	name= "Phantom Flicker"
	recharge_time = 2 MINUTES

/obj/effect/proc_holder/spell/self/phantom_flicker/cast(list/targets, mob/living/simple_animal/pet/familiar/ripplefox/user)
	. = ..()
	var/mob/living/simple_animal/pet/familiar/ripplefox/illusory_familiar = new user.type(user.loc)
	illusory_familiar.familiar_summoner = user
	illusory_familiar.fully_replace_character_name(null, user.name)
	animate(user, alpha = 0, time = 1, easing = EASE_IN) //should be seamless, hopefully
	// Schedule deletion safely with global context
	addtimer(CALLBACK(GLOBAL_PROC, /proc/delete_illusory_fam, illusory_familiar, user), 200)
	user.mob_timers[MT_INVISIBILITY] = world.time + 20 SECONDS
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), 200)
	return TRUE

/proc/delete_illusory_fam(var/mob/living/simple_animal/pet/familiar/ripplefox/illusory_familiar, var/mob/user)
	if(illusory_familiar && !QDELETED(illusory_familiar))
		illusory_familiar.visible_message(span_notice("[illusory_familiar.name] flickers and vanishes into nothingness."))
		qdel(illusory_familiar)

/obj/effect/proc_holder/spell/self/lurking_step
	name = "Lurking Step"
	desc = "Mark this location with a name, binding it to your hidden trail."
	recharge_time = 10 SECONDS

/obj/effect/proc_holder/spell/self/lurking_step/cast(list/targets, mob/living/simple_animal/pet/familiar/mist_lynx/user)
	. = ..()
	if (!user.saved_trails)
		user.saved_trails = list()
	var/spot_name = input(user, "Name this location for future return:", "Mark Trail") as text|null
	if (!spot_name)
		return FALSE
	// Prevent duplicate names
	for (var/trail_entry in user.saved_trails)
		if (trail_entry["name"] == spot_name)
			to_chat(user, span_warning("You already have a trail named '[spot_name]'. Choose a different name."))
			revert_cast()
			return FALSE
	// Prevent duplicate locations
	for (var/trail_entry in user.saved_trails)
		if (trail_entry["loc"] == user.loc)
			to_chat(user, span_warning("You already have a trail marked at this location."))
			revert_cast()
			return FALSE
	// Limit to 3 entries
	if (user.saved_trails.len >= 3)
		user.saved_trails.Remove(user.saved_trails[1])
	user.saved_trails += list(list("name" = spot_name, "loc" = user.loc))
	to_chat(user, span_notice("You still yourself. The place is etched into your hidden path."))
	return TRUE

/obj/effect/proc_holder/spell/invoked/veilbound_shift
	name = "Veilbound Shift"
	desc = "Vanish and reappear at a hidden trail you've marked before."
	chargetime = 20
	recharge_time = 1 MINUTES

/obj/effect/proc_holder/spell/invoked/veilbound_shift/cast(list/targets, mob/living/simple_animal/pet/familiar/mist_lynx/user)
	. = ..()
	if (!user.saved_trails || !user.saved_trails.len)
		to_chat(user, span_warning("You have no marked paths to return to."))
		revert_cast()
		return FALSE

	var/list/trail_names = list()
	for (var/trail_entry in user.saved_trails)
		trail_names += trail_entry["name"]

	var/selected_trail_name = input(user, "Choose a hidden trail to return to:", "Veilbound Shift") as null|anything in trail_names
	if (!selected_trail_name)
		revert_cast()
		return FALSE

	var/target_location
	for (var/trail_entry in user.saved_trails)
		if (trail_entry["name"] == selected_trail_name)
			target_location = trail_entry["loc"]
			break

	if (!(isturf(target_location) || isopenturf(target_location)))
		to_chat(user, span_warning("The path has faded..."))
		// Remove the invalid entry by name
		for (var/i = 1, i <= user.saved_trails.len, i++)
			if (user.saved_trails[i]["name"] == selected_trail_name)
				user.saved_trails.Cut(i, i+1)
				break
		revert_cast()
		return FALSE

	user.visible_message(span_emote("[user.name] blurs at the edges, dissolving like mist."))

	spawn(20)
		// Re-find the entry by name to ensure it's still valid
		var/current_index = 0
		for (var/i = 1, i <= user.saved_trails.len, i++)
			if (user.saved_trails[i]["name"] == selected_trail_name)
				current_index = i
				break
		if (!(isturf(target_location) || isopenturf(target_location)))
			to_chat(user, span_warning("The path has faded..."))
			if (current_index)
				user.saved_trails.Cut(current_index, current_index+1)
			return
		do_teleport(user, target_location, forceMove = TRUE, channel = TELEPORT_CHANNEL_MAGIC)
		user.visible_message(span_emote("A ripple in the air resolves into fur and paw. [user.name] pads silently into view."))

	return TRUE

/obj/effect/proc_holder/spell/self/verdant_veil
	name = "Verdant Veil"
	desc = "Shrouds nearby allies in illusionary invisibility, broken if they move or act."
	recharge_time = 30 SECONDS

//I wanted a long duration aoe invisibility that would be broken by movement. But I can't make it work so, short duration it is.
/obj/effect/proc_holder/spell/self/verdant_veil/cast(list/targets, mob/living/simple_animal/pet/familiar/hollow_antlerling/user)
	. = ..()
	to_chat(user, span_notice("You exhale a shimmering cloud of forest illusion..."))
	user.visible_message(span_warning("[user.name] releases a swirl of glowing leaves!"), span_notice("You feel the forest's stillness wrap around you."))

	for (var/mob/living/nearby_mob in range(1, user))
		if (nearby_mob == user || isobserver(nearby_mob))
			continue

		if (nearby_mob.anti_magic_check(TRUE, TRUE))
			continue

		nearby_mob.visible_message(span_warning("[nearby_mob] starts to fade into thin air!"), span_notice("You start to become invisible!"))
		animate(nearby_mob, alpha = 0, time = 1 SECONDS, easing = EASE_IN)

		nearby_mob.mob_timers[MT_INVISIBILITY] = world.time + 5 SECONDS
		// Apply invis and visual feedback
		nearby_mob.update_sneak_invis()

		// Schedule end of duration
		addtimer(CALLBACK(nearby_mob, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), 5 SECONDS)

	return TRUE


#undef MIRACLE_HEALING_FILTER
#undef CORPSE_SCENT_RANGE
#undef STARSEERS_CRY_RANGE
#undef SOOTHING_BLOOM_RANGE
