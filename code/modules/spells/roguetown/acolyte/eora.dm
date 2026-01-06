//Eora content from Stonekeep

/obj/item/clothing/head/peaceflower
	name = "eoran bud"
	desc = "A flower of gentle petals, associated with Eora or Necra. Usually adorned as a headress or laid at graves as a symbol of love or peace."
	icon = 'icons/roguetown/items/produce.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	icon_state = "peaceflower"
	item_state = "peaceflower"
	dropshrink = 0.9
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	dynamic_hair_suffix = ""
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/clothing/head/peaceflower/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_HEAD || slot == SLOT_WEAR_MASK)
		ADD_TRAIT(user, TRAIT_PACIFISM, "peaceflower_[REF(src)]")

/obj/item/clothing/head/peaceflower/dropped(mob/living/carbon/human/user)
	..()
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "peaceflower_[REF(src)]")

/obj/item/clothing/head/peaceflower/proc/peace_check(mob/living/user)
	// return true if we should be unequippable, return false if not
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head || src == C.wear_mask)
			to_chat(user, "<span class='warning'>I feel at peace. <b style='color:pink'>Why would I want anything else?</b></span>")
			return TRUE
	return FALSE

/obj/item/clothing/head/peaceflower/MouseDrop(atom/over_object)
	if (!peace_check(usr))
		return ..()

/obj/item/clothing/head/peaceflower/attack_hand(mob/user)
	if (!peace_check(user))
		return ..()

/obj/effect/proc_holder/spell/invoked/bud
	name = "Eoran Bloom"
	desc = "Tries to grow an Eoran bud on the target tile or on the targets head, forcing their thoughts away from violence until removed."
	clothes_req = FALSE
	range = 7
	overlay_state = "love"
	sound = list('sound/magic/magnet.ogg')
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	releasedrain = 40
	chargetime = 60
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	recharge_time = 60 SECONDS

/obj/effect/proc_holder/spell/invoked/bud/cast(list/targets, mob/living/user)
	var/target = targets[1]
	if(istype(target, /mob/living/carbon/human)) //Putting flower on head check
		var/mob/living/carbon/human/C = target
		if(!C.get_item_by_slot(SLOT_HEAD))
			var/obj/item/clothing/head/peaceflower/F = new(get_turf(C))
			C.equip_to_slot_if_possible(F, SLOT_HEAD, TRUE, TRUE)
			to_chat(C, "<span class='info'>A flower of Eora blooms on my head. <b style='color:pink'> I feel at peace. </b></span>")
			return TRUE
		else if(!C.get_item_by_slot(SLOT_WEAR_MASK))
			var/obj/item/clothing/head/peaceflower/F = new(get_turf(C))
			C.equip_to_slot_if_possible(F, SLOT_WEAR_MASK, TRUE, TRUE)
			to_chat(C, "<span class='info'>A flower of Eora blooms on my head. <b style='color:pink'> I feel at peace. </b></span>")
			return TRUE
		else
			to_chat(user, "<span class='warning'>The target's head and face are covered. The flowers of Eora need an open space to bloom.</span>")
			revert_cast()
			return FALSE
	var/turf/T = get_turf(targets[1])
	if(!isclosedturf(T))
		new /obj/item/clothing/head/peaceflower(T)
		return TRUE
	to_chat(user, "<span class='warning'>The targeted location is blocked. The flowers of Eora refuse to grow.</span>")
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/eoracurse
	name = "Eora's Curse"
	desc = "Makes the target both high and drunk."
	overlay_state = "curse2"
	releasedrain = 50
	chargetime = 30
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/whiteflame.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = FALSE

/obj/effect/proc_holder/spell/invoked/eoracurse/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		target.apply_status_effect(/datum/status_effect/buff/druqks)
		target.apply_status_effect(/datum/status_effect/buff/drunk)
		target.visible_message("<span class='info'>A purple haze shrouds [target]!</span>", "<span class='notice'>I feel much calmer.</span>")
		//target.blur_eyes(10)
		return TRUE
	revert_cast()
	return FALSE

// =====================
// Eora Bond Component
// =====================
/datum/component/eora_bond
	var/mob/living/carbon/partner
	var/mob/living/carbon/caster
	var/duration = 900 SECONDS
	var/max_distance = 7
	var/damage_share = 0.4
	var/heal_share = 0.4
	var/wound_chance = 15
	var/ispartner = FALSE
	can_transfer = TRUE

/datum/component/eora_bond/partner
	ispartner = TRUE

/datum/component/eora_bond/Initialize(mob/living/partner_mob, mob/living/caster_mob, var/holy_skill)
	if(!isliving(parent) || !isliving(partner_mob))
		return COMPONENT_INCOMPATIBLE

	// Prevent duplicate bonds
	var/datum/component/eora_bond/existing = parent.GetComponent(/datum/component/eora_bond)
	if(existing)
		return COMPONENT_INCOMPATIBLE

	partner = partner_mob
	caster = caster_mob

	var/bonus_mod = 0
	if(holy_skill >= 4)
		bonus_mod = 0.05
	damage_share = 0.1 + (0.05 * holy_skill) + bonus_mod
	heal_share = 0.1 + (0.05 * holy_skill) + bonus_mod
	wound_chance = 40 - (5 * holy_skill)

	// Correct signal name
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damage))
	RegisterSignal(parent, COMSIG_LIVING_MIRACLE_HEAL_APPLY, PROC_REF(on_heal))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_deletion))

	START_PROCESSING(SSprocessing, src)
	addtimer(CALLBACK(src, .proc/remove_bond), duration)

	var/mob/living/L = parent
	L.apply_status_effect(/datum/status_effect/eora_bond)
	return ..()

/datum/component/eora_bond/proc/on_damage(datum/source, damage, damagetype, def_zone)
	if( !isliving(partner) || !ispartner)
		return

	var/mob/living/carbon/L = caster
	var/shared_damage = damage * damage_share

	if(damagetype == BRUTE)
		//Heal our buddy <3
		var/list/wCount = partner.get_wounds()
		if(wCount.len > 0)
			partner.heal_wounds(shared_damage)
			partner.update_damage_overlays()
		partner.adjustBruteLoss(-shared_damage, 0)

		var/obj/item/bodypart/BP = null
		BP = L.get_bodypart(check_zone(def_zone))
		if(!BP)
			BP = L.get_bodypart(BODY_ZONE_CHEST)
		BP.receive_damage(shared_damage, 0)
		L.update_damage_overlays()
		//Potentially bite ourselves :(
		if(prob(wound_chance))
			L.visible_message(span_danger("[L]'s wounds bleed profusely!"))
			BP.add_wound(/datum/wound/bite/small)

