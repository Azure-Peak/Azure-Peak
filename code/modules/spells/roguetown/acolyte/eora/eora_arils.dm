
/obj/item/reagent_containers/food/snacks/eoran_aril
	name = "eoran aril"
	desc = "A glowing seed from the fruit of Eora. It pulses with divine energy."
	icon = 'icons/obj/items/eora_pom.dmi'
	dropshrink = 0.7
	icon_state = "auric"
	bitesize = 1
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_TINY
	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	var/effect_desc = "Unknown effects."
	var/altruistic = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/eoran_aril/attack(mob/living/M, mob/living/user, def_zone)
	if(M != user && !altruistic)
		to_chat(user, span_info("The seed glows hot with Eora's rage as you try to forcefully feed her gift to another."))
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/eoran_aril/On_Consume(mob/living/eater)
	. = ..()
	if(iscarbon(eater))
		var/mob/living/carbon/c = eater
		apply_effects(c)

/obj/item/reagent_containers/food/snacks/eoran_aril/examine(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/c = user
		if(c.patron.type == /datum/patron/divine/eora)
			. += span_info(effect_desc)

/obj/item/reagent_containers/food/snacks/eoran_aril/proc/apply_effects(mob/living/carbon/eater)
	return

//--TIER 1--
/obj/item/reagent_containers/food/snacks/eoran_aril/crimson
	name = "crimson aril"
	desc = "A blood-red seed that seems to pulse with vitality."
	icon_state = "crimson"
	effect_desc = "This fruit heals for a blood price. This seed can be fed to others at the cost of your own blood."

	var/heal_amount = 35
	var/blood_loss = 225

/obj/item/reagent_containers/food/snacks/eoran_aril/crimson/Initialize()
	. = ..()
	blood_loss = BLOOD_VOLUME_NORMAL * 0.03

/obj/item/reagent_containers/food/snacks/eoran_aril/crimson/apply_effects(mob/living/carbon/eater)
	//Instant heal, but you can only eat a couple before the next will make you pass out.
	var/list/wCount = eater.get_wounds()
	//No undead because they kinda don't have blood to give for this.
	if(!eater.construct && !(eater.mob_biotypes & MOB_UNDEAD))
		var/current_brute_loss = eater.getBruteLoss()
		blood_loss += (eater.blood_volume * 0.06)
		if(wCount.len > 0)
			eater.heal_wounds(heal_amount + (current_brute_loss * 0.12))
			eater.update_damage_overlays()
		// blood loss is equal to 3% max blood volume + 6% of current blood volume
		// Regular healing is equal to 35 damage + 12% of current damage
		eater.blood_volume = max(0, eater.blood_volume - blood_loss)
		eater.adjustBruteLoss(-(heal_amount + (current_brute_loss * 0.12)), 0)
		eater.adjustFireLoss(-(heal_amount + (eater.getFireLoss() * 0.12)), 0)
		eater.adjustToxLoss(-(heal_amount + (eater.getToxLoss() * 0.12)), 0)
		eater.adjustOxyLoss(-(heal_amount + (eater.getOxyLoss() * 0.12)), 0)
		eater.adjustOrganLoss(ORGAN_SLOT_BRAIN, -heal_amount)
		eater.adjustCloneLoss(-heal_amount, 0)

/obj/item/reagent_containers/food/snacks/eoran_aril/crimson/attack(mob/living/M, mob/living/user, def_zone)
	if(!ishuman(M))
		return
	if(M == user)
		. = ..()
		return
	visible_message(span_danger("[user] begins altruistically channeling the crimson aril's power to restore [M]."),
	 span_info("I begin channeling the crimson aril's power into [M] using my own blood."))
	if(!do_mob(user, M, time = 0.6 SECONDS, double_progress = TRUE, can_move = FALSE))
		return
	var/mob/living/carbon/human/eater = M
	//Instant heal, but you can only eat a couple before the next will make you pass out.
	var/list/wCount = eater.get_wounds()
	//No undead because they kinda don't have blood to give for this.
	if(!eater.construct && !(eater.mob_biotypes & MOB_UNDEAD))
		var/current_brute_loss = eater.getBruteLoss()
		blood_loss += (user.blood_volume * 0.08)
		if(wCount.len > 0)
			eater.heal_wounds(heal_amount + (current_brute_loss * 0.12))
			eater.update_damage_overlays()
		// blood loss is equal to 3% max blood volume + 8% of current blood volume
		// Regular healing is equal to 35 damage + 12% of current damage
		user.blood_volume = max(0, user.blood_volume - blood_loss)
		eater.adjustBruteLoss(-(heal_amount + (current_brute_loss * 0.12)), 0)
		eater.adjustFireLoss(-(heal_amount + (eater.getFireLoss() * 0.12)), 0)
		eater.adjustToxLoss(-(heal_amount + (eater.getToxLoss() * 0.12)), 0)
		eater.adjustOxyLoss(-(heal_amount + (eater.getOxyLoss() * 0.12)), 0)
		eater.adjustOrganLoss(ORGAN_SLOT_BRAIN, -heal_amount)
		eater.adjustCloneLoss(-heal_amount, 0)
	qdel(src)
	return

/obj/item/reagent_containers/food/snacks/eoran_aril/roseate
	name = "roseate aril"
	desc = "A pink seed that radiates beauty and grace."
	icon_state = "roseate"
	effect_desc = "Grants fleeting beauty. Rejects the ugly."

	var/beauty_duration = 10 MINUTES

/obj/item/reagent_containers/food/snacks/eoran_aril/roseate/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(!HAS_TRAIT(H, TRAIT_UNSEEMLY) && !HAS_TRAIT(H, TRAIT_BEAUTIFUL))
			H.apply_status_effect(/datum/status_effect/buff/eora_grace)

/datum/status_effect/buff/eora_grace
	id = "eora_grace"
	duration = 10 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/eora_grace

/atom/movable/screen/alert/status_effect/eora_grace
	name = "Eora's grace"
	desc = "You feel beautiful."

/datum/status_effect/buff/eora_grace/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
	return TRUE

/datum/status_effect/buff/eora_grace/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		REMOVE_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)

