/datum/action/cooldown/spell/malum
	background_icon = 'icons/mob/actions/malummiracles.dmi'
	button_icon = 'icons/mob/actions/malummiracles.dmi'
	spell_color = GLOW_COLOR_MALUM
	sparks_amt = 3 //God of fire

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	ignore_armor_penalty = TRUE

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy

	spell_tier = 0
	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/malum, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/////////////////
// T0 - Ignite //
/////////////////

/datum/action/cooldown/spell/miracle/ignition/malum
	background_icon = 'icons/mob/actions/malummiracles.dmi'
	button_icon = 'icons/mob/actions/malummiracles.dmi'
	spell_color = GLOW_COLOR_MALUM
	required_items = list(/obj/item/clothing/neck/roguetown/psicross/malum, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/////////////////////////
// T0 - Reconstruction //
/////////////////////////

/datum/action/cooldown/spell/malum/reconstruction
	name = "Reconstruction"
	desc = "Restore integrity of any structure."
	button_icon_state = "restoration"
	sound = 'sound/magic/timestop.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR - 10

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	//invocations = list("Repair!")
	invocation_type = INVOCATION_NONE

	charge_required = FALSE
	cooldown_time = 20 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/malum/reconstruction/cast(atom/cast_on)
	. = ..()
	//var/mob/living/carbon/human/H = owner
	var/skill = owner.get_skill_level(/datum/skill/magic/holy)
	var/repair_points = 50 * skill
	var/starget = cast_on
	if(isobj(starget))
		if(istype(starget, /obj/item))
			return FALSE
		var/obj/structure/S = starget
		if(S.obj_integrity >= S.max_integrity)
			return FALSE
		if(istype(S, /obj/structure/mineral_door/))
			var/obj/structure/mineral_door/door = S
			//to_chat(owner, span_warning("[door.obj_integrity]"))
			owner.visible_message(span_notice("[owner] starts concentrating on [door.name]."),
			span_notice("I start concentrating on [door.name]."))
			playsound(owner, 'sound/misc/wood_saw.ogg', 100, TRUE)
			if(!do_after(owner, (150 / skill), target = door))
				return
			playsound(owner, 'sound/misc/wood_saw.ogg', 100, TRUE)
			door.icon_state = "[door.base_state]"
			door.density = TRUE
			door.set_opacity(TRUE)
			door.brokenstate = FALSE
			door.obj_broken = FALSE
			door.repair_state = 0								
			if((S.obj_integrity + repair_points) > S.max_integrity)
				var/need_points = (S.max_integrity - S.obj_integrity)
				S.obj_integrity += need_points
			else
				S.obj_integrity += repair_points
			owner.visible_message(span_notice("[owner] point on [door.name] and repair this."), \
			span_notice("I point on [door.name]. Malum blessing!"))	
			return TRUE

		if(istype(S, /obj/structure/roguewindow/))
			var/obj/structure/roguewindow/window = S
			if(window.obj_integrity < window.max_integrity)
				//to_chat(owner, span_warning("[window.obj_integrity]"))	
				owner.visible_message(span_notice("[owner] starts concentrating on [window.name]."),
				span_notice("I start concentrating on [window.name]."))
				playsound(owner, 'sound/misc/wood_saw.ogg', 100, TRUE)
				if(!do_after(owner, (150 / skill), target = window))
					return
				playsound(owner, 'sound/misc/wood_saw.ogg', 100, TRUE)
				window.icon_state = "[window.base_state]"
				window.density = TRUE
				window.brokenstate = FALSE
				window.obj_broken = FALSE
				if((S.obj_integrity + repair_points) > S.max_integrity)
					var/need_points = (S.max_integrity - S.obj_integrity)
					S.obj_integrity += need_points
				else
					S.obj_integrity += repair_points					
				owner.visible_message(span_notice("[owner] point on [window.name] and repair this."), \
				span_notice("I point on [window.name]. Malum blessing!"))	
				return TRUE
		else
			if(!do_after(owner, (150 / skill), target = S))
				return
			if((S.obj_integrity + repair_points) > S.max_integrity)
				var/need_points = (S.max_integrity - S.obj_integrity)
				S.obj_integrity += need_points
			else
				S.obj_integrity += repair_points
			return TRUE
	if(get_turf(starget))
		var/turf/closed/wall/mineral/W = cast_on
		if(W.turf_integrity >= W.max_integrity)
			return FALSE
		if(!do_after(owner, (150 / skill), target = W))
			return
		if((W.turf_integrity + repair_points) > W.max_integrity)
			var/need_points = (W.max_integrity - W.turf_integrity)
			W.turf_integrity += need_points
		else
			W.turf_integrity += repair_points
		return TRUE
	return FALSE

//////////////////////////////
// T1 - Vigorious Exchange. //
//////////////////////////////

/datum/action/cooldown/spell/malum/vigorousexchange
	name = "Vigorous Exchange"
	desc = "Restores the target's Energy, twice as effective on someone else."
	fluff_desc = "Behind every great work is a hard-working master, dilligent and patient yet not immune from intricacies of lyfe. Even Malum has once fallen to such after losing His hammer, exhausted and weak he was nursed back to health by Pestra so that even he may continue on. Now Their shared gift fuels the forges of Psydonia for no great work shall go unfinished so long as They maintain vigil."
	button_icon_state = "vigorousexchange"
	sound = 'sound/magic/undivided_recuperation.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	//invocations = list("Through flame and ash, let vigor rise, by Malum’s hand, let strength reprise!")
	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/malum/vigorousexchange/cast(atom/cast_on)
	. = ..()
	var/const/energytoregen = 200

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if (!isliving(spelltarget))
		show_visible_message(owner, "You can only cast this on living beings.")
		return FALSE
	if (spelltarget == H)
		spelltarget.energy_add((energytoregen * (owner.get_skill_level(associated_skill))) / 2)//You only get half
		show_visible_message(owner, "<font color='orange'>As [owner] intones the incantation, vibrant flames swirl around them.", "<font color='orange'>As you intone the incantation, vibrant flames swirl around you. You feel refreshed.")
	else if (H.energy > (energytoregen))
		owner.energy_add(-(energytoregen * (owner.get_skill_level(associated_skill))))
		spelltarget.energy_add((energytoregen * (owner.get_skill_level(associated_skill))) * 2)
		show_visible_message(spelltarget, "<font color='orange'>As [owner] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards [spelltarget].", "<font color='orange'>As [owner] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards you. You feel refreshed.")

/////////////////////
// T2 - Heat Metal //
/////////////////////

/datum/action/cooldown/spell/malum/heatmetal
	name = "Heat Metal"
	desc= "Damages Armor, forces target to drop a metallic weapon, heats up an ingot in tongs or smelts a single item."
	button_icon_state = "heatmetal"
	sound = 'sound/items/bsmithfail.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE //Why are you trying to set YOURSELF on fire.

	primary_resource_cost = SPELLCOST_MIRACLE + 10

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocations = list("With heat I wield, with flame I claim, Let metal serve in Malum's name!")
	invocation_type = INVOCATION_SHOUT //It has seperate message ON USE

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/malum/heatmetal/cast(atom/cast_on)
	. = ..()
	var/list/nosmeltore = list(/obj/item/rogueore/coal)
	var/datum/effect_system/spark_spread/sparks = new()
	if (!cast_on)
		return FALSE
	if(cast_on in nosmeltore)
		return FALSE
	if (istype(cast_on, /obj/item))
		handle_item_smelting(cast_on, owner, sparks, nosmeltore)
	else if (iscarbon(cast_on))
		if(spell_guard_check(cast_on, TRUE))
			var/mob/living/carbon/C = cast_on
			C.visible_message(span_warning("[cast_on] resists the searing heat!"))
			return TRUE
		handle_living_entity(cast_on, owner, nosmeltore)

/proc/show_visible_message(mob/user, text, selftext)
	var/text_to_send = addtext("<font color='yellow'>", text, "</font>")
	var/selftext_to_send = addtext("<font color='yellow'>", selftext, "</font>")
	user.visible_message(text_to_send, selftext_to_send)

/proc/handle_item_smelting(obj/item/target, mob/user, datum/effect_system/spark_spread/sparks, list/nosmeltore)
	if (!target.smeltresult) return
	var/obj/item/itemtospawn = target.smeltresult
	show_visible_message(user, "After [user]'s incantation, [target] glows brightly and melts into an ingot.", null)
	new itemtospawn(target.loc)
	sparks.set_up(1, 1, target.loc)
	sparks.start()
	qdel(target)

/proc/handle_living_entity(mob/target, mob/user, list/nosmeltore)
	var/obj/item/targeteditem = get_targeted_item(user, target)
	if (!targeteditem || targeteditem.smeltresult == /obj/item/ash || target.anti_magic_check(TRUE,TRUE))
		show_visible_message(user, "After their incantation, [user] points at [target] but it seems to have no effect.", "After your incantation, you point at [target] but it seems to have no effect.")
		return
	if (istype(targeteditem, /obj/item/rogueweapon/tongs))
		handle_tongs(targeteditem, user)
	else if (should_heat_in_hand(user, target, targeteditem, nosmeltore))
		handle_heating_in_hand(target, targeteditem, user)
	else
		handle_heating_equipped(target, targeteditem, user)

/proc/get_targeted_item(mob/user, mob/target)
    var/target_item
    switch(user.zone_selected)
        if (BODY_ZONE_PRECISE_R_HAND)
            target_item = target.held_items[2]
        if (BODY_ZONE_PRECISE_L_HAND)
            target_item = target.held_items[1]
        if (BODY_ZONE_HEAD)
            target_item = target.get_item_by_slot(SLOT_HEAD)
        if (BODY_ZONE_PRECISE_EARS)
            target_item = target.get_item_by_slot(SLOT_HEAD)
        if (BODY_ZONE_CHEST)
            if(target.get_item_by_slot(SLOT_ARMOR))
                target_item = target.get_item_by_slot(SLOT_ARMOR)
            else if (target.get_item_by_slot(SLOT_SHIRT))
                target_item = target.get_item_by_slot(SLOT_SHIRT)    
        if (BODY_ZONE_PRECISE_NECK)
            target_item = target.get_item_by_slot(SLOT_NECK)
        if (BODY_ZONE_PRECISE_R_EYE)
            target_item = target.get_item_by_slot(ITEM_SLOT_MASK)
        if ( BODY_ZONE_PRECISE_L_EYE)
            target_item = target.get_item_by_slot(ITEM_SLOT_MASK)
        if (BODY_ZONE_PRECISE_NOSE)
            target_item = target.get_item_by_slot(ITEM_SLOT_MASK)
        if (BODY_ZONE_PRECISE_MOUTH)
            target_item = target.get_item_by_slot(ITEM_SLOT_MOUTH)
        if (BODY_ZONE_L_ARM)
            target_item = target.get_item_by_slot(ITEM_SLOT_WRISTS)
        if (BODY_ZONE_R_ARM)
            target_item = target.get_item_by_slot(ITEM_SLOT_WRISTS)
        if (BODY_ZONE_L_LEG)
            target_item = target.get_item_by_slot(ITEM_SLOT_PANTS)
        if (BODY_ZONE_R_LEG)
            target_item = target.get_item_by_slot(ITEM_SLOT_PANTS)
        if (BODY_ZONE_PRECISE_GROIN)
            target_item = target.get_item_by_slot(ITEM_SLOT_PANTS)
        if (BODY_ZONE_PRECISE_R_FOOT)
            target_item = target.get_item_by_slot(ITEM_SLOT_SHOES)
        if (BODY_ZONE_PRECISE_L_FOOT)
            target_item = target.get_item_by_slot(ITEM_SLOT_SHOES)
    return target_item

/proc/handle_tongs(obj/item/rogueweapon/tongs/T, mob/user) //Stole the code from smithing.
	if (!T.hingot) return
	var/tyme = world.time
	T.hott = tyme
	addtimer(CALLBACK(T, TYPE_PROC_REF(/obj/item/rogueweapon/tongs, make_unhot), tyme), 100)
	T.update_icon()
	show_visible_message(user, "After [user]'s incantation, the ingot inside [T] starts glowing.", "After your incantation, the ingot inside [T] starts glowing.")

/proc/handle_heating_in_hand(mob/living/carbon/target, obj/item/targeteditem, mob/user)
	var/datum/effect_system/spark_spread/sparks = new()
	apply_damage_to_hands(target, user)
	target.dropItemToGround(targeteditem)
	show_visible_message(target, "[target]'s [targeteditem.name] glows brightly, searing their flesh.", "Your [targeteditem.name] glows brightly, It burns!")
	target.emote("painscream")
	playsound(target.loc, 'sound/misc/frying.ogg', 100, FALSE, -1)
	sparks.set_up(1, 1, target.loc)
	sparks.start()

/proc/should_heat_in_hand(mob/user, mob/target, obj/item/targeteditem, list/nosmeltore)
	return ((user.zone_selected == BODY_ZONE_PRECISE_L_HAND && target.held_items[1]) || (user.zone_selected == BODY_ZONE_PRECISE_R_HAND && target.held_items[2])) && !(targeteditem in nosmeltore) && targeteditem.smeltresult

/proc/apply_damage_to_hands(mob/living/carbon/target, mob/user)
	var/obj/item/bodypart/affecting
	var/const/adth_damage_to_apply = 10 //How much damage should burning your hand before dropping the item do.
	if (user.zone_selected == BODY_ZONE_PRECISE_R_HAND)
		affecting = target.get_bodypart(BODY_ZONE_R_ARM)
	else if (user.zone_selected == BODY_ZONE_PRECISE_L_HAND)
		affecting = target.get_bodypart(BODY_ZONE_L_ARM)
	affecting.receive_damage(0, adth_damage_to_apply)

/proc/handle_heating_equipped(mob/living/carbon/target, obj/item/clothing/targeteditem, mob/user)
	var/obj/item/armor = target.get_item_by_slot(SLOT_ARMOR)
	var/obj/item/shirt = target.get_item_by_slot(SLOT_SHIRT)
	var/armor_can_heat = armor && armor.smeltresult && armor.smeltresult != /obj/item/ash
	var/shirt_can_heat = shirt && shirt.smeltresult && shirt.smeltresult != /obj/item/ash // Full damage if no shirt 
	var/damage_to_apply = 20 // How much damage should your armor burning you should do.
	if (user.zone_selected == BODY_ZONE_CHEST)
		if (armor_can_heat && (!shirt_can_heat && shirt))
			damage_to_apply = damage_to_apply / 2 // Halve the damage if only armor can heat but shirt can't.
		if (targeteditem == shirt & armor_can_heat) //this looks redundant but it serves to make sure the damage is doubled if both shirt and armor are metallic.
			apply_damage_if_covered(target, list(BODY_ZONE_CHEST), armor, CHEST, damage_to_apply)
		else if (targeteditem == armor & shirt_can_heat)
			apply_damage_if_covered(target, list(BODY_ZONE_CHEST), shirt, CHEST, damage_to_apply)
	apply_damage_if_covered(target, list(BODY_ZONE_CHEST), targeteditem, CHEST, damage_to_apply)
	apply_damage_if_covered(target, list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), targeteditem, ARMS|HANDS, damage_to_apply)
	apply_damage_if_covered(target, list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), targeteditem, GROIN|LEGS|FEET, damage_to_apply)
	apply_damage_if_covered(target, list(BODY_ZONE_HEAD), targeteditem, HEAD|HAIR|NECK|NOSE|MOUTH|EARS|EYES, damage_to_apply)
	show_visible_message(target, "[target]'s [targeteditem.name] glows brightly, searing their flesh.", "My [targeteditem.name] glows brightly, It burns!")
	playsound(target.loc, 'sound/misc/frying.ogg', 100, FALSE, -1)