/datum/component/eora_bond/proc/on_heal(datum/source, healing_on_tick, healing_datum)
	if( !isliving(parent) || source != parent || istype(healing_datum, /datum/status_effect/buff/healing/eora) || HAS_TRAIT(parent, TRAIT_PSYDONITE))
		return

	healing_on_tick = healing_on_tick * heal_share
	var/mob/living/target_to_heal
	if(parent == caster)
		target_to_heal = partner
	else
		target_to_heal = caster

	target_to_heal.apply_status_effect(/datum/status_effect/buff/healing/eora, healing_on_tick)

/datum/component/eora_bond/proc/on_deletion()
	remove_bond()

/datum/component/eora_bond/process()
	//If this turns out to be too costly, make this based on the movement signal instead.
	var/mob/living/M = parent
	if(!istype(M) || !istype(partner) || M.stat == DEAD || partner.stat == DEAD || get_dist(M, partner) > max_distance)
		remove_bond()

/datum/component/eora_bond/proc/remove_bond()
	var/mob/living/L = parent
	if(L)
		L.remove_status_effect(/datum/status_effect/eora_bond)
		UnregisterSignal(L, list(
			COMSIG_MOB_APPLY_DAMGE,
			COMSIG_LIVING_MIRACLE_HEAL_APPLY,
			COMSIG_PARENT_QDELETING
		))

	if(partner)
		partner.remove_status_effect(/datum/status_effect/eora_bond)
		var/datum/component/eora_bond/other = partner.GetComponent(/datum/component/eora_bond)
		if(other)
			other.partner = null
			qdel(other)

	partner = null
	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

/datum/status_effect/buff/healing/eora

// =====================
// Heartweave Spell
// =====================
/obj/effect/proc_holder/spell/invoked/heartweave
	name = "Heartweave"
	desc = "Forge a symbiotic bond between two souls."
	overlay_state = "bliss"
	range = 1
	chargetime = 0.5 SECONDS
	invocations = list("By Eora's grace, let our fates intertwine!")
	sound = 'sound/magic/magnet.ogg'
	recharge_time = 60 SECONDS
	miracle = TRUE
	devotion_cost = 75
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/heartweave/cast(list/targets, mob/living/user)
	var/mob/living/target = targets[1]

	var/datum/component/eora_bond/existing = user.GetComponent(/datum/component/eora_bond)
	if(existing)
		to_chat(user, span_warning("You are already bonded!"))
		revert_cast()
		return FALSE

	if(!istype(target, /mob/living/carbon) || target == user)
		revert_cast()
		return FALSE

	if(!do_after(user, 2 SECONDS, target = target))
		to_chat(user, span_warning("The bond requires focused concentration!"))
		revert_cast()
		return FALSE

	var/consent = alert(target, "[user] offers a lifebond. Accept?", "Heartweave", "Yes", "No")
	if(consent != "Yes" || QDELETED(target))
		to_chat(user, span_warning("The bond was rejected."))
		revert_cast()
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	// Add component to both participants without mutual recursion
	user.AddComponent(/datum/component/eora_bond, target, user, holy_skill)
	target.AddComponent(/datum/component/eora_bond/partner, target, user, holy_skill)

	user.visible_message(
		span_notice("A golden tether forms between [user] and [target]!"),
		span_notice("You feel [target]'s life force linked to yours.")
	)
	return TRUE

// =====================
// Status Effect
// =====================

#define HEARTWEAVE_FILTER "heartweave"

/datum/status_effect/eora_bond
	id = "eora_bond"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/eora_bond
	var/outline_colour = "#FF69B4"

/atom/movable/screen/alert/status_effect/eora_bond
	name = "Eora's Bond"
	desc = "Your life force is linked to another soul."

/datum/status_effect/eora_bond/on_apply()
	var/filter = owner.get_filter(HEARTWEAVE_FILTER)
	if (!filter)
		owner.add_filter(HEARTWEAVE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 2))
	return TRUE

/datum/status_effect/eora_bond/on_remove()
	owner.remove_filter(HEARTWEAVE_FILTER)

#define BLESSED_FOOD_FILTER "blessedfood"

/datum/component/blessed_food
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/caster
	var/quality
	var/skill
	var/bitesize_mod
	// I hate this but let's be consistent.
	var/datum/patron/patron

/datum/component/blessed_food/Initialize(mob/living/_caster, var/holy_skill, var/patron_init)
	if(!isitem(parent) || !istype(parent, /obj/item/reagent_containers/food/snacks))
		return COMPONENT_INCOMPATIBLE

	caster = _caster
	skill = holy_skill
	var/obj/item/reagent_containers/food/snacks/F = parent
	//Better food being blessed heals more
	quality = F.faretype
	bitesize_mod = 1 / F.bitesize
	patron = patron_init
	F.faretype = clamp(skill, 1, 5)
	if(skill < 5 || patron.type != /datum/patron/divine/eora)
		F.add_filter(BLESSED_FOOD_FILTER, 1, list("type" = "outline", "color" = "#ff00ff", "size" = 1))
	else
		F.add_filter(BLESSED_FOOD_FILTER, 1, list("type" = "outline", "color" = "#f0b000", "size" = 1))
	RegisterSignal(F, COMSIG_FOOD_EATEN, .proc/on_food_eaten)

/datum/component/blessed_food/proc/on_food_eaten(datum/source, mob/living/eater, mob/living/feeder)
	SIGNAL_HANDLER
	if(eater == caster)
		eater.visible_message(span_notice("The divine energy fizzles harmlessly around [caster]."))
		return

	eater.apply_status_effect(/datum/status_effect/buff/healing, (quality + (skill / 5)) * bitesize_mod)
	if(skill > 4 && patron.type == /datum/patron/divine/eora)
		eater.apply_status_effect(/datum/status_effect/buff/haste, 15 SECONDS)

/obj/effect/proc_holder/spell/invoked/bless_food
	name = "Bless Food"
	invocations = list("Eora, nourish this offering!")
	desc = "Bless a food item. Items that take longer to eat heal slower. Skilled clergy can bless food more often. Finer food heals more. Eoran masters can make food a golden hue."
	sound = 'sound/magic/magnet.ogg'
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	devotion_cost = 25
	recharge_time = 90 SECONDS
	overlay_state = "bread"
	associated_skill = /datum/skill/magic/holy
	var/base_recharge_time = 90 SECONDS

