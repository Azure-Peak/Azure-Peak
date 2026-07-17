#define PORTAL_PURSUIT_COOLDOWN 7.5 SECONDS
#define PORTAL_PURSUIT_USES 5

// Scaling (base_antags path, no storyteller slot caps):
//  Midround event: base=1, denom=80, max=2 → 1-79 pop: 1, 80+: 2
//  Roundstart (Abyssor only): base=2, max=2 → always 2
/datum/antagonist/dreamwalker
	name = "Dreamwalker"
	roundend_category = "Dreamwalker"
	antagpanel_category = "Dreamwalker"
	job_rank = ROLE_DREAMWALKER
	storyteller_antag_flags = STORYTELLER_ANTAG_SOFT
	confess_lines = list(
		"MY VISION ABOVE ALL!",
		"I'LL TAKE YOU TO MY REALM!",
		"HIS FORM IS MAGNICIFENT!",
	)
	rogue_enabled = TRUE
	has_tempo = TRUE

	var/traits_dreamwalker = list(
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_DEATHLESS,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		//TRAIT_NOSLEEP, - Readd this later when I give people options to progress skills again...
		TRAIT_NOMOOD,
		TRAIT_NOLIMBDISABLE,
		TRAIT_SHOCKIMMUNE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_HEAVYARMOR,
		TRAIT_COUNTERCOUNTERSPELL,
		TRAIT_RITUALIST,
		TRAIT_STRENGTH_UNCAPPED,
		TRAIT_DREAMWALKER,
		TRAIT_UNLYCKERABLE
		)

	var/STASTR = 15
	var/STASPD = 12
	var/STAINT = 12
	var/STAWIL = 12
	var/STACON = 12
	var/STAPER = 12
	var/STALUC = 10

/datum/antagonist/dreamwalker/on_gain()
	SSmapping.retainer.dreamwalkers |= owner
	. = ..()
	reset_stats()
	// We'll set the special role later to avoid revealing dreamwalkers early!
	//owner.special_role = name
	greet()
	return ..()

/datum/antagonist/dreamwalker/greet()
	to_chat(owner.current, span_notice("I feel a rare ability awaken within me. I am someone coveted as a champion by most gods. A dreamwalker. Not merely touched by Abyssor's dream, but able to pull materia and power from his realm effortlessly. I shall bring glory to my patron. My mind frays under the influence of dream entities, but surely my resolve is stronger than theirs."))
	to_chat(owner.current, span_notice("I manifest a piece of ritual chalk... It seems potent. I shall forge a great weapon, one with such power it shall dwarf all others. I must find a target to begin... It should be easy enough if I focus."))
	owner.announce_objectives()
	..()

/datum/antagonist/dreamwalker/proc/reset_stats()
	owner.current.STASTR = src.STASTR
	owner.current.STAPER = src.STAPER
	owner.current.STAINT = src.STAINT
	owner.current.STASPD = src.STASPD
	owner.current.STAWIL = src.STAWIL
	owner.current.STACON = src.STACON
	owner.current.STALUC = src.STALUC
	//Dreamfiends fear them up close.
	var/mob/living/carbon/human/body = owner.current 
	body.faction |= "dream"
	for (var/trait in traits_dreamwalker)
		ADD_TRAIT(body, trait, "[type]")
	if(body.mind)
		body.mind.RemoveAllSpells()
		body.mind.AddSpell(new /datum/action/cooldown/spell/blink/dreamwalker)
		body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mark_target)
		body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/jaunt)
		body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dream_bind)
		body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dream_trance)
		body.grant_language(/datum/language/abyssal)
	for(var/datum/charflaw/cf in body.charflaws)
		if(istype(cf, /datum/charflaw/hunted) || istype(cf, /datum/charflaw/targeted))
			body.charflaws.Remove(cf)
			QDEL_NULL(cf)
	body.ambushable = FALSE
	body.AddComponent(/datum/component/dreamwalker_repair)
	body.AddComponent(/datum/component/dreamwalker_mark)
	var/obj/item/ritechalk/chalk = new()
	body.put_in_hands(chalk)
	to_chat(body, span_danger("I feel my connection to the arcyne and divine weaken as dream energies assert themselves..."))
	REMOVE_TRAIT(body, TRAIT_ARCYNE, TRAIT_GENERIC)
	body.devotion = null

/datum/outfit/job/roguetown/dreamwalker/pre_equip(mob/living/carbon/human/H) //Equipment is located below
	..()

	H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	// We lose our statpack & racial, so bonuses are significant.
	H.change_stat(STATKEY_STR, 5)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_WIL, 2)

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/blink)
	H.ambushable = FALSE


