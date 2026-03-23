/datum/hag_boon/spell
	name = "Generic spell boon"
	var/spell_type = /obj/effect/proc_holder/spell/invoked/mark_target

/datum/hag_boon/spell/apply_boon_effect(mob/living/L)
	if(!L.mind || !spell_type)
		return

	// It's a little redundant to check it here too, but it's a failsafe.
	for(var/obj/effect/proc_holder/spell/S in L.mind.spell_list)
		if(S.type == spell_type)
			return

	var/obj/effect/proc_holder/spell/spell_inst = new spell_type()
	if(spell_inst.devotion_cost || spell_inst.miracle)
		// Miracles granted by hags don't care about devotion.
		spell_inst.devotion_cost = 0
		spell_inst.miracle = FALSE
	L.mind.AddSpell(spell_inst)
	to_chat(L, span_notice("A strange, flickering knowledge of <b>[spell_inst.name]</b> takes root in your mind."))
	return

/datum/hag_boon/spell/remove_boon_effect(mob/living/L)
	if(!L.mind)
		return

	var/obj/effect/proc_holder/spell/spell_inst
	for(var/obj/effect/proc_holder/spell/S in L.mind.spell_list)
		if(S.type == spell_type)
			spell_inst = S
			break

	if(spell_inst)
		L.mind.RemoveSpell(spell_inst)
		to_chat(L, span_warning("The knowledge of [spell_inst.name] withers and vanishes from your mind."))
	return

/datum/hag_boon/spell/spider_speak
	name = "Boon of Spider Speak"
	desc = "Allows the bearer to cast spider speak, making spiders friendly with a target for a long while."
	spell_type = /obj/effect/proc_holder/spell/invoked/spiderspeak
	points = 10

/datum/hag_boon/spell/twist_food
	name = "Boon of invigorating cooking"
	desc = "Similar to Eoran clergy, the bearer can enchant food with random bonuses and negatives being applied on a bite."
	spell_type = /obj/effect/proc_holder/spell/invoked/twist_food
	points = 20

/datum/hag_boon/spell/find_riches
	name = "Boon of riches"
	desc = "Allows the bearer to find riches underneath boulders every now and then."
	spell_type = /obj/effect/proc_holder/spell/self/boulder_scrounge
	points = 40

/datum/hag_boon/spell/banish
	name = "Boon of banish problems"
	desc = "Allows the bearer to send themselves or someone else to -THE SHADOW REALM-."
	spell_type = /obj/effect/proc_holder/spell/invoked/slumber_exile
	points = 30

/datum/status_effect/buff/twisted_sustenance
	id = "twisted_sustenance"
	duration = 10 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/twisted_sustenance
	var/list/stat_changes = list()

/atom/movable/screen/alert/status_effect/buff/twisted_sustenance
	name = "Wyrd strength"
	desc = "I feel an wyrd feeling coursing through my body."
	icon_state = "buff"

/datum/status_effect/buff/twisted_sustenance/on_creation(mob/living/new_owner, list/passed_stats)
	src.stat_changes = passed_stats
	effectedstats = stat_changes
	return ..()

/datum/status_effect/buff/twisted_sustenance/on_apply()
	. = ..()
	to_chat(owner, span_warning("A wyrd feeling ripples through your biology!"))

/datum/status_effect/buff/twisted_sustenance/on_remove()
	to_chat(owner, span_notice("The wyrd feeling settles, and your body returns to normal."))
	return ..()

/datum/component/twisted_food
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/caster
	var/list/final_stats = list()
	var/stat_buff_amt = 5
	var/stat_nerf_amt = 3
	var/stat_to_nerf = 2

/datum/component/twisted_food/Initialize(mob/living/_caster)
	if(!isitem(parent) || !istype(parent, /obj/item/reagent_containers/food/snacks))
		return COMPONENT_INCOMPATIBLE

	caster = _caster
	var/obj/item/reagent_containers/food/snacks/F = parent

	F.add_filter("twisted_food_glow", 1, list("type" = "outline", "color" = "#ff00ff", "size" = 1))

	generate_stats()
	RegisterSignal(F, COMSIG_FOOD_EATEN, PROC_REF(on_food_eaten))

/datum/component/twisted_food/proc/generate_stats()
	var/list/potential_stats = list(STATKEY_STR, STATKEY_PER, STATKEY_INT, STATKEY_CON, STATKEY_WIL, STATKEY_SPD, STATKEY_LCK)

	// Pick 2 stats to negatively affect.
	var/list/losers = list()
	for(var/i in 1 to stat_to_nerf)
		losers += pick_n_take(potential_stats)

	// distribute points at random!
	for(var/i in 1 to stat_nerf_amt)
		var/target = pick(losers)
		final_stats[target] = (final_stats[target] || 0) - 1

	// Remaining 5 stats
	var/list/winners = potential_stats 
	for(var/i in 1 to stat_buff_amt)
		var/target = pick(winners)
		final_stats[target] = (final_stats[target] || 0) + 1

