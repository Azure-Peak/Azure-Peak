/obj/item/rogueweapon/huntingknife/idagger/steel/rotfang
	name = "rotfang"
	desc = "A decorated dagger fabricated using Pestran secrets. In heretical fashion, it is used to spread black rot rather than contain it. </br>I can coat this dagger in black ichor, giving them black rot on strikes that aren't parried or dodged."
	icon_state = "rotfang"
	// Unique antag weapon, it can be a good deal better
	max_integrity = 220
	wdefense = 5

/obj/item/rogueweapon/huntingknife/idagger/steel/rotfang/Initialize()
	. = ..()
	AddComponent(/datum/component/ichor_stained)

/obj/item/reagent_containers/black_ichor
	name = "black ichor"
	desc = "A malevolent little ball of stabilized black rot, siphoned from the heartbeast."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "ichor"

/datum/component/ichor_stained
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/obj/item/parent_weapon
	var/charges = 0
	var/max_charges = 100

/datum/component/ichor_stained/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	parent_weapon = parent

	RegisterSignal(parent_weapon, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent_weapon, COMSIG_ITEM_PRE_ATTACK, PROC_REF(check_dip))
	RegisterSignal(parent_weapon, COMSIG_ITEM_ATTACK_SUCCESS, PROC_REF(on_attack_success))

/datum/component/ichor_stained/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(charges > 0)
		examine_list += span_warning("It is coated in [charges] layers of thick, viscous ichor.")

/datum/component/ichor_stained/proc/check_dip(obj/item/source, atom/_target, mob/living/attacker, params)
	SIGNAL_HANDLER

	if(!istype(_target, /obj/item/reagent_containers/black_ichor))
		return

	if(charges >= max_charges)
		to_chat(attacker, span_warning("\The [parent_weapon] can't hold any more ichor!"))
		return COMPONENT_NO_ATTACK

	attacker.visible_message(span_notice("[attacker] begins coating \the [parent_weapon] with ichor..."), span_notice("You begin coating \the [parent_weapon] in ichor..."))

	INVOKE_ASYNC(src, PROC_REF(start_dipping), _target, attacker)
	return COMPONENT_NO_ATTACK

/datum/component/ichor_stained/proc/start_dipping(obj/item/_target, mob/living/attacker, params)
	if(do_after(attacker, 0.4 SECONDS, target = _target))
		charges = max_charges
		update_visuals()
		to_chat(attacker, span_nicegreen("You coat the blade in a fresh layer of ichor."))
		qdel(_target)

/datum/component/ichor_stained/proc/on_attack_success(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(charges <= 0 || !isliving(target))
		return

	// This is mostly so that if the balance of these intents changes, it won't make the dagger useless
	var/datum/intent/I = user.used_intent
	var/rot_to_apply = 5 // Base amount

	if(I)
		// If the intent is slower/heavier than the standard quick stab
		if(I.clickcd > CLICK_CD_QUICK)
			rot_to_apply += 3

		// If the swing delay is significant (0.5s or 5 deciseconds)
		if(I.swingdelay > 5) 
			rot_to_apply += 3

	to_chat(world, span_notice("[DEBUG] ichor_stained/on_attack_success: [user] hit [target] with [parent_weapon]. Rot to apply: [rot_to_apply], Charges left before hit: [charges] intent is [I]"))
	apply_black_rot(target, rot_to_apply)

	charges -= rot_to_apply
	if(charges <= 0)
		remove_visuals()
		to_chat(user, span_warning("The last of the ichor rubs off onto [target]!"))

/datum/component/ichor_stained/proc/apply_black_rot(mob/living/target, amount)
	var/datum/status_effect/black_rot/R = target.has_status_effect(/datum/status_effect/black_rot)
	if(R)
		R.add_stack(amount)
	else
		target.apply_status_effect(/datum/status_effect/black_rot, amount)

/datum/component/ichor_stained/proc/update_visuals()
	parent_weapon.icon_state = "[initial(parent_weapon.icon_state)]_p"

/datum/component/ichor_stained/proc/remove_visuals()
	parent_weapon.icon_state = initial(parent_weapon.icon_state)
