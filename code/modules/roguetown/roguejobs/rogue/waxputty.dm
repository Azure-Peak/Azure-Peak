#define PUTTY_READY 1
#define PUTTY_IMPRINTED 2
#define PUTTY_FILLED 3

/datum/crafting_recipe/roguetown/stealth
	abstract_type = /datum/crafting_recipe/roguetown/stealth
	display_category = ITEM_CAT_MISCELLANEOUS
	skillcraft = /datum/skill/misc/sneaking

/datum/crafting_recipe/roguetown/stealth/puddy_tallow
	name = "Wax Putty (Tallow)"
	result = list(/obj/item/waxputty)
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 2)
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/crafting_recipe/roguetown/stealth/puddy_butter
	name = "Wax Putty (Butter slices & Flour)"
	result = list(/obj/item/waxputty)
	reqs = list(/obj/item/reagent_containers/food/snacks/butterslice = 3,
				/obj/item/reagent_containers/powder/flour = 2,)
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/crafting_recipe/roguetown/stealth/puddy_candles
	name = "Wax Putty (Candles)"
	result = list(/obj/item/waxputty)
	reqs = list(/obj/item/candle = 5)
	subtype_reqs = TRUE
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/crafting_recipe/roguetown/stealth/puddy_recycle
	name = "Wax Putty (Recycle)"
	result = list(/obj/item/waxputty)
	reqs = list(/obj/item/waxputty_used = 2)
	craftdiff = SKILL_LEVEL_APPRENTICE

/obj/item/waxputty
	name = "wax putty"
	desc = "A glob of melted, mushed-together wax. It looks easy to hide in your palm, and soft enough to imprint upon a particular shape."
	icon = 'icons/roguetown/items/waxputty.dmi'
	icon_state = "waxputty"
	item_flags = INHANDS_INVISIBLE	// This will not show up on examine as a held item. Sneaky!
	var/state = PUTTY_READY
	var/held_lockhash
	var/cooldown //world.time snapshot to prevent spam. changeNext_move would probably work here, pending testing
	experimental_inhand = FALSE
	grid_height = 64
	grid_width = 32

/obj/item/waxputty/examine(mob/user)
	. = ..()
	switch(state)
		if(PUTTY_READY)
			. += span_notice("Use in-hand to detect valid SAFE imprinting targets.")
			. += span_notice("CLICK on a mob to try and imprint their last used key. UNSAFE imprinting may result in the loss of this item.")
		if(PUTTY_IMPRINTED)
			. += span_notice("A butter slice or a candle may be used to fill in the mold.")
		if(PUTTY_FILLED)
			. += span_notice("The key is prepared. Use in-hand to snap the key out of the putty.")
			. += span_notice("A butter slice or a candle may be used to reset this putty.")

/obj/item/waxputty/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use in-hand to be notified of valid key imprinting targets. A little key icon will appear next to their heads. This makes them safe to imprint.")
	. += span_info("Click on a mob to try and imprint their last used key. If they were safe, this will automatically succeed and imprint.")
	. += span_info("Once imprinted, the putty should be clicked on by a BUTTER SLICE or a CANDLE (any) to fill in the mold.")
	. += span_info("Once filled, the putty can be used in-hand to snap the key out of the shell, ruining the putty.")
	. += span_info("An imprinted & filled putty can be clicked on by a BUTTER SLICE or a CANDLE (any) again to reset the putty.")
	. += span_info("Examining the item should give a hint as to what steps are possible.")

// Meant to be a functionless item, hence new path. Prevents subtype parent call incidents.
/obj/item/waxputty_used
	name = "used wax putty"
	desc = "Shards of what once was malleable wax. It's been used to make a key of some kind. Useless on its own, but can be recycled with another like this."
	icon = 'icons/roguetown/items/waxputty.dmi'
	icon_state = "waxputty_useless"

/obj/item/waxputty/attack(mob/living/target, mob/living/user)
	if(!ishuman(target) || target == user)
		. = ..()
		return

	if(isliving(user))
		var/mob/living/L = user
		if(L.has_status_effect(/datum/status_effect/debuff/thiefalert))
			return

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.last_used_keyhash)
			var/keyhash = H.last_used_keyhash
			if(H.key_imprint_valid_until > world.time)
				attempt_imprint(user, H, keyhash, forced_success = TRUE)
			else
				attempt_imprint(user, H, keyhash)

/obj/item/waxputty/interact(mob/user)
	. = ..()
	if(state == PUTTY_READY)
		if(cooldown < world.time)
			scan_for_targets(user)
			return
		else
			to_chat(user, span_warning("I can't focus this frequently."))
	if(state == PUTTY_FILLED)
		var/mob/living/L = user
		var/turf/T = get_turf(user)
		visible_message(span_warning("[user] <b>snaps</b> the puddy, letting a wax key loose."))
		playsound(user, pick('sound/effects/wax_break1.ogg','sound/effects/wax_break2.ogg','sound/effects/wax_break3.ogg','sound/effects/wax_break4.ogg'), 100, TRUE)
		var/uses = (L.get_skill_level(/datum/skill/misc/sneaking) * 2)
		uses += (rand(L.STALUC - 10, uses))
		L.put_in_hands(new /obj/item/roguekey/waxkey(T, held_lockhash, uses))
		new /obj/item/waxputty_used(T)
		qdel(src)

