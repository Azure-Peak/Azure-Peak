
/obj/item/bodypart
	name = "limb"
	desc = ""
	force = 3
	throwforce = 3
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/mob/human_parts.dmi'
	icon_state = ""
	layer = BELOW_MOB_LAYER //so it isn't hidden behind objects when on the floor
	var/mob/living/carbon/owner = null
	var/mob/living/carbon/original_owner = null
	var/status = BODYPART_ORGANIC
	var/needs_processing = FALSE

	var/static_icon = FALSE
	var/body_zone //BODY_ZONE_CHEST, BODY_ZONE_L_ARM, etc , used for def_zone
	var/aux_zone // used for hands
	var/aux_layer
	var/body_part = null //bitflag used to check which clothes cover this bodypart
	var/use_digitigrade = NOT_DIGITIGRADE //Used for alternate legs, useless elsewhere
	var/held_index = 0 //are we a hand? if so, which one!
	var/is_pseudopart = FALSE //For limbs that don't really exist, eg chainsaws

	var/disabled = BODYPART_NOT_DISABLED //If disabled, limb is as good as missing
	var/body_damage_coeff = 1 //Multiplier of the limb's damage that gets applied to the mob
	var/stam_damage_coeff = 0.75
	var/brutestate = 0
	var/burnstate = 0
	var/brute_dam = 0
	var/burn_dam = 0
	var/stamina_dam = 0
	var/max_stamina_damage = 0
	var/max_damage = 0
	var/max_pain_damage = 100

	var/cremation_progress = 0 //Gradually increases while burning when at full damage, destroys the limb when at 100

	var/brute_reduction = 0 //Subtracted to brute damage taken
	var/burn_reduction = 0	//Subtracted to burn damage taken

	//Coloring and proper item icon update
	var/skin_tone = ""
	var/body_gender = ""
	var/species_id = ""
	var/should_draw_gender = FALSE
	var/should_draw_greyscale = FALSE
	var/species_color = ""
	var/mutation_color = ""
	var/no_update = 0
	var/species_icon = ""

	var/animal_origin = null //for nonhuman bodypart (e.g. monkey)
	var/prosthetic_prefix = "pr" // for unique prosthetic icons on mob
	var/dismemberable = 1 //whether it can be dismembered with a weapon.
	var/disableable = 1

	var/px_x = 0
	var/px_y = 0

	var/species_flags_list = list()
	var/dmg_overlay_type //the type of damage overlay (if any) to use when this bodypart is bruised/burned.

	//Damage messages used by help_shake_act()
	var/heavy_brute_msg = "MANGLED"
	var/medium_brute_msg = "battered"
	var/light_brute_msg = "bruised"
	var/no_brute_msg = "unbruised"

	var/heavy_burn_msg = "CHARRED"
	var/medium_burn_msg = "peeling"
	var/light_burn_msg = "blistered"
	var/no_burn_msg = "unburned"

	var/add_extra = FALSE
	var/offset
	var/offset_f

	var/last_disable = 0
	var/last_crit = 0

	var/list/subtargets = list()		//these are subtargets that can be attacked with weapons (crits)
	var/list/grabtargets = list()		//these are subtargets that can be grabbed

	var/rotted = FALSE
	var/skeletonized = FALSE

	var/fingers = TRUE
	var/organ_slowdown = 0 // Its here because this is first shared definition between two leg organ paths
	var/is_prosthetic = FALSE

	/// Visaul markings to be rendered alongside the bodypart
	var/list/markings
	var/list/aux_markings
	/// Visual features of the bodypart, such as hair and accessories
	var/list/bodypart_features

	/// Whether the bodypart has unlimited bleeding.
	var/unlimited_bleeding = FALSE
	
	/// Cached variable that reflects how much bleeding our wounds are applying to the limb. Handled inside each individual wound.
	var/bleeding = 0

	/// Is the limb flagged for two-stage death handling? (aka, decaps will instantly kill first, THEN remove the head on second apply)
	var/two_stage_death = FALSE
	/// Has the limb been marked as having suffered a two-stage death flag?
	var/grievously_wounded = FALSE

	grid_width = 32
	grid_height = 64

	resistance_flags = FLAMMABLE

/obj/item/bodypart/proc/adjust_marking_overlays(var/list/appearance_list)
	return

/obj/item/bodypart/proc/get_specific_markings_overlays(list/specific_markings, aux = FALSE, mob/living/carbon/human/human_owner, override_color)
	var/list/appearance_list = list()