/obj/effect/proc_holder/spell/invoked/bless_food/cast(list/targets, mob/living/user)
	var/obj/item/target = targets[1]
	if(!istype(target, /obj/item/reagent_containers/food/snacks))
		to_chat(user, span_warning("You can only bless food!"))
		revert_cast()
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	var/mob/living/carbon/human/H = user
	var/patron = FALSE
	if(ishuman(H))
		patron = user.patron
	target.AddComponent(/datum/component/blessed_food, user, holy_skill, patron)
	to_chat(user, span_notice("You bless [target] with Eora's love!"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/bless_food/start_recharge()
	if(ranged_ability_user)
		var/holy_skill = ranged_ability_user.get_skill_level(associated_skill)
		// Reduce recharge by 6 seconds per skill level
		var/skill_reduction = (6 SECONDS) * holy_skill
		recharge_time = base_recharge_time - skill_reduction
		// Ensure recharge doesn't go below 0
		if(recharge_time < 0)
			recharge_time = 0
	else
		recharge_time = base_recharge_time

/obj/effect/proc_holder/spell/invoked/pomegranate
	name = "Amaranth Sanctuary"
	invocations = list("Eora, provide sanctuary for your beauty!")
	desc = "Grow a pomegrenate tree that when tended to grows Aurils with variety of effects. Additionally heals beatiful people and HEAVILY debuffs both STR and PER for everyone in visible range."
	sound = 'sound/magic/magnet.ogg'
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	devotion_cost = 500
	recharge_time = 5 SECONDS
	chargetime = 1 SECONDS
	overlay_state = "tree"
	associated_skill = /datum/skill/magic/holy
	var/obj/structure/eoran_pomegranate_tree/my_little_tree = null

/obj/effect/proc_holder/spell/invoked/pomegranate/cast(list/targets, mob/living/user)
	. = ..()

	if(QDELETED(my_little_tree))
		my_little_tree = null

	if(my_little_tree)
		to_chat(user, span_warning("I cannot maintain more than a single tree for Eora. I must get rid of the other first, however painful."))
		revert_cast()
		return FALSE

	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. Eora's seed cannot sprout here."))
		revert_cast()
		return FALSE
	if(!(istype(T, /turf/open/floor/rogue/grass) || istype(T, /turf/open/floor/rogue/dirt)))
		to_chat(user, span_warning("The tree cannot grow here. It must be planted on dirt or grass!"))
		revert_cast()
		return FALSE

	to_chat(user, span_notice("I begin growing Eora's sacred tree here. I should stop and reconsider if I don't want my only tree here."))
	if(do_after(user, 30 SECONDS, FALSE))
		var/obj/structure/eoran_pomegranate_tree/tree = new /obj/structure/eoran_pomegranate_tree(T)
		my_little_tree = tree
		return TRUE

#define SPROUT 0
#define GROWING 1
#define MATURING 2
#define FRUITING 3

/obj/structure/eoran_pomegranate_tree
	name = "pomegranate tree"
	desc = "A mystical tree blessed by Eora."
	icon = 'icons/obj/items/eora_tree.dmi'
	icon_state = "sprout"
	anchored = TRUE
	density = TRUE
	max_integrity = 200
	resistance_flags = FIRE_PROOF
	pixel_x = -8

	// Growth tracking
	var/growth_stage = SPROUT
	var/growth_progress = 0
	var/growth_threshold = 100
	var/time_to_mature = 10 MINUTES // Total time from sprout 0% to fully grown 100% through GROWING stage
	var/time_to_grow_fruit = 6 MINUTES //Fairly long but these fruits are potentially really good and there can be multiple acolytes
	var/fruit = FALSE
	var/fruit_ready = FALSE

	// Tree care system
	var/happiness = 0
	var/water_happiness = 0
	var/fertilizer_happiness = 0
	var/prune_count = 0
	var/list/tree_offerings = list()
	var/happiness_tier = 1

	/// Range of the aura
	var/aura_range = 7
	/// List of mobs currently affected by our aura
	var/list/mob/living/affected_mobs = list()
	var/ash_offered = FALSE
	var/ash_effect_start_time = 0
	var/creation_time
	var/fruit_doubled = FALSE

/obj/structure/eoran_pomegranate_tree/proc/get_farming_skill(mob/user)
	return user.get_skill_level(/datum/skill/labor/farming)

/obj/structure/eoran_pomegranate_tree/proc/update_happiness_tier()
	if(happiness >= 100)
		happiness_tier = 4
	else if(happiness >= 75)
		happiness_tier = 3
	else if(happiness >= 50)
		happiness_tier = 2
	else
		happiness_tier = 1

/obj/structure/eoran_pomegranate_tree/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ash))
		if(iscarbon(user))
			var/mob/living/carbon/c = user
			if(c.patron.type != /datum/patron/divine/eora)
				to_chat(user, span_warning("The tree rejects your offering. Only followers of Eora may offer ash."))
				return TRUE
		if(ash_offered)
			to_chat(user, span_warning("Covering the tree in additional ash seems to anger it, leaves flare out and the ash flutters to the floor. The aura is renewed."))
			qdel(I)
			ash_offered = FALSE
			aura_range = 7
			return TRUE

		qdel(I)
		ash_offered = TRUE
		ash_effect_start_time = world.time
		to_chat(user, span_notice("The tree shudders as you coats its leaves in ash. The leaves seem to wilt ever so slightly whilst its aura starts to wane."))
		update_icon()
		return TRUE

	if(istype(I, /obj/item/rogueweapon/huntingknife/scissors))
		if(prune_count >= 4)
			to_chat(user, span_warning("The tree has been fully pruned already!"))
			return TRUE
		var/skill = get_farming_skill(user)
		var/prune_time = 25 SECONDS - (skill * 3.5 SECONDS)

		to_chat(user, span_notice("You begin pruning the tree..."))

		if(do_after(user, prune_time, target = src))
			prune_count++
			happiness = min(happiness + 5, 100)
			update_happiness_tier()
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				add_sleep_experience(user, /datum/skill/labor/farming, C.STAINT * 0.5)
			
			to_chat(user, span_notice("You prune some branches."))
			update_icon()
			return TRUE

	if(istype(I, /obj/item/reagent_containers) && !istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/container = I
		if(water_happiness >= 25)
			to_chat(user, span_warning("The tree can't absorb any more water right now!"))
			return TRUE

		var/has_water = FALSE
		if(container.reagents.has_reagent(/datum/reagent/water, 1))
			has_water = TRUE

		if(!has_water)
			to_chat(user, span_warning("The tree accepts only fresh, clean water."))
			return

		var/remaining_cap = 25 - water_happiness
		var/skill = get_farming_skill(user)
		var/potential_gain = 5 + (skill * 4)  // 5 at skill 0, 25 at skill 5+
		var/actual_gain = min(potential_gain, remaining_cap)
		var/action_time = 5 SECONDS - (skill * 0.5 SECONDS)

		if(do_after(user, action_time, target = src))
			container.reagents.remove_reagent(/datum/reagent/water, 1)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				add_sleep_experience(user, /datum/skill/labor/farming, C.STAINT * 0.5)

			water_happiness += actual_gain
			happiness = min(happiness + actual_gain, 100)
			update_happiness_tier()

			to_chat(user, span_notice("You water the tree."))
			update_icon()
			return TRUE

	if(istype(I, /obj/item/compost) || istype(I, /obj/item/fertilizer))

		if(fertilizer_happiness >= 25)
			to_chat(user, span_warning("The tree can't absorb any more nutrients right now!"))
			return TRUE

		var/remaining_cap = 25 - fertilizer_happiness
		var/skill = get_farming_skill(user)
		var/potential_gain = 5 + (skill * 4)
		var/actual_gain = min(potential_gain, remaining_cap)
		var/action_time = 5 SECONDS - (skill * 0.5 SECONDS)

		if(do_after(user, action_time, target = src))
			qdel(I)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				add_sleep_experience(user, /datum/skill/labor/farming, C.STAINT * 0.5)

			fertilizer_happiness += actual_gain
			happiness = min(happiness + actual_gain, 100)
			update_happiness_tier()

			to_chat(user, span_notice("You fertilize the tree."))
			update_icon()
			return TRUE

	if(istype(I, /obj/item/roguegem/ruby) || istype(I, /obj/item/alch/transisdust) || istype(I, /obj/item/reagent_containers/food/snacks/eoran_aril/opalescent))

		if(I.type in tree_offerings)
			to_chat(user, span_warning("This object has already been offered to the tree!"))
			return TRUE

		if(length(tree_offerings) >= 3)
			to_chat(user, span_warning("The tree has received enough offerings for now!"))
			return TRUE

		qdel(I)
		tree_offerings += I.type
		
		happiness = min(happiness + 10, 100)
		update_happiness_tier()

		to_chat(user, span_notice("The tree accepts your offering gracefully with a flutter of its leaves."))
		update_icon()
		return TRUE

	var/was_destroyed = obj_destroyed
	. = ..()
	if(.)
		if(!was_destroyed && obj_destroyed)
			if(iscarbon(user))
				var/mob/living/carbon/c = user
				if(c.patron.type == /datum/patron/divine/eora)
					c.apply_status_effect(/datum/status_effect/debuff/eoran_wilting)
				else
					to_chat(c, span_warning("A divine curse strikes you for destroying the sacred tree!"))
					c.adjustFireLoss(100)
					c.ignite_mob()
					c.add_stress(/datum/stressevent/psycurse)
			record_featured_stat(FEATURED_STATS_TREE_FELLERS, user)
			record_round_statistic(STATS_TREES_CUT)

/obj/structure/eoran_pomegranate_tree/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armor_penetration = 0)
	if(ash_offered)
		ash_offered = FALSE
		aura_range = 7
		visible_message(span_notice("The tree shudders as it is harmmed, ash previously covering the leaves is shaken off, and the aura ignites once more."))
	else
		visible_message(span_notice("The tree shudders as it is harmed. You feel dread emanating from it."))
	. = ..()

