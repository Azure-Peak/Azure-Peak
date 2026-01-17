/////////////////// KEYRING ////////////////////

/obj/item/storage/keyring
	name = "keyring"
	desc = "Will help you organize your keys."
	icon_state = "keyring0"
	icon = 'icons/roguetown/items/keys.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0
	throwforce = 0
	var/list/keys = list()
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_MOUTH|ITEM_SLOT_WRISTS
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	anvilrepair = /datum/skill/craft/blacksmithing
	resistance_flags = FIRE_PROOF
	experimental_inhand = FALSE
	component_type = /datum/component/storage/concrete/roguetown/keyring

/obj/item/storage/keyring/Initialize()
	. = ..()
	for(var/X in keys)
		var/obj/item/key/new_key = new X(loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_key, null, TRUE, TRUE))
			qdel(new_key)

	update_icon()
	update_desc()

/obj/item/storage/keyring/attack_right(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.rmb_show(user)
		return TRUE

/obj/item/storage/keyring/update_icon()
    ..()
    switch(contents.len)
        if(0)
            icon_state = "keyring0"
        if(1)
            icon_state = "keyring1"
        if(2)
            icon_state = "keyring2"
        if(3)
            icon_state = "keyring3"
        if(4)
            icon_state = "keyring4"
        else
            icon_state = "keyring5"

/obj/item/storage/keyring/proc/update_desc()
	if(contents.len)
		desc = span_info("Holds \Roman[contents.len] key\s, including:")
		for(var/obj/item/roguekey/KE in contents)
			desc += span_info("\n- [KE.name ? "A [KE.name]." : "	An unknown key."]")
	else
		desc = ""

/obj/item/storage/keyring/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
    . = ..()
    playsound(src, "sound/items/gems (1).ogg", 100, FALSE)
    update_desc()

/obj/item/storage/keyring/Exited(atom/movable/gone, direction)
    . = ..()

/obj/item/storage/keyring/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,
"sx" = -6,
"sy" = -3,
"nx" = 13,
"ny" = -3,
"wx" = -2,
"wy" = -3,
"ex" = 4,
"ey" = -5,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 15,
"sturn" = 0,
"wturn" = 0,
"eturn" = 39,
"nflip" = 8,
"sflip" = 0,
"wflip" = 0,
"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/////////////////// LOCKPICKRING ////////////////////

/obj/item/lockpickring
	name = "lockpickring"
	desc = "A piece of bent wire to store lockpicking tools. Too bulky for fine work."
	icon_state = "pickring0"
	icon = 'icons/roguetown/items/keys.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	var/list/picks = list()
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_MOUTH|ITEM_SLOT_WRISTS
	experimental_inhand = FALSE
	dropshrink = 0.7

/obj/item/lockpickring/Initialize()
	. = ..()
	if(picks.len)
		for(var/X in picks)
			addtoring(new X())
			picks -= X
	update_icon()

/obj/item/lockpickring/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,
"sx" = -6,
"sy" = -3,
"nx" = 13,
"ny" = -3,
"wx" = -2,
"wy" = -3,
"ex" = 4,
"ey" = -5,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 15,
"sturn" = 0,
"wturn" = 0,
"eturn" = 39,
"nflip" = 8,
"sflip" = 0,
"wflip" = 0,
"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/lockpickring/proc/addtoring(obj/item/I)
	if(!I || !istype(I))
		return 0
	I.loc = src
	picks += I
	update_icon()
	update_desc()

/obj/item/lockpickring/proc/removefromring(mob/user)
	if(!picks.len)
		return
	var/obj/item/lockpick/K = picks[picks.len]
	picks -= K
	K.loc = user.loc
	update_icon()
	update_desc()
	return K

/obj/item/lockpickring/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/lockpick))
		if(picks.len >= 3)
			to_chat(user, "<span class='warning'>Too many lockpicks.</span>")
			return
		user.dropItemToGround(I)
		addtoring(I)
	else
		return ..()

