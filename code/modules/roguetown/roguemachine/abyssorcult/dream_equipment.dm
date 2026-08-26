/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter //thanks to ket for other abyssor clothing sprites
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "rainfall robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles rainfall."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "rain"
	icon = 'icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "sea robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles the waves of the great blue."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "sea"
	icon = 'icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_leader
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "sylveric robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by exalted abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles the woes of His dream."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "leaderrobe"
	icon = 'icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/head/roguetown/roguehood/abyssor_painter
	name = "quicksilver hood"
	desc = "A hood worn by the followers of Abyssor, with a unique spiral wrapping. How do they even see out of this? \
	It's said out of the many pigments of the dream, the most potent resembles quicksilver. \
	Hoods like these are designed to capture the fumes that are given off by the silvery paint... after completing certain rites."
	color = null
	icon_state = "silverhood"
	item_state = "silverhood"
	icon = 'icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/abyssor.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/helmet/heavy/abyssor_painter
	name = "sylveric helmet"
	desc = "Much like the accompanying robes, this sylveric-based creation serves to obscure the wearer. \
	Whether to hide the wearer's horrifically mutated visage as per the rumors surrounding the enigmatic voice of Abyssor. \
	Or to hide a less than imposing, dashing dark elf that would undermine the painter's authority. \
	It doesn't seem to be as sturdy as a dreamwalker's creations. \
	Somehow it allows the wearer to view through it clearly, though the thin, flakey metal hardly seems protective as a result."
	icon = 'icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/abyssor.dmi'
	icon_state = "leaderhelm"
	flags_inv = HIDEFACE|HIDESNOUT|HIDEEARS|HIDEHAIR
	body_parts_covered = FULL_HEAD
	adjustable = CANT_CADJUST
	smeltresult = null
	// Given it's dream-metal, allows dreamwalkers to repair this... should they pilfer it.
	item_flags = DREAM_ITEM
	armor_class = ARMOR_CLASS_LIGHT
	max_integrity = ARMOR_INT_HELMET_HARDLEATHER
	armor = ARMOR_PADDED
	block2add = null

/obj/item/clothing/head/roguetown/helmet/heavy/abyssor_painter/attack_self(mob/user)
	..()
	if(icon_state == "leaderhelm")
		icon_state = "leaderhelm_f"
		to_chat(user, span_notice("You adjust [src] into a sleek configuration."))
	else
		icon_state = "leaderhelm"
		to_chat(user, span_notice("You adjust [src] back to its standard configuration."))

	update_icon()
	if(loc == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_head()

/obj/item/rogueweapon/huntingknife/paint
	name = "painted knife"
	desc = "A simple functional knife made out of paints hardened into a pointy edge. It seems to be able to be used to attune itself with magical paints."
	icon_state = "paint_dagger"
	icon = 'icons/roguetown/weapons/dream_weapons.dmi'
	item_state = "paint_dagger"
	var/enchant_cooldown

/obj/item/rogueweapon/huntingknife/paint/attack_self(mob/user)
	. = ..()
	if(.)
		return TRUE

	if(world.time < enchant_cooldown)
		var/time_left = (enchant_cooldown - world.time) / (1 MINUTES)
		var/minutes_left = round(time_left, 0.1)
		to_chat(user, span_warning("[src] feels inert. It will take about [minutes_left] more minute\s before it can be empowered again."))
		return TRUE

	if(AddComponent(/datum/component/umbral_enchant, user))
		visible_message(span_purple("[src]'s aura turns purple, oozing thick droplets of paint."), span_purple("The [src] in my hand starts oozing abyssal paint."))
		enchant_cooldown = world.time + 2 MINUTES
		return TRUE
	else
		to_chat(user, span_warning("[src] fails to take the abyssal enchantment!"))
		return FALSE

/obj/item/rogueweapon/huntingknife/paint/examine(mob/user)
	. = ..()
	if(enchant_cooldown && world.time < enchant_cooldown)
		var/time_left = (enchant_cooldown - world.time) / (1 MINUTES)
		var/minutes_left = round(time_left, 0.1)
		. += span_notice("It feels inert. About [minutes_left] more minute\s required before it can ooze paint again.")
	else
		. += span_notice("Focusing on it feels like it could empower the blade with abyssal energy.")

/obj/item/rogueweapon/woodstaff/quarterstaff/steel/paint
	name = "sacred paintbrush"
	desc = "A divine paintbrush of a comical size. The blunt end is quite serviceable as an offensive implement, whilst the brush end lets Abyssorite painted harness their miracles."
	icon_state = "brush"
	icon = 'icons/roguetown/weapons/dream_weapons64.dmi'
	item_state = "brush"
	// Meant to be slightly better than a normal steel Qstaff, worse than silver/bsteel however.
	max_integrity = 225
	special = /datum/special_intent/ground_smash/paint_line

/obj/item/rogueweapon/woodstaff/quarterstaff/steel/paint_heal
	name = "sacred paintbrush"
	desc = "A divine paintbrush of a comical size. The blunt end is quite serviceable as an offensive implement, whilst the brush end lets Abyssorite painted harness their miracles."
	icon_state = "brush_heal"
	icon = 'icons/roguetown/weapons/dream_weapons64.dmi'
	item_state = "brush_heal"
	// More defense oriented than the other one.
	force_wielded = 22
	max_integrity = 275
	special = /datum/special_intent/ground_smash/paint_line/healing

/obj/effect/spawner/lootdrop/roguetown/random_paint_staff
	icon_state = "cot"
	loot = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff/steel/paint = 1,
		/obj/item/rogueweapon/woodstaff/quarterstaff/steel/paint_heal = 1
	)
	lootcount = 1