/obj/item/waxputty/proc/scan_for_targets(mob/living/user)
	for(var/mob/living/carbon/human/H in get_hearers_in_view(7, user, RECURSIVE_CONTENTS_CLIENT_MOBS))
		if(H.last_used_keyhash && H.key_imprint_valid_until > world.time)
			H.key_imprint_valid_until += 2 SECONDS
			H.play_overhead_private(list(user), "eff_validkey", 8, (H.key_imprint_valid_until - world.time))
	cooldown = world.time + 3 SECONDS

/obj/item/waxputty/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(state == PUTTY_IMPRINTED)
		if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice) || istype(I, /obj/item/candle))
			visible_message(span_info("[user] starts to drip \the [I] into the imprint of the key..."), vision_distance = 3)
			if(do_after(user, 4 SECONDS, TRUE))
				to_chat(user, span_info("It is done. Use the puddy in your hands to extract the key. Fill it with an extra candle or slice of butter to reset it."))
				state = PUTTY_FILLED
				icon_state = "waxputty_keymold_filled"
				qdel(I)
				return
	if(state == PUTTY_FILLED)
		if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice) || istype(I, /obj/item/candle))
			visible_message(span_info("[user] starts to drip \the [I] into the remaining gaps, slowly reshaping it back to its original form..."), vision_distance = 3)
			if(do_after(user, 4 SECONDS, TRUE))
				to_chat(user, span_info("The puddy has been reset. It can be used to imprint a key again."))
				state = PUTTY_READY
				icon_state = "waxputty"
				qdel(I)
				return

/obj/item/waxputty/proc/attempt_imprint(mob/living/user, mob/living/carbon/human/target, keyhash, forced_success = FALSE)
	if(!user || !target)
		CRASH("attempt_imprint called without valid user or target, there might be an abstract way to call pre_attack without an attacker or the target was deleted.")
	if(!keyhash)
		CRASH("attempt_imprint called without a keyhash. Make sure it's being passed into the arguments, or somehow a door with null / 0 keyhash was (un)locked.")
	if(target)
		target.key_imprint_valid_until = world.time - 0.1 SECONDS // Regardless of outcome, the target shouldn't be "safe" imprintable again.
	if(forced_success)
		imprint(user, keyhash)
		return

	var/user_stealth = user.get_skill_level(/datum/skill/misc/sneaking)
	var/target_stealth = target.get_skill_level(/datum/skill/misc/sneaking)
	var/user_for = user.STALUC
	var/target_for = target.STALUC

	//Our skill vs their skill, our for vs their for, times ten.
	var/final_prob = ((((user_stealth / 2) - target_stealth)) + (user_for - target_for)) * 10
	final_prob = clamp(final_prob, 10, 60) // This isn't the main way to use puddy at all, it's more for thiefbaiting and immersive sim play.

	if(prob(final_prob))
		imprint(user, keyhash)
	else
		failed_attempt(user, target)


/obj/item/waxputty/proc/imprint(mob/living/user, keyhash)
	to_chat(user, span_notice("The shape moulds perfectly."))
	user.playsound_local(user, 'sound/effects/wax_imprint_success.ogg', 100)
	held_lockhash = keyhash
	icon_state = "waxputty_keymold"
	state = PUTTY_IMPRINTED

/obj/item/waxputty/proc/failed_attempt(mob/living/user, mob/living/target)
	playsound(user, pick('sound/effects/thief_alert1.ogg', 'sound/effects/thief_alert2.ogg'), 100, TRUE)
	user.visible_message(span_alert("A THIEF!"), ignored_mobs = list(user), vision_distance = 5)
	user.apply_status_effect(/datum/status_effect/debuff/thiefalert)
	var/bad_luck = 50 - ((user.STALUC - 10) * 10) + ((target.STALUC - 10) * 10)
	if(prob(bad_luck))
		new /obj/item/waxputty_used(get_turf(user))
		qdel(src)

/datum/status_effect/debuff/thiefalert
	id = "thiefalert"
	mob_effect_icon_state = "eff_thiefalert"
	mob_effect_offset_y = 30
	duration = 10 SECONDS

/datum/status_effect/debuff/thiefalert/on_apply()
	. = ..()
	if(owner)
		owner.toggle_rogmove_intent(MOVE_INTENT_WALK)

#undef PUTTY_READY
#undef PUTTY_IMPRINTED
#undef PUTTY_FILLED