/obj/structure/eoran_pomegranate_tree/examine(mob/user)
	. = ..()
	if(!ash_offered)
		. += span_warning("The leaves emit a bright weakening aura, perhaps covering them with ash can prevent this.")
	else
		. += span_warning("The leaves are ashen and dampened, emitting no aura. Perhaps more ash can fix this somehow.")

	if(happiness_tier == 1)
		. += span_warning("The tree seems neglected. Branches are wilted.")
	else if(happiness_tier == 2)
		. += span_info("The tree appears content and healthy.")
	else if(happiness_tier == 3)
		. += span_good("The tree radiates vibrant energy.")
	else if(happiness_tier == 4)
		. += span_good("The tree bustles with an incandescent light. You feel... perfection.")

	if(water_happiness < 25)
		. += span_info("It could use more water.")
	else
		. += span_info("It is fully slaked.")

	if(fertilizer_happiness < 25)
		. += span_info("The roots could use more nutrients.")
	else
		. += span_info("It is fully sated.")

	if(prune_count < 4)
		. += span_info("The branches look messy. Perhaps a scissor can right this mess.")
	else
		. += span_info("The branches are elaborately pruned.")

	if(length(tree_offerings) < 3)
		. += span_info("The tree yearns for an offering. Whispers enter your mind. A red crystal that shimmers... Something that sculpts one's form... A glittering seed...")

/obj/structure/eoran_pomegranate_tree/proc/reset_care()
	//The benefit of rare offerings are kept through harvests.
	happiness = 0 + (10 * length(tree_offerings))
	water_happiness = 0
	fertilizer_happiness = 0
	prune_count = 0
	update_happiness_tier()
	update_icon()

/obj/structure/eoran_pomegranate_tree/Initialize(mapload)
	. = ..()
	update_icon()
	START_PROCESSING(SSobj, src)
	creation_time = world.time

