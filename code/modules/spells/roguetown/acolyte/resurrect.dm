/obj/effect/proc_holder/spell/invoked/resurrect
	name = "Anastasis"
	overlay_state = "revive"
	releasedrain = 90
	chargedrain = 0
	chargetime = 50
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/revive.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 MINUTES
	miracle = TRUE
	devotion_cost = 250
	var/revive_pq = PQ_GAIN_REVIVE
	var/required_structure = /obj/structure/fluff/psycross
	var/required_items = list(/obj/item/clothing/neck/roguetown/psicross = 1)
	var/alt_required_items = list(/obj/item/clothing/neck/roguetown/psicross = 1)
	var/item_radius = 1
	var/debuff_type = /datum/status_effect/debuff/revived
	var/structure_range = 1
	var/harms_undead = TRUE
	priest_excluded = TRUE

/obj/effect/proc_holder/spell/invoked/resurrect/start_recharge()
	var/old_recharge = recharge_time
	recharge_time = initial(recharge_time) * SSchimeric_tech.get_resurrection_multiplier()
	// If the spell was fully charged, keep it fully charged after adjusting recharge_time
	if(charge_counter >= old_recharge && old_recharge > 0)
		charge_counter = recharge_time
	. = ..()

/obj/effect/proc_holder/spell/invoked/resurrect/proc/get_current_required_items()
	if(SSchimeric_tech.has_revival_cost_reduction() && length(alt_required_items))
		return alt_required_items
	return required_items