/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent
	name = "opalescent aril"
	desc = "An iridescent seed that shifts colors in the light."
	icon_state = "opalescent"
	effect_desc = "Transforms held gems into rubies."
	
/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent/apply_effects(mob/living/eater)
	for(var/obj/item/roguegem/G in eater.held_items)
		var/obj/item/roguegem/ruby/new_gem = new(eater.loc)
		qdel(G)
		eater.put_in_hands(new_gem)
		to_chat(eater, span_notice("The [G] transforms into a rontz in your hand!"))
		//Probably best not to allow 2 at once...
		break

// TIER 2
/obj/item/reagent_containers/food/snacks/eoran_aril/cerulean
	name = "cerulean aril"
	desc = "A deep blue seed that smells of the ocean."
	icon_state = "cerulean"
	effect_desc = "Excellent fishing bait that attracts treasure."
	baitpenalty = 5
	isbait = TRUE
	fishingMods=list(
		"commonFishingMod" = 0.2,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 0,
		"dangerFishingMod" = 0,
		"ceruleanFishingMod" = 1, // 1 on cerulean aril, 0 on everything else
		"cheeseFishingMod" = 0 // Just for the funny gimmick of a chance for rats and rouses.
	)
/obj/item/reagent_containers/food/snacks/eoran_aril/fractal
	name = "fractal aril"
	desc = "A geometrically perfect seed that hurts to look at."
	icon_state = "fractal"
	effect_desc = "At a cost to constitution, Eora's mercy will melt unsightfulness away..."

