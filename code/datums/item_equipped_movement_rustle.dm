
/* ported from tgstation: https://github.com/tgstation/tgstation/blob/master/code/datums/components/item_equipped_movement_rustle.dm
with light edits to work with roguecode */


/datum/component/item_equipped_movement_rustle

	///sound that plays, use an SFX define if there is multiple.
	var/rustle_sounds = SFX_CHAIN_STEP

	///what move are we on.
	var/move_counter = 0
	///how many moves to take before playing the sound.
	var/move_delay = 4

	///volume at which the sound plays.
	var/volume = 100
	///does the sound vary?
	var/sound_vary = TRUE
	///extra-range for this component's sound.
	var/sound_extra_range = -1
	///sound exponent for the rustle.
	var/sound_falloff_exponent = 5
	///when sounds start falling off for the rustle rustle.
	var/sound_falloff_distance = 1

	var/static/list/valid_storage_rustlers = list(
		/datum/component/storage/concrete/roguetown/hat
	)

/datum/component/item_equipped_movement_rustle/Initialize(custom_sounds, move_delay_override, volume_override, extrarange, falloff_exponent, falloff_distance)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_unequip))
	RegisterSignal(parent, COMSIG_AFTER_STORAGE_INSERT, PROC_REF(handle_storage_insert))
	RegisterSignal(parent, COMSIG_AFTER_STORAGE_REMOVE, PROC_REF(handle_storage_remove))

	if(custom_sounds)
		rustle_sounds = custom_sounds
	if(isnum(volume_override))
		volume = volume_override
	if(isnum(move_delay_override))
		move_delay = move_delay_override
	if(isnum(extrarange))
		sound_extra_range = extrarange
	if(isnum(falloff_exponent))
		sound_falloff_exponent = falloff_exponent
	if(isnum(falloff_distance))
		sound_falloff_distance = falloff_distance

/datum/component/item_equipped_movement_rustle/proc/on_equip(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER

	RegisterSignal(equipper, COMSIG_MOVABLE_MOVED, PROC_REF(try_step), override = TRUE)
	RegisterSignal(equipper, COMSIG_SEX_JOSTLE, PROC_REF(try_step_quick), override = TRUE)

/datum/component/item_equipped_movement_rustle/proc/on_unequip(datum/source, mob/dropped)
	SIGNAL_HANDLER

	move_counter = 0
	UnregisterSignal(dropped, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(dropped, COMSIG_SEX_JOSTLE)

/datum/component/item_equipped_movement_rustle/proc/handle_storage_insert(datum/source, obj/storage_master, mob/user, datum/storage_datum)
	SIGNAL_HANDLER

	if(!is_type_in_list(storage_datum, valid_storage_rustlers))
		return

	RegisterSignal(storage_master, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(storage_master, COMSIG_ITEM_DROPPED, PROC_REF(on_unequip))

	if(storage_master.loc == user)
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(try_step), override = TRUE)

/datum/component/item_equipped_movement_rustle/proc/handle_storage_remove(datum/source, obj/storage_master, mob/user, datum/storage_datum)
	SIGNAL_HANDLER

	if(!is_type_in_list(storage_datum, valid_storage_rustlers))
		return

	UnregisterSignal(storage_master, COMSIG_ITEM_EQUIPPED)
	UnregisterSignal(storage_master, COMSIG_ITEM_DROPPED)

	if(storage_master.loc == user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/datum/component/item_equipped_movement_rustle/proc/try_step(obj/item/clothing/source)//(mob/source)
	SIGNAL_HANDLER
	/*if (source.moving_diagonally == FIRST_DIAG_STEP)   //you can uncomment these if someone ever implements diagonal movement
		return*/
	move_counter++
	if(move_counter >= move_delay)
		play_rustle_sound(source)
		move_counter = 0

/datum/component/item_equipped_movement_rustle/proc/try_step_quick(obj/item/clothing/source)//(mob/source)
	SIGNAL_HANDLER
	/*if (source.moving_diagonally == FIRST_DIAG_STEP)   //you can uncomment these if someone ever implements diagonal movement
		return*/
	move_counter++
	if(move_counter >= (move_delay / 2))
		play_rustle_sound(source)
		move_counter = 0

/datum/component/item_equipped_movement_rustle/proc/play_rustle_sound(obj/item/clothing/source)//(mob/source)
	playsound(source, rustle_sounds, volume, sound_vary, sound_extra_range, sound_falloff_exponent, falloff = sound_falloff_distance)
