/datum/component/stag_essence
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/bites_required = 0
	var/list/eater_tracker = list() // Key: real_name, Value: bites_taken

/datum/component/stag_essence/Initialize()
	if(!istype(parent, /obj/item/reagent_containers/food/snacks))
		return COMPONENT_INCOMPATIBLE

	var/obj/item/reagent_containers/food/snacks/S = parent
	bites_required = S.bitesize

	// Pale white outline and subtle glow
	S.add_filter("stag_glow_outline", 1, list("type" = "outline", "color" = "#f0f0f0", "size" = 1))
	S.add_filter("stag_glow_internal", 2, list("type" = "blur", "size" = 2, "color" = "#ffffff"))

	RegisterSignal(parent, COMSIG_FOOD_EATEN, PROC_REF(on_food_eaten))

/datum/component/stag_essence/proc/on_food_eaten(datum/source, mob/living/eater, mob/living/feeder)
	SIGNAL_HANDLER

	if(!eater || !eater.real_name)
		return
	eater_tracker[eater.real_name]++

	if(eater_tracker[eater.real_name] == 1)
		to_chat(eater, span_bigbold("A tingle of power. Not enough, you need it all, consume the whole cut!"))

	if(eater_tracker[eater.real_name] >= bites_required)
		to_chat(eater, span_bigbold("Your muscles strengthen. Something has changed, the power of the stag dwells within you now."))
		eater.AddComponent(/datum/component/stag_protection)
		ADD_TRAIT(eater, TRAIT_WHITE_STAG, TRAIT_STATUS_EFFECT)

#define MOVESPEED_ID_FOREST_RUSH "forest_rush"

/datum/status_effect/buff/forest_rush
	id = "forest_rush"
	duration = 6 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/white_rush // Reusing alert icon
	// Very weak given this triggers when armor is hit too.
	var/healing_per_tick = 0.5

/datum/status_effect/buff/forest_rush/on_creation(mob/living/new_owner)
	effectedstats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1
	)
	return ..()

/datum/status_effect/buff/forest_rush/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	owner.add_movespeed_modifier(MOVESPEED_ID_FOREST_RUSH, update=TRUE, priority=15, multiplicative_slowdown=-0.25)
	if(prob(30))
		owner.visible_message(span_danger("[owner.name] swells with a rush of power upon being struck!"))
	return TRUE

/datum/status_effect/buff/forest_rush/tick()
	var/mob/living/carbon/human/H = owner
	H.adjustBruteLoss(-healing_per_tick)
	var/list/wCount = H.get_wounds()
	if(length(wCount))
		H.heal_wounds(healing_per_tick)
		H.update_damage_overlays()
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume + healing_per_tick, BLOOD_VOLUME_NORMAL)
	var/obj/effect/temp_visual/heal/E = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	E.color = "#ffffff"

/datum/status_effect/buff/forest_rush/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_FOREST_RUSH)
	return ..()

#undef MOVESPEED_ID_FOREST_RUSH

/datum/component/stag_protection
	var/damage_threshold = 5

/datum/component/stag_protection/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damage))

/datum/component/stag_protection/proc/on_damage(datum/source, damage, damagetype)
	SIGNAL_HANDLER

	if(damage < damage_threshold)
		return

	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/buff/forest_rush)