/datum/special_intent/ground_smash/paint_line
	name = "Paint Wave"
	desc = "Swings downward, sending a 6-tile line of abyssal paint cascading forward. Struck targets are offbalanced and slowed. Converts existing paint trails on hit into spiked traps."
	// 6 tiles straight ahead with 0.1s staggering
	tile_coordinates = list(
		list(0, 0, 0 SECONDS),
		list(0, 1, 0.1 SECONDS),
		list(0, 2, 0.2 SECONDS),
		list(0, 3, 0.3 SECONDS),
		list(0, 4, 0.4 SECONDS),
		list(0, 5, 0.5 SECONDS)
	)
	var/paint_payload_buff = /datum/status_effect/debuff/ink_spike/weak
	var/paint_payload_debuff = /datum/status_effect/debuff/ink_spike
	var/paint_consume_buff = FALSE
	var/paint_deny_buff = FALSE
	var/paint_color = "#580000"
	var/paint_apply_to_pulled = FALSE

/datum/special_intent/ground_smash/paint_line/healing
	desc = "Swings downward, sending a 6-tile line of abyssal paint cascading forward. Struck targets are offbalanced and slowed. Converts existing paint trails on hit into healing paints that can affect even those without paint affinity."
	paint_payload_buff = /datum/status_effect/buff/umbral_recovery
	paint_payload_debuff = /datum/status_effect/buff/umbral_recovery
	paint_consume_buff = TRUE
	paint_deny_buff = TRUE
	paint_color = "#b6e6b6"
	paint_apply_to_pulled = TRUE

/datum/special_intent/ground_smash/paint_line/apply_hit(turf/T)
	. = ..()

	if(!T || !isopenturf(T))
		return

	var/obj/effect/ink_trail/existing_trail = locate(/obj/effect/ink_trail) in T

	if(existing_trail)
		existing_trail.buff_payload = paint_payload_buff
		existing_trail.debuff_payload = paint_payload_debuff
		existing_trail.icon_state = "paint_gray"
		existing_trail.color = paint_color
		existing_trail.consume_buff = paint_consume_buff
		existing_trail.deny_buff = paint_deny_buff
		existing_trail.apply_to_pulled = paint_apply_to_pulled
		if(howner)
			existing_trail.caster_ref = WEAKREF(howner)
		if(HAS_TRAIT(howner, TRAIT_INK_AFFINITY))
			existing_trail.refresh_lifetime(15 SECONDS)
		else
			existing_trail.refresh_lifetime(8 SECONDS)
	else
		new /obj/effect/ink_trail(T, howner)

/obj/item/dream_material/parchment_abyssal
	name = "abyssal parchment"
	desc = "A piece of paper engraved with words that swirl rather than flow."
	icon_state = "scroll"

/obj/item/dream_material/parchment_abyssal/attack_self(mob/user)
	. = ..()
	if(.)
		return TRUE

	if(user && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.can_speak_in_language(/datum/language/abyssal))
			to_chat(H, span_purple("You begin to study the scroll, it's almost as if the words engrave themselves onto your mind's eye."))
			if(do_after(H, 8 SECONDS))
				H.grant_language(/datum/language/abyssal)
				to_chat(H, span_purple("As you study the abyssal script, the guttural tones of the Abyssal language suddenly make sense to you."))
				visible_message(span_notice("[user] studies [src], their eyes glowing briefly as they absorb the knowledge of the scroll."))
				qdel(src)
			return TRUE
		else
			to_chat(H, span_warning("You already understand the abyssal text written upon [src]."))
		return TRUE

/obj/item/dream_material/parchment_abyssal/examine(mob/user)
	. = ..()
	. += span_purple("Using this item will decipher its ancient text, granting you knowledge of the Abyssal tongue.")
