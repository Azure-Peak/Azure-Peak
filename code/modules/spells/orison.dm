////////////////////
// BASE OF ORISON //
////////////////////

/datum/action/cooldown/spell/touch/orison
	name = "Orison"
	desc = "The fundamental teachings of theology return to you:\n \
	<b>Light</b>: Issue a prayer for illumination, causing you or another living creature to begin glowing with light for five minutes - this stacks each time you cast it, with no upper limit. Using thaumaturgy on a person will remove this blessing from them, and MMB on your praying hand will remove any light blessings from yourself.\n \
	<b>Fill</b>: Beseech your Divine to create a small quantity of water in a container that you touch for some devotion.\n \
	<b>Voice</b>: Direct a sliver of divine thaumaturgy into your being, causing your voice to become LOUD when you next speak. Known to sometimes scare the rats inside the SCOMlines. Can be used on light sources at range, and it will cause them flicker.\n \
	<b>Bless</b>: Utter a prayer for redemption to your Divine to bring a repentant soul into their flock. The close bonds of the Ten uniquely allow an initiate to choose whichever they feel closest to. THIS IS ONLY TO BE USED AFTER A CONVERSION IN ROLEPLAY. DO NOT USE THIS WITHOUT A ROLEPLAY BASIS OR THERE WILL BE DIRE CONSEQUENCES."

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
		if(/datum/intent/hand/convert)
			var/mob/living/carbon/human/H = caster
			if(istype(H))
				H.convert_other(victim)
				qdel(hand)
				return TRUE
	return FALSE

// --- Touch Attack Item ---

/obj/item/melee/new_touch_attack/orison
	name = "\improper lesser prayer"
	desc = "Holy energy crackles at your fingertips, ready to serve you. Touch yourself to dismiss."
	possible_item_intents = list(/datum/intent/hand/light, /datum/intent/fill, /datum/intent/hand/voice, /datum/intent/hand/convert)
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

// we love undivided and how much snowflake code it needs
/proc/get_god_name(datum/patron/to_check)
	return (istype(to_check, /datum/patron/divine/undivided) ? "the Ten" : to_check.name)

