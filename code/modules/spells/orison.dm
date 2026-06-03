////////////////////
// BASE OF ORISON //
////////////////////

/datum/action/cooldown/spell/touch/orison
	name = "Orison"
	desc = "The fundamental teachings of theology return to you:\n \
	<b>Light</b>: Issue a prayer for illumination, causing you or another living creature to begin glowing with light for five minutes - this stacks each time you cast it, with no upper limit. Using thaumaturgy on a person will remove this blessing from them, and MMB on your praying hand will remove any light blessings from yourself.\n \
	<b>Fill</b>: Beseech your Divine to create a small quantity of water in a container that you touch for some devotion.\n \
	<b>Voice</b>: Direct a sliver of divine thaumaturgy into your being, causing your voice to become LOUD when you next speak. Known to sometimes scare the rats inside the SCOMlines. Can be used on light sources at range, and it will cause them flicker."

	background_icon = 'icons/mob/actions/genericmiracles.dmi'
	button_icon = 'icons/mob/actions/genericmiracles.dmi'
	button_icon_state = "thaumaturgy"

	draw_message = span_notice("I calm my mind and prepare to draw upon an orison.")
	drop_message = span_notice("I return my mind to the now.")

	hand_path = /obj/item/melee/new_touch_attack/orison
	can_cast_on_self = TRUE
	infinite_use = TRUE
	ignore_armor_penalty = TRUE

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE_ORISON

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_CANTRIP

	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 0

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	cooldown_time = 10 SECONDS

	attunement_school = null

	//required_items = list(/obj/item/clothing/neck/roguetown/psicross)

	var/thaumaturgy_devotion = 10
	var/light_devotion = 5
	var/water_moisten = 2