//	var/specific_layer = aux ? aux_layer : BODYPARTS_LAYER
	var/specific_layer = aux_layer ? aux_layer : BODYPARTS_LAYER
	var/specific_render_zone = aux ? aux_zone : body_zone
	for(var/key in specific_markings)
		var/color = specific_markings[key]
		var/datum/body_marking/BM = GLOB.body_markings[key]

		var/render_limb_string = specific_render_zone
		if(BM.gendered && (!BM.gender_only_chest || specific_render_zone == BODY_ZONE_CHEST))
			var/gendaar = (human_owner.gender == FEMALE) ? "f" : "m"
			render_limb_string = "[render_limb_string]_[gendaar]"

		var/mutable_appearance/accessory_overlay = mutable_appearance(BM.icon, "[BM.icon_state]_[render_limb_string]", -specific_layer)
		if(override_color)
			accessory_overlay.color = "#[override_color]"
		else
			accessory_overlay.color = "#[color]"
		appearance_list += accessory_overlay
	return appearance_list

/obj/item/bodypart/proc/get_markings_overlays(override_color)
	if((!markings && !aux_markings) || !owner || !ishuman(owner))
		return
	var/mob/living/carbon/human/human_owner = owner
	var/list/appearance_list = list()
	if(markings)
		appearance_list += get_specific_markings_overlays(markings, FALSE, human_owner, override_color)
	if(aux_markings)
		appearance_list += get_specific_markings_overlays(aux_markings, TRUE, human_owner, override_color)
	adjust_marking_overlays(appearance_list)
	return appearance_list

/obj/item/bodypart/grabbedintents(mob/living/user, precise)
	return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)

/obj/item/bodypart/l_arm/grabbedintents(mob/living/user, precise)
	var/used_limb = precise
	if(used_limb == BODY_ZONE_PRECISE_L_HAND)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash, /datum/intent/grab/disarm)
	else
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)

/obj/item/bodypart/r_arm/grabbedintents(mob/living/user, precise)
	var/used_limb = precise
	if(used_limb == BODY_ZONE_PRECISE_R_HAND)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash, /datum/intent/grab/disarm)
	else
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)

/obj/item/bodypart/chest/grabbedintents(mob/living/user, precise)
	if(precise == BODY_ZONE_PRECISE_GROIN)
		return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/shove)
	return list(/datum/intent/grab/move, /datum/intent/grab/shove)

/obj/item/bodypart/Destroy()
	if(owner)
		owner.bodyparts -= src
		owner = null
	if(bandage)
		QDEL_NULL(bandage)
	for(var/datum/wound/wound as anything in wounds)
		qdel(wound)
	return ..()

/obj/item/bodypart/onbite(mob/living/carbon/human/user)
	if((user.mind && user.mind.has_antag_datum(/datum/antagonist/zombie)) || istype(user.dna.species, /datum/species/werewolf))
		if(owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
			to_chat(user, span_notice("My power is weakened, I cannot heal!"))
			return
		if(do_after(user, 50, target = src))
			user.visible_message(span_warning("[user] consumes [src]!"),\
							span_notice("I consume [src]!"))
			playsound(get_turf(user), pick(dismemsound), 100, FALSE, -1)
			new /obj/effect/gibspawner/generic(get_turf(src), user)
			user.fully_heal()
			qdel(src)
		return
	return ..()

/obj/item/bodypart/MiddleClick(mob/living/user, params)
	var/obj/item/held_item = user.get_active_held_item()
	if(held_item)
		if(held_item.get_sharpness() && held_item.wlength == WLENGTH_SHORT)
			if(skeletonized)
				to_chat(user, span_warning("There's not even a sliver of flesh on this!"))
				return
			var/used_time = 210
			if(user.mind)
				used_time -= (user.get_skill_level(/datum/skill/labor/butchering) * 30)
			visible_message("[user] begins to butcher \the [src].")
			playsound(src, 'sound/foley/gross.ogg', 100, FALSE)
			var/steaks = 1
			switch(user.get_skill_level(/datum/skill/labor/butchering))
				if(3)
					steaks = 2
				if(4 to 5)
					steaks = 3
				if(6)
					steaks = 4 // the steaks have never been higher
			var/amt2raise = user.STAINT/3
			var/produced_steaks = list()
			if(do_after(user, used_time, target = src))
				for(steaks, steaks>0, steaks--)
					var/obj/item/reagent_containers/food/snacks/rogue/meat/steak/new_steak = new(get_turf(src))
					produced_steaks += new_steak
				if(rotted)
					for(var/obj/item/reagent_containers/food/snacks/rogue/meat/steak/putrid in produced_steaks)
						putrid.become_rotten()
				new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
				user.mind.add_sleep_experience(/datum/skill/labor/butchering, amt2raise, FALSE)
				qdel(src)
	..()

/obj/item/bodypart/attack(mob/living/carbon/C, mob/user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(HAS_TRAIT(C, TRAIT_LIMBATTACHMENT))
			if(!H.get_bodypart(body_zone) && !animal_origin)
				if(H == user)
					H.visible_message(span_warning("[H] jams [src] into [H.p_their()] empty socket!"),\
					span_notice("I force [src] into my empty socket, and it locks into place!"))
				else
					H.visible_message(span_warning("[user] jams [src] into [H]'s empty socket!"),\
					span_notice("[user] forces [src] into my empty socket, and it locks into place!"))
				user.temporarilyRemoveItemFromInventory(src, TRUE)
				attach_limb(C)
				return
	return ..()

/obj/item/bodypart/head/attackby(obj/item/I, mob/user, params)
	if(length(contents) && I.get_sharpness() && !user.cmode)
		add_fingerprint(user)
		playsound(loc, 'sound/combat/hits/bladed/genstab (1).ogg', 60, vary = FALSE)
		user.visible_message(span_warning("[user] begins to cut open [src]."),\
			span_notice("You begin to cut open [src]..."))
		if(do_after(user, 5 SECONDS, target = src))
			drop_organs(user)
			user.visible_message(span_danger("[user] cuts [src] open!"),\
				span_notice("You finish cutting [src] open."))
		return
	return ..()

/obj/item/bodypart/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(status != BODYPART_ROBOTIC)
		playsound(get_turf(src), 'sound/blank.ogg', 50, TRUE, -1)
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3)
	if(!skeletonized && owner && !(NOBLOOD in owner.dna?.species?.species_traits))
		new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))

