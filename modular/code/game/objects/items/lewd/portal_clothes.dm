//OV FILE
//CHANGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

/obj/item/portal_clothes
	name = "portal stone"
	icon = 'modular/icons/obj/lewd/portal_clothes.dmi'
	icon_state = "portal"
	desc = "A portal stone that can be synced to clothing, allowing sensations to be passed through it. (Note: if linked while the clothing is being worn, remove the clothing and re-equip.) (Disclaimer: This item is meant to be used for private adult scenes, and is not meant to be used as a replacement to Sending Stones, please do not abuse this.)"
	w_class = WEIGHT_CLASS_TINY
	obj_flags = UNIQUE_RENAME
	var/datum/component/portal_clothes/paired_with
	possible_item_intents = list(/datum/intent/use)

/obj/item/portal_clothes/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("Use on a bit of clothing, underwear, legwear or piercings to sync to it. Then use the stone in-hand to send sensations to the wearer.")

/obj/item/portal_clothes/attack_self(mob/user)
	if(!paired_with)
		to_chat(user,"[src] is not currently paired with any clothing, use it on some clothing to pair it.")
		return
	if(!paired_with.clothing_holder)
		to_chat(user,"[src] is not currently paired with any clothing, use it on some clothing to pair it.")
		return
	if(!paired_with.current_holder)
		to_chat(user,"[paired_with.clothing_holder] is not currently equipped on anyone...")
		return
	var/input_text = input(user, "What sensations are you transmitting through the portal stone?", "Message")
	if(input_text)
		paired_with.on_receive(src, user, input_text)
		to_chat(user, span_italics("You sent the following sensation: [input_text]"))

/obj/item/portal_clothes/Destroy()
	if(paired_with)
		QDEL_NULL(paired_with)
	. = ..()

/obj/item/portal_clothes/pre_attack(atom/A, mob/living/user, params)
	if(isclothing(A) || istype(A, /obj/item/undies) || istype(A, /obj/item/legwears) || istype(A, /obj/item/piercings))
		if(!user.Adjacent(A))
			return
		var/obj/item/the_clothing = A
		var/confirming = tgui_alert(user, "Do you want to sync [src] with the [the_clothing]?", "Make portal", list("Yes", "No"))
		if(!confirming || (confirming == "No"))
			return
		if(paired_with)
			to_chat(user,"[paired_with.clothing_holder] is no longer synced to [src].")
			paired_with.Destroy()
		var/stuff = src
		the_clothing.AddComponent(/datum/component/portal_clothes, stuff)
		to_chat(user,"[the_clothing] is now synced to [src].")
	return TRUE

// THE DATUM!

/datum/component/portal_clothes
	var/obj/item/portal_clothes/portal_stone
	var/obj/item/clothing_holder
	var/mob/current_holder
	var/first_use = TRUE

/datum/component/portal_clothes/Initialize(var/portal_stone_register)
	if(!isclothing(parent) && !istype(parent, /obj/item/undies) && !istype(parent, /obj/item/legwears) && !istype(parent, /obj/item/piercings))
		return COMPONENT_INCOMPATIBLE
	clothing_holder = parent
	portal_stone = portal_stone_register
	portal_stone.paired_with = src
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_ITEM_UNDERWEAR_EQUIPPED, PROC_REF(on_equip_undies))
	RegisterSignal(parent, COMSIG_ITEM_UNDERWEAR_REMOVE, PROC_REF(on_drop_undies))

/datum/component/portal_clothes/proc/on_equip(datum/source, mob/user)
	current_holder = user

/datum/component/portal_clothes/proc/on_drop(datum/source, mob/user)
	current_holder = null

/datum/component/portal_clothes/proc/on_equip_undies(datum/source, mob/user)
	current_holder = user

/datum/component/portal_clothes/proc/on_drop_undies(datum/source, mob/user)
	current_holder = null

/datum/component/portal_clothes/proc/on_send(datum/source, mob/user, sending_message)
	if(!current_holder || !clothing_holder || !portal_stone)
		return
	
	var/turf/where_we_are = get_turf(portal_stone)
	for(var/mob/people in where_we_are.contents)
		to_chat(people, span_italics("[portal_stone] responds with a sensation from [current_holder]: [sending_message]"))
	to_chat(current_holder, span_italics("Sent a sensation through [portal_stone]: [sending_message]"))

/datum/component/portal_clothes/proc/on_receive(datum/source, mob/user, receiving_message)
	if(!current_holder || !clothing_holder || !portal_stone)
		return
	
	to_chat(current_holder, span_italics("[clothing_holder] inflicts the following sensations on you: [receiving_message]"))
	if(first_use)
		to_chat(current_holder, span_smallred("You can respond to this message with a sensation by starting your say with a - symbol."))
		first_use = FALSE

/datum/component/portal_clothes/Destroy(force, silent)
	. = ..()
	if(portal_stone)
		if(!QDELETED(portal_stone))
			portal_stone.paired_with = null

/datum/component/portal_clothes/proc/clear_link()
	if(portal_stone)
		if(!QDELETED(portal_stone))
			portal_stone.paired_with = null
	Destroy()