/datum/action/cooldown/spell/touch/orison/cast_on_hand_hit(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	switch(caster.used_intent.type)
		if(/datum/intent/hand/light)
			cast_light(hand, victim, caster)
			qdel(hand)
			return TRUE
		if(/datum/intent/hand/voice)
			thaumaturgy(hand, victim, caster)
			qdel(hand)
			return TRUE
		if(/datum/intent/fill)
			create_water(hand, victim, caster)
			qdel(hand)
			return TRUE
	return FALSE

// --- Touch Attack Item ---

/obj/item/melee/new_touch_attack/orison
	name = "\improper lesser prayer"
	desc = "Holy energy crackles at your fingertips, ready to serve you. Touch yourself to dismiss."
	possible_item_intents = list(/datum/intent/hand/light, /datum/intent/fill, /datum/intent/hand/voice)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#FFFFFF"
	associated_skill = /datum/skill/magic/holy
	experimental_inhand = FALSE

	var/right_click = FALSE

/obj/item/melee/new_touch_attack/orison/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	var/datum/action/cooldown/spell/touch/orison/spell = spell_which_made_us?.resolve()
	if(spell)
		spell.cast_on_hand_hit(src, target, user)

/obj/item/melee/new_touch_attack/orison/MiddleClick(mob/living/user, params)
	. = ..()
	if (user.has_status_effect(/datum/status_effect/light_buff))
		user.remove_status_effect(/datum/status_effect/light_buff)
		user.visible_message(span_notice("[user] closes [user.p_their()] eyes, and the holy light surrounding them retreats into their chest and disappears."), span_notice("I relinquish the gift of [user.patron.name]'s light."))
		return

////////////////////
// ORISON - LIGHT //
////////////////////

#define BLESSINGOFLIGHT_FILTER "bol_glow"

/atom/movable/screen/alert/status_effect/light_buff
	name = "Miraculous Light"
	desc = "A blessing of light wards off the darkness surrounding me."
	icon_state = "stressvg"

/datum/status_effect/light_buff
	id = "orison_light_buff"
	alert_type = /atom/movable/screen/alert/status_effect/light_buff
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	examine_text = "SUBJECTPRONOUN is surrounded by an aura of gentle light."
	var/outline_colour = "#ffffff"
	var/color_mob_light = "#f5edda"
	/// The object attached to the mob that emits light
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj
	/// Amount of light our buff emits, can be buffed by someone with higher miracles skill
	var/holy_light_power = 1

/datum/status_effect/light_buff/on_creation(mob/living/new_owner, light_power)
	if(light_power > holy_light_power)
		holy_light_power = light_power
	return ..()

/datum/status_effect/light_buff/refresh(mob/living/owner, light_power)
	duration += initial(duration) // stack this up as much as we can be bothered to cast it
	if(holy_light_power > mob_light_obj.light_power)
		mob_light_obj.light_power = holy_light_power

/datum/status_effect/light_buff/on_apply()
	. = ..()
	if (!.)
		return
	playsound(owner, 'sound/magic/whiteflame.ogg', 75, FALSE)
	to_chat(owner, span_notice("Light blossoms into being around me!"))
	var/filter = owner.get_filter(BLESSINGOFLIGHT_FILTER)
	if (!filter)
		owner.add_filter(BLESSINGOFLIGHT_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	mob_light_obj = owner.mob_light(7, 7, _color ="#f5edda")
	mob_light_obj.light_power = holy_light_power
	return TRUE

/datum/status_effect/light_buff/on_remove()
	playsound(owner, 'sound/items/firesnuff.ogg', 75, FALSE)
	to_chat(owner, span_notice("The miraculous light surrounding me has fled..."))
	owner.remove_filter(BLESSINGOFLIGHT_FILTER)
	QDEL_NULL(mob_light_obj)

/datum/action/cooldown/spell/touch/orison/proc/cast_light(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	var/holy_skill = caster.get_skill_level(/datum/skill/magic/holy)
	var/cast_time = 35 - (holy_skill * 3)
	var/mob/living/carbon/human/H = caster
	if (!victim.Adjacent(caster))
		to_chat(caster, span_info("I need to be next to [victim] to channel a blessing of light!"))
		return

	if(!isliving(victim))
		to_chat(caster, span_notice("Only living creachers can bear the blessing of [caster.patron.name]'s light."))
		return

	var/god_title = istype(caster.patron, /datum/patron/divine/undivided) ? "Ten Undivided" : "Blessed [caster.patron.name]"

	if(victim != caster)
		caster.visible_message(span_notice("[caster] reaches gently towards [victim], beads of light glimmering at [caster.p_their()] fingertips..."), span_notice("[god_title], I ask but for a light to guide the way..."))
	else
		caster.visible_message(span_notice("[caster] closes [caster.p_their()] eyes and places a glowing hand upon [caster.p_their()] chest..."), span_notice("[god_title], I ask but for a light to guide the way..."))

	if(!do_after(caster, cast_time, target = victim))
		return
	var/mob/living/living_thing = victim
	if (living_thing.has_status_effect(/datum/status_effect/light_buff))
		caster.visible_message(span_notice("The holy light emanating from [living_thing] becomes brighter!"), span_notice("I feed further devotion into [living_thing]'s blessing of light."))
	else
		caster.visible_message(span_notice("A gentle illumination suddenly blossoms into being around [living_thing]!"), span_notice("I grant [living_thing] a blessing of light."))

	var/light_power = clamp(4 + (holy_skill - 3), 4, 7)
	living_thing.apply_status_effect(/datum/status_effect/light_buff, light_power)

	H.devotion?.update_devotion(-SPELLCOST_MIRACLE_MINOR)
	StartCooldown()
	return light_devotion

#undef BLESSINGOFLIGHT_FILTER

////////////////////
// ORISON - VOICE //
////////////////////

/atom/movable/screen/alert/status_effect/thaumaturgy
	name = "Thaumaturgical Voice"
	desc = "The power of my god will make the next thing I say carry much further!"
	icon_state = "stressvg"

/datum/status_effect/thaumaturgy
	id = "thaumaturgy"
	alert_type = /atom/movable/screen/alert/status_effect/thaumaturgy
	duration = 30 SECONDS
	var/potency = 1

/datum/status_effect/thaumaturgy/on_creation(mob/living/new_owner, skill_power)
	potency = skill_power
	return ..()

/datum/action/cooldown/spell/touch/orison/proc/thaumaturgy(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	var/holy_skill = caster.get_skill_level(/datum/skill/magic/holy)
	if (victim == caster)
		// give us a buff that makes our next spoken thing really loud and also cause any linked, un-muted scom to shriek out the phrase at a 15% chance
		var/cast_time = 50 - (holy_skill * 5)
		caster.visible_message(span_notice("[caster] lowers [caster.p_their()] head solemnly, whispered prayers spilling from [caster.p_their()] lips..."), span_notice("O holy [caster.patron.name], share unto me a sliver of your power..."))

		if (!caster.has_status_effect(/datum/status_effect/thaumaturgy))
			if (do_after(caster, cast_time, target = caster))
				caster.apply_status_effect(/datum/status_effect/thaumaturgy, holy_skill)
				caster.visible_message(span_notice("[caster] throws open [caster.p_their()] eyes, suddenly emboldened!"), span_notice("A feeling of power wells up in my throat: speak, and many will hear!"))
				StartCooldown()
				return thaumaturgy_devotion
		else
			to_chat(caster, span_notice("I'm already empowered with divine thaumaturgy!"))
			return
	else
		// make a light source flicker, and others around it within a radius	
		if (istype(victim, /obj/machinery/light) || istype(victim, /obj/item/flashlight))
			for (var/obj/maybe_light in view(3 + holy_skill, victim))
				if (istype(maybe_light, /obj/machinery/light))
					var/obj/machinery/light/other_light = maybe_light
					other_light.flicker(holy_skill * 5)
					//caster.devotion?.update_devotion(-1)
				else if (istype(maybe_light, /obj/item/flashlight/flare))
					var/obj/item/flashlight/flare/mobile_light = maybe_light
					if (mobile_light.on)
						mobile_light.turn_off()
						//caster.devotion?.update_devotion(-1)

			to_chat(caster, span_notice("I direct the weight of my faith towards nearby flames, causing them to flicker!"))

			StartCooldown()
			return thaumaturgy_devotion
		else if (isturf(victim))

			var/did_flicker = FALSE
			for (var/obj/machinery/light/other_lights in view(3 + holy_skill, victim))
				other_lights.flicker(holy_skill * 5)
				//caster.devotion?.update_devotion(-1)
				did_flicker = TRUE

			if (did_flicker)
				to_chat(caster, span_notice("I direct the weight of my faith towards nearby flames, causing them to flicker!"))

				StartCooldown()
				return thaumaturgy_devotion
			else
				to_chat(caster, span_notice("My faith finds no flames to show its passage..."))
				return
		else if (isliving(victim))

			var/mob/living/living_thing = victim
			if (living_thing.has_status_effect(/datum/status_effect/light_buff))
				living_thing.remove_status_effect(/datum/status_effect/light_buff)
				caster.visible_message(span_notice("[caster] issues a reserved gesture towards [living_thing], and the holy light leaves [living_thing.p_them()]."), span_notice("I gesture towards [living_thing], and [living_thing.p_their()] blessing of light recedes."))
				return
			else
				to_chat(caster, span_notice("My divine thaumaturgy can only augment my own voice, or dismiss the blessing of light on others."))
				return
		else
			to_chat(caster, span_warning("I can only direct thaumaturgical prayers towards myself, the ground, and any nearby light sources."))
			return

///////////////////
// ORISON - FILL //
///////////////////

/datum/reagent/water/blessed
	name = "blessed water"
	description = "A gift of Devotion. It very lightly mends the wounds of the lyving, but ignites the flesh of the unlyving."

/datum/reagent/water/blessed/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_UNDEAD)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/water/blessed/on_mob_metabolize(mob/living/L)
	..()
	if(L.mob_biotypes & MOB_UNDEAD)
		L.adjust_fire_stacks(2)
		L.adjustFireLoss(5)
		L.ignite_mob()
		L.emote("scream")
		L.visible_message(span_warning("[L] erupts into angry fizzling and hissing!"), span_warning("DAMNATION, BLESSED WATER! IT BUUUURNS!"))

/datum/reagent/water/blessed/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if (!istype(M))
		return ..()
	
	if (method == TOUCH)
		if (M.mob_biotypes & MOB_UNDEAD)
			M.adjustFireLoss(2*reac_volume, 0)
			M.visible_message(span_warning("[M] erupts into angry fizzling and hissing!"), span_warning("DAMNATION, BLESSED WATER! IT BUUUURNS!"))
			M.emote("scream")

	return ..()

/datum/reagent/water/cursed
	name = "cursed water"
	description = "A gift of Devotion. Very slightly heals wounds of the dead and the enlightened."

/datum/reagent/water/cursed/on_mob_life(mob/living/carbon/M)
	. = ..()
	var/mob/living/carbon/human/M_hum
	if(istype(M,/mob/living/carbon/human/))
		M_hum = M
	if((M.mob_biotypes & MOB_UNDEAD) || (M_hum.patron.undead_hater == FALSE))
		M.adjustBruteLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()
	else
		M.adjustBruteLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()
		M.stamina_add(0.5  * REAGENTS_EFFECT_MULTIPLIER)

/datum/reagent/water/medicine
	name = "Pestran Medicine"
	description = "A gift of devotion from the Patron of Healing and Medicine, stronger than blessed water but taste horrible!"
	color = "#428b42"
	taste_description = "nauseatingly bitter"
	scent_description = "medicine"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/water/medicine/on_mob_life(mob/living/carbon/M)
	if(volume >= 50)
		M.reagents.remove_reagent(/datum/reagent/water/medicine, 2) // no more than 1 large bottle at a time
	if(volume > 0.99)
		M.adjustBruteLoss(-0.5 * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.5 * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.5 * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustToxLoss(-0.5 * REAGENTS_EFFECT_MULTIPLIER, 0)
		for(var/datum/reagent/R in M.reagents.reagent_list)
			if(R.harmful)
				holder.remove_reagent(R.type, 0.2 * REAGENTS_EFFECT_MULTIPLIER)
		var/list/wCount = M.get_wounds()
		if(wCount.len > 0)
			M.heal_wounds(2)
		..()

/datum/action/cooldown/spell/touch/orison/proc/create_water(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	// normally we wouldn't use fatigue here to keep in line w/ other holy magic, but we have to since water is a persistent resource
	if (!victim.Adjacent(caster))
		to_chat(caster, span_info("I need to be closer to [victim] in order to try filling it with water."))
		return

	if (victim.is_refillable())
		if (victim.reagents.holder_full())
			to_chat(caster, span_warning("[victim] is full."))
			return
		
		caster.visible_message(span_info("[caster] closes [caster.p_their()] eyes in prayer and extends a hand over [victim] as water begins to stream from [caster.p_their()] fingertips..."), span_notice("I utter forth a plea to [caster.patron.name] for succour, and hold my hand out above [victim]..."))

		var/holy_skill = caster.get_skill_level(/datum/skill/magic/holy)
		var/drip_speed = 1.5 SECONDS
		var/fatigue_spent = 0
		var/water_qty = 5
		while (do_after(caster, drip_speed, target = victim))
			if (victim.reagents.holder_full())
				break

			water_qty = holy_skill * 5
			var/list/water_contents = list(/datum/reagent/water/cursed = water_qty)
			if(caster.patron.undead_hater == TRUE)
				water_contents = list(/datum/reagent/water/blessed = water_qty)
			if(caster.patron.name == "Pestra")
				water_contents = list(/datum/reagent/water/medicine = water_qty)
			var/datum/reagents/reagents_to_add = new()
			reagents_to_add.add_reagent_list(water_contents)
			reagents_to_add.trans_to(victim, reagents_to_add.total_volume, transfered_by = caster)
			
			if (prob(80))
				playsound(caster, 'sound/items/fillcup.ogg', 55, TRUE)
		
		return min(50, fatigue_spent)
	else if (istype(victim, /obj/item/natural/cloth))
		// stupid little easter egg here: you can dampen a cloth to clean with it, because prestidigitation also lets you clean things. also a lot cheaper devotion-wise than filling a bucket
		var/obj/item/natural/cloth/the_cloth = victim
		var/holy_skill = caster.get_skill_level(/datum/skill/magic/holy)
		if(the_cloth.wet >= holy_skill * 5) // Don't reduce the wetness if someone better than you already blessed it
			to_chat(caster, span_warning("I cannot soak this cloth any further"))
			return
		the_cloth.wet = holy_skill * 5
		caster.visible_message(span_info("[caster] closes [caster.p_their()] eyes in prayer, beads of moisture coalescing in [caster.p_their()] hands to moisten [the_cloth]."), span_notice("I utter forth a plea to [caster.patron.name] for succour, and will moisture into [the_cloth]. I should be able to clean with it properly now."))
		return water_moisten
	else if (istype(victim, /obj/item/reagent_containers/powder/flour))
		// these three should probably be abstracted but the type pathing here is a nightmare and it's only three cases for now so it's probably fine
		var/obj/item/reagent_containers/powder/flour/the_flour = victim
		the_flour.wet(src, caster)
		return
	else if (istype(victim, /obj/item/reagent_containers/food/snacks/grown/rice))
		var/obj/item/reagent_containers/food/snacks/grown/rice/the_rice = victim
		the_rice.wet(src, caster)
		return
	else if (istype(victim, /obj/item/reagent_containers/powder/mineral))
		var/obj/item/reagent_containers/powder/mineral/the_mineral = victim
		the_mineral.wet(src, caster)
		return
	else if (istype(victim, /obj/structure/soil))
		caster.visible_message(span_info("[caster] conjures water over the soil."), span_notice("I utter forth a plea to [caster.patron.name] for succour, and will moisture into the soil."))
		return
	else
		to_chat(caster, span_info("I'll need to find a container that can hold water."))