/obj/structure/eoran_pomegranate_tree/process(delta_time)
	var/delta_seconds = delta_time / 10 // Convert delta_time (ticks) to seconds Delta time is the amount of time that has passed since the last time process was called.

	var/target_growth_rate_per_second = 0

	if(ash_offered)
		var/time_since_ash = world.time - ash_effect_start_time
		if(time_since_ash >= 30 SECONDS)
			aura_range = 0
		else if(time_since_ash >= 15 SECONDS)
			aura_range = round(aura_range / 2)

	if(!fruit_doubled && (world.time - creation_time) >= 40 MINUTES)
		fruit_doubled = TRUE
		visible_message(span_notice("The tree has matured and now bears more fruit!"))

	if(growth_progress >= 50)
		var/list/current_mobs = list()
		var/atom/A = src

	// Get all mobs in range
		var/list/mobs_in_range
		mobs_in_range = view(aura_range, A)

		for(var/mob/living/L in mobs_in_range)
			//Unconscious people can't harm others. Nor can they observe trees. Dead people are food.
			if(L.stat == UNCONSCIOUS)
				continue
			current_mobs += L

			// Apply effects if new mob
			if(!affected_mobs[L])
				apply_effects(L)
				affected_mobs[L] = TRUE

		// Remove effects from mobs that left range
		for(var/mob/living/L in affected_mobs - current_mobs)
			remove_effects(L)
			affected_mobs -= L

	if (growth_stage == FRUITING && !fruit)
		// We need to grow from 75% to 100% in time_to_grow_fruit
		var/progress_needed_in_fruiting = growth_threshold * 0.25

		if (time_to_grow_fruit > 0)
			target_growth_rate_per_second = progress_needed_in_fruiting / (time_to_grow_fruit / 10)
		else
			target_growth_rate_per_second = growth_threshold // Grow instantly if time is 0
	else
		if (time_to_mature > 0)
			target_growth_rate_per_second = growth_threshold / (time_to_mature / 10)
		else
			target_growth_rate_per_second = growth_threshold // Grow instantly if time is 0

	growth_progress = min(growth_progress + (target_growth_rate_per_second * delta_seconds), growth_threshold)

	check_growth_stage()

/obj/structure/eoran_pomegranate_tree/proc/apply_effects(mob/living/target)
	target.apply_status_effect(/datum/status_effect/debuff/pomegranate_aura, src)

/obj/structure/eoran_pomegranate_tree/proc/remove_effects(mob/living/target)
	target.remove_status_effect(/datum/status_effect/debuff/pomegranate_aura)

/obj/structure/eoran_pomegranate_tree/proc/check_growth_stage()
	switch(growth_stage)
		if(SPROUT)
			if(growth_progress >= 25)
				advance_stage(GROWING)
		if(GROWING)
			if(growth_progress >= 50)
				advance_stage(MATURING)
		if(MATURING)
			if(growth_progress >= 75)
				advance_stage(FRUITING)
		if(FRUITING)
			if(!fruit && growth_progress >= growth_threshold)
				spawn_fruit()

/obj/structure/eoran_pomegranate_tree/proc/advance_stage(new_stage)
	growth_stage = new_stage
	update_icon()
	visible_message(span_notice("The [name] grows larger!"))

	if(new_stage == FRUITING)
		spawn_fruit()

/obj/structure/eoran_pomegranate_tree/proc/spawn_fruit()
	if(fruit)  // Already has fruit
		return

	fruit = TRUE
	fruit_ready = FALSE
	update_icon()
	addtimer(CALLBACK(src, .proc/ripen_fruit), rand(10 SECONDS, 15 SECONDS))

/obj/structure/eoran_pomegranate_tree/proc/ripen_fruit()
	fruit_ready = TRUE
	visible_message(span_notice("The fruit on [src] glows with a warm light!"))
	update_icon()

/obj/structure/eoran_pomegranate_tree/update_icon()
	// Base icon states
	switch(growth_stage)
		if(SPROUT)
			icon_state = "sprout"
		if(GROWING)
			icon_state = "growing"
		if(MATURING)
			icon_state = "mature"
		if(FRUITING)
			icon_state = "fruiting"

	cut_overlays()

	if(growth_stage == FRUITING && fruit_ready)
		var/image/fruit_image = image(icon = initial(icon), icon_state = "fruit[happiness_tier]", layer = 1)
		add_overlay(fruit_image)

	. = ..()

/datum/status_effect/pomegranate_fatigue
	id = "pom_fatigue"
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/pomegranate_fatigue

/datum/status_effect/pomegranate_fatigue/on_apply()
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_SANITY, update=TRUE, priority=100, override=FALSE, multiplicative_slowdown=0.5)

/datum/status_effect/pomegranate_fatigue/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_SANITY)
	return ..()

/atom/movable/screen/alert/status_effect/pomegranate_fatigue
	name = "Divine Fatigue"
	desc = "The sacred energy of the pomegranate leaves you weakened."

/obj/structure/eoran_pomegranate_tree/attack_hand(mob/living/user)
	if(!fruit_ready || !fruit)
		return ..()

	if(!can_pick_fruit(user))
		return

	user.visible_message(
		span_notice("[user] carefully picks the fruit."),
		span_notice("You gently pick the glowing pomegranate.")
	)

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		add_sleep_experience(user, /datum/skill/labor/farming, C.STAINT * 3)
	var/obj/item/fruit_of_eora/new_fruit = new(user.loc, happiness_tier, fruit_doubled)
	user.put_in_hands(new_fruit)

	// Apply picking debuff
	user.apply_status_effect(/datum/status_effect/pomegranate_fatigue)

	// Reset tree
	fruit = FALSE
	fruit_ready = FALSE
	growth_progress = 75 // Return to fruiting stage baseline
	reset_care()
	update_icon()

// Check if user can pick fruit
/obj/structure/eoran_pomegranate_tree/proc/can_pick_fruit(mob/living/user)
	if(!fruit_ready)
		to_chat(user, span_warning("The fruit isn't ripe yet!"))
		return FALSE

	// Eoran alignment check
	if(!(user.patron.type == /datum/patron/divine/eora) && !HAS_TRAIT(user, TRAIT_CHOSEN))
		to_chat(user, span_warning("The fruit vanishes as you reach for it!"))
		return FALSE

	return TRUE

/obj/item/fruit_of_eora
	name = "pomegranate"
	desc = "A mystical pomegranate glowing with inner light. It feels warm to the touch."
	icon = 'icons/obj/items/eora_pom.dmi'
	icon_state = "pom"
	var/fruit_tier = 1
	var/list/aril_types = list()
	var/opened = FALSE
	var/fruit_doubled = FALSE

/obj/item/fruit_of_eora/Initialize(mapload, tier = 1, doubled = FALSE)
	. = ..()
	fruit_tier = tier
	fruit_doubled = doubled
	generate_arils()
	update_pom()

/obj/item/fruit_of_eora/proc/update_pom()
	switch(fruit_tier)
		if(1)
			name = "rotten pomegranate"
			desc = "A rotten pomegranate."
			icon_state = "rotten"
		if(2)
			name = "blemished pomegranate"
			desc = "A blemished pomegranate, it's blue like azure."
			icon_state = "blemished"
		if(3)
			desc = "A vibrant pomegranate pulsing with inner light. It radiates warmth."
			icon_state = "pom"
		if(4)
			name = "golden pomegranate"
			desc = "A flawless golden pomegranate blazing with divine light. It feels alive, thumping like a beating heart."
			icon_state = "golden"