//empties the bodypart from its organs and other things inside it
/obj/item/bodypart/proc/drop_organs(mob/user, violent_removal)
	var/turf/T = get_turf(src)
	if(status != BODYPART_ROBOTIC)
		playsound(T, 'sound/blank.ogg', 50, TRUE, -1)
	for(var/obj/item/I in src)
		I.forceMove(T)

/obj/item/bodypart/proc/skeletonize(lethal = TRUE)
	if(bandage)
		remove_bandage()
	for(var/obj/item/I in embedded_objects)
		remove_embedded_object(I)
	for(var/obj/item/I in src) //dust organs
		qdel(I)
	skeletonized = TRUE
	for(var/datum/wound/bloody_wound as anything in wounds)
		if(isnull(bloody_wound.bleed_rate))
			continue
		qdel(bloody_wound)

/obj/item/bodypart/chest/skeletonize(lethal = TRUE)
	. = ..()
	if(lethal && owner && !(NOBLOOD in owner.dna?.species?.species_traits))
		owner.death()

/obj/item/bodypart/head/skeletonize(lethal = TRUE)
	. = ..()
	if(lethal && owner && !(NOBLOOD in owner.dna?.species?.species_traits))
		owner.death()

/obj/item/bodypart/proc/consider_processing()
	if(stamina_dam > DAMAGE_PRECISION)
		. = TRUE
	//else if.. else if.. so on.
	else
		. = FALSE
	needs_processing = .

//Return TRUE to get whatever mob this is in to update health.
/obj/item/bodypart/proc/on_life(stam_regen)
	if(stamina_dam > DAMAGE_PRECISION && stam_regen)					//DO NOT update health here, it'll be done in the carbon's life.
		heal_damage(0, 0, INFINITY, null, FALSE)
		. |= BODYPART_LIFE_UPDATE_HEALTH

/obj/item/bodypart/Initialize()
	. = ..()
	update_HP()

/obj/item/bodypart/proc/update_HP()
	if(!is_organic_limb() || !owner)
		return
	var/old_max_damage = max_damage
	var/new_max_damage = initial(max_damage) * (owner.STACON / 10)
	if(new_max_damage != old_max_damage)
		max_damage = new_max_damage

