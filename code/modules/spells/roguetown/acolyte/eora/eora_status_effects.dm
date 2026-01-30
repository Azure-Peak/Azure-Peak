#define ASHEN_FILTER
/atom/movable/screen/alert/status_effect/buff/ashen_aril
	name = "Arillean Apotheosis"
	desc = "Divine power courses through you, enhancing all abilities."
	icon_state = "buff"

/datum/status_effect/buff/ashen_aril
	id = "ashen"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ashen_aril
	duration = 6 MINUTES
	var/prevent_reapply = FALSE
	var/current_boost = 5
	var/next_wound_time = 0
	var/static/list/valid_body_zones = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG
	)

/datum/status_effect/buff/ashen_aril/on_creation(mob/living/new_owner, boost_level = 5, new_duration = 6 MINUTES)
	current_boost = boost_level
	duration = new_duration
	next_wound_time = world.time - 1

	. = ..()

	switch(current_boost)
		if(3 to 5)
			linked_alert.name = "Arillean Apotheosis"
			linked_alert.desc = "Divine power courses through you, enhancing all abilities."
			linked_alert.icon_state = "pom_god"
		if(1 to 2)
			linked_alert.name = "Waning Arillean Apotheosis"
			linked_alert.desc = "The divine power within you is fading."
			linked_alert.icon_state = "pom_god"
		if(0)
			linked_alert.name = "Arillean Peace"
			linked_alert.desc = "The calm before the storm."
			linked_alert.icon_state = "pom_anxiety"
		if(-4 to -1)
			linked_alert.name = "Ashen Scourge"
			linked_alert.desc = "Your body is turning to ash!"
			linked_alert.icon_state = "pom_regret"
		if(-5)
			linked_alert.name = "Arillean Husk"
			linked_alert.desc = "Much of your body has deteriorated into ash. It is not through Eora's mercy if you are still alive somehow."
			linked_alert.icon_state = "pom_regret"

/datum/status_effect/buff/ashen_aril/on_apply()
	// Apply stat boosts to all attributes
	effectedstats = list(
		STATKEY_STR = current_boost,
		STATKEY_WIL = current_boost,
		STATKEY_CON = current_boost,
		STATKEY_INT = current_boost,
		STATKEY_PER = current_boost,
		STATKEY_LCK = current_boost,
		STATKEY_SPD = current_boost
	)
	//Apply Uncapped STR as long as it's still positive.
	if(current_boost > 0)
		ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)

	// Apply Beautiful trait for positive boosts
	if(current_boost == 5)
		ADD_TRAIT(owner, TRAIT_BEAUTIFUL, TRAIT_MIRACLE)
		to_chat(owner, span_notice("You feel divinely empowered and radiant!"))
	else if(current_boost == 0)
		REMOVE_TRAIT(owner, TRAIT_BEAUTIFUL, TRAIT_MIRACLE)
		to_chat(owner, span_warning("Your divine beauty fades..."))
	else if (current_boost == -5)
		ADD_TRAIT(owner, TRAIT_UNSEEMLY, TRAIT_MIRACLE)
		to_chat(owner, span_notice("Your flesh is flaky and disgusting."))

	// Set visual appearance based on boost level
	switch(current_boost)
		if(3 to 5)
			owner.add_filter(ASHEN_FILTER, 2, list("type" = "outline", "color" = "#e78e08", "alpha" = 225, "size" = 2))
		if(1 to 2)
			owner.add_filter(ASHEN_FILTER, 2, list("type" = "outline", "color" = "#c0c0c0", "alpha" = 180, "size" = 1))
		if(-4 to -1)
			owner.add_filter(ASHEN_FILTER, 2, list("type" = "outline", "color" = "#a9a9a9", "alpha" = 160, "size" = 1))
		if(-5)
			owner.add_filter(ASHEN_FILTER, 2, list("type" = "outline", "color" = "#696969", "alpha" = 140, "size" = 1))

	return ..()

/datum/status_effect/buff/ashen_aril/tick()
	// Apply wounds at negative boost levels except -5
	if(current_boost < 0 && current_boost > -5 && world.time > next_wound_time)
		next_wound_time = world.time + rand(30 SECONDS, 60 SECONDS)
		if(prob(25))
			if(iscarbon(owner))
				var/mob/living/carbon/C = owner
				var/list/valid_parts = list()

				for(var/obj/item/bodypart/BP in C.bodyparts)
					var/BP_name = BP.name
					if(!BP_name) BP_name = "Unnamed Bodypart" // Fallback

					var/bool_can_bloody_wound = BP.can_bloody_wound()
					var/bool_in_zone = (BP.body_zone in valid_body_zones)
					var/bool_combined_condition = (bool_in_zone && bool_can_bloody_wound)

					if(bool_combined_condition) //Idk but it works like this.
						valid_parts += BP

				if(length(valid_parts))
					var/obj/item/bodypart/BP = pick(valid_parts)
					BP.add_wound(/datum/wound/slash, FALSE, "looks sickly and ashen.")
					new /obj/item/ash(owner.loc)
					to_chat(owner, span_warning("Your body cracks as a new wound opens, ash spilling forth."))

