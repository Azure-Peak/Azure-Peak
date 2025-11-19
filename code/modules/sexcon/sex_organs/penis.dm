/obj/item/organ/penis
	name = "penis"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_PENIS
	organ_dna_type = /datum/organ_dna/penis
	accessory_type = /datum/sprite_accessory/penis/human
	var/sheath_type = SHEATH_TYPE_NONE
	var/erect_state = ERECT_STATE_NONE
	var/penis_type = PENIS_TYPE_PLAIN
	var/penis_size = DEFAULT_PENIS_SIZE
	var/functional = TRUE

/obj/item/organ/penis/Initialize()
	. = ..()

/obj/item/organ/penis/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	RegisterSignal(M, COMSIG_SEX_AROUSAL_CHANGED, PROC_REF(on_arousal_changed), TRUE)
	if(penis_type in list(PENIS_TYPE_KNOTTED, PENIS_TYPE_TAPERED_DOUBLE_KNOTTED, PENIS_TYPE_BARBED_KNOTTED))
		M.AddComponent(/datum/component/knotting)

/obj/item/organ/penis/Remove(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	UnregisterSignal(M, COMSIG_SEX_AROUSAL_CHANGED)
	if(penis_type in list(PENIS_TYPE_KNOTTED, PENIS_TYPE_TAPERED_DOUBLE_KNOTTED, PENIS_TYPE_BARBED_KNOTTED))
		qdel(M.GetComponent(/datum/component/knotting))

/obj/item/organ/penis/proc/on_arousal_changed()
	var/list/arousal_data = list()
	SEND_SIGNAL(owner, COMSIG_SEX_GET_AROUSAL, arousal_data)

	var/max_arousal = MAX_AROUSAL || 120
	var/current_arousal = arousal_data["arousal"] || 0
	var/arousal_percent = min(100, (current_arousal / max_arousal) * 100)

	var/new_state = ERECT_STATE_NONE
	switch(arousal_percent)
		if(0 to 10)
			new_state = ERECT_STATE_NONE
		if(11 to 35)
			new_state = ERECT_STATE_PARTIAL
		if(36 to 100)
			new_state = ERECT_STATE_HARD
	update_erect_state(new_state)

/obj/item/organ/penis/proc/update_erect_state(new_state = ERECT_STATE_NONE)
	var/oldstate = erect_state

	erect_state = new_state
	if(oldstate != erect_state && owner)
		owner.update_body_parts(TRUE)

/obj/item/organ/penis/proc/create_fake_variant(mob/living/carbon/human/user)
	var/obj/item/penis_fake/fake = new()
	fake.copy_properties_from(src)
	fake.set_original_owner(user)
	return fake

/obj/item/penis_fake
	name = "penis"
	icon_state = "severedtail" //placeholder
	var/sheath_type = SHEATH_TYPE_NONE
	var/erect_state = ERECT_STATE_NONE
	var/penis_type = PENIS_TYPE_PLAIN
	var/penis_size = DEFAULT_PENIS_SIZE
	// Tracking vars
	var/original_owner_ckey = null
	var/original_owner_name = null
	var/insertion_timestamp = null

/obj/item/penis_fake/Initialize()
	. = ..()
	insertion_timestamp = world.time

/obj/item/penis_fake/proc/copy_properties_from(obj/item/organ/penis/source)
	if(!source)
		return
	sheath_type = source.sheath_type
	erect_state = source.erect_state
	penis_type = source.penis_type
	penis_size = source.penis_size
	grid_height = 32 * penis_size
	grid_width = 32
	name = "[source.name]"

/obj/item/penis_fake/proc/set_original_owner(mob/living/carbon/human/owner)
	if(owner?.ckey)
		original_owner_ckey = owner.ckey
		original_owner_name = owner.real_name || owner.name

/obj/item/penis_fake/proc/is_owned_by(mob/living/carbon/human/user)
	if(!user?.ckey)
		return FALSE
	return user.ckey == original_owner_ckey

/obj/item/organ/penis/knotted
	name = "knotted penis"
	penis_type = PENIS_TYPE_KNOTTED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/knotted/big
	penis_size = 3

/obj/item/organ/penis/equine
	name = "equine penis"
	penis_type = PENIS_TYPE_EQUINE
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/tapered_mammal
	name = "tapered penis"
	penis_type = PENIS_TYPE_TAPERED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/tapered
	name = "tapered penis"
	penis_type = PENIS_TYPE_TAPERED
	sheath_type = SHEATH_TYPE_SLIT

/obj/item/organ/penis/tapered_double
	name = "hemi tapered penis"
	penis_type = PENIS_TYPE_TAPERED_DOUBLE
	sheath_type = SHEATH_TYPE_SLIT

/obj/item/organ/penis/tapered_double_knotted
	name = "hemi knotted tapered penis"
	penis_type = PENIS_TYPE_TAPERED_DOUBLE_KNOTTED
	sheath_type = SHEATH_TYPE_SLIT

/obj/item/organ/penis/barbed
	name = "barbed penis"
	penis_type = PENIS_TYPE_BARBED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/barbed_knotted
	name = "barbed knotted penis"
	penis_type = PENIS_TYPE_BARBED_KNOTTED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/tentacle
	name = "tentacle penis"
	penis_type = PENIS_TYPE_TENTACLE
	sheath_type = SHEATH_TYPE_NONE