/proc/apply_damage_if_covered(mob/living/carbon/target, list/body_zones, obj/item/clothing/targeteditem, mask, damage)
	var/datum/effect_system/spark_spread/sparks = new()
	var/obj/item/bodypart/affecting = null
	for (var/zone in body_zones)
	{
		if (targeteditem.body_parts_covered & mask)
			affecting = target.get_bodypart(zone)
		if (affecting)
			affecting.receive_damage(0, damage)
			sparks.set_up(1, 1, target.loc)
			sparks.start()
	}

/////////////////////
// T2 - Hammerfall //
/////////////////////

/datum/action/cooldown/spell/malum/hammerfall
	name = "Hammerfall"
	desc = "Heave a conjured maul overhead, then bring it crashing down on the ground before you, leaving any struck stumbling.\n\n\
	Deals 50 brute damage and applies Immobilizes to everything in the smash. Against structures does triple damage."
	background_icon = 'icons/mob/actions/malummiracles.dmi'
	button_icon = 'icons/mob/actions/malummiracles.dmi'
	button_icon_state = "hammerfall"
	blade_class = BCLASS_BLUNT
	windup_time = TELEGRAPH_HIGH_IMPACT
	damage = 50
	structure_damage = 150
	sweep_step = 0
	impact_delay = 4
	detonate_sound = null
	immobilize_on_hit = 2 SECONDS
	var/hammer_scale = 1.9

	parent_type = /datum/action/cooldown/spell/telegraphed_strike
	sound = 'sound/magic/scrapeblade.ogg'
	glow_intensity = GLOW_INTENSITY_MEDIUM

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR + 20

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_MIRACLE//Dunno it's not properly inhereting for some reason.

	invocations = list("By molten might and hammer's weight, in Malum’s flame, the earth shall quake!")
	invocation_type = INVOCATION_SHOUT

	cooldown_time = 45 SECONDS
	charging_slowdown = 1

	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	associated_stat = null
	associated_skill = /datum/skill/magic/holy

	telegraph_type = /obj/effect/temp_visual/trap/hammerfall

