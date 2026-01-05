/obj/effect/proc_holder/spell/self/conjure_armor/dragonhide
	name = "Conjure Dragonhide"
	desc = "Conjure a Dragonhide Barrier. Granting long-lasting protection from attacks and an especial affinity against flames. Your armor slot must be free to use this.\n\
	The barrier lasts until it is broken, a new one is summoned, or the spell is forgotten."
	overlay_state = "conjure_dragonhide"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 50
	chargedrain = 1
	chargetime = 3 SECONDS
	no_early_release = TRUE
	recharge_time = 3 MINUTES

	warnie = "spellwarning"
	no_early_release = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 4 // upgrade on ring, + firestack immunity pretty dang good.
	spell_tier = 2 // Spellblade tier.

	invocations = list("Equitare Draconis") // google translate latin 'ride the dragon' - If someone literate wants to change this, feel free to.
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM


	objtoequip = /obj/item/clothing/suit/roguetown/dragonhide
	slottoequip = SLOT_ARMOR
	checkspot = "armor"

/obj/effect/proc_holder/spell/self/conjure_armor/conjure_dragonhide/Destroy()
	if(src.conjured_armor)
		conjured_armor.visible_message(span_warning("The [conjured_armor]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(conjured_armor)
	return ..()



/obj/item/clothing/suit/roguetown/dragonhide
	name = "dragonhide"
	desc = "An arcyne art first mastered by the 'dragonsbreath magisters' of Lirvas. This barrier protects best against the heat."
	max_integrity = 200
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "conjure_dragonhide"
	slot_flags = ITEM_SLOT_ARMOR
	mob_overlay_icon = null
	sleeved = null
	boobed = FALSE
	flags_inv = null
	armor_class = ARMOR_CLASS_LIGHT
	blade_dulling = DULLING_BASHCHOP
	blocksound = PLATEHIT
	armor = ARMOR_DRAGONHIDE
	body_parts_covered = COVERAGE_FULL | COVERAGE_HEAD_NOSE | NECK | HANDS | FEET
	unenchantable = TRUE

/obj/item/clothing/suit/roguetown/dragonhide/equipped(mob/living/user)
	. = ..()
	if(!QDELETED(src))
		user.apply_status_effect(/datum/status_effect/buff/dragonhide)


/obj/item/clothing/suit/roguetown/dragonhide/proc/dispel()
	if(!QDELETED(src))
		src.visible_message(span_warning("The [src]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(src)

/obj/item/clothing/suit/roguetown/dragonhide/obj_break()
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/suit/roguetown/dragonhide/attack_hand(mob/living/user)
	. = ..()
	if(!QDELETED(src))
		dispel()
	
/obj/item/clothing/suit/roguetown/dragonhide/dropped(mob/living/user)
	. = ..()
	user.remove_status_effect(/datum/status_effect/buff/dragonhide)
	if(!QDELETED(src))
		dispel()



#define DRAGONHIDE_FILTER "dragonhide_glow"

/datum/status_effect/buff/dragonhide
	id = "dragonscaled"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dragonhide
	duration = -1
	examine_text = "<font color='red'>SUBJECTPRONOUN is covered in ashy scales!</font>"
	var/outline_colour = "#c23d09"

/atom/movable/screen/alert/status_effect/buff/dragonhide
	name = "Dragonhide"
	desc = "Flames dance at my heels, yet do not sting!"

/datum/status_effect/buff/dragonhide/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NOFIRE, TRAIT_GENERIC)
	var/filter = owner.get_filter(DRAGONHIDE_FILTER)
	if (!filter)
		owner.add_filter(DRAGONHIDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))

/datum/status_effect/buff/dragonhide/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOFIRE, TRAIT_GENERIC)
	owner.remove_filter(DRAGONHIDE_FILTER)

#undef DRAGONHIDE_FILTER



