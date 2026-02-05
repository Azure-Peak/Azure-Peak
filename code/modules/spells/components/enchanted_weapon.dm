#define DEFAULT_DURATION 15 MINUTES

// I nuked the former Searing Blade. Leaving 1 open for a future replacement

/* Component used for adding enchantment from the enchant weapon spell
 Three types of enchantments are available:
 1. Force Blade: Increases the force of the weapon by 5.
 2. Durability: Increases the integrity and max integrity of the weapon by 100.
 3. Arcane Mark: Applies a stack of Arcane Mark, 5 sec cd (ARCANE_MARK_COOLDOWN)
 The enchantment will lasts for 15 minutes, and will automatically refresh in the hand of an Arcyne user.
 There used to be a concept for a blade to set people on fire - but it was too broken if people didn't insta pat
*/

/datum/component/enchanted_weapon
	dupe_mode = COMPONENT_DUPE_UNIQUE // To avoid weird filter override this is the way..
	var/endtime = null // How long till the conjured item disappear (Don't use duration it is messed up)
	var/allow_refresh = TRUE // If TRUE, the item will refresh its duration when held by a X user
	var/refresh_skill = /datum/skill/magic/arcane // The skill that will be used to refresh the item
	var/overridden_duration = null
	var/enchant_type = FORCE_BLADE_ENCHANT // The type of enchantment
	var/next_arcane_mark_time = 0

/datum/component/enchanted_weapon/Initialize(duration_override, allow_refresh_override, refresh_skill_override, enchant_type_override)
	if(!istype(parent, /obj/item/rogueweapon))
		return COMPONENT_INCOMPATIBLE
	var/obj/item/I = parent

	var/new_duration = duration_override ? duration_override : DEFAULT_DURATION

	if(duration_override)
		endtime = world.time + duration_override
		overridden_duration = duration_override
	else
		endtime = world.time + DEFAULT_DURATION
	if(allow_refresh_override)
		allow_refresh = allow_refresh_override
	if(refresh_skill_override)
		refresh_skill = refresh_skill_override
	if(enchant_type_override)
		enchant_type = enchant_type_override
	apply_enchant(I)

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_OBJFIX, PROC_REF(on_fix))
	if(enchant_type == ARCANE_MARK_ENCHANT)
		RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(arcane_mark_afterattack))

	addtimer(CALLBACK(src, PROC_REF(refresh_check)), new_duration)

/datum/component/enchanted_weapon/proc/refresh_check()
	var/obj/item/I = parent
	var/obj/itemloc = I.loc
	if(!allow_refresh || !refresh_skill)
		remove()
		qdel(src)
		return
	if(!istype(itemloc, /mob/living))
		while(!istype(itemloc, /mob/living))
			if(isnull(itemloc))
				qdel(src)
				return // If the item is not in a mob, remove the refresh
			itemloc = itemloc.loc
			if(istype(itemloc, /turf))
				qdel(src)
				return // If the item is on the ground, remove the refresh
	var/mob/living/current_user = itemloc
	var/has_right_skill = current_user?.get_skill_level(refresh_skill)
	if(has_right_skill)
		if(overridden_duration)
			endtime = world.time + overridden_duration
			addtimer(CALLBACK(src, PROC_REF(refresh_check)), overridden_duration)
		else
			endtime = world.time + DEFAULT_DURATION
			addtimer(CALLBACK(src, PROC_REF(refresh_check)), DEFAULT_DURATION)
	else
		qdel(src)
		return

/datum/component/enchanted_weapon/proc/apply_enchant(var/obj/item/I, is_fix = FALSE)
	if(enchant_type == FORCE_BLADE_ENCHANT)
		I.force += FORCE_BLADE_FORCE
		I.force_wielded += FORCE_BLADE_FORCE
		I.update_force_dynamic()
		var/force_blade_filter = I.get_filter(FORCE_FILTER)
		if(!force_blade_filter)
			I.add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_DISPLACEMENT, "alpha" = 200, "size" = 1))
	else if(enchant_type == DURABILITY_ENCHANT)
		if(!is_fix) // Obj fix already increase durability.
			I.max_integrity += DURABILITY_INCREASE
			I.obj_integrity += DURABILITY_INCREASE
		var/durability_filter = I.get_filter(DURABILITY_FILTER)
		if(!durability_filter)
			I.add_filter(DURABILITY_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_METAL, "alpha" = 200, "size" = 1))
	else if(enchant_type == ARCANE_MARK_ENCHANT)
		var/mark_filter = I.get_filter(ARCANE_MARK_FILTER_WEAPON)
		if(!mark_filter)
			I.add_filter(ARCANE_MARK_FILTER_WEAPON, 2, list("type" = "outline", "color" = GLOW_COLOR_ARCANE, "alpha" = 200, "size" = 1))

// Called when the enchantment is removed
/datum/component/enchanted_weapon/proc/remove()
	var/obj/item/I = parent
	if(enchant_type == FORCE_BLADE_ENCHANT)
		I.force -= FORCE_BLADE_FORCE
		I.force_wielded -= FORCE_BLADE_FORCE
		I.remove_filter(FORCE_FILTER)
	else if(enchant_type == DURABILITY_ENCHANT)
		if(I.max_integrity != initial(I.max_integrity))
			I.max_integrity -= DURABILITY_INCREASE // Jank ass "temporary" fix I sure hope no one else modify max integrity
		I.obj_integrity = min(I.obj_integrity, I.max_integrity - DURABILITY_INCREASE)
		I.remove_filter(DURABILITY_FILTER)
	else if(enchant_type == (ARCANE_MARK_ENCHANT))
		I.remove_filter(ARCANE_MARK_FILTER_WEAPON)
	else
		return

/datum/component/enchanted_weapon/Destroy()
	remove()
	. = ..()

/datum/component/enchanted_weapon/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(enchant_type == FORCE_BLADE_ENCHANT)
		examine_list += "This weapon is enchanted with a force blade enchantment."
	else if(enchant_type == DURABILITY_ENCHANT)
		examine_list += "This weapon is enchanted with a durability enchantment."
	else if(enchant_type == ARCANE_MARK_ENCHANT)
		examine_list += "This weapon is enchanted with an Arcane Mark enchantment."
	var/remaining_minutes = round((endtime - world.time) / 600)
	examine_list += "The enchantment will last for [remaining_minutes] more minutes."

// This is called right after the object is fixed and all of its force / wdefense values are reset to initial. We re-apply the relevant bonuses.
/datum/component/enchanted_weapon/proc/on_fix()
	var/obj/item/I = parent
	apply_enchant(I, TRUE)

//special snowflake arcane mark proc grahhh
/datum/component/enchanted_weapon/proc/arcane_mark_afterattack(obj/item/source, atom/target, mob/user, click_parameters)

	SIGNAL_HANDLER
	if(world.time < next_arcane_mark_time)
		return
	if(!ismob(target))
		return
	var/mob/living/L = target
	if(istype(L, /mob/living/carbon))
		apply_arcane_mark(L)
		playsound(get_turf(L), 'sound/magic/clang.ogg', 100)
		next_arcane_mark_time = world.time + ARCANE_MARK_COOLDOWN

#undef DEFAULT_DURATION