/datum/component/twisted_food/proc/on_food_eaten(datum/source, mob/living/eater, mob/living/feeder)
	SIGNAL_HANDLER
	eater.apply_status_effect(/datum/status_effect/buff/twisted_sustenance, final_stats)

/obj/effect/proc_holder/spell/invoked/twist_food
	name = "Twist Food"
	desc = "Infuse a snack with wyrd magycks. Consumption shuffles the eater's stats (+5/-3 budget). Mimics Eora's incantations"
	invocations = list("Eora, nourish this offering!")
	recharge_time = 90 SECONDS
	overlay_state = "bread"
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/twist_food/cast(list/targets, mob/living/user)
	var/obj/item/target = targets[1]
	
	if(!istype(target, /obj/item/reagent_containers/food/snacks))
		to_chat(user, span_warning("You can only twist food!"))
		revert_cast()
		return FALSE

	target.AddComponent(/datum/component/twisted_food, user)
	to_chat(user, span_notice("You infuse [target] with a wyrd aura."))
	return TRUE

/obj/effect/proc_holder/spell/self/boulder_scrounge
	name = "Find Riches"
	desc = "Heave a heavy stone to reveal the treasures the earth has swallowed."
	recharge_time = 8 MINUTES
	var/static/list/treasure_pool = list(
		/obj/item/roguecoin/gold/pile = 15,
		/obj/item/roguecoin/silver/pile = 25,
		/obj/item/roguecoin/aalloy/pile = 10,
		/obj/item/clothing/neck/roguetown/psicross = 5,
		/obj/item/clothing/neck/roguetown/collar = 3,
		/obj/item/reagent_containers/glass/cup/golden = 2,
		/obj/item/roguecoin/gold/virtuepile = 4,
		/obj/item/alch/transisdust = 5
	)

/obj/effect/proc_holder/spell/self/boulder_scrounge/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user
	var/turf/T = get_turf(H)
	var/obj/structure/boulder = locate(/obj/item/natural/rock) in range(1, H)

	if(!boulder)
		to_chat(H, span_warning("You find nothing but mud. You need a heavy stone to find a real hoard."))
		revert_cast()
		return FALSE
	H.visible_message(span_notice("[H] begins prying at the base of [boulder]..."), \
					 span_notice("You strain against [boulder], looking for a hidden cache."))

	if(!do_after(H, 4 SECONDS, target = boulder))
		revert_cast()
		return FALSE

	var/luck_roll = H.STALUC + (H.get_stress_amount() < 0 ? 10 : 0)
	var/obj/item/found_thing

	if(luck_roll >= 20)
		found_thing = new /obj/item/roguecoin/gold/pile(T)
		to_chat(H, span_boldnotice("A hoard of Zenarii!"))
	else if(luck_roll >= 10)
		found_thing = new /obj/item/roguecoin/silver/pile(T)
		to_chat(H, span_notice("A collection of Ziliquae. This will buy much."))
	else
		found_thing = new /obj/item/roguecoin/copper/pile(T)
		to_chat(H, span_info("A few measly Zennies... better than nothing."))

	if(!H.put_in_hands(found_thing, FALSE))
		found_thing.forceMove(T)

	if(prob(20 + luck_roll))
		var/treasure_path = pickweight(treasure_pool)
		var/obj/item/extra = new treasure_path(T)

		to_chat(H, span_boldnotice("Wait... there is something else tucked in the roots!"))
		if(!H.put_in_hands(extra, FALSE))
			extra.forceMove(T)

	playsound(T, 'modular/Neu_Food/sound/rustle2.ogg', 50, TRUE)
	return TRUE

/obj/effect/proc_holder/spell/invoked/slumber_exile
	name = "Slumbering Exile"
	desc = "Force someone next to you into the realm of dreams for two minutes, once every day."
	recharge_time = 30 MINUTES
	invocations = list("DRE-YMA... SLEE-PA...")
	range = 1
	action_icon_state = "exile"
	charging_slowdown = 2
	chargetime = 1.5 SECONDS

/obj/effect/proc_holder/spell/invoked/slumber_exile/cast(list/targets, mob/user = usr)
	. = ..()
	var/mob/living/carbon/human/target = targets[1]
	if(!ishuman(target))
		revert_cast()
		return FALSE

	target.visible_message(span_userdanger("[user] banishes [target] into a dark rift!"))
	to_chat(target, span_userdanger("The world dissolves into mist as you are dragged into a dream!"))

	teleport_to_dream(target, 1, 1, FALSE, 2 MINUTES)

	return TRUE
