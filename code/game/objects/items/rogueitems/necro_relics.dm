/obj/item/necro_relics/necro_crystal
	name = "dark crystal"
	desc = "It feels cold in your hands. You shouldn't be holding this."
	icon = 'icons/roguetown/items/gems.dmi'
	icon_state = "necro_crystal"
	hitsound = 'sound/blank.ogg'
	dropshrink = 0.6
	var/last_use_time = 0
	var/use_cooldown = 300 // 30 seconds
	var/list/active_skeletons = list() //List of active skeletons stored here.
	var/max_summons = 2 //Maximum amount of skeletons that can be summoned at one time.
	var/max_charges = 2 //Maximum amount of charges the crystal can hold.
	var/current_charges = 2
	grid_height = 32
	grid_width = 32

/obj/item/necro_relics/necro_crystal/examine(mob/user)
	. = ..()
	if(current_charges > 0)
		. += span_notice("The crystal radiates with dark, brimming power.")
	else
		. += span_danger("The crystal lies hollow and inert, its magic drained.")

/obj/item/necro_relics/necro_crystal/Initialize()
	..()
	set_light(2, 2, 1, l_color = "#551c1c")

/obj/item/necro_relics/necro_crystal/proc/recharge(obj/item/reagent_containers/lux/L, mob/user)
	if(current_charges >= max_charges)
		to_chat(user, span_notice("The crystal is already brimming with power."))
		return FALSE

	qdel(L) // consume the lux
	current_charges = min(current_charges + 1, max_charges)
	to_chat(user, span_notice("The crystal hums as it drinks in the lyfe essence."))
	playsound(src, 'sound/magic/churn.ogg', 70, TRUE)
	return TRUE

/obj/item/necro_relics/necro_crystal/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/lux))
		return recharge(I, user)
	return ..()

/obj/item/necro_relics/necro_crystal/attack_self(mob/living/user)
	..()
	if(!user) 
		return FALSE
		
	if(length(active_skeletons) >= max_summons)
		to_chat(user, span_warning("The crystal emits an ominous thrumming. The power within is too strained to conjure another skeleton right now."))
		return FALSE

	if(world.time - src.last_use_time < src.use_cooldown)
		to_chat(user, span_warning("The crystal thrums under your touch, but remains inert."))
		return FALSE

	if(current_charges <= 0)
		to_chat(user, span_warning("The crystal feels hollow. It hungers for lux."))
		return FALSE

	// Ask the Necromancer for a task for the skeleton BEFORE the timer
	var/tasks = list("TOIL","FIGHT","GUARD","SEEK")
	var/tasks_choice = input(user, "WHAT IS THY BIDDING?", "IN HER NAME") as anything in tasks
	if(!tasks_choice)
		to_chat(user, span_warning("You must assign a task for your skeleton!"))
		return FALSE

	src.last_use_time = world.time

	if(!do_after(user, 60, src))
		to_chat(user, span_warning("You lose your concentration."))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_CABAL))
		to_chat(user, span_warning("The crystal rejects you! It shatters within your grasp!"))
		user.flash_fullscreen("redflash1")
		new /obj/item/natural/glass_shard(get_turf(src))
		playsound(src, "glassbreak", 70, TRUE)
		qdel(src)
		return FALSE

	var/turf/T = get_step(user, user.dir)
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	var/necro_name = user.real_name ? user.real_name : user.name
	var/list/candidates = pollGhostCandidates("The veil splits! A hand reaches forth! Serve [necro_name] in undeath as a Greater Skeleton? YOU WILL [tasks_choice]", ROLE_NECRO_SKELETON, null, null, 10 SECONDS, POLL_IGNORE_NECROMANCER_SKELETON)
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("The depths are hollow."))
		return FALSE

	var/mob/C = pick(candidates)
	if(!C || !istype(C, /mob/dead))
		return FALSE

	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/skeleton/no_equipment/target = new /mob/living/carbon/human/species/skeleton/no_equipment(T)
	target.crystal = WEAKREF(src)
	target.key = C.key
	current_charges--
	SSjob.EquipRank(target, "Greater Skeleton", TRUE)
	target.visible_message(span_warning("[target]'s eyes light up with an eerie glow!"))
	var/datum/weakref/W = WEAKREF(target)
	active_skeletons += W

	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "GREATER SKELETON"), 3 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)

	if(current_charges <= 0)
		to_chat(user, span_notice("The crystal dims, its power spent."))
	else
		to_chat(user, span_notice("The crystal's glow lessens. [current_charges] use\s remain."))

	user.flash_fullscreen("redflash1")
	playsound(src, "shatter", 50, TRUE)

	return TRUE

/mob/living/carbon/human/proc/choose_pronouns_and_body()
	var/p_input = input(src, "Choose your character's pronouns", "Pronouns") as anything in GLOB.pronouns_list
	if(p_input)
		src.pronouns = p_input
	if(alert(src, "Do you wish to change your frame?", "Body Type", "Yes", "No") == "Yes")
		src.gender = (src.gender == MALE) ? FEMALE : MALE
	src.regenerate_icons()

/obj/item/necro_relics/zskull
	name = "desecrated skull"
	desc = "It feels cold in your hands. You shouldn't be holding this."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "skull"
	hitsound = 'sound/blank.ogg'
	dropshrink = 0.6
	grid_width = 64
	grid_height = 32
	var/active = FALSE
	var/active_item = FALSE