//Applies brute and burn damage to the organ. Returns 1 if the damage-icon states changed at all.
//Damage will not exceed max_damage using this proc
//Cannot apply negative damage
/obj/item/bodypart/proc/receive_damage(brute = 0, burn = 0, stamina = 0, blocked = 0, updating_health = TRUE, required_status = null)
	update_HP()
	var/hit_percent = (100-blocked)/100
	if((!brute && !burn && !stamina) || hit_percent <= 0)
		return FALSE
	if(owner && (owner.status_flags & GODMODE))
		return FALSE	//godmode

	if(required_status && (status != required_status))
		return FALSE

	var/dmg_mlt = CONFIG_GET(number/damage_multiplier) * hit_percent
	brute = round(max(brute * dmg_mlt, 0),DAMAGE_PRECISION)
	burn = round(max(burn * dmg_mlt, 0),DAMAGE_PRECISION)
	stamina = round(max(stamina * dmg_mlt, 0),DAMAGE_PRECISION)
	brute = max(0, brute - brute_reduction)
	burn = max(0, burn - burn_reduction)
	//No stamina scaling.. for now..

	if(!brute && !burn && !stamina)
		return FALSE

	//cap at maxdamage
	if(brute_dam + brute > max_damage)
		brute_dam = max_damage
	else
		brute_dam += brute
	if(burn_dam + burn > max_damage)
		burn_dam = max_damage
	else
		burn_dam += burn

	//We've dealt the physical damages, if there's room lets apply the stamina damage.
	stamina_dam += round(CLAMP(stamina, 0, max_stamina_damage - stamina_dam), DAMAGE_PRECISION)

	if(owner)
		if(owner.show_redflash())
			if((brute + burn) < 10)
				owner.flash_fullscreen("redflash1")
			else if((brute + burn) < 20)
				owner.flash_fullscreen("redflash2")
			else if((brute + burn) >= 20)
				owner.flash_fullscreen("redflash3")

	if(owner && updating_health)
		owner.updatehealth()
		if(stamina > DAMAGE_PRECISION)
			owner.update_stamina()
			owner.stam_regen_start_time = world.time + STAMINA_REGEN_BLOCK_TIME
			. = TRUE
	consider_processing()
	update_disabled()
	return update_bodypart_damage_state() || .

//Heals brute and burn damage for the organ. Returns 1 if the damage-icon states changed at all.
//Damage cannot go below zero.
//Cannot remove negative damage (i.e. apply damage)
/obj/item/bodypart/proc/heal_damage(brute, burn, stamina, required_status, updating_health = TRUE)
	if((HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC)) && owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		return
	update_HP()
	if(required_status && (status != required_status)) //So we can only heal certain kinds of limbs, ie robotic vs organic.
		return
	if(owner && owner.has_status_effect(/datum/status_effect/buff/fortify))
		brute *= 1.5
		burn *= 1.5
		stamina *= 1.5

	brute_dam	= round(max(brute_dam - brute, 0), DAMAGE_PRECISION)
	burn_dam	= round(max(burn_dam - burn, 0), DAMAGE_PRECISION)
	stamina_dam = round(max(stamina_dam - stamina, 0), DAMAGE_PRECISION)
	if(owner && updating_health)
		owner.updatehealth()
	consider_processing()
	update_disabled()
	cremation_progress = min(0, cremation_progress - ((brute_dam + burn_dam)*(100/max_damage)))
	return update_bodypart_damage_state()

//Returns total damage.
/obj/item/bodypart/proc/get_damage(include_stamina = FALSE)
	var/total = brute_dam + burn_dam
	if(include_stamina)
		total = max(total, stamina_dam)
	return total

//Checks disabled status thresholds
/obj/item/bodypart/proc/update_disabled()
	update_HP()
	set_disabled(is_disabled())

/obj/item/bodypart/proc/is_disabled()
	if(!owner || !can_disable() || HAS_TRAIT(owner, TRAIT_NOLIMBDISABLE))
		return BODYPART_NOT_DISABLED
	//yes this does mean vampires can use rotten limbs
	if((rotted || skeletonized) && !(owner.mob_biotypes & MOB_UNDEAD))
		return BODYPART_DISABLED_ROT
	for(var/datum/wound/ouchie as anything in wounds)
		if(isnull(ouchie) || !istype(ouchie, /datum/wound))
			continue
		if(!ouchie.disabling)
			continue
		return BODYPART_DISABLED_WOUND
	if(HAS_TRAIT(owner, TRAIT_PARALYSIS) || HAS_TRAIT(src, TRAIT_PARALYSIS))
		return BODYPART_DISABLED_PARALYSIS
	var/surgery_flags = get_surgery_flags()
	if(surgery_flags & SURGERY_CLAMPED)
		return BODYPART_DISABLED_CLAMPED
	var/total_dam = get_damage()
	if((total_dam >= max_damage) || (HAS_TRAIT(owner, TRAIT_EASYLIMBDISABLE) && (total_dam >= (max_damage * 0.6))))
		return BODYPART_DISABLED_DAMAGE
	return BODYPART_NOT_DISABLED