/obj/effect/proc_holder/spell/invoked/resurrect/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]

		var/validation_result = validate_items(target)
		if(validation_result != "")
			to_chat(user, span_warning("[validation_result] on the floor next to or on top of [target]"))
			revert_cast()
			return FALSE

		var/found_structure = FALSE
		var/list/search_area = oview(structure_range, target)

		for(var/atom/A in search_area)
			// Check if the atom itself is the required structure type
			if(istype(A, required_structure))
				found_structure = TRUE
				break

			if(istype(A, /turf))
				var/turf/T = A
				for(var/obj/O in T.contents)
					if(istype(O, required_structure))
						found_structure = TRUE
						break // Found it in the turf, no need to check further
			if(found_structure)
				break

		if(!found_structure)
			var/atom/temp_structure = required_structure
			to_chat(user, span_warning("I need a holy [initial(temp_structure.name)] near [target]."))
			revert_cast()
			return FALSE
		if(!target.check_revive(user))
			revert_cast()
			return FALSE
		if(target.mob_biotypes & MOB_UNDEAD && harms_undead) //positive energy harms the undead
			target.visible_message(
				span_danger("[target] is unmade by divine magic!"), 
				span_userdanger("I'm unmade by divine magic!")
			)
			target.gib()
			return TRUE
		if(alert(target, "They are calling for you. Are you ready?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
			target.visible_message(span_notice("Nothing happens. They are not being let go."))
			return FALSE
		target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
		if(!target.revive(full_heal = FALSE))
			to_chat(user, span_warning("Nothing happens."))
			revert_cast()
			return FALSE
		var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
		//GET OVER HERE!
		if(underworld_spirit)
			var/mob/dead/observer/ghost = underworld_spirit.ghostize()
			qdel(underworld_spirit)
			ghost.mind.transfer_to(target, TRUE)
		target.grab_ghost(force = TRUE) // even suicides
		target.emote("breathgasp")
		target.Jitter(100)
		target.update_body()
		target.visible_message(span_notice("[target] is revived by divine magic!"), span_green("I awake from the void."))
		if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
			adjust_playerquality(revive_pq, user.ckey)
			ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
		target.mind.remove_antag_datum(/datum/antagonist/zombie)
		target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
		target.apply_status_effect(debuff_type)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
		//Due to an increased cost and cooldown, these revival types heal quite a bit.
		target.apply_status_effect(/datum/status_effect/buff/healing, 14)
		consume_items(target)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/resurrect/cast_check(skipcharge = 0,mob/user = usr)
	if(!..())
		to_chat(user, span_warning("The miracle fizzles."))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/resurrect/proc/validate_items(atom/center)
	var/list/current_required_items = get_current_required_items()
	var/list/available_items = list()
	var/list/missing_items = list()

	// Scan for items in radius
	for(var/obj/item/I in range(item_radius, center))
		if(I.type in current_required_items)
			available_items[I.type] += 1

	// Check quantities and compile missing list
	for(var/item_type in current_required_items)
		var/needed = current_required_items[item_type]
		var/have = available_items[item_type] || 0
		
		if(have < needed) {
			var/obj/item/I = item_type
			var/amount_needed = needed - have
			missing_items += "[amount_needed] [initial(I.name)][amount_needed > 1 ? "s" : ""] "
		}

	if(length(missing_items))
		var/string = ""
		for(var/item in missing_items)
			string += item 
		return "Missing components: [string]."
	return ""

/obj/effect/proc_holder/spell/invoked/resurrect/proc/consume_items(atom/center)
	var/list/current_required_items = get_current_required_items()
	for(var/item_type in current_required_items)
		var/needed = current_required_items[item_type]

		for(var/obj/item/I in range(item_radius, center))
			if(needed <= 0)
				break
			if(I.type == item_type)
				needed--
				qdel(I)

/obj/effect/proc_holder/spell/invoked/resurrect/abyssor
	name = "Abyssal Revival"
	desc = "Revive the target at a cost, cast on yourself to check.<br>a dreamfiend will stalk the target and sap their stats until confronted by them."
	sound = 'sound/magic/whale.ogg'
	//A medley of common ocean fish, totalling 10
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fish/sole = 3,
		/obj/item/reagent_containers/food/snacks/fish/cod = 3,
		/obj/item/reagent_containers/food/snacks/fish/bass = 2,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 1,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 1,
	)
	alt_required_items = list(
		/obj/item/reagent_containers/food/snacks/fish/plaice = 2,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1
	)
	debuff_type = /datum/status_effect/debuff/dreamfiend_curse
	//This will be Abyssor's statue soon.
	required_structure = /turf/open/water/ocean
	overlay_state = "terrors"

/datum/status_effect/debuff/dreamfiend_curse
	id = "dreamfiend_curse"
	alert_type = /atom/movable/screen/alert/status_effect/dreamfiend_curse
	/// Type of dreamfiend to summon
	var/dreamfiend_type
	var/obj/effect/proc_holder/spell/invoked/summon_dreamfiend_curse/curse_spell

/datum/status_effect/debuff/dreamfiend_curse/on_creation(mob/living/new_owner)
	// Choose dreamfiend type from weighted list
	var/list/dreamfiend_types = list(
		/mob/living/simple_animal/hostile/rogue/dreamfiend = 50,
		/mob/living/simple_animal/hostile/rogue/dreamfiend/major = 49,
		/mob/living/simple_animal/hostile/rogue/dreamfiend/ancient = 1
	)
	dreamfiend_type = pickweight(dreamfiend_types)

	effectedstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = -5,
		STATKEY_LCK = -5,
		STATKEY_SPD = -2,
		STATKEY_PER = -5
	)

	// Add summoning spell to the victim
	if(!new_owner.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/abyssal_strength))
		curse_spell = new(new_owner)
		new_owner.mind?.AddSpell(curse_spell)
		curse_spell.dreamfiend_type = dreamfiend_type
		curse_spell.timed_cooldown = world.time + 5 MINUTES

	. = ..()

	switch(dreamfiend_type)
		if(/mob/living/simple_animal/hostile/rogue/dreamfiend/ancient)
			linked_alert.icon_state = "dreamfiend_ancient"
			linked_alert.name = "Grand Abyssal Curse."
			linked_alert.desc = "A terrifying presence if felt fraying the edges of my mind. This is a threat I cannot face alone."
		if(/mob/living/simple_animal/hostile/rogue/dreamfiend/major)
			linked_alert.icon_state = "dreamfiend_major"
			linked_alert.name = "Major Abyssal Curse."
			linked_alert.desc = "A great deamon is sapping my mind, a dangerous foe which I must summon to regain my faculties."
		if(/mob/living/simple_animal/hostile/rogue/dreamfiend)
			linked_alert.icon_state = "dreamfiend"

