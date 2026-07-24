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
	primary_resource_cost = 15
	cast_range = 4
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

/datum/status_effect/buff/fortifyingvapors/on_creation(mob/living/new_owner, datum/herbal_recipe/R)
	recipe = R
	. = ..()

/datum/status_effect/buff/fortifyingvapors/on_apply(datum/herbal_recipe/R)
	var/filter = owner.get_filter(VAPORS_HEALING_FILTER)
	if(!filter)
		owner.add_filter(VAPORS_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	if(recipe?.catalyst)
		owner.process_vapor_catalyst(recipe.catalyst)
	return TRUE

/datum/status_effect/buff/fortifyingvapors/on_remove()
	owner.remove_filter(VAPORS_HEALING_FILTER)
	REMOVE_TRAIT(owner, TRAIT_ZOMBIE_SPEECH, "vapecrack")
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, "vapecrack")
	REMOVE_TRAIT(owner, TRAIT_GARGLE_SPEECH, "vapecrack")
	REMOVE_TRAIT(owner, TRAIT_MUSES_GRACE, "vapecrack")
	owner.update_damage_hud()

/datum/status_effect/buff/fortifyingvapors/tick()
	var/brute_heal = healing_on_tick
	var/burn_heal = healing_on_tick
	var/toxin_heal = healing_on_tick
	if(recipe)
		brute_heal += recipe.brute * 0.2
		burn_heal += recipe.burn * 0.2
		toxin_heal += recipe.toxin * 0.2
	if(owner.getBruteLoss())
		owner.adjustBruteLoss(-min(brute_heal, owner.getBruteLoss()), 0)
	if(owner.getFireLoss())
		owner.adjustFireLoss(-min(burn_heal, owner.getFireLoss()), 0)
	if(owner.getToxLoss())
		owner.adjustToxLoss(-min(toxin_heal, owner.getToxLoss()), 0)
	if(recipe?.blood)
		owner.adjustOxyLoss(-5)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume += BLOOD_VOLUME_NORMAL * 0.02
		for(var/datum/wound/W as anything in owner.get_wounds())
			if(!istype(W, /datum/wound/slash/incision))
				if(W.bleed_rate <= 0 && W.sew_threshold)
					W.sew_progress = W.sew_threshold
					W.sew_wound()
	if(recipe?.wounds)
		for(var/datum/wound/W as anything in owner.get_wounds())
			if(!istype(W, /datum/wound/slash/incision))
				W.heal_wound(3)

/datum/status_effect/buff/healingvapors
	id = "healingvapors"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healingvapors
	duration = 1 MINUTES
	examine_text = "<font color='#00ff6a'>SUBJECTPRONOUN is surrounded by restorative medicinal vapors.</font>"
	var/datum/herbal_recipe/recipe
	var/outline_colour = "#9ebb5b"
	var/min_heal = 0.25

/datum/status_effect/buff/healingvapors/on_creation(mob/living/new_owner, datum/herbal_recipe/R)
	recipe = R
	. = ..()