/obj/item/bodypart/proc/set_disabled(new_disabled)
	if(disabled == new_disabled)
		return
	disabled = new_disabled
	last_disable = world.time
	if(owner)
		owner.update_health_hud() //update the healthdoll
		owner.update_body()
		owner.update_mobility()
	return TRUE //if there was a change.

//Updates an organ's brute/burn states for use by update_damage_overlays()
//Returns 1 if we need to update overlays. 0 otherwise.
/obj/item/bodypart/proc/update_bodypart_damage_state()
	var/tbrute	= round( (brute_dam/max_damage)*3, 1 )
	var/tburn	= round( (burn_dam/max_damage)*3, 1 )
	if((tbrute != brutestate) || (tburn != burnstate))
		brutestate = tbrute
		burnstate = tburn
		return TRUE
	return FALSE

//Change organ status
/obj/item/bodypart/proc/change_bodypart_status(new_limb_status, heal_limb, change_icon_to_default)
	status = new_limb_status
	if(heal_limb)
		burn_dam = 0
		brute_dam = 0
		brutestate = 0
		burnstate = 0

	if(change_icon_to_default)
		if(status == BODYPART_ORGANIC)
			icon = species_icon
		else if(status == BODYPART_ROBOTIC)
			icon = DEFAULT_BODYPART_ICON_ROBOTIC

	if(owner)
		owner.updatehealth()
		owner.update_body() //if our head becomes robotic, we remove the lizard horns and human hair.
		owner.update_hair()
		owner.update_damage_overlays()

/obj/item/bodypart/proc/is_organic_limb()
	return (status == BODYPART_ORGANIC)

//we inform the bodypart of the changes that happened to the owner, or give it the informations from a source mob.
/obj/item/bodypart/proc/update_limb(dropping_limb, mob/living/carbon/source)
	var/mob/living/carbon/C
	if(source)
		C = source
		if(!original_owner)
			original_owner = source
	else if(original_owner && owner != original_owner) //Foreign limb
		no_update = TRUE
	else
		C = owner
		no_update = FALSE

	if((C) && HAS_TRAIT(C, TRAIT_HUSK) && is_organic_limb())
		species_id = "husk" //overrides species_id
		dmg_overlay_type = "" //no damage overlay shown when husked
		should_draw_gender = FALSE
		should_draw_greyscale = FALSE
		no_update = TRUE

	if(no_update)
		return

	if(!animal_origin)
		var/mob/living/carbon/human/H = C
		should_draw_greyscale = FALSE
		if(!H.dna || !H.dna.species)
			return
		var/datum/species/S = H.dna.species
		species_id = S.limbs_id
		if(H.gender == MALE)
			species_icon = S.limbs_icon_m
		else
			species_icon = S.limbs_icon_f
		species_flags_list = H.dna.species.species_traits


		if(S.use_skintones)
			skin_tone = H.skin_tone
			should_draw_greyscale = TRUE
		else
			skin_tone = ""

		body_gender = H.gender
		should_draw_gender = S.sexes

		if((MUTCOLORS in S.species_traits) || (DYNCOLORS in S.species_traits))
			if(S.fixed_mut_color)
				species_color = S.fixed_mut_color
			else
				species_color = H.dna.features["mcolor"]
			should_draw_greyscale = TRUE
		else
			species_color = ""

		mutation_color = ""

		dmg_overlay_type = S.damage_overlay_type

	else if(animal_origin == MONKEY_BODYPART) //currently monkeys are the only non human mob to have damage overlays.
		dmg_overlay_type = animal_origin

	if(status == BODYPART_ROBOTIC)
		dmg_overlay_type = "robotic"

	if(dropping_limb)
		no_update = TRUE //when attached, the limb won't be affected by the appearance changes of its mob owner.

//to update the bodypart's icon when not attached to a mob
/obj/item/bodypart/proc/update_icon_dropped()
	cut_overlays()
	var/list/standing = get_limb_icon(1)
	if(!standing.len)
		icon_state = initial(icon_state)//no overlays found, we default back to initial icon.
		return
	for(var/image/I in standing)
		I.pixel_x = px_x
		I.pixel_y = px_y
	add_overlay(standing)