/obj/item/fruit_of_eora/proc/generate_arils()
	aril_types = list()
	var/list/possible_arils

	// Define aril tables by tier
	switch(fruit_tier)
		if(1)
			return
		if(2)
			possible_arils = list(
				/obj/item/reagent_containers/food/snacks/eoran_aril/crimson = 50,
				/obj/item/reagent_containers/food/snacks/eoran_aril/roseate = 10,
				/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent = 20
			)
		if(3)
			possible_arils = list(
				/obj/item/reagent_containers/food/snacks/eoran_aril/crimson = 30,
				/obj/item/reagent_containers/food/snacks/eoran_aril/roseate = 10,
				/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent = 20,
				/obj/item/reagent_containers/food/snacks/eoran_aril/pearlescent = 20,
				/obj/item/reagent_containers/food/snacks/eoran_aril/cerulean = 20,
				/obj/item/reagent_containers/food/snacks/eoran_aril/fractal = 5
			)
		if(4)
			possible_arils = list(
				/obj/item/reagent_containers/food/snacks/eoran_aril/crimson = 15,
				/obj/item/reagent_containers/food/snacks/eoran_aril/roseate = 5,
				/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent = 10,
				/obj/item/reagent_containers/food/snacks/eoran_aril/pearlescent = 10,
				/obj/item/reagent_containers/food/snacks/eoran_aril/cerulean = 15,
				/obj/item/reagent_containers/food/snacks/eoran_aril/fractal = 5,
				/obj/item/reagent_containers/food/snacks/eoran_aril/auric = 4,
				/obj/item/reagent_containers/food/snacks/eoran_aril/ashen = 1,
				/obj/item/reagent_containers/food/snacks/eoran_aril/ochre = 5,
				/obj/item/reagent_containers/lux/eoran_aril = 1, //Lux equivalent
				/obj/item/reagent_containers/eoran_seed = 1 // Seed for more trees
			)

	// Generate 4 arils +1 per tier.
	var/num_arils = 4 + (floor(fruit_tier / 2))
	if(fruit_doubled)
		num_arils *= 2

	for(var/i in 1 to num_arils)
		var/aril_type = pickweight(possible_arils)
		aril_types += aril_type

/obj/item/fruit_of_eora/attackby(obj/item/I, mob/user)
	if(!opened && I.get_sharpness())
		if ( \
			!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/structure/table/optable) in src.loc) && \
			!(locate(/obj/item/storage/bag/tray) in src.loc) \
			)
			to_chat(user, span_warning("I need to use a table."))
			return FALSE
		open_fruit(user)
		return TRUE
	return ..()

/obj/item/fruit_of_eora/proc/open_fruit(mob/user)
	if(opened)
		return

	to_chat(user, span_notice("You carefully cut open the pomegranate, revealing glowing seeds within."))
	playsound(src, 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1)
	opened = TRUE

	for(var/aril_type in aril_types)
		new aril_type(loc)

	qdel(src)

/obj/item/reagent_containers/food/snacks/eoran_aril
	name = "eoran aril"
	desc = "A glowing seed from the fruit of Eora. It pulses with divine energy."
	icon = 'icons/obj/items/eora_pom.dmi'
	dropshrink = 0.7
	icon_state = "auric"
	bitesize = 1
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_TINY
	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	var/effect_desc = "Unknown effects."
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/eoran_aril/attack(mob/living/M, mob/living/user, def_zone)
	if(M != user)
		to_chat(user, span_info("The seed glows hot with Eora's rage as you try to forcefully feed her gift to another."))
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/eoran_aril/On_Consume(mob/living/eater)
	. = ..()
	if(iscarbon(eater))
		var/mob/living/carbon/c = eater
		apply_effects(c)

/obj/item/reagent_containers/food/snacks/eoran_aril/examine(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/c = user
		if(c.patron.type == /datum/patron/divine/eora)
			. += span_info(effect_desc)

/obj/item/reagent_containers/food/snacks/eoran_aril/proc/apply_effects(mob/living/carbon/eater)
	return

//--TIER 1--
/obj/item/reagent_containers/food/snacks/eoran_aril/crimson
	name = "crimson aril"
	desc = "A blood-red seed that seems to pulse with vitality."
	icon_state = "crimson"
	effect_desc = "This fruit heals for a blood price."

	var/heal_amount = 35
	var/blood_loss = 225

/obj/item/reagent_containers/food/snacks/eoran_aril/crimson/Initialize()
	. = ..()
	blood_loss = BLOOD_VOLUME_NORMAL * 0.04

/obj/item/reagent_containers/food/snacks/eoran_aril/crimson/apply_effects(mob/living/carbon/eater)
	//Instant heal, but you can only eat a couple before the next will make you pass out.
	var/list/wCount = eater.get_wounds()
	//No undead because they kinda don't have blood to give for this.
	if(!eater.construct && !(eater.mob_biotypes & MOB_UNDEAD))
		var/current_brute_loss = eater.getBruteLoss()
		blood_loss += (eater.blood_volume * 0.1)
		if(wCount.len > 0)
			eater.heal_wounds(heal_amount + (current_brute_loss * 0.12))
			eater.update_damage_overlays()
		// blood loss is equal to 4% max blood volume + 10% of current blood volume
		// Regular healing is equal to 35 damage + 12% of current damage
		eater.blood_volume = max(0, eater.blood_volume - blood_loss)
		eater.adjustBruteLoss(-(heal_amount + (current_brute_loss * 0.12)), 0)
		eater.adjustFireLoss(-(heal_amount + (eater.getFireLoss() * 0.12)), 0)
		eater.adjustToxLoss(-(heal_amount + (eater.getToxLoss() * 0.12)), 0)
		eater.adjustOxyLoss(-(heal_amount + (eater.getOxyLoss() * 0.12)), 0)
		eater.adjustOrganLoss(ORGAN_SLOT_BRAIN, -heal_amount)
		eater.adjustCloneLoss(-heal_amount, 0)

/obj/item/reagent_containers/food/snacks/eoran_aril/roseate
	name = "roseate aril"
	desc = "A pink seed that radiates beauty and grace."
	icon_state = "roseate"
	effect_desc = "Grants fleeting beauty. Rejects the ugly."

	var/beauty_duration = 10 MINUTES

/obj/item/reagent_containers/food/snacks/eoran_aril/roseate/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(!HAS_TRAIT(H, TRAIT_UNSEEMLY) && !HAS_TRAIT(H, TRAIT_BEAUTIFUL))
			H.apply_status_effect(/datum/status_effect/buff/eora_grace)

/datum/status_effect/buff/eora_grace
	id = "eora_grace"
	duration = 10 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/eora_grace

/atom/movable/screen/alert/status_effect/eora_grace
	name = "Eora's grace"
	desc = "You feel beautiful."

/datum/status_effect/buff/eora_grace/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
	return TRUE

/datum/status_effect/buff/eora_grace/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		REMOVE_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)