/obj/structure/portal_jaunt
	name = "dream rift"
	desc = "A shimmering portal to another place. You hear countless whispers when you get close, seems dangerous."
	icon_state = "shitportal"
	icon = 'icons/roguetown/misc/structure.dmi'
	max_integrity = 250
	var/cooldown = 0
	var/uses = 0
	var/max_uses = PORTAL_PURSUIT_USES
	var/turf/linked_turf
	var/safe_passage = FALSE

/obj/structure/portal_jaunt/Initialize()
	. = ..()
	cooldown = world.time + 4 SECONDS
	visible_message(span_warning("[src] shimmers into existence!"))
	playsound(src, 'sound/magic/charging_lightning.ogg', 50, TRUE)

	set_light(3, 2, 20, l_color = "#7b60f3")

/obj/structure/portal_jaunt/attack_hand(mob/user)
	if(!do_after(user, 1 SECONDS, target = src))
		to_chat(user, span_warning("I must stand still to use the portal."))
		return

	if(world.time < cooldown)
		var/time_left = (cooldown - world.time) * 0.1
		to_chat(user, span_warning("The portal is not stable yet. [time_left] seconds remaining."))
		return

	if(uses >= max_uses)
		to_chat(user, span_warning("The portal collapses as you touch it!"))
		qdel(src)
		return

	if(!linked_turf || !do_teleport(user, linked_turf))
		to_chat(user, span_warning("The portal flickers but nothing happens."))
		return

	uses++
	cooldown = world.time + PORTAL_PURSUIT_COOLDOWN
	// High likelyhood of getting a dreamfiend summon upon non dreamwalkers when used.
	if(!safe_passage && !HAS_TRAIT(user, TRAIT_DREAMWALKER) && (prob(75)))
		summon_dreamfiend(
			target = user,
			user = user,
			F = /mob/living/simple_animal/hostile/rogue/dreamfiend,
			outer_tele_radius = 3,
			inner_tele_radius = 2,
			include_dense = FALSE,
			include_teleport_restricted = FALSE
		)

	visible_message(span_warning("[user] steps through [src]!"))
	playsound(src, 'sound/magic/lightning.ogg', 50, TRUE)

	if(uses >= max_uses)
		visible_message(span_danger("[src] collapses in on itself!"))
		QDEL_IN(src, 1)

// Component to track marked targets and hits
/datum/component/dreamwalker_mark
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/marked_target = null
	var/hit_count = 0
	var/max_hits = 5
	var/mark_duration = 30 MINUTES
	var/mark_start_time = 0
	var/mark_minimum_duration = 10 MINUTES
	var/obj/effect/proc_holder/spell/invoked/summon_marked/summon_spell = null

/datum/component/dreamwalker_mark/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_ITEM_ATTACK, .proc/on_attack)

/datum/component/dreamwalker_mark/Destroy()
	if(marked_target)
		UnregisterSignal(marked_target, COMSIG_LIVING_DEATH)
		marked_target = null

	if(summon_spell && ishuman(parent))
		var/mob/living/carbon/human/H = parent
		if(H.mind)
			H.mind.RemoveSpell(summon_spell)
		QDEL_NULL(summon_spell)
	return ..()

/datum/component/dreamwalker_mark/proc/set_marked_target(mob/living/target)
	if(marked_target)
		UnregisterSignal(marked_target, COMSIG_LIVING_DEATH)
		if(marked_target.has_status_effect(/datum/status_effect/dream_mark))
			marked_target.remove_status_effect(/datum/status_effect/dream_mark)

	marked_target = target
	hit_count = 0
	mark_start_time = 0

	if(marked_target)
		RegisterSignal(marked_target, COMSIG_LIVING_DEATH, .proc/on_target_death)
		to_chat(parent, span_notice("You begin focusing your dream energy on [marked_target]."))

		// Remove any existing summon spell
		if(summon_spell && ishuman(parent))
			var/mob/living/carbon/human/H = parent
			if(H.mind)
				H.mind.RemoveSpell(summon_spell)
			QDEL_NULL(summon_spell)

/datum/component/dreamwalker_mark/proc/on_attack(mob/parent, mob/living/target, mob/user, obj/item/I)
	SIGNAL_HANDLER

	if(!marked_target || target != marked_target)
		return

	if(!(I.item_flags & DREAM_ITEM))
		return

	if(marked_target.has_status_effect(/datum/status_effect/dream_mark))
		return

	hit_count++
	to_chat(user, span_notice("Your dream weapon strikes true. [hit_count]/[max_hits] hits to establish a connection."))

	if(hit_count >= max_hits)
		// Apply the mark status effect
		marked_target.apply_status_effect(/datum/status_effect/dream_mark, mark_duration)
		mark_start_time = world.time
		to_chat(user, span_warning("You've established a strong dream connection with [marked_target]! You'll be able to summon them in 10 minutes."))
		to_chat(marked_target, span_userdanger("You feel an unnatural connection forming with [user]. Your very essence feels tethered to them."))

		create_summon_spell()