///since organs aren't actually stored in the bodypart themselves while attached to a person, we have to query the owner for what we should have
/obj/item/bodypart/proc/get_organs()
	if(!owner)
		return FALSE

	var/list/bodypart_organs
	for(var/obj/item/organ/organ_check as anything in owner.internal_organs) //internal organs inside the dismembered limb are dropped.
		if(check_zone(organ_check.zone) == body_zone)
			LAZYADD(bodypart_organs, organ_check) // this way if we don't have any, it'll just return null

	return bodypart_organs

//Gives you a proper icon appearance for the dismembered limb
/obj/item/bodypart/proc/get_limb_icon(dropped, hideaux = FALSE)
	icon_state = "" //to erase the default sprite, we're building the visual aspects of the bodypart through overlays alone.

	. = list()
	var/icon_gender = (body_gender == FEMALE) ? "f" : "m" //gender of the icon, if applicable

	var/image_dir = 0
	if(dropped && !skeletonized)
		if(static_icon)
			icon = initial(icon)
			icon_state = initial(icon_state)
			return
		image_dir = SOUTH
		if(dmg_overlay_type)
			if(brutestate)
				. += image('icons/mob/dam_mob.dmi', "[dmg_overlay_type]_[body_zone]_[brutestate]0_[icon_gender]", -DAMAGE_LAYER, image_dir)
			if(burnstate)
				. += image('icons/mob/dam_mob.dmi', "[dmg_overlay_type]_[body_zone]_0[burnstate]_[icon_gender]", -DAMAGE_LAYER, image_dir)

	var/image/limb = image(layer = -BODYPARTS_LAYER, dir = image_dir)
	var/image/aux

	. += limb

	if(animal_origin)
		if(is_organic_limb())
			limb.icon = 'icons/mob/animal_parts.dmi'
			if(species_id == "husk")
				limb.icon_state = "[animal_origin]_husk_[body_zone]"
			else
				limb.icon_state = "[animal_origin]_[body_zone]"
		else
			limb.icon = 'icons/mob/augmentation/augments.dmi'
			limb.icon_state = "[animal_origin]_[body_zone]"
		return

//	if((body_zone != BODY_ZONE_HEAD && body_zone != BODY_ZONE_CHEST))
//		should_draw_gender = FALSE
	should_draw_gender = TRUE

	var/skel = skeletonized ? "_s" : ""

	var/is_organic_limb = is_organic_limb()

	if(is_organic_limb)
		if(should_draw_greyscale)
			limb.icon = species_icon
			if(should_draw_gender)
				limb.icon_state = "[body_zone][skel]"
			else if(use_digitigrade)
				limb.icon_state = "digitigrade_[use_digitigrade]_[body_zone]"
			else
				limb.icon_state = "[body_zone][skel]"
		else
			limb.icon = 'icons/mob/human_parts.dmi'
			if(should_draw_gender)
				limb.icon_state = "[species_id]_[body_zone]_[icon_gender]"
			else
				limb.icon_state = "[species_id]_[body_zone]"
		if(aux_zone)
			if(!hideaux)
				aux = image(limb.icon, "[aux_zone][skel]", -aux_layer, image_dir)
				. += aux

	else
		limb.icon = species_icon
		limb.icon_state = "[prosthetic_prefix]_[body_zone]"
		if(aux_zone)
			if(!hideaux)
				aux = image(limb.icon, "pr_[aux_zone]", -aux_layer, image_dir)
				. += aux


	var/override_color = null
	if(rotted)
		override_color = SKIN_COLOR_ROT
	if(is_organic_limb && should_draw_greyscale && !skeletonized)
		var/draw_color =  mutation_color || species_color || skin_tone
		if(rotted || (owner && HAS_TRAIT(owner, TRAIT_ROTMAN)))
			draw_color = SKIN_COLOR_ROT
		if(draw_color)
			limb.color = "#[draw_color]"
			if(aux_zone && !hideaux)
				aux.color = "#[draw_color]"
	
	var/draw_organ_features = TRUE
	var/draw_bodypart_features = TRUE
	if(owner && owner.dna)
		var/datum/species/owner_species = owner.dna.species
		if(NO_ORGAN_FEATURES in owner_species.species_traits)
			draw_organ_features = FALSE
		if(NO_BODYPART_FEATURES in owner_species.species_traits)
			draw_bodypart_features = FALSE
	
	// Markings overlays
	if(!skeletonized)
		var/list/marking_overlays = get_markings_overlays(override_color)
		if(marking_overlays)
			. += marking_overlays
	
	// Organ overlays
	if(!skeletonized && draw_organ_features)
		for(var/obj/item/organ/organ as anything in get_organs())
			if(!organ.is_visible())
				continue
			var/mutable_appearance/organ_appearance = organ.get_bodypart_overlay(src)
			if(organ_appearance)
				. += organ_appearance
	
	// Feature overlays
	if(!skeletonized && draw_bodypart_features)
		for(var/datum/bodypart_feature/feature as anything in bodypart_features)
			var/overlays = feature.get_bodypart_overlay(src)
			if(!overlays)
				continue
			. += overlays