/datum/action/cooldown/spell/malum/hammerfall/get_pattern_offsets()
	return list(
		list(-1, 1), list(0, 1), list(1, 1),
		list(-1, 2), list(0, 2), list(1, 2),
		list(-1, 3), list(0, 3), list(1, 3),
	)

/datum/action/cooldown/spell/malum/hammerfall/do_blade_animation(mob/living/carbon/human/H, facing)
	var/obj/effect/temp_visual/ferramancy_hammer/malum/hammer = new(null)
	hammer.vis_holder = H
	H.vis_contents += hammer
	var/rest_y = round(6.5 * hammer_scale - 4)
	var/fwd_x = 0
	var/fwd_y = 0
	switch(facing)
		if(NORTH)
			fwd_y = 32
		if(SOUTH)
			fwd_y = -32
		if(EAST)
			fwd_x = 32
		if(WEST)
			fwd_x = -32
	var/matrix/upright = matrix()
	upright.Scale(hammer_scale)
	upright.Turn(180)
	var/matrix/airborne = matrix()
	airborne.Scale(hammer_scale, hammer_scale * 1.4)
	airborne.Turn(180)
	hammer.transform = airborne
	hammer.pixel_x = fwd_x
	hammer.pixel_y = fwd_y + rest_y + 176
	hammer.alpha = 0
	animate(hammer, pixel_y = fwd_y + rest_y, transform = upright, time = impact_delay, easing = CUBIC_EASING | EASE_IN)
	animate(hammer, alpha = 255, time = 1, flags = ANIMATION_PARALLEL)
	return hammer