/atom/movable/screen/alert/status_effect/dreamfiend_curse
	name = "Abyssal Curse."
	desc = "A nightmare entity has revived you, but now it is draining your vitality. Summon it to confront it."

/obj/effect/proc_holder/spell/invoked/summon_dreamfiend_curse
	name = "Confront Terror"
	desc = "Summon the dreamfiend haunting you to confront it directly"
	overlay_state = "terrors"
	chargetime = 0
	invocations = list(span_danger("begins to smell of saltwater. You can hear waves crashing nearby..."))
	invocation_type = "emote"
	sound = 'sound/mobs/abyssal/abyssal_teleport.ogg'
	/// Type of dreamfiend to summon
	var/dreamfiend_type
	recharge_time = 600 SECONDS
	var/timed_cooldown

/obj/effect/proc_holder/spell/invoked/summon_dreamfiend_curse/cast(list/targets, mob/living/user)
	if (world.time < timed_cooldown) 
		to_chat(user, span_warning("You must gather your strength before you are ready to confront your terror!"))
		to_chat(user, span_warning("Time remaining: [max(0, timed_cooldown - world.time)/10] seconds."))
		revert_cast()
		return FALSE
	// Summon the dreamfiend
	if(summon_dreamfiend(
		target = user,
		user = user,
		F = dreamfiend_type,
		outer_tele_radius = 6,
		inner_tele_radius = 5
	))
		// Remove the curse after summoning
		user.remove_status_effect(/datum/status_effect/debuff/dreamfiend_curse)
		user.mind.RemoveSpell(src)
		return TRUE

	to_chat(user, span_warning("No valid space to manifest the nightmare!"))
	return FALSE

/obj/effect/proc_holder/spell/invoked/resurrect/pestra
	name = "Putrid Revival"
	desc = "Revive the target by consuming heartblood. Self cast for more information."
	sound = 'sound/magic/slimesquish.ogg'
	required_items = list(
		/obj/item/heart_blood_canister/filled = 1,
		/obj/item/heart_blood_vial/filled = 2
	)
	alt_required_items = list(
		/obj/item/heart_blood_vial/filled = 2
	)
	overlay_icon = 'icons/mob/actions/pestraspells.dmi'
	action_icon = 'icons/mob/actions/pestraspells.dmi'
	overlay_state = "resurrect"

/obj/effect/proc_holder/spell/invoked/resurrect/eora
	//Does heartfelt even exist?
	name = "Heartfelt Revival"
	desc = "Revive the target at a cost, cast on yourself to check.<br>The target will get hungry faster for a time."
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast = 5
	)
	alt_required_items = list(
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1
	)
	debuff_type = /datum/status_effect/debuff/metabolic_acceleration
	sound = 'sound/magic/heartbeat.ogg'
	overlay_state = "eora_revive"

/atom/movable/screen/alert/status_effect/nutrition_drain
	name = "Metabolic Acceleration"
	desc = "Your body is burning energy at an accelerated rate!"
	icon_state = "nutrition_drain"

/datum/status_effect/debuff/metabolic_acceleration
	id = "metabolic_accel"
	alert_type = /atom/movable/screen/alert/status_effect/nutrition_drain
	tick_interval = 1 MINUTES
	duration = 15 MINUTES

/datum/status_effect/debuff/metabolic_acceleration/tick()
	if(!owner || owner.stat == DEAD)
		qdel(src)
		return

	if(HAS_TRAIT(owner, TRAIT_NOHUNGER))
		// For those without hunger, drain blood instead. CONSEQUENCES FOR MY TRAIT CHOICES?!
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			H.blood_volume = max(H.blood_volume - 100, BLOOD_VOLUME_SURVIVE)
	else
		// For normal humans, drain nutrition
		owner.adjust_nutrition(-100)

/datum/status_effect/debuff/metabolic_acceleration/on_creation(mob/living/new_owner)
	effectedstats = list(
		STATKEY_CON = -5
	)

	return ..()

/obj/effect/proc_holder/spell/invoked/resurrect/xylix
	//Cheap, but wildly unpretictable with possibly far worse effects than other methods.
	name = "Anastasis?"
	desc = "Revives the target? Grants them a random debuff from other revivals, small change to be worse or better."
	debuff_type = /datum/status_effect/debuff/random_revival
	alt_required_items = list(
		/obj/item/clothing/neck/roguetown/psicross/wood = 1
	)