/obj/item/bodypart/deconstruct(disassembled = TRUE)
	drop_organs()
	return ..()

/obj/item/bodypart/chest
	name = BODY_ZONE_CHEST
	desc = ""
	icon_state = "default_human_chest"
	max_damage = 300
	body_zone = BODY_ZONE_CHEST
	body_part = CHEST
	px_x = 0
	px_y = 0
	stam_damage_coeff = 1
	max_stamina_damage = 120
	max_pain_damage = 150
	var/obj/item/cavity_item
	subtargets = list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_GROIN)
	grabtargets = list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_GROIN)
	offset = OFFSET_ARMOR
	offset_f = OFFSET_ARMOR_F
	dismemberable = FALSE

	grid_width = 64
	grid_height = 96

/obj/item/bodypart/chest/set_disabled(new_disabled)
	. = ..()
	if(!. || !owner)
		return
	if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
		if(owner.stat < DEAD)
			to_chat(owner, span_warning("I feel a sharp pain in my back!"))

/obj/item/bodypart/chest/Destroy()
	QDEL_NULL(cavity_item)
	return ..()

/obj/item/bodypart/chest/drop_organs(mob/user, violent_removal)
	if(cavity_item)
		cavity_item.forceMove(drop_location())
		cavity_item = null
	..()

/obj/item/bodypart/chest/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_chest"
	animal_origin = MONKEY_BODYPART

/obj/item/bodypart/chest/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART

/obj/item/bodypart/l_arm
	name = "left arm"
	desc = ""
	icon_state = "default_human_l_arm"
	attack_verb = list("slapped", "punched")
	max_damage = 200
	max_stamina_damage = 50
	body_zone = BODY_ZONE_L_ARM
	body_part = ARM_LEFT
	aux_zone = BODY_ZONE_PRECISE_L_HAND
	aux_layer = HANDS_PART_LAYER
	body_damage_coeff = 1
	held_index = 1
	px_x = -6
	px_y = 0
	subtargets = list(BODY_ZONE_PRECISE_L_HAND)
	grabtargets = list(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_L_ARM)
	offset = OFFSET_GLOVES
	offset_f = OFFSET_GLOVES_F
	dismember_wound = /datum/wound/dismemberment/l_arm

/obj/item/bodypart/l_arm/is_disabled()
	. = ..()
	if(!. && owner && HAS_TRAIT(owner, TRAIT_PARALYSIS_L_ARM))
		return BODYPART_DISABLED_PARALYSIS

/obj/item/bodypart/l_arm/set_disabled(new_disabled)
	. = ..()
	if(!. || !owner)
		return
	if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
		if(owner.stat < DEAD)
			to_chat(owner, span_boldwarning("I can no longer move my [name]!"))
		if(held_index)
			owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	else if(disabled == BODYPART_DISABLED_PARALYSIS)
		if(owner.stat < DEAD)
			to_chat(owner, span_danger("I can no longer feel my [name]."))
			if(held_index)
				owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	if(owner.hud_used)
		var/atom/movable/screen/inventory/hand/L = owner.hud_used.hand_slots["[held_index]"]
		if(L)
			L.update_icon()

/obj/item/bodypart/l_arm/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_l_arm"
	animal_origin = MONKEY_BODYPART
	px_x = -5
	px_y = -3

/obj/item/bodypart/l_arm/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART

/obj/item/bodypart/r_arm
	name = "right arm"
	desc = ""
	icon_state = "default_human_r_arm"
	attack_verb = list("slapped", "punched")
	max_damage = 200
	body_zone = BODY_ZONE_R_ARM
	body_part = ARM_RIGHT
	aux_zone = BODY_ZONE_PRECISE_R_HAND
	aux_layer = HANDS_PART_LAYER
	body_damage_coeff = 1
	held_index = 2
	px_x = 6
	px_y = 0
	max_stamina_damage = 50
	subtargets = list(BODY_ZONE_PRECISE_R_HAND)
	grabtargets = list(BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_ARM)
	offset = OFFSET_GLOVES
	offset_f = OFFSET_GLOVES_F
	dismember_wound = /datum/wound/dismemberment/r_arm