/obj/item/lockpickring/attack_right(mob/user)
	if(picks.len)
		to_chat(user, "<span class='notice'>I steal a pick off the ring.</span>")
		var/obj/item/lockpick/K = removefromring(user)
		user.put_in_active_hand(K)

/obj/item/lockpickring/update_icon()
	..()
	if(!picks.len)
		icon_state = "pickring0"
		return
	if(picks.len >= 3)
		icon_state = "pickring3"
		return
	switch(picks.len)
		if(1)
			icon_state = "pickring1"
		if(2)
			icon_state = "pickring2"
		if(3)
			icon_state = "pickring3"

/obj/item/lockpickring/proc/update_desc()
	if(picks.len)
		desc = initial(desc)
		desc += "<span class='info'>\n\Roman [picks.len] lockpicks.</span>"
	else
		desc = initial(desc)

/obj/item/lockpickring/mundane
	picks = list(/obj/item/lockpick, /obj/item/lockpick, /obj/item/lockpick)

/obj/item/lockpickring/one
	picks = list(/obj/item/lockpick)

/obj/item/storage/keyring/sheriff
	keys = list(/obj/item/roguekey/sheriff, /obj/item/roguekey/dungeon, /obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/manor, /obj/item/roguekey/graveyard, /obj/item/roguekey/armory, /obj/item/roguekey/sergeant, /obj/item/roguekey/knight)

/obj/item/storage/keyring/judge
	keys = list(/obj/item/roguekey/sheriff, /obj/item/roguekey/armory, /obj/item/roguekey/dungeon, /obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/manor, /obj/item/roguekey/graveyard, /obj/item/roguekey/sergeant)

/obj/item/storage/keyring/councillor
	keys = list(/obj/item/roguekey/garrison, /obj/item/roguekey/manor, /obj/item/roguekey/graveyard)

/obj/item/storage/keyring/councillor/cofferer
	keys = list(/obj/item/roguekey/steward, /obj/item/roguekey/garrison, /obj/item/roguekey/manor, /obj/item/roguekey/graveyard)

/obj/item/storage/keyring/squire
	keys = list(/obj/item/roguekey/dungeon, /obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/manor)

/obj/item/storage/keyring/guard
	keys = list(/obj/item/roguekey/warden, /obj/item/roguekey/walls)

/obj/item/storage/keyring/guardcastle
	keys = list(/obj/item/roguekey/dungeon, /obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/manor, /obj/item/roguekey/armory)

/obj/item/storage/keyring/guardsergeant
	keys = list(/obj/item/roguekey/dungeon, /obj/item/roguekey/garrison, /obj/item/roguekey/warden, /obj/item/roguekey/walls, /obj/item/roguekey/manor, /obj/item/roguekey/armory, /obj/item/roguekey/sergeant)

/obj/item/storage/keyring/guardknight
	keys = list(/obj/item/roguekey/dungeon, /obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/manor, /obj/item/roguekey/knight)

/obj/item/storage/keyring/vtavern
	keys = list(/obj/item/roguekey/tavern/village, /obj/item/roguekey/roomvi/village, /obj/item/roguekey/roomv/village, /obj/item/roguekey/roomiv/village, /obj/item/roguekey/roomiii/village, /obj/item/roguekey/roomii/village, /obj/item/roguekey/roomi/village)

/obj/item/storage/keyring/gatemaster
	keys = list(/obj/item/roguekey/dungeon, /obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/manor, /obj/item/roguekey/armory)

/obj/item/storage/keyring/merchant
	keys = list(/obj/item/roguekey/shop, /obj/item/roguekey/merchant)

/obj/item/storage/keyring/mguard
	keys = list(/obj/item/roguekey/dungeon, /obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/manor, /obj/item/roguekey/armory)

/obj/item/storage/keyring/mage
	keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/university, /obj/item/roguekey/mage)