/datum/status_effect/buff/ashen_aril/on_remove()
	. = ..()
	owner.remove_filter(ASHEN_FILTER)
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	if(!prevent_reapply)
	// Handle effect progression
		if(current_boost > -4)
			owner.apply_status_effect(/datum/status_effect/buff/ashen_aril, current_boost - 1)
		else
			// Permanent at -5 with wilting effect
			owner.apply_status_effect(/datum/status_effect/buff/ashen_aril, -5, -1)
			owner.apply_status_effect(/datum/status_effect/debuff/eoran_wilting)

#undef ASHEN_FILTER

/datum/status_effect/buff/eoran_balm_effect
	id = "eoran_balm"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = -1
	var/healing_power = 1.5
	var/waiting_for_prompt = FALSE

/datum/status_effect/buff/eoran_balm_effect/on_apply()
	to_chat(owner, span_notice("A strange balm courses through my veins, an unnatural warmth spreads through my lifeless body..."))
	. = ..()

/datum/status_effect/buff/eoran_balm_effect/tick()
	. = ..()
	var/mob/living/carbon/M = owner
	new /obj/effect/temp_visual/heal(get_turf(owner), "#cd2be2")

	if(M.stat != DEAD)
		M.remove_status_effect(src)
		return

	if(waiting_for_prompt)
		return

	M.adjustBruteLoss(-healing_power)
	M.adjustFireLoss(-healing_power)
	M.adjustToxLoss(-healing_power)
	M.adjustOxyLoss(-healing_power)
	M.adjustCloneLoss(-healing_power)

	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume + healing_power * 2, BLOOD_VOLUME_NORMAL)

	var/list/wounds = M.get_wounds()
	if(length(wounds))
		M.heal_wounds(healing_power)
		M.update_damage_overlays()

	if(M.getBruteLoss() < 50 && M.getFireLoss() < 50 && M.getToxLoss() < 50 && M.getOxyLoss() < 50 && M.blood_volume >= BLOOD_VOLUME_SAFE)

		new /obj/effect/temp_visual/heal(get_turf(M), "#8A2BE2")

		if (M.mind)
			waiting_for_prompt = TRUE
			if(alert(M, "Are you ready to face the world, once more?", "Revival", "I must go on", "Let me rest") != "I must go on")
				M.visible_message(span_warning("[M]'s body shudders but falls still again."))
				M.remove_status_effect(src)
				return

		M.adjustOxyLoss(-M.getOxyLoss()) // Full oxygen healing
		if(!M.revive(full_heal = FALSE))
			M.visible_message(span_warning("[M]'s body shudders but fails to revive!"))
			M.remove_status_effect(src)
			return

		M.emote("breathgasp")
		M.Jitter(100)
		record_round_statistic(STATS_LUX_REVIVALS)
		M.update_body()
		M.visible_message(span_notice("[M] is dragged back from Necra's hold!"), span_green("I awake from the void."))
		M.mind.remove_antag_datum(/datum/antagonist/zombie)
		M.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
		M.apply_status_effect(/datum/status_effect/debuff/revived)
		M.remove_status_effect(src)

#define POM_FILTER "pom_aura"

/datum/status_effect/debuff/pomegranate_aura
	id = "pomegranate_aura"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/pomegranate_aura
	var/outline_colour ="#42001f"
	var/datum/weakref/source_ref

/datum/status_effect/debuff/pomegranate_aura/on_creation(mob/living/owner, tree)
	source_ref = WEAKREF(tree)
	var/str_change = 0
	var/perc_change = 0

	if(owner.patron.type != /datum/patron/divine/eora)
		str_change = -8
		perc_change = -8
	else if (!(owner.get_skill_level(/datum/skill/magic/holy) >= 1))
		//Eorans get a slight edge.
		str_change = -6
		perc_change = -6
	else
		//Devotees to Eora get a strong edge.
		str_change = -4
		perc_change = -2

	effectedstats = list(
		STATKEY_STR = str_change,
		STATKEY_PER = perc_change
	)

	return ..()

/datum/status_effect/debuff/pomegranate_aura/on_apply()
	. = ..()
	var/filter = owner.get_filter(POM_FILTER)
	if (!filter)
		owner.add_filter(POM_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 180, "size" = 1))
	to_chat(owner, span_warning("My combat prowess is sapped by the tree!"))

/datum/status_effect/debuff/pomegranate_aura/on_remove()
	. = ..()
	owner.remove_filter(POM_FILTER)
	to_chat(owner, span_warning("As I leave the influence of the tree, my strength returns."))