/obj/item/reagent_containers/food/snacks/eoran_aril/fractal/apply_effects(mob/living/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
			REMOVE_TRAIT(H, TRAIT_UNSEEMLY, TRAIT_VIRTUE)
			H.change_stat(STATKEY_CON, -1)
			to_chat(eater, span_good("You feel your imperfections melt away, but your body feels more fragile."))

// TIER 3
/obj/item/reagent_containers/food/snacks/eoran_aril/auric
	name = "auric aril"
	desc = "A golden seed that radiates warmth and life."
	icon_state = "auric"
	effect_desc = "Key ingredient in revival potions."

/obj/item/reagent_containers/food/snacks/eoran_aril/ashen
	name = "ashen aril"
	desc = "A grey seed that feels glacial to the touch. An IMMENSE sense of dread can be felt just looking at it."
	icon_state = "ashen"
	effect_desc = "The forbidden aril. This one is not meant for you."

/obj/item/reagent_containers/food/snacks/eoran_aril/ashen/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater

		if(H.patron.type == /datum/patron/divine/eora)
			// Eora does not appreciate her followers ignoring her most sacred wishes.
			H.apply_status_effect(/datum/status_effect/debuff/eoran_wilting)
		else
			var/datum/status_effect/buff/ashen_aril/existing_effect = H.has_status_effect(/datum/status_effect/buff/ashen_aril)

			if(existing_effect)
				// Already burnt by an aril, simply stave off the ashing for 30 minutes.
				existing_effect.prevent_reapply = TRUE
				H.remove_status_effect(/datum/status_effect/buff/ashen_aril)
				H.remove_filter("ashen_filter")
				H.apply_status_effect(/datum/status_effect/buff/ashen_aril, 0, 30 MINUTES)
			else
				H.apply_status_effect(/datum/status_effect/buff/ashen_aril, 5, 6 MINUTES)

/obj/item/reagent_containers/food/snacks/eoran_aril/ochre
	name = "ochre aril"
	desc = "A blood-red seed that seems to pulse menacingly."
	icon_state = "ochre"
	effect_desc = "Return two nearby corpses in view from necra's embrace, at the cost of your own life."

/obj/item/reagent_containers/food/snacks/eoran_aril/ochre/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(H.patron.type == /datum/patron/divine/eora)
			var/list/mob/living/carbon/human/target_mobs = list()

			for(var/mob/living/carbon/human/target in view(7, H))
				if(target_mobs.len >= 2)
					break
				if(target.stat != DEAD)
					continue
				if(!target.mind || !target.mind.active)
					continue
				if(HAS_TRAIT(target, TRAIT_NECRAS_VOW))
					continue
				if(HAS_TRAIT(target, TRAIT_DNR))
					continue
				if(target.mob_biotypes & MOB_UNDEAD)
					continue
				if(target.has_status_effect(/datum/status_effect/debuff/metabolic_acceleration))
					continue
				if(target.has_status_effect(/datum/status_effect/debuff/eoran_wilting))
					continue

				target_mobs += target

			if(target_mobs.len > 0)
				H.apply_status_effect(/datum/status_effect/debuff/eoran_wilting)
				addtimer(CALLBACK(GLOBAL_PROC_REF(process_ochre_revivals), target_mobs), 0)

	return ..()

/proc/process_ochre_revivals(list/mob/living/carbon/human/targets_to_revive)
	for(var/mob/living/carbon/human/target in targets_to_revive)
		continue
		if(target.stat != DEAD)
			continue

		INVOKE_ASYNC(GLOBAL_PROC_REF(revive_ochre_target), target)

/proc/revive_ochre_target(mob/living/carbon/human/target)
	to_chat(world, span_userdanger("ATTEMPTING REVIVAL FOR [target]"))
	if(QDELETED(target) || target.stat != DEAD)
		return FALSE

	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()

	if (target.client)
		if (alert(target, "They are calling for you. Are you ready?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
			target.visible_message(span_notice("Nothing happens. They are not being let go."))
			return FALSE
	else if (underworld_spirit && underworld_spirit.client)
		if (alert(underworld_spirit, "They are calling for you. Are you ready?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
			target.visible_message(span_notice("Nothing happens. They are not being let go."))
			return FALSE
	else
		target.visible_message(span_notice("The body shudders, but there's no one to call out to."))
		return FALSE

	// Perform revival
	target.adjustOxyLoss(-target.getOxyLoss())
	if(target.revive(full_heal = FALSE))
		// Transfer ghost back to body (if they were ghosted)
		if(underworld_spirit && underworld_spirit.mind) // Ensure spirit exists and has a mind
			underworld_spirit.mind.transfer_to(target, TRUE) // Transfer mind back to the revived body
			qdel(underworld_spirit) // Delete the spirit mob
		else
			target.grab_ghost(force = TRUE) // This attempts to grab a ghost even if they committed suicide.

		target.emote("breathgasp")
		target.Jitter(100)
		target.update_body()
		target.visible_message(span_notice("[target] is revived by divine magic!"), span_green("I awake from the void."))

		ADD_TRAIT(target, TRAIT_IWASREVIVED, "ochre_aril")
		target.apply_status_effect(/datum/status_effect/debuff/metabolic_acceleration)
		return TRUE
	else
		target.visible_message(span_warning("The magic falters, and nothing happens."))
		return FALSE

//For now this is just artifical lux. But this may make the user/receiver indebted to eora eventually.
//This is meant to be given guaranteed with T4 pommes for priests but given we don't have eoran priests yet I will implement this when we do.
/obj/item/reagent_containers/lux/eoran_aril
	name = "incandescent aril"
	desc = "A blindingly bright seed that radiates pure life energy. It imitates lux, the essence of life."
	icon = 'icons/obj/items/eora_pom.dmi'
	icon_state = "incandescent"
	dropshrink = 0.7

/obj/item/reagent_containers/food/snacks/eoran_aril/pearlescent
	name = "pearlescent aril"
	desc = "A milky-white seed that pulses with purifying energy."
	icon_state = "pearlescent"
	effect_desc = "Transforms poisons within your body into lifeblood at the cost of diluting strong lifeblood."

/obj/item/reagent_containers/food/snacks/eoran_aril/pearlescent/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		H.apply_status_effect(/datum/status_effect/pearlescent_aril)

/obj/item/reagent_containers/eoran_seed
	name = "Satin aril"
	desc = "A silky soft seed from Eora's sacred tree. It can be used to propagate her gift in fertile soil."
	icon = 'icons/obj/items/eora_pom.dmi'
	icon_state = "roseate"

/obj/item/reagent_containers/eoran_seed/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!isturf(target) || !proximity_flag)
		return ..()

	var/turf/T = target

	// Location checks
	if(!isopenturf(T))
		to_chat(user, span_warning("The seed needs open space to grow!"))
		return
	if(!(istype(T, /turf/open/floor/rogue/grass) || istype(T, /turf/open/floor/rogue/dirt)))
		to_chat(user, span_warning("The seed must be planted on dirt or grass!"))
		return

	// Planting process
	to_chat(user, span_notice("You begin to plant the seed in [T]. It pulses gently..."))
	if(!do_after(user, 30 SECONDS, target))
		to_chat(user, span_warning("Planting was interrupted!"))
		return

	// Re-check conditions after delay
	if(!isopenturf(T) || !(istype(T, /turf/open/floor/rogue/grass) || istype(T, /turf/open/floor/rogue/dirt)))
		to_chat(user, span_warning("The ground is no longer suitable!"))
		return

	// Create tree and consume seed
	new /obj/structure/eoran_pomegranate_tree(T)
	qdel(src)
