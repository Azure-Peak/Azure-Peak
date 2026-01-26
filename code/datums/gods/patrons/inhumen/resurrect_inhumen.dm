#define NOBLE_MULTIPLIER 2.5

/datum/component/debt_collector
	var/debt_remaining = 0
	/// There's a couple instances where on_equip() is called twice incorrectly. I'm applying a small cooldown to prevent abuse of this...
	var/next_payment_time = 0

/datum/component/debt_collector/Initialize(start_debt = 200)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/H = parent
	if(HAS_TRAIT(H, TRAIT_NOBLE))
		debt_remaining = start_debt * NOBLE_MULTIPLIER
	else
		debt_remaining = start_debt
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/on_equip)

/datum/component/debt_collector/proc/on_equip(mob/living/carbon/human/H, obj/item/I, slot)
	SIGNAL_HANDLER

	if(slot != ITEM_SLOT_HANDS)
		return

	if(world.time < next_payment_time)
		return

	// Set the cooldown immediately to "lock" this tick
	next_payment_time = world.time + 1

	// Only interact with standard currency, so no marques or psila
	if(istype(I, /obj/item/roguecoin/gold) || istype(I, /obj/item/roguecoin/silver) || istype(I, /obj/item/roguecoin/copper))
		addtimer(CALLBACK(src, .proc/process_payment, H, I), 1)

/datum/component/debt_collector/proc/process_payment(mob/living/carbon/human/H, obj/item/roguecoin/C)
	var/total_real_value = C.get_real_price()
	if(debt_remaining <= 0)
		clear_debt(H)
		return

	if(total_real_value > debt_remaining)
		var/refund_budget = total_real_value - debt_remaining
		refund_budget = max(0, floor(refund_budget))
		to_chat(H, span_warning("A golden hand claims [C] and manifest the remainder."))

		qdel(C)
		// We need a delay to stop the old coin pile from merging with the refund prematurely. Delay one tick :D
		// I love coin code!!
		spawn(1)
			var/obj/structure/roguemachine/temp_ref = new /obj/structure/roguemachine()
			temp_ref.budget2change(refund_budget, H)
			qdel(temp_ref)

		debt_remaining = 0
		clear_debt(H)

	else
		debt_remaining -= total_real_value
		to_chat(H, span_warning("As you grasp [C], [total_real_value] worth of debt vanishes. Remaining: [debt_remaining]."))
		playsound(H, 'sound/foley/coins1.ogg', 50, TRUE)
		qdel(C)
		if(debt_remaining <= 0)
			clear_debt(H)

/datum/component/debt_collector/proc/clear_debt(mob/living/carbon/human/H)
	to_chat(H, span_nicegreen("The weight of your debt has lifted!"))
	H.remove_status_effect(/datum/status_effect/debuff/debt_indicator)
	qdel(src)

#undef NOBLE_MULTIPLIER

/atom/movable/screen/alert/status_effect/debuff/debt_indicator
	name = "Indentured Spirit"
	desc = "A spiritual debt weighs heavy on your soul, sapping your vitality. Standard coins you touch are consumed to appease Matthios."
	icon_state = "pom_regret"

/atom/movable/screen/alert/status_effect/debuff/debt_indicator/examine_ui(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	if(desc)
		inspec += "<br>[desc]"

	// Find the component to show the live debt count
	var/datum/component/debt_collector/DC = user.GetComponent(/datum/component/debt_collector)
	if(DC)
		inspec += "<br><span class='boldwarning'>Current Debt: [DC.debt_remaining] mammon.</span>"

	// Stat penalties logic from the base proc
	for(var/S in attached_effect?.effectedstats)
		if(attached_effect.effectedstats[S] > 0)
			inspec += "<br><span class='purple'>[S]</span> \Roman [attached_effect.effectedstats[S]]"
		else if(attached_effect.effectedstats[S] < 0)
			var/newnum = attached_effect.effectedstats[S] * -1
			inspec += "<br><span class='danger'>[S]</span> \Roman [newnum]"

	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")

/datum/status_effect/debuff/debt_indicator
	id = "debt_indicator"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/debuff/debt_indicator
	effectedstats = list(
		STATKEY_STR = -2,
		STATKEY_SPD = -4,
		STATKEY_CON = -2
	)

/datum/status_effect/debuff/debt_indicator/on_apply()
	. = ..()
	owner.AddComponent(/datum/component/debt_collector, 200)
	to_chat(owner, span_userdanger("A cold, crushing weight settles over your limbs... you are indentured."))

/datum/status_effect/debuff/debt_indicator/on_remove()
	. = ..()
	to_chat(owner, span_nicegreen("The crushing weight lifts from your soul. You are free!"))

/obj/effect/proc_holder/spell/invoked/resurrect/matthios
	name = "Life transaction"
	desc = "Revives the target by arranging a deal with matthios. They will be indebted to him."
	debuff_type = /datum/status_effect/debuff/debt_indicator
	alt_required_items = list()
	required_items = list()