/datum/status_effect/debuff/random_revival
	id = "random_revival_debuff"
	duration = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/random_revival

/datum/status_effect/debuff/random_revival/on_apply()
	. = ..()
	// 10% chance for special teleport effect
	if(prob(10))
		apply_teleport_effect()
	else
		// 90% chance for normal debuff
		apply_random_debuff()
		if(prob(33))
			apply_random_debuff()
		if(prob(20))
			apply_random_debuff()

	return TRUE

/datum/status_effect/debuff/random_revival/proc/apply_random_debuff()
	var/static/list/possible_debuffs = list(
		/datum/status_effect/debuff/revived,
		/datum/status_effect/debuff/dreamfiend_curse,
		/datum/status_effect/debuff/metabolic_acceleration,
		/datum/status_effect/debuff/malum_revival,
		/datum/status_effect/debuff/ravox_revival,
		/datum/status_effect/debuff/dendor_revival,
		/datum/status_effect/debuff/noc_revival,
	)
	var/debuff_type = pick(possible_debuffs)
	owner.apply_status_effect(debuff_type)

/datum/status_effect/debuff/random_revival/proc/apply_teleport_effect()
	var/area/target_area = locate(/area/rogue/indoors/town/manor) in GLOB.sortedAreas
	if(!target_area)
		apply_random_debuff() // Fallback if manor doesn't exist
		return

	// Find valid turf in manor
	var/turf/target_turf
	var/attempts = 0
	var/max_attempts = 5

	while(attempts < max_attempts && !target_turf)
		attempts++

		// Get all turfs in manor area
		var/list/area_turfs = get_area_turfs(target_area.type)
		if(!length(area_turfs))
			break

		var/list/valid_turfs = list()
		for(var/turf/T in area_turfs)
			if(T.density)
				continue
			if(istransparentturf(T))
				continue
			if(T.teleport_restricted)
				continue
			valid_turfs += T

		if(length(valid_turfs))
			target_turf = pick(valid_turfs)

	if(target_turf)
		// Unequip everything before teleporting
		owner.unequip_everything()

		// Teleport to manor
		owner.forceMove(target_turf)
		to_chat(owner, span_userdanger("You wake up in an unfamiliar place, stripped of your belongings!"))
		owner.Jitter(30)
	else
		// Fallback to random debuff if no valid turf found
		apply_random_debuff()

/atom/movable/screen/alert/status_effect/random_revival
	name = "Strange Aftereffects"
	desc = "The revival has left you with unexpected consequences..."

//Dendor, Malum, Ravox, Noc
//Fairly generic for now, I might give these more unique effects later!
/datum/status_effect/debuff/malum_revival
	id = "malum_revival"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/malum_revival

/datum/status_effect/debuff/malum_revival/on_creation(mob/living/new_owner)
	effectedstats = list(
		STATKEY_WIL = -5,
		STATKEY_STR = -2
	)
	return ..()

/atom/movable/screen/alert/status_effect/malum_revival
	name = "Malum's Burden"
	desc = "Your body feels heavy and slow to recover."
	icon_state = "malum_burden"

/datum/status_effect/debuff/ravox_revival
	id = "ravox_revival"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/ravox_revival

/datum/status_effect/debuff/ravox_revival/on_creation(mob/living/new_owner)
	effectedstats = list(
		STATKEY_STR = -5,
		STATKEY_SPD = -2
	)
	return ..()

/atom/movable/screen/alert/status_effect/ravox_revival
	name = "Ravox's Weakness"
	desc = "Your muscles feel feeble and movements sluggish."
	icon_state = "ravox_weakness"

/datum/status_effect/debuff/dendor_revival
	id = "dendor_revival"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/dendor_revival

/datum/status_effect/debuff/dendor_revival/on_creation(mob/living/new_owner)
	effectedstats = list(
		STATKEY_SPD = -5,
		STATKEY_CON = -2
	)
	return ..()