/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent
	name = "opalescent aril"
	desc = "An iridescent seed that shifts colors in the light."
	icon_state = "opalescent"
	effect_desc = "Transforms held gems into rubies."
	
/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent/apply_effects(mob/living/eater)
	for(var/obj/item/roguegem/G in eater.held_items)
		var/obj/item/roguegem/ruby/new_gem = new(eater.loc)
		qdel(G)
		eater.put_in_hands(new_gem)
		to_chat(eater, span_notice("The [G] transforms into a rontz in your hand!"))
		//Probably best not to allow 2 at once...
		break

// TIER 2
/obj/item/reagent_containers/food/snacks/eoran_aril/cerulean
	name = "cerulean aril"
	desc = "A deep blue seed that smells of the ocean."
	icon_state = "cerulean"
	effect_desc = "Excellent fishing bait that attracts treasure."
	baitpenalty = 5
	isbait = TRUE
	fishingMods=list(
		"commonFishingMod" = 0.2,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 0,
		"dangerFishingMod" = 0,
		"ceruleanFishingMod" = 1, // 1 on cerulean aril, 0 on everything else
		"cheeseFishingMod" = 0 // Just for the funny gimmick of a chance for rats and rouses.
	)
	baitresilience = 5

/obj/item/reagent_containers/food/snacks/eoran_aril/fractal
	name = "fractal aril"
	desc = "A geometrically perfect seed that hurts to look at."
	icon_state = "fractal"
	effect_desc = "At a cost to constitution, Eora's mercy will melt unsightfulness away..."

