/datum/component/holster
	/// Weapon path and its children that are allowed
	var/obj/item/rogueweapon/valid_blade
	/// Specific weapons that are allowed. Bypasses valid_blade
	var/list/obj/item/rogueweapon/valid_blades
	/// Specific weapons that are not allowed. Bypassed valid_blade
	var/list/obj/item/rogueweapon/invalid_blades

	/// Stores weapon
	var/obj/item/rogueweapon/sheathed

	var/sheathe_time = 0.1 SECONDS
	var/sheathe_sound = 'sound/foley/equip/scabbard_holster.ogg'
	var/use_icons = TRUE


/datum/component/holster/Initialize(obj/item/rogueweapon/arg_validblade, list/arg_valid_blades, list/arg_invalid_blades, arg_sheathe_time)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	if(arg_validblade)
		valid_blade = arg_validblade
	if(islist(arg_valid_blades) && length(arg_valid_blades))
		valid_blades = arg_valid_blades.Copy()
	if(islist(arg_invalid_blades) && length(arg_invalid_blades))
		invalid_blades = arg_invalid_blades.Copy()
	if(arg_sheathe_time)
		sheathe_time = arg_sheathe_time

	RegisterSignal(parent, COMSIG_ITEM_ATTACK_TURF, PROC_REF(search_turf))
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(hand_check))
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_RIGHT, PROC_REF(right_click))
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(attack_by))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(examine_check))
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_ICON, PROC_REF(update_icon))

/datum/component/holster/proc/search_turf(atom/source, turf/T, mob/living/user)
	to_chat(user, span_notice("I search for my sword..."))
	for(var/obj/item/rogueweapon/sword/sword in T.contents)
		if(eat_sword(user, sword))
			break

/datum/component/holster/proc/weapon_check(mob/living/user, obj/A)
	if(sheathed)
		to_chat(user, span_warning("The sheath is occupied!"))
		return FALSE
	if(valid_blade && !istype(A, valid_blade))
		to_chat(user, span_warning("[A] won't fit in there."))
		return FALSE
	if(valid_blades)
		if(!(A.type in valid_blades))
			to_chat(user, span_warning("[A] won't fit in there."))
			return FALSE
	if(invalid_blades)
		if(A.type in invalid_blades)
			to_chat(user, span_warning("[A] won't fit in there."))
			return FALSE
	if(istype(A, /obj/item/rogueweapon))
		var/obj/item/rogueweapon/RW = A
		if(!RW.sheathe_icon)
			to_chat(user, span_warning("[A] won't fit in there."))
			return FALSE
	else
		return FALSE
	return TRUE


/datum/component/holster/proc/eat_sword(mob/living/user, obj/A)
	if(!weapon_check(user, A))
		return FALSE
	var/obj/item/I = parent
	if(I.obj_broken)
		user.visible_message(
			span_warning("[user] begins to force [A] into [parent]!"),
			span_warningbig("I begin to force [A] into [parent].")
		)
		if(!move_after(user, 2 SECONDS, target = user))
			return FALSE
		return FALSE
	if(!move_after(user, sheathe_time, target = user))
		return FALSE

	A.forceMove(src)
	sheathed = A
	update_icon(user)

	user.visible_message(
		span_notice("[user] sheathes [A] into [parent]."),
		span_notice("I sheathe [A] into [parent].")
	)

	playsound(parent, sheathe_sound, 100, TRUE)
	return TRUE


/datum/component/holster/proc/Entered()
	return

/datum/component/holster/proc/puke_sword(mob/living/user)
	if(!sheathed)
		return FALSE
	var/obj/item/I = parent
	if(I.obj_broken)
		user.visible_message(
			span_warning("[user] begins to force [sheathed] out of [I]!"),
			span_warningbig("I begin to force [sheathed] out of [I].")
		)
		if(!move_after(user, 2 SECONDS, target = user))
			return FALSE
	if(!move_after(user, sheathe_time, target = user))
		return FALSE

	sheathed.forceMove(user.loc)
	sheathed.pickup(user)
	user.put_in_hands(sheathed)
	sheathed = null
	update_icon(user)

	user.visible_message(
		span_warning("[user] draws out of [parent]!"),
		span_notice("I draw out of [parent].")
	)
	return TRUE


/datum/component/holster/proc/hand_check(datum/source, mob/user)
	var/obj/item/I = parent
	var/is_in_slot = TRUE
	if(ishuman(user))
		var/mob/living/carbon/human/human = user
		is_in_slot = (I in (list(human.backl, human.backr, human.beltl, human.beltr) + human.get_inactive_held_item()))
	if(sheathed && is_in_slot)
		puke_sword(user)
		return COMPONENT_NO_ATTACK_HAND

/datum/component/holster/proc/right_click(atom/source, mob/user)
	if(sheathed)
		puke_sword(user)

/datum/component/holster/proc/attack_by(atom/source, obj/item/I, mob/user, params)
	if(!sheathed)
		if(!eat_sword(user, I))
			return
	return COMPONENT_NO_AFTERATTACK


/datum/component/holster/proc/examine_check(datum/source, mob/user, list/examine_list)
	if(sheathed)
		examine_list += span_notice("The sheath is occupied by [sheathed]. Left-click to pull it out.")


/datum/component/holster/proc/update_icon(atom/source, mob/living/user)
	var/obj/item/I = parent
	if(use_icons)
		if(sheathed)
			I.icon_state = "[initial(I.icon_state)]_[sheathed.sheathe_icon]"
		else
			I.icon_state = "[initial(I.icon_state)]"

		if(user)
			user.update_inv_hands()
			user.update_inv_belt()
			user.update_inv_back()

	I.getonmobprop(tag)

/datum/component/holster/gwstrap
	use_icons = FALSE

/datum/component/holster/gwstrap/weapon_check(mob/living/user, obj/item/A)
	if(sheathed)
		return FALSE

	if(istype(A, /obj/item/rogueweapon))
		if(A.w_class >= WEIGHT_CLASS_BULKY)
			return TRUE

	if(!istype(A, /obj/item/clothing/neck/roguetown/psicross)) //snowflake that bypasses the valid_blades that i made. i will commit seppuku eventually
		return FALSE

/datum/component/holster/gwstrap/update_icon(mob/living/user)
	var/obj/item/I = parent
	if(sheathed)
		I.worn_x_dimension = 64
		I.worn_y_dimension = 64
		I.icon = sheathed.icon
		I.icon_state = sheathed.icon_state
		I.experimental_onback = TRUE
	else
		I.icon = initial(I.icon)
		I.icon_state = initial(I.icon_state)
		I.worn_x_dimension = initial(I.worn_x_dimension)
		I.worn_y_dimension = initial(I.worn_y_dimension)
		I.experimental_onback = FALSE

	if(user)
		user.update_inv_back()
		
	I.getonmobprop(tag)

/datum/component/holster/simplestrap/update_icon(mob/living/user)
	var/obj/item/I = parent
	if(sheathed)
		if(sheathed.bigboy)
			I.bigboy = TRUE
		I.icon = sheathed.icon
		I.icon_state = sheathed.icon_state
		I.experimental_onback = TRUE
		I.experimental_onhip = TRUE
	else
		I.icon = initial(I.icon)
		I.icon_state = initial(I.icon_state)
		I.experimental_onback = FALSE
		I.experimental_onhip = FALSE
		I.bigboy = FALSE
	if(user)
		user.update_inv_hands()
		user.update_inv_back()
		user.update_inv_belt()

	I.getonmobprop(tag)