/obj/item/storage/keyring/innkeep
	keys = list(/obj/item/roguekey/tavern, /obj/item/roguekey/tavernkeep, /obj/item/roguekey/roomhunt, /obj/item/roguekey/roomvi, /obj/item/roguekey/roomv, /obj/item/roguekey/roomiv, /obj/item/roguekey/roomiii, /obj/item/roguekey/roomii, /obj/item/roguekey/roomi, /obj/item/roguekey/fancyroomi, /obj/item/roguekey/fancyroomii, /obj/item/roguekey/fancyroomiii, /obj/item/roguekey/fancyroomiv, /obj/item/roguekey/fancyroomv)

/obj/item/storage/keyring/priest
	keys = list(/obj/item/roguekey/priest, /obj/item/roguekey/church, /obj/item/roguekey/graveyard, /obj/item/roguekey/keeper)

/obj/item/storage/keyring/churchie
	keys = list(/obj/item/roguekey/church, /obj/item/roguekey/graveyard, /obj/item/roguekey/keeper)

/obj/item/storage/keyring/keeper
	keys = list(/obj/item/roguekey/keeper)

/obj/item/storage/keyring/puritan
	keys = list(/obj/item/roguekey/puritan, /obj/item/roguekey/inquisition)

/obj/item/storage/keyring/nightman
	keys = list(/obj/item/roguekey/nightman, /obj/item/roguekey/nightmaiden)

/obj/item/storage/keyring/hand
	keys = list(/obj/item/roguekey/hand, /obj/item/roguekey/steward, /obj/item/roguekey/tavern, /obj/item/roguekey/church, /obj/item/roguekey/walls, /obj/item/roguekey/dungeon, /obj/item/roguekey/garrison, /obj/item/roguekey/manor, /obj/item/roguekey/graveyard, /obj/item/roguekey/armory, /obj/item/roguekey/sergeant, /obj/item/roguekey/knight)

/obj/item/storage/keyring/steward
	keys = list(/obj/item/roguekey/steward, /obj/item/roguekey/garrison, /obj/item/roguekey/manor, /obj/item/roguekey/graveyard)

/obj/item/storage/keyring/clerk
	keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/graveyard)

/obj/item/storage/keyring/servant
	keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/garrison)

/obj/item/storage/keyring/archivist
	keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/archive, /obj/item/roguekey/university)

/obj/item/storage/keyring/physician
	keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/garrison, /obj/item/roguekey/physician, /obj/item/roguekey/keeper)

/obj/item/storage/keyring/royal
	keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/royal, /obj/item/roguekey/garrison)

/obj/item/storage/keyring/lord
	keys = list(/obj/item/roguekey/hand, /obj/item/roguekey/steward, /obj/item/roguekey/tavern, /obj/item/roguekey/church, /obj/item/roguekey/walls, /obj/item/roguekey/dungeon, /obj/item/roguekey/garrison, /obj/item/roguekey/manor, /obj/item/roguekey/graveyard, /obj/item/roguekey/royal, /obj/item/roguekey/armory, /obj/item/roguekey/sergeant, /obj/item/roguekey/knight)

/obj/item/storage/keyring/heir
	keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/heir, /obj/item/roguekey/garrison)

/obj/item/storage/keyring/mageapprentice
	keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/university)

/obj/item/storage/keyring/soilson
	keys = list(/obj/item/roguekey/farm, /obj/item/roguekey/apartments/stable1, /obj/item/roguekey/apartments/stable2)

/obj/item/storage/keyring/guildmaster
	keys = list(/obj/item/roguekey/crafterguild, /obj/item/roguekey/tailor, /obj/item/roguekey/craftermaster)

/obj/item/storage/keyring/tailor
	keys = list(/obj/item/roguekey/crafterguild, /obj/item/roguekey/tailor)

/obj/item/storage/keyring/vampire
	keys = list(/obj/item/roguekey/vampire, /obj/item/roguekey/vampire/guest, /obj/item/roguekey/vampire/maid)
