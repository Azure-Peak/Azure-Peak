#define BOG_CREAM_DURATION (30 MINUTES)

/obj/item/bog_cream
	name = "bog cream"
	desc = "A herbal remedy developed by Azurians who have to wade in and out of the swamp of olden day, allegedly a recipe passed down for generations. It is made from a dried, crushed leech, mixed with extract of artemisia or pipeweed, roasted, and then mixed in with tallow to be applied as a cream, and is said to stop leeches from attaching to your body."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "cream_bog"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.8
	grid_width = 32
	grid_height = 32

/obj/item/bog_cream/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with it in hand on yourself or someone else to ward off leeches for [BOG_CREAM_DURATION / (1 MINUTES)] minutes.")
	. += span_info("It cannot be applied again until the previous coat has worn off.")

/obj/item/bog_cream/attack_self(mob/user)
	if(isliving(user))
		apply_cream(user, user)

/obj/item/bog_cream/attack(mob/living/M, mob/living/user)
	apply_cream(M, user)

/obj/item/bog_cream/proc/apply_cream(mob/living/target, mob/living/user)
	if(!ishuman(target))
		return
	if(target.has_status_effect(/datum/status_effect/buff/bog_cream))
		to_chat(user, span_warning("[target == user ? "I am" : "[target] is"] already coated in bog cream."))
		return
	if(target == user)
		user.visible_message(span_notice("[user] starts rubbing [src] onto [user.p_them()]self."), span_notice("I start rubbing [src] onto myself..."))
	else
		user.visible_message(span_notice("[user] starts rubbing [src] onto [target]."), span_notice("I start rubbing [src] onto [target]..."))
	if(!do_after(user, 5 SECONDS, target = target))
		return
	if(QDELETED(src) || QDELETED(target))
		return
	if(target.has_status_effect(/datum/status_effect/buff/bog_cream))
		return
	target.apply_status_effect(/datum/status_effect/buff/bog_cream)
	if(target == user)
		to_chat(user, span_notice("I am coated in bog cream."))
	else
		to_chat(user, span_notice("I coat [target] in bog cream."))
		to_chat(target, span_notice("[user] coats me in bog cream."))
	qdel(src)

/datum/status_effect/buff/bog_cream
	id = "bog_cream"
	duration = BOG_CREAM_DURATION
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/buff/bog_cream

/datum/status_effect/buff/bog_cream/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_LEECHIMMUNE, id)

/datum/status_effect/buff/bog_cream/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LEECHIMMUNE, id)
	to_chat(owner, span_warning("The bog cream has worn off."))

/atom/movable/screen/alert/status_effect/buff/bog_cream
	name = "Bog Cream"
	desc = "Leeches will not attach to me."
	icon = 'icons/mob/screen_alert_misc.dmi'
	icon_state = "bog_cream"

/datum/crafting_recipe/roguetown/survival/bog_cream
	name = "Bog Cream (Artemisia)"
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	result = /obj/item/bog_cream
	reqs = list(
		/obj/item/natural/worms/leech = 1,
		/obj/item/alch/artemisia = 1,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		)
	craftdiff = 1
	subtype_reqs = FALSE

/datum/crafting_recipe/roguetown/survival/bog_cream/pipeweed
	name = "Bog Cream (Pipeweed)"
	reqs = list(
		/obj/item/natural/worms/leech = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		)

#undef BOG_CREAM_DURATION