/datum/action/cooldown/spell/malum/hammerfall/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	var/turf/T = get_step(get_turf(H), facing) || get_turf(H)
	if(!T)
		return
	playsound(T, pick('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg'), 90, TRUE, 4)
	playsound(T, 'sound/magic/repulse.ogg', 55, TRUE, 3)
	for(var/mob/M in range(5, T))
		shake_camera(M, 2, 1)
	new /obj/effect/temp_visual/spell_impact(T, spell_color, SPELL_IMPACT_HIGH)
	if(QDELETED(visual))
		return
	var/rest = visual.pixel_y
	animate(visual, pixel_y = rest + 4, time = 1, easing = SINE_EASING | EASE_OUT)
	animate(pixel_y = rest, time = 1, easing = SINE_EASING | EASE_IN)
	animate(alpha = 0, time = 3)

/obj/effect/temp_visual/trap/hammerfall
	color = GLOW_COLOR_MALUM
	light_color = GLOW_COLOR_MALUM
	duration = 3 SECONDS

/obj/effect/temp_visual/ferramancy_hammer/malum
	icon = 'icons/mob/actions/malummiracles.dmi'
	icon_state = "hammer_of_malum"

/obj/effect/temp_visual/lavastaff
	icon_state = "lavastaff_warn"
	duration = 50

