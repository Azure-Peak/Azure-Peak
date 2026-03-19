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
	spell_type = /obj/effect/proc_holder/spell/invoked/spiderspeak
	points = 10

/datum/hag_boon/spell/twist_food
	name = "Boon of invigorating cooking"
	spell_type = /obj/effect/proc_holder/spell/invoked/twist_food
	points = 20

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
	desc = "Infuse a snack with wyrd magycks. Consumption shuffles the eater's stats (+3/-2 budget). Mimics Eora's incantations"
	invocations = list("Eora, nourish this offering!")
	recharge_time = 15 SECONDS
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