/datum/status_effect/buff/healingvapors/on_apply(datum/herbal_recipe/R)
	if(recipe?.catalyst)
		owner.process_vapor_catalyst(recipe.catalyst)
	var/filter = owner.get_filter(VAPORS_HEALING_FILTER)
	if(!filter)
		owner.add_filter(VAPORS_HEALING_FILTER, 2, list("type" = "outline",	"color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/healingvapors/tick()
	if(recipe?.brute)
		var/brute = owner.getBruteLoss()
		if(brute > 0)
			var/heal = max(brute * (recipe.brute * 0.03), min_heal)
			owner.adjustBruteLoss(-min(heal, brute), 0)
	if(recipe?.burn)
		var/burn = owner.getFireLoss()
		if(burn > 0)
			var/heal = max(burn * (recipe.burn * 0.03), min_heal)
			owner.adjustFireLoss(-min(heal, burn), 0)
	if(recipe?.toxin)
		var/toxin = owner.getToxLoss()
		if(toxin > 0)
			var/heal = max(toxin * (recipe.toxin * 0.03), min_heal)
			owner.adjustToxLoss(-min(heal, toxin), 0)
	if(recipe?.blood)
		owner.adjustOxyLoss(-10)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume += BLOOD_VOLUME_NORMAL * 0.03
		for(var/datum/wound/W as anything in owner.get_wounds())
			if(!istype(W, /datum/wound/slash/incision))
				if(W.bleed_rate <= 0 && W.sew_threshold)
					W.sew_progress = W.sew_threshold
					W.sew_wound()
	if(recipe?.wounds)
		for(var/datum/wound/W as anything in owner.get_wounds())
			if(!istype(W, /datum/wound/slash/incision))
				W.heal_wound(6)

/datum/status_effect/buff/healingvapors/on_remove()
	owner.remove_filter(VAPORS_HEALING_FILTER)
	REMOVE_TRAIT(owner, TRAIT_ZOMBIE_SPEECH, "vapecrack")
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, "vapecrack")
	REMOVE_TRAIT(owner, TRAIT_GARGLE_SPEECH, "vapecrack")
	REMOVE_TRAIT(owner, TRAIT_MUSES_GRACE, "vapecrack")
	owner.update_damage_hud()

/mob/living/proc/process_vapor_catalyst(catalyst, is_lethal = FALSE, stinky = FALSE)
	switch(catalyst)
		if("Ozium")
			visible_message(span_notice("A dull, sweet haze settles over [src], leaving [src.p_them()] eerily tranquil."), span_artery("I enter a world of bliss... Maybe too much of it. I'm slowing down everywhere."))
			ADD_TRAIT(src, TRAIT_ZOMBIE_SPEECH, "vapecrack")
			ADD_TRAIT(src, TRAIT_NOPAIN, "vapecrack")
			apply_status_effect(/datum/status_effect/buff/ozium)
			apply_status_effect(/datum/status_effect/buff/druqks)
			sate_addiction(/datum/charflaw/addiction/junkie)

		if("Moondust")
			if(!has_status_effect(/datum/status_effect/debuff/sleepytime))
				visible_message(span_notice("[src]'s eyes widen as manic energy courses through [src.p_them()]."), span_artery("OH, HEHE! I'M-- GOOD LORD, I'M TWITCHY. HEHEHEHE! I CAN'T SPEEEEAK!!!"))
				ADD_TRAIT(src, TRAIT_GARGLE_SPEECH, "vapecrack")
			else
				visible_message(span_notice("[src] suddenly seems wide awake, brimming with restless energy."), span_artery("I feel all my exhaustion just... poof! Gone."))
			apply_status_effect(/datum/status_effect/buff/moondust)
			apply_status_effect(/datum/status_effect/buff/druqks)
			if(src.has_status_effect(/datum/status_effect/debuff/sleepytime))
				remove_status_effect(/datum/status_effect/debuff/sleepytime)
				remove_stress(/datum/stressevent/sleepytime)
				src.mind.sleep_adv.advance_cycle()
			sate_addiction(/datum/charflaw/addiction/junkie)

		if("Spice")
			visible_message(span_notice("[src] shudders as an invigorating rush courses through [src.p_them()]."), span_artery("OhhHHHhhhhh YEEEEaaaAAAHHHHH!!"))
			apply_status_effect(/datum/status_effect/buff/invigoration, 30 SECONDS, 25, 15)
			apply_status_effect(/datum/status_effect/buff/druqks)
			sate_addiction(/datum/charflaw/addiction/junkie)

		if("Coffee")
			visible_message(span_notice("A rich aroma surrounds [src], who suddenly looks sharper and more alert."), span_artery("What an elegant, invigorating scent!"))
			apply_status_effect(/datum/status_effect/buff/invigoration, 30 SECONDS, 25, 15)
			apply_status_effect(/datum/status_effect/buff/vigorized)
			sate_addiction(/datum/charflaw/addiction/caffiend)

		if("Fae Dust")
			visible_message(span_notice("Glittering motes dance around [src] as [src.p_their()] gaze drifts into impossible colors."), span_artery("Where is my hands?... I can taste the colors and see the flavors!"))
			apply_status_effect(/datum/status_effect/buff/invigoration, 30 SECONDS, 25, 15)
			apply_status_effect(/datum/status_effect/buff/seelie_drugs)
			sate_addiction(/datum/charflaw/addiction/junkie)
			ADD_TRAIT(src, TRAIT_MUSES_GRACE, "vapecrack")

		if("Fermented Crab")
			visible_message(span_notice("[src] flushes slightly, wearing an oddly affectionate grin."), span_artery("I'm getting frisky!~"))
			apply_status_effect(/datum/status_effect/buff/fermented_crab)

		if("Coal")
			visible_message(span_notice("[src] breaks into a heavy sweat as dark impurities seem to leave [src.p_their()] body."), span_artery("I begin sweating rapidly... Unsavory, but all my impurities are coming out with it."))
			reagents.clear_reagents()

		if("Honey")
			visible_message(span_notice("Golden-scented vapors cling gently to [src]'s body."),	span_artery("I feel the vapors caressing my ailments with a potent anti-foulness to it."))
			if(has_status_effect(/datum/status_effect/debuff/rotted_zombie))
				if(remove_rot(target = src,	user = src,	method = "surgery",	success_message = "The rot leaves [src]'s body!", fail_message = "Nothing happens.", lethal = is_lethal))
					visible_message(span_green("The rot visibly sloughs away from [src]'s body."), span_green("I feel the rot leave my body!"))
					remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
					apply_status_effect(/datum/status_effect/debuff/rotted)
				else
					visible_message(span_warning("The honeyed vapors fail to purge any corruption from [src]."), span_warning("I feel no different..."))
			else
				visible_message(span_notice("The sweet vapors drift harmlessly around [src], finding no rot to cleanse."), span_notice("The honeyed vapors find no trace of rot within me."))

#undef VAPORS_HEALING_FILTER