/datum/status_effect/debuff/pomegranate_aura/tick()
	// Check if source tree still exists
	var/obj/structure/eoran_pomegranate_tree/tree = source_ref?.resolve()
	if(QDELETED(tree) || !istype(tree))
		owner.remove_status_effect(src)
		return

	// Check distance to tree. This is a sanity check given the aura SHOULD remove already, but you can never be too safe :)
	if(get_dist(owner, tree) > tree.aura_range)
		owner.remove_status_effect(src)
		return

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		// Ugly people might get hurt
		if(HAS_TRAIT(H, TRAIT_UNSEEMLY) && prob(2))
			to_chat(H, span_warning("The tree's beauty burns your eyes!"))
			H.Dizzy(5)
			H.blur_eyes(5)
			H.adjustBruteLoss(10, 0)

		// Beautiful people might get healed
		else if(HAS_TRAIT(H, TRAIT_BEAUTIFUL) && prob(10))
			to_chat(H, span_good("The tree's beauty revitalizes you!"))
			H.apply_status_effect(/datum/status_effect/buff/healing, 1)

	// There is no beauty in death. Feed my tree.
	if(owner.stat == DEAD)
		owner.blood_volume = max(10, owner.blood_volume - 10)

/atom/movable/screen/alert/status_effect/pomegranate_aura
	name = "Eora's Blessing"
	desc = "You feel a sense of peace near this sacred tree."
	icon_state = "pom_peace"

#undef POM_FILTER

#define WILTING_FILTER "wilting_death"

/atom/movable/screen/alert/status_effect/eoran_wilting
	name = "WILTING"
	desc = "My limbs are falling off!"
	icon_state = "pom_death"

/datum/status_effect/debuff/eoran_wilting
	id = "wilting"
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/eoran_wilting
	var/outline_colour ="#2c2828"
	var/datum/weakref/source_ref

/datum/status_effect/debuff/eoran_wilting/on_apply()
	if(isliving(owner))
		owner.add_filter(WILTING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 210, "size" = 2))
		to_chat(owner, span_userdanger("You feel like your limbs are starting to detach horrifically, death is imminent!"))
	return TRUE

/datum/status_effect/debuff/eoran_wilting/on_remove()
	if(isliving(owner))
		var/mob/living/L = owner
		L.remove_filter(WILTING_FILTER)
	
	dismember_owner()

/datum/status_effect/debuff/eoran_wilting/tick()
	if(isliving(owner))
		var/mob/living/L = owner
		L.flash_fullscreen("redflash3", 1)
		
		// Small damage to limbs as warning
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			for(var/obj/item/bodypart/BP in C.bodyparts)
				if(BP.body_zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
					BP.receive_damage(1)

/datum/status_effect/debuff/eoran_wilting/proc/dismember_owner()
	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner
	playsound(C, 'sound/misc/eat.ogg', 100, TRUE)

	// Dismember limbs in sequence
	var/static/list/dismember_order = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD
	)

	C.visible_message(span_userdanger("[C]'s limbs wither and fall off in a gruesome display!"))

	for(var/zone in dismember_order)
		var/obj/item/bodypart/BP = C.get_bodypart(zone)
		if(BP)
			C.adjustBruteLoss(50)
			BP.dismember()
			sleep(0.5 SECONDS)

#undef WILTING_FILTER

/datum/status_effect/pearlescent_aril
	id = "pearlescent_aril"
	duration = 10 MINUTES
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/pearlescent_aril

/atom/movable/screen/alert/status_effect/pearlescent_aril
	name = "Pearlescent Cleansing"
	desc = "Poison heals you!"
	icon_state = "pearlescent"

/datum/status_effect/pearlescent_aril/on_apply()
	to_chat(owner, span_notice("A cleansing warmth spreads through your veins as the aril takes effect."))
	return ..()

/datum/status_effect/pearlescent_aril/tick()
	if(!owner.reagents || !iscarbon(owner))
		return
	
	var/mob/living/carbon/C = owner
	var/datum/reagents/R = C.reagents
	var/conversion_occurred = FALSE
	
	for(var/datum/reagent/RG in R.reagent_list)
		if(RG.harmful || istype(RG, /datum/reagent/medicine/stronghealth) && RG.volume > 0.1)
			R.remove_reagent(RG.type, 1)
			R.add_reagent(/datum/reagent/medicine/healthpot, 1)
			conversion_occurred = TRUE
	
	// Visual feedback if conversion occurred
	if(conversion_occurred)
		new /obj/effect/temp_visual/heal(get_turf(C), "#d8d8d8")

/datum/status_effect/pearlescent_aril/on_remove()
	to_chat(owner, span_warning("The cleansing warmth fades from your veins."))
	..()