/obj/item/reagent_containers/food/snacks/eoran_aril/fractal/apply_effects(mob/living/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
			REMOVE_TRAIT(H, TRAIT_UNSEEMLY, TRAIT_VIRTUE)
			H.change_stat(STATKEY_CON, -1)
			to_chat(eater, span_good("You feel your imperfections melt away, but your body feels more fragile."))

// TIER 3
/obj/item/reagent_containers/food/snacks/eoran_aril/auric
	name = "auric aril"
	desc = "A golden seed that radiates warmth and life."
	icon_state = "auric"
	effect_desc = "Key ingredient in revival potions."

/obj/item/reagent_containers/food/snacks/eoran_aril/ashen
	name = "ashen aril"
	desc = "A grey seed that feels glacial to the touch. An IMMENSE sense of dread can be felt just looking at it."
	icon_state = "ashen"
	effect_desc = "The forbidden aril. This one is not meant for you."

/obj/item/reagent_containers/food/snacks/eoran_aril/ashen/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater

		if(H.patron.type == /datum/patron/divine/eora)
			// Eora does not appreciate her followers ignoring her most sacred wishes.
			H.apply_status_effect(/datum/status_effect/debuff/eoran_wilting)
		else
			var/datum/status_effect/buff/ashen_aril/existing_effect = H.has_status_effect(/datum/status_effect/buff/ashen_aril)

			if(existing_effect)
				// Already burnt by an aril, simply stave off the ashing for 30 minutes.
				existing_effect.prevent_reapply = TRUE
				H.remove_status_effect(/datum/status_effect/buff/ashen_aril)
				H.remove_filter("ashen_filter")
				H.apply_status_effect(/datum/status_effect/buff/ashen_aril, 0, 30 MINUTES)
			else
				H.apply_status_effect(/datum/status_effect/buff/ashen_aril, 5, 6 MINUTES)

/obj/item/reagent_containers/food/snacks/eoran_aril/ochre
	name = "ochre aril"
	desc = "A blood-red seed that seems to pulse menacingly."
	icon_state = "ochre"
	effect_desc = "Return two nearby corpses in view from necra's embrace, at the cost of your own life."

/obj/item/reagent_containers/food/snacks/eoran_aril/ochre/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(H.patron.type == /datum/patron/divine/eora)
			var/list/mob/living/carbon/human/target_mobs = list()

			for(var/mob/living/carbon/human/target in view(7, H))
				if(target_mobs.len >= 2)
					break
				if(target.stat != DEAD)
					continue
				if(!target.mind || !target.mind.active)
					continue
				if(HAS_TRAIT(target, TRAIT_NECRAS_VOW))
					continue
				if(HAS_TRAIT(target, TRAIT_DNR))
					continue
				if(target.mob_biotypes & MOB_UNDEAD)
					continue
				if(target.has_status_effect(/datum/status_effect/debuff/metabolic_acceleration))
					continue
				if(target.has_status_effect(/datum/status_effect/debuff/eoran_wilting))
					continue

				target_mobs += target

			if(target_mobs.len > 0)
				H.apply_status_effect(/datum/status_effect/debuff/eoran_wilting)
				addtimer(CALLBACK(GLOBAL_PROC_REF(process_ochre_revivals), target_mobs), 0)

	return ..()

/proc/process_ochre_revivals(list/mob/living/carbon/human/targets_to_revive)
	for(var/mob/living/carbon/human/target in targets_to_revive)
		continue
		if(target.stat != DEAD)
			continue

		INVOKE_ASYNC(GLOBAL_PROC_REF(revive_ochre_target), target)

/proc/revive_ochre_target(mob/living/carbon/human/target)
	to_chat(world, span_userdanger("ATTEMPTING REVIVAL FOR [target]"))
	if(QDELETED(target) || target.stat != DEAD)
		return FALSE

	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()

	if (target.client)
		if (alert(target, "They are calling for you. Are you ready?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
			target.visible_message(span_notice("Nothing happens. They are not being let go."))
			return FALSE
	else if (underworld_spirit && underworld_spirit.client)
		if (alert(underworld_spirit, "They are calling for you. Are you ready?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
			target.visible_message(span_notice("Nothing happens. They are not being let go."))
			return FALSE
	else
		target.visible_message(span_notice("The body shudders, but there's no one to call out to."))
		return FALSE

	// Perform revival
	target.adjustOxyLoss(-target.getOxyLoss())
	if(target.revive(full_heal = FALSE))
		// Transfer ghost back to body (if they were ghosted)
		if(underworld_spirit && underworld_spirit.mind) // Ensure spirit exists and has a mind
			underworld_spirit.mind.transfer_to(target, TRUE) // Transfer mind back to the revived body
			qdel(underworld_spirit) // Delete the spirit mob
		else
			target.grab_ghost(force = TRUE) // This attempts to grab a ghost even if they committed suicide.

		target.emote("breathgasp")
		target.Jitter(100)
		target.update_body()
		target.visible_message(span_notice("[target] is revived by divine magic!"), span_green("I awake from the void."))

		ADD_TRAIT(target, TRAIT_IWASREVIVED, "ochre_aril")
		target.apply_status_effect(/datum/status_effect/debuff/metabolic_acceleration)
		return TRUE
	else
		target.visible_message(span_warning("The magic falters, and nothing happens."))
		return FALSE

//For now this is just artifical lux. But this may make the user/receiver indebted to eora eventually.
//This is meant to be given guaranteed with T4 pommes for priests but given we don't have eoran priests yet I will implement this when we do.
/obj/item/reagent_containers/lux/eoran_aril
	name = "incandescent aril"
	desc = "A blindingly bright seed that radiates pure life energy. It imitates lux, the essence of life."
	icon = 'icons/obj/items/eora_pom.dmi'
	icon_state = "incandescent"
	dropshrink = 0.7

/obj/item/reagent_containers/food/snacks/eoran_aril/pearlescent
	name = "pearlescent aril"
	desc = "A milky-white seed that pulses with purifying energy."
	icon_state = "pearlescent"
	effect_desc = "Transforms poisons within your body into lifeblood at the cost of diluting strong lifeblood."

/obj/item/reagent_containers/food/snacks/eoran_aril/pearlescent/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		H.apply_status_effect(/datum/status_effect/pearlescent_aril)

/obj/item/reagent_containers/eoran_seed
	name = "Satin aril"
	desc = "A silky soft seed from Eora's sacred tree. It can be used to propagate her gift in fertile soil."
	icon = 'icons/obj/items/eora_pom.dmi'
	icon_state = "roseate"

/obj/item/reagent_containers/eoran_seed/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!isturf(target) || !proximity_flag)
		return ..()

	var/turf/T = target

	// Location checks
	if(!isopenturf(T))
		to_chat(user, span_warning("The seed needs open space to grow!"))
		return
	if(!(istype(T, /turf/open/floor/rogue/grass) || istype(T, /turf/open/floor/rogue/dirt)))
		to_chat(user, span_warning("The seed must be planted on dirt or grass!"))
		return

	// Planting process
	to_chat(user, span_notice("You begin to plant the seed in [T]. It pulses gently..."))
	if(!do_after(user, 30 SECONDS, target))
		to_chat(user, span_warning("Planting was interrupted!"))
		return

	// Re-check conditions after delay
	if(!isopenturf(T) || !(istype(T, /turf/open/floor/rogue/grass) || istype(T, /turf/open/floor/rogue/dirt)))
		to_chat(user, span_warning("The ground is no longer suitable!"))
		return

	// Create tree and consume seed
	new /obj/structure/eoran_pomegranate_tree(T)
	qdel(src)

#undef SPROUT
#undef GROWING
#undef MATURING
#undef FRUITING

//Remove their ability to feel bad, restore a small amount of hunger / thirst if they're already starving.
/obj/effect/proc_holder/spell/invoked/eora_blessing
	name = "Eora's Blessing"
	desc = "Bestow a person with Eora's calm, if only for a little while."
	sound = 'sound/magic/eora_bless.ogg'
	devotion_cost = 80
	recharge_time = 5 MINUTES
	miracle = TRUE
	invocation_type = "shout"
	invocations = list("Let the beauty of lyfe fill you whole.")
	overlay_state = "eora_bless"
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/eora_blessing/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/L = targets[1]
		var/assocskill = L.get_skill_level(associated_skill)
		L.apply_status_effect(/datum/status_effect/eora_blessing, assocskill)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/eora_blessing
	id = "eora_bless"
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/eora_blessing

/datum/status_effect/eora_blessing/on_apply(assocskill)
	if(assocskill)
		duration *= assocskill	//+1 minute per skill level.
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(owner, TRAIT_EORAN_SERENE, TRAIT_GENERIC)	//Generic origin so other Eorans do not have their innate traits overridden (they use TRAIT_MIRACLE)
	var/hungercheck = H.nutrition
	var/hydrohomiecheck = H.hydration
	switch(hungercheck)
		if(0 to NUTRITION_LEVEL_STARVING)
			switch(assocskill)
				if(SKILL_LEVEL_NOVICE)
					H.nutrition = NUTRITION_LEVEL_STARVING + 50
				if(SKILL_LEVEL_APPRENTICE to SKILL_LEVEL_EXPERT)
					H.nutrition = NUTRITION_LEVEL_HUNGRY + 50
				else	//Acolyte w/ Devotee
					H.nutrition = NUTRITION_LEVEL_FED
	switch(hydrohomiecheck)
		if(0 to HYDRATION_LEVEL_DEHYDRATED)
			switch(assocskill)
				if(SKILL_LEVEL_NOVICE)
					H.nutrition = HYDRATION_LEVEL_DEHYDRATED + 50
				if(SKILL_LEVEL_APPRENTICE to SKILL_LEVEL_EXPERT)
					H.nutrition = HYDRATION_LEVEL_THIRSTY + 50
				else	//Acolyte w/ Devotee
					H.nutrition = HYDRATION_LEVEL_SMALLTHIRST
	if(assocskill > SKILL_LEVEL_APPRENTICE)
		H.add_stress(/datum/stressevent/eoran_blessing_greater)
	else
		H.add_stress(/datum/stressevent/eoran_blessing)
	H.update_stress()
	. = ..()

/datum/status_effect/eora_blessing/on_remove()
	REMOVE_TRAIT(owner, TRAIT_EORAN_SERENE, TRAIT_GENERIC)
	owner.update_stress()
	return ..()

/atom/movable/screen/alert/status_effect/buff/eora_blessing
	name = "Eora's Calm"
	desc = "A refreshing calm. All your troubles have washed away. Why can't it always be like this?"
	icon_state = "eora_bless"

#undef HEARTWEAVE_FILTER
#undef BLESSED_FOOD_FILTER