/datum/component/dreamwalker_mark/proc/create_summon_spell()
	if(!marked_target || !ishuman(parent))
		return

	// Check if mark is still active
	if(!marked_target.has_status_effect(/datum/status_effect/dream_mark))
		to_chat(parent, span_warning("Your connection with [marked_target] has faded before you could summon them!"))
		return

	// Create the summon spell
	summon_spell = new()
	var/mob/living/carbon/human/H = parent
	if(H.mind)
		H.mind.AddSpell(summon_spell)
		to_chat(H, span_warning("Your connection with [marked_target] is now strong enough to summon them!"))

/datum/component/dreamwalker_mark/proc/on_target_death()
	SIGNAL_HANDLER
	to_chat(parent, span_warning("Your connection with [marked_target] has been severed by death."))
	set_marked_target(null)

/datum/component/dreamwalker_mark/proc/can_summon()
	if(!marked_target)
		return FALSE

	if(!marked_target.has_status_effect(/datum/status_effect/dream_mark))
		return FALSE

	if(world.time < mark_start_time + mark_minimum_duration)
		var/time_left = ((mark_start_time + mark_minimum_duration) - world.time) * 0.1
		to_chat(parent, span_warning("The mark is not stable yet. [time_left] seconds remaining."))
		return FALSE

	return TRUE

// Status effect for marked targets
/datum/status_effect/dream_mark
	id = "dream_mark"
	duration = 30 MINUTES // Increased to 30 minutes
	alert_type = /atom/movable/screen/alert/status_effect/dream_mark

/datum/status_effect/dream_mark/on_apply()
	to_chat(owner, span_userdanger("You feel your essence being pulled toward another realm. You've been marked by a dreamwalker!"))
	return TRUE

/datum/status_effect/dream_mark/on_remove()
	to_chat(owner, span_notice("The connection to the dream realm fades."))

/atom/movable/screen/alert/status_effect/dream_mark
	name = "Dream Marked"
	desc = "A dreamwalker has established a connection to your essence. They may attempt to summon you once the connection stabilizes."
	icon_state = "dream_mark"

/obj/item/ingot/sylveric
	name = "Sylveric ingot"
	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "ingotsylveric"
	desc = "An impossibly light metal that seems to grow harder and heavier when pressured. Nothing seems to be able to shape this metal."

// Add extra examine text for dreamwalkers
/obj/item/ingot/sylveric/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_DREAMWALKER))
		. += span_notice("You can feel the metal resonate with your dream energy. If you strike another sylveric ingot with this one, you can shape it into a weapon.")

// Handle attacking one sylveric ingot with another
/obj/item/ingot/sylveric/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/ingot/sylveric))
		if(!HAS_TRAIT(user, TRAIT_DREAMWALKER))
			return ..()

		// Check if both ingots are accessible
		if(I != user.get_active_held_item())
			return ..()

		if(!(src in user.contents) && !(isturf(src.loc) && in_range(src, user)))
			return ..()

		// Show weapon selection menu
		var/list/weapon_options = list(
			"Dreamreaver Greataxe" = image(icon = 'icons/roguetown/weapons/axes64.dmi', icon_state = "dreamaxeactive"),
			"Harmonious Spear" = image(icon = 'icons/roguetown/weapons/polearms64.dmi', icon_state = "dreamspearactive"),
			"Oozing Sword" = image(icon = 'icons/roguetown/weapons/swords64.dmi', icon_state = "dreamswordactive"),
			"Thunderous Trident" = image(icon = 'icons/roguetown/weapons/polearms64.dmi', icon_state = "dreamtriactive")
		)

		var/choice = show_radial_menu(user, src, weapon_options, require_near = TRUE, tooltips = TRUE)
		if(!choice)
			return

		to_chat(user, span_notice("You begin focusing your dream energy to shape the sylveric ingots into a [choice]..."))
		if(do_after(user, 10 SECONDS, target = src))
			var/obj/item/new_weapon
			switch(choice)
				if("Dreamreaver Greataxe")
					new_weapon = new /obj/item/rogueweapon/greataxe/dreamscape/active(user.loc)
				if("Harmonious Spear")
					new_weapon = new /obj/item/rogueweapon/halberd/glaive/dreamscape/active(user.loc)
				if("Oozing Sword")
					new_weapon = new /obj/item/rogueweapon/greatsword/bsword/dreamscape/active(user.loc)
				if("Thunderous Trident")
					new_weapon = new /obj/item/rogueweapon/spear/dreamscape_trident/active(user.loc)

			if(new_weapon)
				to_chat(user, span_notice("You shape the sylveric ingots into a [choice]."))
				user.put_in_hands(new_weapon)
				qdel(I)
				qdel(src)
		return
	return ..()

#undef PORTAL_PURSUIT_COOLDOWN
#undef PORTAL_PURSUIT_USES