//////////////////
// T3 - Reforge //
//////////////////

/datum/action/cooldown/spell/malum/reforge
	name = "Reforge"
	desc = "Progressively repair all metal items on a target."
	button_icon_state = "repair"
	sound = null
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_NO_MOVE

/datum/action/cooldown/spell/malum/reforge/cast(atom/cast_on)
	. = ..()
	var/skill = owner.get_skill_level(/datum/skill/magic/holy)
	var/repair_points = 200 * skill
	var/one_fix_points = 50 + (skill * 10)
	for(var/obj/item/I)
		if(repair_points <= 0 || (repair_points - one_fix_points) <= 0)
			repair_points = 0
			return FALSE
		if(!I.smeltresult) //only metal items.
			continue
		if(I.smeltresult == /obj/item/ash && I.smeltresult == /obj/item/rogueore/coal) //not cloth and wood.
			continue
		if(I.max_integrity <= I.obj_integrity)
			continue
		if(!owner.Adjacent(cast_on))
			return TRUE
		if(!do_after(owner, 2 SECONDS))
			repair_points = 0
			return FALSE
		I.obj_integrity = min(I.obj_integrity + one_fix_points, I.max_integrity)
		I.visible_message(span_info("[I] glows in a faint mending light."))
		playsound(cast_on, 'sound/magic/magearmorup.ogg', 10)
		if(I.max_integrity <= I.obj_integrity)
			if(I.obj_broken) // obj_fix() strips armor ratings/class when called on intact armor; only call it on items that were actually broken.
				I.obj_fix()
			I.repair_coverage()
			I.visible_message(span_info("[I] mend together, completely."))
			playsound(cast_on, 'sound/magic/magearmorup.ogg', 50)
			continue
		cast(cast_on)
	return TRUE