/obj/item/necro_relics/zskull/attackby(obj/item/I, var/mob/living/U, params)
	var/mob/living/carbon/human/user = U
	if(user.used_intent?.blade_class == BCLASS_CUT && user.patron.type == /datum/patron/inhumen/zizo && active == FALSE) //Only Zizo
		playsound(get_turf(src.loc), 'sound/items/wood_sharpen.ogg', 100)
		user.visible_message(span_notice("[user] begins to carve a rune [src]."))
		if(do_after(user, 4 SECONDS))
			user.visible_message(span_notice("[user] carve a rune on [src]."))
			var/obj/item/necro_relics/zskull/active/S = new /obj/item/necro_relics/zskull/active(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(S)
			qdel(src)
			return
	..()

/obj/item/necro_relics/zskull/active
	name = "runic desecrated skull"
	icon_state = "zskull"
	active = TRUE
	active_item = FALSE
	var/component = /datum/magic_item/greater/invocation
	var/inv_type = null
	var/list/unlocked_spells = list()
	var/amethyst = FALSE
	var/toper = FALSE
	var/gemerald = FALSE
	var/saffira = FALSE
	var/blortz = FALSE
	var/rontz = FALSE

/obj/item/necro_relics/zskull/active/Initialize()
	. = ..()
	var/magiceffect= new component
	src.AddComponent(/datum/component/magic_item, magiceffect)

/datum/magic_item/greater/invocation
	var/active_item = FALSE
	description = ""
	var/power = 0
	var/inv_type = null
	var/skill = 0
	var/holy = 0
	var/arcane = 0

/obj/item/necro_relics/zskull/active/attackby(var/obj/item/roguegem/I, var/mob/living/user, params)
	if(istype(I, /obj/item/roguegem/amethyst) && !amethyst)
		unlocked_spells |= /obj/effect/proc_holder/spell/invoked/invocation
		amethyst = TRUE
		qdel(I)
	if(istype(I, /obj/item/roguegem/yellow) && !toper)
		unlocked_spells |= /obj/effect/proc_holder/spell/invoked/invocation/toper
		toper = TRUE
		qdel(I)
	if(istype(I, /obj/item/roguegem/green) && !gemerald)
		unlocked_spells |= /obj/effect/proc_holder/spell/invoked/invocation/gemerald
		gemerald = TRUE
		qdel(I)
	if(istype(I, /obj/item/roguegem/violet) && !saffira)
		unlocked_spells |= /obj/effect/proc_holder/spell/invoked/invocation/saffira
		saffira = TRUE
		qdel(I)
	if(istype(I, /obj/item/roguegem/blue) && !blortz)
		unlocked_spells |= /obj/effect/proc_holder/spell/invoked/invocation/blortz
		blortz = TRUE
		qdel(I)
	if(istype(I, /obj/item/roguegem/ruby) && !rontz)
		unlocked_spells |= /obj/effect/proc_holder/spell/invoked/invocation/rontz
		rontz = TRUE
		qdel(I)
	..()

/datum/magic_item/greater/invocation/on_use(var/obj/item/necro_relics/zskull/active/i, var/mob/living/user)
	if(/obj/effect/proc_holder/spell/invoked/invocation in i.unlocked_spells)
		if(power == 0)
			if(i.amethyst == TRUE)
				i.icon_state = "zskulla"
				inv_type = /obj/effect/proc_holder/spell/invoked/invocation
			else
				power++
		if(power == 1)
			if(i.toper == TRUE)
				i.icon_state = "zskullt"
				inv_type = /obj/effect/proc_holder/spell/invoked/invocation/toper
			else
				power++
		if(power == 2)
			if(i.gemerald == TRUE)
				i.icon_state = "zskulle"
				inv_type = /obj/effect/proc_holder/spell/invoked/invocation/gemerald
			else
				power++
		if(power == 3)
			if(i.saffira == TRUE)
				i.icon_state = "zskulls"
				inv_type = /obj/effect/proc_holder/spell/invoked/invocation/saffira
			else
				power++
		if(power == 4)
			if(i.blortz == TRUE)
				i.icon_state = "zskullg"
				inv_type = /obj/effect/proc_holder/spell/invoked/invocation/blortz
			else
				power++
		if(power == 5)
			if(i.rontz == TRUE)
				i.icon_state = "zskullr"
				inv_type = /obj/effect/proc_holder/spell/invoked/invocation/rontz
			else
				power++
		power++
		if(power > 5)
			power = 0
		if(inv_type in i.unlocked_spells)
			var/last_inv_type = i.inv_type
			i.inv_type = inv_type
			user.mind.AddSpell(new i.inv_type)
			user.mind.RemoveSpell(last_inv_type)
	. = ..()

/datum/magic_item/greater/invocation/on_equip(var/obj/item/necro_relics/zskull/active/i, var/mob/living/carbon/human/user, slot)
	holy = user.get_skill_level(/datum/skill/magic/holy)
	arcane = user.get_skill_level(/datum/skill/magic/arcane)
	skill = holy + arcane
	if(!slot == ITEM_SLOT_HANDS)
		return
	if(!i.inv_type)
		return
	if(active_item)
		return
	if(user.patron?.type != /datum/patron/inhumen/zizo) //only zizoplayer.
		if(skill <= 1) //Only devout-magos, necromancers or clerics.
			user.electrocute_act(75)
			if(user.is_holding(i))
				user.dropItemToGround(i)
	else
		active_item = TRUE
		user.mind.AddSpell(new i.inv_type)
		to_chat(user, span_notice("I feel the magick within [i] resonate with my own."))

/datum/magic_item/greater/invocation/on_drop(var/obj/item/necro_relics/zskull/active/i, var/mob/living/user)
	if(!i.inv_type)
		return
	if(active_item)
		active_item = FALSE
		for(var/obj/effect/proc_holder/spell/invoked/invocation/spell in user.mind?.spell_list)
			user.mind.RemoveSpell(spell)
		to_chat(user, span_notice("the warmth of [i] fades away."))