/atom/movable/screen/alert/status_effect/dendor_revival
	name = "Dendor's Sluggishness"
	desc = "Your movements are weighted by invisible roots and your body feels fragile."
	icon_state = "dendor_sluggish"

/datum/status_effect/debuff/noc_revival
	id = "noc_revival"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/noc_revival
	tick_interval = 10 SECONDS
	var/static/list/valid_body_zones = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG
	)

/datum/status_effect/debuff/noc_revival/on_creation(mob/living/new_owner)
	effectedstats = list(STATKEY_INT = -5)
	return ..()

/datum/status_effect/debuff/noc_revival/tick()
	// Check if outside at night
	if(istype(get_area(owner), /area/rogue/outdoors) && (GLOB.tod == "night"))
		if(prob(15))
			to_chat(owner, span_danger("Moonlight sears your flesh!"))
			owner.adjustFireLoss(15)
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
					BP.add_wound(/datum/wound/nocburn, FALSE, "looks burnt.")

/datum/wound/nocburn
	name = "light burn"
	whp = 15
	sewn_whp = 5
	bleed_rate = 0
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.1
	sewn_clotting_threshold = 0.05
	sew_threshold = 25
	mob_overlay = "cut"
	can_sew = TRUE
	//It's.. a burn..
	can_cauterize = FALSE

/atom/movable/screen/alert/status_effect/noc_revival
	name = "Noc's Moonlit Curse"
	desc = "Your mind feels clouded and moonlight burns your skin."
	icon_state = "noc_curse"

/obj/effect/proc_holder/spell/invoked/resurrect/malum
	name = "Diligent Revival"
	desc = "Revive the target at a cost, cast on yourself to check.<br>Targets willpower and strength will be sapped for a time."
	required_items = list(
		/obj/item/ingot/iron = 3
	)
	alt_required_items = list(
		/obj/item/ingot/copper = 1
	)
	debuff_type = /datum/status_effect/debuff/malum_revival
	sound = 'sound/magic/clang.ogg'

/obj/effect/proc_holder/spell/invoked/resurrect/ravox
	name = "Just Revival"
	desc = "Revive the target at a cost, cast on yourself to check.<br>Targets strength and speed will be sapped for a time."
	// The items here are somewhat hard to pick as it still has to be something a ravox acolyte would reasonably obtain.
	// Bones insinuate that mayhaps, they went out there to delete some skeletons for justice?
	required_items = list(
		/obj/item/natural/bone = 10
	)
	alt_required_items = list(
		/obj/item/natural/bone = 7
	)
	debuff_type = /datum/status_effect/debuff/ravox_revival

/obj/effect/proc_holder/spell/invoked/resurrect/dendor
	name = "Wild Revival"
	desc = "Revive the target at a cost, cast on yourself to check.<br>Targets speed and constitution will be sapped for a time."
	//Herbs that have to do with intelligence mostly. Easier to remember.
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
		/obj/item/alch/mentha = 3,
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 3
	)
	alt_required_items = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1
	)
	debuff_type = /datum/status_effect/debuff/dendor_revival
	required_structure = /obj/structure/flora/roguetree/wise
	sound = 'sound/magic/birdsong.ogg'

/obj/effect/proc_holder/spell/invoked/resurrect/noc
	name = "Moonlit Revival"
	desc = "Revive the target at a cost, cast on yourself to check.<br>Targets intelligence will be sapped for a time, in addition they will be burned by moonlight."
	required_items = list(
		/obj/item/paper/scroll = 15
	)
	alt_required_items = list(
		/obj/item/paper = 15
	)
	debuff_type = /datum/status_effect/debuff/noc_revival
	overlay_state = "noc_revive"
	sound = 'sound/magic/owlhoot.ogg'


/obj/effect/proc_holder/spell/invoked/resurrect/undivided
	name = "Decagram Revival"
	desc = "Revive the target at a cost, cast on yourself to check."
	required_items = list(
		/obj/item/rogueore/gold = 1 // Was thinking Eclipsum combo of gold/silver but that'd probably be *too* expensive. Probably the costliest revival, while having a anastasis equal debuff.
	)
	debuff_type = /datum/status_effect/debuff/revived
	sound = 'sound/magic/revive.ogg'