///////////////////
// T4 - Fortress //
///////////////////

/datum/action/cooldown/spell/malum/fortress
	name = "Fortress"
	desc = "Channel an immense surge of arcyne energy to erect a 5x5 fortress of arrow wards around yourself. \
	Each wall segment blocks incoming projectiles from the outside while allowing you and allies to shoot out freely. \
	The fortress lasts until its cooldown expires or until the walls are destroyed."
	button_icon_state = "fortress"
	sound = 'sound/magic/whiteflame.ogg'
	glow_intensity = GLOW_INTENSITY_VERY_HIGH

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY

	secondary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("Sanctuary!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/malum/fortress/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(H)
	if(!center)
		return FALSE

	// 5x5 perimeter - outer ring at range 2 from caster
	var/list/perimeter_data = list() // list of list(turf, outward_dir)
	for(var/turf/T in range(2, center))
		var/dx = T.x - center.x
		var/dy = T.y - center.y
		if(abs(dx) != 2 && abs(dy) != 2)
			continue
		if(T.density)
			continue
		// Determine outward-facing direction based on which edge the tile is on
		var/outward_dir = 0
		if(abs(dx) == 2 && abs(dy) == 2)
			// Corners face diagonally outward
			outward_dir = get_dir(center, T)
		else if(abs(dx) == 2)
			// Left/right edges face east/west
			outward_dir = dx > 0 ? EAST : WEST
		else
			// Top/bottom edges face north/south
			outward_dir = dy > 0 ? NORTH : SOUTH
		perimeter_data += list(list(T, outward_dir))

	if(!length(perimeter_data))
		return FALSE

	H.visible_message(span_boldwarning("[H] channels a massive ward inscription - the air crackles with arcyne energy!"), span_notice("I erect the Arcyne Fortress!"))
	playsound(center, 'sound/magic/whiteflame.ogg', 80, TRUE, 5)

	for(var/list/entry in perimeter_data)
		var/turf/T = entry[1]
		var/outward_dir = entry[2]
		var/obj/structure/arrow_ward/malum/wall = new(T, H, cooldown_time)
		wall.set_shield_dir(outward_dir)

	return TRUE

/obj/structure/arrow_ward/malum
	icon_state = "malum_ward"
	max_integrity = 200