/obj/item/melee/new_touch_attack/orison/MiddleClick(mob/living/user, params)
	. = ..()
	if (user.has_status_effect(/datum/status_effect/light_buff))
		user.remove_status_effect(/datum/status_effect/light_buff)
		user.visible_message(span_notice("[user] closes [user.p_their()] eyes, and the holy light surrounding them retreats into their chest and disappears."), span_notice("I relinquish the gift of [get_god_name(user.patron)]'s light."))
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
		M.adjustFireLoss(0.5	* REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
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
		M.adjustBruteLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()
	else
		M.adjustBruteLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()
		M.stamina_add(0.5	* REAGENTS_EFFECT_MULTIPLIER)

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

GLOBAL_LIST_INIT(convert_incantations, list(
		/datum/patron/divine/undivided = "Ten above, bring this wayward soul into thy embrace!!",
		/datum/patron/divine/astrata = "O great Overtyrant, grant order to this wayward soul!!",
		/datum/patron/divine/noc = "O wise Moonbrother, grant wisdom to this wayward soul!!",
		/datum/patron/divine/dendor = "O great Treefather, grant this wayward soul the nature of the wyld!!",
		/datum/patron/divine/abyssor = "O great Dreamer, induct this wayward soul into the mysteries of the deep!!",
		/datum/patron/divine/ravox = "O great Justiciar, grant justice to this wayward soul!!",
		/datum/patron/divine/necra = "Undermaiden, grant peace to this wayward soul!!",
		// /datum/patron/divine/xylix = "", nah. we do a little trolling with xylix
		/datum/patron/divine/pestra = "Lady of Pestilence, bring clarity to this wayward soul!!",
		/datum/patron/divine/malum = "O great Forgefather, bring diligence to this wayward soul!!",
		/datum/patron/divine/eora = "Great Mother, show mercy to this wayward soul!!", // because just "love" is too tacky
		/datum/patron/old_god = "Embrace the truth; PSYDON lyves!!", // psydon doesn't hear you, so you're talking to the other person here
		/datum/patron/inhumen/zizo = "Dame of Progress, show this one the truth of the world!", // culty, progressive, quieter than tennite invocations. all the Four are, except Graggar, because there's more of a usecase for being subtle
		/datum/patron/inhumen/graggar = "SHATTER THE BINDS OF MIND AND SOUL! SMASH THE CAGE OF LIES! GRAGGAR GRAGGAR GRAGGAR!!", // the ten's order is a cage. shatter the bars, claw free to the truth. in other words: they're larping. also, loud.
		/datum/patron/inhumen/matthios = "O Lorde, grant camaraderie to this wayward soul!", // similar to astrata's on purpose. and linked to matthios's free-men/comrades/siblings-in-arms thing. yes the title portion IS based entirely on how avarice refers to matthios why do you ask
		/datum/patron/inhumen/baotha = "Lady of Heartbreak, grant mercy to this wounded soul!" // once more, similar to eora's. emphasizes the "mercy" baotha grants to the broken
		))

/mob/living/carbon/human/proc/convert_other(atom/victim)

	var/mob/living/carbon/human/caster = src
	var/mob/living/carbon/human/new_convert = victim

	var/is_tennite = istype(caster.patron, /datum/patron/divine)

	if(caster == new_convert)
		return FALSE

	if(!ishuman(caster))
		return FALSE
	if(!ishuman(new_convert))
		to_chat(caster, span_info("I can only convert people; anything simpler cannot properly worship [is_tennite ? "the Ten" : get_god_name(caster.patron)]."))
		return FALSE

	if (!victim.Adjacent(caster))
		to_chat(caster, span_info("I need to be closer to [victim] to grant them [get_god_name(caster.patron)]'s grace."))
		return FALSE

	// no converting NPCs. if they're SSD this may also trigger, but why are you trying to convert ssd players. also, no ping-ponging back and forth in a single round or converting patron-locked roles
	if(!new_convert.client || HAS_TRAIT(new_convert, TRAIT_RECENT_CONVERT) || HAS_TRAIT(new_convert, TRAIT_UNCONVERTIBLE))
		to_chat(caster, span_info("They don't seem like they'll be receptive to my proselytizing..."))
		return FALSE

	if(istype(new_convert.patron, /datum/patron/vheslyn)) //UNFORGIVABLE SIN, UNFORGIVABLE, DIE. DIE. DIE.
		to_chat(caster, span_userdanger("[new_convert] is UNFORGIVABLE, my attempt to convert them violently sunders my lux!"))
		if(!HAS_TRAIT(caster, TRAIT_NOPAIN))
			caster.emote("agony")
		if(!HAS_TRAIT(caster, TRAIT_NOMOOD))
			caster.freak_out()
		playsound(caster, 'sound/misc/lava_death.ogg', 100, TRUE)
		caster.adjust_fire_stacks(40, /datum/status_effect/fire_handler/fire_stacks/vheslyn) //YOU FUCKING DESERVE THIS
		caster.adjustFireLoss(120)//Yeah that's gonna hurt, very rapidly
		caster.Knockdown(30)
		caster.Jitter(30)
		caster.Stun(25)
		caster.ignite_mob()
		explosion(get_turf(caster), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		caster.visible_message(span_danger("[caster] is violently smited as profane flames engulf their entire body!"))
		return FALSE

	if(new_convert.mind.has_spell(/datum/action/cooldown/spell/mending/lesser)) // this is only given to luxplate heretics & iconoclasts, who are a major antag
		to_chat(caster, span_info("Their faith is manifest as armor, bound to their very flesh... what could I possibly hope to accomplish here?"))
		return FALSE

	if(alert(caster, "Do you wish to attempt to convert [new_convert]? THIS IS NOT SOMETHING TO BE DONE LIGHTLY. READ THE SPELL DESCRIPTION IF YOU DO NOT KNOW WHAT THIS DOES.", "FOCUS THE LIGHT", "Yes", "No") != "Yes")
		return FALSE

	visible_message(span_info("[src] whispers rapid prayers, performing a rite to bring [new_convert] before their patron's gaze..."), span_info("You whisper prayers to [get_god_name(caster.patron)], casting their gaze upon [new_convert]..."))
	var/convert_message
	if(istype(caster.patron, /datum/patron/old_god))
		convert_message = "[caster.real_name] is trying to guide you onto PSYDON's path. Will you embrace Him, and forswear any lesser 'gods'?"
	else if(is_tennite)
		convert_message = "[caster.real_name] is trying to bring you into the Ten's embrace. Will you bask in Their light?"
	else
		switch(caster.patron.type)
			if(/datum/patron/inhumen/zizo)
				convert_message = "[caster.real_name] is trying to teach you the ways of ZIZO. Will you learn?"
			if(/datum/patron/inhumen/matthios)
				convert_message = "[caster.real_name] is offering you membership of the free men. Will you join?"
			if(/datum/patron/inhumen/graggar)
				convert_message = "[caster.real_name] is offering you Graggar's anointment. Will you break free?"
			if(/datum/patron/inhumen/baotha)
				convert_message = "[caster.real_name] is trying to offer you Baotha's mercy. Will you indulge?"
			else // this should not happen but if people add more gods and don't update this it's good to have a fallback
				convert_message = "[caster.real_name] is trying to convert you to [get_god_name(caster.patron)]. Will you accept?"
	convert_message += " THIS WILL CHANGE YOUR PATRON."
	// this is going to look slightly jank, and it is. but this is the best way to get a window that doesn't steal focus, can't intercept your clicks, and can't be meta'd; all concerns people had with alert()
	var/list/result = list(new_convert)
	if(!is_tennite && istype(caster.patron, new_convert.patron.type))
		result -= new_convert
	else
		showCandidatePollWindow(new_convert, 10 SECONDS, convert_message, result, null, world.time, flashwindow = FALSE)
	if(!do_mob(caster, new_convert, 10 SECONDS, can_move = FALSE) || caster.cmode || new_convert.cmode)
		to_chat(caster, span_info("I lose focus! The rite fails."))
		return FALSE
	if(!length(result))
		if(is_tennite)
			to_chat(caster, span_warning("[new_convert] is not responsive to my proselytizing..."))
		else
			to_chat(caster, span_warning("[new_convert] clings still to their misguided faith... or they already walk [get_god_name(caster.patron)]'s path."))
		return FALSE

	// we have a player that has accepted and is valid for conversion: it's go time
	var/datum/patron/new_patron = caster.patron.type
	var/datum/patron/old_patron = new_convert.patron
	if(is_tennite) // tennites can convert to any tennite faith, since they're a package deal; inhumen are much more individualized
		var/list/patrons_named = list()
		for(var/path as anything in GLOB.patrons_by_faith[/datum/faith/divine])
			var/datum/patron/patron = GLOB.patronlist[path]
			if(!patron.name)
				continue
			if(istype(patron, old_patron.type))
				continue // no converting astratans to astrata
			patrons_named[patron.name] = patron.type
		new_patron = patrons_named[input(new_convert, "Which of the Ten calls to you most?", "THE GODS SMILE") as anything in patrons_named]

	if(ispath(new_patron, /datum/patron/divine/xylix))
		caster.say(pick_assoc(GLOB.convert_incantations)) // just like torturing a xylixian has random lines from all the other gods, converting someone TO xylix will troll you as well
		playsound(new_convert, 'sound/magic/mockery.ogg', 60, FALSE, -1) // so they know it didn't just bug out and this is, in fact, xylix playing a prank on you
	else
		caster.say(GLOB.convert_incantations[new_patron.type])

	if(istype(new_convert.patron, /datum/patron/inhumen) && !ispath(new_patron, /datum/patron/inhumen)) // you're no longer a heretic
		REMOVE_TRAIT(new_convert, TRAIT_HERESIARCH, TRAIT_GENERIC)

	if(HAS_TRAIT(caster, TRAIT_CLERGY)) // however, only members of the church can actually remove excommunication (if you get converted by like a missionary or something, go up to the churchies and roleplay to get it removed)
		if(new_convert.real_name in GLOB.excommunicated_players)
			GLOB.excommunicated_players -= new_convert.real_name
		REMOVE_TRAIT(new_convert, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)
		new_convert.remove_status_effect(/datum/status_effect/debuff/excomm)
		new_convert.remove_stress(/datum/stressevent/excommunicated)

	// Save devotion state
	var/saved_level = CLERIC_T0
	var/saved_max_progression = CLERIC_T1
	var/saved_devotion_gain = CLERIC_REGEN_MINOR
	var/had_blast = FALSE
	var/was_cleric = FALSE

	if(new_convert.devotion)
		was_cleric = TRUE
		saved_level = new_convert.devotion.level
		saved_devotion_gain = new_convert.devotion.passive_devotion_gain
		saved_max_progression = new_convert.devotion.max_progression

		// Remove all granted spells
		for(var/S in new_convert.devotion.granted_spells)
			new_convert.mind.RemoveSpell(S)

		// gravemark and minion order are special, they're given to zizo and ravox only, and zizo only if they're t3 or above; also, necromancers and liches get them through arcyne means
		if(new_convert.mind.has_spell(/datum/action/cooldown/spell/gravemark) && !istype(SSrole_class_handler.get_advclass_by_name(new_convert.advjob), /datum/advclass/wretch/necromancer) && !new_convert.mind.has_antag_datum(/datum/antagonist/lich))
			new_convert.mind.RemoveSpell(/datum/action/cooldown/spell/gravemark)
			new_convert.mind.RemoveSpell(/datum/action/cooldown/spell/minion_order)

		if(new_convert.mind.has_spell(/datum/action/cooldown/spell/projectile/divine_blast))
			had_blast = TRUE
			new_convert.mind.RemoveSpell(/datum/action/cooldown/spell/projectile/divine_blast)

		if(new_convert.mind.has_spell(/datum/action/cooldown/spell/projectile/unholy_blast))
			had_blast = TRUE
			new_convert.mind.RemoveSpell(/datum/action/cooldown/spell/projectile/unholy_blast)

		// cleric traits are removed here
		new_convert.devotion.Destroy()

	// basic god traits are swapped over here
	new_convert.set_patron(new_patron)

	if(!istype(new_convert.patron, /datum/patron/inhumen) && new_convert.mind.has_spell(/datum/action/cooldown/spell/convert_heretic))
		new_convert.mind.RemoveSpell(/datum/action/cooldown/spell/convert_heretic)

	if(was_cleric && !istype(new_convert.patron, /datum/patron/old_god)) // psydonites don't get new miracles, since psydonite "miracles" don't work like real miracles
		// Grant new devotion
		var/datum/devotion/new_devotion = new /datum/devotion(new_convert, new_convert.patron)
		new_convert.devotion = new_devotion
		new_devotion.grant_miracles(new_convert, saved_level, saved_devotion_gain, saved_max_progression)
		if(had_blast)
			var/blast_to_grant = (istype(new_convert.patron, /datum/patron/inhumen) ? /datum/action/cooldown/spell/projectile/divine_blast : /datum/action/cooldown/spell/projectile/unholy_blast)
			new_convert.mind.AddSpell(new blast_to_grant)
		// why are you like this
		if(saved_level >= 3 && istype(new_convert.patron, /datum/patron/inhumen/zizo) && !new_convert.mind.has_spell(/datum/action/cooldown/spell/gravemark))
			new_convert.mind.AddSpell(new /datum/action/cooldown/spell/gravemark)
			new_convert.mind.AddSpell(new /datum/action/cooldown/spell/minion_order)
	else if(was_cleric)
		// however, they can have TRAIT_PSYDONITE as a treat
		ADD_TRAIT(new_convert, TRAIT_PSYDONITE, ROUNDSTART_TRAIT)

	// give a small mood buff to both parties, identical to prayer; psydonites get the same thing but with more ambiguous wording
	if(istype(new_convert.patron, /datum/patron/old_god))
		caster.add_stress(/datum/stressevent/convert/psydon)
	else
		caster.add_stress(/datum/stressevent/convert)
	new_convert.add_stress(/datum/stressevent/convert/recipient)

	message_admins("CONVERSION: [caster.real_name] ([caster.ckey]) has converted [new_convert.real_name] ([new_convert.ckey]) to [new_convert.patron.name]")
	log_game("CONVERSION: [caster.real_name] ([caster.ckey]) converted [new_convert.real_name] ([new_convert.ckey]) to [new_convert.patron.name]")
	to_chat(caster, span_danger("You've converted [new_convert.name] to follow [get_god_name(new_convert.patron)]!"))
	if(istype(new_convert.patron, /datum/patron/old_god))
		to_chat(new_convert, span_danger("You feel divine energies shift as [get_god_name(old_patron)]'s blessings forsake you!")) // woe is you, blessed fool
	else
		to_chat(new_convert, span_danger("You feel divine energies shift as [get_god_name(old_patron)]'s blessings forsake you, and [get_god_name(new_convert.patron)]'s embrace envelops you!"))

	if(istype(new_convert.patron, /datum/patron/inhumen) && !istype(old_patron, /datum/patron/inhumen)) // this is a heretic conversion: pass in the effects from the old heretic conversion spell
		var/absolved = FALSE
		if(new_convert.has_status_effect(/datum/status_effect/debuff/apostasy))
			new_convert.remove_status_effect(/datum/status_effect/debuff/apostasy)
			absolved = TRUE
		if(new_convert.real_name in GLOB.apostasy_players)
			GLOB.apostasy_players -= new_convert.real_name
			absolved = TRUE
		if(new_convert.real_name in GLOB.excommunicated_players)
			GLOB.excommunicated_players -= new_convert.real_name
			absolved = TRUE
		new_convert.remove_status_effect(/datum/status_effect/debuff/excomm)
		new_convert.remove_stress(/datum/stressevent/apostasy)
		new_convert.remove_stress(/datum/stressevent/excommunicated)

		for(var/datum/curse/C in new_convert.curses)
			new_convert.remove_curse(C)
			absolved = TRUE

		ADD_TRAIT(new_convert, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(HAS_TRAIT(caster, TRAIT_ZURCH)) // no granting zurch access if you don't have it
			ADD_TRAIT(new_convert, TRAIT_ZURCH, TRAIT_GENERIC)
		if(absolved)
			to_chat(new_convert, span_danger("You feel ancient powers lifting divine burdens from your soul..."))

	GLOB.dominant_faith_tracker.handle_conversion(new_convert, old_patron)
	ADD_TRAIT(new_convert, TRAIT_RECENT_CONVERT, TRAIT_GENERIC)
	return TRUE