/obj/item/bodypart/r_arm/is_disabled()
	. = ..()
	if(!. && owner && HAS_TRAIT(owner, TRAIT_PARALYSIS_R_ARM))
		return BODYPART_DISABLED_PARALYSIS

/obj/item/bodypart/r_arm/set_disabled(new_disabled)
	. = ..()
	if(!. || !owner)
		return
	if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
		if(owner.stat < DEAD)
			to_chat(owner, span_danger("I can no longer move my [name]!"))
		if(held_index)
			owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	else if(disabled == BODYPART_DISABLED_PARALYSIS)
		if(owner.stat < DEAD)
			to_chat(owner, span_danger("I can no longer feel my [name]."))
			if(held_index)
				owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	if(owner.hud_used)
		var/atom/movable/screen/inventory/hand/R = owner.hud_used.hand_slots["[held_index]"]
		if(R)
			R.update_icon()

/obj/item/bodypart/r_arm/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_r_arm"
	animal_origin = MONKEY_BODYPART
	px_x = 5
	px_y = -3

/obj/item/bodypart/r_arm/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART

/obj/item/bodypart/l_leg
	name = "left leg"
	desc = ""
	icon_state = "default_human_l_leg"
	attack_verb = list("kicked", "stomped")
	max_damage = 200
	body_zone = BODY_ZONE_L_LEG
	body_part = LEG_LEFT
	body_damage_coeff = 1
	px_x = -2
	px_y = 12
	max_stamina_damage = 50
	aux_zone = "l_leg_above"
	aux_layer = LEG_PART_LAYER
	subtargets = list(BODY_ZONE_PRECISE_L_FOOT)
	grabtargets = list(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_L_LEG)
	dismember_wound = /datum/wound/dismemberment/l_leg

/obj/item/bodypart/l_leg/is_disabled()
	. = ..()
	if(!. && owner && HAS_TRAIT(owner, TRAIT_PARALYSIS_L_LEG))
		return BODYPART_DISABLED_PARALYSIS

/obj/item/bodypart/l_leg/set_disabled(new_disabled)
	. = ..()
	if(!. || !owner)
		return
	if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
		if(owner.stat < DEAD)
			to_chat(owner, span_danger("I can no longer move my [name]!"))
	else if(disabled == BODYPART_DISABLED_PARALYSIS)
		if(owner.stat < DEAD)
			to_chat(owner, span_danger("I can no longer feel my [name]."))

/obj/item/bodypart/l_leg/digitigrade
	name = "left digitigrade leg"
	use_digitigrade = FULL_DIGITIGRADE

/obj/item/bodypart/l_leg/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_l_leg"
	animal_origin = MONKEY_BODYPART
	px_y = 4

/obj/item/bodypart/l_leg/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART

/obj/item/bodypart/r_leg
	name = "right leg"
	desc = ""
	// alternative spellings of 'pokey' are availible
	icon_state = "default_human_r_leg"
	attack_verb = list("kicked", "stomped")
	max_damage = 200
	body_zone = BODY_ZONE_R_LEG
	body_part = LEG_RIGHT
	body_damage_coeff = 1
	px_x = 2
	px_y = 12
	max_stamina_damage = 50
	aux_zone = "r_leg_above"
	aux_layer = LEG_PART_LAYER
	subtargets = list(BODY_ZONE_PRECISE_R_FOOT)
	grabtargets = list(BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_R_LEG)
	dismember_wound = /datum/wound/dismemberment/r_leg

/obj/item/bodypart/r_leg/is_disabled()
	. = ..()
	if(!. && owner && HAS_TRAIT(owner, TRAIT_PARALYSIS_R_LEG))
		return BODYPART_DISABLED_PARALYSIS

/obj/item/bodypart/r_leg/set_disabled(new_disabled)
	. = ..()
	if(!. || !owner)
		return
	if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
		if(owner.stat < DEAD)
			to_chat(owner, span_danger("I can no longer move my [name]!"))
	else if(disabled == BODYPART_DISABLED_PARALYSIS)
		if(owner.stat < DEAD)
			to_chat(owner, span_danger("I can no longer feel my [name]."))

/obj/item/bodypart/r_leg/digitigrade
	name = "right digitigrade leg"
	use_digitigrade = FULL_DIGITIGRADE

/obj/item/bodypart/r_leg/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_r_leg"
	animal_origin = MONKEY_BODYPART
	px_y = 4

/obj/item/bodypart/r_leg/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART
