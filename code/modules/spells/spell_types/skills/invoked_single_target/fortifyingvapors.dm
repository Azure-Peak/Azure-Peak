/obj/effect/temp_visual/vapors_in
	icon = 'icons/effects/effects.dmi'
	icon_state = "mist"
	duration = 10
	layer = ABOVE_MOB_LAYER
	alpha = 200
	color = "#66ffbf"

/obj/effect/temp_visual/vapors_in/Initialize(mapload)
	. = ..()
	transform = matrix()*3
	animate(src, transform = matrix()*0.1, alpha = 0, time = duration, easing = EASE_IN)
	return INITIALIZE_HINT_NORMAL

/obj/effect/temp_visual/vapors_in/Destroy()
	if(ismob(loc))
		var/mob/M = loc
		M.vis_contents -= src
	return ..()

/obj/effect/temp_visual/vapors_out
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"
	duration = 8
	layer = ABOVE_MOB_LAYER
	alpha = 220
	color = "#66ff7a"

/obj/effect/temp_visual/vapors_out/Initialize(mapload, dir_to_go)
	. = ..()
	var/turf/T = get_step(src, dir_to_go)
	if(T)
		animate(src, pixel_x = (T.x - x) * 32, pixel_y = (T.y - y) * 32, alpha = 0, time = duration)
	return INITIALIZE_HINT_NORMAL

/datum/action/cooldown/spell/fortifying_vapors
	name = "Fortifying Vapors"
	desc = "A stream of medicinal vapors guided by mana, providing long-lasting but gradual healing to a target within 2 tiles. Requires a held or equipped censer as a medium for the vapors to waft from, and the vessel must be properly fueled."
	fluff_desc = "After generations of study, physickers refined the art of guiding mana through medicinal herbs and alchemical resins. With aid from arcyne scholars and inspiration from Pestra's teachings, the resulting vapors became a trusted method of battlefield recovery, carrying restorative essences deeper into the body than simple remedies ever could."
	button_icon = 'icons/mob/actions/antiquarianspells.dmi'
	button_icon_state = "fortifyingvapors"
	sound = 'sound/items/steamrelease.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	click_to_activate = TRUE
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 25
	cast_range = 2
	charge_required = FALSE
	cooldown_time = 15 SECONDS
	associated_skill = /datum/skill/misc/reading
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z
	required_items = list(/obj/item/flashlight/flare/torch/lantern/psycenser, /obj/item/flashlight/flare/torch/lantern/censer)

/datum/action/cooldown/spell/fortifying_vapors/proc/get_censer(mob/user)
	for(var/obj/item/flashlight/flare/torch/lantern/C in user.held_items)
		if(istype(C, /obj/item/flashlight/flare/torch/lantern/psycenser))
			return C
		if(istype(C, /obj/item/flashlight/flare/torch/lantern/censer))
			return C
	return null

/datum/action/cooldown/spell/fortifying_vapors/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		return FALSE
	var/obj/item/flashlight/flare/torch/lantern/C = get_censer(owner)
	if(!C)
		to_chat(owner, span_warning("You require a censer in hand to guide the vapors."))
		return FALSE
	if(!C.on)
		to_chat(owner, span_warning("The censer needs to be on for any vapors to flee from it."))
		return FALSE
	if(istype(C, /obj/item/flashlight/flare/torch/lantern/censer))
		var/obj/item/flashlight/flare/torch/lantern/censer/N = C
		if(N.herb_charges <= 0)
			to_chat(owner, span_warning("There is not enough herbal fuel in the censer."))
			return FALSE
	var/mob/living/L = cast_on
	if(L.has_status_effect(/datum/status_effect/buff/fortifyingvapors))
		to_chat(owner, span_warning("They are already under the effects of fortifying vapors."))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/fortifying_vapors/cast(atom/cast_on)
	var/obj/item/flashlight/flare/torch/lantern/C = get_censer(owner)
	var/datum/herbal_recipe/recipe
	if(istype(C, /obj/item/flashlight/flare/torch/lantern/censer))
		var/obj/item/flashlight/flare/torch/lantern/censer/N = C
		N.herb_charges = max(N.herb_charges - 1, 0)
		recipe = N.recipe
	. = ..()
	var/mob/living/target = cast_on
	if(!istype(target))
		return FALSE
	show_visible_message(owner, span_necrosis("[owner] waves their lit censer around, wafting about benefic scents."))
	to_chat(target, span_warning("A heady scent fills my nostrils. My pulse quickens; I feel clear and sharp."))
	var/obj/effect/temp_visual/vapors_in/V = new
	target.vis_contents += V
	var/turf/T = get_turf(owner)
	new /obj/effect/temp_visual/vapors_out(T, NORTHEAST)
	new /obj/effect/temp_visual/vapors_out(T, NORTHWEST)
	new /obj/effect/temp_visual/vapors_out(T, SOUTHEAST)
	new /obj/effect/temp_visual/vapors_out(T, SOUTHWEST)
	target.apply_status_effect(/datum/status_effect/buff/fortifyingvapors, recipe)
	target.playsound_local(target, 'sound/magic/heartbeat.ogg', 100)
	return TRUE

#define VAPORS_HEALING_FILTER "fortifying_vapors_glow"

/atom/movable/screen/alert/status_effect/buff/fortifyingvapors
	name = "Fortifying Vapors"
	desc = "A heady scent fills my nostrils. My pulse quickens; I feel clear and sharp."
	icon_state = "pom_anxiety"
	color = "#00ffc8"

/atom/movable/screen/alert/status_effect/buff/fortified
	name = "Fortified"
	desc = "The aromatic vapors invigorate my body."
	icon_state = "pom_anxiety"
	color = "#bbff00"

/atom/movable/screen/alert/status_effect/buff/healingvapors
	name = "Healing Vapors"
	desc = "Restorative vapors slowly mend injuries according to their herbal preparation."
	icon_state = "pom_anxiety"
	color = "#9bff9b"

/datum/status_effect/buff/fortifyingvapors
	id = "fortifyingvapors"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fortifyingvapors
	duration = 30 SECONDS
	examine_text = "<font color='#00ff6a'>SUBJECTPRONOUN is surrounded by subtle, heady vapors.</font>"
	var/healing_on_tick = 0.5
	var/outline_colour = "#9ebb5b"
	var/datum/herbal_recipe/recipe

/datum/status_effect/buff/fortifyingvapors/on_apply(datum/herbal_recipe/R)
	recipe = R

	var/filter = owner.get_filter(VAPORS_HEALING_FILTER)
	if(!filter)
		owner.add_filter(VAPORS_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))

	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, "fortifyingvape")

	return TRUE

/datum/status_effect/buff/fortifyingvapors/tick()
	var/base_heal = healing_on_tick
	var/brute_heal = base_heal
	var/burn_heal = base_heal
	var/toxin_heal = base_heal
	var/oxy_heal = base_heal

	if(recipe)
		brute_heal += recipe.brute * 0.15
		burn_heal += recipe.burn * 0.15
		toxin_heal += recipe.toxin * 0.15

	if(owner.getBruteLoss())
		owner.adjustBruteLoss(-min(brute_heal, owner.getBruteLoss()), 0)

	if(owner.getFireLoss())
		owner.adjustFireLoss(-min(burn_heal, owner.getFireLoss()), 0)

	if(owner.getToxLoss())
		owner.adjustToxLoss(-min(toxin_heal, owner.getToxLoss()), 0)

	if(owner.getOxyLoss())
		owner.adjustOxyLoss(-min(oxy_heal, owner.getOxyLoss()), 0)

	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -base_heal)
	owner.adjustCloneLoss(-base_heal, 0)

	if(recipe?.blood)
		var/blood_heal = BLOOD_VOLUME_NORMAL * (recipe.blood * 0.01)
		owner.blood_volume = min(owner.blood_volume + blood_heal, BLOOD_VOLUME_NORMAL)

	if(recipe?.wounds)
		for(var/datum/wound/W in owner.get_wounds())
			if(W.whp <= 0)
				continue

			var/wound_heal = max(W.whp * (recipe.wounds * 0.01), 0.5)
			wound_heal = min(wound_heal, W.whp)

			W.heal_wound(wound_heal)

			if(W.bleed_rate > 0)
				var/bleed_heal = max(W.bleed_rate * (recipe.wounds * 0.1), 0.2)
				W.set_bleed_rate(max(W.bleed_rate - bleed_heal, 0))

	owner.update_damage_overlays()

/datum/status_effect/buff/fortifyingvapors/on_remove()
	owner.remove_filter(VAPORS_HEALING_FILTER)
	owner.update_damage_hud()
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, "fortifyingvape")

/datum/status_effect/buff/healingvapors
	id = "healingvapors"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healingvapors
	duration = 1 MINUTES
	examine_text = "<font color='#00ff6a'>SUBJECTPRONOUN is surrounded by restorative medicinal vapors.</font>"
	var/datum/herbal_recipe/recipe
	var/outline_colour = "#9ebb5b"
	var/min_heal = 0.25

/datum/status_effect/buff/healingvapors/on_apply(datum/herbal_recipe/R)
	recipe = R

	var/filter = owner.get_filter(VAPORS_HEALING_FILTER)
	if(!filter)
		owner.add_filter(VAPORS_HEALING_FILTER, 2, list("type" = "outline",	"color" = outline_colour, "alpha" = 60, "size" = 1))

	return TRUE

/datum/status_effect/buff/healingvapors/tick()
	if(!recipe)
		return

	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/fortifyingvapors(get_turf(owner))
	H.color = "#9ebb5b"

	if(recipe.brute)
		var/brute = owner.getBruteLoss()
		if(brute > 0)
			var/heal = max(brute * (recipe.brute * 0.01), min_heal)
			heal = min(heal, brute)
			owner.adjustBruteLoss(-heal, 0)

	if(recipe.burn)
		var/burn = owner.getFireLoss()
		if(burn > 0)
			var/heal = max(burn * (recipe.burn * 0.01), min_heal)
			heal = min(heal, burn)
			owner.adjustFireLoss(-heal, 0)

	if(recipe.toxin)
		var/toxin = owner.getToxLoss()
		if(toxin > 0)
			var/heal = max(toxin * (recipe.toxin * 0.01), min_heal)
			heal = min(heal, toxin)
			owner.adjustToxLoss(-heal, 0)

	if(recipe.wounds)
		for(var/datum/wound/W in owner.get_wounds())
			if(W.whp <= 0)
				continue

			var/heal = max(W.whp * (recipe.wounds * 0.01), min_heal)
			heal = min(heal, W.whp)

			W.heal_wound(heal)

	if(recipe.blood)
		var/blood_heal = BLOOD_VOLUME_NORMAL * (recipe.blood * 0.01)
		owner.blood_volume = min(owner.blood_volume + blood_heal, BLOOD_VOLUME_NORMAL)

	owner.update_damage_overlays()

/datum/status_effect/buff/healingvapors/on_remove()
	owner.remove_filter(VAPORS_HEALING_FILTER)
	owner.update_damage_hud()

#undef VAPORS_HEALING_FILTER
