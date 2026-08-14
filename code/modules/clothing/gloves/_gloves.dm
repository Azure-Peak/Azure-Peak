/datum/component/storage/concrete/roguetown/gloves
	screen_max_rows = 2
	screen_max_columns = 2
	max_w_class = WEIGHT_CLASS_GIGANTIC

	cant_hold = list(
		/obj/item/storage,
		/obj/item/rogueweapon,
		/obj/item/bomb,
		/obj/item/flashlight,
		/obj/item/recipe_book,
	)

	attack_hand_interact = FALSE
	silent = TRUE
	rustle_sound = null

	insert_preposition = "onto"
	allow_big_nesting = TRUE
	allow_nesting = TRUE
	intercept_parent_attack = FALSE
	intercept_parent_mousedrop = FALSE

/datum/component/storage/concrete/roguetown/gloves/attackby(datum/source, obj/item/attacking_item, mob/user, params, storage_click)
	if(is_type_in_list(attacking_item, cant_hold))
		return FALSE
	return ..()

/datum/component/storage/concrete/roguetown/gloves/update_icon()
	. = ..()
	var/obj/our_parent = real_location()
	if(ismob(our_parent.loc))
		var/mob/parent_mob = our_parent.loc
		parent_mob.update_inv_head()

/datum/component/storage/concrete/roguetown/gloves/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check = FALSE, params, storage_click = FALSE)
	// we only want aesthetically hand items, like rings and gloves, to be addable
	if(!(storing.slot_flags & (ITEM_SLOT_RING | ITEM_SLOT_HANDS)))
		return FALSE
	// any sort of armoured item is forbidden, it's aesthetic only
	if(storing.armor?.stab > 0 || storing.armor?.blunt > 0)
		return FALSE
	// don't allow recursive nesting, it must be empty
	if(length(storing.contents))
		return FALSE
	return ..()

/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 1
	body_parts_covered = HANDS
	slot_flags = ITEM_SLOT_GLOVES
	attack_verb = list("challenged")
	var/transfer_prints = FALSE
	strip_delay = STRIP_DELAY_FAST
	equip_delay_other = 40
	bloody_icon_state = "bloodyhands"

	grid_width = 64
	grid_height = 32
	throw_on_break = TRUE

	var/attachment_component = /datum/component/storage/concrete/roguetown/gloves

/obj/item/clothing/gloves/Initialize(mapload)
	. = ..()
	if(attachment_component)
		AddComponent(attachment_component)

/obj/item/clothing/gloves/get_examine_name(mob/user)
	var/default_examine_name = ..()
	if(attachment_component)
		var/datum/component/storage/concrete/roguetown/our_component = GetComponent(attachment_component)
		if(length(our_component.item_to_grid_coordinates))
			var/list/examine_strings = list()
			for(var/obj/item/thing as anything in our_component.item_to_grid_coordinates)
				examine_strings += thing.get_examine_name(user)
			default_examine_name += " ([examine_strings.Join(", ")])"
	return default_examine_name

/obj/item/clothing/gloves/get_mechanics_examine(mob/user)
	. = ..()
	if(attachment_component)
		. += span_info("Shift + RMB will open aesthetic storage, allowing the user to layer extra decorations over \the [src].")
		. += span_info("Alt + RMB allows the user to toggle aesthetic storage (Shift + RMB) items on or off.")

/obj/item/clothing/gloves/ShiftRightClick(mob/user)
	if(attachment_component)
		var/datum/component/storage/storage_component = GetComponent(attachment_component)
		if(storage_component)
			storage_component.rmb_show(user)
			return TRUE
	return ..()

/obj/item/clothing/gloves/AltRightClick(mob/user)
	. = ..()
	if(!istype(loc, /mob/living/carbon))
		return
	if(attachment_component)
		var/datum/component/storage/concrete/roguetown/storage_component = GetComponent(attachment_component)
		if(storage_component && length(storage_component.item_to_grid_coordinates))
			var/list/options = list()
			for(var/obj/item/clothing/C in storage_component.item_to_grid_coordinates)
				if(!C || !isclothing(C))
					continue
				if(C.item_flags & NOT_SHOW_IN_STORAGE)
					options["[C.name] (Hidden)"] = C
				else
					options["[C.name] (Shown)"] = C
			var/choice = input(user, "Choose clothing to layer:","Layering") as null|anything in options
			if(choice)
				var/clothes_to_change = options[choice]
				if(isclothing(clothes_to_change))
					var/obj/item/clothing/C = clothes_to_change
					if(C.item_flags & NOT_SHOW_IN_STORAGE)
						C.item_flags &= ~NOT_SHOW_IN_STORAGE
					else
						C.item_flags |= NOT_SHOW_IN_STORAGE
					to_chat(user, span_info("[C] will be [(C.item_flags & NOT_SHOW_IN_STORAGE) ? "hidden" : "visible"] \the [src]"))
				user.update_inv_gloves()

// since we want rings to layer over the gloves, we set the layer manually here - amulets, in turn, override it in their own build_worn_icon proc
// we also override female here because rings and amulets don't have _f sprites!
/obj/item/clothing/gloves/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, female = FALSE, customi = null, sleeveindex, boobed_overlay = FALSE, icon/clip_mask = null)
	var/mutable_appearance/standing = ..()
	// get attachment component and check if there's anything inside
	if(attachment_component)
		var/datum/component/storage/concrete/roguetown/our_component = GetComponent(attachment_component)
		if(our_component && length(our_component.item_to_grid_coordinates))
			for(var/obj/item/thing as anything in our_component.item_to_grid_coordinates)
				if(thing.item_flags & NOT_SHOW_IN_STORAGE)
					continue
				var/shouldrenderfemale = (female && !(thing.slot_flags & SLOT_RING)) // rings and amulets don't have _f icons, but gloves _do_
				var/mutable_appearance/thing_appearance = thing.build_worn_icon(RING_LAYER, default_icon_file, isinhands, femaleuniform, override_state, shouldrenderfemale, customi, sleeveindex, boobed_overlay, clip_mask)
				thing_appearance.appearance_flags = RESET_COLOR
				thing_appearance.pixel_x -= standing.pixel_x
				thing_appearance.pixel_y -= standing.pixel_y
				standing.add_overlay(thing_appearance)
	return standing

/obj/item/clothing/gloves/ComponentInitialize()
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(clean_blood))

/obj/item/clothing/gloves/proc/clean_blood(datum/source, strength)
	if(strength < CLEAN_STRENGTH_BLOOD)
		return
	transfer_blood = 0
	qdel(GetComponent(/datum/component/decal/blood))
	return TRUE

/obj/item/clothing/gloves/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("\the [src] are forcing [user]'s hands around [user.p_their()] neck! It looks like the gloves are possessed!"))
	return OXYLOSS

/obj/item/clothing/gloves/update_damaged_state()
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_gloves()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(atom/A, proximity)
	return 0 // return 1 to cancel attack_hand()
